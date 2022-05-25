# ABSTRACT: Widget layout using a simplified box model

unit module Terminal::Widgets::Layout;


#| Style information (either requested or computed) for a layout node/leaf
class Style {
    # NOTE: Since Style is immutable we can assume that once instantiated, if
    #       set-* is defined, then min-* and max-* must be as well; likewise,
    #       if min-* and max-* are both defined and the same, then set-* is
    #       defined and the same.

    has UInt $.set-w;
    has UInt $.set-h;
    has UInt $.min-w;
    has UInt $.min-h;
    has UInt $.max-w;
    has UInt $.max-h;
    has Bool $.minimize-w;
    has Bool $.minimize-h;

    submethod TWEAK() {
        $!min-w //= $!set-w;
        $!max-w //= $!set-w;
        $!min-h //= $!set-h;
        $!max-h //= $!set-h;
        $!set-w //= $!min-w if $!min-w.defined && $!max-w.defined && $!min-w == $!max-w;
        $!set-h //= $!min-h if $!min-h.defined && $!max-h.defined && $!min-h == $!max-h;

        # Prevent non-sensical styles
        fail "Cannot configure a style width with min ($!min-w) and max ($!max-w) swapped"
            if $!min-w.defined && $!max-w.defined && $!min-w > $!max-w;

        fail "Cannot configure a style height with min ($!min-h) and max ($!max-h) swapped"
            if $!min-h.defined && $!max-h.defined && $!min-h > $!max-h;

        fail "Cannot set a style width ($!set-w) that is not between min ($!min-w) and max ($!max-w)"
            if $!set-w.defined && $!min-w.defined && $!min-w > $!set-w
            || $!set-w.defined && $!max-w.defined && $!max-w < $!set-w;

        fail "Cannot set a style height ($!set-h) that is not between min ($!min-h) and max ($!max-h)"
            if $!set-h.defined && $!min-h.defined && $!min-h > $!set-h
            || $!set-h.defined && $!max-h.defined && $!max-h < $!set-h;
    }

