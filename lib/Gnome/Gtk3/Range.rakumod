#TL:1:Gnome::Gtk3::Range:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Range

Base class for widgets which visualize an adjustment

=head1 Description


B<Gnome::Gtk3::Range> is the common base class for widgets which visualize an
adjustment, e.g B<Gnome::Gtk3::Scale> or B<Gnome::Gtk3::Scrollbar>.

Apart from signals for monitoring the parameters of the adjustment,
B<Gnome::Gtk3::Range> provides properties and methods for influencing the sensitivity
of the “steppers”. It also provides properties and methods for setting a
“fill level” on range widgets. See C<gtk_range_set_fill_level()>.

=head2 Implemented Interfaces

Gnome::Gtk3::Range implements
=item [Gnome::Gtk3::Orientable](Orientable.html)

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Range;
  also is Gnome::Gtk3::Widget;
  also does Gnome::Gtk3::Orientable;

=comment head2 Example


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Gdk3::Types;
use Gnome::Gtk3::Widget;

use Gnome::Gtk3::Buildable;
use Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkrange.h
# https://developer.gnome.org/stable/GtkRange.html#gtk-range-get-fill-level
unit class Gnome::Gtk3::Range:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;
also does Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create an object using a native object from elsewhere. See also Gnome::GObject::Object.

  multi method new ( :$native-object! )

=end pod

#TM:1:new():inheriting
#TM:1:new(:native-object):

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<value-changed>,
    :w1<adjust-bounds move-slider>,
    :w2<change-value>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::Range';

  if ? %options<native-object> || ? %options<widget> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkRange');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_range_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_adjustment:
=begin pod
=head2 [[gtk_] range_] set_adjustment

Sets the adjustment to be used as the “model” object for this range
widget. The adjustment indicates the current range value, the
minimum and maximum range values, the step/page increments used
for keybindings and scrolling, and the page size. The page size
is normally 0 for B<Gnome::Gtk3::Scale> and nonzero for B<Gnome::Gtk3::Scrollbar>, and
indicates the size of the visible area of the widget being scrolled.
The page size affects the size of the scrollbar slider.

  method gtk_range_set_adjustment ( N-GObject $adjustment )

=item N-GObject $adjustment; a B<Gnome::Gtk3::Adjustment>

=end pod

sub gtk_range_set_adjustment ( N-GObject $range, N-GObject $adjustment )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_get_adjustment:
=begin pod
=head2 [[gtk_] range_] get_adjustment

Get the B<Gnome::Gtk3::Adjustment> which is the “model” object for B<Gnome::Gtk3::Range>.
See C<gtk_range_set_adjustment()> for details.
The return value does not have a reference added, so should not
be unreferenced.

Returns: (transfer none): a B<Gnome::Gtk3::Adjustment>

  method gtk_range_get_adjustment ( --> N-GObject  )


=end pod

sub gtk_range_get_adjustment ( N-GObject $range )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_inverted:
=begin pod
=head2 [[gtk_] range_] set_inverted

Ranges normally move from lower to higher values as the
slider moves from top to bottom or left to right. Inverted
ranges have higher values at the top or on the right rather than
on the bottom or left.

  method gtk_range_set_inverted ( Int $setting )

=item Int $setting; C<1> to invert the range

=end pod

