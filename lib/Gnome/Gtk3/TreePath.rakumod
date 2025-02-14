#TL:1:Gnome::Gtk3::TreePath:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TreePath

A struct that specifies a TreePath.


=comment head1 Description
=comment A struct that specifies a TreePath.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TreePath;
  also is Gnome::GObject::Boxed;


=head2 Uml Diagram

![](plantuml/TreePath.svg)


=comment head2 Example

=end pod
#=finish

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Boxed;

# next use statement is a bogus line needed to prevent Raku issuing
# 'Object does not exist in serialization context' when testing TreeSelection
use Gnome::GObject::Object;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::TreePath:auth<github:MARTIMM>;
also is Gnome::GObject::Boxed;
#also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkTreePath
=end pod

#TT:1:N-GtkTreePath:
class N-GtkTreePath
  is repr('CPointer')
  is export
  { }

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new
=head3 default, no options

Create a new default tree path object. This refers to a row.

  multi method new ( )

=head3 :first

Create a new tree path with first index. The string representation of this path is “0”.

  multi method new ( Bool :first! )

=head3 :string

Create a new tree path object using a string. Creates a new B<Gnome::Gtk3::TreePath>-struct initialized to I<$string>.

I<$string> is expected to be a colon separated list of numbers. For example, the string “10:4:0” would create a path of depth 3 pointing to the 11th child of the root node, the 5th child of that 11th child, and the 1st child of that 5th child. If an invalid path string is passed in, the native object is undefined.

  multi method new ( Str :$string! )


=head3 :indices

Create a new tree path object using indices.

  multi method new ( Array :$indices! )


=head3 :native-object

Create an object using a native object from elsewhere.

  multi method new ( N-GtkTreePath :native-object! )


=end pod

#TM:1:new():
#TM:1:new(:first):
#TM:1:new(:string):
#TM:1:new(:indices):
#TM:4:new(:native-object):TopLevelSupportClass
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::TreePath';

  if self.is-valid { }

  elsif %options<native-object>:exists or %options<widget>:exists  { }

  # process all named arguments
  else {
    my $no;

    if ? %options<first> {
      $no = _gtk_tree_path_new_first();
    }

    elsif ? %options<indices> {
      $no = _gtk_tree_path_new_from_indices(|%options<indices>);
    }

    elsif ? %options<string> {
      $no = _gtk_tree_path_new_from_string(%options<string>);
    }

    elsif %options.keys.elems {
      die X::Gnome.new(
        :message('Unsupported options for ' ~ self.^name ~
                 ': ' ~ %options.keys.join(', ')
                )
      );
    }

    else {
      $no = _gtk_tree_path_new();
    }

    self._set-native-object($no);
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkTreePath');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tree_path_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkTreePath');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
# ? no ref/unref for a variant type
method native-object-ref ( $n-native-object --> Any ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
  _gtk_tree_path_free($n-native-object)
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_tree_path_new:new()
#`{{
=begin pod
=head2 [gtk_] tree_path_new

Creates a new B<Gnome::Gtk3::TreePath>-struct. This refers to a row.

Returns: A newly created B<Gnome::Gtk3::TreePath>-struct.

  method gtk_tree_path_new ( --> N-GtkTreePath  )


=end pod
}}

sub _gtk_tree_path_new ( --> N-GtkTreePath )
  is native(&gtk-lib)
  is symbol('gtk_tree_path_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_tree_path_new_from_string:
#`{{
=begin pod
=head2 [[gtk_] tree_path_] new_from_string

Creates a new B<Gnome::Gtk3::TreePath>-struct initialized to I<path>.

I<path> is expected to be a colon separated list of numbers.
For example, the string “10:4:0” would create a path of depth
3 pointing to the 11th child of the root node, the 5th
child of that 11th child, and the 1st child of that 5th child.
If an invalid path string is passed in, C<Any> is returned.

Returns: A newly-created B<Gnome::Gtk3::TreePath>-struct, or C<Any>

  method gtk_tree_path_new_from_string ( Str $path --> N-GtkTreePath  )

=item Str $path; The string representation of a path

=end pod
}}

sub _gtk_tree_path_new_from_string ( Str $path --> N-GtkTreePath )
  is native(&gtk-lib)
  is symbol('gtk_tree_path_new_from_string')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_tree_path_new_from_indices:
#`{{
=begin pod
=head2 [[gtk_] tree_path_] new_from_indices

Creates a new path with I<first_index> and I<varargs> as indices.

Returns: A newly created B<Gnome::Gtk3::TreePath>-struct

  method gtk_tree_path_new_from_indices ( *@indices --> N-GtkTreePath  )

