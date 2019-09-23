$fn = max($fn, 32);

t20_w = 20;
t20_notch_w = 6;
t20_notch_d = 6;
t20_hole_ir = 5/2;

module t20(length=100) {
    color("silver") translate([0, 0, -length/2])
    linear_extrude(length) {
        difference() {
            square([t20_w, t20_w], center=true);
            for (i=[0:3]) {
                rotate([0, 0, 90 * i]) {
                    translate([t20_w/2 - t20_notch_d / 2, 0, 0]) {
                        square([t20_notch_d, t20_notch_w], center=true);
                    }
                }
            }
            circle(r=t20_hole_ir);
        }
    }
}

module t20_hole(length) {
    t20(length);
    cube([t20_w - 2, t20_w - 2, length+1], center=true);
}

t20_corner_l = 30;
t20_corner_h = 20;
t20_corner_w = t20_corner_l;
t20_corner_slot_l = 10;
t20_corner_slot_w = 6;
t20_corner_slot_offs = 15;
t20_corner_hole_h = t20_corner_l;
t20_corner_th = 3.5;


module t20_corner() {
    // TODO: use_stl
    color("gray") difference () {
        translate([0, -t20_corner_h/2, 0])
        hull() {
            cube([t20_corner_th, t20_corner_h, t20_corner_l]);
            cube([t20_corner_l, t20_corner_h, t20_corner_th]);
        }
        t20_corner_holes();
    }
}

module t20_corner_holes() {
    translate([t20_corner_slot_offs, 0, 0]) 
        _t20_corner_hole();
    translate([0, 0, t20_corner_slot_offs]) 
        rotate([0, 90, 0])
        _t20_corner_hole();
}

module _t20_corner_hole() {
    hull() {
        for (i=[-1,1]) 
            translate([i * (t20_corner_slot_l - t20_corner_slot_w)/2, 0, 0])
            cylinder(r=t20_corner_slot_w/2, h=t20_corner_hole_h);
    }
}