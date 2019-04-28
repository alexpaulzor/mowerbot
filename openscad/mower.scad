
mower_shaft_or = 25 / 2;
mower_shaft_l = 32 * IN_MM;
mower_blade_or = 12 * IN_MM / 2;
mower_blade_h = 3 * IN_MM;
mower_neck_angle = 45;
mower_neck_or = 2 * IN_MM;
mower_neck_shaft_l = 7.5 * IN_MM;
mower_neck_h = 5.5 * IN_MM;
mower_neck_offset_h = 1.0 * IN_MM;

module ac_mower() {
    translate([0, 0, -mower_neck_shaft_l])
        cylinder(r=mower_shaft_or, h=mower_shaft_l);
    translate([0, 0, -mower_neck_shaft_l]) {
                rotate([0, -mower_neck_angle, 0]) {
                    translate([0, 0, -mower_blade_h - mower_neck_offset_h]) {
                        cylinder(r=mower_blade_or, h=mower_blade_h);
                        cylinder(r=mower_neck_or, h=mower_blade_h+mower_neck_h);
                    }
                }
            }
}