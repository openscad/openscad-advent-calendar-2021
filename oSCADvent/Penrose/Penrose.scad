/* scADVENT 2021 - Penrose  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we have a look at how penrose tiling works
  https://en.wikipedia.org/wiki/Penrose_tiling
  
  Penrose is a non-repetitive or aperiodic tiling. 
  
  The process is straight forward:
  • take a triangle and build a new triangle inside the existing.
    Therefore we divide one side with a ratio so we get two triangles a smaller and a bigger.
  And a second case were we divide another side and getting three triangles. Now just repeat this with each new triangle but we only cutting the bigger in three and the smaller in two so we don't end up with big and very small triangles.
  
  — recursion is the way we accomplish this. 

 */

/*[Penrose]*/

//change recursion level
recursion=4;//[3:6]
//change symmetry
divisor=5;//[2:10] 
//change Spacing 
wall=0.5;//[0:0.01:1]
// golden ratio
PHI=1.618;
// triangle length / size
l=50;
animation=false;
seed=42;

wire=true;
h=3;

ratio=animation?PHI+ 0.3 + sin(360*$t)* 0.5:
                PHI;

function GR(a,b)=a+(b-a)/ratio; // Golden Ratio calculation


/*[Hidden]*/

a=[0, +0 ]; // first point at center

// we using two mirrored parts so each triangle is half and the angle from center hence only a quarter
angle= 360 / (divisor*4); 

b=a + [sin( angle), cos( angle)] * l; // the adjactant sides end point at angle and length
c=a + [sin(-angle), cos(-angle)] * l;

//  !polygon([a, b, c]); // uncomment to see (CTRL + SHIFT + D)



// making a printable wireframe or a 3D model
difference(){  
 if(wire) rotate(angle) linear_extrude(h)offset(wall*4,$fn=36)circle(r=l -wall*3,$fn=divisor*2);
  
for(i=[0:divisor-1])rotate(360/divisor * i) // to get a nice polar shape we put Penrose pattern together around the center
  union(){ // as they are asymetric we mirror one to get  more symmetry
   rotate(angle) Penrose();              // rotate one side to y axis
   mirror([1,0])rotate(angle)Penrose(); // rotate one side to y axis and mirror along x
  }
}

// bottom plate
if(!wire) color("gray")
            rotate([180,0,angle])
              linear_extrude(.5)
                offset(max(.5,wall*4),$fn=36)
                  circle(r=l -wall*3,$fn=divisor*2);


// The Penrose tiles generation

module Penrose(rec=recursion,tri=[a,b,c],case=1,wall=wall,color,seed = seed,scale=wire?1:0){//<- change start case 1 or 2
  a=tri[0];
  b=tri[1];
  c=tri[2];
  seedI=seed; // internal seed for predictable random numbers
  //  case=floor(rands(1,2.9999,1)[0]); we could choose to use random cases but it just look weird
  
  if (rec>0){
    if(case==1){
     // the smaller resulting tri will be cut in two the next time (case 1)
        Penrose(rec=rec-1, tri= [c       , GR(a, b), b], case=1, color= 0, seed = seed * rec + 0);

    // the bigger gets cut in 3 the next time
        Penrose(rec=rec-1, tri= [GR(a, b), c       , a], case=2, color= 1, seed = seed * rec + 1000);
    }
    if(case==2){
        Penrose(rec=rec-1, tri= [GR(b, a), GR(b, c), b], case= 2, color= 2, seed = seed * rec + 2000);
        Penrose(rec=rec-1, tri= [GR(b, c), GR(b, a), a], case= 1, color= 3, seed = seed * rec + 3000);
        Penrose(rec=rec-1, tri= [GR(b, c),        c, a], case= 2, color= 4, seed = seed * rec + 4000);
    }
  }

center=(a+(b+c)/2)/2; //middle of a triangle to get proper extrusion scale
    
    // a scaled extrusion will scale to the center but our triangles are not near the center, to make this work we have to move them into the center extrude and move back

z=animation?// extrusion height
      
        3 + 3 * 
          sin( $t * 360 + rands(-360, 360, 1,seedI)[0]):// for animation periodic (sin) but with random offset
           wire?50: // not animation but 50 for wireframe
                rands(1, h, 1,seedI)[0]; // else just random 
    
if (rec<=(animation?recursion-1:0))// only draw the pattern at the last recursion else everything overlaps as if animation
  translate([0,0,animation?5-rec/recursion*5:0]){  
  
  color(palette[color],alpha=0.4) // we need colors!
   translate(center) // move back
    linear_extrude(z,scale=scale,center=wire?true:false)
      translate(-center)  // move to center
        offset(-wall/2)polygon(tri);    
   } 
}

// just a white background
%color([1,1.0,1.0])translate([0,0,-200])rotate([-45,0])square(1000,true); 


// the colors we use

palette=[ // and our colors
// case 1
"Lime",
"Crimson",

// case 2
"ForestGreen",
"MediumPurple",
"Red",

// unused colors

"DarkRed", 
"DarkGreen",
"SeaGreen"

];