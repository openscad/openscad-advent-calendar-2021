/* scADVENT 2021 - Neuron   by Ulrich Bär  license:CC0 
 https://creativecommons.org/publicdomain/zero/1.0/
 
 
 Today we learn how to model a lightning or a neuron
 */

/*[lightning]*/
number=10;
recursion=20;//[5:25]


for (i=[0:number-1])rotate(i*360/number)translate([4,0])F(rec=recursion); // number of objects
  // origin or soma
color("deeppink",alpha=0.7)sphere(5,$fn=36);
color("navy",alpha=0.3)sphere(6.5,$fn=36);
color("navy",alpha=.2)sphere(8,$fn=36);

// the recursive zigzag path
module F(rec=15,dir=0,zcolor,alpha=1){ 
 l=rands(2, 25, 1)[0];                                     // length of the Segment
 zufall=floor( rands(1, 3.999, 1)[0]);                        //  direction change or split case
 zcolor=is_num(zcolor)?zcolor:floor(rands(0, len(colorList)-.001, 1)[0]); // random color from list if not set
 deg=rands(15, 65, 1)[0];     // random direction z
 degy=rands(15, 65, 1)[0];   // random direction z
    if (rec>0){
     if(dir<100)if(zufall == 1 || zufall == 3)  translate([l-.5, 0]) rotate([0,degy, deg]) F(rec-1,dir= dir+deg,zcolor=zcolor,alpha=alpha-.05);      //  one direction
     if(dir>-100)if(zufall == 2 || zufall == 3)  translate([l-.5, 0]) rotate([0,-degy, -deg]) F(rec-1,dir= dir-deg,zcolor=zcolor,alpha=alpha-.05); //  alteranting other direction
    }
        
translate([l/2,0])color(colorList[zcolor],alpha=max(.1,alpha))linear_extrude(rec/10)offset(.5)square([l,max(0.01,alpha)*3],true);
 
}

// a palette, a list of web colors https://en.wikipedia.org/wiki/Web_colors
colorList=[
"Turquoise",
"Aqua",
"Aquamarine",
"MediumBlue",
"Blue",
"MidnightBlue",
"RoyalBlue",
"SteelBlue",
"DodgerBlue",
"DeepSkyBlue",
"CornflowerBlue",
"SkyBlue",
"LightSkyBlue",
"Indigo",
"Purple",
"DarkMagenta",
"DarkViolet",
"DarkSlateBlue",
"BlueViolet",
"DarkOrchid",
"Magenta",
"SlateBlue",
"MediumSlateBlue",
"MediumOrchid",
"MediumPurple",
"Orchid",
"Violet",
"Plum",
"Thistle"
];