=item Int list of indices

=end pod
}}
sub _gtk_tree_path_new_from_indices ( *@indices --> N-GtkTreePath ) {

  my @parameterList = ();
  for @indices -> Int $i {
    # values not used here
    @parameterList.push(Parameter.new(type => int32));
  }

  # for the last number which must be -1
  @parameterList.push(Parameter.new(type => int32));

  # create signature
  my Signature $signature .= new(
    :params( |@parameterList),
    :returns(N-GtkTreePath)
  );

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_tree_path_new_from_indices', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  $f( |@indices, -1)
}

#`{{ For me, the above function seems good enough
#-------------------------------------------------------------------------------
# TM:0:gtk_tree_path_new_from_indicesv:
=begin pod
=head2 [[gtk_] tree_path_] new_from_indicesv

Creates a new path with the given I<indices> array of I<length>.

Returns: A newly created B<Gnome::Gtk3::TreePath>-struct

  method gtk_tree_path_new_from_indicesv (
    Int $indices, UInt $length --> N-GtkTreePath
  )

=item Int $indices; (array length=length): array of indices
=item UInt $length; length of I<indices> array

=end pod

sub gtk_tree_path_new_from_indicesv ( int32 $indices, uint64 $length --> N-GtkTreePath )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_to_string:
=begin pod
=head2 [[gtk_] tree_path_] to_string

Generates a string representation of the path. This string is a “:” separated list of numbers. For example, “4:10:0:3” would be an acceptable return value for this string.

Returns: A newly-allocated string.
=comment Must be freed with C<g_free()>.

  method gtk_tree_path_to_string ( --> Str  )

=end pod

sub gtk_tree_path_to_string ( N-GtkTreePath $path --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_tree_path_new_first:new(:first)
#`{{
=begin pod
=head2 [[gtk_] tree_path_] new_first

Creates a new B<Gnome::Gtk3::TreePath>-struct. The string representation of this path is “0”.

Returns: A new B<Gnome::Gtk3::TreePath>-struct

  method gtk_tree_path_new_first ( --> N-GtkTreePath  )


=end pod
}}
sub _gtk_tree_path_new_first ( --> N-GtkTreePath )
  is native(&gtk-lib)
  is symbol('gtk_tree_path_new_first')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_append_index:
=begin pod
=head2 [[gtk_] tree_path_] append_index

Appends a new index to a path.

As a result, the depth of the path is increased.

  method gtk_tree_path_append_index ( Int $index )

=item Int $index; the index

=end pod

sub gtk_tree_path_append_index ( N-GtkTreePath $path, int32 $index )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_prepend_index:
=begin pod
=head2 [[gtk_] tree_path_] prepend_index

Prepends a new index to a path.

As a result, the depth of the path is increased.

  method gtk_tree_path_prepend_index ( Int $index )

=item Int $index; the index

=end pod

sub gtk_tree_path_prepend_index ( N-GtkTreePath $path, int32 $index )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_get_depth:
=begin pod
=head2 [[gtk_] tree_path_] get_depth

Returns the current depth of I<path>.

Returns: The depth of I<path>

  method gtk_tree_path_get_depth ( --> Int  )

=end pod

sub gtk_tree_path_get_depth ( N-GtkTreePath $path --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_get_indices:
=begin pod
=head2 [[gtk_] tree_path_] get_indices

Returns the current indices of I<path>.

This is an array of integers, each representing a node in a tree. The length of the array can be obtained with C<gtk_tree_path_get_depth()>.

Returns: An B<Array> of the current indices, or C<Any>

  method gtk_tree_path_get_indices ( --> Array )

=end pod

sub gtk_tree_path_get_indices ( N-GtkTreePath $path --> Array ) {
  my CArray[int32] $ix = _gtk_tree_path_get_indices($path);
  my $l = gtk_tree_path_get_depth($path);
  my Array $ix2 = [];
  loop ( my $i = 0; $i < $l; $i++) {
    $ix2[$i] = $ix[$i];
  }

  $ix2
}

sub _gtk_tree_path_get_indices ( N-GtkTreePath $path --> CArray[int32] )
  is native(&gtk-lib)
  is symbol('gtk_tree_path_get_indices')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_get_indices_with_depth:
=begin pod
=head2 [[gtk_] tree_path_] get_indices_with_depth

Returns the current indices of I<path>.

This is an array of integers, each representing a node in a tree. It also returns the number of elements in the array.

  method gtk_tree_path_get_indices_with_depth ( --> List  )

Returns a list of
=item Int: number of elements returned in the integer array, or C<Any>
=item Array: An Array with the current indices, or C<Any>

=end pod

sub gtk_tree_path_get_indices_with_depth ( N-GtkTreePath $path --> List ) {
  my CArray[int32] $ix = _gtk_tree_path_get_indices_with_depth(
    $path, my int32 $l
  );
  my Array $ix2 = [];
  loop ( my $i = 0; $i < $l; $i++) {
    $ix2[$i] = $ix[$i];
  }

  ( $l, $ix2)
}

sub _gtk_tree_path_get_indices_with_depth (
  N-GtkTreePath $path, int32 $depth is rw
--> CArray[int32] )
  is native(&gtk-lib)
  is symbol('gtk_tree_path_get_indices_with_depth')
  { * }

#-------------------------------------------------------------------------------
#`{{ No document, user must use clear-tree-path()
# TM:0:gtk_tree_path_free:
=begin pod
=head2 [gtk_] tree_path_free

Frees I<path>. If I<path> is C<Any>, it simply returns.

  method gtk_tree_path_free ( )


=end pod
}}
sub _gtk_tree_path_free ( N-GtkTreePath $path )
  is native(&gtk-lib)
  is symbol('gtk_tree_path_free')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_copy:
