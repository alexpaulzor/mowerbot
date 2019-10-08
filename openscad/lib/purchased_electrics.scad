// include <arduino.scad>
// use <boxit.scad>

IN_MM = 25.4;
$fn = 32;

wall_th = 2;

beam_w = 15;

/////////////////////////////////////////////////
//////////// ELECTRONICS ////////////////////////
/////////////////////////////////////////////////

mega_l = 102;
mega_w = 55;
mega_h = 18;
mega_hole_r = 3.2 / 2;
mega_lift = 12;

module mega() {
    translate([0, mega_w, 0])
    rotate([0, 0, -90]) {
        % arduino(MEGA2560);
        % translate([0, 0, mega_h - 2])
            arduino(MEGA2560);
    }
    // mega_holes();
}

module mega_holes() {
    translate([0, mega_w, 0])
    rotate([0, 0, -90]) {
        for (xy=dueHoles) {
            translate([xy[0], xy[1], -mega_h])
                cylinder(r=mega_hole_r, h=mega_h * 3);
        }
        translate([8, -60, 0])
            cube([15, 60, 20]);
    }
}

nano_l = 45;
nano_w = 18;
nano_h = 8;
nano_board_h = 3;
nano_usb_w = 8;
nano_usb_l = 10;
nano_usb_overhang = 2;
module nano() {
    translate([nano_usb_overhang, -nano_w/2, 0])
        cube([nano_l - nano_usb_overhang, nano_w, nano_board_h]);
    translate([0, -nano_usb_w/2, 0])
        cube([nano_usb_l, nano_usb_w, nano_h]);
}

// TODO: estimated
vreg_l = 55;
vreg_w = 40;
vreg_h = 20;  

module vreg() {
    cube([vreg_l, vreg_w, vreg_h]);
}

// TODO: estimated
rc_l = 20;
rc_w = 40;
rc_h = 50;  

module rc() {
    cube([rc_l, rc_w, rc_h]);
}

bat_l = 150;
bat_w = 90;
bat_h = 95;
module bat() {
    cube([bat_l, bat_w, bat_h]);
}


dcctl_l = 50;
dcctl_w = 42;
dcctl_h = 52;
dcctl_hs_l = 33;
dcctl_hs_w = 23;
dcctl_hs_h = dcctl_h;
dcctl_hole_r = 3/2;
dcctl_hole_offset = 5;
dcctl_hole_or = 6/2;
dcctl_board_th = 1.5;
dcctl_board_side_w = dcctl_w - dcctl_hs_w;

module dcctl_holes() {
    for (x=[dcctl_hole_offset, dcctl_l - dcctl_hole_offset]) {
        for (z=[dcctl_hole_offset, dcctl_l - dcctl_hole_offset]) {
            translate([x, 0, z]) {
                rotate([-90, 0, 0]) {
                    translate([0, 0, -dcctl_hs_w])
                        cylinder(r=dcctl_hole_r, h=dcctl_w);
                    translate([0, 0, dcctl_board_th]) 
                        cylinder(r=dcctl_hole_or, h=dcctl_board_side_w);
                }
            }
        }
    }
}

module dcctl() {
    difference() {
        cube([dcctl_l, dcctl_board_side_w, dcctl_h]);
        dcctl_holes();
    }    
    translate([(dcctl_l - dcctl_hs_l) / 2, -dcctl_hs_w, 0])
        cube([dcctl_hs_l, dcctl_hs_w, dcctl_hs_h]);
}

module dcctl_centered() {
    translate([-dcctl_l/2, 0, -dcctl_h/2]) {
        dcctl();
        dcctl_holes();
    }
}

rocker_or = 10;
rocker_h = 25;
rocker_lip_h = 3;
rocker_lip_or = 12;
num_rockers = 4;
iec_plug_l = 32;
iec_plug_w = 27;
iec_plug_h = 32;

module iec_plug() {
    translate([0, 0, wall_th - iec_plug_h/2])
    cube([iec_plug_l, iec_plug_w, iec_plug_h], center=true);
}

module rocker() {
    translate([0, 0, -rocker_h])
        cylinder(r=rocker_or, h=rocker_h + rocker_lip_h);
    cylinder(r=rocker_lip_or, h=rocker_lip_h);
}

outlet_flange_l = 93;
outlet_flange_w = 19;
outlet_flange_h = 17;
outlet_flange_th = 1.125;
outlet_hole_cc_l = 84;
outlet_hole_or = 3/2;
outlet_screw_c_c = 84;

outlet_w = 34;
outlet_h = 70;
outlet_l = outlet_h;
outlet_center = 10;
outlet_screw_od = 3;
outlet_face_d = 5;
outlet_d = 18;
face_d = outlet_face_d;

plug_h = (outlet_h - outlet_center) / 2;
module plug_face() {
    intersection() {
        cube([plug_h, outlet_w, outlet_face_d]);
        translate([plug_h / 2, outlet_w / 2, 0])
            cylinder(h=face_d, r=outlet_w / 2);
    }
}

