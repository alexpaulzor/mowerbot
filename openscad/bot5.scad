include <lib/motors.scad>;
include <lib/openbeam.scad>;
include <lib/motion_hardware.scad>;
include <lib/salvaged_parts.scad>;
$fn=60;

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
       
        translate([0, 0, spool_h / 2 + mini_drive_wall_th])
            spool_core();
        cylinder(r=motor_coupler_od/2, h=2*spool_h, center=true);
        translate([0, 0, mini_drive_wall_th * 3])
            for (dt=[0:5]) {
                rotate([0, 0, 20+dt])
                motor_coupler_holes();
            }
        for(j=[0:mini_drive_num_holes])  {
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
            spool_core();
        
        cylinder(r=rod_r, h=2*spool_h, center=true);
        for(j=[0:mini_drive_num_holes])  {
            rotate([0,0,j*360 / mini_drive_num_holes])
                translate([mini_drive_hole_offs, 0, -1])
                    cylinder(h=mini_drive_l + 2 , r=mini_drive_hole_ir);
        }
	}
}

module design_spool() {
    * translate([0, 0, spool_h / 2 + mini_drive_wall_th])
        spool();
    mini_drive_adapter();
    * translate([0, 0, spool_h + 2 * mini_drive_wall_th])
        rotate([180, 0, 0])
        mini_drive_adapter_plate();
}

design_spool();