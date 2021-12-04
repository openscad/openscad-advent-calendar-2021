/* scADVENT 2021 - Tower  by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we have a Tower, not much code needed for this
 */

/*[Tower]*/
max=15;
s=25;
h=3;


Tower(s,max,h);

// recursively one cube on the other, each a little smaller 

module Tower(s=25,max=25,h=3,count=0){
  if(count<max)translate([0,0,1])rotate(137.5/4)Tower(count=count+1,max=max,s=s*0.877,h=count*5);
  color(count/max*[1.0,0.5,0.7]+[0.0, 0.5, 0.3])translate([-s/2,-s/2])cube([s,s,h],false);
}
