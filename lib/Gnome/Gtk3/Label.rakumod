#TL:1:Gnome::Gtk3::Label:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Label

A widget that displays a small to medium amount of text

![](images/label.png)

=head1 Description

The B<Gnome::Gtk3::Label> widget displays a small amount of text. As the name implies, most labels are used to label another widget such as a B<Gnome::Gtk3::Button>, a B<Gnome::Gtk3::MenuItem>, or a B<Gnome::Gtk3::ComboBox>.


=head2 Css Nodes

  label
  ├── [selection]
  ├── [link]
  ┊
  ╰── [link]

B<Gnome::Gtk3::Label> has a single CSS node with the name label. A wide variety of style classes may be applied to labels, such as .title, .subtitle, .dim-label, etc. In the B<Gnome::Gtk3::ShortcutsWindow>, labels are used with the .keycap style class.

If the label has a selection, it gets a subnode with name selection.

If the label has links, there is one subnode per link. These subnodes carry the link or visited state depending on whether they have been visited.

=head2 Gnome::Gtk3::Label as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::Label> implementation of the B<Gnome::Gtk3::Buildable> interface supports a custom <attributes> element, which supports any number of <attribute> elements. The <attribute> element has attributes named “name“, “value“, “start“ and “end“ and allows you to specify B<PangoAttribute> values for this label.

An example of a UI definition fragment specifying Pango attributes:

  <object class="GtkLabel">
    <attributes>
      <attribute name="weight" value="PANGO_WEIGHT_BOLD"/>
      <attribute name="background" value="red" start="5" end="10"/>"
    </attributes>
  </object>


The start and end attributes specify the range of characters to which the Pango attribute applies. If start and end are not specified, the attribute is applied to the whole text. Note that specifying ranges does not make much sense with translatable attributes. Use markup embedded in the translatable content instead.


=head2 Mnemonics

Labels may contain “mnemonics”. Mnemonics are underlined characters in the label, used for keyboard navigation. Mnemonics are created by providing a string with an underscore before the mnemonic character, such as `"_File"`, to the functions C<gtk_label_new_with_mnemonic()> or C<gtk_label_set_text_with_mnemonic()>.

Mnemonics automatically activate any activatable widget the label is inside, such as a B<Gnome::Gtk3::Button>; if the label is not inside the mnemonic’s target widget, you have to tell the label about the target using C<.new(:mnemonic())>. Here’s a simple example where the label is inside a button:

  # Pressing Alt+H will activate this button
  my Gnome::Gtk3::Button $b .= new;
  my Gnome::Gtk3::Label $l .= new(:mnemonic<_Hello>);
  $b.add($l);


There’s a convenience function to create buttons with a mnemonic label already inside:

  # Pressing Alt+H will activate this button
  my Gnome::Gtk3::Button $b .= new(:mnemonic<_Hello>);


To create a mnemonic for a widget alongside the label, such as a B<Gnome::Gtk3::Entry>, you have to point the label at the entry with C<set-mnemonic-widget()>:

  # Pressing Alt+H will focus the entry
  my Gnome::Gtk3::Entry $entry .= new;
  my Gnome::Gtk3::Label $label .= new(:mnemonic<_Hello>);
  $label.set-mnemonic-widget($entry);


=head2 Markup (styled text)

To make it easy to format text in a label (changing colors, fonts, etc.), label text can be provided in a simple [markup format][PangoMarkupFormat].

Here’s how to create a label with a small font:

  my Gnome::Gtk3::Label $label .= new;
  $label.set-markup("<small>Small text</small>");

See L<complete documentation|https://developer.gnome.org/pygtk/stable/pango-markup-language.html> of available tags in the Pango manual.

The markup passed to C<set-markup()> must be valid; for example, literal <, > and & characters must be escaped as &lt;, &gt;, and &amp;.
=comment If you pass text obtained from the user, file, or a network to C<set-markup()>, you’ll want to escape it with C<escape-text()> or C<g_markup_printf_escaped()>.

Markup strings are just a convenient way to set the B<PangoAttrList> on a label; C<set-attributes()> may be a simpler way to set attributes in some cases. Be careful though; B<PangoAttrList> tends to cause internationalization problems, unless you’re applying attributes to the entire string (i.e. unless you set the range of each attribute to [0, C<G_MAXINT>)). The reason is that specifying the start_index and end_index for a B<PangoAttribute> requires knowledge of the exact string being displayed, so translations will cause problems.

=head2 Selectable labels

Labels can be made selectable with C<gtk_label_set_selectable()>. Selectable labels allow the user to copy the label contents to the clipboard. Only labels that contain useful-to-copy information — such as error messages — should be made selectable.


=head2 Text layout

A label can contain any number of paragraphs, but will have performance problems if it contains more than a small number. Paragraphs are separated by newlines or other paragraph separators understood by Pango.

Labels can automatically wrap text if you call C<set-line-wrap()>.

C<set-justify()> sets how the lines in a label align with one another. If you want to set how the label as a whole aligns in its available space, see the  I<halign> and  I<valign> properties.

The  I<width-chars> and  I<max-width-chars> properties can be used to control the size allocation of ellipsized or wrapped labels. For ellipsizing labels, if either is specified (and less than the actual text size), it is used as the minimum width, and the actual text size is used as the natural width of the label. For wrapping labels, width-chars is used as the minimum width, if specified, and max-width-chars is used as the natural width. Even if max-width-chars specified, wrapping labels will be rewrapped to use all of the available width.

Note that the interpretation of  I<width-chars> and  I<max-width-chars> has changed a bit with the introduction of width-for-height geometry management.


=head2 Links

Since 2.18, GTK+ supports markup for clickable hyperlinks in addition to regular Pango markup. The markup for links is borrowed from HTML, using the `<a>` with “href“ and “title“ attributes. GTK+ renders links similar to the way they appear in web browsers, with colored, underlined text. The “title“ attribute is displayed as a tooltip on the link.

