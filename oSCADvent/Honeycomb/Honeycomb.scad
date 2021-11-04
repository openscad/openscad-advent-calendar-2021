/* scADVENT 2021 - Honeycomb by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 Today we learn how to model a Honeycomb coaster. 
 A hexagon is special as its side length is equal to its radius 
 */

/*[HexCoaster]*/
glasdiameter=85;
cells=12;
h=5;
wall=.6;

HexCoaster(d=glasdiameter,h=h,wall=wall,cells=cells); //<= module call with variables

//We start with a module for it 

module HexCoaster(d=50,h=4,wall=.5,cells=12){
 $fn=36;
    
// First we need to get all Data right and a round glas needs a bigger hexagon to fit around for which we using a circle ($fn=6) with 6 fragments and the diameter as follows: 
    
    hexDiameter=d/cos(30);// as 6 Triangle meet at center and this is their height

// to get an idea we can show a dummy with # while % prevents rendering -remove *to display
    *#% union(){   
    linear_extrude(h)circle(d=hexDiameter,$fn=6);
    translate([0,0,h])circle(d=d);
     }   
// making the coaster with round edges using minkowski - as this moves another object around, we need to start smaller so we end with the size we want. but leaving the sphere size out so we getting this as padding around.
    padding=1;
    module Base(s=padding)
        translate([0,0,s])minkowski(){
            roundCorner=5;
            cylinder(h-s*2,d=hexDiameter-roundCorner,$fn=6);// hex base object
            cylinder(.01,d1=roundCorner,d2=0);// making round edges
            sphere(s);// making round edges on top and bottom
        }
    
 //now we create the Honeycomb with an offset to make room for a wall later
 //  by using two offsets we get rounded corner and end ½ wall smaller so between two we have 1× wall that way we don't need to calculate wallspace later
    module Honeycomb(hd,h=h-1,wall=wall){
        linear_extrude(h*2/3)offset(wall/2)offset(-wall)circle(d=hd,$fn=6);//base
        translate([0,0,h*2/3-.01])linear_extrude(h/3,scale=0)offset(wall/2)offset(-wall)circle(d=hd,$fn=6);//top
    }
// And we need many of them so we build a cross array for them, also we need to know how big they could be so we dividing the hexdiameter by the number which will be the distance for a hexgons + ½ side leaving 2/3 for diameter
    module HexArray(){ 
        hd=hexDiameter/(cells);//(d/cells);
        iC=hd*cos(30); // inner circle    
// as every 2nd row need to move half side to side distance - we need twice the amount for tx
        translate([-hd*.75*cells,-d/2-iC/2])// moving into center
            for(tx=[0:cells*1.8],ty=[0:cells+2])translate([tx*(hd+hd/2)/2,ty*iC+(tx%2?0:iC/2)])rotate([180])Honeycomb(hd=hd);
    }
    
    
// Now the final Steps where all modules come together. We create the holes with a difference from the Base and HexArray but make sure only taking that part from the HexArray which is inside the hexDiameter by using the intersection()
    
    difference(){
        Base();
        intersection(){
           translate([0,0,h+.1]) HexArray();
           cylinder(50,d=hexDiameter,center=true,$fn=6);
        }
        translate([0,0,h])cylinder(2,d=hexDiameter,center=true,$fn=6);// insert rim
    }

}