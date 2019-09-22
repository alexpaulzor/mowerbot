include <lib/motion_hardware.scad>;
include <lib/t20beam.scad>;
include <lib/motors.scad>;

/** 
 * REFERENCE:
 * center_height:
   * kp08 pillow block    : 15mm
   * sk8 rail mount       : 20mm
   * sc8uu linear bearing : 11mm
   * nema23 mount         : 39mm  [36mm from top]
   * nema17 mount         : 30mm

 */

module inventory() {
	for (i=[1:2]) {
		translate([0, 0, i*100]) rotate([0, 0, 0])
			nema23_mount();
		translate([0, 0, i*100]) rotate([0, 0, 0])
			nema23();
	}
	for (i=[1:2]) {
		translate([0, 100, i*100]) rotate([0, 0, 0])
			nema17_mount();
		translate([0, 100, i*100]) rotate([0, 0, 0])
			nema17();
	}

    for (i=[1:1]) {
        translate([100, i*100, 50]) rotate([0, 0, 0])
            t08_nut();
        translate([100, i*100, 0]) rotate([0, 90, 0])
            t08_screw(400);
    }
    for (i=[1:2]) {
        translate([120, i*100, 50]) rotate([0, 0, 0])
            t08_nut();
        translate([120, i*100, 0]) rotate([0, 90, 0])
            t08_screw(300);
    }
    for (i=[1:5]) {
        translate([200, i*100, 0]) rotate([0, 90, 0])
            rail(500);
    }
    
    for (i=[1:2]) {
        translate([220, i*100, 0]) rotate([0, 90, 0])
            rail(250);
    }
    
    for (i=[1:min(21, 6)]) {
        translate([100, 100, i*100]) rotate([0, 90, 0])
            kp08();
    }
    
    for (i=[1:min(30, 10)]) {
        translate([200, 100, i*100]) rotate([0, 90, 0])
            sk8();
    }
    
    for (i=[1:12]) {
        translate([200, 200, i*100]) rotate([0, 90, 0])
            sc8uu();
    }

    for (i=[1:6]) {
        translate([300, i*100, 00]) rotate([0, 0, 0])
            t20(500);
    }
}

* translate([-500, 500, 0])
    inventory();

cnc_w = 500;
cnc_l = 500;
cnc_screw_l = 400;
cnc_x = 300;
cnc_y = 300;


module cnc_frame() {
    // edge with nema23 mount
    translate([0, 0, 0]) rotate([90, 0, 0])
        t20(cnc_w);
    for (i=[-1, 1])
        translate([cnc_l/2 - t20_w/2, i * (cnc_w + t20_w)/2, 0]) rotate([0, 90, 0])
        t20(cnc_l);
    

    % translate([0, 0, 0]) rotate([0, 0, 0])
        t20(500);
    % translate([0, 0, 0]) rotate([0, 0, 0])
        t20(500);
    % translate([0, 0, 0]) rotate([0, 0, 0])
        t20(500);

    % translate([0, 0, 0]) rotate([0, 0, 0])
        t20_corner();
    % translate([0, 0, 0]) rotate([0, 0, 0])
        t20_corner();
    % translate([0, 0, 0]) rotate([0, 0, 0])
        t20_corner();
    % translate([0, 0, 0]) rotate([0, 0, 0])
        t20_corner();
    % translate([0, 0, 0]) rotate([0, 0, 0])
        t20_corner();
    % translate([0, 0, 0]) rotate([0, 0, 0])
        t20_corner();
    
    
}

cnc_frame();