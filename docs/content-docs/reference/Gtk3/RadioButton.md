Gnome::Gtk3::RadioButton
========================

A choice from multiple check buttons

![](images/radio-group.png)

Description
===========

A single radio button performs the same basic function as a **Gnome::Gtk3::CheckButton**, as its position in the object hierarchy reflects. It is only when multiple radio buttons are grouped together that they become a different user interface component in their own right.

Every radio button is a member of some group of radio buttons. When one is selected, all other radio buttons in the same group are deselected. A **Gnome::Gtk3::RadioButton** is one way of giving the user a choice from many options.

Css Nodes
---------

    radiobutton
    ├── radio
    ╰── <child>

A **Gnome::Gtk3::RadioButton** with indicator (see `gtk_toggle_button_set_mode()`) has a main CSS node with name radiobutton and a subnode with name radio.

    button.radio
    ├── radio
    ╰── <child>

A **Gnome::Gtk3::RadioButton** without indicator changes the name of its main node to button and adds a .radio style class to it. The subnode is invisible in this case.

When an unselected button in the group is clicked the clicked button receives the *toggled* signal, as does the previously selected button. Inside the *toggled* handler, `gtk_toggle_button_get_active()` can be used to determine if the button has been selected or deselected.

See Also
--------

**Gnome::Gtk3::ComboBox**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::RadioButton;
    also is Gnome::Gtk3::CheckButton;

Uml Diagram
-----------

![](plantuml/RadioButton.svg)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::RadioButton;

    unit class MyGuiClass;
    also is Gnome::Gtk3::RadioButton;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::RadioButton class process the options
      self.bless( :GtkRadioButton, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Example
-------

Create a group with two radio buttons

    # Create a top level window and set a title
    my Gnome::Gtk3::Window $top-window .= new(:title('Two Radio Buttons'));
    $top-window.set-border-width(20);

    # Create a grid and add it to the window
    my Gnome::Gtk3::Grid $grid .= new;
    $top-window.add($grid);

    # Creat the radio buttons
    my Gnome::Gtk3::RadioButton $rb1 .= new(:label('Radio One'));
    my Gnome::Gtk3::RadioButton $rb2 .= new(
      :group-from($rb1), :label('Radio Two')
    );

    # First button selected
    $rb1.set-active(1);

    # Add radio buttons to the grid
    $grid.gtk-grid-attach( $rb1, 0, 0, 1, 1);
    $grid.gtk-grid-attach( $rb2, 0, 1, 1, 1);

    # Show everything and activate all
    $top-window.show-all;

Methods
=======

Creates a new **Gnome::Gtk3::RadioButton**. To be of any practical value, a widget should then be packed into the radio button. This will create a new group.

    multi method new ( )

Create a new object and add to the group defined by the list.

    multi method new (
      Gnome::Glib::SList :$group!, Str :$label!, Bool :$mnemonic = False
    )

Create a new object and add to the group defined by another radio button object.

    multi method new (
      Gnome::Gtk3::RadioButton :$group-from!, Str :$label!,
      Bool :$mnemonic = False
    )

Create a new object with a label.

    multi method new ( Str :$label!, Bool :$mnemonic = False )

Create an object using a native object from elsewhere.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder.

    multi method new ( Str :$build-id! )

get-group, get-group-rk
-----------------------

Retrieves the group assigned to a radio button.

Returns: (element-type GtkRadioButton) : a linked list containing all the radio buttons in the same group as *radio-button*. The returned list is owned by the radio button and must not be modified or freed.

    method get-group ( --> N-GSList )
    method get-group-rk ( --> Gnome::Glib::SList )

join-group
----------

Joins a **Gnome::Gtk3::RadioButton** object to the group of another **Gnome::Gtk3::RadioButton** object

Use this in language bindings instead of the `get-group()` and `gtk-radio-button-set-group()` methods

    method join-group ( N-GObject $group_source )

### Example

A common way to set up a group of radio buttons is the following:

    my Gnome::Gtk3::RadioButton $last-button;
    for @button-labels -> $label {
      my Gnome::Gtk3::RadioButton $radio-button .= new(:$label);
      $radio-button.join_group($last_button) if $last_button.defined;
      $last_button = $radio_button;
    }

  * N-GObject $group_source; a radio button object whos group we are joining, or `undefined` to remove the radio button from its group

set-group
---------

Sets a **Gnome::Gtk3::RadioButton**’s group. It should be noted that this does not change the layout of your interface in any way, so if you are changing the group, it is likely you will need to re-arrange the user interface to reflect these changes.

    method set-group ( N-GSList $group )

  * N-GSList $group; (element-type GtkRadioButton): an existing radio button group, such as one returned from `get-group()`, or `undefined`.

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `connect-object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `connect-object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### group-changed

Emitted when the group of radio buttons that a radio button belongs to changes. This is emitted when a radio button switches from being alone to being part of a group of 2 or more buttons, or vice-versa, and when a button is moved from one group of 2 or more buttons to a different one, but not when the composition of the group that a button belongs to changes.

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($button),
      *%user-options
    );

  * $button; the object which received the signal

  * $_handle_id; the registered event handler id

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **.set-text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.get-property( 'label', $gv);
    $gv.set-string('my text label');

Supported properties
--------------------

### Group: group

Sets a new group for a radio button.Widget type: GTK_TYPE_RADIO_BUTTON

The **Gnome::GObject::Value** type of property *group* is `G_TYPE_OBJECT`.

Property is write only

