// gurkansahin28@gmail.com
// climbing circles
// license: CC0 https://creativecommons.org/publicdomain/zero/1.0/
//
// y = pow((r*r - x*x), 1/2)

r = 10;

module circleqxy(r) {
    z = 0;
    for (x = [-r : 0.05 : r]) {
        y = pow((r*r - x*x), 1/2);
        translate([x, y, z]) cube(r/10, center = true);
        translate([x, -y, z]) cube(r/10, center = true);
    }
}

for (z = [-r : 1 : r]) {
    c = rands(0, 255, 3) / 255;
    rr = pow((r*r - z*z), 1/2);
    color(c, alpha = 0.8)
        translate([0, 0, z])
            circleqxy(rr);
}