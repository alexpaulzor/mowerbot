include <constants.scad>;

rod_r = 8 / 2;
rod_l = 500;

rod_mount_flange_w = 42;
rod_mount_flange_h = 6.5;
rod_mount_w = 20;
rod_mount_l = 14;
rod_mount_h = 33.5;

// moved to constants.scad
// rod_mount_hole_r = 5.5 / 2;
// rod_mount_hole_c_c = 31.5;
// rod_mount_c_h = 20;

module rod(l=rod_l) {
    rotate([0, 90, 0])
        cylinder(r=rod_r, h=l);
}

module rod_mount() {
    difference() {
        union() {
            translate([-rod_mount_l / 2, -rod_mount_w / 2, -rod_mount_c_h])
                cube([rod_mount_l, rod_mount_w, rod_mount_h]);
            translate([-rod_mount_l / 2, -rod_mount_flange_w / 2, -rod_mount_c_h]) 
                cube([rod_mount_l, rod_mount_flange_w, rod_mount_flange_h]);
        }
        translate([-rod_mount_l / 2, 0, 0])
            rod(rod_mount_l);
        rod_mount_holes();
    }
}

module rod_mount_holes(h=rod_mount_c_h) {
    translate([0, rod_mount_hole_c_c / 2, -rod_mount_c_h])
        cylinder(r=rod_mount_hole_r, h=h);
    translate([0, -rod_mount_hole_c_c / 2, -rod_mount_c_h])
        cylinder(r=rod_mount_hole_r, h=h);
}

rod_traveller_w = 34;
rod_traveller_l = 30;
rod_traveller_h = 21.7;
rod_traveller_step_h = 17;
rod_traveller_step_w = 17;
rod_traveller_hole_c_c_w = 24.5;
rod_traveller_hole_c_c_l = 18;
rod_traveller_hole_r = 4 / 2;
rod_traveller_mount_h = 4 * rod_traveller_hole_r;

module rod_traveller() {
    difference() {
        translate([-rod_traveller_l/2, -rod_traveller_w/2, -rod_traveller_h/2])
            cube([rod_traveller_l, rod_traveller_w, rod_traveller_h]);
        translate([-rod_traveller_l/2, 0, 0])
            rod(rod_traveller_l);
        
        translate([-rod_traveller_hole_c_c_l/2, -rod_traveller_hole_c_c_w/2, -rod_traveller_h/2])
            cylinder(r=rod_traveller_hole_r, h=rod_traveller_h);
        translate([-rod_traveller_hole_c_c_l/2, rod_traveller_hole_c_c_w/2, -rod_traveller_h/2])
            cylinder(r=rod_traveller_hole_r, h=rod_traveller_h);
        translate([rod_traveller_hole_c_c_l/2, rod_traveller_hole_c_c_w/2, -rod_traveller_h/2])
            cylinder(r=rod_traveller_hole_r, h=rod_traveller_h);
        translate([rod_traveller_hole_c_c_l/2, -rod_traveller_hole_c_c_w/2, -rod_traveller_h/2])
            cylinder(r=rod_traveller_hole_r, h=rod_traveller_h);
         translate([-rod_traveller_l/2, -rod_traveller_w / 2, -rod_traveller_h / 2 + rod_traveller_step_h])
            cube([rod_traveller_l, (rod_traveller_w - rod_traveller_step_w) / 2, rod_traveller_h - rod_traveller_step_h]);
        translate([-rod_traveller_l/2, (rod_traveller_w - rod_traveller_step_w) / 2, -rod_traveller_h / 2 + rod_traveller_step_h])
            cube([rod_traveller_l, (rod_traveller_w - rod_traveller_step_w) / 2, rod_traveller_h - rod_traveller_step_h]);
    }
}

module rod_traveller_mount_holes(h=rod_traveller_mount_h) {
    translate([-rod_traveller_hole_c_c_l/2, -  rod_traveller_hole_c_c_w/2, -h/2])
            cylinder(r=rod_traveller_hole_r, h=h);
        translate([-rod_traveller_hole_c_c_l/2, rod_traveller_hole_c_c_w/2, -h/2])
            cylinder(r=rod_traveller_hole_r, h=h);
        translate([rod_traveller_hole_c_c_l/2, rod_traveller_hole_c_c_w/2, -h/2])
            cylinder(r=rod_traveller_hole_r, h=h);
        translate([rod_traveller_hole_c_c_l/2, -rod_traveller_hole_c_c_w/2, -h/2])
            cylinder(r=rod_traveller_hole_r, h=h);
}


