// Written by Ryan A. Colyer for SCADvent 2021
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

ziparr = function(varr) let(
    last = min([for (v=varr) len(v)-1])
  )
  [for (i=[0:last]) [for (v=varr) v[i]]];

zip = function(v1, v2, v3=undef, v4=undef, v5=undef)
  !is_undef(v5) ? ziparr([v1, v2, v3, v4, v5]) :
  !is_undef(v4) ? ziparr([v1, v2, v3, v4]) :
  !is_undef(v3) ? ziparr([v1, v2, v3]) :
  ziparr([v1, v2]);

function _sum_rec(v, first, last, sum=0) = first > last ? sum :
  _sum_rec(v, first+1, last, sum+v[first]);

sum = function(v, first=0, last=undef) let(
    last_int = is_undef(last) ? len(v)-1 : last
  )
  _sum_rec(v, first, last_int);

avg = function(v) sum(v)/len(v);

N = 150;
size = 5;

function SnowballPts() = let(
    cube_pts = zip(rands(-1,1,N), rands(-1,1,N), rands(-1,1,N)),
    sphere_pts = [for (c=cube_pts) if (norm(c)<=1) c*size]
  )
  sphere_pts;


Snowball = function(z, ang) let(
    phi = asin(z/size),
    x = size*cos(phi)*cos(ang),
    y = size*cos(phi)*sin(ang),
    p = [x,y,z],
    dp = avg(
      [for (c=$sphere_pts) let(
          cp = c*p,
          w = cp >= 0 ? 1 : pow(exp(cp), 0.2)
        )
        w*abs(c*p)
      ]),
    r = dp*cos(phi) + 0.01
  )
  r;


module PlotClosePoints(pointarrays) {
  function recurse_avg(arr, n=0, p=[0,0,0]) = (n>=len(arr)) ? p :
    recurse_avg(arr, n+1, p+(arr[n]-p)/(n+1));

  N = len(pointarrays);
  P = len(pointarrays[0]);
  NP = N*P;
  lastarr = pointarrays[N-1];
  midbot = recurse_avg(pointarrays[0]);
  midtop = recurse_avg(pointarrays[N-1]);

  faces_bot = [
    for (i=[0:P-1])
      [0,i+1,1+(i+1)%len(pointarrays[0])]
  ];

  loop_offset = 1;
  bot_len = loop_offset + P;

  faces_loop = [
    for (j=[0:N-2], i=[0:P-1], t=[0:1])
      [loop_offset, loop_offset, loop_offset] + (t==0 ?
      [j*P+i, (j+1)*P+i, (j+1)*P+(i+1)%P] :
      [j*P+i, (j+1)*P+(i+1)%P, j*P+(i+1)%P])
  ];

  top_offset = loop_offset + NP - P;
  midtop_offset = top_offset + P;

  faces_top = [
    for (i=[0:P-1])
      [midtop_offset,top_offset+(i+1)%P,top_offset+i]
  ];

  points = [
    for (i=[-1:NP])
      (i<0) ? midbot :
      ((i==NP) ? midtop :
      pointarrays[floor(i/P)][i%P])
  ];
  faces = concat(faces_bot, faces_loop, faces_top);

  polyhedron(points=points, faces=faces, convexity=8);
}


module PlotBallFunction(Func, r, step, num_circle_steps=180) {
  ang_step = 360 / num_circle_steps;
  minplot = 0.001*step;
  phi_len = floor(90/atan(step / r));
  stepphi = 90/phi_len;

  pointarrays = [
    for (phi_i = [-phi_len:phi_len]) let(z = r*sin(phi_i*stepphi))
      [ for (ai = [0:num_circle_steps-1]) let(
            a = ai * ang_step,
            r = Func(z, a),
            rchecked = r < minplot ? minplot : r
          )
          [rchecked * cos(a), rchecked * sin(a), z]
      ]
  ];

  PlotClosePoints(pointarrays);
}


module MakeSnowball() {
  $sphere_pts = SnowballPts();
  color("#ffffff") PlotBallFunction(Snowball, size, 0.4);
}

for (y=[0:15:45])
  for (x=[0:15:45])
    translate([x,y,0]) MakeSnowball();

