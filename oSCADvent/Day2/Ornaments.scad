// decorating the tree by Ulrich Bär


/*[TreeBall]*/
d=50;
twist=3;//[0:6]
Onehalf=false;
$fn=36;

// render only one half for easy printing ×2 - put them together with a thread
difference(){
    union(){
        if(!Onehalf)HalfBall();
        rotate([180,0,twist*30])HalfBall();
    }
    cylinder(h=d*2,d=2.5,center=true); // hole for the thread
}

// creating a 12 point star by overlapping 4 Triangles
// removing the left side to make half a rotate extrusion working
module HalfBall(offsetValue=2){//⇐ change the offsetValue here
    rotate([-90])rotate_extrude(angle=180,convexity=5)
    difference(){
      // substracting and adding offset for rounding inner and outer edges
      offset(offsetValue)offset(-offsetValue*2)union(){
           rotate(0)  circle(d=d+offsetValue*6,$fn=3);
           rotate(30) circle(d=d+offsetValue*6,$fn=3);
           rotate(60) circle(d=d+offsetValue*6,$fn=3);
           rotate(90) circle(d=d+offsetValue*6,$fn=3); 
        }
        translate([0,-d])square(d*2); // removing left side as rotate_extrude can only work with positive or negatve side of the rotational axis.
    }
}
