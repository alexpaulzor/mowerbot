include <lib/motion_hardware.scad>;
include <lib/metric.scad>;

wall_th = 2;
shaft_traveller_pivot_l = 2 * traveller_flange_or + 2 * wall_th;
shaft_traveller_pivot_w = 2 * traveller_flange_or + rod_r + 2 * wall_th;
shaft_traveller_pivot_h = 2 * rod_r + 2 * wall_th;

module shaft_traveller_pivot() {
    difference() {
        translate([0, rod_r / 2, 0])
            # cube([shaft_traveller_pivot_l, shaft_traveller_pivot_w, shaft_traveller_pivot_h], center=true);
	rotate([0, 0, 45]) {
        # translate([0, 0, rod_r])
            shaft_traveller();
        shaft_traveller_holes(50);
        for (i=[1:traveller_num_holes])
        rotate([0, 0, i * traveller_hole_angle])
            translate([traveller_hole_offset, 0, -shaft_traveller_pivot_h/2 + m3_nut_h/2])
                m3_nut();
    }
	rotate([0, 90, 0])
		shaft(30, true);
	translate([0, traveller_flange_or, 0])
        rod(center=true);
    
}
}

shaft_traveller_pivot();