include <lib/motors.scad>;
include <lib/metric.scad>;
include <lib/motion_hardware.scad>;
use <lib/lib_pulley.scad>;
include <lib/mower.scad>;
include <lib/casting.scad>;

hub_ir = (1 + 3/8) * IN_MM / 2;
wall_th = 3;

hub_h = 45;
hub_num_sections = 2;
hub_section_theta = 360 / hub_num_sections;
min_draft_angle = 3; // for testing
key_h = hub_ir - wc_shaft_r2 ;

module _hub_adapter() {
    difference() {
        intersection() {
            draft_cylinder(r=hub_ir, h=hub_h, invert=false, draft_angle=0, face_draft=min_draft_angle);
            rotate([0, 0, 180])
                draft_cylinder(r=hub_ir, h=hub_h, invert=false, draft_angle=0, face_draft=min_draft_angle);
            // draft_cylinder(r=hub_ir, h=hub_h, invert=false, draft_angle=0, face_draft=-5);
            // * cylinder(r=hub_ir + wall_th, h=wall_th);
        }
        translate([0, 0, hub_h - wc_shaft_h]) {
            wc_motor_shaft(key=false);
            // * wc_motor_shaft_key_offset()
            // wc_motor_shaft_double_key(4);
            wc_motor_shaft_key_offset() {
                translate([0, 0, (wc_shaft_notch_d - key_h)/2 - wc_shaft_notch_d - 0.2])
                    wc_motor_shaft_key(h=key_h, draft_angle=min_draft_angle);
                translate([0, 0, (wc_shaft_notch_d - key_h)/2])
                % hub_key();
            }
        }
        
        
    }
    /*section_h = hub_h / hub_num_sections;
    for (i=[0:hub_num_sections-1])
        translate([0, 0, section_h*i])
        hub_adapter_section(i);*/
}

module hub_key() {
    wc_motor_shaft_key(h=hub_ir - wc_shaft_r2 + wc_shaft_notch_d, draft_angle=min_draft_angle);
}
* ! translate([0, 0, (wc_shaft_notch_d - key_h)/2])
                wc_motor_shaft_key(h=key_h, draft_angle=min_draft_angle);
module hub_adapter_key() {
    intersection() {
        _hub_adapter();
        hub_adapter_mask();
    }
}


module hub_adapter_prong() {
    intersection() {
        rotate([0, 0, hub_section_theta])
            _hub_adapter();
        hub_adapter_mask();
    }
}

module hub_adapter() {
    hub_adapter_key();
    * for (i=[1:hub_num_sections])
    rotate([0, 0, i*hub_section_theta])
        hub_adapter_prong();
}


// module wc_motor_shaft_double_key(n=3) {
//     for (i=[0:n])
//         translate([0, 0, -i*wc_shaft_notch_d])
//         wc_motor_shaft_key();
// }

module hub_adapter_mask() {
    r = 40;
    translate([-r, 0, 0])
        cube([2*r, r, hub_h]);
    // linear_extrude(hub_h)
    //     polygon([
    //         [0, 0], 
    //         [r * sin(hub_section_theta/2), r * cos(hub_section_theta/2)], 
    //         [r * -sin(hub_section_theta/2), r * cos(hub_section_theta/2)]]);
}

// ! hub_adapter_mask();
// module hub_adapter_section(section=0, hub_num_sections=hub_num_sections) {
//     section_h = hub_h / hub_num_sections;
    
//     difference() {
//         union() {
//             draft_cylinder(r=hub_ir, h=section_h, invert=false, draft_angle=-2);
//             * cylinder(r=hub_ir + wall_th, h=wall_th);
//         }
//         translate([0, 0, -section * section_h])
//             wc_motor_shaft();
//         echo(section=section);
//         * for (z=[hub_h / 4, hub_h / 2, 3 * hub_h / 4]) {
//             translate([0, hub_ir, wall_th + z]) {
//                 rotate([90, 0, 0]) {
//                     cylinder(r=5/2, h=hub_ir);
//                     m5_nut();
//                     translate([0, 0, m5_nut_h/2 + 1]) m5_nut();
//                 }
//             }
//         }
//     }
// }

// ! wc_motor_shaft();

module hub_adapter_cast_plate() {
    
