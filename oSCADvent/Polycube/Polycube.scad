/* scADVENT 2021 - Polycube  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we make a https://en.wikipedia.org/wiki/Polycube  we try a tetracube.
 tetra means 4  so always 4 cubes together  there are 8 unique possibilities
 
 */

/*[Polycube]*/
size=15;
chamfer=1;
singleCubeNr=0;


if (singleCubeNr)PolyCube(singleCubeNr);
  else for (i=[0:4],j=[0:1])translate([i,j]*size*4.5)PolyCube(i+1+j*5);


// One basis cube
module BaseC(size,edge){
  minkowski(){
    cube(size-edge*2,true);
    union(){
      linear_extrude(edge,scale=0)circle(edge,$fn=4);
      rotate([180,0])linear_extrude(edge,scale=0)circle(edge,$fn=4);
    }
  }
}


// now we have to attach multiple

module PolyCube(nr){
  id=nr%(len(blueprint)+1); // everything above 9 will count from 0 again (but gets different colors)
build=blueprint[id-1]; // we taking the needed build instructions from our list starting with 0
color(rands(0,1,3,nr)) // a random color but with nr as seed so equal tetracubes get the same color  
for(x=[0:3],y=[0:1],z=[0:1])if(build[y+z*2][x])translate([x*size -.01,y*size -.01,z*size -.01])BaseC(size,chamfer);
  
}


blueprint=[
[[1,1,0,0],     // first row x from x=0-3
 [1,1,0,0],    // second row x with y=1 this is [1]
 [0,0,0,0],   // third row x y=0 and z this is [2] this is on top of the first row
 [0,0,0,0]], // second row x y=1 and z this is [3] or [1+1*2] y+z y=0 or 1, z=0 or 2

[[0,0,1,0],
 [0,1,1,0],
 [0,0,0,0],
 [0,0,1,0]],

[[0,0,1,0],
 [1,1,1,0],
 [0,0,0,0],
 [0,0,0,0]],
 
[[1,1,0,0],
 [0,1,1,0],
 [0,0,0,0],
 [0,0,0,0]],
 
[[0,1,1,1],
 [0,0,1,0],
 [0,0,0,0],
 [0,0,0,0]],
 
[[0,1,1,0],
 [0,0,1,0],
 [0,0,0,0],
 [0,0,1,0]],
 
[[0,0,1,1],
 [0,0,1,0],
 [0,0,0,0],
 [0,0,1,0]],
 
[[0,0,0,0],  // this is the last tetracube but for filling a 3×3 we need to add a Tricube
 [1,1,1,1],
 [0,0,0,0],
 [0,0,0,0]],
 
[[1,1,0,0],  // this is one Tricube
 [1,0,0,0],
 [0,0,0,0],
 [0,0,0,0]], 
 
[[1,1,1,0],  // this is the second Tricube
 [0,0,0,0],
 [0,0,0,0],
 [0,0,0,0]]

];