/* scADVENT 2021 - Oloid  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to model an https://en.wikipedia.org/wiki/Oloid
 */

/*[Olioid]*/
d=20;
hull=true;
cut=0;//[0:X,1:Z]

// using a hull makes it look different but doesn't change the rolling behaviour
%rotate(90,[cut,1-cut])if(hull)hull()Oloid();
else Oloid();

//For better print we only print a half 2×
// the symetrie allows us to choose one from 3 axis (y and z are the same shape)
difference(){
rotate(90,[cut,1-cut])if(hull)hull()Oloid();
else Oloid();

rotate(180,[1,0])cylinder(150,d=150); // cutting -z away
cylinder(d/1.5,d1=2.5,d2=2,center=true,$fn=36);// hole for filament as connector

}
module Oloid (d=d) {
    
    translate([-d/4,0])Disc(d); // disc moved half radius left
    translate([d/4,0])rotate(90,[1,0])Disc(d);// disc moved half radius right and rotated 90°
    
}


//a disc with a round edge
module Disc(d,edgeR=.5,$fn=72){    
   
  // easy to make with minkowski but slower
  *  minkowski(){
        cylinder(h=.001,d=d-edgeR*2);
        sphere(edgeR);
    }
    
 // better as more performant
    rotate_extrude(convexity=5){
        translate([d/2-edgeR,0])circle(edgeR);
        translate([0,-edgeR])square([d/2-edgeR,edgeR*2]);
    }
}// end Disc