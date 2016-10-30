difference() 
{ 
cube([100.000,80.000,30.000], center = false); 
 translate([8.890,15.240,10.000]) rotate([0.0,90.0,0.0]) 
 linear_extrude(height = 19.050, center = false) 
 rotate([0,0,45]) square(size = 0.800, center = true); 
 translate([27.940,15.240,10.000]) rotate([0.0,90.0,-45.0]) 
 linear_extrude(height = 3.592, center = false) 
 rotate([0,0,45]) square(size = 0.800, center = true); 
 translate([8.890,5.080,20.000]) rotate([0.0,90.0,0.0]) 
 linear_extrude(height = 19.050, center = false) 
 rotate([0,0,45]) square(size = 0.800, center = true); 
 translate([27.940,5.080,10.000]) rotate([0.0,90.0,45.0]) 
 linear_extrude(height = 3.592, center = false) 
 rotate([0,0,45]) square(size = 0.800, center = true); 
} 