    scale(CAST_EXPANSION) {
        translate([-25, 20, 0])
            rotate([90, 0, 0])
            hub_adapter_key();
        translate([25, 20, 0])
            rotate([90, 0, 0])
            hub_adapter_prong();
        translate([0, 0, (hub_ir - wc_shaft_r2 + wc_shaft_notch_d)/2])
            rotate([0, 0, 0])
            hub_key();

        // translate([5, 0, 2])
        //      draft_cube([10, 10, 4], center=true);
        # translate([0, -20, 2])
             draft_cube([20, 5, 4], center=true);
        translate([-45, 0, 1.5])
             draft_cube([6, 5, 3], center=true);
        translate([-50, 0, 0])
            shell(5, 4);
        translate([45, 0, 1.5])
             draft_cube([6, 5, 3], center=true);
        translate([50, 0, 0])
            shell(5, 4);

        translate([0, 20, 2.5])
             draft_cube([4, 15, 5], center=true);
        translate([8, 22, 2.5])
            rotate([0, 0, 45])
             draft_cube([4, 15, 5], center=true);
        translate([-8, 22, 2.5])
            rotate([0, 0, -45])
             draft_cube([4, 15, 5], center=true);
        translate([0, 35, 0])
            shell();

        // translate([0, -40, 0])
        //     rotate([60, 0, 0])
        //     rotate([0, -90, 0])
        //     hub_adapter_prong();
    
        // translate([-35, 0, hub_h])
        //     rotate([180, 0, 0])
        //     hub_adapter();
        // translate([35, 0, hub_h])
        //     rotate([180, 0, 0])
        //     hub_adapter();
        // shell();
        // for (x=[-67, 67])
        // translate([x, 0, 0]) 
        //     shell(or=5, ir=4);
        // for (x=[-14, 14])
        // translate([x, 0, 2])
        //     draft_cube([10, 6, 4], center=true, draft_angle=10);
        // for (x=[-58, 58])
        // translate([x, 0, 1])
        //     draft_cube([10, 3, 2], center=true, draft_angle=10);
    }
}


wc_adapter_th = 5;
wc_adapter_or = 45;
wc_adapter_h = wc_adapter_or - wc_adapter_th - wall_th;
wc_adapter_num_holes = 4;
wc_adapter_hole_ir = 3;
wc_adapter_hole_offs = 35;
wc_adapter_num_sections = 4;
wc_key_h = 10;

module divet(r=2, h=5) {
    cylinder(r1=r, r2=0, h=h, $fn=32);
}

module wc_adapter() {
    difference() {
        union() {
            difference() {
                union() {
                    draft_cylinder(r=wc_adapter_or, h=wc_adapter_h, draft_angle=min_draft_angle);
                    
                }
                translate([0, 0, wc_adapter_h])
                    rotate_extrude()
                    translate([wc_adapter_or, 0, 0])
                    circle(r=wc_adapter_or - wc_shaft_r1 - wall_th);
            }
            # for (i=[0:wc_adapter_num_holes])
                rotate([0, 0, 360/wc_adapter_num_holes*i])
                translate([wc_adapter_hole_offs, 0, 0])
                draft_cylinder(h=5, r=4, invert=false, draft_angle=min_draft_angle);
        }
        % translate([0, 0, wc_shaft_h])
            rotate([180, 0, 0])
            wc_motor_shaft(key=false);
        
        divet();
        translate([0, 0, wc_adapter_h])
            rotate([180, 0, 0])
            divet();
        for (i=[0:wc_adapter_num_holes])
            rotate([0, 0, 360/wc_adapter_num_holes*i]) {
                translate([wc_adapter_hole_offs, 0, 0])
                divet();
                translate([wc_adapter_hole_offs, 0, 8])
                    rotate([180, 0, 0])
                    divet();   
                translate([wc_adapter_hole_offs, 0, 5])
                    draft_cylinder(h=5, r=4, invert=false, draft_angle=-min_draft_angle);
            * draft_cylinder(r=wc_adapter_hole_ir, h=3*wc_adapter_th, draft_angle=min_draft_angle);
        }
    }
}

