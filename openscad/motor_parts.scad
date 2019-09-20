include <lib/motors.scad>;
include <lib/metric.scad>;
include <lib/motion_hardware.scad>;
use <lib/lib_pulley.scad>;
include <lib/mower.scad>;

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
        for (z=[hub_h / 4, hub_h / 2, 3 * hub_h / 4]) {
            translate([0, hub_ir, wall_th + z]) {
                rotate([90, 0, 0]) {
                    cylinder(r=5/2, h=hub_ir);
                    m5_nut();
                    translate([0, 0, m5_nut_h/2 + 1]) m5_nut();
                }
            }
        }
    }
}

pitch_or = bldc_od / 2 + 4;
gt2_pitch = 2;
bldc_teeth = floor(2 * 3.14 * pitch_or / gt2_pitch);
hs_pulley_teeth = 10;
drive_ratio = bldc_teeth / hs_pulley_teeth; 
hs_axle_od = 8;
bldc_max_rpm = 990;
hs_max_rpm = bldc_max_rpm * bldc_teeth / hs_pulley_teeth;
bldc_hole_or = 3/2;
gear_h = bldc_hub_h; //6;  // IN_MM * get_thickness(CHAIN_SIZE);
echo("bldc: ", bldc_teeth, ":", hs_pulley_teeth,  " (", drive_ratio, ") ", hs_max_rpm, " rpm");

module bldc_pulley(use_stl=false) {
    if (use_stl) {
        import("stl/bldc_pulley.motor_parts.stl");
    } else {
        //difference() {
            //sprocket(size=CHAIN_SIZE, teeth=bldc_teeth, bore=bldc_od/IN_MM);
            gt2_pulley(
                bldc_teeth, bldc_od, 
                pulley_t_ht=gear_h, pulley_b_ht=0, 
                pulley_b_dia=0, no_of_nuts=0, nut_shaft_distance=0);
            //bldc_holes();
        //}
    }
}

module hs_pulley(use_stl=false) {
    if (use_stl) {
        import("stl/hs_pulley.motor_parts.stl");
    } else {
        difference() {
            union() {
                translate([0, 0, -gear_h/2])
                //sprocket(size=CHAIN_SIZE, teeth=hs_pulley_teeth, bore=motor_coupler_od/IN_MM);
                gt2_pulley(
                    hs_pulley_teeth, motor_coupler_od, 
                    pulley_t_ht=gear_h, pulley_b_ht=gear_h, 
                    pulley_b_dia=motor_coupler_od, no_of_nuts=0, nut_shaft_distance=3);
                cylinder(r=(motor_coupler_od+4)/2, h=motor_coupler_length, center=true);
            }
        
            cylinder(r=motor_coupler_od/2, h=motor_coupler_length, center=true);
            translate([0, 0, -motor_coupler_length/2]) {
                % motor_coupler();
                for (theta=[0:5:10])
                    rotate([0, 0, theta])
                    motor_coupler_holes();
            }
        }
    }
}

module bldc_holes() {
    bldc_num_holes = floor(bldc_teeth / 4);
    bldc_hole_angle = 360 / bldc_num_holes;
    
    * for (i=[0:bldc_num_holes-1]) {
        rotate([0, 0, i*bldc_hole_angle])
        translate([bldc_od/2 + 4, 0, 0])
        cylinder(r=bldc_hole_or, h=bldc_hub_h, center=true);
    }
}  

module bldc_sleeve() {
    difference() {
        cylinder(r=bldc_rim_od/2, h=(bldc_hub_h-gear_h)/2, center=true, $fn=90);
        cylinder(r=bldc_od/2, h=(bldc_hub_h-gear_h)/2, center=true, $fn=90);
        # bldc_holes();
    }
}

module bldc_design() {
    translate([0, 0, -gear_h/2])
        bldc_pulley(false);
    % bldc_hub();
    * for (i=[-1,1])
        translate([0, 0, i*(gear_h/2 + (bldc_hub_h-gear_h)/4)])
        bldc_sleeve();
        
}

ch_adapter_h = dc_m_threads_h/2;

module ch_adapter() {
    % translate([0, 0, -ch_hub_h]) 
        cutting_head();
    % translate([0, 0, dc_m_threads_h/2])
        rotate([180, 0, 0])
        dc_mower();
    difference() {   
        union() {
            cylinder(r=ch_hub_hex_ir, h=ch_adapter_h/2, $fn=6);
            translate([0, 0, ch_adapter_h/2])
                cylinder(r2=ch_hub_ir, r1=ch_hub_ir+.3, h=ch_top_h/2);
        }
        m5_nut();
        cylinder(r=dc_m_shaft_or, h=ch_adapter_h);
    }
}

ch_adapter();

//bldc_design();

//translate([100, 100, 0])
//hs_pulley(false);