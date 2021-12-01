/* scADVENT 2021 - Ball   by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to create a ball filled with random spheres or sticks
 */

/*[Ball]*/
size=50;
minSize=4;
maxSize=8;
number=500;
bubbles=true;
negative=false;



// a module to position a sphere with its shell on s, so tranlated by radius from center and moved to s
module S(r, s)
translate([s -r*(negative? -0.5: 1), 0])sphere(r, $fs=1);

if (bubbles)difference(){
  if(negative) sphere(size/2); // if negative the bubbles are substracted from this sphere
  for(i=[0 :number -1])         // making bubbles
    color(rands(0, 1, 3))
      rotate([0, 0, rands(-180, 180, 1)[0]])     // a random for Z rotation
        rotate([0, rands(-180, 180, 1)[0],0])    // a random for X rotation
          S(rands(minSize/2, maxSize/2, 1)[0] , size/2); // random size
  if(!negative) sphere(size/2 -5, $fs=1, $fa=5);// if not negative this sphere is substracted from the bubbles  
  }
  // or filled with Sticks (bubbles = false )
 // which will be moved around and rotated like hay or straw (use smaller min & max size for this)
else
intersection(){
  for(i=[0:number -1]) // loop for number of objects
    translate(rands(-size/2, size/2, 3)) // a random array/list or vector of 3 is like [x,y,z]
    rotate(rands(-180, 180, 3))         // same for rotation 
    color(rands(0, 1, 3))              // and for color 
    cylinder(size*2, d=rands(minSize, maxSize, 1)[0], center=true, $fs=1); // and a random number for the diameter

  color("yellowgreen") sphere(d=size, $fs=1, $fa=5);//interscting object
}



