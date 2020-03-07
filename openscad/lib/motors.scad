include <metric.scad>;

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

motor_ds_h = 17;
motor_ds_or = 12 / 2;
motor_ds_notch_x = 1;
motor_ds_notch_y = motor_ds_or - 8.10 / 2;
motor_ds_notch_h = 4.5;
motor_ds_hole_ir = 6 / 2;

module motor_driveshaft() {
    difference() {
        cylinder(r=motor_ds_or, h=motor_ds_h);
        translate([0, 0, motor_ds_h - motor_ds_notch_h]) {
            translate([-motor_ds_or, -motor_ds_or, 0])
                cube([motor_ds_notch_x, , motor_ds_or*2, motor_ds_notch_h]);
            for (theta=[0, 180]) {
                rotate([0, 0, theta])
                translate([-motor_ds_or, -motor_ds_or, 0])
                cube([motor_ds_or*2, motor_ds_notch_y, motor_ds_notch_h]);
            }
        }
        motor_driveshaft_holes();
    }
}

module motor_driveshaft_holes(h=motor_ds_h) {
    cylinder(r=motor_ds_hole_ir, h=h);
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
        rail(nema17_collar_l);
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

module nema23_mount(motor_dir=1) {
    difference() {
        union() {
            color("black") translate([0, -nema23_mount_w / 2, -nema23_mount_c_h]) {
                cube([nema23_mount_flange_h, nema23_mount_w, nema23_mount_h]);
                cube([nema23_mount_l, nema23_mount_w, nema23_mount_flange_h]);
            }
            
            color("lightgray")
                rotate([0, -90, (motor_dir - 1) * 90])
                cylinder(r=nema23_shaft_or, h=nema23_shaft_l);
        }
        
        translate([(nema23_mount_l - nema23_slot_l)/2, nema23_mount_slot_c_c/2 - nema23_slot_w/2, -nema23_mount_c_h])
            cube([nema23_slot_l, nema23_slot_w, nema23_mount_flange_h]);
        translate([(nema23_mount_l - nema23_slot_l)/2, -nema23_mount_slot_c_c/2 - nema23_slot_w/2, -nema23_mount_c_h])
            cube([nema23_slot_l, nema23_slot_w, nema23_mount_flange_h]);
        rotate([0, 90, 0])
            cylinder(r=nema23_mount_face_ir, h=nema23_mount_flange_h);
    }
    nema23_x = motor_dir * nema23_l/2 + (motor_dir < 0 ? 0 : nema23_mount_flange_h);
    color("black") translate([nema23_x, 0, 0])
        cube([nema23_l, nema23_w, nema23_w], center=true);
}

mini_motor_shaft_or = 3;
mini_motor_notched_w = 4.37;
mini_motor_notch_h = 10;
mini_motor_shaft_h = 14;
mini_motor_shaft_offs = 15;
mini_motor_w = 1.26 * IN_MM;
mini_motor_l = 1.81 * IN_MM;
mini_motor_h = 1.0 * IN_MM;
mini_motor_hole_sep = [18, 32];
mini_motor_hole_ir = 3/2;
mini_motor_hole_offs = 7;
mini_motor_cyl_or = 24.3 / 2;
mini_motor_cyl_l = 35;
mini_motor_cyl_offs = 3.5;

module mini_motor() {
    translate([-mini_motor_shaft_offs, -mini_motor_w/2, -mini_motor_h]) {
        difference() {
            cube([mini_motor_l, mini_motor_w, mini_motor_h]);
            # mini_motor_holes();
        }
    }
        
    difference() {
        cylinder(r=mini_motor_shaft_or, h=mini_motor_shaft_h);
        translate([2*mini_motor_shaft_or - mini_motor_notched_w, -mini_motor_shaft_or, mini_motor_shaft_h - mini_motor_notch_h])
            cube([2*mini_motor_shaft_or, 2*mini_motor_shaft_or, mini_motor_notch_h]);
    }
    translate([mini_motor_l - mini_motor_shaft_offs, 0, -mini_motor_cyl_or - mini_motor_cyl_offs])
        rotate([0, 90, 0])
        cylinder(r=mini_motor_cyl_or, h=mini_motor_cyl_l);
}

module mini_motor_holes() {
    translate([mini_motor_hole_offs, mini_motor_w / 2 + mini_motor_hole_sep[0]/2, 2])
        cylinder(r=mini_motor_hole_ir, h=mini_motor_h);
    translate([mini_motor_hole_offs, mini_motor_w / 2 - mini_motor_hole_sep[0]/2, 2])
        cylinder(r=mini_motor_hole_ir, h=mini_motor_h);
    translate([mini_motor_hole_offs + mini_motor_hole_sep[1], mini_motor_w / 2 + mini_motor_hole_sep[0]/2, 2])
        cylinder(r=mini_motor_hole_ir, h=mini_motor_h);
    translate([mini_motor_hole_offs + mini_motor_hole_sep[1], mini_motor_w / 2 - mini_motor_hole_sep[0]/2, 2])
        cylinder(r=mini_motor_hole_ir, h=mini_motor_h);
}

wc_shaft_thread_or = 10 / 2;  // M10x1.25
wc_shaft_thread_h = 14;
wc_shaft_r2 = 14 / 2;  // top
wc_shaft_r1 = 17 / 2;  // bottom
wc_shaft_h = 53;
wc_shaft_notch_w = 5;
wc_shaft_notch_l = 38 - wc_shaft_notch_w;
wc_shaft_notch_d = 5;
wc_shaft_notch_offs = 12 + wc_shaft_notch_w / 2;

module wc_motor_shaft() {
    difference() {
        cylinder(r1=wc_shaft_r1, r2=wc_shaft_r2, h=wc_shaft_h);
        % translate([0, wc_shaft_r1, wc_shaft_notch_offs])
            rotate([90, 0, 0])
            cylinder(r=wc_shaft_notch_w/2, h=wc_shaft_notch_d);
        % translate([0, wc_shaft_r1, wc_shaft_notch_offs + wc_shaft_notch_l])
            rotate([90, 0, 0])
            cylinder(r=wc_shaft_notch_w/2, h=wc_shaft_notch_d);
        % translate([0, wc_shaft_r1 - wc_shaft_notch_d / 2, wc_shaft_notch_offs + wc_shaft_notch_l / 2])
            cube([wc_shaft_notch_w, wc_shaft_notch_d, wc_shaft_notch_l], center=true);  
    }
    translate([0, 0, wc_shaft_h])
        cylinder(r=wc_shaft_thread_or, h=wc_shaft_thread_h);
}

module wc_motor() {
    wc_motor_shaft();
}

/////// BLDC wheel



// rpm=990 (measured 33 clicks in 2 seconds)
// 16.5 rps

// tire od = 195mm
// c = 3.14*19.5 = 61.23cm
// at 16.5rps = 10 m/s

bldc_rim_od = 136; // mm
bldc_od = 124; // mm
bldc_rim_dr = 6; // mm
bldc_rim_h = 18;
bldc_shaft_od = 12;
bldc_shaft_h = 100;
bldc_hub_h = 27; // mm

module bldc_hub() {
    cylinder(r=bldc_od/2, h=bldc_hub_h, center=true);
    cylinder(r=bldc_shaft_od/2, h=bldc_shaft_h, center=true);
    for (i=[-1,1])
        translate([0, 0, i*(bldc_hub_h/2 + bldc_rim_h/2)])
        cylinder(r=bldc_rim_od/2, h=bldc_rim_h, center=true);
}
