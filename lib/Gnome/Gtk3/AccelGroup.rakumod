#TL:1:Gnome::Gtk3::AccelGroup:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AccelGroup

Groups of global keyboard accelerators for an entire B<Gnome::Gtk3::Window>.


=comment ![](images/X.png)


=head1 Description

A B<Gnome::Gtk3::AccelGroup> represents a group of keyboard accelerators, typically attached to a toplevel B<Gnome::Gtk3::Window> (with C<Gnome::Gtk3::Window.add-accel-group()>). Usually you won’t need to create a B<Gnome::Gtk3::AccelGroup> directly; instead you might whish to use B<Gnome::Gtk3::Builder> together with B<Gnome::Gio::Action> and modules using the B<Gnome::Gtk3::Actionable> role.

Note that “accelerators” are different from “mnemonics”. Accelerators are shortcuts for activating a menu item; they appear alongside the menu item they’re a shortcut for. For example “Ctrl+Q” might appear alongside the “Quit” menu item. Mnemonics are shortcuts for GUI elements such as text entries or buttons; they appear as underlined characters. See C<Gnome::Gtk3::Label.new(:mnemonic)>. Menu items can have both accelerators  and mnemonics, of course.


=head2 See Also

C<Gnome::Gtk3::Window.add-accel-group()>, C<Gnome::Gtk3::AccelMap.change-entry()>,


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::AccelGroup;
  also is Gnome::GObject::Object;


=head2 Uml Diagram

