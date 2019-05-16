motor_short_c_c = 56;
motor_short_offset = 0.9 * IN_MM;
motor_long_c_c = 72;
motor_long_offset = 1.75 * IN_MM;
motor_collar_or = 1 * IN_MM / 2;
motor_hole_ir = 3;
motor_post_or = 0.5 * IN_MM / 2;
motor_hole_depth = 0.8 * IN_MM;
motor_post_depth = 1.5 * IN_MM;
motor_collar_h = 1.4 * IN_MM;
motor_post_to_sprocket_h = 2.0 * IN_MM;
motor_shaft_or = 0.5 * IN_MM / 2;
motor_or = 2.4 * IN_MM / 2;
motor_depth = 4.5 * IN_MM;
motor_gearbox_w = 3 * IN_MM;
motor_gearbox_depth = 2 * IN_MM;
motor_gearbox_l = 3.4 * IN_MM;
motor_sprocket_h = 0.3 * IN_MM;
motor_sprocket_or = 1.8 * IN_MM / 2;

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

nema17_mount_flange_h = 3;
nema17_mount_w = 50;
nema17_mount_l = 50 + nema17_mount_flange_h;
nema17_mount_h = 51.5;
nema17_mount_c_h = 30;
nema17_slot_l = 35;
nema17_slot_iw = 25.6;
nema17_slot_ow = 34.4;
nema17_mount_slot_c_c = (nema17_slot_iw + nema17_slot_ow) / 2;
nema17_slot_w = (nema17_slot_ow - nema17_slot_iw) / 2;
//nema17_collar_l = 35;
nema17_collar_l_offset = 6;
nema17_collar_l_coupler = 25;
nema17_collar_l = (
    nema17_collar_l_coupler + 
    nema17_collar_l_offset + 
    nema17_mount_flange_h);
nema17_collar_or = 20 / 2;
nema17_l = 48;
nema17_w = 43;

module nema17_mount() {
    difference() {
        union() {
            translate([0, -nema17_mount_w / 2, -nema17_mount_c_h]) {
                cube([nema17_mount_flange_h, nema17_mount_w, nema17_mount_h]);
                cube([nema17_mount_l, nema17_mount_w, nema17_mount_flange_h]);
            }
            translate([nema17_collar_l_offset, 0, 0])
            rotate([0, 90, 0])
                cylinder(r=nema17_collar_or, h=nema17_collar_l_coupler);
        }
        shaft(nema17_mount_flange_h);
        translate([(nema17_mount_l - nema17_slot_l)/2, nema17_mount_slot_c_c/2 - nema17_slot_w/2, -nema17_mount_c_h])
            cube([nema17_slot_l, nema17_slot_w, nema17_mount_flange_h]);
        translate([(nema17_mount_l - nema17_slot_l)/2, -nema17_mount_slot_c_c/2 - nema17_slot_w/2, -nema17_mount_c_h])
            cube([nema17_slot_l, nema17_slot_w, nema17_mount_flange_h]);
        rod(nema17_collar_l);
    }
    % translate([-nema17_l, -nema17_w/2, -nema17_w/2])
        cube([nema17_l, nema17_w, nema17_w]);
}

nema23_mount_flange_h = 3;
nema23_mount_w = 65;
nema23_mount_l = 65 + nema23_mount_flange_h;
nema23_mount_h = 68;
nema23_mount_c_h = 39;
nema23_mount_face_ir = 39 / 2;
nema23_slot_l = 45;
nema23_slot_iw = 39.6;
nema23_slot_ow = 46.2;
nema23_mount_slot_c_c = (nema23_slot_iw + nema23_slot_ow) / 2;
nema23_slot_w = (nema23_slot_ow - nema23_slot_iw) / 2;
//nema23_collar_l = 35;
/*nema23_collar_l_offset = 6;
nema23_collar_l_coupler = 25;
nema23_collar_l = (
    nema23_collar_l_coupler + 
    nema23_collar_l_offset + 
    nema23_mount_flange_h);
nema23_collar_or = 20 / 2;*/
nema23_shaft_or = 10 / 2;
nema23_shaft_l = 23;
nema23_l = 100;
nema23_w = 57;

module nema23_mount() {
    difference() {
        union() {
            translate([0, -nema23_mount_w / 2, -nema23_mount_c_h]) {
                cube([nema23_mount_flange_h, nema23_mount_w, nema23_mount_h]);
                cube([nema23_mount_l, nema23_mount_w, nema23_mount_flange_h]);
            }
            
            rotate([0, -90, 0])
                cylinder(r=nema23_shaft_or, h=nema23_shaft_l);
        }
        
        translate([(nema23_mount_l - nema23_slot_l)/2, nema23_mount_slot_c_c/2 - nema23_slot_w/2, -nema23_mount_c_h])
            cube([nema23_slot_l, nema23_slot_w, nema23_mount_flange_h]);
        translate([(nema23_mount_l - nema23_slot_l)/2, -nema23_mount_slot_c_c/2 - nema23_slot_w/2, -nema23_mount_c_h])
            cube([nema23_slot_l, nema23_slot_w, nema23_mount_flange_h]);
        rotate([0, 90, 0])
            cylinder(r=nema23_mount_face_ir, h=nema23_mount_flange_h);
    }
    # translate([nema23_mount_flange_h, -nema23_w/2, -nema23_w/2])
        cube([nema23_l, nema23_w, nema23_w]);
}