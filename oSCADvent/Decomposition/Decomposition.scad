// Written for SCADvent 2021
// Wobbly sheet by Ulrich Bär
// Cube animation by Ryan A. Colyer
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

// Recommended animation settings:  fps: 30, steps: 400

color_rate = 6;
x_speed = 6;
y_speed = 18;
rot_speed = 2;
tilemargin = 0;
tilesize = 4;
tile_count = 50;
amp_solid = 0.25;

decomp_mid = 0.5 + amp_solid/2;
decomp_half = 0.5 - amp_solid/2;
decomp_trans = decomp_half - abs($t - decomp_mid);
amplitude =
  $t < amp_solid ? 0 :
  decomp_trans < amp_solid ? (decomp_trans/amp_solid)*30 :
  30;
tilestep = tilesize + tilemargin;
sheetlen = tilesize*tile_count;
sheet_sep = amplitude;

function t3(w, phi=0) = sin($t*w + phi);
cf1 = function(x, y) [x/sheetlen, 0.5*(1+t3(color_rate*360)), y/sheetlen];
cf2 = function(x, y) [0.5*(1+t3(color_rate*360)), y/sheetlen, x/sheetlen];
cf3 = function(x, y) [y/sheetlen, x/sheetlen, 0.5*(1+t3(color_rate*360))];

module Sheet(cf) {
  for (x=[0:tilestep:sheetlen])
    for (y=[0:tilestep:sheetlen]) {
      x2 = x+tilesize;
      y2 = y+tilesize;
      t3x = t3(x_speed*360, x);
      t3y = t3(y_speed*360, y);
      t3x2 = t3(x_speed*360, x2);
      t3y2 = t3(y_speed*360, y2);
      color(cf(x, y))
        hull() {
          translate([x, y, amplitude * t3x * t3y])
            cube(0.01);
          translate([x2, y, amplitude * t3x2 * t3y])
            cube(0.01);
          translate([x, y2, amplitude * t3x * t3y2])
            cube(0.01);
          translate([x2, y2, amplitude * t3x2 * t3y2])
            cube(0.01);
        }
    }
}

module ThreeSheets() {
  translate([sheet_sep, sheet_sep, 0])
    mirror([0,0,0])
    rotate([180,0,90])
    Sheet(cf1);
  translate([sheet_sep, 0, sheet_sep])
    rotate([90,0,0])
    Sheet(cf2);
  translate([0, sheet_sep, sheet_sep])
    rotate([0,-90,0])
    Sheet(cf3);
}

rotate([0, 0, rot_speed*360*$t])
  translate(-(sheetlen/2 + sheet_sep)*[1, 1, 1]) {
    ThreeSheets();
    translate((sheetlen + 2*sheet_sep + tilestep)*[1, 1, 1])
      mirror([0, 0, 1])
      mirror([0, 1, 0])
      mirror([1, 0, 0])
      ThreeSheets();
  }