![](plantuml/AccelMap-Group.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::AccelGroup;

  unit class MyGuiClass;
  also is Gnome::Gtk3::AccelGroup;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::AccelGroup class process the options
    self.bless( :GtkAccelGroup, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::GObject::Object;
use Gnome::GObject::Closure;

use Gnome::Glib::SList;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::AccelGroup:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkAccelFlags

Accelerator flags used with C<connect()>.

=item GTK-ACCEL-VISIBLE: Accelerator is visible
=item GTK-ACCEL-LOCKED: Accelerator not removable
=item GTK-ACCEL-MASK: Mask
=end pod

#TE:1:GtkAccelFlags:
enum GtkAccelFlags is export (
  'GTK_ACCEL_VISIBLE'        => 1 +< 0,
  'GTK_ACCEL_LOCKED'         => 1 +< 1,
  'GTK_ACCEL_MASK'           => 0x07
);

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkAccelGroup

An object representing and maintaining a group of accelerators.

=end pod

#TT:0:N-GtkAccelGroup:
class N-GtkAccelGroup is export is repr('CStruct') {
  has N-GObject $.parent;
  has GtkAccelGroupPrivate $.priv;
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkAccelKey

=item UInt $.accel-key: The accelerator keyval
=item UInt $.accel-mods:The accelerator modifiers mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=item UInt $.accel-flags: The accelerator flags

=end pod

#TT:1:N-GtkAccelKey:
class N-GtkAccelKey is export is repr('CStruct') {
  has guint $.accel-key;
  has GFlag $.accel-mods;

  # ': 16' means; use 16 bits of a uint, so I take a short
  has guint16 $.accel-flags;
}

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new AccelGroup object.

  multi method new ( )


=head3 :native-object

Create an AccelGroup object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a AccelGroup object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w3<accel-activate accel-changed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::AccelGroup' #`{{ or %options<GtkAccelGroup> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_accel_group_new___x___($no);
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_accel_group_new();
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkAccelGroup');
  }
}

#-------------------------------------------------------------------------------
#TM:1:activate:
=begin pod
=head2 activate

Finds the first accelerator in the I<accel-group> that matches I<$accel-key> and I<$accel-mods>, and activates it.

Returns: C<True> if an accelerator was activated and handled this keypress.

Note: It seems that it always returns False altough the callback is called and finishes without errors.

  method activate (
    UInt $accel-quark, N-GObject() $acceleratable,
    UInt $accel-key, UInt $accel-mods
    --> Bool
  )

=item $accel-quark; the quark for the accelerator name
=item $acceleratable; the B<Gnome::Gtk3::Object>, usually a B<Gnome::Gtk3::Window>, on which to activate the accelerator
=item $accel-key; accelerator keyval from a key event
=item $accel-mods; keyboard state mask from a key event. A mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.

The C<$accel-quark> can be retrieved as follows where the key sequence of the accelerator is C< <ctrl>A >.

  my Gnome::Glib::Quark $quark .= new;
  my Str $accel-name = $ag.accelerator-name( GDK_KEY_A, GDK_CONTROL_MASK);
  my UInt $accel-quark = $quark.from-string($accel-name);
=end pod


method activate (
  UInt $accel-quark, N-GObject() $acceleratable,
  UInt $accel-key, UInt $accel-mods
  --> Bool
) {
  gtk_accel_group_activate(
    self._get-native-object-no-reffing, $accel-quark,
    $acceleratable, $accel-key, $accel-mods
  ).Bool
}

sub gtk_accel_group_activate (
  N-GObject $accel_group, GQuark $accel-quark, N-GObject $acceleratable,
  guint $accel-key, GFlag $accel-mods
  --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:connect:
=begin pod
=head2 connect

Installs an accelerator in this group. When I<accel-group> is being activated in response to a call to C<groups-activate()>, the I<closure> will be invoked if the I<accel-key> and I<accel-mods> from C<groups-activate()> match those of this connection.

The signature used for the I<closure> is that of B<Gnome::Gtk3::AccelGroupActivate>.

Note that, due to implementation details, a single closure can only be connected to one accelerator group.

  method connect (
    UInt $accel-key, UInt $accel-mods,
    UInt $accel_flags, N-GObject() $closure
  )

=item $accel-key; key value of the accelerator
=item $accel-mods; modifier combination of the accelerator. A mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=item $accel_flags; a flag mask to configure this accelerator. A mask from bits of GtkAccelFlags
=item $closure; closure to be executed upon accelerator activation
=end pod

method connect (
  UInt $accel-key, UInt $accel-mods, UInt $accel_flags, N-GObject() $closure
) {
  gtk_accel_group_connect(
    self._get-native-object-no-reffing, $accel-key, $accel-mods, $accel_flags, $closure
  );
}

sub gtk_accel_group_connect (
  N-GObject $accel_group, guint $accel-key, GFlag $accel-mods, GFlag $accel_flags, N-GObject $closure
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:connect-by-path:
=begin pod
=head2 connect-by-path

Installs an accelerator in this group, using an accelerator path to look up the appropriate key and modifiers (see C<Gnome::Gtk3::AccelMap.add-entry()>).

When the I<accel-group> is being activated in response to a call to C<groups-activate()>, I<closure> will be invoked if the I<$accel-key> and I<$accel-mods> from C<groups-activate()> match the key and modifiers for the path.

The signature used for the I<closure> is that of B<Gnome::Gtk3::AccelGroupActivate>.

Note that I<accel-path> string will be stored in a B<Gnome::Gtk3::Quark>. Therefore, if you pass a static string, you can save some memory by interning it first with C<g-intern-static-string()>.

  method connect-by-path ( Str $accel_path, N-GObject() $closure )

=item $accel_path; path used for determining key and modifiers
=item $closure; closure to be executed upon accelerator activation
=end pod

method connect-by-path ( Str $accel_path, N-GObject() $closure ) {
  gtk_accel_group_connect_by_path(
    self._get-native-object-no-reffing, $accel_path, $closure
  );
}

sub gtk_accel_group_connect_by_path (
  N-GObject $accel_group, gchar-ptr $accel_path, N-GObject $closure
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:disconnect:
=begin pod
=head2 disconnect

Removes an accelerator previously installed through C<connect()>.

Returns: C<True> if the closure was found and got disconnected

  method disconnect ( N-GObject() $closure --> Bool )

=item $closure; the closure to remove from this accelerator group, or C<undefined> to remove all closures
=end pod

method disconnect ( N-GObject() $closure --> Bool ) {
  gtk_accel_group_disconnect(
    self._get-native-object-no-reffing, $closure
  ).Bool
}

sub gtk_accel_group_disconnect (
  N-GObject $accel_group, N-GObject $closure --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:disconnect-key:
=begin pod
=head2 disconnect-key

Removes an accelerator previously installed through C<connect()>.

Returns: C<True> if there was an accelerator which could be removed, C<False> otherwise.

  method disconnect-key ( UInt $accel-key, UInt $accel-mods --> Bool )

=item $accel-key; key value of the accelerator
=item $accel-mods; modifier combination of the accelerator. A mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=end pod

method disconnect-key ( UInt $accel-key, UInt $accel-mods --> Bool ) {
  gtk_accel_group_disconnect_key(
    self._get-native-object-no-reffing, $accel-key, $accel-mods
  ).Bool
}

sub gtk_accel_group_disconnect_key (
  N-GObject $accel_group, guint $accel-key, GFlag $accel-mods --> gboolean
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:find:
=begin pod
=head2 find

Finds the first entry in an accelerator group for which I<find-func> returns C<True> and returns its B<Gnome::Gtk3::AccelKey>.

Returns: the key of the first entry passing I<find-func>. The key is owned by GTK+ and must not be freed.

  method find ( GtkAccelGroupFindFunc $find_func, Pointer $data --> N-GtkAccelKey )

=item GtkAccelGroupFindFunc $find_func; (scope call): a function to filter the entries of I<accel-group> with
=item Pointer $data; data to pass to I<find-func>
=end pod

method find (
  GtkAccelGroupFindFunc $find_func, Pointer $data --> N-GtkAccelKey
) {
  gtk_accel_group_find( self._get-native-object-no-reffing, $find_func, $data)
}

sub gtk_accel_group_find (
  N-GObject $accel_group, GtkAccelGroupFindFunc $find_func,
  gpointer $data --> N-GtkAccelKey
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:from-accel-closure:
=begin pod
=head2 from-accel-closure

Finds the B<Gnome::Gtk3::AccelGroup> to which I<closure> is connected; see C<connect()>.

Returns: the B<Gnome::Gtk3::AccelGroup> to which I<closure> is connected, or C<undefined>

  method from-accel-closure ( N-GObject() $closure --> N-GObject )

=item $closure; a B<Gnome::Gtk3::Closure>
=end pod

method from-accel-closure ( N-GObject() $closure --> N-GObject ) {
  $closure .= _get-native-object-no-reffing unless $closure ~~ N-GObject;
  gtk_accel_group_from_accel_closure($closure)
}

method from-accel-closure-rk (
  N-GObject() $closure --> Gnome::Gtk3::AccelGroup
) {
  Gnome::N::deprecate(
    'from-accel-closure-rk', 'coercing from from-accel-closure',
    '0.47.2', '0.50.0'
  );

  Gnome::Gtk3::AccelGroup.new(:native-object(
      gtk_accel_group_from_accel_closure($closure)
    )
  )
}

sub gtk_accel_group_from_accel_closure (
  N-GObject $closure --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-is-locked:
=begin pod
=head2 get-is-locked

Locks are added and removed using C<lock()> and C<unlock()>.

Returns: C<True> if there are 1 or more locks on the I<accel-group>, C<False> otherwise.

  method get-is-locked ( --> Bool )

=end pod

method get-is-locked ( --> Bool ) {
  gtk_accel_group_get_is_locked(self._get-native-object-no-reffing).Bool
}

sub gtk_accel_group_get_is_locked (
  N-GObject $accel_group --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-modifier-mask:
=begin pod
=head2 get-modifier-mask

Gets a mask with bits from enum GdkModifierType found in B<Gnome::Gdk3::Types> representing the mask for this I<accel-group>. For example, modifiers like B<GDK-CONTROL-MASK>, B<GDK-SHIFT-MASK>, etc.

Returns: the modifier mask for this accel group.

  method get-modifier-mask ( --> UInt )

=end pod

method get-modifier-mask ( --> UInt ) {
  gtk_accel_group_get_modifier_mask(self._get-native-object-no-reffing)
}

sub gtk_accel_group_get_modifier_mask (
  N-GObject $accel_group --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:groups-activate:
=begin pod
=head2 groups-activate

Finds the first accelerator in any B<Gnome::Gtk3::AccelGroup> attached to I<$object> that matches I<$accel-key> and I<$accel-mods>, and activates that accelerator.

Returns: C<True> if an accelerator was activated and handled this keypress

  method groups-activate (
    N-GObject() $object, UInt $accel-key, UInt $accel-mods
    --> Bool
  )

=item $object; the widget, usually a B<Gnome::Gtk3::Window>, on which to activate the accelerator.
=item $accel-key; accelerator keyval from a key event.
=item $accel-mods; keyboard state mask from a key event. A mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=end pod

method groups-activate (
  N-GObject() $object, UInt $accel-key, UInt $accel-mods --> Bool
) {
  gtk_accel_groups_activate( $object, $accel-key, $accel-mods).Bool
}

sub gtk_accel_groups_activate (
  N-GObject $object, guint $accel-key, GFlag $accel-mods --> gboolean
) is native(&gtk-lib)
  { * }

#`{{ TODO Object does not seem initialized
(AccelGroup.t:152559): GLib-GObject-CRITICAL **: 14:22:53.267: g_object_ref: assertion 'G_IS_OBJECT (object)' failed

#-------------------------------------------------------------------------------
#TM:0:groups-from-object:
=begin pod
=head2 groups-from-object

Gets a list of all accel groups which are attached to I<object>.

Returns: (element-type GtkAccelGroup) : a list of all accel groups which are attached to I<object>

  method groups-from-object ( N-GObject() $object --> N-GSList )

=item $object; a B<Gnome::Gtk3::Object>, usually a B<Gnome::Gtk3::Window>

The C<-rk> version returns an Array with B<Gnome::Gtk3::AccelGroup> objects.

=end pod

method groups-from-object ( N-GObject() $object --> N-GSList ) {
  gtk_accel_groups_from_object($object)
}

sub gtk_accel_groups_from_object (
  N-GObject $object --> N-GSList
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk-accelerator-get-default-mod-mask:
=begin pod
=head2 accelerator-get-default-mod-mask

Gets the modifier mask.

The modifier mask determines which modifiers are considered significant for keyboard accelerators. See C<gtk-accelerator-set-default-mod-mask()>.

Returns: the default accelerator modifier mask. A mask of GdkModifierType to be found in B<Gnome::Gdk3::Types>.

  method accelerator-get-default-mod-mask ( --> UInt )

=end pod

method accelerator-get-default-mod-mask ( --> UInt ) {
  gtk_accelerator_get_default_mod_mask
}

sub gtk_accelerator_get_default_mod_mask (
   --> GFlag
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:accelerator-get-label:
=begin pod
=head2 accelerator-get-label

Converts an accelerator keyval and modifier mask into a string which can be used to represent the accelerator to the user.

Returns: a newly-allocated string representing the accelerator.

  method accelerator-get-label (
    UInt $accelerator-key, UInt $accelerator-mods --> Str
  )

=item $accelerator-key; accelerator keyval
=item $accelerator-mods; accelerator modifier mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=end pod

method accelerator-get-label (
  UInt $accelerator-key, UInt $accelerator-mods --> Str
) {
  gtk_accelerator_get_label( $accelerator-key, $accelerator-mods)
}

sub gtk_accelerator_get_label (
  guint $accelerator-key, GFlag $accelerator-mods --> gchar-ptr
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:accelerator-get-label-with-keycode:
=begin pod
=head2 accelerator-get-label-with-keycode

Converts an accelerator keyval and modifier mask into a (possibly translated) string that can be displayed to a user, similarly to C<gtk-accelerator-get-label()>, but handling keycodes.

This is only useful for system-level components, applications should use C<accelerator-parse()> instead.

Returns: a string representing the accelerator.

  method accelerator-get-label-with-keycode (
    N-GObject() $display, UInt $accelerator-key,
    UInt $keycode, UInt $accelerator-mods --> Str
  )

=item $display; a B<Gnome::Gtk3::Display> or C<undefined> to use the default display
=item $accelerator-key; accelerator keyval
=item $keycode; accelerator keycode
=item $accelerator-mods; accelerator modifier mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=end pod

method accelerator-get-label-with-keycode (
  N-GObject() $display, UInt $accelerator-key, UInt $keycode,
  UInt $accelerator-mods
  --> Str
) {
  gtk_accelerator_get_label_with_keycode(
    self._get-native-object-no-reffing, $display, $accelerator-key, $keycode, $accelerator-mods
  )
}

sub gtk_accelerator_get_label_with_keycode (
  N-GObject $display, guint $accelerator-key, guint $keycode, GEnum $accelerator-mods --> gchar-ptr
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:accelerator-name:
=begin pod
=head2 accelerator-name

Converts an accelerator keyval and modifier mask into a string parseable by C<gtk-accelerator-parse()>. For example, if you pass in B<Gnome::Gtk3::DK-KEY-q> and B<Gnome::Gtk3::DK-CONTROL-MASK>, this function returns “<Control>q”.

If you need to display accelerators in the user interface, see C<gtk-accelerator-get-label()>.

Returns: a newly-allocated accelerator name

  method accelerator-name (
    UInt $accelerator-key, UInt $accelerator-mods --> Str
  )

=item $accelerator-key; accelerator keyval
=item $accelerator-mods; accelerator modifier mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=end pod

method accelerator-name (
  UInt $accelerator-key, UInt $accelerator-mods --> Str
) {
  gtk_accelerator_name( $accelerator-key, $accelerator-mods)
}

sub gtk_accelerator_name (
  guint $accelerator-key, GFlag $accelerator-mods --> gchar-ptr
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:gtk-accelerator-name-with-keycode:
=begin pod
=head2 gtk-accelerator-name-with-keycode

Converts an accelerator keyval and modifier mask into a string parseable by C<gtk-accelerator-parse-with-keycode()>, similarly to C<gtk-accelerator-name()> but handling keycodes. This is only useful for system-level components, applications should use C<gtk-accelerator-parse()> instead.

Returns: a newly allocated accelerator name.

  method gtk-accelerator-name-with-keycode (
    N-GObject() $display, UInt $accelerator-key,
    UInt $keycode, UInt $accelerator-mods
    --> Str
  )

=item $display; a B<Gnome::Gtk3::Display> or C<undefined> to use the default display
=item $accelerator-key; accelerator keyval
=item $keycode; accelerator keycode
=item $accelerator-mods; accelerator modifier mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=end pod

method gtk-accelerator-name-with-keycode (
  N-GObject() $display, UInt $accelerator-key, UInt $keycode,
  UInt $accelerator-mods
  --> Str
) {
  gtk_accelerator_name_with_keycode(
    self._get-native-object-no-reffing, $display, $accelerator-key, $keycode, $accelerator-mods
  )
}

sub gtk_accelerator_name_with_keycode (
  N-GObject $display, guint $accelerator-key, guint $keycode, GEnum $accelerator-mods --> gchar-ptr
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:accelerator-parse:
=begin pod
=head2 accelerator-parse

Parses a string representing an accelerator. The format looks like “<Control>a” or “<Shift><Alt>F1” or “<Release>z” (the last one is for key release).

The parser is fairly liberal and allows lower or upper case, and also abbreviations such as “<Ctl>” and “<Ctrl>”. Key names are parsed using C<gdk-keyval-from-name()>. For character keys the name is not the symbol, but the lowercase name, e.g. one would use “<Ctrl>minus” instead of “<Ctrl>-”.

If the parse fails, I<accelerator-key> and I<accelerator-mods> will be set to 0 (zero).

  method accelerator-parse ( Str $accelerator --> List )

=item $accelerator; string representing an accelerator

The returned List contains;
=item $accelerator-key; the accelerator keyval, or C<undefined>
=item $accelerator-mods; the accelerator modifier mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>. C<undefined>

Note that many letters are translated to lowercase. So, for example, the string '<Ctrl>A' will not produce C<GDK_KEY_A> but C<GDK_KEY_a> for the returned C<$accelerator-key>. The resulting behaviour however, will be the same.
=end pod

method accelerator-parse ( Str $accelerator --> List ) {
  my guint $accelerator-key;
  my guint $accelerator-mods;
  gtk_accelerator_parse(
    $accelerator, $accelerator-key, $accelerator-mods
  );

  ( $accelerator-key, $accelerator-mods)
}

sub gtk_accelerator_parse (
  gchar-ptr $accelerator, guint $accelerator-key is rw,
  GFlag $accelerator-mods is rw
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk-accelerator-parse-with-keycode:
=begin pod
=head2 gtk-accelerator-parse-with-keycode

Parses a string representing an accelerator, similarly to C<gtk-accelerator-parse()> but handles keycodes as well. This is only useful for system-level components, applications should use C<gtk-accelerator-parse()> instead.

If I<accelerator-codes> is given and the result stored in it is non-C<undefined>, the result must be freed with C<g-free()>.

If a keycode is present in the accelerator and no I<accelerator-codes> is given, the parse will fail.

If the parse fails, I<accelerator-key>, I<accelerator-mods> and I<accelerator-codes> will be set to 0 (zero).

  method gtk-accelerator-parse-with-keycode (
    Str $accelerator --> List
  )

=item $accelerator; string representing an accelerator

The returned List holds;
=item $accelerator-key; the accelerator keyval, or C<undefined>
=item $accelerator-codes; the accelerator keycodes, or C<undefined>
=item $accelerator-mods; the accelerator modifier mask, C<undefined>. A mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=end pod

method gtk-accelerator-parse-with-keycode ( Str $accelerator --> List ) {
  my guint $accelerator-key;
  my guint $accelerator-codes;
  my guint $accelerator-mods;

  gtk_accelerator_parse_with_keycode(
    self._get-native-object-no-reffing, $accelerator, $accelerator-key, $accelerator-codes, $accelerator-mods
  );
}

sub gtk_accelerator_parse_with_keycode (
  gchar-ptr $accelerator, guint $accelerator-key is rw,
  guint $accelerator-codes is rw, GFlag $accelerator-mods is rw
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:accelerator-set-default-mod-mask:
=begin pod
=head2 accelerator-set-default-mod-mask

Sets the modifiers that will be considered significant for keyboard accelerators. The default mod mask depends on the GDK backend in use, but will typically include B<Gnome::Gtk3::DK-CONTROL-MASK> | B<Gnome::Gtk3::DK-SHIFT-MASK> | B<Gnome::Gtk3::DK-MOD1-MASK> | B<Gnome::Gtk3::DK-SUPER-MASK> | B<Gnome::Gtk3::DK-HYPER-MASK> | B<Gnome::Gtk3::DK-META-MASK>. In other words, Control, Shift, Alt, Super, Hyper and Meta. Other modifiers will by default be ignored by B<Gnome::Gtk3::AccelGroup>.

You must include at least the three modifiers Control, Shift and Alt in any value you pass to this function.

The default mod mask should be changed on application startup, before using any accelerator groups.

  method accelerator-set-default-mod-mask ( UInt $default_mod_mask )

=item $default_mod_mask; accelerator modifier mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=end pod

method accelerator-set-default-mod-mask ( UInt $default_mod_mask ) {
  gtk_accelerator_set_default_mod_mask($default_mod_mask);
}

sub gtk_accelerator_set_default_mod_mask (
  GEnum $default_mod_mask
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:lock:
=begin pod
=head2 lock

Locks the given accelerator group.

Locking an acelerator group prevents the accelerators contained within it to be changed during runtime. Refer to C<Gnome::Gtk3::Map.change-entry()> about runtime accelerator changes.

If called more than once, I<accel-group> remains locked until C<unlock()> has been called an equivalent number of times.

  method lock ( )

=end pod

method lock ( ) {
  gtk_accel_group_lock(self._get-native-object-no-reffing);
}

sub gtk_accel_group_lock (
  N-GObject $accel_group
) is native(&gtk-lib)
  { * }

#`{{
from https://docs.gtk.org/gtk3/struct.AccelGroupEntry.html

struct GtkAccelGroupEntry {
  GtkAccelKey key;
  GClosure* closure;
  GQuark accel_path_quark;
}

#-------------------------------------------------------------------------------
#TM:0:query:
=begin pod
=head2 query

Queries an accelerator group for all entries matching I<accel-key> and I<accel-mods>.

Returns:   (array length=n-entries): an array of I<n-entries> B<Gnome::Gtk3::AccelGroupEntry> elements, or C<undefined>. The array is owned by GTK+ and must not be freed.

  method query (
    UInt $accel-key, UInt $accel-mods, guInt-ptr $n_entries
    --> GtkAccelGroupEntry
  )

=item $accel-key; key value of the accelerator
=item $accel-mods; modifier combination of the accelerator. A mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=item $n_entries; location to return the number of entries found, or C<undefined>
=end pod

method query ( UInt $accel-key, UInt $accel-mods, guInt-ptr $n_entries --> GtkAccelGroupEntry ) {
  my guint $accelerator-key;
  my guint $accelerator-codes;
  my guint $accelerator-mods;


  gtk_accel_group_query(
    self._get-native-object-no-reffing, $accel-key, $accel-mods, $n_entries
  )
}

sub gtk_accel_group_query (
  N-GObject $accel_group, guint $accel-key, GFlag $accel-mods, gugint-ptr $n_entries --> GtkAccelGroupEntry
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:unlock:
=begin pod
=head2 unlock

Undoes the last call to C<lock()> on this I<accel-group>.

  method unlock ( )

=end pod

method unlock ( ) {
  gtk_accel_group_unlock(self._get-native-object-no-reffing);
}

sub gtk_accel_group_unlock (
  N-GObject $accel_group
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_accel_group_new:
#`{{
=begin pod
=head2 _gtk_accel_group_new

Creates a new B<Gnome::Gtk3::AccelGroup>.

Returns: a new B<Gnome::Gtk3::AccelGroup> object

  method _gtk_accel_group_new ( --> N-GObject )

=end pod
}}

sub _gtk_accel_group_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_accel_group_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=comment -----------------------------------------------------------------------
=comment #TS:1:accel-activate:
=head2 accel-activate

The accel-activate signal is an implementation detail of
B<Gnome::Gtk3::AccelGroup> and not meant to be used by applications.

Returns: C<True> if the accelerator was activated

  method handler (
    N-GObject $acceleratable,
    UInt $keyval,
    UInt #`{ GdkModifierType flags from Gnome::Gdk3::Window } $modifier,
    Gnome::Gtk3::AccelGroup :_widget($accel_group),
    Int :$_handler_id,
    N-GObject :$_native-object,
    *%user-options

    --> Bool
  );

=item $acceleratable; the object on which the accelerator was activated
=item $keyval; the accelerator keyval
=item $modifier; the modifier combination of the accelerator
=item $accel_group; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:accel-changed:
=head2 accel-changed

The accel-changed signal is emitted when an entry is added to or removed from the accel group.

Widgets like B<Gnome::Gtk3::AccelLabel> which display an associated accelerator should connect to this signal, and rebuild their visual representation if the I<accel-closure> is theirs.

  method handler (
    UInt $keyval,
    UInt #`{ GdkModifierType flags from Gnome::Gdk3::Window } $modifier,
    N-GObject #`{ native Gnome::GObject::Closure } $accel_closure,
    Gnome::Gtk3::AccelGroup :_widget($accel_group),
    Int :$_handle_id,
    *%user-options
  );

=item $keyval; the accelerator keyval
=item $modifier; the modifier combination of the accelerator
=item $accel_closure; the B<Gnome::Gtk3::Closure> of the accelerator
=item $accel_group; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod
