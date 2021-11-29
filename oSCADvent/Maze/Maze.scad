/* scADVENT 2021 - Maze  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to create a random maze as a coaster
 */

/*[Maze]*/
//cell radius
r=2;
//cell shape
shape=36;  // [36:round,4:orthogonal,8:edgy,12:less edgy]
// line width
wall=.5;
// height of the coaster
h=4;
// glas diameter in mm
coaster=90;
// n-gon sides
gon=8;
// edge radius
edgeR=5;
// generate random pattern
random=true;
// if not random use this pattern
seed=42;
// use the list below?
customList=false;
// cell switch pattern sequence
list="1001";


// custom list will generate different pattern for different r or coaster size as the number of rows and columns change

// list="110011100001010";  // example 
// list="1100011101010";  // example 
// list="11000111010";  // example 
// list="101111101";  // example 
// list="1001001";  // example 
// list="1101";   // example 




d=(coaster/2)/cos(180/gon)*2;// the inner circle of the n-gon
size=[ceil(d/(r*2)),ceil(d/(r*2))]; // needed size of the maze (rows×columns)
// size=[30,30]; //  use a fixed size to obtain a pattern with customList independently from r or coaster size

echo(rows=size.x,columns=size.y);
randomSeed=round(rands(-9999,9999,1)[0]);
echo();
echo(currentSeed=randomSeed); // so you can replicate this pattern
echo();
listC=[for(i=[0:len(list)-1])list[i]=="1"?1:0]; // converting list string into array of numbers
randoms=customList?listC:rands(0,1.999,size.x*size.y,random?randomSeed:seed); // random switch for each grid unit


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

module A(r=r,wall=1,shape=shape){
 $fn=shape;
 wall=wall/cos(180/shape); // correct line width for lower $fn
 rotate(45) difference(){
    intersection(){
      circle(r+wall/2);
      square(10);
    }
    circle(r-wall/2);
  }
}


// two of them diagonal is one cell with i as a switch to turn them 90° or not
module B(i=+0,r=r,wall=wall)
color(i?"red":"blue")translate([0,0,i?.5:0.4]) // this line is for better understanding when viewing 2D
rotate((i?90:0)){
  translate([-r,-r])rotate(-45)A(r,wall);
  translate([r,r])rotate(-45+180)A(r,wall);
}

// and a lot of them as a grid
module Maze(bottom=.5){
  $fn=36;
  color("LightGoldenrodYellow") linear_extrude(h*.75,convexity=5)  // comment this line out to view in 2D
   offset(-wall/3.5)offset(+wall/3.5) // rounding inner corners
    offset(+wall/2.5)offset(-wall/2.5) // rounding outer corners
     for(x=[0:size.x -1],y=[0:size.y -1])translate([x, y] * r * 2) // Grid of cells B()
      let(number= y +x * size.y )// the random switch is adressed as cell number - number of columns (x) × size of a column + y value of the current column
      B(floor(randoms[ number % len(randoms) ])); // we use mod % so shorter list (customList) will warp around
  color("SandyBrown")translate([-r,-r])cube(concat(size * r * 2, [bottom])); // floor
}





