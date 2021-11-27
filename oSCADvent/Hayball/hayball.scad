/* scADVENT 2021 - Hay ball   by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to create a ball filled with random sticks
 */

/*[Hay ball]*/
size=40;
stick_dia=2;



intersection(){
  for(i=[0:200])
    translate(rands(-20,20,3))
    rotate(rands(-180,180,3))
    color(rands(0,1,3))cylinder(size*2,d=stick_dia,center=true,$fn=36);

  color("yellowgreen")sphere(d=size,$fn=150);//interscting object
}