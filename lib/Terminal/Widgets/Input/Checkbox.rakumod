# ABSTRACT: A single checkbox, optionally labeled

use Terminal::Widgets::Input::Boolean;
use Terminal::Widgets::Input::Labeled;


#| A single optionally labeled checkbox
class Terminal::Widgets::Input::Checkbox
 does Terminal::Widgets::Input::Boolean
 does Terminal::Widgets::Input::Labeled {
    #| Checkbox glyphs
    method checkbox-text() {
        my constant %boxes =
            ASCII => « '[ ]' [x] »,
            Uni1  => «   ☐    ☒  »,
            Uni7  => «   🞏    🞕  »;

        self.terminal.caps.best-symbol-choice(%boxes)[+$.state]
    }

    #| Refresh just the value, without changing anything else
    method refresh-value(Bool:D :$print = True) {
        my $layout = self.layout.computed;
        my $x      = $layout.left-correction;
        my $y      = $layout.top-correction;

        $.grid.set-span-text($x, $y, self.checkbox-text);
        self.composite(:$print);
    }

    #| Refresh the whole input
    method full-refresh(Bool:D :$print = True) {
        my $layout = self.layout.computed;
        my $x      = $layout.left-correction;
        my $y      = $layout.top-correction;
        my $text   = self.checkbox-text ~ (' ' ~ $.label if $.label);

        self.clear-frame;
        self.draw-framing;

        $.grid.set-span($x, $y, $text, self.current-color);
        self.composite(:$print);
    }
}