An example looks like this:

  my Str $text = [+] "Go to the",
    "<a href=\"http://www.gtk.org title="&lt;i&gt;Our&lt;/i&gt; website\">",
    "GTK+ website</a> for more...";
  my Gnome::Gtk3::Label $l .= new;
  $l.set-markup($text);

It is possible to implement custom handling for links and their tooltips with the  I<activate-link> signal and the C<gtk_label_get_current_uri()> function.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Label;
  also is Gnome::Gtk3::Misc;


=head2 Uml Diagram

![](plantuml/Label.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Label;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Label;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Label class process the options
    self.bless( :GtkLabel, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::Gtk3::Misc;
use Gnome::Gtk3::Enums;

#use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtklabel.h
# https://developer.gnome.org/gtk3/stable/GtkLabel.html
unit class Gnome::Gtk3::Label:auth<github:MARTIMM>:ver<0.2.1>;
also is Gnome::Gtk3::Misc;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :text

Creates a new label with the given text inside it. You can pass an undefined string to get an empty label widget.

  multi method new ( Str :$text! )

=head3 :mnemonic

Create a new object with mnemonic.

If characters in a string are preceded by an underscore, they are underlined. If you need a literal underscore character in a label, use '__' (two underscores). The first underlined character represents a keyboard accelerator called a mnemonic. The mnemonic key can be used to activate another widget, chosen automatically, or explicitly using C<set-mnemonic-widget()>.

If C<set-mnemonic-widget()> is not called, then the first activatable ancestor of the B<Gnome::Gtk3::Label> will be chosen as the mnemonic widget. For instance, if the label is inside a button or menu item, the button or menu item will automatically become the mnemonic widget and be activated by the mnemonic.

  multi method new ( Str :$mnemonic! )

=head3 :native-object

Create an object using a native object from elsewhere. See also B<Gnome::N::TopLevelSupportClass>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:inheriting
#TM:1:new(:text):
#TM:1:new(:mnemonic):
#TM:1:new(:native-object):
#TM:1:new(:build-id):
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w3<move-cursor>, :w0<copy-clipboard activate-current-link>,
    :w1<populate-popup activate-link>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Label' or %options<GtkLabel> {

    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;

      if %options<text>:exists {
        $no = _gtk_label_new(%options<text> // Str);
      }

      elsif %options<mnemonic>.defined {
        $no = _gtk_label_new_with_mnemonic(%options<mnemonic>);
      }

      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }

      self._set-native-object($no);
    }
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkLabel');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;

  try { $s = &::("gtk_label_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkLabel') if ?$s;
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:2:get-angle:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-angle

Gets the angle of rotation for the label. See C<set-angle()>.

Returns: the angle of rotation for the label

  method get-angle ( --> Num )

=end pod

method get-angle ( --> Num ) {
  gtk_label_get_angle( self._f('GtkLabel'))
}

sub gtk_label_get_angle ( N-GObject $label --> gdouble )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_attributes:
=begin pod
=head2 [[gtk_] label_] get_attributes

Gets the attribute list that was set on the label using
C<gtk_label_set_attributes()>, if any. This function does
not reflect attributes that come from the labels markup
(see C<gtk_label_set_markup()>). If you want to get the
effective attributes for the label, use
pango_layout_get_attribute (gtk_label_get_layout (label)).

Returns: (nullable) (transfer none): the attribute list, or C<Any>
if none was set.

  method gtk_label_get_attributes ( --> PangoAttrList  )


=end pod

sub gtk_label_get_attributes ( N-GObject $label --> PangoAttrList )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:2:get-current-uri:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-current-uri

Returns the URI for the currently active link in the label. The active link is the one under the mouse pointer or, in a selectable label, the link in which the text cursor is currently positioned.

This function is intended for use in a  I<activate-link> handler or for use in a  I<query-tooltip> handler.

Returns: the currently active URI. The string is owned by GTK+ and must not be freed or modified.

  method get-current-uri ( --> Str )

=end pod

method get-current-uri ( --> Str ) {
  gtk_label_get_current_uri( self._f('GtkLabel'))
}

sub gtk_label_get_current_uri ( N-GObject $label --> Str )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_ellipsize:
=begin pod
=head2 [[gtk_] label_] get_ellipsize

Returns the ellipsizing position of the label. See C<gtk_label_set_ellipsize()>.

Returns: B<PangoEllipsizeMode>

  method gtk_label_get_ellipsize ( --> PangoEllipsizeMode  )


=end pod

sub gtk_label_get_ellipsize ( N-GObject $label --> PangoEllipsizeMode )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_layout:
=begin pod
=head2 get-layout

Gets the B<PangoLayout> used to display the label. The layout is useful to e.g. convert text positions to pixel positions, in combination with C<gtk_label_get_layout_offsets()>. The returned layout is owned by the I<label> so need not be freed by the caller. The I<label> is free to recreate its layout at any time, so it should be considered read-only.

Returns: the B<PangoLayout> for this label

  method gtk_label_get_layout ( --> PangoLayout )


=end pod

sub gtk_label_get_layout ( N-GObject $label --> PangoLayout )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-layout-offsets:
=begin pod
=head2 get-layout-offsets

Obtains the coordinates where the label will draw the B<PangoLayout> representing the text in the label; useful to convert mouse events into coordinates inside the B<PangoLayout>, e.g. to take some action if some part of the label is clicked. Of course you will need to create a B<Gnome::Gtk3::EventBox> to receive the events, and pack the label inside it, since labels are windowless (they return C<0> from C<gtk_widget_get_has_window()>). Remember when using the B<PangoLayout> functions you need to convert to and from pixels using C<PANGO_PIXELS()> or B<PANGO_SCALE>.

  method get-layout-offsets ( --> List )

Returns a List with
=item Int $x; location to store X offset of layout, or C<Any>
=item Int $y; location to store Y offset of layout, or C<Any>

=end pod

method get-justify ( --> List ) {
  my gint $x;
  my gint $y;
  gtk_label_get_layout_offsets( self._f('GtkLabel'), $x, $y)

  ( $x, $y)
}

sub gtk_label_get_layout_offsets (
  N-GObject $label, int32 $x is rw, int32 $y is rw
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:2:get-justify:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-justify

Returns the justification of the label. See C<set-justify()>.

  method get-justify ( --> GtkJustification )

=end pod

method get-justify ( --> GtkJustification ) {
  GtkJustification(gtk_label_get_justify( self._f('GtkLabel')))
}

sub gtk_label_get_justify ( N-GObject $label --> GEnum )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-label:
=begin pod
=head2 get-label

Fetches the text from a label widget including any embedded underlines indicating mnemonics and Pango markup. (See C<get-text()>).

Returns: the text of the label widget. This string is owned by the widget and must not be modified or freed.

  method get-label ( --> Str )

=end pod

method get-label ( --> Str ) {
  gtk_label_get_label( self._f('GtkLabel'))
}

sub gtk_label_get_label ( N-GObject $label --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-lines:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-lines

Gets the number of lines to which an ellipsized, wrapping label should be limited. See C<set-lines()>.

Returns: The number of lines

  method get-lines ( --> Int  )

=end pod

method get-lines ( --> Int ) {
  gtk_label_get_lines( self._f('GtkLabel'))
}

sub gtk_label_get_lines ( N-GObject $label --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-line-wrap:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-line-wrap

Returns whether lines in the label are automatically wrapped. See C<gtk_label_set_line_wrap()>.

Returns: C<True> if the lines of the label are automatically wrapped.

  method get-line-wrap ( --> Bool )

=end pod

method get-line-wrap ( --> Bool ) {
  gtk_label_get_line_wrap( self._f('GtkLabel')).Bool
}

sub gtk_label_get_line_wrap ( N-GObject $label --> gboolean )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-line-wrap-mode:
=begin pod
=head2 get-line-wrap-mode

Returns line wrap mode used by the label. See C<gtk_label_set_line_wrap_mode()>.

Returns: C<1> if the lines of the label are automatically wrapped.

  method get-line-wrap-mode ( --> PangoWrapMode )

=end pod

method get-line-wrap-mode ( --> PangoWrapMode ) {
  gtk_label_get_line_wrap_mode( self._f('GtkLabel'))
}

sub gtk_label_get_line_wrap_mode ( N-GObject $label --> PangoWrapMode )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:2:get-max-width-chars:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-max-width-chars

Retrieves the desired maximum width of this label, in characters. See C<set-width-chars()>.

Returns: the maximum width of the label in characters.

  method get-max-width-chars ( --> Int )

=end pod

method get-max-width-chars ( --> Int ) {
  gtk_label_get_max_width_chars( self._f('GtkLabel'))
}

sub gtk_label_get_max_width_chars ( N-GObject $label --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-mnemonic-keyval:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-mnemonic-keyval

If the label has been set so that it has an mnemonic key this function returns the keyval used for the mnemonic accelerator. If there is no mnemonic set up it returns B<GDK_KEY_VoidSymbol>.

Returns: GDK keyval usable for accelerators, or B<GDK_KEY_VoidSymbol>

  method get-mnemonic-keyval ( --> UInt  )

=end pod

method get-mnemonic-keyval ( --> UInt ) {
  gtk_label_get_mnemonic_keyval( self._f('GtkLabel'))
}

sub gtk_label_get_mnemonic_keyval ( N-GObject $label --> guint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-mnemonic-widget:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-mnemonic-widget

Retrieves the target of the mnemonic (keyboard shortcut) of this label. See C<set-mnemonic-widget()>.

Returns: the target of the label’s mnemonic, or undefined if none has been set and the default algorithm will be used.

  method get-mnemonic-widget ( --> N-GObject )

=end pod

method get-mnemonic-widget ( --> N-GObject ) {
  gtk_label_get_mnemonic_widget( self._f('GtkLabel'))
}

sub gtk_label_get_mnemonic_widget ( N-GObject $label --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-selectable:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-selectable

Gets the value set by C<set-selectable()>.

Returns: C<True> if the user can copy text from the label

  method get-selectable ( --> Bool )

=end pod

method get-selectable ( --> Bool ) {
  gtk_label_get_selectable( self._f('GtkLabel')).Bool
}

sub gtk_label_get_selectable ( N-GObject $label --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-selection-bounds:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-selection-bounds

Gets the selected range of characters in the label, returning C<True> if there’s a selection.

  method gtk_label_get_selection_bounds ( --> List )

This method returns a list of which
=item Bool $non-empty: C<True> if selection is non-empty
=item Int $start; start of selection, as a character offset
=item Int $end; end of selection, as a character offset

=end pod

method get-selection-bounds ( --> List ) {
  my gint $start;
  my gint $end;
  my Bool $non-empty = _gtk_label_get_selection_bounds(
    self._f('GtkLabel'), $start, $end
  ).Bool;

  ( $non-empty, $start, $end)
}

sub gtk_label_get_selection_bounds ( N-GObject $label --> List ) {
  my gint $start;
  my gint $end;
  my Bool $non-empty = _gtk_label_get_selection_bounds(
    $label, $start, $end
  ).Bool;

  ( $non-empty, $start, $end)
}

sub _gtk_label_get_selection_bounds (
  N-GObject $label, gint $start is rw, gint $end is rw --> gboolean
) is native(&gtk-lib)
  is symbol('gtk_label_get_selection_bounds')
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-single-line-mode:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-single-line-mode

Returns whether the label is in single line mode.

Returns: C<True> when the label is in single line mode.

  method get-single-line-mode ( --> Bool )

=end pod

method get-single-line-mode ( --> Bool ) {
  gtk_label_get_single_line_mode( self._f('GtkLabel')).Bool
}

sub gtk_label_get_single_line_mode ( N-GObject $label --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-text:
=begin pod
=head2 get-text

Fetches the text from a label widget, as displayed on the screen. This does not include any embedded underlines indicating mnemonics or Pango markup. (See C<gtk_label_get_label()>)

Returns: the text in the label widget. This is the internal string used by the label, and must not be modified.

  method get-text ( --> Str )


=end pod

method get-text ( --> Str ) {
  gtk_label_get_text(self._f('GtkLabel'))
}

sub gtk_label_get_text ( N-GObject $label --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-track-visited-links:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-track-visited-links

Returns whether the label is currently keeping track of clicked links.

Returns: C<True> if clicked links are remembered

  method get-track-visited-links ( --> Bool )

=end pod

method get-track-visited-links ( --> Bool ) {
  gtk_label_get_track_visited_links( self._f('GtkLabel')).Bool
}

sub gtk_label_get_track_visited_links ( N-GObject $label --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-use-markup:
=begin pod
=head2 get-use-markup

Returns whether the label’s text is interpreted as marked up with the Pango text markup language. See C<set-use-markup()>.

Returns: C<True> if the label’s text will be parsed for markup.

  method get-use-markup ( --> Bool )

=end pod

method get-use-markup ( --> Bool ) {
  gtk_label_get_use_markup( self._f('GtkLabel')).Bool
}

sub gtk_label_get_use_markup ( N-GObject $label --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-use-underline:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-use-underline

Returns whether an embedded underline in the label indicates a mnemonic. See C<set-use-underline()>.

Returns: C<True> whether an embedded underline in the label indicates the mnemonic accelerator keys.

  method get-use-underline ( --> Bool )

=end pod

method get-use-underline ( --> Bool ) {
  gtk_label_get_use_underline( self._f('GtkLabel')).Bool
}

sub gtk_label_get_use_underline ( N-GObject $label --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-width-chars:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-width-chars

Retrieves the desired width of I<label>, in characters. See C<set-width-chars()>.

Returns: the width of the label in characters.

  method get-width-chars ( --> Int )

=end pod

method get-width-chars ( --> Int ) {
  gtk_label_get_width_chars( self._f('GtkLabel'))
}

sub gtk_label_get_width_chars ( N-GObject $label --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-xalign:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-xalign

Gets the  I<xalign> property for I<label>.

Returns: the xalign property

  method get-xalign ( --> Num  )

=end pod

method get-xalign ( --> Num ) {
  gtk_label_get_xalign( self._f('GtkLabel'))
}

sub gtk_label_get_xalign ( N-GObject $label --> gfloat )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-yalign:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 get-yalign

Gets the  I<yalign> property for I<label>.

Returns: the yalign property

  method get-yalign ( --> Num  )

=end pod

method get-yalign ( --> Num ) {
  gtk_label_get_yalign( self._f('GtkLabel'))
}

sub gtk_label_get_yalign ( N-GObject $label --> gfloat )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:select-region:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 select-region

Selects a range of characters in the label, if the label is selectable. See C<set-selectable()>. If the label is not selectable, this function has no effect. If I<$start_offset> or I<$end_offset> are -1, then the end of the label will be substituted.

  method select-region ( Int $start_offset, Int $end_offset )

=item Int $start_offset; start offset (in characters not bytes)
=item Int $end_offset; end offset (in characters not bytes)

=end pod

method select-region ( Int $start, Int $end ) {
  gtk_label_select_region( self._f('GtkLabel'), $start, $end)
}

sub gtk_label_select_region (
  N-GObject $label, gint $start_offset, gint $end_offset
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_label_set_angle:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-angle

Sets the angle of rotation for the label. An angle of 90 reads from bottom to top, an angle of 270, from top to bottom. The angle setting for the label is ignored if the label is selectable, wrapped, or ellipsized.

  method set-angle ( Num $angle )

=item Num $angle; the angle that the baseline of the label makes with the horizontal, in degrees, measured counterclockwise

=end pod

method set-angle ( $angle ) {
  gtk_label_set_angle( self._f('GtkLabel'), $angle.Num)
}

sub gtk_label_set_angle ( N-GObject $label, gdouble $angle )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_attributes:
=begin pod
=head2 [[gtk_] label_] set_attributes

Sets a B<PangoAttrList>; the attributes in the list are applied to the
label text.

The attributes set with this function will be applied
and merged with any other attributes previously effected by way
of the  I<use-underline> or  I<use-markup> properties.
While it is not recommended to mix markup strings with manually set
attributes, if you must; know that the attributes will be applied
to the label after the markup string is parsed.

  method gtk_label_set_attributes ( PangoAttrList $attrs )

=item PangoAttrList $attrs; (allow-none): a B<PangoAttrList>, or C<Any>

=end pod

sub gtk_label_set_attributes ( N-GObject $label, PangoAttrList $attrs )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_ellipsize:
=begin pod
=head2 [[gtk_] label_] set_ellipsize

Sets the mode used to ellipsize (add an ellipsis: "...") to the text
if there is not enough space to render the entire string.

  method gtk_label_set_ellipsize ( PangoEllipsizeMode $mode )

=item PangoEllipsizeMode $mode; a B<PangoEllipsizeMode>

=end pod

sub gtk_label_set_ellipsize ( N-GObject $label, PangoEllipsizeMode $mode )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:2:set-justify:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-justify

Sets the alignment of the lines in the text of the label relative to each other. C<GTK_JUSTIFY_LEFT> is the default value when the widget is first created with C<gtk_label_new()>. If you instead want to set the alignment of the label as a whole, use C<gtk_widget_set_halign()> instead. C<gtk_label_set_justify()> has no effect on labels containing only a single line.

  method set-justify ( GtkJustification $jtype )

=item GtkJustification $jtype; a C<GtkJustification> enum type

=end pod

method set-justify ( GtkJustification $jtype ) {
  gtk_label_set_justify( self._f('GtkLabel'), $jtype)
}

sub gtk_label_set_justify ( N-GObject $label, GEnum $jtype )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-label:
=begin pod
=head2 set-label

Sets the text of the label. The label is interpreted as including embedded underlines and/or Pango markup depending on the values of the  I<use-underline> and I<use-markup> properties.

  method set-label ( Str $str )

=item Str $str; the new text to set for the label

=end pod

method set-label ( Str $str ) {
  gtk_label_set_label( self._f('GtkLabel'), $str)
}

sub gtk_label_set_label ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-lines:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-lines

Sets the number of lines to which an ellipsized, wrapping label should be limited. This has no effect if the label is not wrapping or ellipsized. Set this to -1 if you don’t want to limit the number of lines.

  method set-lines ( Int $lines )

=item Int $lines; the desired number of lines, or -1

=end pod

method set-lines ( Int $lines ) {
  gtk_label_set_lines( self._f('GtkLabel'), $lines)
}

sub gtk_label_set_lines ( N-GObject $label, gint $lines )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-line-wrap:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-line-wrap

Toggles line wrapping within the B<Gnome::Gtk3::Label> widget. C<True> makes it break lines if text exceeds the widget’s size. C<False> lets the text get cut off by the edge of the widget if it exceeds the widget size.

Note that setting line wrapping to C<True> does not make the label wrap at its parent container’s width, because GTK+ widgets conceptually can’t make their requisition depend on the parent container’s size. For a label that wraps at a specific position, set the label’s width using C<set-size-request()>.

  method set-line-wrap ( Int $wrap )

=item Int $wrap; the setting

=end pod

method set-line-wrap ( Bool $wrap ) {
  gtk_label_set_line_wrap( self._f('GtkLabel'), $wrap.Int)
}

sub gtk_label_set_line_wrap ( N-GObject $label, gboolean $wrap )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-line-wrap-mode:
=begin pod
=head2 set-line-wrap-mode

If line wrapping is on (see C<gtk_label_set_line_wrap()>) this controls how
the line wrapping is done. The default is C<PANGO_WRAP_WORD> which means
wrap on word boundaries.

  method set-line-wrap-mode ( PangoWrapMode $wrap_mode )

=item PangoWrapMode $wrap_mode; the line wrapping mode

=end pod

method set-line-wrap-mode ( PangoWrapMode $wrap_mode ) {
  gtk_label_set_line_wrap_mode( self._f('GtkLabel'), $wrap_mode)
}

sub gtk_label_set_line_wrap_mode ( N-GObject $label, PangoWrapMode $wrap_mode )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:set-markup:
=begin pod
=head2 set-markup

Parses I<$str> which is marked up with the Pango text markup language, setting the label’s text and attribute list based on the parse results.

=begin comment
If the I<$str> is external data, you may need to escape it with C<g_markup_escape_text()> or C<g_markup_printf_escaped()>:

  my Gnome::Glib::Markup .= new(...)
  my Str $format = "<span style=\"italic\">\C<s></span>";
  my Str $markup =


const char *format = "<span style=\"italic\">\C<s></span>";
char *markup;

markup = g_markup_printf_escaped (format, str);
gtk_label_set_markup (GTK_LABEL (label), markup);
g_free (markup);
]|
=end comment

This function will set the  I<use-markup> property to C<1> as a side effect.

If you set the label contents using the  I<label> property you should also ensure that you set the  I<use-markup> property accordingly.

See also: C<set-text()>.

  method set-markup ( Str $str )

=item Str $str; a markup string. See also L<Pango markup format|https://developer.gnome.org/pygtk/stable/pango-markup-language.html>.

=end pod

method set-markup ( Str $str ) {
  gtk_label_set_markup( self._f('GtkLabel'), $str)
}

sub gtk_label_set_markup ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-markup-with-mnemonic:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-markup-with-mnemonic

Parses I<$str> which is marked up with the L<Pango text markup language|https://developer.gnome.org/pygtk/stable/pango-markup-language.html>,setting the label’s text and attribute list based on the parse results. If characters in I<str> are preceded by an underscore, they are underlined indicating that they represent a keyboard accelerator called a mnemonic.

The mnemonic key can be used to activate another widget, chosen automatically, or explicitly using C<set-mnemonic-widget()>.

  method set-markup-with-mnemonic ( Str $str )

=item Str $str; a markup string (see [Pango markup format][PangoMarkupFormat])

=end pod

method set-markup-with-mnemonic ( Str $str ) {
  gtk_label_set_markup_with_mnemonic( self._f('GtkLabel'), $str)
}

sub gtk_label_set_markup_with_mnemonic ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-max-width-chars:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-max-width-chars

Sets the desired maximum width in characters of this label to I<n_chars>.

  method set-max-width-chars ( Int $n_chars )

=item Int $n_chars; the new desired maximum width, in characters.

=end pod

method set-max-width-chars ( Int $n_chars ) {
  gtk_label_set_max_width_chars( self._f('GtkLabel'), $n_chars)
}

sub gtk_label_set_max_width_chars ( N-GObject $label, gint $n_chars )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-mnemonic-widget:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-mnemonic-widget

If the label has been set so that it has an mnemonic key (using e.g. C<set-markup-with-mnemonic()>, C<set-text-with-mnemonic()>, C<new(:mnemonic)> or the “use_underline” property) the label can be associated with a widget that is the target of the mnemonic. When the label is inside a widget (like a B<Gnome::Gtk3::Button> or a B<Gnome::Gtk3::Notebook> tab) it is automatically associated with the correct widget, but sometimes (e.g. when the target is a B<Gnome::Gtk3::Entry> next to the label) you need to set it explicitly using this function.

The target widget will be accelerated by emitting the B<Gnome::Gtk3::Widget>::mnemonic-activate signal on it. The default handler for this signal will activate the widget if there are no mnemonic collisions and toggle focus between the colliding widgets otherwise.

  method set-mnemonic-widget ( N-GObject $widget )

=item N-GObject $widget; the target B<Gnome::Gtk3::Widget> or undefined

=end pod

method set-mnemonic-widget ( $widget ) {
  my $no = $widget;
  $no .= _get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_label_set_mnemonic_widget( self._f('GtkLabel'), $no)
}

sub gtk_label_set_mnemonic_widget ( N-GObject $label, N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-pattern:xt/Benchmarking/Modules/Label.raku
#TODO set-pattern() does not seem to set pattern property

=begin pod
=head2 set-pattern

The pattern of underlines you want under the existing text within the B<Gnome::Gtk3::Label> widget. For example if the current text of the label says “FooBarBaz” passing a pattern of “___   ___” will underline “Foo” and “Baz” but not “Bar”.

  method set-pattern ( Str $pattern )

=item Str $pattern; The pattern as described above.

=end pod

method set-pattern ( Str $pattern ) {
  gtk_label_set_pattern( self._f('GtkLabel'), $pattern)
}

sub gtk_label_set_pattern ( N-GObject $label, Str $pattern )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-selectable:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-selectable

Selectable labels allow the user to select text from the label, for copy-and-paste.

  method set-selectable ( Bool $setting )

=item Int $setting; C<True> to allow selecting text in the label

=end pod

method set-selectable ( Bool $setting ) {
  gtk_label_set_selectable( self._f('GtkLabel'), $setting.Int)
}

sub gtk_label_set_selectable ( N-GObject $label, gboolean $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-single-line-mode:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-single-line-mode

Sets whether the label is in single line mode.

  method set-single-line-mode ( Bool $single_line_mode )

=item Int $single_line_mode; C<True> if the label should be in single line mode

=end pod

method set-single-line-mode ( Bool $single_line_mode ) {
  gtk_label_set_single_line_mode( self._f('GtkLabel'), $single_line_mode)
}

sub gtk_label_set_single_line_mode (
  N-GObject $label, gboolean $single_line_mode
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-text:
=begin pod
=head2 set-text

Sets the text within the B<Gnome::Gtk3::Label> widget. It overwrites any text that was there before.

This function will clear any previously set mnemonic accelerators, and set the  I<use-underline> property to C<0> as a side effect. The function will also set the I<use-markup> property to C<0> as a side effect.

See also: C<set-markup()>

  method set-text ( Str $str )

=item Str $str; The text you want to set

=end pod

method set-text ( Str $str ) {
  gtk_label_set_text( self._f('GtkLabel'), $str);
}

sub gtk_label_set_text ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-text-with-mnemonic:
=begin pod
=head2 set-text-with-mnemonic

Sets the label’s text from the string I<$str>. If characters in I<$str> are preceded by an underscore, they are underlined indicating that they represent a keyboard accelerator called a mnemonic. The mnemonic key can be used to activate another widget, chosen automatically, or explicitly using C<set-mnemonic-widget()>.

  method set-text-with-mnemonic ( Str $str )

=item Str $str; a string

=end pod

method set-text-with-mnemonic ( Str $str ) {
  gtk_label_set_text_with_mnemonic( self._f('GtkLabel'), $str)
}

sub gtk_label_set_text_with_mnemonic ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-track-visited-links:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-track-visited-links

Sets whether the label should keep track of clicked links (and use a different color for them).

  method set-track-visited-links ( Bool $track_links )

=item Bool $track_links; C<True> to track visited links

=end pod

method set-track-visited-links ( Bool $track_links ) {
  gtk_label_set_track_visited_links( self._f('GtkLabel'), $track_links)
}

sub gtk_label_set_track_visited_links (
  N-GObject $label, gboolean $track_links
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-use-markup:
=begin pod
=head2 set-use-markup

Sets whether the text of the label contains markup in L<Pango’s text markup language|https://developer.gnome.org/pygtk/stable/pango-markup-language.html>.

See C<set-markup()>.

  method set-use-markup ( Bool $setting )

=item Bool $setting; C<True> if the label’s text should be parsed for markup.

=end pod

method set-use-markup ( Bool $setting ) {
  gtk_label_set_use_markup( self._f('GtkLabel'), $setting.Int)
}

sub gtk_label_set_use_markup ( N-GObject $label, gboolean $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-use-underline:
=begin pod
=head2 set-use-underline

If C<True>, an underline in the text indicates the next character should be used for the mnemonic accelerator key.

  method set-use-underline ( Bool $setting )

=item Bool $setting; C<True> if underlines in the text indicate mnemonics

=end pod

method set-use-underline ( Bool $setting ) {
  gtk_label_set_use_underline( self._f('GtkLabel'), $setting)
}

sub gtk_label_set_use_underline ( N-GObject $label, gboolean $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-width-chars:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-width-chars

Sets the desired width in characters of this label to I<$n_chars>.

  method set-width-chars ( Int $n_chars )

=item Int $n_chars; the new desired width, in characters.

=end pod

method set-width-chars ( Int $n_chars ) {
  gtk_label_set_width_chars( self._f('GtkLabel'), $n_chars)
}

sub gtk_label_set_width_chars ( N-GObject $label, gint $n_chars )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-xalign:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-xalign

Sets the I<xalign> property for I<label>.

  method set-xalign ( Num $xalign )

=item Num $xalign; the new xalign value, between 0 and 1

=end pod

method set-xalign ( $xalign ) {
  gtk_label_set_xalign( self._f('GtkLabel'), $xalign.Num)
}

sub gtk_label_set_xalign ( N-GObject $label, gfloat $xalign )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set-yalign:xt/Benchmarking/Modules/Label.raku
=begin pod
=head2 set-yalign

Sets the I<yalign> property for I<label>.

  method set-yalign ( Num $yalign )

=item Num $yalign; the new yalign value, between 0 and 1

=end pod

method set-yalign ( $yalign ) {
  gtk_label_set_yalign( self._f('GtkLabel'), $yalign.Num)
}

sub gtk_label_set_yalign ( N-GObject $label, gfloat $yalign )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_label_new:new(:text)
#`{{
=begin pod
=head2 [gtk_] label_new

Creates a new label with the given text inside it. You can
pass C<Any> to get an empty label widget.

Returns: the new B<Gnome::Gtk3::Label>

  method gtk_label_new ( Str $str --> N-GObject  )

=item Str $str; (allow-none): The text of the label

=end pod
}}

sub _gtk_label_new ( Str $str --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_label_new')
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_label_new_with_mnemonic:new(:mnemonic)
#`{{
=begin pod
=head2 [[gtk_] label_] new_with_mnemonic

Creates a new B<Gnome::Gtk3::Label>, containing the text in I<str>.

If characters in I<str> are preceded by an underscore, they are
underlined. If you need a literal underscore character in a label, use
'__' (two underscores). The first underlined character represents a
keyboard accelerator called a mnemonic. The mnemonic key can be used
to activate another widget, chosen automatically, or explicitly using
C<gtk_label_set_mnemonic_widget()>.

If C<gtk_label_set_mnemonic_widget()> is not called, then the first
activatable ancestor of the B<Gnome::Gtk3::Label> will be chosen as the mnemonic
widget. For instance, if the label is inside a button or menu item,
the button or menu item will automatically become the mnemonic widget
and be activated by the mnemonic.

Returns: the new B<Gnome::Gtk3::Label>

  method gtk_label_new_with_mnemonic ( Str $str --> N-GObject  )

=item Str $str; (allow-none): The text of the label, with an underscore in front of the mnemonic character

=end pod
}}

sub _gtk_label_new_with_mnemonic ( Str $str --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_label_new_with_mnemonic')
  { * }


#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<connect-object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<connect-object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment -----------------------------------------------------------------------
=comment #TS:0:activate-current-link:
=head3 activate-current-link

A [keybinding signal][GtkBindingSignal]
which gets emitted when the user activates a link in the label.

Applications may also emit the signal with C<g-signal-emit-by-name()>
if they need to control activation of URIs programmatically.

The default bindings for this signal are all forms of the Enter key.


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($label),
    *%user-options
  );

=item $label; The label on which the signal was emitted

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:activate-link:
=head3 activate-link

The signal which gets emitted to activate a URI.
Applications may connect to it to override the default behaviour,
which is to call C<gtk-show-uri-on-window()>.

Returns: C<True> if the link has been activated


  method handler (
    Str $uri,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($label),
    *%user-options
    --> Int
  );

=item $label; The label on which the signal was emitted

=item $uri; the URI that is activated

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:copy-clipboard:
=head3 copy-clipboard

The I<copy-clipboard> signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted to copy the selection to the clipboard.

The default binding for this signal is Ctrl-c.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($label),
    *%user-options
  );

=item $label; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:move-cursor:
=head3 move-cursor

The I<move-cursor> signal is a
[keybinding signal][GtkBindingSignal]
which gets emitted when the user initiates a cursor movement.
If the cursor is not visible in I<entry>, this signal causes
the viewport to be moved instead.

Applications should not connect to it, but may emit it with
C<g-signal-emit-by-name()> if they need to control the cursor
programmatically.

The default bindings for this signal come in two variants,
the variant with the Shift modifier extends the selection,
the variant without the Shift modifer does not.
There are too many key combinations to list them all here.
- Arrow keys move by individual characters/lines
- Ctrl-arrow key combinations move by words/paragraphs
- Home/End keys move to the ends of the buffer

  method handler (
    Unknown type GTK_TYPE_MOVEMENT_STEP $step,
    Int $count,
    Int $extend_selection,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($entry),
    *%user-options
  );

=item $entry; the object which received the signal

=item $step; the granularity of the move, as a B<Gnome::Gtk3::MovementStep>

=item $count; the number of I<step> units to move

=item $extend_selection; C<True> if the move should extend the selection

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:0:populate-popup:
=head3 populate-popup

The I<populate-popup> signal gets emitted before showing the
context menu of the label. Note that only selectable labels
have context menus.

If you need to add items to the context menu, connect
to this signal and append your menuitems to the I<menu>.

  method handler (
    Unknown type GTK_TYPE_MENU $menu,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($label),
    *%user-options
  );

=item $label; The label on which the signal is emitted

=item $menu; the menu that is being populated

=item $_handle_id; the registered event handler id

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:1:angle:
=head3 Angle: angle

The angle that the baseline of the label makes with the horizontal, in degrees, measured counterclockwise. An angle of 90 reads from from bottom to top, an angle of 270, from top to bottom. Ignored if the label is selectable.

The B<Gnome::GObject::Value> type of property I<angle> is C<G_TYPE_DOUBLE>.

=comment -----------------------------------------------------------------------
=comment #TP:0:attributes:
=head3 Attributes: attributes


The B<Gnome::GObject::Value> type of property I<attributes> is C<G_TYPE_BOXED>.

=comment -----------------------------------------------------------------------
=comment #TP:0:cursor-position:
=head3 Cursor Position: cursor-position


The B<Gnome::GObject::Value> type of property I<cursor-position> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:ellipsize:
=head3 Ellipsize: ellipsize


The preferred place to ellipsize the string, if the label does
not have enough room to display the entire string, specified as a
B<PangoEllipsizeMode>.

Note that setting this property to a value other than
C<PANGO-ELLIPSIZE-NONE> has the side-effect that the label requests
only enough space to display the ellipsis "...". In particular, this
means that ellipsizing labels do not work well in notebook tabs, unless
the B<Gnome::Gtk3::Notebook> tab-expand child property is set to C<True>. Other ways
to set a label's width are C<gtk-widget-set-size-request()> and
C<set-width-chars()>.

   Widget type: PANGO_TYPE_ELLIPSIZE_MODE

The B<Gnome::GObject::Value> type of property I<ellipsize> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:0:justify:
=head3 Justification: justify

The alignment of the lines in the text of the label relative to each other. This does NOT affect the alignment of the label within its allocation. See GtkLabel:xalign for that
Default value: False

The B<Gnome::GObject::Value> type of property I<justify> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:1:label:
=head3 Label: label

The contents of the label.

If the string contains [Pango XML markup][PangoMarkupFormat], you will  have to set the  I<use-markup> property to C<True> in order for the label to display the markup attributes. See also C<set-markup()> for a convenience function that sets both this property and the  I<use-markup> property at the same time.

If the string contains underlines acting as mnemonics, you will have to set the  I<use-underline> property to C<True> in order for the label to display them.
The B<Gnome::GObject::Value> type of property I<label> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:lines:
=head3 Number of lines: lines

 The number of lines to which an ellipsized, wrapping label should be limited. This property has no effect if the label is not wrapping or ellipsized. Set this property to -1 if you don't want to limit the number of lines.

The B<Gnome::GObject::Value> type of property I<lines> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:max-width-chars:
=head3 Maximum Width In Characters: max-width-chars


The desired maximum width of the label, in characters. If this property is set to -1, the width will be calculated automatically.
See the section on [text layout][label-text-layout] for details of how  I<width-chars> and  I<max-width-chars> determine the width of ellipsized and wrapped labels.

The B<Gnome::GObject::Value> type of property I<max-width-chars> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:mnemonic-keyval:
=head3 Mnemonic key: mnemonic-keyval

The B<Gnome::GObject::Value> type of property I<mnemonic-keyval> is C<G_TYPE_UINT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:mnemonic-widget:
=head3 Mnemonic widget: mnemonic-widget

The widget to be activated when the label's mnemonic key is pressed

The B<Gnome::GObject::Value> type of property I<mnemonic-widget> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:pattern:
=head3 Pattern: pattern

A string with '_' characters in positions correspond to characters in the text to underline Default value: Any

The B<Gnome::GObject::Value> type of property I<pattern> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:selectable:
=head3 Selectable: selectable

Whether the label text can be selected with the mouse
Default value: False

The B<Gnome::GObject::Value> type of property I<selectable> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:selection-bound:
=head3 Selection Bound: selection-bound


The B<Gnome::GObject::Value> type of property I<selection-bound> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:single-line-mode:
=head3 Single Line Mode: single-line-mode

Whether the label is in single line mode. In single line mode, the height of the label does not depend on the actual text, it is always set to ascent + descent of the font. This can be an advantage in situations where resizing the label because of text changes would be distracting, e.g. in a statusbar.

The B<Gnome::GObject::Value> type of property I<single-line-mode> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:track-visited-links:
=head3 Track visited links: track-visited-links

Set this property to C<True> to make the label track which links have been visited. It will then apply the B<Gnome::Gtk3::TK-STATE-FLAG-VISITED> when rendering this link, in addition to B<Gnome::Gtk3::TK-STATE-FLAG-LINK>.

The B<Gnome::GObject::Value> type of property I<track-visited-links> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:use-markup:
=head3 Use markup: use-markup

The text of the label includes XML markup. See C<pango-parse-markup()>
Default value: False

The B<Gnome::GObject::Value> type of property I<use-markup> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:use-underline:
=head3 Use underline: use-underline

If set, an underline in the text indicates the next character should be used for the mnemonic accelerator key
Default value: False

The B<Gnome::GObject::Value> type of property I<use-underline> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:width-chars:
=head3 Width In Characters: width-chars

The desired width of the label, in characters. If this property is set to -1, the width will be calculated automatically. See the section on L<text layout|https://developer.gnome.org/gtk3/stable/GtkLabel.html#label-text-layout> for details of how  I<width-chars> and  I<max-width-chars> determine the width of ellipsized and wrapped labels.

The B<Gnome::GObject::Value> type of property I<width-chars> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:wrap:
=head3 Line wrap: wrap

If set, wrap lines if the text becomes too wide
Default value: False

The B<Gnome::GObject::Value> type of property I<wrap> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:wrap-mode:
=head3 Line wrap mode: wrap-mode


If line wrapping is on (see the  I<wrap> property) this controls how the line wrapping is done. The default is C<PANGO-WRAP-WORD>, which means wrap on word boundaries.

   Widget type: PANGO_TYPE_WRAP_MODE

The B<Gnome::GObject::Value> type of property I<wrap-mode> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:1:xalign:
=head3 X align: xalign

The xalign property determines the horizontal aligment of the label text inside the labels size allocation. Compare this to  I<halign>, which determines how the labels size allocation is positioned in the space available for the label.

The B<Gnome::GObject::Value> type of property I<xalign> is C<G_TYPE_FLOAT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:yalign:
=head3 Y align: yalign

The yalign property determines the vertical aligment of the label text inside the labels size allocation. Compare this to  I<valign>, which determines how the labels size allocation is positioned in the space available for the label.


The B<Gnome::GObject::Value> type of property I<yalign> is C<G_TYPE_FLOAT>.
=end pod