module wc_adapter_spines() {
    cutout_r = wc_adapter_or - wc_shaft_r1 - wc_adapter_th;
    // rotate_extrude() {
        // rotate([90, 0, 0])
        difference() {
            translate([wc_adapter_or/2 - 1, 0, wc_adapter_h - wc_adapter_th - cutout_r/2])
                // rotate([90, 0, 0])
                square([wc_adapter_or - 2, wc_adapter_num_sections * wc_adapter_h], center=true);

            * translate([wc_adapter_or, 0, wc_adapter_h - wc_adapter_th - cutout_r]) {
                // rotate([90, 0, 0])
                scale([0.9, 1, 1])
                    circle(r=cutout_r, h=wc_adapter_th*2, center=true);
                translate([0, 0, -wc_adapter_th])
                    square([1.8*cutout_r, wc_adapter_th*3], center=true);
                    // draft_cube([1.8*cutout_r, wc_adapter_th*3, wc_adapter_th*2], center=true, draft_angle=-min_draft_angle, invert=true);
            }
        }
    // }
}


module wc_adapter_section(section=0) {
    difference() {
        translate([0, 0, -wc_adapter_h * section])
            draft_cylinder(r=hub_ir, h=wc_adapter_h, invert=false, draft_angle=-min_draft_angle);
        wc_adapter_spines(false);
        translate([0, 0, -wc_shaft_h + wc_adapter_h]) {
            wc_motor_shaft(key=false);
            wc_motor_shaft_key_offset() {
                wc_key();
                * translate([0, wc_shaft_notch_l, 0])
                    wc_key();
            }
        }
    }
}

module wc_key() {
    wc_motor_shaft_key(h=wc_key_h, draft_angle=min_draft_angle);
}

module sprue_shell(or=10, h=5, l=20) {
    rotate([0, 0, 0]) {
        shell(or, or-2);
        translate([(l + or)/2, 0, 0])
        sprue_runner(h=h, l=l+or);
    }
}

module sprue_runner(h=5, l=20) {
    translate([0, 0, h/2])
    draft_cube([l, 2*h, h], center=true, draft_angle=10);
}

module wc_adapter_cast_plate() {
    scale(CAST_EXPANSION) {
        translate([0, -70, wc_adapter_h])
            rotate([180, 0, 0])
            wc_adapter();


        translate([30, 30, wc_key_h/2])
            rotate([0, 0, -45])
            wc_key();
        translate([-30, 30, wc_key_h/2])
            rotate([0, 0, 45])
            wc_key();
        translate([30, 30, 0])
            rotate([0, 0, 135])
            sprue_runner(3, 45);
        translate([-30, 30, 0])
            rotate([0, 0, 45])
            sprue_runner(3, 45);
        translate([-30, -30, 0])
            rotate([0, 0, 135])
            sprue_runner(3, 45);
        translate([30, -30, 0])
            rotate([0, 0, 45])
            sprue_runner(3, 45);
        translate([0, 0, 0])
            rotate([0, 0, 90])
            sprue_runner(5, 60);
        sprue_runner(5, 60);

        // translate([50, 0, 0])
        //     sprue_runner(4, 16);
        // translate([60, -30, 0])
        //     rotate([0,0,90])
        //     sprue_runner(3, 30);
        // translate([50, 30, 0])
        rotate([0, 0, -90])
            sprue_shell();
        // translate([60, 20, 0])
        //     rotate([0,0,90])
        //     sprue_runner(3, 30);

        for (i=[1:wc_adapter_num_sections-1])
            rotate([0, 0, (i + 1) * 360 / (wc_adapter_num_sections)]) {
            rotate([180, 0, 0])
            translate([-40, 0, (i-1)*wc_adapter_h])
                wc_adapter_section(i);
            // translate([-50, 0, 0])
            //     sprue_runner(4, 20);
            // translate([-70, -40, 0])
            //     rotate([0, 0, 90])
            //     sprue_shell(6, 4);
        }
    }
}

wc_adapter();
 // # wc_adapter_section(0);
// * for (i=[1:wc_adapter_num_sections-1])
// wc_adapter_section(i);
// wc_adapter_section(2);
// wc_adapter_section(3);
// wc_adapter_cast_plate();
// hub_adapter_cast_plate();
// % translate([40, 40, 0])
//     hub_adapter();


// % flask();

// hub_adapter_cast_plate();

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

module scale_plate_bldc() {
    bldc_hub();
}

// scale_plate_bldc();
// ch_adapter();

//bldc_design();

//translate([100, 100, 0])
//hs_pulley(false);