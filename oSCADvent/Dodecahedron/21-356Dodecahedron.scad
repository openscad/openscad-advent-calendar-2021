  // Dodecahedron bone cage by Ulrich Bär
 // This work is released with CC0 into the public domain.
// https://creativecommons.org/publicdomain/zero/1.0/

$fs=0.75;
$fa=3.6;

l=25;
d=3;

ball=d *(sqrt(5) +1 )/1.25;
of=l/1.25;

Dodecahedron(l, d, ball);
a=-acos(sqrt(5) /5 );//-atan((sqrt(5)-1)/2)*2;
echo(a);

function iCr(l)=l /2 /tan(72 /2 );


module Strut(l, d, ball,i)render()
  rotate([90, 0])
  difference(){
    rotate(0)rotate_extrude()
      difference(){
        offset(-of)offset(of)union(){
          translate([0, l/2, 0])circle(d=ball + (i?0.07:-.07));
          square([d, l], true);
          translate([0, -l/2, 0])circle(d=ball -.07);
        }
        translate([0, -250])square(500);
      }
  if(!i)translate([0, 0,  l/2])sphere(d=ball );
  translate([0, 0, -l/2])sphere(d=ball);
    }


module D(l,d,ball)
translate([iCr(l),0])rotate(72 /2)  
  for(i=[0: 2])rotate(i *72)translate([iCr(l),0]) Strut(l, d, ball,i); 

module Do(l, d, ball, a)
  for(i=[0: 4])rotate(i *72)translate([iCr(l),0])rotate([0, a, 0]) D(l, d, ball);

module Dodecahedron(l, d, ball){
  ri=l /20 *sqrt(250 +110 *sqrt(5));
  Do(l, d, ball, a);
  translate([0, 0, ri *2])rotate(72 /2)Do(l, d, ball, -a);
}

