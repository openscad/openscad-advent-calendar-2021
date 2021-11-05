/* scADVENT 2021 - icosahedron  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to model an https://en.wikipedia.org/wiki/Icosahedron
 */

/*[icosahedron]*/
s=20;
r=3;
// there is a very simple way but we need the golden ratio https://en.wikipedia.org/wiki/Golden_ratio
phi=(1+sqrt(5))/2;

dA=acos(-sqrt(5)/3);// Dihedral angle for an icosahedron needed to get a flat side down for printing

rotate(dA*0.5,[+0,1,0])minkowski(){ // rounding edges
                    Icosahedron(s-r);//in this special case we reduce only 1×r
                    sphere(r,$fn=72);
                }

module Icosahedron(s=s){
  
// we use 3 golden ratio squares each rotated 90deg on one axis and put a hull around, 
// you can deactivate //hull() by comment the line 23 (ctrl+d) to see the underlying structure   
 hull()
    for(rot=[[0,1,0],[1,0,0],[0,0,1]])
        rotate(90,v=rot)
        linear_extrude(.01,scale=0)//by using extrusion (scale=0) we get only one edge 
        square([s,s*phi],true);  

}
