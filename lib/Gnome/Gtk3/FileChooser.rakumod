#TL:1:Gnome::Gtk3::FileChooser:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::FileChooser

=SUBTITLE File chooser interface used by Gnome::Gtk3::FileChooserWidget and Gnome::Gtk3::FileChooserDialog

=head1 Description

I<Gnome::Gtk3::FileChooser> is an interface that can be implemented by file selection widgets. In GTK+, the main objects that implement this interface are I<Gnome::Gtk3::FileChooserWidget>, I<Gnome::Gtk3::FileChooserDialog>, and I<Gnome::Gtk3::FileChooserButton>. You do not need to write an object that implements the I<Gnome::Gtk3::FileChooser> interface unless you are trying to adapt an existing file selector to expose a standard programming interface.

I<Gnome::Gtk3::FileChooser> allows for shortcuts to various places in the filesystem. In the default implementation these are displayed in the left pane. It may be a bit confusing at first that these shortcuts come from various sources and in various flavours, so lets explain the terminology here:

=item Bookmarks: are created by the user, by dragging folders from the right pane to the left pane, or by using the “Add”. Bookmarks can be renamed and deleted by the user.

=item Shortcuts: can be provided by the application. For example, a Paint program may want to add a shortcut for a Clipart folder. Shortcuts cannot be modified by the user.

=item Volumes: are provided by the underlying filesystem abstraction. They are the “roots” of the filesystem.

=head2 File Names and Encodings

When the user is finished selecting files in a I<Gnome::Gtk3::FileChooser>, your program can get the selected names either as filenames or as URIs. For URIs, the normal escaping rules are applied if the URI contains non-ASCII characters. However, filenames are always returned in the character set specified by the `G_FILENAME_ENCODING` environment variable. Please see the GLib documentation for more details about this variable.

This means that while you can pass the result of C<.get-filename()> to Raku C<IO>, you may not be able to directly set it as the text of a I<Gnome::Gtk3::Label> widget unless you convert it first to UTF-8, which all GTK+ widgets expect. You should use C<g_filename_to_utf8()> to convert filenames into strings that can be passed to GTK+ widgets. B<Note: open() and fopen() are C functions which are not needed by the Raku user. Furthermore, the Str Raku type is already UTF-8>.

=begin comment
=head2 Adding a Preview Widget

You can add a custom preview widget to a file chooser and then get notification about when the preview needs to be updated. To install a preview widget, use C<.set_preview_widget()>. Then, connect to the prop I<update-preview> signal to get notified when you need to update the contents of the preview.

Your callback should use C<gtk_file_chooser_get_preview_filename()> to see what needs previewing. Once you have generated the preview for the corresponding file, you must call C<gtk_file_chooser_set_preview_widget_active()> with a boolean flag (B<Int for Raku>) that indicates whether your callback could successfully generate a preview.

## Example: Using a Preview Widget ## {I<gtkfilechooser>-preview}
|[<!-- language="C" -->
{
  B<Gnome::Gtk3::Image> *preview;

  ...

  preview = C<gtk_image_new()>;

  gtk_file_chooser_set_preview_widget (my_file_chooser, preview);
  g_signal_connect (my_file_chooser, "update-preview",
		    G_CALLBACK (update_preview_cb), preview);
}

static void
update_preview_cb (B<Gnome::Gtk3::FileChooser> *file_chooser, gpointer data)
{
  B<Gnome::Gtk3::Widget> *preview;
  char *filename;
  B<Gnome::Gdk3::Pixbuf> *pixbuf;
  gboolean have_preview;

  preview = GTK_WIDGET (data);
  filename = gtk_file_chooser_get_preview_filename (file_chooser);

  pixbuf = gdk_pixbuf_new_from_file_at_size (filename, 128, 128, NULL);
  have_preview = (pixbuf != NULL);
  g_free (filename);

  gtk_image_set_from_pixbuf (GTK_IMAGE (preview), pixbuf);
  if (pixbuf)
    g_object_unref (pixbuf);

  gtk_file_chooser_set_preview_widget_active (file_chooser, have_preview);
}
]|
=end comment


=head2 Adding Extra Widgets

You can add extra widgets to a file chooser to provide options that are not present in the default design. For example, you can add a toggle button to give the user the option to open a file in read-only mode. You can use C<.set-extra-widget()> to insert additional widgets in a file chooser.

=begin comment
An example for adding extra widgets:
|[<!-- language="C" -->

  B<Gnome::Gtk3::Widget> *toggle;

  ...

  toggle = gtk_check_button_new_with_label ("Open file read-only");
  gtk_widget_show (toggle);
  gtk_file_chooser_set_extra_widget (my_file_chooser, toggle);
}
]|
=end comment

If you want to set more than one extra widget in the file chooser, you can a container such as a I<Gnome::Gtk3::Box> or a I<Gnome::Gtk3::Grid> and include your widgets in it. Then, set the container as the whole extra widget.


=head2 See Also

I<Gnome::Gtk3::FileChooserDialog>, I<Gnome::Gtk3::FileChooserWidget>, I<Gnome::Gtk3::FileChooserButton>


=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::FileChooser;
  also is Gnome::GObject::Object;


=head2 Example to show how to get filenames from the dialog

  my Gnome::Gtk3::FileChooserDialog $file-select-dialog .= new(
    :build-id($target-widget-name)
  );

  # get-filenames() is from FileChooser class
  my Gnome::Glib::SList $fnames .= new(
    :native-object($file-select-dialog.get-filenames)
  );

  my @files-to-process = ();
  for ^$fnames.g-slist-length -> $i {
    @files-to-process.push($fnames.nth-data-str($i));
  }

  # get the file and directory names
  for @files-to-process -> $file {
    note "Process $file";
  };

  $fnames.g-slist-free;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::Error;
use Gnome::Glib::SList;

use Gnome::GObject::Object;
#use Gnome::Gtk3::FileFilter;

#-------------------------------------------------------------------------------
# Note that enums must be kept outside roles
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkFileChooserAction

Describes whether a I<Gnome::Gtk3::FileChooser> is being used to open existing files or to save to a possibly new file.

=item GTK_FILE_CHOOSER_ACTION_OPEN: Indicates open mode. The file chooser will only let the user pick an existing file.
=item GTK_FILE_CHOOSER_ACTION_SAVE: Indicates save mode. The file chooser will let the user pick an existing file, or type in a new filename.
=item GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER: Indicates an Open mode for selecting folders. The file chooser will let the user pick an existing folder.
=item GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER: Indicates a mode for creating a new folder. The file chooser will let the user name an existing or new folder.

=end pod

