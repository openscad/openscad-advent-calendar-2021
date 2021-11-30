// gurkansahin28@gmail.com
// sphere equation
// license: CC0 https://creativecommons.org/publicdomain/zero/1.0/
//
// x*x + y*y + z*z = r*r

r = 20;
rs = r*r;

for (x = [-r : 1 : r]) {
    for (y = [-r : 0.3 : r]) {
        z = sqrt(r*r - (x*x + y*y));
        color([abs(y) * 12, 200, 120] / 255, alpha = abs(y) / 9)
            translate([x, y, z])
                cube(0.6);
    }
}