shaft_l = 400;
shaft_pillow_l = 13;
shaft_pillow_h = 30;
shaft_pillow_w = 2 * shaft_pillow_c_h;
shaft_pillow_flange_w = 55;

shaft_pillow_flange_h = 5;

// moved to constants.scad
// shaft_r = 8 / 2;
// shaft_pillow_hole_r = 5 / 2;
// shaft_pillow_hole_c_c = 42;
// shaft_pillow_c_h = 14.5;

module shaft(l=shaft_l) {
    rod(l);
}

module shaft_pillow() {
    difference() {
        union() {
            translate([-shaft_pillow_l/2, 0, 0])
                rotate([0, 90, 0])
                    cylinder(r=shaft_pillow_w/2, h=shaft_pillow_l);
            translate([-shaft_pillow_l/2, -shaft_pillow_flange_w/2, -shaft_pillow_c_h])
                cube([shaft_pillow_l, shaft_pillow_flange_w, shaft_pillow_flange_h]);
        }
        shaft(shaft_pillow_l);
        shaft_pillow_holes();
    }
}

module shaft_pillow_holes(h=shaft_pillow_flange_h) {
    translate([0, shaft_pillow_hole_c_c/2, -shaft_pillow_c_h])
        cylinder(r=shaft_pillow_hole_r, h=h);
    translate([0, - shaft_pillow_hole_c_c/2, -shaft_pillow_c_h])
        cylinder(r=shaft_pillow_hole_r, h=h);
}

traveller_h = 16;
traveller_collar_or = 11 / 2;
traveller_flange_or = 23 / 2;
traveller_flange_h = 3.75;
traveller_flange_z = 10.2;
traveller_hole_ir = 3.7 / 2;
traveller_hole_offset = 8;
traveller_num_holes = 4;
traveller_hole_angle = 360 / traveller_num_holes;
traveller_ir = 7 / 2;

gimbal_shift_z = -traveller_flange_z/2 + traveller_flange_h / 2;

module shaft_traveller() {
     //translate([0, 0, gimbal_l / 2 - traveller_flange_z / 2 + gimbal_shift_z])
        difference() {
        union() {
            cylinder(h=traveller_h, r=traveller_collar_or);
            translate([0, 0, traveller_flange_z]) {
                difference() {
                    cylinder(h=traveller_flange_h, r=traveller_flange_or);
                    for (i=[1:traveller_num_holes])
                        rotate([0, 0, i * traveller_hole_angle])
                            translate([traveller_hole_offset, 0, 0])
                                cylinder(h=traveller_flange_h, r=traveller_hole_ir);
                }
            }
        }
        cylinder(h=traveller_h, r=traveller_ir);
    }
}

nema_mount_flange_h = 3;
nema_mount_w = 50;
nema_mount_l = 50 + nema_mount_flange_h;
nema_mount_h = 51.5;
nema_mount_c_h = 30;
nema_slot_l = 35;
nema_slot_iw = 25.6;
nema_slot_ow = 34.4;
nema_mount_slot_c_c = (nema_slot_iw + nema_slot_ow) / 2;
nema_slot_w = (nema_slot_ow - nema_slot_iw) / 2;
//nema_collar_l = 35;
nema_collar_l_offset = 6;
nema_collar_l_coupler = 25;
nema_collar_l = (
    nema_collar_l_coupler + 
    nema_collar_l_offset + 
    nema_mount_flange_h);
nema_collar_or = 20 / 2;
nema_l = 48;
nema_w = 43;