module outlet() {
    translate([-outlet_flange_l / 2, - outlet_flange_w / 2, -outlet_flange_th])
        cube([outlet_flange_l, outlet_flange_w, outlet_flange_th]);
    for (x=[1, 0, -1]) {
        translate([x * outlet_hole_cc_l/2, 0, -outlet_flange_h])
            cylinder(r=outlet_hole_or, h=outlet_w);
        
    translate([outlet_center / 2, -outlet_w / 2, 0])
        plug_face();
    translate([-outlet_center / 2 - plug_h, -outlet_w / 2, 0])
        plug_face();
    translate([-outlet_h/2, -outlet_w/2, -outlet_d])
        cube([outlet_h, outlet_w, outlet_d]);
    }
}


atx_l = 55;
atx_w = 24;
atx_h = 10;
atx_nub_l = 4;
atx_nub_w = 8;
atx_nub_h = 2;

module atx() {
    cube([atx_l, atx_w, atx_h], true);
    translate([0, 0, atx_h / 2 + atx_nub_h / 2])
        cube([atx_nub_l, atx_w, atx_nub_h], true);
}

disp_l = 58;;
disp_w = 28;
disp_h = 12;
disp_flange_l = 62;
disp_flange_w = 34;
disp_flange_h = 2;

module disp() {
    translate([0, 0, -disp_h/2])
        cube([disp_l, disp_w, disp_h], true);
    translate([0, 0, disp_flange_h/2])
        cube([disp_flange_l, disp_flange_w, disp_flange_h], true);
}

module mount_block(ir) {
    block_outside = 2*ir + 2 * wall_th;
    difference() {
        union() {
            translate([0, 0, wall_th/2])
                cube([3 * beam_w, beam_w, wall_th], center=true);
            translate([0, 0, block_outside/4])
                cube([block_outside, beam_w, block_outside/2], center=true);
            translate([0, 0, ir + wall_th])
                rotate([90, 0, 0]) 
                cylinder(r=block_outside/2, h=beam_w, center=true);
            * translate([ir + wall_th, 0, sqrt(2)/4*block_brace_w + wall_th/2])
                rotate([0, 45, 0])
                cube([block_brace_w, beam_w, block_brace_w/2], center=true);
            * translate([-ir - wall_th, 0, sqrt(2)/4*block_brace_w + wall_th/2])
                rotate([0, -45, 0])
                cube([block_brace_w, beam_w, block_brace_w/2], center=true);
            translate([-ir - wall_th + 1, -beam_w/2 + block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, -45, 0])
                cube([beam_w, block_brace_w/2, beam_w], center=true);
            * translate([-ir - wall_th + 1, beam_w/2 - block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, -45, 0])
                cube([beam_w, block_brace_w/2, beam_w], center=true);
            translate([ir + wall_th - 1, -beam_w/2 + block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, 45, 0])
                cube([beam_w, block_brace_w/2, beam_w], center=true);
            * translate([ir + wall_th - 1, beam_w/2 - block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, 45, 0])
                cube([beam_w, block_brace_w/2, beam_w], center=true);
        }
        translate([0, 0, ir + wall_th])
            rotate([90, 0, 0]) 
            cylinder(r=ir, h=beam_w+1, center=true, $fn=64);
        translate([beam_w, 0, 0])
            cylinder(r=openbeam_hole_or, h=wall_th*2);
        translate([-beam_w, 0, 0])
            cylinder(r=openbeam_hole_or, h=wall_th*2);
        
        translate([0, 0, -beam_w/2])
            cube([3*beam_w + 1, beam_w + 1, beam_w], center=true);
    }
}

bearing_h = 7;
bearing_ir = 4;
bearing_or = 11;
block_brace_w = 5;
module pillow_block() {
   mount_block(bearing_or);
}

module rocker_mount() {
    % translate([0, -beam_w/2, rocker_or + wall_th])
        rotate([90]) 
        rocker();
    mount_block(rocker_or);
}

sens_pin_h = 5;
sens_pin_l = 9;
sens_pin_offs_l = 4;
sens_chip_h = 4;

module sens_pins(pin_w) {
    translate([-sens_pin_l / 2 + sens_pin_offs_l, 0, sens_chip_h / 2 + sens_pin_h / 2])
        cube([sens_pin_l, pin_w, sens_pin_h], center=true);
        
}

ir_sens_chip_l = 20;
ir_sens_chip_w = 16;
ir_sens_pin_w = 8;

ir_sens_h = 12;
ir_sens_w = 6;
ir_sens_l = 6;
module ir_sensor() {
    cube([ir_sens_chip_l, ir_sens_chip_w, sens_chip_h], center=true);
    translate([0, 0, ir_sens_h / 2])
        cube([ir_sens_l, ir_sens_w, ir_sens_h], center=true);
    translate([-ir_sens_chip_l/2, 0, 0])
        sens_pins(ir_sens_pin_w);
}

ir_emit_chip_l = 20;
ir_emit_chip_w = 16;
ir_emit_pin_w = 8;

ir_emit_or = 3;
ir_emit_l = 22;
module ir_emit() {
    cube([ir_emit_chip_l, ir_emit_chip_w, sens_chip_h], center=true);
    rotate([0, 90, 0])
        cylinder(r=ir_emit_or, h=ir_emit_l);
    translate([-ir_emit_chip_l/2, 0, 0])
        sens_pins(ir_emit_pin_w);
}

