---
title: Tutorial - Application Commandline
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Extending the Application

Our first attempt to build an application went well but to make it more useful we need to add a few things. There are more initialization flags to consider besides the one we met before; `G_APPLICATION_NON_UNIQUE`.


## Handling Command Line Arguments

In Raku we are used to have `@*ARGS` which is interpreted by subroutine `MAIN()`. The `@*ARGS` variable is important and is available globally. When calling `.run()`, the array is fed to the application with an extra argument added. In C, it is common to have the program name as its first argument in this list. To keep things te same for these libraries and prevent unpleasant surprises, that value is inserted at the first position.

The **Gnome::Gio::Application** class handles the arguments at two different locations in your program. There is a part that handles local arguments and a part that handles remote arguments. The local part is accessed using a signal `handle-local-options`. So, if you want to process arguments for which a primary is not needed, you must register a handler for this signal.

### Local Argument Processing

The `handle-local-options` handler is accessed with a native Variant dictonary holding the options registered previously using calls in the Application class. Here, I've taken a design decision to not support the argument processing of Gio and friends. The reason for this is that the Variant structures are quite combersome to read and modify. Indispensable for the C-programmer but in Raku however, we have `@*ARGS` 😄. Using one of the freely available modules one can peel off and select the options you need.

The handler must also return an integer which will determine the next step of the application. Values of 0 and higher are taken as exit values with 0 mostly as successfull and > 0 some kind of failure. This value becomes the return value of the `.run()` method.
When -1 is returned, it is taken as a sign to continue and not to return to the commandline.

So adding the following will give us a way to process arguments. I've taken the freedom to choose the **Getopt::Long** module of Leon Timmermans to process the arguments.

```
use Getopt::Long;                                                 # 1
use Gnome::N::N-GObject;
…
unit class UserAppClass is Gnome::Gtk3::Application;
…
submethod BUILD ( ) {
  …
  self.register-signal( self, 'local-options', 'handle-local-options');
                                                                  # 2
  …
}
…
method local-options (
  N-GObject $n-vd, UserAppClass :_widget($app) --> Int            # 3
) {
  my Int $exit-code = -1;                                         # 4

  CATCH {                                                         # 5
    default { .message.note; $exit-code = 1; return $exit-code; }
  }

  my $o = get-options('version');                                 # 6
  if $o<version> {
    say "Version of UserAppClass is 0.2.0";
    $exit-code = 0;
  }

  $exit-code
}
```
1) We need **Getopt::Long** and **Gnome::N::N-GObject**. The N-GObject class is only used to define the handler interface.

2) Register the handler for the `handle-local-options` signal.

3) Positional arguments must always be defined when declaring a handler method. It is necessary because of the way the registration of signals works. The named arguments like `:_widget` and the users provided options may always be left out if not used in the method.

4) Specify the exit code such that the application continues. Change it when an error occurs or when the task is done.

5) When there are unrecognized arguments and options, the `get-options()` routine will blow up in your face. Define a CATCH to prevent a stack dump and show the message only.

6) Process an option. It is a boolean variable `version` which, when found, the application will show a version and then decides to return a success value after which the application will stop.

When no arguments are given, the program continues and shows a window. Each invocation without arguments adds a new window. You might introduce a boolean variable which is set after building the GUI. A second attempt to build can be prevented after checking this value.

Lets try it;
```
# raku sceleton-application-v2.raku --version
Unknown option --version
```
*What!!!!* I wanted to see a version! Not an error! 😦. It has something to do with my design decision to not support the argument processing of Gio. It seems that we must do more to get rid of the automatic checking of the Application.


### Remote Argument Processing

To get this to work we must turn on another signal and we must also add an initialization flag to our `.new()` method. Below is the total of added code.

