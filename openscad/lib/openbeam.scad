openbeam_w = 15;
bracket_th = 1.5;
beam_notch_d = 5;
beam_notch_w = 3;
beam_hole_or = 3/2;

module beam(length=50) {
    translate([0, 0, -length/2])
    linear_extrude(length) {
        difference() {
            square([openbeam_w, openbeam_w], center=true);
            for (i=[0:3]) {
                rotate([0, 0, 90 * i]) {
                    translate([openbeam_w/2 - beam_notch_d / 2, 0, 0]) {
                        square([beam_notch_d, beam_notch_w], center=true);
                    }
                }
            }
            //circle(r=beam_hole_or);
        }
    }
}

module beam_hole(length) {
    beam(length);
    cube([openbeam_w - 2, openbeam_w - 2, length+1], center=true);
}

module tee_bracket() {
    difference() {
        union() {
            translate([0, openbeam_w, 0]) 
                cube([openbeam_w, 3 * openbeam_w, bracket_th], center=true);
            translate([0, 0, 0]) 
                cube([3 * openbeam_w, openbeam_w, bracket_th], center=true);
        }
        for (xi=[-1, 0, 1]) {
            translate([xi * openbeam_w, 0, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
            translate([0, (xi+1) * openbeam_w, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
        }
    }
}