/* scADVENT 2021 - Octahedron   by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to generate a https://en.wikipedia.org/wiki/Truncated_octahedron
 and yes the last form (model 4) is also the base of a https://en.wikipedia.org/wiki/Moravian_star
 */

/*[Octahedron]*/
h=20;
cut=0;
model=0;//[0:Octahedron,1:truncatedOctahedron,2:Cuboctahedron,3:Trucatedcuboctahedron,4:Rhombicuboctahedron ]



if(!cut&&!model) for(i=[0:4])translate([i*(h +5),0])color(rands(0,1,3))Object(i);
  else Object(model);


   //  Octa means 8  like two pyramids with 4 sides
  // and truncated that we have to cut something away.
 // if we cutting ¼ an each side so half in total away we get a Cuboctaheadron with triangle and square faces
// if we take ⅙ on each side ⅓ in total we get the truncatedOctahedron

module Oktaeder(h=30,c)intersection(){
  union(){
    cylinder(h/2,r1=h/2,r2=0,$fn=4);                   // Pyramid
    rotate(180,[1,0,0])cylinder(h/2,r1=h/2,r2=0,$fn=4); // Pyramid upside down
  }
if(c)cube(c,true);
}

module Object(model){
if (model==0) Oktaeder(h=h,c=h-cut);
if (model==1) Oktaederstumpf(h=h);
if (model==2) Kuboktaeder(h=h);
if (model==3) Rhombenkuboktaeder(h=h,fn=8);
if (model==4) Rhombenkuboktaeder(h=h,fn=4,r=h/(3+1/3));  
}

module Rhombenkuboktaeder(h=20,fn=8,r){
    r=is_undef(r)?h/2.93:r;
hull(){// rhombenkuboktaeder
rotate(180/fn)cylinder(h,r=r,center=true,$fn=fn);
rotate([90,0])rotate(180/fn)cylinder(h,r=r,center=true,$fn=fn);    
rotate([0,90])rotate(180/fn)cylinder(h,r=r,center=true,$fn=fn);
}
}

module Oktaederstumpf(h=20)
intersection(){
    Oktaeder(h/2*3);
    cube(h,true);    
}

module Kuboktaeder(h=20)
intersection(){
    Oktaeder(h/2*4);
    cube(h,true);
}


