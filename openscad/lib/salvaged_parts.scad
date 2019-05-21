include <constants.scad>;

spool_ir = 52 / 2;
spool_or = 168 / 2;
spool_h = 2 * IN_MM;
spool_inner_wall_or = 56 / 2;
spool_outer_wall_ir = 67 / 2;
spool_outer_wall_or = 71 / 2;
spool_num_slots = 12 * 3;  // actually 12, but use double to accomodate for partial-twist
spool_slot_th = 2;
spool_wall_th = 3;

module spool() {    
    spool_core();
    difference() {
        for (i=[-1, 1]) {
            translate([0, 0, (spool_h - spool_wall_th) / 2 * i])
            cylinder(r=spool_or, h=spool_wall_th, center=true);
        }
        cylinder(r=spool_outer_wall_or, h=spool_h+1, center=true);
    }
}

module spool_core() {
     difference() {
        cylinder(r=spool_outer_wall_or, h=spool_h, center=true);
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