module nema_mount() {
    difference() {
        union() {
            translate([0, -nema_mount_w / 2, -nema_mount_c_h]) {
                cube([nema_mount_flange_h, nema_mount_w, nema_mount_h]);
                cube([nema_mount_l, nema_mount_w, nema_mount_flange_h]);
            }
            translate([nema_collar_l_offset, 0, 0])
            rotate([0, 90, 0])
                cylinder(r=nema_collar_or, h=nema_collar_l_coupler);
        }
        shaft(nema_mount_flange_h);
        translate([(nema_mount_l - nema_slot_l)/2, nema_mount_slot_c_c/2 - nema_slot_w/2, -nema_mount_c_h])
            cube([nema_slot_l, nema_slot_w, nema_mount_flange_h]);
        translate([(nema_mount_l - nema_slot_l)/2, -nema_mount_slot_c_c/2 - nema_slot_w/2, -nema_mount_c_h])
            cube([nema_slot_l, nema_slot_w, nema_mount_flange_h]);
        rod(nema_collar_l);
    }
    % translate([-nema_l, -nema_w/2, -nema_w/2])
        cube([nema_l, nema_w, nema_w]);
}

bar_w = 1.0 * IN_MM;

module bar(length) {
    cube([length, bar_w, bar_w], center=true);
}

function get_rod_mount_c_h() = rod_mount_c_h;
function get_rod_mount_flange_w() = rod_mount_flange_w;
function get_rod_mount_l() = rod_mount_l;
function get_rod_r() = rod_r;
function get_shaft_l() = shaft_l;

$fn=30;
PI = 3.14159;

MM_PER_INCH = 25.4;


motor_short_c_c = 56;
motor_short_offset = 0.9 * MM_PER_INCH;
motor_long_c_c = 72;
motor_long_offset = 1.75 * MM_PER_INCH;
motor_collar_or = 1 * MM_PER_INCH / 2;
motor_hole_ir = 3;
motor_post_or = 0.5 * MM_PER_INCH / 2;
motor_hole_depth = 0.8 * MM_PER_INCH;
motor_post_depth = 1.5 * MM_PER_INCH;
motor_collar_h = 1.4 * MM_PER_INCH;
motor_post_to_sprocket_h = 2.0 * MM_PER_INCH;
motor_shaft_or = 0.5 * MM_PER_INCH / 2;
motor_or = 2.4 * MM_PER_INCH / 2;
motor_depth = 4.5 * MM_PER_INCH;
motor_gearbox_w = 3 * MM_PER_INCH;
motor_gearbox_depth = 2 * MM_PER_INCH;
motor_gearbox_l = 3.4 * MM_PER_INCH;
motor_sprocket_h = 0.3 * MM_PER_INCH;
motor_sprocket_or = 1.8 * MM_PER_INCH / 2;

function get_motor_tall_rotation() = atan(motor_short_c_c/2 / (motor_short_offset + motor_long_offset));

module motor_post() {
    // difference() {
      //  cylinder(h=motor_post_depth, r=motor_post_or);
        translate([0, 0, motor_post_depth - motor_hole_depth])
            cylinder(r=motor_hole_ir, h=motor_hole_depth);
    //}
}

module drive_motor(use_stl=false) {
    if (use_stl) {
        import("drive_motor.stl");
    } else {
        translate([0, 0, -motor_post_to_sprocket_h]) {
            difference() {
                union() {
                    cylinder(r=motor_collar_or, h=motor_collar_h);
                    cylinder(r=motor_shaft_or, h=motor_post_to_sprocket_h);
            
                    translate([-motor_short_c_c/2, motor_or, -motor_or])
                    rotate([0, -90, 0])
                        cylinder(r=motor_or, h=motor_depth);
                    translate([-motor_short_c_c/2 - motor_post_or, motor_long_offset - motor_gearbox_l, -motor_gearbox_depth])
                    cube([motor_gearbox_w, motor_gearbox_l, motor_gearbox_depth]);
                    translate([0, motor_long_offset, -motor_post_depth])
                        cylinder(h=motor_post_depth, r=motor_post_or);
                }
                translate([0, motor_long_offset, -motor_post_depth])
                    motor_post();
                translate([-motor_short_c_c/2, -motor_short_offset, -motor_post_depth])
                    motor_post();
                translate([motor_short_c_c/2, -motor_short_offset, -motor_post_depth])
                    motor_post();
            }
        }
    }
}