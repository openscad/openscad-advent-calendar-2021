s=15;
size=3;
wall=5;
padding=0.75;
cham=.75;





difference(){
  Box();
  translate([0,0,cham*2])
    for(rot=[[90, 0], [90, 0, 90]])rotate(rot)
      for(i=[-size/2+1:size/2-1])translate([i*s, 0])
        rotate([0, 0, 30])cylinder(s*size, r=cham, $fn=3, center=true);
  
}



module Box(side=s*size+wall*2+padding*2)
minkowski(convexity=5){
  difference(){
    translate([0,0, side/2]) cube(side-cham*2,true);
    translate([0,0, side/2-wall+cham*2.0001]) minkowski(){
      cube(side-wall*2-cham*2,true);
      scale(2)union(){
        cylinder(cham, r1=cham, r2=0, $fn=4);
        rotate([180, 0])cylinder(cham, r1=cham, r2=0, $fn=4);
      }
    }
    translate([0,0, s/3*2])cylinder(150,d=500);
    }
    
  union(){
    cylinder(cham, r1=cham, r2=0, $fn=4);
    rotate([180, 0])cylinder(cham, r1=cham,r2=0, $fn=4);
    
  }
}


%cube(size*s, true);