=begin pod
=head2 [gtk_] tree_path_copy

Creates a new B<Gnome::Gtk3::TreePath>-struct as a copy of I<path>.

Returns: a new B<Gnome::Gtk3::TreePath>-struct

  method gtk_tree_path_copy ( --> N-GtkTreePath  )

=end pod

sub gtk_tree_path_copy ( N-GtkTreePath $path --> N-GtkTreePath )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_compare:
=begin pod
=head2 [gtk_] tree_path_compare

Compares two paths.

If this path appears before path C<$c> in a tree, then -1 is returned.
If C<$c> appears before this node, then 1 is returned.
If this path is equal to C<$c>, then 0 is returned.

Returns: -1, 0 or 1

  method gtk_tree_path_compare ( N-GtkTreePath $c --> Int  )

=item N-GtkTreePath $c; a B<Gnome::Gtk3::TreePath>-struct to compare with

=end pod

sub gtk_tree_path_compare ( N-GtkTreePath $a, N-GtkTreePath $b --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_next:
=begin pod
=head2 [gtk_] tree_path_next

Moves the I<path> to point to the next node at the current depth.

  method gtk_tree_path_next ( )

=end pod

sub gtk_tree_path_next ( N-GtkTreePath $path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_prev:
=begin pod
=head2 [gtk_] tree_path_prev

Moves the I<path> to point to the previous node at the
current depth, if it exists.

Returns: C<1> if I<path> has a previous node, and
the move was made

  method gtk_tree_path_prev ( --> Int  )

=end pod

sub gtk_tree_path_prev ( N-GtkTreePath $path --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_up:
=begin pod
=head2 [gtk_] tree_path_up

Moves the I<path> to point to its parent node, if it has a parent.

Returns: C<1> if I<path> has a parent, and the move was made

  method gtk_tree_path_up ( --> Int  )

=end pod

sub gtk_tree_path_up ( N-GtkTreePath $path --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_down:
=begin pod
=head2 [gtk_] tree_path_down

Moves I<path> to point to the first child of the current path.

  method gtk_tree_path_down ( )

=end pod

sub gtk_tree_path_down ( N-GtkTreePath $path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_is_ancestor:
=begin pod
=head2 [[gtk_] tree_path_] is_ancestor

Returns C<1> if I<$descendant> is a descendant of this path or contained inside.

  method gtk_tree_path_is_ancestor (
    N-GtkTreePath $descendant --> Int
  )

=item N-GtkTreePath $descendant; another B<Gnome::Gtk3::TreePath>-struct

=end pod

sub gtk_tree_path_is_ancestor ( N-GtkTreePath $path, N-GtkTreePath $descendant --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_path_is_descendant:
=begin pod
=head2 [[gtk_] tree_path_] is_descendant

Returns C<1> if this path is a descendant of I<$ancestor> or I<$ancestor> contains this path somewhere below it

  method gtk_tree_path_is_descendant (
    N-GtkTreePath $ancestor --> Int
  )

=item N-GtkTreePath $ancestor; another B<Gnome::Gtk3::TreePath>-struct

=end pod

sub gtk_tree_path_is_descendant ( N-GtkTreePath $path, N-GtkTreePath $ancestor --> int32 )
  is native(&gtk-lib)
  { * }
