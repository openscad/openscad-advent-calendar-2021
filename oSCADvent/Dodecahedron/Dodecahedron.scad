/* scADVENT 2021 - Dodecahedron  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we make a wire Dodecahedron step by step
 https://en.wikipedia.org/wiki/Dodecahedron
 */

/*[Dodecahedron]*/
side=25;
strutDia=5;
cornerSize=true;
spheres=true;
orientation=0;//[0:face,1:edge,2:point]


 color("gold")WireDodecaheadron(); // <= This is what you get at the end


  // First lets see how we can construct a dodecahedron. Do (two) deca (ten)  so we have 12 pentagonal faces.
 // It is a dual to the icosaheadron (https://en.wikipedia.org/wiki/Duality_(mathematics) ) 
// So it may not surprise that we can use a similar technique but needing different ratios, and a cube.

// so lets  get our values.  We need the golden ratio PHI  and the angles (to turn it later)

PHI=(1+sqrt(5))/2; // φ the golden ratio
b=acos(-1/sqrt(5));
c=acos(-sqrt(1/10*(5-sqrt(5)))); // we only need β so ignore this
echo(beta=b,gamma=c);

// we build this not with a face but starting with an edge at the bottom

translate([l3*3,0,0])union(){
  %hull()Structure();
  %Structure();
  }

module Structure(side=side)
union(){
  for(i=[[0,90,0],[90,0,0],[0,0,90]])rotate(i)color(i/90)linear_extrude(.1,scale=0)square([side*(1+PHI),side],true); // 3× rectangles
   color("LightSkyBlue",alpha=0.5)cube(side*PHI,true); // a cube
}


// Now we have a better understanding where our Points are. We using half of the length so we can calculate from the center
l1=side/2;           //short side half
l2=side*PHI/2;      //middle from the cube
l3=side*(1+PHI)/2; //long side half


// There will be 8 (points from the cube) + 3×4 (3×rectangles) = 20 points.


function points (side=side)= // we using a function so the points are parametric with the side variable
let(
l1=side/2,           //short side half
l2=side*PHI/2,      //middle from the cube
l3=side*(1+PHI)/2 //long side half
)

[
[  0,  l1, -l3 ], [  0, -l1, -l3 ],  // starting with the bottom edge (green)
[  0,  l1,  l3 ], [  0, -l1,  l3 ], // the top edge (+ z axis)

// seems we can save some time by mirror them with a loop lets try this with the next rectangle the red one
for(x=[ -1, 1 ], z=[ -1, 1 ])[ x*l3,    0, z*l1 ],   // this will generate 4 Points on x and z
for(y=[ -1, 1 ], x=[ -1, 1 ])[ x*l1, y*l3,    0 ],  // the blue rectangle on x and y

// and a triple loop for the cube
for(x=[ -l2, l2 ],y=[ -l2, l2 ],z=[ -l2, l2 ])[ x, y, z]
];


 // so let's see if that is working
%translate([0,0,l3*3]) Dodecaeder();

module Dodecaeder(side=side)
hull()   // a hull connects all points so we can use our lazy faces methode
polyhedron(points(side),
[[for(i=[0:len(points(side))-1])i]]); // just all faces in a row looks bad but is enough to use the hull
  
  // looks good so far
 // Now the struts for our wire, we make a module to connect 2 points with a hull and using spheres
// there would be a 2nd option where we use a rotate_extrude with a square and smoothed circles but this require to calculate the angle between two vectors and length "norm()" so let's not do this today.

module Strut (p0, p1 , d=strutDia){ // strutDia was set on top in the variables
  hull(){
    $fn=24; // to make it smoother
    translate(p0)sphere(d=d);
    translate(p1)sphere(d=d);
  }

}
//  and Finaly the Dodecahedron using the Strut to connect the points, require some manual work except we would like to connect every point with every point
module Edges()
  for(j=[0:4:8])
    for(i=[0:2:3])
      Strut(points()[i+j],points()[i +1+j]);
  
  // and connecting with the cube points which are the last 8 points so starting with point 12 - 19

module CubeP(cubeP=0){
      Strut(points()[cubeP +12],points()[ 1]);
      Strut(points()[cubeP +12],points()[ 4]);
      Strut(points()[cubeP +12],points()[ 8]);
}
// we could repeat this now for all 8 points or we just loop a mirror for each axis to get all  2³= 8 corners.

module Corners()
  for(
    mx=[
        [0, 0, 0],
        [1, 0, 0]
      ],
    my=[
        [0, 0, 0],
        [0, 1, 0]
      ],
    mz=[
        [0, 0, 0],
        [0, 0, 1]
      ]
  )
  mirror(mx)mirror(my)mirror(mz)CubeP();
  

   // so lets put it together and turn on the flat side using the β (b) angle
  // and as we have all points we could add a sphere on each option
 // or let's go crazy and put tiny dodecaeder there we already done the work for it

module WireDodecaheadron(strutDia=strutDia,cornerSize=cornerSize,spheres=spheres){
  d= cornerSize==true?PHI*strutDia: // if true we use the golden ratio for them else the number provided
                   cornerSize;
  rotate(orientation==0?[-b/2, 0,0]:             // flat on the face
                        orientation==2?[0,atan(l3/l1),0]:      // on a point
                                       [0,0,0] // on the edge as we build it
  
  ){
    Corners();
    Edges();
    if(cornerSize) for (i=[ 0 : len(points())-1 ])translate( points()[i] ) {
      if (spheres) sphere( d= d, $fn=36 );
        else Dodecaeder(d);
      
    }
  }
}




  //here is another approach by intersecting / cutting 12 sides (6 intersections)
 // but this gives us only the object and no clue about the points
//color("Ivory")rotate([b/2,0,90])DH();
module DH(h=h*2.227)
intersection(){
  cube([2*h,2*h,h],true);
  intersection_for(i=[0:5])rotate(i*72)rotate([-b,0])cube([2*h,2*h,h],true);
 
}