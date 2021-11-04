/* scADVENT 2021 - The conjunctions by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
//   (orbit radii and planet size not to scale)

/*[conjunctions]*/

// orbital period
bodyA="Mars";//[Venus,Earth,Mars,Jupiter,Saturn,CustomA,CustomB]
bodyB="Jupiter";//[Venus,Earth,Mars,Jupiter,Saturn,CustomA,CustomB]

//play with own orbital periods
customA=7;//(.1)
customB=13;//(.1)

//auto calc number
calcOrbits=true;
//display every n days (low = many lines)
day=16;
//starting difference
delta=0;//[-360:360]
//number of orbits (earth years)
orbits=8;
/*[dimensions]*/
radiusA=30;//(0,100)
radiusB=100;

// width of the line
linesize=.45;

// extrusion h
h=1;

/*[Hidden]*/
innerRing=true;



data=[//https://en.wikipedia.org/wiki/Orbital_period
["Planet","orbitperiod yr"],
["Venus",0.615],
["Earth",1],
["Mars",1.881],
["Jupiter",11.862],
["Saturn",29.46],
["CustomA",customA],
["CustomB",customB]
];


a=search([bodyA],data)[0]; // a get the orbital period for body A
b=search([bodyB],data)[0]; // a get the orbital period for body B
echo("•••••••••••");
echo("the Numbers");
echo(search_result_lines=a,b); // Searchresult found in table position
echo(selected=data[a],data[b]); // data found there

//Orbitperiods
aOrbit_period=data[a][1]; // using the second value [1] from the search result for a
bOrbit_period=data[b][1]; // using the second value [1] from the search result for b


// calc when both planets are at the starting positon again
cycles= function(aP=round(aOrbit_period*10)/10,bP=round(bOrbit_period*10)/10,cycles=360)
    (cycles*aP)%360==0&&(cycles*bP)%360==0||cycles/day>1000?cycles:
                                                      cycles(cycles=cycles+1);

//  limit (5000 loops) and if calc orbits is used

orbitDays=min(calcOrbits?cycles():orbits*360,5000*abs(day));
echo(auto_calc_cycles=cycles(),actual_used_Days=orbitDays);
echo("•••••••••••");
%sphere(10);// SUN (not rendered %)

// making everything 3D to print
linear_extrude(h){ 
//drawing all positons for A and B
    for(i=[0:day:orbitDays]) let (rotA=i*aOrbit_period,rotB=i*bOrbit_period)
        hull(){//drawing lines between the planets (circles)
        rotate(rotA)translate([radiusA,0])circle(linesize/2,$fn=12);
        rotate(rotB+delta)translate([radiusB,0])circle(linesize/2,$fn=12);
        }
    difference(){// outside circle ring connecting Endpoints
        r=max(radiusB,radiusA); // using the biggest
        circle(r+linesize,$fn=100);
        circle(r-linesize,$fn=100);
    }
    if(innerRing)difference(){// inside circle ring connecting Endpoints
        r=min(radiusB,radiusA); // using the biggest
        circle(r+linesize,$fn=100);
        circle(r-linesize,$fn=100);
    }    
    
    
} 



