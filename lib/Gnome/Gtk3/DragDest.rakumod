#TL:1:Gnome::Gtk3::DragDest:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::DragDest

=comment ![](images/X.png)

=head1 Description

GTK+ has a rich set of functions for doing inter-process communication via the drag-and-drop metaphor.

This module defines the drag destination manipulations


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::DragDest;


=comment head2 Uml Diagram

=comment ![](plantuml/.svg)

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::GObject::Object;

use Gnome::Gdk3::Atom;

use Gnome::Gtk3::TargetEntry;
use Gnome::Gtk3::TargetTable;
use Gnome::Gtk3::TargetList;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::DragDest:auth<github:MARTIMM>:ver<0.1.0>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkDestDefaults

The B<Gnome::Gtk3::DestDefaults> enumeration specifies the various types of action that will be taken on behalf of the user for a drag destination site.

=item GTK_DEST_DEFAULT_NONE: (=0) to select no default.
=item GTK-DEST-DEFAULT-MOTION: If set for a widget, GTK+, during a drag over this widget will check if the drag matches this widget’s list of possible targets and actions. GTK+ will then call C<gdk-drag-status()> as appropriate.
=item GTK-DEST-DEFAULT-HIGHLIGHT: If set for a widget, GTK+ will draw a highlight on this widget as long as a drag is over this widget and the widget drag format and action are acceptable.
=item GTK-DEST-DEFAULT-DROP: If set for a widget, when a drop occurs, GTK+ will will check if the drag matches this widget’s list of possible targets and actions. If so, GTK+ will call C<gtk-drag-get-data()> on behalf of the widget. Whether or not the drop is successful, GTK+ will call C<gtk-drag-finish()>. If the action was a move, then if the drag was successful, then C<True> will be passed for the I<delete> parameter to C<gtk-drag-finish()>.
=item GTK-DEST-DEFAULT-ALL: If set, specifies that all default actions should be taken.

=end pod

#TE:1:GtkDestDefaults:
enum GtkDestDefaults is export (
  GTK_DEST_DEFAULT_NONE         => 0,
  'GTK_DEST_DEFAULT_MOTION'     => 1 +< 0,
  'GTK_DEST_DEFAULT_HIGHLIGHT'  => 1 +< 1,
  'GTK_DEST_DEFAULT_DROP'       => 1 +< 2,
  'GTK_DEST_DEFAULT_ALL'        => 0x07
);

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new DragDest object.

  multi method new ( )

This object does not wrap a native object into this Raku object because it does not need one. Therefore no option like C<:native-object> is needed.

=end pod

#TM:1:new():
# submethod BUILD ( *%options ) {  }

#-------------------------------------------------------------------------------
#TM:0:add-image-targets:
=begin pod
=head2 add-image-targets

Add the image targets supported by B<Gnome::Gtk3::SelectionData> to the target list of the drag destination. The targets are added with I<info> = 0. If you need another value, use C<gtk-target-list-add-image-targets()> and C<set-target-list()>.

  method add-image-targets ( N-GObject() $widget )

=item $widget; a native B<Gnome::Gtk3::Widget> that’s a drag destination
=end pod

method add-image-targets ( N-GObject() $widget ) {
  gtk_drag_dest_add_image_targets($widget);
}