volt_disp_w = 14;
volt_disp_l = 23;
volt_disp_h = 10;
volt_disp_tab_lw = 5;
volt_disp_tab_h = 3;
volt_disp_tab_hole_ir = 3 / 2;

module volt_disp() {
    difference() {
        union() {
            cube([volt_disp_l, volt_disp_w, volt_disp_h], center=true);
            translate([0, 0, (volt_disp_tab_h - volt_disp_h) / 2]) 
                cube([
                    volt_disp_l + 2 * volt_disp_tab_lw,
                    volt_disp_tab_lw,
                    volt_disp_tab_h], center=true);
        }
        volt_disp_holes();
    }
}

module volt_disp_holes() {
    for (i=[-1, 1]) {
        translate([i* (volt_disp_l + volt_disp_tab_lw)/2, 0, 0])
            cylinder(r=volt_disp_tab_hole_ir, h=2*volt_disp_h, center=true);
    }
}

module volt_disp_holder() {
    volt_disp();
    % translate([0, 0, -openbeam_w/2])
        rotate([0, 90, 0])
        openbeam();
    
}

eflight_bat_l = 110;
eflight_bat_w = 35;
eflight_bat_h = 35;

module eflight_bat() {
    cube([eflight_bat_l, eflight_bat_w, eflight_bat_h], center=true);
}

l298n_l = 45;
l298n_w = 45;
l298n_h = 15;
l298n_heatsink_l = 16;
l298n_heatsink_w = 23;
l298n_heatsink_h = 29;
l298n_hole_or = 3 / 2;
l298n_hole_c_c = 37;
module l298n() {
    difference() {
        union() {
            translate([0, 0, l298n_h/2])
                cube([l298n_l, l298n_w, l298n_h], center=true);
            translate([(l298n_l-l298n_heatsink_l)/2, 0, l298n_heatsink_h/2])
                cube([l298n_heatsink_l, l298n_heatsink_w, l298n_heatsink_h], center=true);
        }
        l298n_holes();
    }
}

module l298n_holes() {
    for (x=[-1, 1]) {
        for (y=[-1, 1]) {
            translate([x * l298n_hole_c_c/2, y * l298n_hole_c_c / 2, l298n_heatsink_h/2])
            cylinder(r=l298n_hole_or, h=l298n_heatsink_h * 2, center=true);
        }
    } 
}

laser_diode_h = 25;
laser_diode_or = 9/2;
laser_diode_beam_ir = 6 / 2;
laser_diode_beam_l = 100;
laser_diode_wire_ir = 4 / 2;
module laser_diode(bl=laser_diode_h, wl=laser_diode_h) {
    rotate([0, 90, 0]) {
        cylinder(r=laser_diode_or, h=laser_diode_h, center=true);
        color("red", 0.5)
            translate([0, 0, laser_diode_h/2])
            cylinder(r1=laser_diode_beam_ir, r2=bl, h=bl);
            // scale([0.3, 1.1, 1])
            // cylinder(r1=laser_diode_beam_ir, r2=bl, h=bl);
        color("red")
            translate([0, -1, -laser_diode_h/2 - wl])
            cylinder(r=1, h=wl);
        color("black")
            translate([0, 1, -laser_diode_h/2 - wl])
            cylinder(r=1, h=wl);
    }
}


/////////////////////////////////////////////////
//////////// LIMIT SWITCH ///////////////////////
/////////////////////////////////////////////////

switch_w = 20;
switch_l = 11;
switch_h = 7;
switch_hole_offset_w = 5;
switch_hole_offset_l = 3;
switch_hole_ir = 2.5 / 2;

switch_roller_offset = 3;
switch_roller_overhang = 2.3;
switch_roller_h = 5;
switch_roller_w = 19;
switch_roller_l = 5;
switch_roller_th = 0.2;

switch_pin_clearance = 1.5;
switch_pin_h = 5;

switch_holder_lip_l = 2;
switch_holder_h = 3 * rail_r;
switch_holder_w = switch_holder_h + switch_w + switch_roller_overhang;
switch_holder_l = switch_l + 2 * switch_holder_lip_l;

module switch() {
    translate([0, 0, -switch_h/2])
        cube([switch_l, switch_w, switch_h]);
    translate([-switch_roller_l, -switch_roller_overhang, -switch_roller_h/2])
        rotate([0, 0, -atan(switch_roller_l / switch_roller_w)])
            cube([switch_roller_th, switch_roller_w, switch_roller_h]);
    translate([switch_l, switch_pin_clearance, -switch_pin_h/2])
        cube([switch_pin_h, switch_w - 1 * switch_pin_clearance, switch_pin_h]);
    translate([switch_l - switch_hole_offset_l, switch_w - switch_hole_offset_w, -switch_h])
        cylinder(r=switch_hole_ir, h=2 * switch_h);
    
    translate([switch_l - switch_hole_offset_l, switch_hole_offset_w, -switch_h])
        cylinder(r=switch_hole_ir, h=2 * switch_h);
}
