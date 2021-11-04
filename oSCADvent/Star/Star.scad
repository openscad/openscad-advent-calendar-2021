/* scADVENT 2021 - The Star  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/

// Today: how to make a star hanger
// After Printing you can Twist each shell a little to get a nice 3D hanger from a flat print (maybe put in warm water for that or use a hair dryer).



$fn=36;// ensure small radii are not getting blocky
/*[Star]*/
points=5;
r1=40;
r2=20;
wall=1.0;
//number inner shells
limit=+8;
/*[Hidden]*/
h=1.2;


//A 5 point Star has 5 inner and 5 outer points so we make 10 alternating with r1 and r2
// and rotate 360° arround by using sin(deg),cos(deg)
// if r1 and r2 are equal we get a n-sided circle(r,$fn=n);


Star=function (n,r1,r2) 
    [[for(i=[0:n*2 -1])let(
        r=i%2?r2:r1, // alternating r1 and r2 every second point
        deg=i*360/(n*2)) // number * degree per segment
        [sin(deg)*r,cos(deg)*r]],//points
     [[for(i=[0:n*2])i%(n*2)]] // path last path point = first 
    ];

// putting points and path into a variable by assigning the variables to Star()
pointsS=Star(points,r1,r2);
echo(points=pointsS[0]);
echo(path=pointsS[1]); 
// making a module that creates a wall as difference of two stars and allows to reduce it    
module Star(wall=wall,sizeRed=0) 
    difference(){// making a shell
     offset(wall/2)offset(delta=-sizeRed)polygon(pointsS[0],pointsS[1]);
     offset(-wall/2)offset(delta=-sizeRed) polygon(pointsS[0],pointsS[1]);
    }


// making Stars within Stars and 3D
linear_extrude(height=h,convexity=5)
for (i=[0:limit]) Star(sizeRed=i*wall*2);
    

// making a hanger and connection and 3D
linear_extrude(height=.6,convexity=5)// connection need to stay low so it can be twisted later
union(){//Hanger and connection 2D
    difference(){
      offset(-5) offset(5){// fillet 5mm for hanger circle
           translate([-wall/2,-2])square([wall,r1+5]); // connection
           translate([0,r1+15]) circle(7.5+wall/2); // hanger
           }
    translate([0,r1+15])circle(7.5-wall/2);// hole for hanger
    offset(delta=-wall*2*limit)polygon(pointsS[0],pointsS[1]); //removing center     
        
    }
}