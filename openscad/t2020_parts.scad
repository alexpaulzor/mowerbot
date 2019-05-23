include <lib/t2020beam.scad>;
include <lib/motion_hardware.scad>;

rod_mount_spacer_h = 13;
module rod_mount_spacer(use_stl=false) {
	% translate([0, 0, rod_mount_spacer_h + rod_mount_c_h])
        rod_mount();
    scale_adj = [
        rod_mount_l / t2020_w,
        rod_mount_flange_w / (rod_mount_hole_c_c + t2020_w)
    ];
    echo(scale_adj);
    difference() {
        linear_extrude(height=rod_mount_spacer_h, scale=scale_adj) {
            square([t2020_w, rod_mount_hole_c_c + t2020_w], center=true);
        }
        translate([0, 0, rod_mount_c_h - 1])
            rod_mount_holes();
    }
}

coupler_brace_wall_th = 2;
coupler_brace_splines = 10;
coupler_brace_spline_w = coupler_brace_wall_th;

module coupler_brace(use_stl=false) {
	difference() {
        union() {
            cylinder(r=motor_coupler_od/2 + coupler_brace_wall_th, h=motor_coupler_length);
            fin_l = (motor_coupler_od + coupler_brace_spline_w + 4*coupler_brace_wall_th) / 2;
            for (i=[0:360/coupler_brace_splines:360]) {
                rotate([0, 0, i])
                translate([fin_l/2, 0, motor_coupler_length/2])
                cube([fin_l, coupler_brace_spline_w, motor_coupler_length], center=true);
            }
        }
       
        translate([0, 0, motor_coupler_length/2])
            cylinder(r=motor_coupler_od/2, h=motor_coupler_length+2, center=true);
        for (dt=[0:5]) {
            rotate([0, 0, 20+dt])
            motor_coupler_holes();
        }
        % motor_coupler();
	}
}

coupler_brace();