// Written in 2021 by Ryan A. Colyer for SCADvent 2021
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

$fa=1; $fs=0.4;

width = 170;
height = 50;
thickness = 6;
hook_width = 4;
hook_extent = 20;
hook_count = 5;
roundby = 5;
display_text = "Merry Christmas";
screw_holes = true;
hole_diam = 4;

module Hook() {
  translate([-thickness/2, thickness-height/2, (hook_extent+hook_width)/2])
  rotate([0, 90, 0])
  linear_extrude(thickness)
  offset(hook_width/2)
    difference() {
      circle(hook_extent/2);
      translate([0, 0.1]) circle(hook_extent/2);
    }
}

module KeyHolder() {
  x_extent = (width-height)/2;
  linear_extrude(4) offset(roundby) hull() {
    translate([x_extent, 0])
      rotate(360/16)
      circle(height/2-2*roundby, $fn=8);
    translate([-x_extent, 0])
      rotate(360/16)
      circle(height/2-2*roundby, $fn=8);
  }

  for (i=[0:hook_count-1])
    translate([2*x_extent*(i+0.5-hook_count/2)/hook_count, 0, 0])
    Hook();
}

difference() {
  color("#b3000c")
    KeyHolder();
  color("#1E792C") {
    translate([0, 0, 1])
      linear_extrude(thickness, convexity=4)
      resize([width-height, -1], auto=true)
      text(display_text, height/2, halign="center", valign="center");
    if (screw_holes) {
      translate([width/2-0.3*height, 0, -1])
        cylinder(h=thickness+2, d=hole_diam);
      translate([0.3*height-width/2, 0, -1])
        cylinder(h=thickness+2, d=hole_diam);
    }
  }
}

