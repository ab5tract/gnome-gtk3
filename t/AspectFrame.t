use v6;
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::AspectFrame;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::AspectFrame $af;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $af .= new(
    :label('blub'), :xalign(0.3e0), :yalign(0.5e0),
    :ratio(0.5e0), :obey-child(False)
  );

  isa-ok $af, Gnome::Gtk3::AspectFrame, '.new(:label, ...)';
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
  is $af.get-label, 'blub', '.set-label() / .get-label()';
  $af.set-label-align( 0.8e0, 0.03e0);
  my Num ( $xa, $ya) = $af.get-label-align;
  is-approx $xa, 0.8e0, '.get-label-align() xalign ok';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $af.aspect-frame-set( 0.2e0, 0.9e0, 1e0, False);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_FLOAT));
  $af.g-object-get-property( 'xalign', $gv);
  is-approx $gv.get-float, 0.2e0, '.frame_set()';
  $gv.unset;
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {

  $af .= new( :label('blub'), :xalign(0.15e0));

  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_FLOAT));
  $af.g-object-get-property( 'xalign', $gv);
  is-approx $gv.get-float, 0.15e0, 'property xalign';
  $gv.unset;

  $gv .= new(:init(G_TYPE_FLOAT));
  $af.g-object-get-property( 'yalign', $gv);
  is-approx $gv.get-float, 0.0e0, 'property yalign';
  $gv.unset;

  $gv .= new(:init(G_TYPE_BOOLEAN));
  $af.g-object-get-property( 'obey-child', $gv);
  is $gv.get-boolean, 1, 'property obey-child';
  $gv.unset;
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