    multi method gist(Style:D:) {
        'w:(' ~ ($.min-w, $.set-w, $.max-w).map({ $_ // '*'}).join(':')
         ~ (' min' if $.minimize-w) ~ ') ' ~
        'h:(' ~ ($.min-h, $.set-h, $.max-h).map({ $_ // '*'}).join(':')
         ~ (' min' if $.minimize-h) ~ ')'
    }

    multi method gist(Style:U:) {
        'Style:U'
    }
}


#| Role for dynamic layout nodes, tracking both requested and computed styles
role Dynamic {
    has Capture $.extra;
    has Style   $.requested;
    has Style   $.computed is rw;
    has Dynamic $.parent   is rw;
    has         $.widget   is rw;
    has UInt    $.x        is rw;
    has UInt    $.y        is rw;


    method compute-layout() { ... }
    method propagate-xy()   { ... }

    method update-requested(*%updates) {
        self.uncompute;
        $!requested = $!requested.clone(|%updates);
    }

    method uncompute() {
        $!computed = Nil;
    }

    method is-set() {
        $.computed && $.computed.set-w.defined && $.computed.set-h.defined
        && $.x.defined && $.y.defined
    }

    method initial-compute() {
        # Start with previously computed styles if available, or requested styles if not
        my $style = $.computed // $.requested;
        my $min-w = $style.min-w;
        my $set-w = $style.set-w;
        my $max-w = $style.max-w;
        my $min-h = $style.min-h;
        my $set-h = $style.set-h;
        my $max-h = $style.max-h;
        my $minimize-w = ?$style.minimize-w;
        my $minimize-h = ?$style.minimize-h;

        if $.parent {
            # Try to pull settings from parent
            my $pc = $.parent.computed;
            if $.parent.vertical {
                $min-w //= $pc.min-w;
                $set-w //= $pc.set-w;
                $max-w //= $pc.set-w // $pc.max-w;
            }
            else {
                $min-h //= $pc.min-h;
                $set-h //= $pc.set-h;
                $max-h //= $pc.set-h // $pc.max-h;
            }
        }
        else {
            # Try to set values directly
            $set-w //= $max-w // $min-w;
            $set-h //= $max-h // $min-h;
        }

        # Default minimums to 0
        $min-w //= 0;
        $min-h //= 0;

        ($min-w, $set-w, $max-w,
         $min-h, $set-h, $max-h,
         $minimize-w, $minimize-h)
    }
}


#| A leaf node in the layout tree (no possible children)
class Leaf does Dynamic {
    multi method gist(Leaf:U:) {
        self.^name ~ ':U'
    }

    multi method gist(Leaf:D:) {
        self.^name ~ '|' ~
        "requested: [$.requested.gist()] " ~
        "computed: [$.computed.gist()] " ~
        "x:{$.x // '*'} y:{$.y // '*' }"
    }

    method all-set(Leaf:D:) { self.is-set }

    multi method compute-layout(Leaf:D:) {
        # Do initial DWIM computations
        my ($min-w, $set-w, $max-w,
            $min-h, $set-h, $max-h,
            $minimize-w, $minimize-h) = self.initial-compute;

        # Assign final computed style
        $!computed = Style.new(:$min-w, :$set-w, :$max-w,
                               :$min-h, :$set-h, :$max-h,
                               :$minimize-w, :$minimize-h);
        # note "leaf: ", $.computed;

        self
    }

    method propagate-xy() { }
}


#| A general node in the layout tree (optional children, with tracking of
#| whether children are slotted vertically or horizontally)
class Node does Dynamic {
    has $.vertical;
    has @.children;

    submethod TWEAK() {
        .parent = self for @!children;
    }

    multi method gist(Node:U:) {
        self.^name ~ ':U'
    }

    multi method gist(Node:D:) {
        my @child-gists = @.children.map: *.gist.indent(4);
        self.^name ~ '|' ~
        "requested: [$.requested.gist()] " ~
        "computed: [$.computed.gist()] " ~
        "x:{$.x // '*'} y:{$.y // '*' }" ~
        (" :vertical" if $.vertical) ~
        ("\n" ~ @child-gists.join("\n") if @.children)
    }

    method uncompute() {
        self.Dynamic::uncompute;
        .uncompute for @.children;
    }

    method all-set(Node:D:) {
        self.is-set && all(@.children.map(*.all-set))
    }

    multi method compute-layout(Node:D:) {
        # Do initial DWIM computations
        my ($min-w, $set-w, $max-w,
            $min-h, $set-h, $max-h,
            $minimize-w, $minimize-h) = self.initial-compute;

        # Assign *partially* computed style to allow children to introspect this node
        $!computed = Style.new(:$min-w, :$set-w, :$max-w,
                               :$min-h, :$set-h, :$max-h,
                               :$minimize-w, :$minimize-h);
        # note "partial: ", $!computed;
        return unless @.children;

        # Compute all children based on partial info so far
        .compute-layout for @.children;

        # note "\n", self;

        # Incorporate already-known children's settings into current where possible
        my @child-style = @.children.map(*.computed);

        # Minimums: always useful, though calculation varies by orientation
        my @child-min-w = @child-style.map: { .min-w // 0 };
        my @child-min-h = @child-style.map: { .min-h // 0 };
        my $child-min-w = $.vertical ?? @child-min-w.max !! @child-min-w.sum;
        my $child-min-h = $.vertical ?? @child-min-h.sum !! @child-min-h.max;
        $min-w max= $child-min-w;
        $min-h max= $child-min-h;

        # Maximums: only useful if all non-minimized children have the value defined
        #           for a particular measure *and* that result is >= than the min
        my &child-max-w = $.vertical ?? {.max-w.defined || !.minimize-w} !! { True };
        my @child-max-w = @child-style.grep(&child-max-w).map(*.max-w);
        unless @child-max-w.grep(!*.defined) {
            my $child-max-w = $.vertical ?? @child-max-w.min !! @child-max-w.sum;
            $max-w min= $child-max-w if $child-max-w >= $child-min-w;
        }
        my &child-max-h = $.vertical ?? { True } !! {.max-h.defined || !.minimize-h};
        my @child-max-h = @child-style.grep(&child-max-h).map(*.max-h);
        unless @child-max-h.grep(!*.defined) {
            my $child-max-h = $.vertical ?? @child-max-h.sum !! @child-max-h.min;
            $max-h min= $child-max-h if $child-max-h >= $child-min-h;
        }

        # Check whether min/max are equal (and thus force set to be the same)
        # Note that minimums are always defined by this point (though may be 0)
        if $max-w.defined && $min-w == $max-w {
            fail "Width is set to $set-w, outside of min/max $min-w"
                if $set-w.defined && $set-w != $min-w;
            $set-w = $min-w;
        }
        if $max-h.defined && $min-h == $max-h {
            fail "Height is set to $set-h, outside of min/max $min-h"
                if $set-h.defined && $set-h != $min-h;
            $set-h = $min-h;
        }

        # Set values: subtract out and see what's left
        my @child-set-w = @child-style.map(*.set-w).grep(*.defined);
        my $child-set-w = $.vertical
                          ?? (@child-set-w ?? @child-set-w.max !! 0)
                          !!  @child-set-w.sum;

        if @.children == @child-set-w {
            fail "Set width in parent ($set-w) does not match width of children ($child-set-w)"
                if $set-w.defined && $set-w != $child-set-w;
            $set-w = $child-set-w;
        }
        elsif $set-w.defined {
            my $remain-w = $set-w - $child-set-w;
            # note "Distribute remaining width from set ($remain-w) (child: $child-set-w)";
            my @unset-w = @.children.grep(!*.computed.set-w.defined).sort(-*.computed.minimize-w);
            while @unset-w {
                fail "Negative remaining width to distribute" if $remain-w < 0;
                my $share  = floor $remain-w / @unset-w;
                my $node   = @unset-w.shift;
                $share  min= 0                    if $node.computed.minimize-w;
                $share  max= $node.computed.min-w if $node.computed.min-w.defined;
                $remain-w -= $share;

                $node.computed = $node.computed.clone(:set-w($share));
                $node.compute-layout;
            }
        }

        my @child-set-h = @.children.map(*.computed.set-h).grep(*.defined);
        my $child-set-h = $.vertical   ?? @child-set-h.sum !!
                          @child-set-h ?? @child-set-h.max !! 0;

        if @.children == @child-set-h {
            fail "Set height in parent ($set-h) does not match height of children ($child-set-h)"
                if $set-h.defined && $set-h != $child-set-h;
            $set-h = $child-set-h;
        }
        elsif $set-h.defined {
            my $remain-h = $set-h - $child-set-h;
            # note "Distribute remaining height from set ($remain-h) (child: $child-set-h)";
            my @unset-h = @.children.grep(!*.computed.set-h.defined).sort(-*.computed.minimize-h);
            while @unset-h {
                fail "Negative remaining height to distribute" if $remain-h < 0;
                my $share  = floor $remain-h / @unset-h;
                my $node   = @unset-h.shift;
                $share  min= 0                    if $node.computed.minimize-h;
                $share  max= $node.computed.min-h if $node.computed.min-h.defined;
                $remain-h -= $share;

                $node.computed = $node.computed.clone(:set-h($share));
                $node.compute-layout;
            }
        }

        # note "\nAbout to set:\n", self;
        # note "Expected new values:\n",
        #      (:$min-w, :$set-w, :$max-w,
        #       :$min-h, :$set-h, :$max-h,
        #       :$minimize-w, :$minimize-h);

        # Assign final computed style
        $!computed = Style.new(:$min-w, :$set-w, :$max-w,
                               :$min-h, :$set-h, :$max-h,
                               :$minimize-w, :$minimize-h);
        # note "node: ", $!computed;

        self
    }

    method propagate-xy() {
        # Stop propagating silently if current node has not been placed properly
        return unless $.x.defined && $.y.defined;

        if $.vertical {
            my $y = $.y;
            for @.children {
                .x = $.x;
                .y = $y;
                .propagate-xy;
                last without my $h = .computed.set-h;
                $y += $h;
            }
        }
        else {
            my $x = $.x;
            for @.children {
                .x = $x;
                .y = $.y;
                .propagate-xy;
                last without my $w = .computed.set-w;
                $x += $w;
            }
        }
    }
}

#| A visual divider (such as box-drawing lines) between layout nodes
class Divider is Leaf { }

#| A framing node
# class Frame   is Node { }

#| A widget node; localizes xy coordinate frame for children
#| (upper left of this widget becomes new 0,0 for children)
class Widget  is Node {
    method propagate-xy() {
        if $.vertical {
            my $y = 0;
            for @.children {
                .x = 0;
                .y = $y;
                .propagate-xy;
                last without my $h = .computed.set-h;
                $y += $h;
            }
        }
        else {
            my $x = 0;
            for @.children {
                .x = $x;
                .y = 0;
                .propagate-xy;
                last without my $w = .computed.set-w;
                $x += $w;
            }
        }
    }
}


#| Helper class for building style/layout trees
class Builder {
    # Leaf nodes (no children ever)
    method leaf(     :$extra = \(), *%style) {
        Leaf.new:    :$extra, requested => Style.new(|%style) }
    method divider(  :$extra = \(), *%style) {
        Divider.new: :$extra, requested => Style.new(|%style) }

    # Nodes with optional children
    method node(    *@children, :$vertical, :$extra = \(), *%style) {
        Node.new:   :@children, :$vertical, :$extra, requested => Style.new(|%style) }
    # method frame(   *@children, :$vertical, :$extra = \(), *%style) {
    #     Frame.new:  :@children, :$vertical, :$extra, requested => Style.new(|%style) }
    method widget(  *@children, :$vertical, :$extra = \(), *%style) {
        Widget.new: :@children, :$vertical, :$extra, requested => Style.new(|%style) }
}


#| Role for UI Widgets that are dynamically built using the above system
role WidgetBuilding {
    # Required methods
    method layout-model()               { ... }
    method build-node($node, $geometry) { ... }

    #| Compute the UI layout according to its constraints
    method compute-layout() {
        # Build a layout model (or reuse an existing one) for this Widget
        # XXXX: $.layout //= ?
        my $layout-root = $.layout // self.layout-model;

        # Ask the layout model to compute its own layout details and
        # propagate positioning to children
        $layout-root.compute-layout;
        $layout-root.x  = $.x;
        $layout-root.y  = $.y;
        $layout-root.propagate-xy;

        $layout-root
    }

    #| Build actual Widgets for the children of a given layout-node
    method build-children($layout-node, $parent) {
        # Only Layout::Node subclasses have children; a Layout::Leaf does not
        return unless $layout-node ~~ Node;

        for $layout-node.children {
            # Along with computed XYWH, also include child's parent Widget and
            # child's associated Layout::Dynamic object in the geometry info
            my $geometry = \(:$parent, :layout($_),
                             :x(.x), :y(.y),
                             :w(.computed.set-w),
                             :h(.computed.set-h));
            .widget = self.build-node($_, $geometry);

            # If build-node returned a defined widget, it's the new parent for
            # recursion; otherwise it's just an internal node or a non-Widget
            # and the current parent widget should still be used
            self.build-children($_, .widget // $parent);
        }
    }
}


# XXXX: Ideas for allowing resize/reorder/etc.
#
# * Each widget keeps a reference to its layout object, and vice versa
# * When triggering relayout, check top level; if :U, layout from scratch, otherwise update
# * When rebuilding, check widget ref; if :U, build it, otherwise update
# * When adding or removing layout node or widget, do the same to its dual
# * Encode layout constraints as closures that can be rerun for relayout
