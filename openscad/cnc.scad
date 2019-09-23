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

        translate([0, 0, 0]) rotate([0, 0, 0])
            t20_corner();
    }

    for (i=[1:3]) {
        translate([0, 0, 0]) rotate([0, 0, 0])
            motor_coupler();
    }
}

* translate([-500, 500, 0])
    inventory();

cnc_w = 500;  // w = y
cnc_l = 500;  // l = x
cnc_x_screw_l = 400;
cnc_x_motor_x_offs = 48;
cnc_x_end = 360;

cnc_stage_l = 300;
cnc_stage_w = 300;
cnc_stage_h = 100;
cnc_stage_dx = cnc_stage_l;
cnc_stage_dy = cnc_stage_w;
cnc_stage_dz = cnc_stage_h;

cnc_x_rail_offset = cnc_stage_w/2 - sc8uu_w/2;
cnc_undercarriage_l = 100; //(cnc_l - cnc_stage_dx)/2;

cnc_gantry_h = 300;

module cnc_frame(use_stl=false) {
    if (use_stl) import("stl/cnc_frame.cnc.stl");
    else {
        translate([-t20_w/2, 0, -kp08_c_h - t20_w/2])
            _cnc_frame_base();
        translate([cnc_l/2, 0, -kp08_c_h])
            gantry();
    }
}

module _cnc_frame_base() {
    // starting from edge with nema23 mount
    for (x=[0, cnc_x_end, cnc_l-t20_w]) {
        translate([x, 0, 0]) rotate([90, 0, 0])
            t20(cnc_w);
    }
    for (i=[-1, 1]) {
        translate([cnc_l/2 - t20_w/2, i * (cnc_w + t20_w)/2, 0]) rotate([0, 90, 0])
            t20(cnc_l);
        translate([t20_w / 2, i*cnc_w / 2, 0]) rotate([i * 90, 0, 0])
           t20_corner();
        for (x=[cnc_x_end, cnc_l - t20_w]) {
            translate([x - t20_w / 2, i*cnc_w / 2, 0]) rotate([i * 90, 180, 0])
               t20_corner();

        }
        translate([-t20_w/2, i*cnc_x_rail_offset, sk8_c_h + t20_w/2])
            rail(cnc_l);
        for (x=[0, cnc_l - t20_w]) {
            translate([x, i*cnc_x_rail_offset, sk8_c_h + t20_w/2])
            sk8();
        }
    }
    translate([-cnc_x_motor_x_offs, 0, nema23_mount_c_h - nema23_mount_flange_h - t20_w/2]) {
        nema23_mount(-1);
        translate([nema23_shaft_l, 0, 0])
            t08_screw(cnc_x_screw_l);
    }
    for (x=[0, cnc_x_end])
        translate([x, 0, nema23_mount_c_h - nema23_mount_flange_h - t20_w/2]) rotate([0, 0, 0])
        kp08();
    translate([-t20_w/2, 0, kp08_c_h + t20_w/2]) rotate([0, -90, 0])
        motor_coupler();

}

module gantry() {
    for (i=[-1, 1]) {
        translate([0, i * (cnc_w/2 - t20_w/2), cnc_gantry_h/2 - t20_w])
            t20(cnc_gantry_h);
        translate([
                -t20_w/2 - sk8_c_h, 
                i*(cnc_w/2 - t20_w/2), 
                cnc_gantry_h - t20_w/2 - sk8_hole_c_c/2]) 
            rotate([90, 0, 0]) 
            rotate([0, -90, 0]) 
            sk8();
    }
    translate([0, 0, cnc_gantry_h - t20_w/2]) rotate([90, 0, 0])
        t20(cnc_w);
    translate([-t20_w/2 - sk8_c_h, 0, cnc_gantry_h - t20_w/2 - sk8_hole_c_c/2]) 
        rotate([0, 0, 90]) 
        translate([-cnc_w/2, 0, 0])
        rail(cnc_w);
}


module t08_nut_holder() {
    t20(100);
    translate([t20_w/2, 0, 0]) rotate([0, 90, 0])
        t08_nut();
}

module cnc_stage(use_stl=false) {
    if (use_stl) {
        import("stl/cnc_stage.cnc.stl");
    } else {
        _cnc_stage();
    }
}

module _cnc_stage() {
    translate([t20_w/2, 0, 0]) rotate([90, 0, 0]) 
        t08_nut_holder();
    for (x=[
            t20_w/2 + sc8uu_hole_c_c_l/2, 
            3 * t20_w/2 + cnc_undercarriage_l - sc8uu_hole_c_c_l/2])  {
        for (y=[-cnc_x_rail_offset, cnc_x_rail_offset]) {
            translate([x, y, (sk8_c_h - sc8uu_c_h)/2]) 
                rotate([180, 0, 0]) 
                sc8uu();
        }
    }

    for (x=[
            t20_w/2, 
            cnc_undercarriage_l + 3 * t20_w / 2])
        translate([x, 0, t20_w/2 + sk8_c_h + sc8uu_c_h - kp08_c_h]) 
        rotate([90, 0, 0]) 
        t20(cnc_stage_w);
    for (i=[-1, 1]) {
        translate([
            t20_w + cnc_undercarriage_l/2,
            i*(-cnc_x_rail_offset - sc8uu_hole_c_c_w / 2), 
            t20_w/2 + sk8_c_h + sc8uu_c_h - kp08_c_h
            ]) 
        rotate([0, 90, 0]) 
            t20(cnc_undercarriage_l);
        translate([
            t20_w + cnc_undercarriage_l/2,
            i*(-cnc_x_rail_offset - sc8uu_hole_c_c_w / 2), 
            3 * t20_w/2 + sk8_c_h + sc8uu_c_h - kp08_c_h 
            ]) 
        rotate([0, 90, 0]) 
            t20(cnc_stage_l);

        translate([
            t20_w, 
            i * (cnc_x_rail_offset + sc8uu_hole_c_c_w/2 - t20_w/2), 
            t20_w/2 + sk8_c_h + sc8uu_c_h - kp08_c_h]) 
            rotate([i*90, 0, 0])
            t20_corner();
        translate([
            t20_w + cnc_undercarriage_l, 
            i * (cnc_x_rail_offset + sc8uu_hole_c_c_w/2 - t20_w/2), 
            t20_w/2 + sk8_c_h + sc8uu_c_h - kp08_c_h]) 
            rotate([i*90, 180, 0])
            t20_corner();
    }

}

function timewave(maximum) = maximum / 2  ; //+ 
// function timewave(maximum, t=$t) = maximum / 2 + maximum/2 * cos(360 * (is_undef(t) ? 0.5 : t));
module cnc_design() {
    show_position = [
        timewave(cnc_stage_dx), 
        cnc_stage_dy/2, 
        cnc_stage_dz/2];
    echo("Showing ", $t, show_position);
    cnc_frame(false);
    translate([show_position[0], 0, 0]) 
        cnc_stage();
}

cnc_design();