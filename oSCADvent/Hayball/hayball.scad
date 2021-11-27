/* scADVENT 2021 - Hay ball   by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to create a ball filled with random sticks
 */

/*[Hay ball]*/
size=40;
stick_dia=2;
numberStems=250;


intersection(){
  for(i=[0:numberStems]) // loop for number of objects
    translate(rands(-size/2,size/2,3)) // a random array/list or vector of 3 is like [x,y,z]
    rotate(rands(-180,180,3))         // same for rotation 
    color(rands(0,1,3))              // and for color 
    cylinder(size*2,d=rands(1,stick_dia,1)[0],center=true,$fn=36); // and a random number for the diameter

  color("yellowgreen")sphere(d=size,$fn=150);//interscting object
}