sub gtk_range_set_inverted ( N-GObject $range, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_get_inverted:
=begin pod
=head2 [[gtk_] range_] get_inverted

Gets the value set by C<gtk_range_set_inverted()>.

Returns: C<1> if the range is inverted

  method gtk_range_get_inverted ( --> Int  )


=end pod

sub gtk_range_get_inverted ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_flippable:
=begin pod
=head2 [[gtk_] range_] set_flippable

If a range is flippable, it will switch its direction if it is
horizontal and its direction is C<GTK_TEXT_DIR_RTL>.

See C<gtk_widget_get_direction()>.


  method gtk_range_set_flippable ( Int $flippable )

=item Int $flippable; C<1> to make the range flippable

=end pod

sub gtk_range_set_flippable ( N-GObject $range, int32 $flippable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_get_flippable:
=begin pod
=head2 [[gtk_] range_] get_flippable

Gets the value set by C<gtk_range_set_flippable()>.

Returns: C<1> if the range is flippable


  method gtk_range_get_flippable ( --> Int  )


=end pod

sub gtk_range_get_flippable ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_slider_size_fixed:
=begin pod
=head2 [[gtk_] range_] set_slider_size_fixed

Sets whether the range’s slider has a fixed size, or a size that
depends on its adjustment’s page size.

This function is useful mainly for B<Gnome::Gtk3::Range> subclasses.


  method gtk_range_set_slider_size_fixed ( Int $size_fixed )

=item Int $size_fixed; C<1> to make the slider size constant

=end pod

sub gtk_range_set_slider_size_fixed ( N-GObject $range, int32 $size_fixed )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_get_slider_size_fixed:
=begin pod
=head2 [[gtk_] range_] get_slider_size_fixed

This function is useful mainly for B<Gnome::Gtk3::Range> subclasses.

See C<gtk_range_set_slider_size_fixed()>.

Returns: whether the range’s slider has a fixed size.


  method gtk_range_get_slider_size_fixed ( --> Int  )


=end pod

sub gtk_range_get_slider_size_fixed ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_range_get_range_rect:
=begin pod
=head2 [[gtk_] range_] get_range_rect

This function returns the area that contains the range’s trough and its steppers, in widgets window coordinates.

This function is useful mainly for GtkRange subclasses.

  method gtk_range_get_range_rect ( --> Gnome::Gdk3::Rectangle )

=item $rectangle. Location for the range rectangleType to return. N-GdkRectangle is defined in GdkTypes.

=end pod

sub gtk_range_get_range_rect ( N-GObject $range --> N-GdkRectangle ) {
  _gtk_range_get_range_rect( $range, my N-GdkRectangle $rectangle .= new);
  $rectangle
}

sub _gtk_range_get_range_rect (
  N-GObject $range, N-GdkRectangle $rectangle is rw
) is native(&gtk-lib)
  is symbol('gtk_range_get_range_rect')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_range_get_slider_range:
=begin pod
=head2 [[gtk_] range_] get_slider_range

This function returns sliders range along the long dimension,
in widget->window coordinates.

This function is useful mainly for B<Gnome::Gtk3::Range> subclasses.


  method gtk_range_get_slider_range ( --> List )

Returns a C<List> where
=item Int $slider_start; the slider's start, or C<Any>
=item Int $slider_end; the slider's end, or C<Any>

=end pod

sub gtk_range_get_slider_range ( N-GObject $range ) {
  _gtk_range_get_slider_range(
    $range, my int32 $slider_start, my int32 $slider_end
  );

  ( $slider_start, $slider_end)
}

sub _gtk_range_get_slider_range (
  N-GObject $range, int32 $slider_start is rw, int32 $slider_end is rw
) is native(&gtk-lib)
  is symbol('gtk_range_get_slider_range')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_lower_stepper_sensitivity:
=begin pod
=head2 [[gtk_] range_] set_lower_stepper_sensitivity

Sets the sensitivity policy for the stepper that points to the
'lower' end of the B<Gnome::Gtk3::Range>’s adjustment.


  method gtk_range_set_lower_stepper_sensitivity ( GtkSensitivityType $sensitivity )

=item GtkSensitivityType $sensitivity; the lower stepper’s sensitivity policy.

=end pod

sub gtk_range_set_lower_stepper_sensitivity ( N-GObject $range, int32 $sensitivity )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_get_lower_stepper_sensitivity:
=begin pod
=head2 [[gtk_] range_] get_lower_stepper_sensitivity

Gets the sensitivity policy for the stepper that points to the
'lower' end of the B<Gnome::Gtk3::Range>’s adjustment.

Returns: The lower stepper’s sensitivity policy.


  method gtk_range_get_lower_stepper_sensitivity ( --> GtkSensitivityType  )


=end pod

sub gtk_range_get_lower_stepper_sensitivity ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_upper_stepper_sensitivity:
=begin pod
=head2 [[gtk_] range_] set_upper_stepper_sensitivity

Sets the sensitivity policy for the stepper that points to the
'upper' end of the B<Gnome::Gtk3::Range>’s adjustment.


  method gtk_range_set_upper_stepper_sensitivity ( GtkSensitivityType $sensitivity )

=item GtkSensitivityType $sensitivity; the upper stepper’s sensitivity policy.

=end pod

sub gtk_range_set_upper_stepper_sensitivity ( N-GObject $range, int32 $sensitivity )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_get_upper_stepper_sensitivity:
=begin pod
=head2 [[gtk_] range_] get_upper_stepper_sensitivity

Gets the sensitivity policy for the stepper that points to the
'upper' end of the B<Gnome::Gtk3::Range>’s adjustment.

Returns: The upper stepper’s sensitivity policy.


  method gtk_range_get_upper_stepper_sensitivity ( --> GtkSensitivityType  )


=end pod

sub gtk_range_get_upper_stepper_sensitivity ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_increments:
=begin pod
=head2 [[gtk_] range_] set_increments

Sets the step and page sizes for the range.
The step size is used when the user clicks the B<Gnome::Gtk3::Scrollbar>
arrows or moves B<Gnome::Gtk3::Scale> via arrow keys. The page size
is used for example when moving via Page Up or Page Down keys.

  method gtk_range_set_increments ( Num $step, Num $page )

=item Num $step; step size
=item Num $page; page size

=end pod

sub gtk_range_set_increments ( N-GObject $range, num64 $step, num64 $page )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_range_set_range:
=begin pod
=head2 [[gtk_] range_] set_range

Sets the allowable values in the B<Gnome::Gtk3::Range>, and clamps the range value to be between I<min> and I<max>. (If the range has a non-zero page size, it is clamped between I<min> and I<max> - page-size.)

  method gtk_range_set_range ( Num $min, Num $max )

=item Num $min; minimum range value
=item Num $max; maximum range value

=end pod

sub gtk_range_set_range ( N-GObject $range, num64 $min, num64 $max )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_range_set_value:
=begin pod
=head2 [[gtk_] range_] set_value

Sets the current value of the range; if the value is outside the minimum or maximum range values, it will be clamped to fit inside them. The range emits the  I<value-changed> signal if the value changes.

  method gtk_range_set_value ( Num $value )

=item Num $value; new value of the range

=end pod

sub gtk_range_set_value ( N-GObject $range, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_range_get_value:
=begin pod
=head2 [[gtk_] range_] get_value

Gets the current value of the range.

  method gtk_range_get_value ( --> Num  )


=end pod

sub gtk_range_get_value ( N-GObject $range )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_show_fill_level:
=begin pod
=head2 [[gtk_] range_] set_show_fill_level

Sets whether a graphical fill level is show on the trough. See C<gtk_range_set_fill_level()> for a general description of the fill level concept.


  method gtk_range_set_show_fill_level ( Int $show_fill_level )

=item Int $show_fill_level; Whether a fill level indicator graphics is shown.

=end pod

sub gtk_range_set_show_fill_level ( N-GObject $range, int32 $show_fill_level )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_get_show_fill_level:
=begin pod
=head2 [[gtk_] range_] get_show_fill_level

Gets whether the range displays the fill level graphically.

Returns: C<1> if I<range> shows the fill level.


  method gtk_range_get_show_fill_level ( --> Int  )


=end pod

sub gtk_range_get_show_fill_level ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_restrict_to_fill_level:
=begin pod
=head2 [[gtk_] range_] set_restrict_to_fill_level

Sets whether the slider is restricted to the fill level. See
C<gtk_range_set_fill_level()> for a general description of the fill
level concept.


  method gtk_range_set_restrict_to_fill_level ( Int $restrict_to_fill_level )

=item Int $restrict_to_fill_level; Whether the fill level restricts slider movement.

=end pod

sub gtk_range_set_restrict_to_fill_level ( N-GObject $range, int32 $restrict_to_fill_level )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_get_restrict_to_fill_level:
=begin pod
=head2 [[gtk_] range_] get_restrict_to_fill_level

Gets whether the range is restricted to the fill level.

Returns: C<1> if I<range> is restricted to the fill level.


  method gtk_range_get_restrict_to_fill_level ( --> Int  )


=end pod

sub gtk_range_get_restrict_to_fill_level ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_fill_level:
=begin pod
=head2 [[gtk_] range_] set_fill_level

Set the new position of the fill level indicator.

The “fill level” is probably best described by its most prominent
use case, which is an indicator for the amount of pre-buffering in
a streaming media player. In that use case, the value of the range
would indicate the current play position, and the fill level would
be the position up to which the file/stream has been downloaded.

This amount of prebuffering can be displayed on the range’s trough
and is themeable separately from the trough. To enable fill level
display, use C<gtk_range_set_show_fill_level()>. The range defaults
to not showing the fill level.

Additionally, it’s possible to restrict the range’s slider position
to values which are smaller than the fill level. This is controller
by C<gtk_range_set_restrict_to_fill_level()> and is by default
enabled.


  method gtk_range_set_fill_level ( Num $fill_level )

=item Num $fill_level; the new position of the fill level indicator

=end pod

sub gtk_range_set_fill_level ( N-GObject $range, num64 $fill_level )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_get_fill_level:
=begin pod
=head2 [[gtk_] range_] get_fill_level

Gets the current position of the fill level indicator.

Returns: The current fill level


  method gtk_range_get_fill_level ( --> Num  )


=end pod

sub gtk_range_get_fill_level ( N-GObject $range )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_set_round_digits:
=begin pod
=head2 [[gtk_] range_] set_round_digits

Sets the number of digits to round the value to when
it changes. See  I<change-value>.


  method gtk_range_set_round_digits ( Int $round_digits )

=item Int $round_digits; the precision in digits, or -1

=end pod

sub gtk_range_set_round_digits ( N-GObject $range, int32 $round_digits )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_range_get_round_digits:
=begin pod
=head2 [[gtk_] range_] get_round_digits

Gets the number of digits to round the value to when
it changes. See  I<change-value>.

Returns: the number of digits to round to


  method gtk_range_get_round_digits ( --> Int  )


=end pod

sub gtk_range_get_round_digits ( N-GObject $range )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, N-GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:0:value-changed:
=head3 value-changed

Emitted when the range value changes.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($range),
    *%user-options
  );

=item $range; the B<Gnome::Gtk3::Range> that received the signal


=comment #TS:0:adjust-bounds:
=head3 adjust-bounds

Emitted before clamping a value, to give the application a
chance to adjust the bounds.

  method handler (
    Unknown type G_TYPE_DOUBLE $value,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($range),
    *%user-options
  );

=item $range; the B<Gnome::Gtk3::Range> that received the signal

=item $value; the value before we clamp


=comment #TS:0:move-slider:
=head3 move-slider

Virtual function that moves the slider. Used for keybindings.

  method handler (
    Unknown type GTK_TYPE_SCROLL_TYPE $step,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($range),
    *%user-options
  );

=item $range; the B<Gnome::Gtk3::Range> that received the signal

=item $step; how to move the slider


=comment #TS:0:change-value:
=head3 change-value

The  I<change-value> signal is emitted when a scroll action is
performed on a range.  It allows an application to determine the
type of scroll event that occurred and the resultant new value.
The application can handle the event itself and return C<1> to
prevent further processing.  Or, by returning C<0>, it can pass
the event to other handlers until the default GTK+ handler is
reached.

The value parameter is unrounded.  An application that overrides
the B<Gnome::Gtk3::Range>::change-value signal is responsible for clamping the
value to the desired number of decimal digits; the default GTK+
handler clamps the value based on  I<round-digits>.

It is not possible to use delayed update policies in an overridden
 I<change-value> handler.

Returns: C<1> to prevent other handlers from being invoked for
the signal, C<0> to propagate the signal further


  method handler (
    Unknown type GTK_TYPE_SCROLL_TYPE $scroll,
    Unknown type G_TYPE_DOUBLE $value,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($range),
    *%user-options
    --> Int
  );

=item $range; the B<Gnome::Gtk3::Range> that received the signal

=item $scroll; the type of scroll action that was performed

=item $value; the new value resulting from the scroll action


=end pod
