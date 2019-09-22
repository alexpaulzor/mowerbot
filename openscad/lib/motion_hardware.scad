include <constants.scad>;

t08_screw_r = 8 / 2;

rail_r = 8 / 2;

sk8_hole_r = 5 / 2;
sk8_hole_c_c = 32;
sk8_c_h = 20;

sk8_flange_w = 42;
sk8_flange_h = 6.5;
sk8_w = 20;
sk8_l = 14;
sk8_h = 33.5;

module rail(l=400, center=false) {
    rotate([0, 90, 0])
        cylinder(r=rail_r, h=l, center=center);
}

module sk8() {
    difference() {
        union() {
            translate([-sk8_l / 2, -sk8_w / 2, -sk8_c_h])
                cube([sk8_l, sk8_w, sk8_h]);
            translate([-sk8_l / 2, -sk8_flange_w / 2, -sk8_c_h]) 
                cube([sk8_l, sk8_flange_w, sk8_flange_h]);
        }
        translate([-sk8_l / 2, 0, 0])
            rail(sk8_l);
        sk8_holes();
    }
}

module sk8_holes(h=sk8_c_h) {
    translate([0, sk8_hole_c_c / 2, -sk8_c_h])
        cylinder(r=sk8_hole_r, h=h);
    translate([0, -sk8_hole_c_c / 2, -sk8_c_h])
        cylinder(r=sk8_hole_r, h=h);
}

sc8uu_w = 34;
sc8uu_l = 30;
sc8uu_h = 22;
sc8uu_step_h = 18;
sc8uu_step_w = 11;
sc8uu_step_base_w = 17;
sc8uu_hole_c_c_w = 24;
sc8uu_hole_c_c_l = 18;
sc8uu_hole_r = 4 / 2;

module sc8uu() {
    difference() {
        translate([-sc8uu_l/2, -sc8uu_w/2, -sc8uu_h/2])
            cube([sc8uu_l, sc8uu_w, sc8uu_h]);
        translate([-sc8uu_l/2, 0, 0])
            rail(sc8uu_l);
        
        translate([-sc8uu_hole_c_c_l/2, -sc8uu_hole_c_c_w/2, -sc8uu_h/2])
            cylinder(r=sc8uu_hole_r, h=sc8uu_h);
        translate([-sc8uu_hole_c_c_l/2, sc8uu_hole_c_c_w/2, -sc8uu_h/2])
            cylinder(r=sc8uu_hole_r, h=sc8uu_h);
        translate([sc8uu_hole_c_c_l/2, sc8uu_hole_c_c_w/2, -sc8uu_h/2])
            cylinder(r=sc8uu_hole_r, h=sc8uu_h);
        translate([sc8uu_hole_c_c_l/2, -sc8uu_hole_c_c_w/2, -sc8uu_h/2])
            cylinder(r=sc8uu_hole_r, h=sc8uu_h);
        translate([-sc8uu_l/2, -sc8uu_w / 2, -sc8uu_h / 2 + sc8uu_step_h])
            cube([sc8uu_l, (sc8uu_w - sc8uu_step_w) / 2, sc8uu_h - sc8uu_step_h]);
        translate([-sc8uu_l/2, sc8uu_step_w / 2, -sc8uu_h / 2 + sc8uu_step_h])
            cube([sc8uu_l, (sc8uu_w - sc8uu_step_w) / 2, sc8uu_h - sc8uu_step_h]);
    }
}

module sc8uu_mount_holes(h=sc8uu_h) {
    translate([-sc8uu_hole_c_c_l/2, -  sc8uu_hole_c_c_w/2, -h/2])
            cylinder(r=sc8uu_hole_r, h=h);
        translate([-sc8uu_hole_c_c_l/2, sc8uu_hole_c_c_w/2, -h/2])
            cylinder(r=sc8uu_hole_r, h=h);
        translate([sc8uu_hole_c_c_l/2, sc8uu_hole_c_c_w/2, -h/2])
            cylinder(r=sc8uu_hole_r, h=h);
        translate([sc8uu_hole_c_c_l/2, -sc8uu_hole_c_c_w/2, -h/2])
            cylinder(r=sc8uu_hole_r, h=h);
}


kp08_l = 13;
kp08_h = 30;
kp08_w = 30;
kp08_flange_w = 55;

