#TL:1:Gnome::Gtk3::TreeIter:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TreeIter

=head1 Description

A struct that specifies a TreeIter.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TreeIter;
  also is Gnome::GObject::Boxed;


=head2 Uml Diagram

![](plantuml/TreeIter.svg)


=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::TreeIter:auth<github:MARTIMM>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkTreeIter

The B<Gnome::Gtk3::TreeIter> is the primary structure for accessing a B<Gnome::Gtk3::TreeModel>. Tree iterators are not created by the users application but are returned from TreeModel implementations such as B<Gnome::Gtk3::TreeStore>.

=begin comment
Models are expected to put a unique integer in the I<stamp> member, and put model-specific data in the three I<user_data> members.

=item Int $.stamp: a unique stamp to catch invalid iterators
=item Pointer $.user_data: model-specific data
=item Pointer $.user_data2: model-specific data
=item Pointer $.user_data3: model-specific data
=end comment
=end pod

#TT:1:N-GtkTreeIter:
#`{{
class N-GtkTreeIter
  is repr('CPointer')
  is export
  { }
}}

class N-GtkTreeIter is export is repr('CStruct') {
  has int32 $.stamp;
  has Pointer $.userdata1;
  has Pointer $.userdata2;
  has Pointer $.userdata3;

  submethod BUILD ( int32 :$stamp ) {
    $!stamp = $stamp // 0;
  }

  submethod TWEAK (
    :$userdata1 is copy, :$userdata2 is copy, :$userdata3 is copy
  ) {
    $userdata1 //= CArray[int32].new(0);
    $userdata2 //= CArray[int32].new(0);
    $userdata3 //= CArray[int32].new(0);
    $!userdata1 := nativecast( Pointer, $userdata1);
    $!userdata2 := nativecast( Pointer, $userdata2);
    $!userdata3 := nativecast( Pointer, $userdata3);
  }

  method COERCE ( $no --> N-GtkTreeIter ) {
    note "Coercing from {$no.^name} to ", self.^name if $Gnome::N::x-debug;
    nativecast( N-GtkTreeIter, $no)
  }
}


#-------------------------------------------------------------------------------
#has Bool $.tree-iter-is-valid = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=begin comment
=head2 new

Create an object taking the native object from elsewhere. C<.is-valid()> will return True or False depending on the state of the provided object.

  multi method new ( Gnome::Gtk3::TreeIter :$native-object! )

=end comment
=end pod

#TM:4:new(:native-object):
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::TreeIter';

#note"tree iter: ", %options.perl, ', ', self.is-valid();

  if self.is-valid { }

  elsif %options<native-object>:exists or %options<widget>:exists  { }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

#note"Tree iter: ", self._get-native-object.perl(), ', ', self.is-valid;

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkTreeIter');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tree_iter_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
# no shortnames

  self._set-class-name-of-sub('GtkTreeIter');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
# ? no ref/unref for a variant type
method native-object-ref ( $n-native-object ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
  _gtk_tree_iter_free($n-native-object)
}

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_iter_copy:
=begin pod
=head2 [gtk_] tree_iter_copy

Creates a dynamically allocated tree iterator as a copy of I<iter>.

This function is not intended for use in applications, because you can just copy the structures by value like so;

  Gnome::Gtk3::TreeIter $new_iter .= new(
   :native-object($iter._get-native-object())
  );

You must free this iter with C<clear-object()>.

Returns: a newly-allocated copy of I<iter>

  method gtk_tree_iter_copy ( --> N-GtkTreeIter  )

=item N-GtkTreeIter $iter; a B<Gnome::Gtk3::TreeIter>-struct

=end pod

method copy ( --> N-GtkTreeIter ) {
  gtk_tree_iter_copy(self._get-native-object);
}

sub gtk_tree_iter_copy ( N-GtkTreeIter $iter --> N-GtkTreeIter )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#`{{ No document, user must use clear-tree-iter()
# TM:0:gtk_tree_iter_free:
=begin pod
=head2 [gtk_] tree_iter_free

Frees an iterator that has been allocated by C<gtk_tree_iter_copy()>.

This function is mainly used for language bindings.

  method gtk_tree_iter_free ( N-GtkTreeIter $iter )

=item N-GtkTreeIter $iter; a dynamically allocated tree iterator

=end pod
}}

sub _gtk_tree_iter_free ( N-GtkTreeIter $iter )
  is native(&gtk-lib)
  is symbol('gtk_tree_iter_free')
  { * }
