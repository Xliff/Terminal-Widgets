# ABSTRACT: Single line text input

use Terminal::LineEditor::DuospaceInput;
use Terminal::LineEditor::RawTerminalInput;
use Text::MiscUtils::Layout;

use Terminal::Widgets::Utils;
use Terminal::Widgets::Events;
use Terminal::Widgets::Widget;


constant $dim-gray = gray-color(.2);

#| Multiplex all forms of user input, rooted at a control widget
class Terminal::Widgets::Input::Text
   is Terminal::Widgets::Widget
 does Terminal::LineEditor::HistoryTracking
 does Terminal::LineEditor::KeyMappable {
    has $.input-class = Terminal::LineEditor::ScrollingSingleLineInput::ANSI;
    has $.input-field;

    has &.process-entry;

    has Bool:D $.enabled is rw = False;
    has Bool:D $!literal-mode  = False;

    has Str:D  $.prompt-string = '>';
    has Str:D  $.text-color    = "white on_$dim-gray";
    has Str:D  $.prompt-color  = "bold $!text-color";

    has Str:D  $.disabled-string = '';
    has Str:D  $.disabled-color  = $!text-color;


    #| Set $!input-field, with both compile-time and runtime type checks
    method set-input-field(Terminal::LineEditor::ScrollingSingleLineInput:D $new-field) {
        die "New input-field is not a $.input-class"
            unless $new-field ~~ $.input-class;
        $!input-field = $new-field;
    }

    #| Set current prompt-string and (optionally) prompt-color
    method set-prompt(Str:D $!prompt-string, Str $prompt-color?) {
        $!prompt-color = $_ with $prompt-color;
        self.full-refresh
    }

    #| Completely refresh input, including possibly toggling enabled state
    method full-refresh(Str:D $content = '', Bool:D :$print = True) {
        if $.enabled {
            # Determine new field metrics
            my $field-start   = duospace-width($.prompt-string);
            my $display-width = $.w - $field-start;

            # Create a new input field using the new metrics
            # XXXX: Should we support masked inputs?
            self.set-input-field($.input-class.new(:$display-width, :$field-start));

            # Insert initial content if any and refresh input field
            self.do-edit('insert-string', $content, :force-refresh);
        }
        else {
            self.show-disabled(:$print);
        }
    }

    #| Display input disabled state
    method show-disabled(Bool:D :$print = True) {
        $.grid.clear;
        $.grid.set-span-text(0, 0, $.disabled-string);
        $.grid.set-span-color(0, $.w - 1, 0, $.disabled-color);
        self.composite(:$print);
    }

    #| Do edit in current input field, then print and flush the full refresh string
    method do-edit($action, $insert?, Bool:D :$force-refresh = False,
                   Bool:D :$print = True) {
        my $edited = $insert.defined ?? $.input-field.edit-insert-string($insert)
                                     !! $.input-field."edit-$action"();

        self.refresh-input-field($force-refresh || $edited);
        self.composite(:$print);
    }

    #| Refresh widget in input field mode
    method refresh-input-field(Bool:D $edited = True) {
        my $refresh = $.input-field.render(:$edited);
        my $start   = $.input-field.field-start;
        my $pos     = $start
                    + $.input-field.left-mark-width
                    + $.input-field.scroll-to-insert-width;

        $.grid.set-span(0,      0, $.prompt-string, $.prompt-color);
        $.grid.set-span($start, 0, $refresh, $.text-color);
        $.grid.set-span-color($pos, $pos, 0, 'inverse');
    }

    #| Dispatch a key event when enabled for editing
    multi method handle-event(Terminal::Widgets::Events::KeyboardEvent:D
                              $event where *.key.defined, AtTarget) {
        my $raw-key = $event.key;
        if $!literal-mode {
            my $string = $raw-key ~~ Str ?? $raw-key !! ~($raw-key.value);
            self.do-edit('insert-string', $string);
            $!literal-mode = False;
        }
        else {
            my $key = self.decode-keyname($raw-key);
            if !$key {
                self.do-edit('insert-string', $raw-key);
                # reset-completions;
            }
            orwith $key && %.keymap{$key} {
                # when 'complete'        { do-complete }
                # reset-completions;

                when 'literal-next'    { $!literal-mode = True }
                # XXXX: Disable history when in masked (password/secret) mode
                when 'history-start'   { self.do-history-start }
                when 'history-prev'    { self.do-history-prev  }
                when 'history-next'    { self.do-history-next  }
                when 'history-end'     { self.do-history-end   }

                # Suspends program when self.suspend is called, dropping back to shell.
                # When the user resumes, the code picks up at the end of self.suspend.
                when 'suspend'         { self.suspend;
                                         $.input-field.force-pos-to-start;
                                         self.do-edit('insert-string', ''); }

                # Core key bindings: finishing, aborting, generic edits
                when 'finish'          { self.finish-entry }
                when 'abort-input'     { self.abort-entry  }
                when 'abort-or-delete' { $.input-field.buffer.contents
                                         ?? self.do-edit('delete-char-forward')
                                         !! self.abort-entry }
                default                { self.do-edit($_) }
            }
        }
    }

    #| Abort entry in progress
    method abort-entry() {
        self.reset-entry-state;
    }

    #| Finish entry in progress
    method finish-entry() {
        my $input = $.input-field.buffer.contents.trim;
        self.reset-entry-state;

        if $input {
            self.add-history($input);
            $_($input) with &.process-entry;
        }
    }

    #| Clear entry state, clear input field, and refresh
    method reset-entry-state() {
        $!literal-mode = False;
        $.unfinished-entry = '';
        self.full-refresh;
    }

    # History helpers
    method do-history-start() {
        return unless @.history && $.history-cursor;

        $.unfinished-entry = $.input-field.buffer.contents
            if self.history-cursor-at-end;

        self.jump-to-history-start;
        self.full-refresh(self.history-entry);
    }

    method do-history-prev() {
        return unless @.history && $.history-cursor;

        $.unfinished-entry = $.input-field.buffer.contents
            if self.history-cursor-at-end;

        self.history-prev;
        self.full-refresh(self.history-entry);
    }

    method do-history-next() {
        return if self.history-cursor-at-end;

        self.history-next;
        self.full-refresh(self.history-entry);
    }

    method do-history-end() {
        return if self.history-cursor-at-end;

        self.jump-to-history-end;
        self.full-refresh(self.history-entry);
    }
}
