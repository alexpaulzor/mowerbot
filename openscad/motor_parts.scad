include <lib/motors.scad>;
include <lib/metric.scad>;

hub_ir = 35 / 2;
wall_th = 3;
hub_h = 48 + wall_th;


module hub_adapter() {
    difference() {
        union() {
            cylinder(r=hub_ir, h=hub_h);
            cylinder(r=hub_ir + wall_th, h=wall_th);
        }
        wc_motor_shaft();
        translate([0, hub_ir, hub_h / 2])
            rotate([90, 0, 0]) {
                cylinder(r=5/2, h=hub_ir);
                m5_nut();
                translate([0, 0, m5_nut_h/2 + 1]) m5_nut();
            }
    }
}

hub_adapter();