sub gtk_drag_dest_add_image_targets (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-text-targets:
=begin pod
=head2 add-text-targets

Add the text targets supported by B<Gnome::Gtk3::SelectionData> to the target list of the drag destination. The targets are added with I<info> = 0. If you need another value, use C<gtk-target-list-add-text-targets()> and C<set-target-list()>.

  method add-text-targets ( N-GObject() $widget )

=item $widget; a B<Gnome::Gtk3::Widget> that’s a drag destination
=end pod

method add-text-targets ( N-GObject() $widget ) {
  gtk_drag_dest_add_text_targets($widget);
}

sub gtk_drag_dest_add_text_targets (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-uri-targets:
=begin pod
=head2 add-uri-targets

Add the URI targets supported by B<Gnome::Gtk3::SelectionData> to the target list of the drag destination. The targets are added with I<info> = 0. If you need another value, use C<gtk-target-list-add-uri-targets()> and C<set-target-list()>.

  method add-uri-targets ( N-GObject() $widget )

=item $widget; a B<Gnome::Gtk3::Widget> that’s a drag destination
=end pod

method add-uri-targets ( N-GObject() $widget ) {
  gtk_drag_dest_add_uri_targets($widget);
}

sub gtk_drag_dest_add_uri_targets (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:find-target:xt/examples/Dnd
=begin pod
=head2 find-target

Looks for a match between the supported targets of I<context> and the I<dest-target-list>, returning the first matching target, otherwise returning C<GDK-NONE>. I<dest-target-list> should usually be the return value from C<get-target-list()>, but some widgets may have different valid targets for different parts of the widget; in that case, they will have to implement a drag-motion handler that passes the correct target list to this function.

Returns: first target that the source offers and the dest can accept, or C<GDK-NONE>

  method find-target (
    N-GObject() $widget, N-GObject() $context,
    N-GObject() $target-list?
    --> N-GObject
  )

=item $widget; drag destination widget
=item $context; drag context
=item $target-list; list of droppable targets, or C<undefined> to use C<get-target-list($widget)>.


Previously, it returned a B<Gnome::Gdk3::Atom>. To confirm with latest ideas about coercing, the routine now returns a native object. To cope with the change, write the following instead, for example;

  my Gnome::Gdk3::Atom() $target-atom = $!destination.find-target(…);

Note the C<()> tacked on the B<Gnome::Gdk3::Atom> type! Sorry that I cannot give a deprecation warning because of multis not looking for return types.

=end pod

method find-target (
  N-GObject() $widget, N-GObject() $context,
  N-GObject() $target-list = N-GObject
  --> N-GObject
) {
  gtk_drag_dest_find_target( $widget, $context, $target-list)
}

sub gtk_drag_dest_find_target (
  N-GObject $widget, N-GObject $context, N-GObject $target-list
  --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-target-list:
=begin pod
=head2 get-target-list

Returns the list of targets this widget can accept from drag-and-drop.

Returns: the B<Gnome::Gtk3::TargetList>, or C<undefined> if none

  method get-target-list ( N-GObject() $widget --> N-GObject )

=item $widget; a B<Gnome::Gtk3::Widget>
=end pod

method get-target-list ( N-GObject() $widget --> N-GObject ) {
  gtk_drag_dest_get_target_list($widget)
}

sub gtk_drag_dest_get_target_list (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-track-motion:
=begin pod
=head2 get-track-motion

Returns whether the widget has been configured to always emit  I<drag-motion> signals.

Returns: C<True> if the widget always emits  I<drag-motion> events

  method get-track-motion ( N-GObject $widget --> Bool )

=item $widget; a B<Gnome::Gtk3::Widget> that’s a drag destination
=end pod

method get-track-motion ( $widget --> Bool ) {
  gtk_drag_dest_get_track_motion($widget).Bool
}

sub gtk_drag_dest_get_track_motion (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:set:xt/examples/Dnd
=begin pod
=head2 set

Sets a widget as a potential drop destination, and adds default behaviors.

The default behaviors listed in I<flags> have an effect similar to installing default handlers for the widget’s drag-and-drop signals ( I<drag-motion>,  I<drag-drop>, ...). They all exist for convenience. When passing C<GTK-DEST-DEFAULT-ALL> for instance it is sufficient to connect to the widget’s  I<drag-data-received> signal to get primitive, but consistent drag-and-drop support.

Things become more complicated when you try to preview the dragged data, as described in the documentation for  I<drag-motion>. The default behaviors described by I<flags> make some assumptions, that can conflict with your own signal handlers. For instance C<GTK-DEST-DEFAULT-DROP> causes invokations of C<gdk-drag-status()> in the context of  I<drag-motion>, and invokations of C<gtk-drag-finish()> in  I<drag-data-received>. Especially the later is dramatic, when your own  I<drag-motion> handler calls C<gtk-drag-get-data()> to inspect the dragged data.

There’s no way to set a default action here, you can use the  I<drag-motion> callback for that.

=begin comment
TODO implement gdk-window-get-pointer
Here’s an example C<drag-motion> handler which selects the action to use depending on whether the control key is pressed or not:

  method drag-motion (
    N-GObject() $context, Int $x, Int $y, UInt $time, :_widget($widget)
  ) {
    ??  $mask = gdk-window-get-pointer( $widget.get-window, NULL, NULL);

    my Gnome::Gdk3::DragContext $ctx .= new(:native-object($context));
    if $mask +& GDK-CONTROL-MASK {
      $ctx.status( GDK-ACTION-COPY, time);
    }
    else {
      $ctx.status( GDK-ACTION-MOVE, time);
    }
  }
=end comment

The method API is

  multi method set (
    N-GObject() $widget, Int() $flags,
    Array[N-GtkTargetEntry] $targets, Int() $actions
  )

=item $widget; a B<Gnome::Gtk3::Widget>
=item $flags; which types of default drag behavior to use. Bits are from enum GtkDestDefaults.
=item $targets; an array of native B<Gnome::Gtk3::TargetEntry> targets indicating the drop types that this I<widget> will accept. Later you can access the list with C<get-target-list()> and C<find-target()>, or an empty array.
=item $actions; a bitmask of possible actions for a drop onto this I<widget>. Bits are from enum GdkDragAction defined in B<Gnome::Gdk3::DragContext>.
=end pod

multi method set (
  N-GObject() $widget, Int() $flags, Array $targets, Int() $actions
) {
  $widget .= _get-native-object-no-reffing unless $widget ~~ N-GObject;

  my Array $n-target-array = [];
  for @$targets -> $target is copy {
    $target = $target ~~ N-GtkTargetEntry
                ?? $target
                !! $target._get-native-object-no-reffing;
#note "$?LINE, ", $target;
    $n-target-array.push: $target;
  }
#note "$?LINE, ", $n-target-array;
  my Gnome::Gtk3::TargetTable $target-table .= new(:array($n-target-array));

  gtk_drag_dest_set(
    $widget, $flags, $target-table.get-target-table, $targets.elems, $actions
  );
}

multi method set ( N-GObject() $widget, Int() $flags, Int() $actions ) {
  gtk_drag_dest_set( $widget, $flags, CArray[N-GObject], 0, $actions);
}

sub gtk_drag_dest_set (
  N-GObject $widget, GFlag $flags, CArray[N-GObject] $targets,
  gint $n_targets, GFlag $actions
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:set-target-list:xt/examples/Dnd
=begin pod
=head2 set-target-list

Sets the target types that this widget can accept from drag-and-drop. The widget must first be made into a drag destination with C<set()>.

  method set-target-list ( N-GObject() $widget, N-GtkTargetList $target-list )

=item $widget; a B<Gnome::Gtk3::Widget> that’s a drag destination
=item $target-list; list of droppable targets, or C<undefined> for none
=end pod

method set-target-list ( N-GObject() $widget, $target-list is copy ) {
  if ?$target-list {
    $target-list .= _get-native-object-no-reffing
      unless $target-list ~~ N-GtkTargetList;
  }

  else {
    $target-list = N-GObject;
  }

  gtk_drag_dest_set_target_list( $widget, $target-list);
}

sub gtk_drag_dest_set_target_list (
  N-GObject $widget, N-GtkTargetList $target-list
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-track-motion:
=begin pod
=head2 set-track-motion

Tells the widget to emit  I<drag-motion> and I<drag-leave> events regardless of the targets and the C<GTK-DEST-DEFAULT-MOTION> flag.

This may be used when a widget wants to do generic actions regardless of the targets that the source offers.

  method set-track-motion ( N-GObject() $widget, Bool $track_motion )

=item $widget; a B<Gnome::Gtk3::Widget> that’s a drag destination
=item $track_motion; whether to accept all targets
=end pod

method set-track-motion ( N-GObject() $widget, Bool $track_motion ) {
  gtk_drag_dest_set_track_motion( $widget, $track_motion);
}

sub gtk_drag_dest_set_track_motion (
  N-GObject $widget, gboolean $track_motion
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unset:
=begin pod
=head2 unset

Clears information about a drop destination set with C<set()>. The widget will no longer receive notification of drags.

  method unset ( N-GObject() $widget )

=item $widget; a B<Gnome::Gtk3::Widget>
=end pod

method unset ( $widget ) {
  gtk_drag_dest_unset($widget);
}

sub gtk_drag_dest_unset (
  N-GObject $widget
) is native(&gtk-lib)
  { * }
