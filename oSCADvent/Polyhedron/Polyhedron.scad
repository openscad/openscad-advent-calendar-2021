/* scADVENT 2021 -Polyhedron-   by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to model and animate a convex Polyhedron 
 */

/*[Polyhedron]*/
steps=36;
size=12;
rotations=1;


p=[for(i=[0:steps-1],j=[0:steps-1])
  let(x=i*360/steps,y=j*360/steps)
  [sin(x),cos(y),sin((y+x)+180*$t)]];// points changed by animation factor $t
  

color("gold")rotate([90*$t*2,0])rotate(90*$t*rotations)scale(size)AutoPoly(p);



module AutoPoly(p){
f=[for(i=[0:len(p)-3])[i,i+1,i+2]]; // faces are created arbitrary
hull()                              // a hull makes the polyheadron pieces to a solid object
polyhedron(p,f,convexity=5);
}