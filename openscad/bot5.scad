include <lib/motors.scad>;
include <lib/openbeam.scad>;
include <lib/motion_hardware.scad>;
$fn=60;
spool_ir = 52 / 2;
spool_or = 168 / 2;
spool_h = 2 * IN_MM;
spool_inner_wall_or = 56 / 2;
spool_outer_wall_ir = 67 / 2;
spool_outer_wall_or = 71 / 2;
spool_num_slots = 12;
spool_slot_th = 2;
spool_wall_th = 3;

module spool() {
    difference() {
        union() {
            cylinder(r=spool_outer_wall_or, h=spool_h, center=true);
            for (i=[-1, 1]) {
                translate([0, 0, (spool_h - spool_wall_th) / 2 * i])
                cylinder(r=spool_or, h=spool_wall_th, center=true);
            }
        }
        cylinder(r=spool_outer_wall_ir, h=spool_h+1, center=true);
        

    }
    difference() {
        cylinder(r=spool_inner_wall_or, h=spool_h, center=true);
        cylinder(r=spool_ir, h=spool_h+1, center=true);
    }
    fin_l = spool_outer_wall_or - spool_ir;
    for (i=[0:360/spool_num_slots:360]) {
        rotate([0, 0, i])
        translate([spool_ir + fin_l/2, 0, 0])
            cube([fin_l, spool_slot_th, spool_h], center=true);
    }
}

mini_drive_wall_th = 2;
mini_drive_l = motor_coupler_length + mini_drive_wall_th*3;
mini_drive_num_holes = 6;
mini_drive_hole_offs = 18;
mini_drive_hole_ir = 3;


module mini_drive_adapter(use_stl=false) {
	difference() {
        union() {
            cylinder(r=spool_outer_wall_ir, h=3*mini_drive_wall_th);
            cylinder(r=motor_coupler_od/2 + 3*mini_drive_wall_th, h=mini_drive_l);
        }
        # translate([0, 0, spool_h / 2 + mini_drive_wall_th])
            spool();
        cylinder(r=motor_coupler_od/2, h=2*spool_h, center=true);
        translate([0, 0, mini_drive_wall_th * 3])
        for (dt=[0:5]) {
            rotate([0, 0, 20+dt])
            motor_coupler_holes();
        }
        cylinder(r=motor_coupler_od/2, h=2*spool_h, center=true);
        # for(j=[0:mini_drive_num_holes])  {
            rotate([0,0,j*360 / mini_drive_num_holes])
                translate([mini_drive_hole_offs, 0, 0])
                    cylinder(h=mini_drive_l + 1 , r=mini_drive_hole_ir);
        }
	}
}

module mini_drive_adapter_plate(use_stl=false) {
    difference() {
        union() {
            cylinder(r=spool_outer_wall_ir, h=3*mini_drive_wall_th);
            * cylinder(r=spool_ir, h=mini_drive_l);
        }
        translate([0, 0, spool_h / 2 + mini_drive_wall_th])
            spool();
        
        cylinder(r=rod_r, h=2*spool_h, center=true);
        for(j=[0:mini_drive_num_holes])  {
            rotate([0,0,j*360 / mini_drive_num_holes])
                translate([mini_drive_hole_offs, 0, -1])
                    cylinder(h=mini_drive_l + 2 , r=mini_drive_hole_ir);
        }
	}
}

mini_drive_adapter();
% translate([0, 0, spool_h + 4 * mini_drive_wall_th])
    rotate([180, 0, 0])
    mini_drive_adapter_plate();