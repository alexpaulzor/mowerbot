include <lib/motion_hardware.scad>;
include <lib/metric.scad>;
include <lib/motors.scad>;

wall_th = 3;
shaft_traveller_pivot_l = 2 * traveller_flange_or + 2 * wall_th;
shaft_traveller_pivot_w = 2 * traveller_flange_or + rod_r + 2 * wall_th;
shaft_traveller_pivot_h = 2 * rod_r + 2 * wall_th;

module shaft_traveller_pivot() {
    difference() {
            translate([0, rod_r / 2, 0])
                cube([shaft_traveller_pivot_l, shaft_traveller_pivot_w, shaft_traveller_pivot_h], center=true);
        rotate([0, 0, 45]) {
            translate([0, 0, traveller_flange_h/4])
                shaft_traveller();
            shaft_traveller_holes(50);
            for (i=[1:traveller_num_holes])
            rotate([0, 0, i * traveller_hole_angle])
                translate([traveller_hole_offset, 0, -shaft_traveller_pivot_h/2 + m3_nut_h/2])
                    rotate([0, 0, 360 / 12])
                    m3_nut();
        }
        rotate([0, 90, 0])
            shaft(30, true);
        translate([0, traveller_flange_or, 0])
            rod(center=true);
        
    }
}

!shaft_traveller_pivot();


mdi_h = 2;
module motor_drive_interface() {
    difference() {
        translate([0, 0, mdi_h/2])
        union() {
            cube([45, 15, mdi_h], center=true);
            cube([15, 45, mdi_h], center=true);
        }
        translate([0, 0, -motor_ds_h + motor_ds_notch_h / 2]) {
            # motor_driveshaft();
            motor_driveshaft_holes();
        }
        for (theta=[0:90:360]) {
            rotate([0, 0, theta])
            translate([15, 0, 0])
            cylinder(r=3/2, h=motor_ds_notch_h);
        }
    }
}

drive_adapter_or = 15;
drive_adapter_h = 32;
drive_adapter_pulley_h = 8;

module small_drive_adapter(use_stl=false) {
    if (use_stl) {
        import("stl/small_drive_adapter.motion_hardware_parts.stl");
    } else {
        difference() {
            cylinder(r=drive_adapter_or, h=drive_adapter_h);
            cylinder(r=motor_coupler_od/2, h=drive_adapter_h+1);
            translate([0, 0, drive_adapter_pulley_h]) {
                % motor_coupler();
                for (theta=[0:5:10])
                    rotate([0, 0, theta])
                    motor_coupler_holes();
            }
            translate([0, 0, -1])
                drive_pulley_40t(0, drive_adapter_pulley_h);
            
        }
    }
}

nema23_spacer_h = nema23_mount_c_h - nema23_mount_flange_h - kp08_c_h;

module nema23_spacer() {
    % translate([-55, 0, 0]) {
        %nema23_mount(-1);
        % translate([55, 0, 0])
            kp08();
        % translate([10, 0, 0])
            rotate([0, 90, 0])
            small_drive_adapter(use_stl=true);
        %shaft();
    }
    difference() {
        translate([0, 0, -kp08_c_h - nema23_spacer_h/2])
            cube([kp08_l, kp08_flange_w, nema23_spacer_h], center=true);
        # kp08_holes(h=100);
    }
    
}

nema17_spacer_h = nema17_mount_c_h - nema17_mount_flange_h - kp08_c_h;

module nema17_spacer() {
    % translate([-40, 0, 0]) {
        %nema17_mount(-1);
        % translate([40, 0, 0])
            kp08();
       
        %shaft();
    }
    difference() {
        translate([0, 0, -kp08_c_h - nema17_spacer_h/2])
            cube([kp08_l, kp08_flange_w, nema17_spacer_h], center=true);
        kp08_holes(h=100);
        for (y=[-1, 1]) {
            for (z=[-kp08_c_h - m4_nut_h/2, -kp08_c_h - nema17_spacer_h + m4_nut_h/2]) {
                translate([0, y*kp08_hole_c_c/2, z]) 
                    m4_nut();
                translate([0, y*nema17_mount_slot_c_c/2, z]) 
                    m4_nut();
                translate([0, y*nema17_mount_slot_c_c/2, 0])
                    cylinder(r=nema17_slot_w/2, h=100, center=true);
                }
            }
    }
    
}

nema17_spacer();
