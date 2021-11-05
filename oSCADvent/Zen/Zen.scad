/* scADVENT 2021 - Zen by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to model an Zen Stone Garden using randomness
 */

/*[Zen]*/
variation=0;
//area
size=50;
maxStoneSize=10;
rippleHeight=1.3;
base=.5;
rippleBaseOnly=true;

Zen(); // the module build at the very bottom


// Zen is meditation so we let things flow without control. The random generator rands() will help us here. But the name is misleading as there is no randomness especially in computer. There is only a level of incomprehension. But for replicability we can use a seed which will determine the diffrent values.abs
seed=variation==0? // check if a variation is set or 0
round(rands(0,999999,1)[0])://if 0 ⇒ making results random
variation; // else use variation cuz without each render will differ from your view
echo("•••••");
echo(currentSeed_variation=seed);

// A list how many Stones (3-12) there should be
nrStones=round(rands(3,12,1,seed)[0]);
echo(str("There will be ",nrStones," stones"));
echo("•••••");
// We will not only use circular stones but like them a bit scaled therefor we make a module to scale + X and -X also -Y and +Y independently. As we like to handle 2D and 3D objects we need 2 cases.

module Scale(v=[ 1, 2, 2.5, 3],2D=true){
//             [+X,-X,  +Y,-Y]
vPairs=[
    [v[0],v[2]],// +X +Y
    [v[1],v[2]],// -X +Y
    [v[1],v[3]],// -X -Y
    [v[0],v[3]],// +X -Y
    ];   
  for(i=[0:3])  
    
    scale(vPairs[i])rotate(i*90)
    intersection(){
          children();
          if(2D) square(maxStoneSize,false);
          else cube(maxStoneSize,false);
    }
    
}
 

module Random(2D=true){
for (i=[0:nrStones-1])
    let(
// creating a vector with positions for each Stone
        posStones=rands(-size/2,size/2,2,seed+i*i),
// stones should have random sizes we use a special $ variable so it can be used in the child
        $r=rands(2,maxStoneSize/2,1,seed+i*i*10)[0],
// stones should have random Scale vectors (4 values needed for each)
        scaleV=rands(0.85,2,4,seed+i*i*-20)
    ){
    translate(posStones)Scale(scaleV,2D=2D)children();
    }
}


// creating the Ripple with a recursive module (calls itself) we can grow the distance by adding a fix number while in a loop we would need an exponential expression as we can not use x+=1 or similar expressions in oscad. And we can add wind (windspeed=ws, wind angle=wa) which is added to all following shells.
 module Ripple(rec=5,count=0,s=1,wall=0.75,wa=0,ws=0,$fn=72){ 
     if (count<rec-1) Ripple(count=count+1,s=s+0.15)
         translate([sin(wa)*ws,cos(wa)*ws]) // optional adding wind/water movement
         children();// this is the circle or sphere 
         
     difference(){ // making a shell wall wide with distance s
         offset((s+wall)*count+wall+1.5)children();
         offset((s+wall)*count+1.5)children();
     }
 }
 
 module Zen(h=rippleHeight,base=base){
// bringing all together
     sand=[1.0,0.95,0.65];
// So we have a circle that is multiplied in random position by Random() then from these Ripple() are made which are extruded into 3D and colored
   color(sand)linear_extrude(h)Ripple()Random()circle($r);
// Now we like to put in 3D Stones at the same Positon so we use the same module but with a sphere and 2D=false and without Ripple as these work only in 2D 
    color("lightgrey")Random(2D=false)
     scale([1,1,rands(.65,2.5-$r/5,1,$r)[0]]) //we use $r also as seed for z scaling and reduce the max scale for bigger stones
     sphere($r,$fn=72);
     
// and we need a Ground
     ripple=5*10;
   color(sand*0.8) 
     if(rippleBaseOnly)linear_extrude(base,scale=.95)
// for better understand you have to read the next steps bottom up as they are excecuted in that order, the last step is written first in line
        offset(-5)  // removing padding to create fillets 
        offset(10) // merging all ripples and adding padding for fillets
        Ripple()Random()circle($r);
         
     
     else minkowski(){ // a usual square base with rounded corners
        cube([size+ripple,size+ripple,.1],true);
        cylinder(base,5,4,$fn=36);  
    }
}
 