#TE:2:GtkFileChooserAction:t/FileChooserDialog.t
enum GtkFileChooserAction is export (
  'GTK_FILE_CHOOSER_ACTION_OPEN',
  'GTK_FILE_CHOOSER_ACTION_SAVE',
  'GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER',
  'GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkFileChooserConfirmation

Used as a return value of handlers for the prop I<confirm-overwrite> signal of a I<Gnome::Gtk3::FileChooser>. This value determines whether the file chooser will present the stock confirmation dialog, accept the user’s choice of a filename, or let the user choose another filename.

Since: 2.8

=item GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM: The file chooser will present its stock dialog to confirm about overwriting an existing file.
=item GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME: The file chooser will terminate and accept the user’s choice of a file name.
=item GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN: The file chooser will continue running, so as to let the user select another file name.

=end pod

#TE:0:GtkFileChooserConfirmation:
enum GtkFileChooserConfirmation is export (
  'GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM',
  'GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME',
  'GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkFileChooserError

These identify the various errors that can occur while calling I<Gnome::Gtk3::FileChooser> functions.

=item GTK_FILE_CHOOSER_ERROR_NONEXISTENT: Indicates that a file does not exist.
=item GTK_FILE_CHOOSER_ERROR_BAD_FILENAME: Indicates a malformed filename.
=item GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS: Indicates a duplicate path (e.g. when adding a bookmark).
=item GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME: Indicates an incomplete hostname (e.g. "http://foo" without a slash after that).

=end pod

#TE:0:GtkFileChooserError:
enum GtkFileChooserError is export (
  'GTK_FILE_CHOOSER_ERROR_NONEXISTENT',
  'GTK_FILE_CHOOSER_ERROR_BAD_FILENAME',
  'GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS',
  'GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME'
);

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkfilechooser.h
# https://developer.gnome.org/gtk3/stable/GtkFileChooser.html
unit role Gnome::Gtk3::FileChooser:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#-------------------------------------------------------------------------------
#TM:2:new():interfacing:t/FileChooserDialog.t
# interfaces are not instantiated
#submethod BUILD ( *%options ) { }

#-------------------------------------------------------------------------------
# setup signals from interface
method _add_file_chooser_signal_types ( Str $class-name ) {

  self.add-signal-types( $class-name,
    :w0< current-folder-changed file-activated selection-changed
         update-preview confirm-overwrite
       >,
  );
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
# Hook for modules using this interface. Same principle as _fallback but
# does not need callsame. Also this method must be usable without
# an instated object
method _file_chooser_interface ( Str $native-sub --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_file_chooser_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_file_chooser_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('file-chooser-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-file-chooser-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  $s
}


#-------------------------------------------------------------------------------
#TM:0:add-choice:
=begin pod
=head2 add-choice

Adds a 'choice' to the file chooser. This is typically implemented as a combobox or, for boolean choices, as a checkbutton. You can select a value using C<set_choice()> before the dialog is shown, and you can obtain the user-selected value in the I<response> signal handler using C<get-choice()>.

Compare C<set-extra-widget()>.

  method add-choice ( Str $id, Str $label, CArray[Str] $options, CArray[Str] $option_labels )

=item $id; id for the added choice
=item $label; user-visible label for the added choice
=item $options; ids for the options of the choice, or C<undefined> for a boolean choice
=item $option_labels; user-visible labels for the options, must be the same length as I<options>
=end pod

method add-choice ( Str $id, Str $label, CArray[Str] $options, CArray[Str] $option_labels ) {
  gtk_file_chooser_add_choice( self._f('GtkFileChooser'), $id, $label, $options, $option_labels);
}

sub gtk_file_chooser_add_choice (
  N-GObject $chooser, gchar-ptr $id, gchar-ptr $label, gchar-pptr $options, gchar-pptr $option_labels
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-filter:
=begin pod
=head2 add-filter

Adds I<filter> to the list of filters that the user can select between. When a filter is selected, only files that are passed by that filter are displayed.

Note that the I<chooser> takes ownership of the filter, so you have to ref and sink it if you want to keep a reference.

  method add-filter ( N-GObject() $filter )

=item $filter; a B<Gnome::Gtk3::FileFilter>
=end pod

method add-filter ( N-GObject() $filter ) {
  gtk_file_chooser_add_filter( self._f('GtkFileChooser'), $filter);
}

sub gtk_file_chooser_add_filter (
  N-GObject $chooser, N-GObject $filter
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-shortcut-folder:
=begin pod
=head2 add-shortcut-folder

Adds a folder to be displayed with the shortcut folders in a file chooser. Note that shortcut folders do not get saved, as they are provided by the application. For example, you can use this to add a “/usr/share/mydrawprogram/Clipart” folder to the volume list.

Returns: C<True> if the folder could be added successfully, C<False> otherwise. In the latter case, the I<error> will be set as appropriate.

  method add-shortcut-folder ( Str $folder, N-GError $error --> Bool )

=item $folder; (type filename): filename of the folder to add
=item $error; location to store error, or C<undefined>
=end pod

method add-shortcut-folder ( Str $folder, $error is copy --> Bool ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_file_chooser_add_shortcut_folder( self._f('GtkFileChooser'), $folder, $error).Bool
}

sub gtk_file_chooser_add_shortcut_folder (
  N-GObject $chooser, gchar-ptr $folder, N-GError $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-shortcut-folder-uri:
=begin pod
=head2 add-shortcut-folder-uri

Adds a folder URI to be displayed with the shortcut folders in a file chooser. Note that shortcut folders do not get saved, as they are provided by the application. For example, you can use this to add a “file:///usr/share/mydrawprogram/Clipart” folder to the volume list.

Returns: C<True> if the folder could be added successfully, C<False> otherwise. In the latter case, the I<error> will be set as appropriate.

  method add-shortcut-folder-uri ( Str $uri, N-GError $error --> Bool )

=item $uri; URI of the folder to add
=item $error; location to store error, or C<undefined>
=end pod

method add-shortcut-folder-uri ( Str $uri, $error is copy --> Bool ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_file_chooser_add_shortcut_folder_uri( self._f('GtkFileChooser'), $uri, $error).Bool
}

sub gtk_file_chooser_add_shortcut_folder_uri (
  N-GObject $chooser, gchar-ptr $uri, N-GError $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:error-quark:
=begin pod
=head2 error-quark

Registers an error quark for B<Gnome::Gtk3::FileChooser> if necessary.

Returns: The error quark used for B<Gnome::Gtk3::FileChooser> errors.

  method error-quark ( --> UInt )

=end pod

method error-quark ( --> UInt ) {
  gtk_file_chooser_error_quark( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_error_quark (
   --> GQuark
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-action:
=begin pod
=head2 get-action

Gets the type of operation that the file chooser is performing; see C<set_action()>.

Returns: the action that the file selector is performing

  method get-action ( --> GtkFileChooserAction )

=end pod

method get-action ( --> GtkFileChooserAction ) {
  GtkFileChooserAction(gtk_file_chooser_get_action( self._f('GtkFileChooser')))
}

sub gtk_file_chooser_get_action (
  N-GObject $chooser --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-choice:
=begin pod
=head2 get-choice

Gets the currently selected option in the 'choice' with the given ID.

Returns: the ID of the currenly selected option

  method get-choice ( Str $id --> Str )

=item $id; the ID of the choice to get
=end pod

method get-choice ( Str $id --> Str ) {
  gtk_file_chooser_get_choice( self._f('GtkFileChooser'), $id)
}

sub gtk_file_chooser_get_choice (
  N-GObject $chooser, gchar-ptr $id --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-create-folders:
=begin pod
=head2 get-create-folders

Gets whether file choser will offer to create new folders. See C<set_create_folders()>.

Returns: C<True> if the Create Folder button should be displayed.

  method get-create-folders ( --> Bool )

=end pod

method get-create-folders ( --> Bool ) {
  gtk_file_chooser_get_create_folders( self._f('GtkFileChooser')).Bool
}

sub gtk_file_chooser_get_create_folders (
  N-GObject $chooser --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-current-folder:
=begin pod
=head2 get-current-folder

Gets the current folder of I<chooser> as a local filename. See C<set_current_folder()>.

Note that this is the folder that the file chooser is currently displaying (e.g. "/home/username/Documents"), which is not the same as the currently-selected folder if the chooser is in C<GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER> mode (e.g. "/home/username/Documents/selected-folder/". To get the currently-selected folder in that mode, use C<get_uri()> as the usual way to get the selection.

Returns:  (type filename): the full path of the current folder, or C<undefined> if the current path cannot be represented as a local filename. Free with C<g_free()>. This function will also return C<undefined> if the file chooser was unable to load the last folder that was requested from it; for example, as would be for calling C<set_current_folder()> on a nonexistent folder.

  method get-current-folder ( --> Str )

=end pod

method get-current-folder ( --> Str ) {
  gtk_file_chooser_get_current_folder( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_current_folder (
  N-GObject $chooser --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-current-folder-file:
=begin pod
=head2 get-current-folder-file

Gets the current folder of I<chooser> as B<Gnome::Gio::File>. See C<get_current_folder_uri()>.

Returns: the B<Gnome::Gio::File> for the current folder.

  method get-current-folder-file ( --> N-GObject )

=end pod

method get-current-folder-file ( --> N-GObject ) {
  gtk_file_chooser_get_current_folder_file( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_current_folder_file (
  N-GObject $chooser --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-current-folder-uri:
=begin pod
=head2 get-current-folder-uri

Gets the current folder of I<chooser> as an URI. See C<set_current_folder_uri()>.

Note that this is the folder that the file chooser is currently displaying (e.g. "file:///home/username/Documents"), which is not the same as the currently-selected folder if the chooser is in C<GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER> mode (e.g. "file:///home/username/Documents/selected-folder/". To get the currently-selected folder in that mode, use C<get_uri()> as the usual way to get the selection.

Returns: the URI for the current folder. Free with C<g_free()>. This function will also return C<undefined> if the file chooser was unable to load the last folder that was requested from it; for example, as would be for calling C<set_current_folder_uri()> on a nonexistent folder.

  method get-current-folder-uri ( --> Str )

=end pod

method get-current-folder-uri ( --> Str ) {
  gtk_file_chooser_get_current_folder_uri( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_current_folder_uri (
  N-GObject $chooser --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-current-name:
=begin pod
=head2 get-current-name

Gets the current name in the file selector, as entered by the user in the text entry for “Name”.

This is meant to be used in save dialogs, to get the currently typed filename when the file itself does not exist yet. For example, an application that adds a custom extra widget to the file chooser for “file format” may want to change the extension of the typed filename based on the chosen format, say, from “.jpg” to “.png”.

Returns: The raw text from the file chooser’s “Name” entry. Free this with C<g_free()>. Note that this string is not a full pathname or URI; it is whatever the contents of the entry are. Note also that this string is in UTF-8 encoding, which is not necessarily the system’s encoding for filenames.

  method get-current-name ( --> Str )

=end pod

method get-current-name ( --> Str ) {
  gtk_file_chooser_get_current_name( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_current_name (
  N-GObject $chooser --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-do-overwrite-confirmation:
=begin pod
=head2 get-do-overwrite-confirmation

Queries whether a file chooser is set to confirm for overwriting when the user types a file name that already exists.

Returns: C<True> if the file chooser will present a confirmation dialog; C<False> otherwise.

  method get-do-overwrite-confirmation ( --> Bool )

=end pod

method get-do-overwrite-confirmation ( --> Bool ) {
  gtk_file_chooser_get_do_overwrite_confirmation( self._f('GtkFileChooser')).Bool
}

sub gtk_file_chooser_get_do_overwrite_confirmation (
  N-GObject $chooser --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-extra-widget:
=begin pod
=head2 get-extra-widget

Gets the current extra widget; see C<set_extra_widget()>.

Returns: the current extra widget, or C<undefined>

  method get-extra-widget ( --> N-GObject )

=end pod

method get-extra-widget ( --> N-GObject ) {
  gtk_file_chooser_get_extra_widget( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_extra_widget (
  N-GObject $chooser --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-file:
=begin pod
=head2 get-file

Gets the B<Gnome::Gio::File> for the currently selected file in the file selector. If multiple files are selected, one of the files will be returned at random.

If the file chooser is in folder mode, this function returns the selected folder.

Returns: a selected B<Gnome::Gio::File>. You own the returned file; use C<g_object_unref()> to release it.

  method get-file ( --> N-GObject )

=end pod

method get-file ( --> N-GObject ) {
  gtk_file_chooser_get_file( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_file (
  N-GObject $chooser --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-filename:
=begin pod
=head2 get-filename

Gets the filename for the currently selected file in the file selector. The filename is returned as an absolute path. If multiple files are selected, one of the filenames will be returned at random.

If the file chooser is in folder mode, this function returns the selected folder.

Returns:  (type filename): The currently selected filename, or C<undefined> if no file is selected, or the selected file can't be represented with a local filename. Free with C<g_free()>.

  method get-filename ( --> Str )

=end pod

method get-filename ( --> Str ) {
  gtk_file_chooser_get_filename( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_filename (
  N-GObject $chooser --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-filenames:
=begin pod
=head2 get-filenames

Lists all the selected files and subfolders in the current folder of I<chooser>. The returned names are full absolute paths. If files in the current folder cannot be represented as local filenames they will be ignored. (See C<get_uris()>)

Returns: (element-type filename) : a B<Gnome::Gio::SList> containing the filenames of all selected files and subfolders in the current folder. Free the returned list with C<g_slist_free()>, and the filenames with C<g_free()>.

  method get-filenames ( --> N-GSList )

=end pod

method get-filenames ( --> N-GSList ) {
  gtk_file_chooser_get_filenames( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_filenames (
  N-GObject $chooser --> N-GSList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-files:
=begin pod
=head2 get-files

Lists all the selected files and subfolders in the current folder of I<chooser> as B<Gnome::Gio::File>. An internal function, see C<get_uris()>.

Returns: (element-type GFile) : a B<Gnome::Gio::SList> containing a B<Gnome::Gio::File> for each selected file and subfolder in the current folder. Free the returned list with C<g_slist_free()>, and the files with C<g_object_unref()>.

  method get-files ( --> N-GSList )

=end pod

method get-files ( --> N-GSList ) {
  gtk_file_chooser_get_files( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_files (
  N-GObject $chooser --> N-GSList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-filter:
=begin pod
=head2 get-filter

Gets the current filter; see C<set_filter()>.

Returns: the current filter, or C<undefined>

  method get-filter ( --> N-GObject )

=end pod

method get-filter ( --> N-GObject ) {
  gtk_file_chooser_get_filter( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_filter (
  N-GObject $chooser --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-local-only:
=begin pod
=head2 get-local-only

Gets whether only local files can be selected in the file selector. See C<set_local_only()>

Returns: C<True> if only local files can be selected.

  method get-local-only ( --> Bool )

=end pod

method get-local-only ( --> Bool ) {
  gtk_file_chooser_get_local_only( self._f('GtkFileChooser')).Bool
}

sub gtk_file_chooser_get_local_only (
  N-GObject $chooser --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-preview-file:
=begin pod
=head2 get-preview-file

Gets the B<Gnome::Gio::File> that should be previewed in a custom preview Internal function, see C<get_preview_uri()>.

Returns: the B<Gnome::Gio::File> for the file to preview, or C<undefined> if no file is selected. Free with C<g_object_unref()>.

  method get-preview-file ( --> N-GObject )

=end pod

method get-preview-file ( --> N-GObject ) {
  gtk_file_chooser_get_preview_file( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_preview_file (
  N-GObject $chooser --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-preview-filename:
=begin pod
=head2 get-preview-filename

Gets the filename that should be previewed in a custom preview widget. See C<set_preview_widget()>.

Returns:  (type filename): the filename to preview, or C<undefined> if no file is selected, or if the selected file cannot be represented as a local filename. Free with C<g_free()>

  method get-preview-filename ( --> Str )

=end pod

method get-preview-filename ( --> Str ) {
  gtk_file_chooser_get_preview_filename( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_preview_filename (
  N-GObject $chooser --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-preview-uri:
=begin pod
=head2 get-preview-uri

Gets the URI that should be previewed in a custom preview widget. See C<set_preview_widget()>.

Returns: the URI for the file to preview, or C<undefined> if no file is selected. Free with C<g_free()>.

  method get-preview-uri ( --> Str )

=end pod

method get-preview-uri ( --> Str ) {
  gtk_file_chooser_get_preview_uri( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_preview_uri (
  N-GObject $chooser --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-preview-widget:
=begin pod
=head2 get-preview-widget

Gets the current preview widget; see C<set_preview_widget()>.

Returns: the current preview widget, or C<undefined>

  method get-preview-widget ( --> N-GObject )

=end pod

method get-preview-widget ( --> N-GObject ) {
  gtk_file_chooser_get_preview_widget( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_preview_widget (
  N-GObject $chooser --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-preview-widget-active:
=begin pod
=head2 get-preview-widget-active

Gets whether the preview widget set by C<set_preview_widget()> should be shown for the current filename. See C<set_preview_widget_active()>.

Returns: C<True> if the preview widget is active for the current filename.

  method get-preview-widget-active ( --> Bool )

=end pod

method get-preview-widget-active ( --> Bool ) {
  gtk_file_chooser_get_preview_widget_active( self._f('GtkFileChooser')).Bool
}

sub gtk_file_chooser_get_preview_widget_active (
  N-GObject $chooser --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-select-multiple:
=begin pod
=head2 get-select-multiple

Gets whether multiple files can be selected in the file selector. See C<set_select_multiple()>.

Returns: C<True> if multiple files can be selected.

  method get-select-multiple ( --> Bool )

=end pod

method get-select-multiple ( --> Bool ) {
  gtk_file_chooser_get_select_multiple( self._f('GtkFileChooser')).Bool
}

sub gtk_file_chooser_get_select_multiple (
  N-GObject $chooser --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-show-hidden:
=begin pod
=head2 get-show-hidden

Gets whether hidden files and folders are displayed in the file selector. See C<set_show_hidden()>.

Returns: C<True> if hidden files and folders are displayed.

  method get-show-hidden ( --> Bool )

=end pod

method get-show-hidden ( --> Bool ) {
  gtk_file_chooser_get_show_hidden( self._f('GtkFileChooser')).Bool
}

sub gtk_file_chooser_get_show_hidden (
  N-GObject $chooser --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-uri:
=begin pod
=head2 get-uri

Gets the URI for the currently selected file in the file selector. If multiple files are selected, one of the filenames will be returned at random.

If the file chooser is in folder mode, this function returns the selected folder.

Returns: The currently selected URI, or C<undefined> if no file is selected. If C<set_local_only()> is set to C<True> (the default) a local URI will be returned for any FUSE locations. Free with C<g_free()>

  method get-uri ( --> Str )

=end pod

method get-uri ( --> Str ) {
  gtk_file_chooser_get_uri( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_uri (
  N-GObject $chooser --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-uris:
=begin pod
=head2 get-uris

Lists all the selected files and subfolders in the current folder of I<chooser>. The returned names are full absolute URIs.

Returns: (element-type utf8) : a B<Gnome::Gio::SList> containing the URIs of all selected files and subfolders in the current folder. Free the returned list with C<g_slist_free()>, and the filenames with C<g_free()>.

  method get-uris ( --> N-GSList )

=end pod

method get-uris ( --> N-GSList ) {
  gtk_file_chooser_get_uris( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_get_uris (
  N-GObject $chooser --> N-GSList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-use-preview-label:
=begin pod
=head2 get-use-preview-label

Gets whether a stock label should be drawn with the name of the previewed file. See C<set_use_preview_label()>.

Returns: C<True> if the file chooser is set to display a label with the name of the previewed file, C<False> otherwise.

  method get-use-preview-label ( --> Bool )

=end pod

method get-use-preview-label ( --> Bool ) {
  gtk_file_chooser_get_use_preview_label( self._f('GtkFileChooser')).Bool
}

sub gtk_file_chooser_get_use_preview_label (
  N-GObject $chooser --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:list-filters:
=begin pod
=head2 list-filters

Lists the current set of user-selectable filters; see C<add_filter()>, C<remove_filter()>.

Returns: (element-type GtkFileFilter) (transfer container): a B<Gnome::Gio::SList> containing the current set of user selectable filters. The contents of the list are owned by GTK+, but you must free the list itself with C<g_slist_free()> when you are done with it.

  method list-filters ( --> N-GSList )

=end pod

method list-filters ( --> N-GSList ) {
  gtk_file_chooser_list_filters( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_list_filters (
  N-GObject $chooser --> N-GSList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:list-shortcut-folder-uris:
=begin pod
=head2 list-shortcut-folder-uris

Queries the list of shortcut folders in the file chooser, as set by C<add_shortcut_folder_uri()>.

Returns:  (element-type utf8) : A list of folder URIs, or C<undefined> if there are no shortcut folders. Free the returned list with C<g_slist_free()>, and the URIs with C<g_free()>.

  method list-shortcut-folder-uris ( --> N-GSList )

=end pod

method list-shortcut-folder-uris ( --> N-GSList ) {
  gtk_file_chooser_list_shortcut_folder_uris( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_list_shortcut_folder_uris (
  N-GObject $chooser --> N-GSList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:list-shortcut-folders:
=begin pod
=head2 list-shortcut-folders

Queries the list of shortcut folders in the file chooser, as set by C<add_shortcut_folder()>.

Returns:  (element-type filename) : A list of folder filenames, or C<undefined> if there are no shortcut folders. Free the returned list with C<g_slist_free()>, and the filenames with C<g_free()>.

  method list-shortcut-folders ( --> N-GSList )

=end pod

method list-shortcut-folders ( --> N-GSList ) {
  gtk_file_chooser_list_shortcut_folders( self._f('GtkFileChooser'))
}

sub gtk_file_chooser_list_shortcut_folders (
  N-GObject $chooser --> N-GSList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-choice:
=begin pod
=head2 remove-choice

Removes a 'choice' that has been added with C<add_choice()>.

  method remove-choice ( Str $id )

=item $id; the ID of the choice to remove
=end pod

method remove-choice ( Str $id ) {
  gtk_file_chooser_remove_choice( self._f('GtkFileChooser'), $id);
}

sub gtk_file_chooser_remove_choice (
  N-GObject $chooser, gchar-ptr $id
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-filter:
=begin pod
=head2 remove-filter

Removes I<filter> from the list of filters that the user can select between.

  method remove-filter ( N-GObject() $filter )

=item $filter; a B<Gnome::Gtk3::FileFilter>
=end pod

method remove-filter ( N-GObject() $filter ) {
  gtk_file_chooser_remove_filter( self._f('GtkFileChooser'), $filter);
}

sub gtk_file_chooser_remove_filter (
  N-GObject $chooser, N-GObject $filter
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-shortcut-folder:
=begin pod
=head2 remove-shortcut-folder

Removes a folder from a file chooser’s list of shortcut folders.

Returns: C<True> if the operation succeeds, C<False> otherwise. In the latter case, the I<error> will be set as appropriate.

See also: C<add_shortcut_folder()>

  method remove-shortcut-folder ( Str $folder, N-GError $error --> Bool )

=item $folder; (type filename): filename of the folder to remove
=item $error; location to store error, or C<undefined>
=end pod

method remove-shortcut-folder ( Str $folder, $error is copy --> Bool ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_file_chooser_remove_shortcut_folder( self._f('GtkFileChooser'), $folder, $error).Bool
}

sub gtk_file_chooser_remove_shortcut_folder (
  N-GObject $chooser, gchar-ptr $folder, N-GError $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-shortcut-folder-uri:
=begin pod
=head2 remove-shortcut-folder-uri

Removes a folder URI from a file chooser’s list of shortcut folders.

Returns: C<True> if the operation succeeds, C<False> otherwise. In the latter case, the I<error> will be set as appropriate.

See also: C<add_shortcut_folder_uri()>

  method remove-shortcut-folder-uri ( Str $uri, N-GError $error --> Bool )

=item $uri; URI of the folder to remove
=item $error; location to store error, or C<undefined>
=end pod

method remove-shortcut-folder-uri ( Str $uri, $error is copy --> Bool ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_file_chooser_remove_shortcut_folder_uri( self._f('GtkFileChooser'), $uri, $error).Bool
}

sub gtk_file_chooser_remove_shortcut_folder_uri (
  N-GObject $chooser, gchar-ptr $uri, N-GError $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:select-all:
=begin pod
=head2 select-all

Selects all the files in the current folder of a file chooser.

  method select-all ( )

=end pod

method select-all ( ) {
  gtk_file_chooser_select_all( self._f('GtkFileChooser'));
}

sub gtk_file_chooser_select_all (
  N-GObject $chooser
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:select-file:
=begin pod
=head2 select-file

Selects the file referred to by I<file>. An internal function. See C<_select_uri()>.

Returns: Not useful.

  method select-file ( N-GObject() $file, N-GError $error --> Bool )

=item $file; the file to select
=item $error; location to store error, or C<undefined>
=end pod

method select-file ( N-GObject() $file, $error is copy --> Bool ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_file_chooser_select_file( self._f('GtkFileChooser'), $file, $error).Bool
}

sub gtk_file_chooser_select_file (
  N-GObject $chooser, N-GObject $file, N-GError $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:select-filename:
=begin pod
=head2 select-filename

Selects a filename. If the file name isn’t in the current folder of I<chooser>, then the current folder of I<chooser> will be changed to the folder containing I<filename>.

Returns: Not useful.

See also: C<set_filename()>

  method select-filename ( Str $filename --> Bool )

=item $filename; (type filename): the filename to select
=end pod

method select-filename ( Str $filename --> Bool ) {
  gtk_file_chooser_select_filename( self._f('GtkFileChooser'), $filename).Bool
}

sub gtk_file_chooser_select_filename (
  N-GObject $chooser, gchar-ptr $filename --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:select-uri:
=begin pod
=head2 select-uri

Selects the file to by I<uri>. If the URI doesn’t refer to a file in the current folder of I<chooser>, then the current folder of I<chooser> will be changed to the folder containing I<filename>.

Returns: Not useful.

  method select-uri ( Str $uri --> Bool )

=item $uri; the URI to select
=end pod

method select-uri ( Str $uri --> Bool ) {
  gtk_file_chooser_select_uri( self._f('GtkFileChooser'), $uri).Bool
}

sub gtk_file_chooser_select_uri (
  N-GObject $chooser, gchar-ptr $uri --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-action:
=begin pod
=head2 set-action

Sets the type of operation that the chooser is performing; the user interface is adapted to suit the selected action. For example, an option to create a new folder might be shown if the action is C<GTK_FILE_CHOOSER_ACTION_SAVE> but not if the action is C<GTK_FILE_CHOOSER_ACTION_OPEN>.

  method set-action ( GtkFileChooserAction $action )

=item $action; the action that the file selector is performing
=end pod

method set-action ( GtkFileChooserAction $action ) {
  gtk_file_chooser_set_action( self._f('GtkFileChooser'), $action);
}

sub gtk_file_chooser_set_action (
  N-GObject $chooser, GEnum $action
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-choice:
=begin pod
=head2 set-choice

Selects an option in a 'choice' that has been added with C<add_choice()>. For a boolean choice, the possible options are "true" and "false".

  method set-choice ( Str $id, Str $option )

=item $id; the ID of the choice to set
=item $option; the ID of the option to select
=end pod

method set-choice ( Str $id, Str $option ) {
  gtk_file_chooser_set_choice( self._f('GtkFileChooser'), $id, $option);
}

sub gtk_file_chooser_set_choice (
  N-GObject $chooser, gchar-ptr $id, gchar-ptr $option
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-create-folders:
=begin pod
=head2 set-create-folders

Sets whether file choser will offer to create new folders. This is only relevant if the action is not set to be C<GTK_FILE_CHOOSER_ACTION_OPEN>.

  method set-create-folders ( Bool $create_folders )

=item $create_folders; C<True> if the Create Folder button should be displayed
=end pod

method set-create-folders ( Bool $create_folders ) {
  gtk_file_chooser_set_create_folders( self._f('GtkFileChooser'), $create_folders);
}

sub gtk_file_chooser_set_create_folders (
  N-GObject $chooser, gboolean $create_folders
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-current-folder:
=begin pod
=head2 set-current-folder

Sets the current folder for I<chooser> from a local filename. The user will be shown the full contents of the current folder, plus user interface elements for navigating to other folders.

In general, you should not use this function. See the [section on setting up a file chooser dialog][gtkfilechooserdialog-setting-up] for the rationale behind this.

Returns: Not useful.

  method set-current-folder ( Str $filename --> Bool )

=item $filename; (type filename): the full path of the new current folder
=end pod

method set-current-folder ( Str $filename --> Bool ) {
  gtk_file_chooser_set_current_folder( self._f('GtkFileChooser'), $filename).Bool
}

sub gtk_file_chooser_set_current_folder (
  N-GObject $chooser, gchar-ptr $filename --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-current-folder-file:
=begin pod
=head2 set-current-folder-file

Sets the current folder for I<chooser> from a B<Gnome::Gio::File>. Internal function, see C<set_current_folder_uri()>.

Returns: C<True> if the folder could be changed successfully, C<False> otherwise.

  method set-current-folder-file ( N-GObject() $file, N-GError $error --> Bool )

=item $file; the B<Gnome::Gio::File> for the new folder
=item $error; location to store error, or C<undefined>.
=end pod

method set-current-folder-file ( N-GObject() $file, $error is copy --> Bool ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_file_chooser_set_current_folder_file( self._f('GtkFileChooser'), $file, $error).Bool
}

sub gtk_file_chooser_set_current_folder_file (
  N-GObject $chooser, N-GObject $file, N-GError $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-current-folder-uri:
=begin pod
=head2 set-current-folder-uri

Sets the current folder for I<chooser> from an URI. The user will be shown the full contents of the current folder, plus user interface elements for navigating to other folders.

In general, you should not use this function. See the [section on setting up a file chooser dialog][gtkfilechooserdialog-setting-up] for the rationale behind this.

Returns: C<True> if the folder could be changed successfully, C<False> otherwise.

  method set-current-folder-uri ( Str $uri --> Bool )

=item $uri; the URI for the new current folder
=end pod

method set-current-folder-uri ( Str $uri --> Bool ) {
  gtk_file_chooser_set_current_folder_uri( self._f('GtkFileChooser'), $uri).Bool
}

sub gtk_file_chooser_set_current_folder_uri (
  N-GObject $chooser, gchar-ptr $uri --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-current-name:
=begin pod
=head2 set-current-name

Sets the current name in the file selector, as if entered by the user. Note that the name passed in here is a UTF-8 string rather than a filename. This function is meant for such uses as a suggested name in a “Save As...” dialog. You can pass “Untitled.doc” or a similarly suitable suggestion for the I<name>.

If you want to preselect a particular existing file, you should use C<set_filename()> or C<set_uri()> instead. Please see the documentation for those functions for an example of using C<set_current_name()> as well.

  method set-current-name ( Str $name )

=item $name; (type utf8): the filename to use, as a UTF-8 string
=end pod

method set-current-name ( Str $name ) {
  gtk_file_chooser_set_current_name( self._f('GtkFileChooser'), $name);
}

sub gtk_file_chooser_set_current_name (
  N-GObject $chooser, gchar-ptr $name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-do-overwrite-confirmation:
=begin pod
=head2 set-do-overwrite-confirmation

Sets whether a file chooser in C<GTK_FILE_CHOOSER_ACTION_SAVE> mode will present a confirmation dialog if the user types a file name that already exists. This is C<False> by default.

If set to C<True>, the I<chooser> will emit the I<confirm-overwrite> signal when appropriate.

If all you need is the stock confirmation dialog, set this property to C<True>. You can override the way confirmation is done by actually handling the I<confirm-overwrite> signal; please refer to its documentation for the details.

  method set-do-overwrite-confirmation ( Bool $do_overwrite_confirmation )

=item $do_overwrite_confirmation; whether to confirm overwriting in save mode
=end pod

method set-do-overwrite-confirmation ( Bool $do_overwrite_confirmation ) {
  gtk_file_chooser_set_do_overwrite_confirmation( self._f('GtkFileChooser'), $do_overwrite_confirmation);
}

sub gtk_file_chooser_set_do_overwrite_confirmation (
  N-GObject $chooser, gboolean $do_overwrite_confirmation
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-extra-widget:
=begin pod
=head2 set-extra-widget

Sets an application-supplied widget to provide extra options to the user.

  method set-extra-widget ( N-GObject() $extra_widget )

=item $extra_widget; widget for extra options
=end pod

method set-extra-widget ( N-GObject() $extra_widget ) {
  gtk_file_chooser_set_extra_widget( self._f('GtkFileChooser'), $extra_widget);
}

sub gtk_file_chooser_set_extra_widget (
  N-GObject $chooser, N-GObject $extra_widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-file:
=begin pod
=head2 set-file

Sets I<file> as the current filename for the file chooser, by changing to the file’s parent folder and actually selecting the file in list. If the I<chooser> is in C<GTK_FILE_CHOOSER_ACTION_SAVE> mode, the file’s base name will also appear in the dialog’s file name entry.

If the file name isn’t in the current folder of I<chooser>, then the current folder of I<chooser> will be changed to the folder containing I<filename>. This is equivalent to a sequence of C<unselect_all()> followed by C<select_filename()>.

Note that the file must exist, or nothing will be done except for the directory change.

If you are implementing a save dialog, you should use this function if you already have a file name to which the user may save; for example, when the user opens an existing file and then does Save As...

=begin comment
If you don’t have a file name already for example, if the user just created a new file and is saving it for the first time, do not call this function. Instead, use something similar to this:
|[<!-- language="C" -->
if (document_is_new) {
  // the user just created a new document
  set_current_folder_file (chooser, default_file_for_saving);
  set_current_name (chooser, "Untitled document");
}
else {
  // the user edited an existing document
  set_file (chooser, existing_file);
}
]|
=end comment

Returns: An error object. It is valid when the call fails.

  method set-file ( N-GObject() $file --> N-GError )

=item $file; the B<Gnome::Gio::File> to set as the current file.
=end pod

method set-file ( N-GObject() $file --> N-GError ) {
  my $error = CArray[N-GError].new(N-GError.new);
  gtk_file_chooser_set_file(
    self._f('GtkFileChooser'), $file, $error
  ).Bool;

  $error[0];
}

sub gtk_file_chooser_set_file (
  N-GObject $chooser, N-GObject $file, CArray[N-GError] $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-filename:
=begin pod
=head2 set-filename

Sets I<filename> as the current filename for the file chooser, by changing to the file’s parent folder and actually selecting the file in list; all other files will be unselected. If the I<chooser> is in C<GTK_FILE_CHOOSER_ACTION_SAVE> mode, the file’s base name will also appear in the dialog’s file name entry.

Note that the file must exist, or nothing will be done except for the directory change.

You should use this function only when implementing a save dialog for which you already have a file name to which the user may save. For example, when the user opens an existing file and then does Save As... to save a copy or a modified version. If you don’t have a file name already — for example, if the user just created a new file and is saving it for the first time, do not call this function. Instead, use something similar to this: |[<!-- language="C" --> if (document_is_new) { // the user just created a new document set_current_name (chooser, "Untitled document"); } else { // the user edited an existing document set_filename (chooser, existing_filename); } ]|

In the first case, the file chooser will present the user with useful suggestions as to where to save his new file. In the second case, the file’s existing location is already known, so the file chooser will use it.

Returns: Not useful.

  method set-filename ( Str $filename --> Bool )

=item $filename; (type filename): the filename to set as current
=end pod

method set-filename ( Str $filename --> Bool ) {
  gtk_file_chooser_set_filename( self._f('GtkFileChooser'), $filename).Bool
}

sub gtk_file_chooser_set_filename (
  N-GObject $chooser, gchar-ptr $filename --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-filter:
=begin pod
=head2 set-filter

Sets the current filter; only the files that pass the filter will be displayed. If the user-selectable list of filters is non-empty, then the filter should be one of the filters in that list. Setting the current filter when the list of filters is empty is useful if you want to restrict the displayed set of files without letting the user change it.

  method set-filter ( N-GObject() $filter )

=item $filter; a B<Gnome::Gtk3::FileFilter>
=end pod

method set-filter ( N-GObject() $filter ) {
  gtk_file_chooser_set_filter( self._f('GtkFileChooser'), $filter);
}

sub gtk_file_chooser_set_filter (
  N-GObject $chooser, N-GObject $filter
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-local-only:
=begin pod
=head2 set-local-only

Sets whether only local files can be selected in the file selector. If I<local_only> is C<True> (the default), then the selected file or files are guaranteed to be accessible through the operating systems native file system and therefore the application only needs to worry about the filename functions in B<Gnome::Gtk3::FileChooser>, like C<get_filename()>, rather than the URI functions like C<get_uri()>,

On some systems non-native files may still be available using the native filesystem via a userspace filesystem (FUSE).

  method set-local-only ( Bool $local_only )

=item $local_only; C<True> if only local files can be selected
=end pod

method set-local-only ( Bool $local_only ) {
  gtk_file_chooser_set_local_only( self._f('GtkFileChooser'), $local_only);
}

sub gtk_file_chooser_set_local_only (
  N-GObject $chooser, gboolean $local_only
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-preview-widget:
=begin pod
=head2 set-preview-widget

Sets an application-supplied widget to use to display a custom preview of the currently selected file. To implement a preview, after setting the preview widget, you connect to the I<update-preview> signal, and call C<get_preview_filename()> or C<get_preview_uri()> on each change. If you can display a preview of the new file, update your widget and set the preview active using C<set_preview_widget_active()>. Otherwise, set the preview inactive.

When there is no application-supplied preview widget, or the application-supplied preview widget is not active, the file chooser will display no preview at all.

  method set-preview-widget ( N-GObject() $preview_widget )

=item $preview_widget; widget for displaying preview.
=end pod

method set-preview-widget ( N-GObject() $preview_widget ) {
  gtk_file_chooser_set_preview_widget( self._f('GtkFileChooser'), $preview_widget);
}

sub gtk_file_chooser_set_preview_widget (
  N-GObject $chooser, N-GObject $preview_widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-preview-widget-active:
=begin pod
=head2 set-preview-widget-active

Sets whether the preview widget set by C<set_preview_widget()> should be shown for the current filename. When I<active> is set to false, the file chooser may display an internally generated preview of the current file or it may display no preview at all. See C<set_preview_widget()> for more details.

  method set-preview-widget-active ( Bool $active )

=item $active; whether to display the user-specified preview widget
=end pod

method set-preview-widget-active ( Bool $active ) {
  gtk_file_chooser_set_preview_widget_active( self._f('GtkFileChooser'), $active);
}

sub gtk_file_chooser_set_preview_widget_active (
  N-GObject $chooser, gboolean $active
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-select-multiple:
=begin pod
=head2 set-select-multiple

Sets whether multiple files can be selected in the file selector. This is only relevant if the action is set to be C<GTK_FILE_CHOOSER_ACTION_OPEN> or C<GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER>.

  method set-select-multiple ( Bool $select_multiple )

=item $select_multiple; C<True> if multiple files can be selected.
=end pod

method set-select-multiple ( Bool $select_multiple ) {
  gtk_file_chooser_set_select_multiple( self._f('GtkFileChooser'), $select_multiple);
}

sub gtk_file_chooser_set_select_multiple (
  N-GObject $chooser, gboolean $select_multiple
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-show-hidden:
=begin pod
=head2 set-show-hidden

Sets whether hidden files and folders are displayed in the file selector.

  method set-show-hidden ( Bool $show_hidden )

=item $show_hidden; C<True> if hidden files and folders should be displayed.
=end pod

method set-show-hidden ( Bool $show_hidden ) {
  gtk_file_chooser_set_show_hidden( self._f('GtkFileChooser'), $show_hidden);
}

sub gtk_file_chooser_set_show_hidden (
  N-GObject $chooser, gboolean $show_hidden
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-uri:
=begin pod
=head2 set-uri

Sets the file referred to by I<uri> as the current file for the file chooser, by changing to the URI’s parent folder and actually selecting the URI in the list. If the I<chooser> is C<GTK_FILE_CHOOSER_ACTION_SAVE> mode, the URI’s base name will also appear in the dialog’s file name entry.

Note that the URI must exist, or nothing will be done except for the directory change.

You should use this function only when implementing a save dialog for which you already have a file name to which the user may save. For example, when the user opens an existing file and then does Save As... to save a copy or a modified version. If you don’t have a file name already — for example, if the user just created a new file and is saving it for the first time, do not call this function. Instead, use something similar to this: |[<!-- language="C" --> if (document_is_new) { // the user just created a new document set_current_name (chooser, "Untitled document"); } else { // the user edited an existing document set_uri (chooser, existing_uri); } ]|

 In the first case, the file chooser will present the user with useful suggestions as to where to save his new file. In the second case, the file’s existing location is already known, so the file chooser will use it.

Returns: Not useful.

  method set-uri ( Str $uri --> Bool )

=item $uri; the URI to set as current
=end pod

method set-uri ( Str $uri --> Bool ) {
  gtk_file_chooser_set_uri( self._f('GtkFileChooser'), $uri).Bool
}

sub gtk_file_chooser_set_uri (
  N-GObject $chooser, gchar-ptr $uri --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-use-preview-label:
=begin pod
=head2 set-use-preview-label

Sets whether the file chooser should display a stock label with the name of the file that is being previewed; the default is C<True>. Applications that want to draw the whole preview area themselves should set this to C<False> and display the name themselves in their preview widget.

See also: C<set_preview_widget()>

  method set-use-preview-label ( Bool $use_label )

=item $use_label; whether to display a stock label with the name of the previewed file
=end pod

method set-use-preview-label ( Bool $use_label ) {
  gtk_file_chooser_set_use_preview_label( self._f('GtkFileChooser'), $use_label);
}

sub gtk_file_chooser_set_use_preview_label (
  N-GObject $chooser, gboolean $use_label
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unselect-all:
=begin pod
=head2 unselect-all

Unselects all the files in the current folder of a file chooser.

  method unselect-all ( )

=end pod

method unselect-all ( ) {
  gtk_file_chooser_unselect_all( self._f('GtkFileChooser'));
}

sub gtk_file_chooser_unselect_all (
  N-GObject $chooser
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unselect-file:
=begin pod
=head2 unselect-file

Unselects the file referred to by I<file>. If the file is not in the current directory, does not exist, or is otherwise not currently selected, does nothing.

  method unselect-file ( N-GObject() $file )

=item $file; a B<Gnome::Gio::File>
=end pod

method unselect-file ( N-GObject() $file ) {
  gtk_file_chooser_unselect_file( self._f('GtkFileChooser'), $file);
}

sub gtk_file_chooser_unselect_file (
  N-GObject $chooser, N-GObject $file
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unselect-filename:
=begin pod
=head2 unselect-filename

Unselects a currently selected filename. If the filename is not in the current directory, does not exist, or is otherwise not currently selected, does nothing.

  method unselect-filename ( Str $filename )

=item $filename; (type filename): the filename to unselect
=end pod

method unselect-filename ( Str $filename ) {
  gtk_file_chooser_unselect_filename( self._f('GtkFileChooser'), $filename);
}

sub gtk_file_chooser_unselect_filename (
  N-GObject $chooser, gchar-ptr $filename
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unselect-uri:
=begin pod
=head2 unselect-uri

Unselects the file referred to by I<uri>. If the file is not in the current directory, does not exist, or is otherwise not currently selected, does nothing.

  method unselect-uri ( Str $uri )

=item $uri; the URI to unselect
=end pod

method unselect-uri ( Str $uri ) {
  gtk_file_chooser_unselect_uri( self._f('GtkFileChooser'), $uri);
}

sub gtk_file_chooser_unselect_uri (
  N-GObject $chooser, gchar-ptr $uri
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:confirm-overwrite:
=head2 confirm-overwrite

This signal gets emitted whenever it is appropriate to present a
confirmation dialog when the user has selected a file name that
already exists.  The signal only gets emitted when the file
chooser is in C<GTK_FILE_CHOOSER_ACTION_SAVE> mode.

Most applications just need to turn on the
I<do-overwrite-confirmation> property (or call the
C<set_do_overwrite_confirmation()> function), and
they will automatically get a stock confirmation dialog.
Applications which need to customize this behavior should do
that, and also connect to the I<confirm-overwrite>
signal.

A signal handler for this signal must return a
B<Gnome::Gtk3::FileChooserConfirmation> value, which indicates the action to
take.  If the handler determines that the user wants to select a
different filename, it should return
C<GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN>.  If it determines
that the user is satisfied with his choice of file name, it
should return C<GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME>.
On the other hand, if it determines that the stock confirmation
dialog should be used, it should return
C<GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM>. The following example
illustrates this.

## Custom confirmation ## {B<gtkfilechooser>-confirmation}

|[<!-- language="C" -->
static GtkFileChooserConfirmation
confirm_overwrite_callback (GtkFileChooser *chooser, gpointer data)
{
char *uri;

uri = get_uri (chooser);

if (is_uri_read_only (uri))
{
if (user_wants_to_replace_read_only_file (uri))
return GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME;
else
return GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN;
} else
return GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM; // fall back to the default dialog
}

...

chooser = dialog_new (...);

set_do_overwrite_confirmation (GTK_FILE_CHOOSER (dialog), TRUE);
g_signal_connect (chooser, "confirm-overwrite",
G_CALLBACK (confirm_overwrite_callback), NULL);

if (gtk_dialog_run (chooser) == GTK_RESPONSE_ACCEPT)
save_to_file (get_filename (GTK_FILE_CHOOSER (chooser));

gtk_widget_destroy (chooser);
]|

Returns: a B<Gnome::Gtk3::FileChooserConfirmation> value that indicates which
action to take after emitting the signal.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options

    --> Unknown type: GTK_TYPE_FILE_CHOOSER_CONFIRMATION
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:current-folder-changed:
=head2 current-folder-changed

This signal is emitted when the current folder in a B<Gnome::Gtk3::FileChooser>
changes.  This can happen due to the user performing some action that
changes folders, such as selecting a bookmark or visiting a folder on the
file list.  It can also happen as a result of calling a function to
explicitly change the current folder in a file chooser.

Normally you do not need to connect to this signal, unless you need to keep
track of which folder a file chooser is showing.

See also:  C<set_current_folder()>,
C<get_current_folder()>,
C<set_current_folder_uri()>,
C<get_current_folder_uri()>.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:file-activated:
=head2 file-activated

This signal is emitted when the user "activates" a file in the file
chooser.  This can happen by double-clicking on a file in the file list, or
by pressing `Enter`.

Normally you do not need to connect to this signal.  It is used internally
by B<Gnome::Gtk3::FileChooserDialog> to know when to activate the default button in the
dialog.

See also: C<get_filename()>,
C<get_filenames()>, C<get_uri()>,
C<get_uris()>.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:selection-changed:
=head2 selection-changed

This signal is emitted when there is a change in the set of selected files
in a B<Gnome::Gtk3::FileChooser>.  This can happen when the user modifies the selection
with the mouse or the keyboard, or when explicitly calling functions to
change the selection.

Normally you do not need to connect to this signal, as it is easier to wait
for the file chooser to finish running, and then to get the list of
selected files using the functions mentioned below.

See also: C<select_filename()>,
C<unselect_filename()>, C<get_filename()>,
C<get_filenames()>, C<select_uri()>,
C<unselect_uri()>, C<get_uri()>,
C<get_uris()>.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:update-preview:
=head2 update-preview

This signal is emitted when the preview in a file chooser should be
regenerated.  For example, this can happen when the currently selected file
changes.  You should use this signal if you want your file chooser to have
a preview widget.

Once you have installed a preview widget with
C<set_preview_widget()>, you should update it when this
signal is emitted.  You can use the functions
C<get_preview_filename()> or
C<get_preview_uri()> to get the name of the file to preview.
Your widget may not be able to preview all kinds of files; your callback
must call C<set_preview_widget_active()> to inform the file
chooser about whether the preview was generated successfully or not.

Please see the example code in
[Using a Preview Widget][gtkfilechooser-preview].

See also: C<set_preview_widget()>,
C<set_preview_widget_active()>,
C<set_use_preview_label()>,
C<get_preview_filename()>,
C<get_preview_uri()>.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:action:
=head2 action

The type of operation that the file selector is performing

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item The type of this G_TYPE_ENUM object is GTK_TYPE_FILE_CHOOSER_ACTION
=item Parameter is readable and writable.
=item Default value is GTK_FILE_CHOOSER_ACTION_OPEN.


=comment -----------------------------------------------------------------------
=comment #TP:0:create-folders:
=head2 create-folders

Whether a file chooser not in open mode will offer the user to create new folders.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:do-overwrite-confirmation:
=head2 do-overwrite-confirmation

Whether a file chooser in save mode will present an overwrite confirmation dialog if necessary.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:extra-widget:
=head2 extra-widget

Application supplied widget for extra options.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is GTK_TYPE_WIDGET
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:filter:
=head2 filter

The current filter for selecting which files are displayed

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is GTK_TYPE_FILE_FILTER
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:local-only:
=head2 local-only

Whether the selected file(s should be limited to local file: URLs)

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:preview-widget:
=head2 preview-widget

Application supplied widget for custom previews.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is GTK_TYPE_WIDGET
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:preview-widget-active:
=head2 preview-widget-active

Whether the application supplied widget for custom previews should be shown.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:select-multiple:
=head2 select-multiple

Whether to allow multiple files to be selected

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:show-hidden:
=head2 show-hidden

Whether the hidden files and folders should be displayed

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:use-preview-label:
=head2 use-preview-label

Whether to display a stock label with the name of the previewed file.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is TRUE.

=end pod




























=finish
#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_error_quark:
=begin pod
=head2 [[gtk_] file_chooser_] error_quark

Returns: The error quark used for I<Gnome::Gtk3::FileChooser> errors.

Since: 2.4

  method gtk_file_chooser_error_quark ( --> int32  )

=end pod

sub gtk_file_chooser_error_quark (  )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_file_chooser_set_action:t/FileChooserDialog.t
=begin pod
=head2 [[gtk_] file_chooser_] set_action

Sets the type of operation that the chooser is performing; the user interface is adapted to suit the selected action. For example, an option to create a new folder might be shown if the action is C<GTK_FILE_CHOOSER_ACTION_SAVE> but not if the action is C<GTK_FILE_CHOOSER_ACTION_OPEN>.

Since: 2.4

  method gtk_file_chooser_set_action ( GtkFileChooserAction $action )

=item GtkFileChooserAction $action; the action that the file selector is performing

=end pod

sub gtk_file_chooser_set_action ( N-GObject $chooser, int32 $action )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_file_chooser_get_action:t/FileChooserDialog.t
=begin pod
=head2 [[gtk_] file_chooser_] get_action

Gets the type of operation that the file chooser is performing; see C<gtk_file_chooser_set_action()>.

Returns: the action that the file selector is performing

Since: 2.4

  method gtk_file_chooser_get_action ( --> GtkFileChooserAction )

=end pod

sub gtk_file_chooser_get_action ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_file_chooser_set_local_only:t/FileChooserDialog.t
=begin pod
=head2 [[gtk_] file_chooser_] set_local_only

Sets whether only local files can be selected in the file selector. If I<$local_only> is C<1> (the default), then the selected file or files are guaranteed to be accessible through the operating systems native file system and therefore the application only needs to worry about the filename functions in I<Gnome::Gtk3::FileChooser>, like C<gtk_file_chooser_get_filename()>, rather than the URI functions like C<gtk_file_chooser_get_uri()>,

On some systems non-native files may still be available using the native filesystem via a userspace filesystem (FUSE).

Since: 2.4

  method gtk_file_chooser_set_local_only ( Int $local_only )

=item Int $local_only; C<1> if only local files can be selected

=end pod

sub gtk_file_chooser_set_local_only ( N-GObject $chooser, int32 $local_only )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_file_chooser_get_local_only:t/FileChooserDialog.t
=begin pod
=head2 [[gtk_] file_chooser_] get_local_only

Gets whether only local files can be selected in the file selector. See C<gtk_file_chooser_set_local_only()>

Returns: C<1> if only local files can be selected.

Since: 2.4

  method gtk_file_chooser_get_local_only ( --> Int )

=end pod

sub gtk_file_chooser_get_local_only ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_select_multiple:
=begin pod
=head2 [[gtk_] file_chooser_] set_select_multiple

Sets whether multiple files can be selected in the file selector.  This is
only relevant if the action is set to be C<GTK_FILE_CHOOSER_ACTION_OPEN> or
C<GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER>.

Since: 2.4

  method gtk_file_chooser_set_select_multiple ( Int $select_multiple )

=item Int $select_multiple; C<1> if multiple files can be selected.

=end pod

sub gtk_file_chooser_set_select_multiple ( N-GObject $chooser, int32 $select_multiple )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_select_multiple:
=begin pod
=head2 [[gtk_] file_chooser_] get_select_multiple

Gets whether multiple files can be selected in the file
selector. See C<gtk_file_chooser_set_select_multiple()>.

Returns: C<1> if multiple files can be selected.

Since: 2.4

  method gtk_file_chooser_get_select_multiple ( --> Int  )


=end pod

sub gtk_file_chooser_get_select_multiple ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_show_hidden:
=begin pod
=head2 [[gtk_] file_chooser_] set_show_hidden

Sets whether hidden files and folders are displayed in the file selector.

Since: 2.6

  method gtk_file_chooser_set_show_hidden ( Int $show_hidden )

=item Int $show_hidden; C<1> if hidden files and folders should be displayed.

=end pod

sub gtk_file_chooser_set_show_hidden ( N-GObject $chooser, int32 $show_hidden )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_show_hidden:
=begin pod
=head2 [[gtk_] file_chooser_] get_show_hidden

Gets whether hidden files and folders are displayed in the file selector.
See C<gtk_file_chooser_set_show_hidden()>.

Returns: C<1> if hidden files and folders are displayed.

Since: 2.6

  method gtk_file_chooser_get_show_hidden ( --> Int  )


=end pod

sub gtk_file_chooser_get_show_hidden ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_do_overwrite_confirmation:
=begin pod
=head2 [[gtk_] file_chooser_] set_do_overwrite_confirmation

Sets whether a file chooser in C<GTK_FILE_CHOOSER_ACTION_SAVE> mode will present
a confirmation dialog if the user types a file name that already exists.  This
is C<0> by default.

If set to C<1>, the I<chooser> will emit the
prop I<confirm-overwrite> signal when appropriate.

If all you need is the stock confirmation dialog, set this property to C<1>.
You can override the way confirmation is done by actually handling the
prop I<confirm-overwrite> signal; please refer to its documentation
for the details.

Since: 2.8

  method gtk_file_chooser_set_do_overwrite_confirmation ( Int $do_overwrite_confirmation )

=item Int $do_overwrite_confirmation; whether to confirm overwriting in save mode

=end pod

sub gtk_file_chooser_set_do_overwrite_confirmation ( N-GObject $chooser, int32 $do_overwrite_confirmation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_do_overwrite_confirmation:
=begin pod
=head2 [[gtk_] file_chooser_] get_do_overwrite_confirmation

Queries whether a file chooser is set to confirm for overwriting when the user
types a file name that already exists.

Returns: C<1> if the file chooser will present a confirmation dialog;
C<0> otherwise.

Since: 2.8

  method gtk_file_chooser_get_do_overwrite_confirmation ( --> Int  )


=end pod

sub gtk_file_chooser_get_do_overwrite_confirmation ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_create_folders:
=begin pod
=head2 [[gtk_] file_chooser_] set_create_folders

Sets whether file choser will offer to create new folders.
This is only relevant if the action is not set to be
C<GTK_FILE_CHOOSER_ACTION_OPEN>.

Since: 2.18

  method gtk_file_chooser_set_create_folders ( Int $create_folders )

=item Int $create_folders; C<1> if the Create Folder button should be displayed

=end pod

sub gtk_file_chooser_set_create_folders ( N-GObject $chooser, int32 $create_folders )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_create_folders:
=begin pod
=head2 [[gtk_] file_chooser_] get_create_folders

Gets whether file choser will offer to create new folders.
See C<gtk_file_chooser_set_create_folders()>.

Returns: C<1> if the Create Folder button should be displayed.

Since: 2.18

  method gtk_file_chooser_get_create_folders ( --> Int  )


=end pod

sub gtk_file_chooser_get_create_folders ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_current_name:
=begin pod
=head2 [[gtk_] file_chooser_] set_current_name

Sets the current name in the file selector, as if entered
by the user. Note that the name passed in here is a UTF-8
string rather than a filename. This function is meant for
such uses as a suggested name in a “Save As...” dialog.  You can
pass “Untitled.doc” or a similarly suitable suggestion for the I<name>.

If you want to preselect a particular existing file, you should use
C<gtk_file_chooser_set_filename()> or C<gtk_file_chooser_set_uri()> instead.
Please see the documentation for those functions for an example of using
C<gtk_file_chooser_set_current_name()> as well.

Since: 2.4

  method gtk_file_chooser_set_current_name ( Str $name )

=item Str $name; (type filename): the filename to use, as a UTF-8 string

=end pod

sub gtk_file_chooser_set_current_name ( N-GObject $chooser, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_current_name:
=begin pod
=head2 [[gtk_] file_chooser_] get_current_name

Gets the current name in the file selector, as entered by the user in the
text entry for “Name”.

This is meant to be used in save dialogs, to get the currently typed filename
when the file itself does not exist yet.  For example, an application that
adds a custom extra widget to the file chooser for “file format” may want to
change the extension of the typed filename based on the chosen format, say,
from “.jpg” to “.png”.

Returns: The raw text from the file chooser’s “Name” entry.  Free this with
C<g_free()>.  Note that this string is not a full pathname or URI; it is
whatever the contents of the entry are.  Note also that this string is in
UTF-8 encoding, which is not necessarily the system’s encoding for filenames.

Since: 3.10

  method gtk_file_chooser_get_current_name ( --> Str  )


=end pod

sub gtk_file_chooser_get_current_name ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_filename:
=begin pod
=head2 [[gtk_] file_chooser_] get_filename

Gets the filename for the currently selected file in
the file selector. The filename is returned as an absolute path. If
multiple files are selected, one of the filenames will be returned at
random.

If the file chooser is in folder mode, this function returns the selected
folder.

Returns: (nullable) (type filename): The currently selected filename,
or C<Any> if no file is selected, or the selected file can't
be represented with a local filename. Free with C<g_free()>.

Since: 2.4

  method gtk_file_chooser_get_filename ( --> Str  )


=end pod

sub gtk_file_chooser_get_filename ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_filename:
=begin pod
=head2 [[gtk_] file_chooser_] set_filename

Sets I<filename> as the current filename for the file chooser, by changing to the file’s parent folder and actually selecting the file in list; all other files will be unselected. If the I<chooser> is in C<GTK_FILE_CHOOSER_ACTION_SAVE> mode, the file’s base name will also appear in the dialog’s file name entry.

Note that the file must exist, or nothing will be done except for the directory change.

You should use this function only when implementing a save dialog for which you already have a file name to which the user may save. For example, when the user opens an existing file and then does I<Save As...> to save a copy or a modified version. If you don’t have a file name already — for example, if the user just created a new file and is saving it for the first time, do not call this function. Instead, use something similar to this:

  my Gnome::Gtk3::FileChooserDialog $fcd .= new(:title('Choose a file'));
  my Gnome::Gtk3::FileChooser $fc .= new(:widget($fcd));

  my Document $doc .= new;
  ... add content to doc ...

  if $doc.is-new {
    # the user just created a new document
    $fc.set-current-name("Untitled document");
  }

  else {
    # the user edited an existing document
    $fc.set-filename($existing-filename);
  }

  my $status = $fcd.gtk-dialog-run;


In the first case, the file chooser will present the user with useful suggestions as to where to save his new file. In the second case, the file’s existing location is already known, so the file chooser will use it.

Since: 2.4

  method gtk_file_chooser_set_filename ( Str $filename )

=item Str $filename; (type filename): the filename to set as current

=end pod

sub gtk_file_chooser_set_filename ( N-GObject $chooser, Str $filename )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_select_filename:
=begin pod
=head2 [[gtk_] file_chooser_] select_filename

Selects a filename. If the file name isn’t in the current
folder of I<chooser>, then the current folder of I<chooser> will
be changed to the folder containing I<filename>.

Returns: Not useful.

See also: C<gtk_file_chooser_set_filename()>

Since: 2.4

  method gtk_file_chooser_select_filename ( Str $filename --> Int  )

=item Str $filename; (type filename): the filename to select

=end pod

sub gtk_file_chooser_select_filename ( N-GObject $chooser, Str $filename )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_unselect_filename:
=begin pod
=head2 [[gtk_] file_chooser_] unselect_filename

Unselects a currently selected filename. If the filename
is not in the current directory, does not exist, or
is otherwise not currently selected, does nothing.

Since: 2.4

  method gtk_file_chooser_unselect_filename ( Str $filename )

=item Str $filename; (type filename): the filename to unselect

=end pod

sub gtk_file_chooser_unselect_filename ( N-GObject $chooser, Str $filename )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_select_all:
=begin pod
=head2 [[gtk_] file_chooser_] select_all

Selects all the files in the current folder of a file chooser.

Since: 2.4

  method gtk_file_chooser_select_all ( )


=end pod

sub gtk_file_chooser_select_all ( N-GObject $chooser )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_unselect_all:
=begin pod
=head2 [[gtk_] file_chooser_] unselect_all

Unselects all the files in the current folder of a file chooser.

Since: 2.4

  method gtk_file_chooser_unselect_all ( )


=end pod

sub gtk_file_chooser_unselect_all ( N-GObject $chooser )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_filenames:
=begin pod
=head2 [[gtk_] file_chooser_] get_filenames

Lists all the selected files and subfolders in the current folder of
I<chooser>. The returned names are full absolute paths. If files in the current
folder cannot be represented as local filenames they will be ignored. (See
C<gtk_file_chooser_get_uris()>)

Returns: (element-type filename) (transfer full): a I<GSList>
containing the filenames of all selected files and subfolders in
the current folder. Free the returned list with C<g_slist_free()>,
and the filenames with C<g_free()>.

Since: 2.4

  method gtk_file_chooser_get_filenames ( --> N-GSList  )


=end pod

sub gtk_file_chooser_get_filenames ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_current_folder:
=begin pod
=head2 [[gtk_] file_chooser_] set_current_folder

Sets the current folder for I<chooser> from a local filename.
The user will be shown the full contents of the current folder,
plus user interface elements for navigating to other folders.

In general, you should not use this function.  See the
[section on setting up a file chooser dialog][gtkfilechooserdialog-setting-up]
for the rationale behind this.

Returns: Not useful.

Since: 2.4

  method gtk_file_chooser_set_current_folder ( Str $filename --> Int  )

=item Str $filename; (type filename): the full path of the new current folder

=end pod

sub gtk_file_chooser_set_current_folder ( N-GObject $chooser, Str $filename )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_current_folder:
=begin pod
=head2 [[gtk_] file_chooser_] get_current_folder

Gets the current folder of I<chooser> as a local filename.
See C<gtk_file_chooser_set_current_folder()>.

Note that this is the folder that the file chooser is currently displaying
(e.g. "/home/username/Documents"), which is not the same
as the currently-selected folder if the chooser is in
C<GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER> mode
(e.g. "/home/username/Documents/selected-folder/".  To get the
currently-selected folder in that mode, use C<gtk_file_chooser_get_uri()> as the
usual way to get the selection.

Returns: (nullable) (type filename): the full path of the current
folder, or C<Any> if the current path cannot be represented as a local
filename.  Free with C<g_free()>.  This function will also return
C<Any> if the file chooser was unable to load the last folder that
was requested from it; for example, as would be for calling
C<gtk_file_chooser_set_current_folder()> on a nonexistent folder.

Since: 2.4

  method gtk_file_chooser_get_current_folder ( --> Str  )


=end pod

sub gtk_file_chooser_get_current_folder ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_uri:
=begin pod
=head2 [[gtk_] file_chooser_] get_uri

Gets the URI for the currently selected file in
the file selector. If multiple files are selected,
one of the filenames will be returned at random.

If the file chooser is in folder mode, this function returns the selected
folder.

Returns: (nullable) (transfer full): The currently selected URI, or C<Any>
if no file is selected. If C<gtk_file_chooser_set_local_only()> is set to
C<1> (the default) a local URI will be returned for any FUSE locations.
Free with C<g_free()>

Since: 2.4

  method gtk_file_chooser_get_uri ( --> Str  )


=end pod

sub gtk_file_chooser_get_uri ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_uri:
=begin pod
=head2 [[gtk_] file_chooser_] set_uri

Sets the file referred to by I<uri> as the current file for the file chooser,
by changing to the URI’s parent folder and actually selecting the URI in the
list.  If the I<chooser> is C<GTK_FILE_CHOOSER_ACTION_SAVE> mode, the URI’s base
name will also appear in the dialog’s file name entry.

Note that the URI must exist, or nothing will be done except for the
directory change.

You should use this function only when implementing a save
dialog for which you already have a file name to which
the user may save.  For example, when the user opens an existing file and then
does Save As... to save a copy or a
modified version.  If you don’t have a file name already — for example,
if the user just created a new file and is saving it for the first time, do
not call this function.  Instead, use something similar to this:
|[<!-- language="C" -->
if (document_is_new)
{
// the user just created a new document
gtk_file_chooser_set_current_name (chooser, "Untitled document");
}
else
{
// the user edited an existing document
gtk_file_chooser_set_uri (chooser, existing_uri);
}
]|


In the first case, the file chooser will present the user with useful suggestions
as to where to save his new file.  In the second case, the file’s existing location
is already known, so the file chooser will use it.

Returns: Not useful.

Since: 2.4

  method gtk_file_chooser_set_uri ( Str $uri --> Int  )

=item Str $uri; the URI to set as current

=end pod

sub gtk_file_chooser_set_uri ( N-GObject $chooser, Str $uri )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_select_uri:
=begin pod
=head2 [[gtk_] file_chooser_] select_uri

Selects the file to by I<uri>. If the URI doesn’t refer to a
file in the current folder of I<chooser>, then the current folder of
I<chooser> will be changed to the folder containing I<filename>.

Returns: Not useful.

Since: 2.4

  method gtk_file_chooser_select_uri ( Str $uri --> Int  )

=item Str $uri; the URI to select

=end pod

sub gtk_file_chooser_select_uri ( N-GObject $chooser, Str $uri )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_unselect_uri:
=begin pod
=head2 [[gtk_] file_chooser_] unselect_uri

Unselects the file referred to by I<uri>. If the file
is not in the current directory, does not exist, or
is otherwise not currently selected, does nothing.

Since: 2.4

  method gtk_file_chooser_unselect_uri ( Str $uri )

=item Str $uri; the URI to unselect

=end pod

sub gtk_file_chooser_unselect_uri ( N-GObject $chooser, Str $uri )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_uris:
=begin pod
=head2 [[gtk_] file_chooser_] get_uris

Lists all the selected files and subfolders in the current folder of
I<chooser>. The returned names are full absolute URIs.

Returns: (element-type utf8) (transfer full): a I<GSList> containing the URIs of all selected
files and subfolders in the current folder. Free the returned list
with C<g_slist_free()>, and the filenames with C<g_free()>.

Since: 2.4

  method gtk_file_chooser_get_uris ( --> N-GSList  )


=end pod

sub gtk_file_chooser_get_uris ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_current_folder_uri:
=begin pod
=head2 [[gtk_] file_chooser_] set_current_folder_uri

Sets the current folder for I<chooser> from an URI.
The user will be shown the full contents of the current folder,
plus user interface elements for navigating to other folders.

In general, you should not use this function.  See the
[section on setting up a file chooser dialog][gtkfilechooserdialog-setting-up]
for the rationale behind this.

Returns: C<1> if the folder could be changed successfully, C<0>
otherwise.

Since: 2.4

  method gtk_file_chooser_set_current_folder_uri ( Str $uri --> Int  )

=item Str $uri; the URI for the new current folder

=end pod

sub gtk_file_chooser_set_current_folder_uri ( N-GObject $chooser, Str $uri )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_current_folder_uri:
=begin pod
=head2 [[gtk_] file_chooser_] get_current_folder_uri

Gets the current folder of I<chooser> as an URI.
See C<gtk_file_chooser_set_current_folder_uri()>.

Note that this is the folder that the file chooser is currently displaying
(e.g. "file:///home/username/Documents"), which is not the same
as the currently-selected folder if the chooser is in
C<GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER> mode
(e.g. "file:///home/username/Documents/selected-folder/".  To get the
currently-selected folder in that mode, use C<gtk_file_chooser_get_uri()> as the
usual way to get the selection.

Returns: (nullable) (transfer full): the URI for the current folder.
Free with C<g_free()>.  This function will also return C<Any> if the file chooser
was unable to load the last folder that was requested from it; for example,
as would be for calling C<gtk_file_chooser_set_current_folder_uri()> on a
nonexistent folder.

Since: 2.4

  method gtk_file_chooser_get_current_folder_uri ( --> Str  )


=end pod

sub gtk_file_chooser_get_current_folder_uri ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_file:
=begin pod
=head2 [[gtk_] file_chooser_] get_file

Gets the I<GFile> for the currently selected file in
the file selector. If multiple files are selected,
one of the files will be returned at random.

If the file chooser is in folder mode, this function returns the selected
folder.

Returns: (transfer full): a selected I<GFile>. You own the returned file;
use C<g_object_unref()> to release it.

Since: 2.14

  method gtk_file_chooser_get_file ( --> N-GObject  )


=end pod

sub gtk_file_chooser_get_file ( N-GObject $chooser )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_file:
=begin pod
=head2 [[gtk_] file_chooser_] set_file

Sets I<file> as the current filename for the file chooser, by changing
to the file’s parent folder and actually selecting the file in list.  If
the I<chooser> is in C<GTK_FILE_CHOOSER_ACTION_SAVE> mode, the file’s base name
will also appear in the dialog’s file name entry.

If the file name isn’t in the current folder of I<chooser>, then the current
folder of I<chooser> will be changed to the folder containing I<filename>. This
is equivalent to a sequence of C<gtk_file_chooser_unselect_all()> followed by
C<gtk_file_chooser_select_filename()>.

Note that the file must exist, or nothing will be done except
for the directory change.

If you are implementing a save dialog,
you should use this function if you already have a file name to which the
user may save; for example, when the user opens an existing file and then
does Save As...  If you don’t have
a file name already — for example, if the user just created a new
file and is saving it for the first time, do not call this function.
Instead, use something similar to this:
|[<!-- language="C" -->
if (document_is_new)
{
// the user just created a new document
gtk_file_chooser_set_current_folder_file (chooser, default_file_for_saving);
gtk_file_chooser_set_current_name (chooser, "Untitled document");
}
else
{
// the user edited an existing document
gtk_file_chooser_set_file (chooser, existing_file);
}
]|

Returns: Not useful.

Since: 2.14

  method gtk_file_chooser_set_file ( N-GObject $file, N-GError $error --> Int  )

=item N-GObject $file; the I<GFile> to set as current
=item N-GError $error; (allow-none): location to store the error, or C<Any> to ignore errors.

=end pod

sub gtk_file_chooser_set_file ( N-GObject $chooser, N-GObject $file, N-GError $error )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_select_file:
=begin pod
=head2 [[gtk_] file_chooser_] select_file

Selects the file referred to by I<file>. An internal function. See
C<_gtk_file_chooser_select_uri()>.

Returns: Not useful.

Since: 2.14

  method gtk_file_chooser_select_file ( N-GObject $file, N-GError $error --> Int  )

=item N-GObject $file; the file to select
=item N-GError $error; (allow-none): location to store error, or C<Any>

=end pod

sub gtk_file_chooser_select_file ( N-GObject $chooser, N-GObject $file, N-GError $error )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_unselect_file:
=begin pod
=head2 [[gtk_] file_chooser_] unselect_file

Unselects the file referred to by I<file>. If the file is not in the current
directory, does not exist, or is otherwise not currently selected, does nothing.

Since: 2.14

  method gtk_file_chooser_unselect_file ( N-GObject $file )

=item N-GObject $file; a I<GFile>

=end pod

sub gtk_file_chooser_unselect_file ( N-GObject $chooser, N-GObject $file )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_files:
=begin pod
=head2 [[gtk_] file_chooser_] get_files

Lists all the selected files and subfolders in the current folder of I<chooser>
as I<GFile>. An internal function, see C<gtk_file_chooser_get_uris()>.

Returns: (element-type GFile) (transfer full): a I<GSList>
containing a I<GFile> for each selected file and subfolder in the
current folder.  Free the returned list with C<g_slist_free()>, and
the files with C<g_object_unref()>.

Since: 2.14

  method gtk_file_chooser_get_files ( --> N-GSList  )


=end pod

sub gtk_file_chooser_get_files ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_current_folder_file:
=begin pod
=head2 [[gtk_] file_chooser_] set_current_folder_file

Sets the current folder for I<chooser> from a I<GFile>.
Internal function, see C<gtk_file_chooser_set_current_folder_uri()>.

Returns: C<1> if the folder could be changed successfully, C<0>
otherwise.

Since: 2.14

  method gtk_file_chooser_set_current_folder_file ( N-GObject $file, N-GError $error --> Int  )

=item N-GObject $file; the I<GFile> for the new folder
=item N-GError $error; (allow-none): location to store error, or C<Any>.

=end pod

sub gtk_file_chooser_set_current_folder_file ( N-GObject $chooser, N-GObject $file, N-GError $error )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_current_folder_file:
=begin pod
=head2 [[gtk_] file_chooser_] get_current_folder_file

Gets the current folder of I<chooser> as I<GFile>.
See C<gtk_file_chooser_get_current_folder_uri()>.

Returns: (transfer full): the I<GFile> for the current folder.

Since: 2.14

  method gtk_file_chooser_get_current_folder_file ( --> N-GObject  )


=end pod

sub gtk_file_chooser_get_current_folder_file ( N-GObject $chooser )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_preview_widget:
=begin pod
=head2 [[gtk_] file_chooser_] set_preview_widget

Sets an application-supplied widget to use to display a custom preview
of the currently selected file. To implement a preview, after setting the
preview widget, you connect to the prop I<update-preview>
signal, and call C<gtk_file_chooser_get_preview_filename()> or
C<gtk_file_chooser_get_preview_uri()> on each change. If you can
display a preview of the new file, update your widget and
set the preview active using C<gtk_file_chooser_set_preview_widget_active()>.
Otherwise, set the preview inactive.

When there is no application-supplied preview widget, or the
application-supplied preview widget is not active, the file chooser
will display no preview at all.

Since: 2.4

  method gtk_file_chooser_set_preview_widget ( N-GObject $preview_widget )

=item N-GObject $preview_widget; widget for displaying preview.

=end pod

sub gtk_file_chooser_set_preview_widget ( N-GObject $chooser, N-GObject $preview_widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_preview_widget:
=begin pod
=head2 [[gtk_] file_chooser_] get_preview_widget

Gets the current preview widget; see
C<gtk_file_chooser_set_preview_widget()>.

Returns: (nullable) (transfer none): the current preview widget, or C<Any>

Since: 2.4

  method gtk_file_chooser_get_preview_widget ( --> N-GObject  )


=end pod

sub gtk_file_chooser_get_preview_widget ( N-GObject $chooser )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_preview_widget_active:
=begin pod
=head2 [[gtk_] file_chooser_] set_preview_widget_active

Sets whether the preview widget set by
C<gtk_file_chooser_set_preview_widget()> should be shown for the
current filename. When I<active> is set to false, the file chooser
may display an internally generated preview of the current file
or it may display no preview at all. See
C<gtk_file_chooser_set_preview_widget()> for more details.

Since: 2.4

  method gtk_file_chooser_set_preview_widget_active ( Int $active )

=item Int $active; whether to display the user-specified preview widget

=end pod

sub gtk_file_chooser_set_preview_widget_active ( N-GObject $chooser, int32 $active )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_preview_widget_active:
=begin pod
=head2 [[gtk_] file_chooser_] get_preview_widget_active

Gets whether the preview widget set by C<gtk_file_chooser_set_preview_widget()>
should be shown for the current filename. See
C<gtk_file_chooser_set_preview_widget_active()>.

Returns: C<1> if the preview widget is active for the current filename.

Since: 2.4

  method gtk_file_chooser_get_preview_widget_active ( --> Int  )


=end pod

sub gtk_file_chooser_get_preview_widget_active ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_use_preview_label:
=begin pod
=head2 [[gtk_] file_chooser_] set_use_preview_label

Sets whether the file chooser should display a stock label with the name of
the file that is being previewed; the default is C<1>.  Applications that
want to draw the whole preview area themselves should set this to C<0> and
display the name themselves in their preview widget.

See also: C<gtk_file_chooser_set_preview_widget()>

Since: 2.4

  method gtk_file_chooser_set_use_preview_label ( Int $use_label )

=item Int $use_label; whether to display a stock label with the name of the previewed file

=end pod

sub gtk_file_chooser_set_use_preview_label ( N-GObject $chooser, int32 $use_label )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_use_preview_label:
=begin pod
=head2 [[gtk_] file_chooser_] get_use_preview_label

Gets whether a stock label should be drawn with the name of the previewed
file.  See C<gtk_file_chooser_set_use_preview_label()>.

Returns: C<1> if the file chooser is set to display a label with the
name of the previewed file, C<0> otherwise.

  method gtk_file_chooser_get_use_preview_label ( --> Int  )


=end pod

sub gtk_file_chooser_get_use_preview_label ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_preview_filename:
=begin pod
=head2 [[gtk_] file_chooser_] get_preview_filename

Gets the filename that should be previewed in a custom preview
widget. See C<gtk_file_chooser_set_preview_widget()>.

Returns: (nullable) (type filename): the filename to preview, or C<Any> if
no file is selected, or if the selected file cannot be represented
as a local filename. Free with C<g_free()>

Since: 2.4

  method gtk_file_chooser_get_preview_filename ( --> Str  )


=end pod

sub gtk_file_chooser_get_preview_filename ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_preview_uri:
=begin pod
=head2 [[gtk_] file_chooser_] get_preview_uri

Gets the URI that should be previewed in a custom preview
widget. See C<gtk_file_chooser_set_preview_widget()>.

Returns: (nullable) (transfer full): the URI for the file to preview,
or C<Any> if no file is selected. Free with C<g_free()>.

Since: 2.4

  method gtk_file_chooser_get_preview_uri ( --> Str  )


=end pod

sub gtk_file_chooser_get_preview_uri ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_preview_file:
=begin pod
=head2 [[gtk_] file_chooser_] get_preview_file

Gets the I<GFile> that should be previewed in a custom preview
Internal function, see C<gtk_file_chooser_get_preview_uri()>.

Returns: (nullable) (transfer full): the I<GFile> for the file to preview,
or C<Any> if no file is selected. Free with C<g_object_unref()>.

Since: 2.14

  method gtk_file_chooser_get_preview_file ( --> N-GObject  )


=end pod

sub gtk_file_chooser_get_preview_file ( N-GObject $chooser )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_extra_widget:
=begin pod
=head2 [[gtk_] file_chooser_] set_extra_widget

Sets an application-supplied widget to provide extra options to the user.

Since: 2.4

  method gtk_file_chooser_set_extra_widget ( N-GObject $extra_widget )

=item N-GObject $extra_widget; widget for extra options

=end pod

sub gtk_file_chooser_set_extra_widget ( N-GObject $chooser, N-GObject $extra_widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_extra_widget:
=begin pod
=head2 [[gtk_] file_chooser_] get_extra_widget

Gets the current preview widget; see
C<gtk_file_chooser_set_extra_widget()>.

Returns: (nullable) (transfer none): the current extra widget, or C<Any>

Since: 2.4

  method gtk_file_chooser_get_extra_widget ( --> N-GObject  )


=end pod

sub gtk_file_chooser_get_extra_widget ( N-GObject $chooser )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_add_filter:
=begin pod
=head2 [[gtk_] file_chooser_] add_filter

Adds I<filter> to the list of filters that the user can select between.
When a filter is selected, only files that are passed by that
filter are displayed.

Note that the I<chooser> takes ownership of the filter, so you have to
ref and sink it if you want to keep a reference.

Since: 2.4

  method gtk_file_chooser_add_filter ( N-GObject $filter )

=item N-GObject $filter; (transfer full): a I<Gnome::Gtk3::FileFilter>

=end pod

sub gtk_file_chooser_add_filter ( N-GObject $chooser, N-GObject $filter )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_remove_filter:
=begin pod
=head2 [[gtk_] file_chooser_] remove_filter

Removes I<filter> from the list of filters that the user can select between.

Since: 2.4

  method gtk_file_chooser_remove_filter ( N-GObject $filter )

=item N-GObject $filter; a I<Gnome::Gtk3::FileFilter>

=end pod

sub gtk_file_chooser_remove_filter ( N-GObject $chooser, N-GObject $filter )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_list_filters:
=begin pod
=head2 [[gtk_] file_chooser_] list_filters

Lists the current set of user-selectable filters; see
C<gtk_file_chooser_add_filter()>, C<gtk_file_chooser_remove_filter()>.

Returns: (element-type B<Gnome::Gtk3::FileFilter>) (transfer container): a
I<GSList> containing the current set of user selectable filters. The
contents of the list are owned by GTK+, but you must free the list
itself with C<g_slist_free()> when you are done with it.

Since: 2.4

  method gtk_file_chooser_list_filters ( --> N-GSList  )


=end pod

sub gtk_file_chooser_list_filters ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_filter:
=begin pod
=head2 [[gtk_] file_chooser_] set_filter

Sets the current filter; only the files that pass the
filter will be displayed. If the user-selectable list of filters
is non-empty, then the filter should be one of the filters
in that list. Setting the current filter when the list of
filters is empty is useful if you want to restrict the displayed
set of files without letting the user change it.

Since: 2.4

  method gtk_file_chooser_set_filter ( N-GObject $filter )

=item N-GObject $filter; a I<Gnome::Gtk3::FileFilter>

=end pod

sub gtk_file_chooser_set_filter ( N-GObject $chooser, N-GObject $filter )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_filter:
=begin pod
=head2 [[gtk_] file_chooser_] get_filter

Gets the current filter; see C<gtk_file_chooser_set_filter()>.

Returns: (nullable) (transfer none): the current filter, or C<Any>

Since: 2.4

  method gtk_file_chooser_get_filter ( --> N-GObject  )


=end pod

sub gtk_file_chooser_get_filter ( N-GObject $chooser )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_add_shortcut_folder:
=begin pod
=head2 [[gtk_] file_chooser_] add_shortcut_folder

Adds a folder to be displayed with the shortcut folders in a file chooser.
Internal function, see C<gtk_file_chooser_add_shortcut_folder()>.

Returns: C<1> if the folder could be added successfully, C<0>
otherwise.

Since: 2.4

  method gtk_file_chooser_add_shortcut_folder ( Str $folder, N-GError $error --> Int  )

=item Str $folder; file for the folder to add
=item N-GError $error; (allow-none): location to store error, or C<Any>

=end pod

sub gtk_file_chooser_add_shortcut_folder ( N-GObject $chooser, Str $folder, N-GError $error )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_remove_shortcut_folder:
=begin pod
=head2 [[gtk_] file_chooser_] remove_shortcut_folder

Removes a folder from the shortcut folders in a file chooser.  Internal
function, see C<gtk_file_chooser_remove_shortcut_folder()>.

Returns: C<1> if the folder could be removed successfully, C<0>
otherwise.

Since: 2.4

  method gtk_file_chooser_remove_shortcut_folder ( Str $folder, N-GError $error --> Int  )

=item Str $folder; file for the folder to remove
=item N-GError $error; (allow-none): location to store error, or C<Any>

=end pod

sub gtk_file_chooser_remove_shortcut_folder ( N-GObject $chooser, Str $folder, N-GError $error )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_list_shortcut_folders:
=begin pod
=head2 [[gtk_] file_chooser_] list_shortcut_folders

Queries the list of shortcut folders in the file chooser, as set by
C<gtk_file_chooser_add_shortcut_folder()>.

Returns: (nullable) (element-type filename) (transfer full): A list
of folder filenames, or C<Any> if there are no shortcut folders.
Free the returned list with C<g_slist_free()>, and the filenames with
C<g_free()>.

Since: 2.4

  method gtk_file_chooser_list_shortcut_folders ( --> N-GSList  )


=end pod

sub gtk_file_chooser_list_shortcut_folders ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_add_shortcut_folder_uri:
=begin pod
=head2 [[gtk_] file_chooser_] add_shortcut_folder_uri

Adds a folder URI to be displayed with the shortcut folders in a file
chooser.  Note that shortcut folders do not get saved, as they are provided
by the application.  For example, you can use this to add a
“file:///usr/share/mydrawprogram/Clipart” folder to the volume list.

Returns: C<1> if the folder could be added successfully, C<0>
otherwise.  In the latter case, the I<error> will be set as appropriate.

Since: 2.4

  method gtk_file_chooser_add_shortcut_folder_uri ( Str $uri, N-GError $error --> Int  )

=item Str $uri; URI of the folder to add
=item N-GError $error; (allow-none): location to store error, or C<Any>

=end pod

sub gtk_file_chooser_add_shortcut_folder_uri ( N-GObject $chooser, Str $uri, N-GError $error )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_remove_shortcut_folder_uri:
=begin pod
=head2 [[gtk_] file_chooser_] remove_shortcut_folder_uri

Removes a folder URI from a file chooser’s list of shortcut folders.

Returns: C<1> if the operation succeeds, C<0> otherwise.
In the latter case, the I<error> will be set as appropriate.

See also: C<gtk_file_chooser_add_shortcut_folder_uri()>

Since: 2.4

  method gtk_file_chooser_remove_shortcut_folder_uri ( Str $uri, N-GError $error --> Int  )

=item Str $uri; URI of the folder to remove
=item N-GError $error; (allow-none): location to store error, or C<Any>

=end pod

sub gtk_file_chooser_remove_shortcut_folder_uri ( N-GObject $chooser, Str $uri, N-GError $error )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_list_shortcut_folder_uris:
=begin pod
=head2 [[gtk_] file_chooser_] list_shortcut_folder_uris

Queries the list of shortcut folders in the file chooser, as set by
C<gtk_file_chooser_add_shortcut_folder_uri()>.

Returns: (nullable) (element-type utf8) (transfer full): A list of
folder URIs, or C<Any> if there are no shortcut folders.  Free the
returned list with C<g_slist_free()>, and the URIs with C<g_free()>.

Since: 2.4

  method gtk_file_chooser_list_shortcut_folder_uris ( --> N-GSList  )


=end pod

sub gtk_file_chooser_list_shortcut_folder_uris ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_add_choice:
=begin pod
=head2 [[gtk_] file_chooser_] add_choice

Adds a 'choice' to the file chooser. This is typically implemented
as a combobox or, for boolean choices, as a checkbutton. You can select
a value using C<gtk_file_chooser_set_choice()> before the dialog is shown,
and you can obtain the user-selected value in the prop I<response> signal handler
using C<gtk_file_chooser_get_choice()>.

Compare C<gtk_file_chooser_set_extra_widget()>.

Since: 3.22

  method gtk_file_chooser_add_choice ( Str $id, Str $label, CArray[Str] $options, CArray[Str] $option_labels )

=item Str $id; id for the added choice
=item Str $label; user-visible label for the added choice
=item CArray[Str] $options; ids for the options of the choice, or C<Any> for a boolean choice
=item CArray[Str] $option_labels; user-visible labels for the options, must be the same length as I<options>

=end pod

sub gtk_file_chooser_add_choice ( N-GObject $chooser, Str $id, Str $label, CArray[Str] $options, CArray[Str] $option_labels )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_remove_choice:
=begin pod
=head2 [[gtk_] file_chooser_] remove_choice

Removes a 'choice' that has been added with C<gtk_file_chooser_add_choice()>.

Since: 3.22

  method gtk_file_chooser_remove_choice ( Str $id )

=item Str $id; the ID of the choice to remove

=end pod

sub gtk_file_chooser_remove_choice ( N-GObject $chooser, Str $id )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_set_choice:
=begin pod
=head2 [[gtk_] file_chooser_] set_choice

Selects an option in a 'choice' that has been added with
C<gtk_file_chooser_add_choice()>. For a boolean choice, the
possible options are "true" and "false".

Since: 3.22

  method gtk_file_chooser_set_choice ( Str $id, Str $option )

=item Str $id; the ID of the choice to set
=item Str $option; the ID of the option to select

=end pod

sub gtk_file_chooser_set_choice ( N-GObject $chooser, Str $id, Str $option )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_file_chooser_get_choice:
=begin pod
=head2 [[gtk_] file_chooser_] get_choice

Gets the currently selected option in the 'choice' with the given ID.

Returns: the ID of the currenly selected option
Since: 3.22

  method gtk_file_chooser_get_choice ( Str $id --> Str  )

=item Str $id; the ID of the choice to get

=end pod

sub gtk_file_chooser_get_choice ( N-GObject $chooser, Str $id )
  returns Str
  is native(&gtk-lib)
  { * }
#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also B<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

=head2 Supported signals

=comment #TS:0:current-folder-changed:
=head3 current-folder-changed

This signal is emitted when the current folder in a I<Gnome::Gtk3::FileChooser> changes. This can happen due to the user performing some action that changes folders, such as selecting a bookmark or visiting a folder on the file list.  It can also happen as a result of calling a function to explicitly change the current folder in a file chooser.

Normally you do not need to connect to this signal, unless you need to keep track of which folder a file chooser is showing.

See also:  C<gtk_file_chooser_set_current_folder()>,
C<gtk_file_chooser_get_current_folder()>,
C<gtk_file_chooser_set_current_folder_uri()>,
C<gtk_file_chooser_get_current_folder_uri()>.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($chooser),
    :$user-option1, ..., :$user-optionN
  );

=item $chooser; the object which received the signal.


=comment #TS:0:selection-changed:
=head3 selection-changed

This signal is emitted when there is a change in the set of selected files in a I<Gnome::Gtk3::FileChooser>. This can happen when the user modifies the selection with the mouse or the keyboard, or when explicitly calling functions to change the selection.

Normally you do not need to connect to this signal, as it is easier to wait for the file chooser to finish running, and then to get the list of selected files using the functions mentioned below.

See also: C<gtk_file_chooser_select_filename()>,
C<gtk_file_chooser_unselect_filename()>, C<gtk_file_chooser_get_filename()>,
C<gtk_file_chooser_get_filenames()>, C<gtk_file_chooser_select_uri()>,
C<gtk_file_chooser_unselect_uri()>, C<gtk_file_chooser_get_uri()>,
C<gtk_file_chooser_get_uris()>.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($chooser),
    :$user-option1, ..., :$user-optionN
  );

=item $chooser; the object which received the signal.


=comment #TS:0:update-preview:
=head3 update-preview

This signal is emitted when the preview in a file chooser should be regenerated. For example, this can happen when the currently selected file changes. You should use this signal if you want your file chooser to have a preview widget.

Once you have installed a preview widget with C<gtk_file_chooser_set_preview_widget()>, you should update it when this signal is emitted.  You can use the functions C<gtk_file_chooser_get_preview_filename()> or C<gtk_file_chooser_get_preview_uri()> to get the name of the file to preview. Your widget may not be able to preview all kinds of files; your callback must call C<gtk_file_chooser_set_preview_widget_active()> to inform the file chooser about whether the preview was generated successfully or not.

=comment Please see the example code in [Using a Preview Widget][gtkfilechooser-preview].

See also: C<gtk_file_chooser_set_preview_widget()>,
C<gtk_file_chooser_set_preview_widget_active()>,
C<gtk_file_chooser_set_use_preview_label()>,
C<gtk_file_chooser_get_preview_filename()>,
C<gtk_file_chooser_get_preview_uri()>.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($chooser),
    :$user-option1, ..., :$user-optionN
  );

=item $chooser; the object which received the signal.


=comment #TS:0:file-activated:
=head3 file-activated

This signal is emitted when the user "activates" a file in the file chooser.  This can happen by double-clicking on a file in the file list, or by pressing I<Enter>.

Normally you do not need to connect to this signal. It is used internally by I<Gnome::Gtk3::FileChooserDialog> to know when to activate the default button in the dialog.

See also: C<gtk_file_chooser_get_filename()>,
C<gtk_file_chooser_get_filenames()>, C<gtk_file_chooser_get_uri()>,
C<gtk_file_chooser_get_uris()>.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($chooser),
    :$user-option1, ..., :$user-optionN
  );

=item $chooser; the object which received the signal.


=comment #TS:0:confirm-overwrite:
=head3 confirm-overwrite

This signal gets emitted whenever it is appropriate to present a confirmation dialog when the user has selected a file name that already exists. The signal only gets emitted when the file chooser is in C<GTK_FILE_CHOOSER_ACTION_SAVE> mode.

Most applications just need to turn on the I<do-overwrite-confirmation> property (or call the C<gtk_file_chooser_set_do_overwrite_confirmation()> function), and they will automatically get a stock confirmation dialog. Applications which need to customize this behavior should do that, and also connect to the prop I<confirm-overwrite> signal.

A signal handler for this signal must return a B<GtkFileChooserConfirmation> value, which indicates the action to take. If the handler determines that the user wants to select a different filename, it should return C<GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN>. If it determines that the user is satisfied with his choice of file name, it should return C<GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME>. On the other hand, if it determines that the stock confirmation dialog should be used, it should return C<GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM>.

=begin comment
=head4 Custom confirmation
The following example illustrates this.

  static B<Gnome::Gtk3::FileChooserConfirmation>
  confirm_overwrite_callback (B<Gnome::Gtk3::FileChooser> *chooser, gpointer data)
  {
  char *uri;

  uri = gtk_file_chooser_get_uri (chooser);

  if (is_uri_read_only (uri))
  {
  if (user_wants_to_replace_read_only_file (uri))
  return GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME;
  else
  return GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN;
  } else
  return GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM; // fall back to the default dialog
  }

  ...

  chooser = gtk_file_chooser_dialog_new (...);

  gtk_file_chooser_set_do_overwrite_confirmation (GTK_FILE_CHOOSER (dialog), TRUE);
  g_signal_connect (chooser, "confirm-overwrite",
  G_CALLBACK (confirm_overwrite_callback), NULL);

  if (gtk_dialog_run (chooser) == GTK_RESPONSE_ACCEPT)
  save_to_file (gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (chooser));

  gtk_widget_destroy (chooser);
=end comment

Returns: a B<GtkFileChooserConfirmation> value that indicates which action to take after emitting the signal.

Since: 2.8

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($chooser),
    :$user-option1, ..., :$user-optionN
    --> GtkFileChooserConfirmation
  );

=item $chooser; the object which received the signal.


=end pod

=begin comment
=head2 Unsupported signals
=head2 Not yet supported signals
=end comment

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:action:
=head3 Action

The B<Gnome::GObject::Value> type of property I<action> is C<G_TYPE_ENUM>.

The type of operation that the file selector is performing

Default value: False
Flags: GTK_PARAM_READWRITE

=comment #TP:0:filter:
=head3 Filter

The B<Gnome::GObject::Value> type of property I<filter> is C<G_TYPE_OBJECT>.

The current filter for selecting which files are displayed

Widget type: GTK_TYPE_FILE_FILTER
Flags: GTK_PARAM_READWRITE

=comment #TP:0:local-only:
=head3 Local Only

The B<Gnome::GObject::Value> type of property I<local-only> is C<G_TYPE_BOOLEAN>.

Whether the selected file(s should be limited to local file: URLs)

Default value: True

=comment #TP:0:preview-widget-active:
=head3 Preview Widget Active

The B<Gnome::GObject::Value> type of property I<preview-widget-active> is C<G_TYPE_BOOLEAN>.

Whether the application supplied widget for custom previews should be shown.

Default value: True

=comment #TP:0:use-preview-label:
=head3 Use Preview Label

The B<Gnome::GObject::Value> type of property I<use-preview-label> is C<G_TYPE_BOOLEAN>.

Whether to display a stock label with the name of the previewed file.

Default value: True

=comment #TP:0:select-multiple:
=head3 Select Multiple

The B<Gnome::GObject::Value> type of property I<select-multiple> is C<G_TYPE_BOOLEAN>.

Whether to allow multiple files to be selected

Default value: False

=comment #TP:0:show-hidden:
=head3 Show Hidden

The B<Gnome::GObject::Value> type of property I<show-hidden> is C<G_TYPE_BOOLEAN>.

Whether the hidden files and folders should be displayed

Default value: False

=comment #TP:0:do-overwrite-confirmation:
=head3 Do overwrite confirmation

The B<Gnome::GObject::Value> type of property I<do-overwrite-confirmation> is C<G_TYPE_BOOLEAN>.

Whether a file chooser in C<GTK_FILE_CHOOSER_ACTION_SAVE> mode will present an overwrite confirmation dialog if the user selects a file name that already exists.

Since: 2.8

Default value: False

=comment #TP:0:create-folders:
=head3 Allow folder creation

The B<Gnome::GObject::Value> type of property I<create-folders> is C<G_TYPE_BOOLEAN>.

Whether a file chooser not in C<GTK_FILE_CHOOSER_ACTION_OPEN> mode will offer the user to create new folders.

Since: 2.18

Default value: True



=begin comment
=head2 Unsupported properties
=end comment




=head2 Not yet supported properties

=comment #TP:0:preview-widget:
=head3 Preview widget

The B<Gnome::GObject::Value> type of property I<preview-widget> is C<G_TYPE_OBJECT>.

Application supplied widget for custom previews.

Widget type: GTK_TYPE_WIDGET
Flags: GTK_PARAM_READWRITE

=comment #TP:0:extra-widget:
=head3 Extra widget

The B<Gnome::GObject::Value> type of property I<extra-widget> is C<G_TYPE_OBJECT>.

Application supplied widget for extra options.

Widget type: GTK_TYPE_WIDGET
Flags: GTK_PARAM_READWRITE

=end pod
