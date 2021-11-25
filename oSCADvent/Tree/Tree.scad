/* scADVENT 2021 - Tree  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to create a 2D fractal and extrude it into a modern stylized Tree.
 So what is a fractal https://en.wikipedia.org/wiki/Fractal
 It is called fractal because it covers only a fraction of the area a square would.
 That means it doesn't matter how high we crank the recursion we can never fill all voids.abs
 
 An easy way is to put an object around itself multiple times.
 */

/*[Fractal]*/
recursions=6;
size=30;
scaling=0.55;

/*[Tree]*/
h=150;
twist=240;
intersection=false;
star=true;


// An intersection of counterwise twisted trees - for printing this is difficult so we only use one tree
color("green") intersection(){
  Tree( h, twist);
  if(intersection) Tree( h, -twist);
}

// and a Star on top
if (star) color("gold")translate([0,0,h])rotate([0,-90])Star(size);

// 3D extrusion with scale and twist of our recursive fractal shape 

module Tree (h,twist)linear_extrude(h,scale=.05,twist=twist,slices=h,convexity=15)
  Fractal(recursions,size,scaling);


// We create a 2D shape recursively by creating a triangle and then calling that module again and again rotated on each side with decreasing size. So we end up with triangels on each side that themself have tinier triangles on their sides.


module Fractal(recursions,l,sf,counter=0){

    if(counter<recursions){  // as long the counter hasn't reached the recursion level call the module twice (thrice for the first count). The Number of triangles will double with each recursion.
      
      y= l/2+l/2*sf -0.1;  // to align the sides we have to move it l/2 to get on the side plus moving the distance of the attached tinier triangle l/2*sf and ensure 0.1 overlap
      
      rotate( 60) translate([ 0, y ])     // left branch called with shorter length (scaled by sf)
        Fractal( counter= counter+1, l= l*sf, sf= sf, recursions=recursions);  

      rotate(-60) translate([ 0, y ])   // right branch 
        Fractal( counter= counter+1, l= l*sf, sf= sf, recursions=recursions);  
      
    // The part down is only called once at the begining to start the 3rd branch after that there is no need for it because it would propagate inside the first triangle.
      
      if(counter == 0) rotate(180) translate([0, y ]) // 3rd branche called once
        Fractal( counter= counter+1, l= l*sf, sf= sf, recursions=recursions);  
    }


// The triangle placed in each branch
  color([1-counter/recursions,1.0,1-counter/recursions]*0.8) rotate(-30)circle(r=l, $fn=3); 

}

module Star(size)
for(i=[
  [0,0,0], [ 90, 0, 0], [ 0, 90, 0], 
  [180 ,0,0], [ -90, 0, 0], [ 0, -90, 0]
]) rotate(i)linear_extrude(5,scale=0){
  circle(d=size,$fn=3);
  rotate(60) circle(d=size,$fn=3);
  
}
