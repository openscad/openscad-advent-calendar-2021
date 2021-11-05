/* scADVENT 2021 - Zen by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to model an Zen Stone Garden with recursion and randomness
 */

/*[Zen]*/
size=50;
maxStone=10;
h=1.3;
base=.5;
Zen();


// Zen is meditation so we let things flow without control. The random generator rands() will help us here. But the name is misleading as there is no randomness especially in computer. There is only a level of incomprehension. But for replicability we can use a seed which will determine the diffrent values.abs
seed=round(rands(0,999999,1)[0]);//42 //making results random give this a number to safe one scene
echo("•••••");
echo(currentSeed=seed);

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
          if(2D) square(200,false);
          else cube(200,false);
    }
    
}
 

module Random(2D=true){
for (i=[0:nrStones-1])
    let(
// creating a vector with positions for each Stone
        posStones=rands(-size/2,size/2,2,seed+i*i),
// stones should have random sizes we use a special $ variable so it can be used in the child
        $r=rands(2,maxStone/2,1,seed+i*i*10)[0],
// stones should have random Scale vectors (4 values needed for each)
        scaleV=rands(0.85,2,4,seed+i*i*-20)
    ){
    translate(posStones)Scale(scaleV,2D=2D)children();
    }
}



 module Ripple(rec=4,s=2,wall=1,$fn=72){ 
     if (rec) Ripple(rec=rec-1,s=s^1.11+wall*2)children();
         
     difference(){ // making a shell s wide with distance s
         offset(s+wall)children();
         offset(s)children();
     }
 }
 
 module Zen(h=h,base=base){
// bringing all together
     sand=[1.0,0.95,0.65];
   color(sand) linear_extrude(h) Ripple()Random()circle($r);
// Now we like to put in 3D Stones at the same Positon so we use the same module but with a sphere and 2D=false and without Ripple as these work only in 2D 
    color("lightgrey")scale([1,1,rands(.75,1.5,1,seed*2456)[0]])Random(2D=false)sphere($r,$fn=72);
     
// and we need a Ground
     ripple=5*10;
   color(sand*0.8) minkowski(){
        cube([size+ripple,size+ripple,.1],true);
        cylinder(base,5,4,$fn=36);  
    }
}
 