kp08_flange_h = 5;
kp08_hole_r = 5 / 2;
kp08_hole_c_c = 42;
kp08_c_h = 15;

module t08_screw(l=400, center=false) {
    rail(l, center=center);
}

module kp08() {
    difference() {
        union() {
            translate([-kp08_l/2, 0, 0])
                rotate([0, 90, 0])
                    cylinder(r=kp08_w/2, h=kp08_l);
            translate([-kp08_l/2, -kp08_flange_w/2, -kp08_c_h])
                cube([kp08_l, kp08_flange_w, kp08_flange_h]);
        }
        t08_screw(kp08_l);
        kp08_holes();
    }
}

module kp08_holes(h=kp08_h) {
    translate([0, kp08_hole_c_c/2, 0])
        cylinder(r=kp08_hole_r, h=h, center=true);
    translate([0, - kp08_hole_c_c/2, 0])
        cylinder(r=kp08_hole_r, h=h, center=true);
}

traveller_h = 17;
traveller_collar_or = 11 / 2;
traveller_flange_or = 23 / 2;
traveller_flange_h = 3.8;
traveller_flange_z = traveller_h - 5;
traveller_hole_ir = 3.7 / 2;
traveller_hole_offset = 8;
traveller_num_holes = 4;
traveller_hole_angle = 360 / traveller_num_holes;
traveller_ir = 7 / 2;

gimbal_shift_z = -traveller_flange_z/2 + traveller_flange_h / 2;

module t08_nut() {
     //translate([0, 0, gimbal_l / 2 - traveller_flange_z / 2 + gimbal_shift_z])
        difference() {
        union() {
            cylinder(h=traveller_h, r=traveller_collar_or, center=true);
            translate([0, 0, -traveller_h / 2 + traveller_flange_z + traveller_flange_h/2]) {
                difference() {
                    cylinder(h=traveller_flange_h, r=traveller_flange_or, center=true);
                    t08_nut_holes();
                }
            }
        }
        cylinder(h=traveller_h, r=traveller_ir, center=true);
    }
}

module t08_nut_holes(l=traveller_flange_h * 2 + 1) {
    for (i=[1:traveller_num_holes])
        rotate([0, 0, i * traveller_hole_angle])
            translate([traveller_hole_offset, 0, 0])
                cylinder(h=l, r=traveller_hole_ir, center=true);
}

bar_w = 1.0 * IN_MM;

module bar(length) {
    cube([length, bar_w, bar_w], center=true);
}

function get_sk8_c_h() = sk8_c_h;
function get_sk8_flange_w() = sk8_flange_w;
function get_sk8_l() = sk8_l;
function get_rail_r() = rail_r;
function get_t08_screw_l() = t08_screw_l;

module bearing() {
    difference() {
        cylinder(r=bearing_or, h=bearing_h, center=true);
        cylinder(r=bearing_ir, h=bearing_h, center=true);
    }
}

module drive_pulley_40t(bore=9.5, height=6) {
    gt2_pulley(40, bore, pulley_t_ht=height, pulley_b_ht=0, pulley_b_dia=0, no_of_nuts=0, nut_t08_screw_distance=0);
}

motor_coupler_length = 25;
motor_coupler_small_id = 5;
motor_coupler_large_id = 8;
motor_coupler_od = 19;
motor_coupler_large_depth = 18;
motor_coupler_grub_ir = 4 / 2;
motor_coupler_grub_c_c = 17;
motor_coupler_grub_theta = 72; // Unclear from measuring, somewhere 70 <= x < 75, I think

module motor_coupler() {
    difference() {
        cylinder(r=motor_coupler_od/2, h=motor_coupler_length);
        cylinder(r=motor_coupler_small_id/2, h=motor_coupler_length);
        cylinder(r=motor_coupler_large_id/2, h=motor_coupler_large_depth);
        motor_coupler_holes();
    }
}

module motor_coupler_holes() {
    for (t=[0, motor_coupler_grub_theta]) {
        for (z=[-1, 1]) {
            rotate([0, 0, t])
            translate([0, 0, motor_coupler_length/2 + z * motor_coupler_grub_c_c/2])
            rotate([0, 90, 0])
            cylinder(r=motor_coupler_grub_ir, h=motor_coupler_od*3);

        }
    }
}