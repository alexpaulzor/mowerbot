include <lib/t2020beam.scad>;
include <lib/motion_hardware.scad>;

sk8_spacer_h = 13;
module sk8_spacer(use_stl=false) {
	% translate([0, 0, sk8_spacer_h + sk8_c_h])
        sk8();
    scale_adj = [
        sk8_l / t2020_w,
        sk8_flange_w / (sk8_hole_c_c + t2020_w)
    ];
    echo(scale_adj);
    difference() {
        linear_extrude(height=sk8_spacer_h, scale=scale_adj) {
            square([t2020_w, sk8_hole_c_c + t2020_w], center=true);
        }
        translate([0, 0, sk8_c_h - 1])
            sk8_holes();
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

bracket_h = 3;
bracket_w = 20;
bracket_l = 60;
bracket_hole_ir = 5 / 2;
module corner_bracket_template() {
    difference() {
        union() {
            cube([bracket_l, bracket_w, bracket_h]);
            cube([bracket_w, bracket_l, bracket_h]);
        }
        for (i=[0:2]) {
            translate([i * bracket_w + bracket_w / 2, bracket_w / 2, -1])
                cylinder(r=bracket_hole_ir, h=2*bracket_h);
            translate([bracket_w / 2, i * bracket_w + bracket_w / 2, -1])
                cylinder(r=bracket_hole_ir, h=2*bracket_h);
        }
    }
}

corner_bracket_template();