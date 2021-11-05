/* scADVENT 2021 - a Cone by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to model a cone
 */

/*[Cone]*/
d=20;
h=60;
seeds=400;


if($preview)Cone(d,h,seeds);
    
// for printing (render) we turn this upside down else we would need a lot of supports - this way we don't need any supports, and make it a little flat to get more contact area 
   else difference(){
            translate([0,0,h+d/2.5])rotate(180,[1,0])Cone(d,h,seeds);
// for a hanger a piece filament to lock a thread in
            cylinder(50,d1=3,d2=2,$fn=36,center=true);
// cutting the floor to have enought adheason area on the print bed
            translate([0,0,-50])cube(100,true); 
   }


// Nature uses for a lot of radial arrangements an angle called https://en.wikipedia.org/wiki/Golden_angle

// first a module

module Cone(d,h,seeds,s=2.5){
ga=180*(3-sqrt(5)); // the golden angle
echo(goldenAngle=ga);
//a lower radius as it is a cone
r=d/6; // half d radius d/2/2   
// so it looks something like this (remove * to display)
*#%cylinder(h=h,r1=r,d2=d);   

  for (i=[0:seeds])                 // loop ×seeds time
    let(
    deg=i*ga,                     // the golden angle rotation
    height=5+i*h/seeds,          // the height
    r=r+(d/2-r)/seeds*i -1.3,   // the radius following the cone but bit smaller
    a=85-pow(5,2.25/seeds*i),  // the Seed angle
    s=s+pow(s,1/seeds*i),     // changing the size
    c=1/seeds*i              // a counter 0-1 for color 
    )
    color([0.7,0.4,c/2])   // a little color for fun
    rotate(deg) 
    translate([r,0,height])Seed(a,s); // translating radius and height to the single Seed

//the inner part
  color([0.7,0.4,0.2])
    hull(){
      translate([0,0,h])sphere(d=d);//top
      sphere(r=r);//low

    }

}  // end of module Cone


// making a Seed
module Seed(a=60,s=5){
   hull(){
    sphere(1); // anchor point
       
    rotate([0,a])// changable angle
       
    scale([1.75,1,1])// making it rhombus shaped bei streching 
    translate([s*sqrt(2),0])   // moving corner into center
    rotate(45)
    cube([s,s,1],true);// base shape
   }
}