```
use Getopt::Long;
use Gnome::N::N-GObject;                                          # 1
use Gnome::Gio::Enums;
use Gnome::Gio::ApplicationCommandLine;
…
unit class UserAppClass is Gnome::Gtk3::Application;
…
submethod new ( |c ) {
  self.bless(
    :GtkApplication, :app-id(APP-ID),
    :flags(G_APPLICATION_HANDLES_COMMAND_LINE)                    # 2
    |c
  );
}
…
submethod BUILD ( ) {
  …
  self.register-signal( self, 'local-options', 'handle-local-options');
  self.register-signal( self, 'remote-options', 'command-line');  # 3
  …
}
…
method local-options (
  N-GObject $no-vd, UserAppClass :_widget($app) --> Int
) {
  my Int $exit-code = -1;

  CATCH {
    default { .message.note; $exit-code = 1; return $exit-code; }
  }
  my $o = get-options( 'version', 'show:s');
  if $o<version> {
    say "Version of UserAppClass is 0.2.0";
    $exit-code = 0;
  }

  $exit-code
}

method remote-options (                                           # 4
  N-GObject $no-cl, UserAppClass :_widget($app) --> Int
) {
  my Int $exit-code = 0;

  my Gnome::Gio::ApplicationCommandLine() $cl = $no-cl            # 5
    :native-object($n-cl)
  );

  my Array $args = $cl.get-arguments;                             # 6
  my Capture $o = get-options-from( $args[1..*-1], 'version', 'show:s');
                                                                  # 7
  my Str $file-to-show = $o.<show>
    if ($o.<show> // '') and $o.<show>.IO.r;

  self.activate unless $cl.get-is-remote;                         # 8

  if ?$file-to-show {
    $cl.print("Show text from $file-to-show\n");
    … show file in window …
  }

  $cl.clear-object;                                               # 9

  $exit-code
}
```
1) Again more modules are needed to get the `N-GObject` type, the initialization flag and the commandline class.

2) We need the `G_APPLICATION_HANDLES_COMMAND_LINE` to process the commandline arguments remotely.

3) For this to work we must also register a handler for the `command-line` signal.

4) The method `.remote-options()` is called after returning -1 (=continue) from the `.local-options()` method.

5) The commandline object `$cl` is initialized with the provided native object `$no-cl`.

6) The arguments returned from the call are exactly the same as stored while starting the `.run()` method in the beginning. Because the argument management is not supported, it is also not adjusted by the necessary calls in `.local-options()`.

7) Process the options. We must test for the same set as is done in the `.local-options()` to prevent 'option not recognized' errors. Another important thing is that when the tested option set is the same, we do not need a `CATCH {}` to catch unrecognized option errors.

8) Now we get the chance to differentiate between actions needed to do by a primary instance by looking if the arguments are coming from the primary or from the secondary instance. If from a primary, this means that there is not yet a window created and thus we call the applications `.activate()` method. It is worth noting that, now the application requested to handle command line arguments, the `activate` signal will not be fired automatically. This is because the primary must also be able to return to the command line in case of troubles.

9) One last important step is to destroy the commandline object. Otherwise, when it is kept around, the secondary process will be kept alive by not returning from the call to `.run()`. This is done because the object may be kept around to defer some of the tests for later.

When we test it now, we get far better results. First the --version option which returns immediately;
```
# raku sceleton-application-v3.raku --version
Version of UserAppClass is 0.2.0
```
And assuming that some-file.txt exists, the --show option;
```
# raku sceleton-application-v3.raku --show some-file.txt
Info:
  Registered: True
  app id: io.github.martimm.tutorial
Show text from some-file.txt
```
Also a window is made and primary stays alive. You might repeat this while the primary still runs and see what happens, anyways, no second windows anymore.

Unknown uptions are now returning mentioning a failure
```
# raku sceleton-application-v3.raku --help
Unknown option help
```

There are still some problems left but we can ignore them now for the moment.

# What have we learned

Handling commandline arguments is complex bussines when working with GTK application modules. Normally one can just use a `MAIN()` subroutine and decide from there what to do. The program based on the Application module can be kept simple when we apply the `G_APPLICATION_NON_UNIQUE` flag to the initialization of Application.

But when we want more excitement we must handle the local commandline arguments and the remote ones together due to the fact that several GTK option handling classes are not supported. The Application `run()` method picks up all arguments from `@*ARGS` and when the local options handler continues, hands the arguments over to the remote options handler unaltered.

* To handle local options one must add a signal handler for the `handle-local-options` event.
* The local options handler must return an integer;
  * -1 to continue processing
  * 0 to return from `run()` with a success exit value
  * &gt; 0 to return from `run()` with a failure exit value
* To handle remote options one must add the `G_APPLICATION_HANDLES_COMMAND_LINE` flag to the initialization of Application. Also a handler must be registered for the `command-line` event.
