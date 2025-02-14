use v6.d;

use Gnome::Cairo::ImageSurface;
use Gnome::Cairo::Pattern;
use Gnome::Cairo;
use Gnome::Cairo::Types;
use Gnome::Cairo::Enums;

my Gnome::Cairo::ImageSurface $surface;
my Gnome::Cairo $context;

#-------------------------------------------------------------------------------
my Int ( $width, $height) = ( 120, 120);

#-------------------------------------------------------------------------------
$surface .= new( :format(CAIRO_FORMAT_ARGB32), :$width, :$height);
with $context .= new(:$surface) {
  .set-line-width(10);
  .set-source-rgba( 0, 0, 0.4, 1);
  .rectangle( 30, 30, 60, 60);
  .stroke;
}

$surface.write-to-png('stroke.png');

#-------------------------------------------------------------------------------
$surface .= new( :format(CAIRO_FORMAT_ARGB32), :$width, :$height);
with $context .= new(:$surface) {
  .set-source-rgba( 0, 0, 0.4, 1);
  .rectangle( 30, 30, 60, 60);
  .fill;
}

$surface.write-to-png('fill.png');

#-------------------------------------------------------------------------------
$surface .= new( :format(CAIRO_FORMAT_ARGB32), :$width, :$height);
with $context .= new(:$surface) {
  .set-source-rgba( 0.0, 0.0, 0.4, 1);
  .select-font-face(
    "Georgia", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD
  );
  .set-font-size(100);
  my cairo_text_extents_t $text-extends = .text-extents("a");
  .move-to(
    0.5 * $width - $text-extends.width / 2 - $text-extends.x_bearing,
    0.5 * $height - $text-extends.height / 2 - $text-extends.y_bearing
  );
  .show-text("a");
}

$surface.write-to-png('show-text.png');

#-------------------------------------------------------------------------------
$surface .= new( :format(CAIRO_FORMAT_ARGB32), :$width, :$height);
with $context .= new(:$surface) {
  .set-source-rgba( 0.0, 0.0, 0.4, 1);
  .paint-with-alpha(0.4);
}

$surface.write-to-png('paint.png');

#-------------------------------------------------------------------------------
with my Gnome::Cairo::Pattern $linpat .= new(:linear( 20, 20, 100, 100)) {
  .add_color_stop_rgb( 0, 0, 0.3, 0.8);
  .add_color_stop_rgb( 1, 0, 0.8, 0.3);
}

my Gnome::Cairo::Pattern $radpat;
with $radpat .= new(:radial( 60, 60, 30, 60, 60, 90)) {
  .add_color_stop_rgba( 0, 0, 0, 0, 1);
  .add_color_stop_rgba( 0.5, 0, 0, 0, 0);
}

$surface .= new( :format(CAIRO_FORMAT_ARGB32), :$width, :$height);
with $context .= new(:$surface) {
  .set-source($linpat);
  .mask($radpat);
}

$surface.write-to-png('mask.png');





=finish

#-------------------------------------------------------------------------------
$surface .= new( :format(CAIRO_FORMAT_ARGB32), :$width, :$height);
with $context .= new(:$surface) {
}

$surface.write-to-png('.png');
