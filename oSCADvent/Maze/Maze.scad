/* scADVENT 2021 - Maze  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to create a random maze as a coaster
 */

/*[Maze]*/
//cell radius
r=2;
wall=.5;
h=4;
// glas diameter
coaster=90;
// n-gon sides
gon=8;
// edge radius
edgeR=5;
// generate random pattern
random=true;
// if not random use this pattern
seed=42;


d=(coaster/2)/cos(180/gon)*2;// the inner circle of the n-gon
size=[ceil(d/(r*2)),ceil(d/(r*2))]; // needed size of the maze (rows×columns)


randomSeed=round(rands(-9999,9999,1)[0]);
echo();
echo(currentSeed=randomSeed); // so you can replicate this pattern
echo();
randoms=rands(0,1.999,size.x*size.y,random?randomSeed:seed); // random switch for each grid unit


// the coaster

intersection(){
  Maze();
  translate([-r,-r]+size*r)rotate(180/gon)cylinder(50,d=d+wall*2,center=true,$fn=gon);
}
color("NavajoWhite")linear_extrude(h) // rim
translate([-r,-r]+size*r)rotate(180/gon)difference(){
  offset(wall*2+edgeR,$fn=36)offset(-edgeR)circle(d=d,$fn=gon);
  offset(edgeR,$fn=36)offset(-edgeR)circle(d=d,$fn=gon);
}


// square Wall of the whole maze in case you prefer that
*linear_extrude(h) // rim
  translate([-r,-r]+[wall,wall])difference(){
    offset(wall*2)square(size*r*2-[wall,wall]*2);
    offset(wall)square(size*r*2-[wall,wall]*2);
  }


   // We need an element to change the maze, this could be an edge that changes or a wall
  // here we using the part between two circles as a pathway

// starting with a quarter circle ring
module A(r=r,wall=1){
 $fn=36;
 rotate(45) difference(){
    intersection(){
      circle(r+wall/2);
      square(10);
    }
    circle(r-wall/2);
  }
}

// two of them diagonal with i as a switch to turn them 90° or not
module B(i=+0,r=r,wall=wall)rotate((i?90:0)){
  translate([-r,-r])rotate(-45)A(r,wall);
  translate([r,r])rotate(-45+180)A(r,wall);
}

// and a lot of them as a grid
module Maze(bottom=.5){
  color("LightGoldenrodYellow")linear_extrude(h*.75,convexity=5)  
    for(x=[0:size.x -1],y=[0:size.y -1])translate([x, y] * r * 2)B(floor(randoms[ y +x * size.y ]));// the random switch is adressed as cell number - number of columns (x) × size of a column + y value of the current column
  color("SandyBrown")translate([-r,-r])cube(concat(size * r * 2, [bottom])); // floor
}





