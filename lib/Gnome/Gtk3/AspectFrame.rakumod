#TL:1:Gnome::Gtk3::AspectFrame:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AspectFrame

A frame that constrains its child to a particular aspect ratio

=comment ![](images/X.png)


=head1 Description

The B<Gnome::Gtk3::AspectFrame> is useful when you want pack a widget so that it can resize but always retains the same aspect ratio. For instance, one might be drawing a small preview of a larger image. B<Gnome::Gtk3::AspectFrame> derives from B<Gnome::Gtk3::Frame>, so it can draw a label and a frame around the child. The frame will be “shrink-wrapped” to the size of the child.


=head2 Css Nodes

B<Gnome::Gtk3::AspectFrame> uses a CSS node with name frame.

=begin comment
=head2 Implemented Interfaces

Gnome::Gtk3::AspectFrame implements
=comment item Gnome::Atk::ImplementorIface
=end comment


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::AspectFrame;
  also is Gnome::Gtk3::Frame;


=head2 Uml Diagram

![](plantuml/AspectFrame.svg)


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Frame;
use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::AspectFrame:auth<github:MARTIMM>;
also is Gnome::Gtk3::Frame;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :label, :xalign, :yalign, :ratio, :obey-child

Create a new AspectFrame with all bells and wistles.

  multi method new (
    Str :$label!, Num :$xalign = 0.0e0, Num :$yalign = 0.0e0,
    Num :$ratio = 1.0e0, Bool :$obey-child?
  )

=item $label; Label text.
=item $xalign; Horizontal alignment of the child within the allocation of the B<Gnome::Gtk3::AspectFrame>. This ranges from 0.0 (left aligned) to 1.0 (right aligned). By default set to 0.0.
=item $yalign; Vertical alignment of the child within the allocation of the B<Gnome::Gtk3::AspectFrame>. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned). By default set to 0.0.
=item $ratio; The desired aspect ratio. By default set to 1.0.
=item $obey_child; If C<True>, I<ratio> is ignored, and the aspect ratio is taken from the requistion of the child. By default set to False if $ratio is defined or True if it isn't.


=head3 :native-object

Create an object using a native object from elsewhere. See also B<Gnome::N::TopLevelSupportClass>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:label):
#TM:4:new(:native-object):TopLevelSupportClass
#TM:4:new(:build-id):Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::AspectFrame';

  # process all named arguments
  if ? %options<widget> || ? %options<native-object> ||
     ? %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif ?%options<label> {
    my Num ( $xalign, $yalign, $ratio);
    $xalign = %options<xalign> // 0.0e0;
    $yalign = %options<yalign> // 0.0e0;
    $ratio = %options<ratio> // 1.0e0;
    my Bool $obey-child = %options<obey-child> // !%options<ratio>;

    self._set-native-object(
      _gtk_aspect_frame_new(
        %options<label>, $xalign, $yalign, $ratio, $obey-child
      )
    );
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported, undefined, incomplete or wrongly typed options for ' ~
               self.^name ~ ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # no options found
  else {
    die X::Gnome.new(:message('No options found'));
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkAspectFrame');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_aspect_frame_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_aspect_frame_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('aspect-frame-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-aspect-frame-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkAspectFrame');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:set:
=begin pod
=head2 set

Set parameters for an existing B<Gnome::Gtk3::AspectFrame>.

  method set (
    Num $xalign, Num $yalign, Num $ratio, Int $obey_child
  )

=item $xalign; Horizontal alignment of the child within the allocation of the B<Gnome::Gtk3::AspectFrame>. This ranges from 0.0 (left aligned) to 1.0 (right aligned)
=item $yalign; Vertical alignment of the child within the allocation of the B<Gnome::Gtk3::AspectFrame>. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned)
=item $ratio; The desired aspect ratio.
=item $obey_child; If C<1>, I<ratio> is ignored, and the aspect ratio is taken from the requistion of the child.

=end pod

method set (
  Num $xalign, Num $yalign, Num $ratio, Int $obey_child
) {
  gtk_aspect_frame_set(
    self._get-native-object-no-reffing, $xalign, $yalign, $ratio, $obey_child
  );
}

sub gtk_aspect_frame_set ( N-GObject $aspect_frame, num32 $xalign, num32 $yalign, num32 $ratio, int32 $obey_child  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_aspect_frame_new:new(:label)
#`{{
=begin pod
=head2 gtk_aspect_frame_new

Create a new B<Gnome::Gtk3::AspectFrame>.

Returns: the new B<Gnome::Gtk3::AspectFrame>.

  method gtk_aspect_frame_new ( Str $label, Num $xalign, Num $yalign, Num $ratio, Int $obey_child --> N-GObject )

=item $label; (allow-none): Label text.
=item $xalign; Horizontal alignment of the child within the allocation of the B<Gnome::Gtk3::AspectFrame>. This ranges from 0.0 (left aligned) to 1.0 (right aligned)
=item $yalign; Vertical alignment of the child within the allocation of the B<Gnome::Gtk3::AspectFrame>. This ranges from 0.0 (top aligned) to 1.0 (bottom aligned)
=item $ratio; The desired aspect ratio.
=item $obey_child; If C<1>, I<ratio> is ignored, and the aspect ratio is taken from the requistion of the child.

=end pod
}}

sub _gtk_aspect_frame_new ( Str $label, num32 $xalign, num32 $yalign, num32 $ratio, int32 $obey_child --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_aspect_frame_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:obey-child:
=head2 obey-child

Force aspect ratio to match that of the frame's child

The B<Gnome::GObject::Value> type of property I<obey-child> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:ratio:
=head2 ratio

Aspect ratio if obey_child is FALSE

The B<Gnome::GObject::Value> type of property I<ratio> is C<G_TYPE_FLOAT>.

=item Parameter is readable and writable.
=item Minimum value is MIN_RATIO.
=item Maximum value is MAX_RATIO.
=item Default value is 1.0.


=comment -----------------------------------------------------------------------
=comment #TP:1:xalign:
=head2 xalign

X alignment of the child

The B<Gnome::GObject::Value> type of property I<xalign> is C<G_TYPE_FLOAT>.

=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is 1.0.
=item Default value is 0.5.


=comment -----------------------------------------------------------------------
=comment #TP:1:yalign:
=head2 yalign

Y alignment of the child

The B<Gnome::GObject::Value> type of property I<yalign> is C<G_TYPE_FLOAT>.

=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is 1.0.
=item Default value is 0.5.

=end pod




=finish
#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:1:xalign:
=head3 Horizontal Alignment

X alignment of the child.

The B<Gnome::GObject::Value> type of property I<xalign> is C<G_TYPE_FLOAT>.

=comment #TP:1:yalign:
=head3 Vertical Alignment

Y alignment of the child.

The B<Gnome::GObject::Value> type of property I<yalign> is C<G_TYPE_FLOAT>.

=comment #TP:0:ratio:
=head3 Ratio

Aspect ratio if obey_child is FALSE.

The B<Gnome::GObject::Value> type of property I<ratio> is C<G_TYPE_FLOAT>.

=comment #TP:1:obey-child:
=head3 Obey child

Force aspect ratio to match that of the frame's child
Default value: True


The B<Gnome::GObject::Value> type of property I<obey-child> is C<G_TYPE_BOOLEAN>.
=end pod
