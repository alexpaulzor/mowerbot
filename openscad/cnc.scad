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

cnc_w = 500;  // w = y
cnc_l = 500;  // l = x
cnc_x_screw_l = 400;
cnc_x_motor_x_offs = 48;

cnc_x_l = 300;
cnc_y_w = 300;

cnc_x_rail_offset = cnc_y_w/2;

module cnc_frame() {
    // edge with nema23 mount
    for (x=[0, 360, cnc_l-t20_w]) {
        translate([x, 0, 0]) rotate([90, 0, 0])
            t20(cnc_w);
    }
    for (i=[-1, 1]) {
        translate([cnc_l/2 - t20_w/2, i * (cnc_w + t20_w)/2, 0]) rotate([0, 90, 0])
            t20(cnc_l);
        translate([t20_w / 2, i*cnc_w / 2, 0]) rotate([i * 90, 0, 0])
           t20_corner();
        for (x=[360, cnc_l - t20_w]) {
            translate([x - t20_w / 2, i*cnc_w / 2, 0]) rotate([i * 90, 180, 0])
               t20_corner();

        }
        translate([-t20_w/2, i*cnc_x_rail_offset, sk8_c_h + t20_w/2])
            rail(cnc_l);
        # for (x=[0, cnc_l - t20_w]) {
            translate([x, i*cnc_x_rail_offset, sk8_c_h + t20_w/2])
            sk8();
        }
    }
    translate([-cnc_x_motor_x_offs, 0, nema23_mount_c_h - nema23_mount_flange_h - t20_w/2]) {
        nema23_mount(-1);
        translate([nema23_shaft_l, 0, 0])
            t08_screw(cnc_x_screw_l);
    }
    translate([0, 0, nema23_mount_c_h - nema23_mount_flange_h - t20_w/2]) rotate([0, 0, 0])
        kp08();
    translate([360, 0, nema23_mount_c_h - nema23_mount_flange_h - t20_w/2]) rotate([0, 0, 0])
        kp08();

}

cnc_frame();