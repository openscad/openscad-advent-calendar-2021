/* scADVENT 2021 - ColorCube  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today just a multi colored cube with animation
 */

/*[ColorCube]*/
//size
s=10;
//edge r
r=1.0;//(.5)

c1="red";
c2="blue";
c3="green";
c4="yellow";
c5="orange";
c6="white";


// we can color a single face not directly but via difference with a colored object

// there are many nice colors to choose from https://en.wikipedia.org/wiki/Web_colors

colors=[c1, c2 ,c3 ,c4 ,c5 ,c6]; // first bring all colors into an array / list

module ColorCube(colors=colors){
difference(){
  minkowski(){
    // we need to remove 2×r to add the sphere r on both sides with the minkowski keeping the desired size, but by making it a little bigger (removing less) the difference will remove just a little surface to color it and bring it to size
    cube(s -r*2 + 0.05,true); 
    sphere(r ,$fn=36);
  }
  for(i=[0:5])
    let (v=[            // The vectors for all 6 positions
        [  1,  0,  0],
        [  0,  1,  0],
        [  0,  0,  1],
        [ -1,  0,  0],
        [  0, -1,  0],
        [  0,  0, -1]
    ])
  translate(v[i]*s)color(colors[i])cube(s,true);
  }
}

// !ColorCube();  // uncomment to see ( ctrl + shift + D )

// now we could make a 3D Grid with this
grid=[3,3,3];
spacing= $preview? s * 1.5 + 3 * sin($t*360*6+45) :  // for more space between cubes and animation
                   s * 1.075; // when render only a small gap

translate((grid-[1,1,1])/2 * -spacing) // bring it into center
for (
  x=[0:grid.x -1],
  y=[0:grid.y -1],
  z=[0:grid.z -1]) translate([x,y,z] * spacing )
    rotate([ 360, 360, -360]*($preview?$t:0)*3) // rotation only in $preview for animation
  ColorCube();


// for printing we should fill the internal voids by adding a cube (when not $preview)
// the spacing is only 1 less than cubes and we need to add 2× half the cube size for the rest
// then we need it to be little smaller so just removing 1× r  and we remove another 2× r as we using the minkowski again.

if(!$preview)color("grey")minkowski(){
  cube((grid-[1,1,1]) * spacing -[r,r,r] * 3 + [s,s,s],true);
  sphere(r ,$fn=36);
}

 // for animation we change the viewport with $t the animation variable
// to use this click on "View" and animate fiill FPS with 15 and Steps with 240

$vpr=[360, 360, -360]*$t; //  ctrl + D  to comment this line so viewport doesn't change / reset 

