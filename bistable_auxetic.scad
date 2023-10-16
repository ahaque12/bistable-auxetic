
/* [Parameters] */

// Hexagon side length
hex_length=25;

// t paramter
t=5;

// Theta
theta=15;

// Material thickness
thickness=2;

// Sinew holding pieces together
sinew_length=0;

// Gap sizes
gap=.5;

// eps
eps=.01;

// Rows
rows = 3;

// Columns
columns=5;

// Projects point along vector defined by angle & distance.
function proj (coord, alpha, k) = (
  [coord[0]+k*cos(alpha), coord[1]+k*sin(alpha)]
);

// Define intersection between two vectors defined by angle & distance.
function inters (p1, p2, angle1, angle2) = (
[(p1[0] - p2[0])/ (cos(angle1)-cos(angle2)), 
 (p1[1] - p2[1])/ (sin(angle1)-sin(angle2))] 
);

//Distance between two points.
function distance(p1, p2) = (
    sqrt(pow(p2[0] - p1[0], 2) + pow(p2[1] - p1[1], 2))
);

module triangle(hex_length, t, theta){
    anchor = [-hex_length, 0];
    anchor2 = [0, 0];
    anchor3 = proj(anchor, 60, hex_length);
    plength = distance(proj(anchor, 60, t), 
                       inters(proj(anchor, 60, t), [-t-gap, 0], theta, theta+90)) - sinew_length;
    polygon(points=[
        anchor,
        anchor2,
        anchor3,
    
        proj(anchor, 60, t),
        proj(anchor, 60, t+gap),
        proj(proj(anchor, 60, t+gap), theta, plength),
        proj(proj(anchor, 60, t), theta, plength),
        
        [-t, 0],
        [-t-gap, 0],
        proj([-t-gap, 0], theta+90, plength),
        proj([-t, 0], theta+90, plength),
    
        proj(anchor3, 300, t),
        proj(anchor3, 300, t+gap),
        proj(proj(anchor3, 300, t+gap), 210+theta, plength),
        proj(proj(anchor3, 300, t), 210+theta, plength),
        
    ],
    paths=[
        [0,1,2],
        [3,4,5,6],
        [7, 8, 9, 10],
        [11, 12, 13, 14]
    ]
    );
}

module hexagon(hex_length, t, theta){
    triangle(hex_length, t, theta);
    mirror([0,-hex_length ,0]) triangle(hex_length, t, theta);
    rotate([0,0,120]) mirror([0,-hex_length ,0]) triangle(hex_length, t, theta);
    rotate([0,0,120]) triangle(hex_length, t, theta);
    rotate([0,0,-120]) mirror([0,-hex_length ,0]) triangle(hex_length, t, theta);
    rotate([0,0,-120]) triangle(hex_length, t, theta);
}

module bistable_auxetic(hex_length, t, theta) {
    vertical_dist = hex_length*sin(60)*2;
    for (i=[0:rows-1])
        for (j=[0:columns-1])
            translate([hex_length*j*1.5, vertical_dist*(i+(j%2)*.5), 0]) hexagon(hex_length, t, theta);
}

linear_extrude(thickness) bistable_auxetic(hex_length, t, theta);