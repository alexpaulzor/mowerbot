
openbeam_clr = 0.1;
openbeam_w = 15;
openbeam_bracket_th = 1.5;
openbeam_notch_d = 5;
openbeam_notch_w = 3;
openbeam_hole_or = 3/2;

module openbeam(length=50) {
    translate([0, 0, -length/2])
    linear_extrude(length) {
        difference() {
            square([openbeam_w + 2*openbeam_clr, openbeam_w + 2*openbeam_clr], center=true);
            for (i=[0:3]) {
                rotate([0, 0, 90 * i]) {
                    translate([openbeam_w/2 - openbeam_notch_d / 2 - openbeam_clr, 0, 0]) {
                        square([openbeam_notch_d + 2*openbeam_clr, openbeam_notch_w + 2*openbeam_clr], center=true);
                    }
                }
            }
            //circle(r=openbeam_hole_or);
        }
    }
}

module beam_hole(length) {
    openbeam(length);
    cube([openbeam_w - 2, openbeam_w - 2, length+1], center=true);
}

module tee_bracket() {
    difference() {
        union() {
            translate([0, openbeam_w, 0]) 
                cube([openbeam_w, 3 * openbeam_w, openbeam_bracket_th], center=true);
            translate([0, 0, 0]) 
                cube([3 * openbeam_w, openbeam_w, openbeam_bracket_th], center=true);
        }
        for (xi=[-1, 0, 1]) {
            translate([xi * openbeam_w, 0, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
            translate([0, (xi+1) * openbeam_w, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
        }
    }
}
