include <lib/metric.scad>;
include <lib/motors.scad>;
include <lib/purchased_electrics.scad>;
include <lib/motion_hardware.scad>;
include <lib/openbeam.scad>;
include <lib/t20beam.scad>;

beam_w = 20;
// bar_w = 300;
// low_bar_clr = 70;
// high_bar_clr = 350;
// high_bar_offs = 150;

// cam_l = 100;

// // $t = 0;
// // $t = 0.125;
// // $t = 0.24;
// // $t = 0.25;
// // $t = 0.5;
// // $t = 0.75;

// cam_position = [100, bar_w/2, 150];
// function cam_rotation() = [0, 360*$t, 0];
// function cam_wrist_position() = [
//     cam_l * cos(-cam_rotation()[1]),
//     beam_w/2,
//     cam_l * sin(-cam_rotation()[1])
// ];
// function scoop_position() = [
//     200, 
//     50, 
//     //($t < 0.25 ? 0 : 
//     cam_wrist_position()[2] + cam_l //)
// ];
// function scoop_rotation() = [0, 0, 0];
// function rake_position() = [
//     400, 50, 0] + [
//         cam_wrist_position()[0], 0, 
//         scoop_position()[2]];
// function rake_rotation() = [0, 0, 0];

// function poop_position() = [300, 150, 0] + [
//     ($t < 0.5 ? cam_wrist_position()[0] : -cam_l), 
//     0, 
//     scoop_position()[2]];

// echo(
//     cam_wrist_position=cam_wrist_position(),
//     scoop_position=scoop_position());

// module mountpoints() {
//     translate([0, 0, low_bar_clr])
//         cube([beam_w, bar_w, beam_w]);
//     translate([0, 0, high_bar_clr])
//         cube([beam_w, bar_w, beam_w]);
//     translate([high_bar_offs + beam_w, 0, high_bar_clr])
//         cube([beam_w, bar_w, beam_w]);
//     translate([beam_w, 0, high_bar_clr])
//         cube([high_bar_offs, beam_w, beam_w]);  
//     translate([beam_w, bar_w - beam_w, high_bar_clr])
//         cube([high_bar_offs, beam_w, beam_w]);   
// }

// module mechanism_motor() {
//     translate(cam_position)
//         rotate([90, -90, 180])
//         drive_motor();
// }

// module scoop() {
//     difference() {
//         cube([150, 200, 100]);
//         translate([2, 2, 2])
//             cube([150, 196, 100]);
//         translate([0, -1, 100])
//             rotate([0, 35, 0])
//             cube([200, 202, 100]);
//     }

//     translate([-100, 100-beam_w/2, 0])
//         cube([100, beam_w, beam_w]);
// }

// module rake() {
//     // % scoop();
//     for (y=[beam_w/2:beam_w*2:200-beam_w/2]) {
//         translate([0, y, 0]) {
//             rotate([0, 45, 0])
//                 cube([2, beam_w, 50]);
//             translate([50/sqrt(2), 0, 50/sqrt(2)])
//                 rotate([0, -45, 0])
//                 cube([2, beam_w, 100]);

//         }
//     }
//     translate([-50/sqrt(2), beam_w/2, 150/sqrt(2)])
//         rotate([0, -45, 0])
//         cube([2, 200-beam_w, beam_w]);
    
// }

// // ! rake();

// module mechanism_scoop() {
//     translate(scoop_position())
//         rotate(scoop_rotation())
//         scoop();
// }

// module mechanism_rake() {
//     translate(rake_position()) 
//     rotate(rake_rotation())
//         rake();
// }

// // ! mechanism_rake();

// module cam() {
//     translate([-beam_w/2, 0, -beam_w/2])
//         cube([cam_l + beam_w, beam_w, beam_w]);
// }

// module mechanism_cam() {
//     translate(cam_position)
//         rotate(cam_rotation())
//             cam();
// }

// module mechanism_cam_pin() {
//     translate(cam_position + cam_wrist_position())
//         rotate([90, 0, 0])
//         cylinder(r=5/2, h=30, center=true);
// }

// module mechanism() {
//     % mechanism_motor();
//     mechanism_cam();
//     # mechanism_cam_pin();
//     % mechanism_scoop();
//     % mechanism_rake();
// }


// module poop() {
//     translate([max(
//             0, scoop_position()[0] - poop_position()[0] + 22), 0, 20])
//         rotate([90, 0, 0])
//         cylinder(r=20, h=90);
//     translate([30, 0, 15])
//         rotate([-30, 90, 0])
//         cylinder(r=15, h=80);
//     // translate([-30, 50, 10])
//     //     sphere(r=10);
//     translate([max(
//             -30, scoop_position()[0] - poop_position()[0] + 12), 
//             50, 10])
//         sphere(r=10);
// }


// IBT_2 h-bridge BTS7960b
ibt2_l = 50;
ibt2_w = 42;
ibt2_h = 52;
ibt2_hs_l = 35;
ibt2_hs_w = 27;
ibt2_hs_h = ibt2_h;
ibt2_hole_r = 3/2;
// ibt2_hole_offset = 5;
ibt2_hole_or = 6/2;
ibt2_board_th = 1.5;
ibt2_board_side_w = ibt2_w - ibt2_hs_w;
ibt2_hole_c_c = 40;

module ibt2_holes() {
    for (x=[-ibt2_hole_c_c/2, ibt2_hole_c_c/2]) {
        for (z=[-ibt2_hole_c_c/2, ibt2_hole_c_c/2]) {
            translate([x, 0, z]) {
                rotate([-90, 0, 0]) {
                    translate([0, 0, -ibt2_hs_w])
                        cylinder(r=ibt2_hole_r, h=ibt2_w);
                    translate([0, 0, ibt2_board_th]) 
                        cylinder(r=ibt2_hole_or, h=ibt2_board_side_w);
                }
            }
        }
    }
}

module ibt2() {
    difference() {
        translate([0, ibt2_board_th/2, 0])
            cube([ibt2_l, ibt2_board_th, ibt2_h], center=true);
        ibt2_holes();
    }    
    translate([0, -ibt2_hs_w/2, 0])
        cube([ibt2_hs_l, ibt2_hs_w, ibt2_hs_h], center=true);
}

// ! ibt2();

// module ibt2_centered() {
//     translate([-ibt2_l/2, 0, -ibt2_h/2]) {
//         ibt2();
//         # ibt2_holes();
//     }
// }

// ! ibt2_centered();

module h_bridge_holder() {
    difference() {
        union() {
            translate([0, 10, 1])
                cube([50, 80, 2], center=true);
            translate([0, 0, 2])
                rotate([-90, 0, 0])
                for (x=[-ibt2_hole_c_c/2, ibt2_hole_c_c/2]) {
                for (z=[-ibt2_hole_c_c/2, ibt2_hole_c_c/2]) {
                    translate([x, 0, z]) {
                        rotate([90, 0, 0]) {
                            translate([0, 0, 0]) 
                                cylinder(r1=dcctl_hole_or, r2=dcctl_hole_r+1, h=3);
                        }
                    }
                }
            }
        }
        translate([0, 0, 6])
        rotate([90, 0, 0]) {
            ibt2();
            ibt2_holes();
        }
        # for (x=[-15, 15])
            translate([x, 40, 0])
            cylinder(r=5/2, h=5);
    }
}

// ! h_bridge_holder();

// pulley_or = 10;
// pulley_ir = 6/2;
// pulley_w = 5;

// module pulley() {
//     difference() {
//         cylinder(r=pulley_or, h=pulley_w+2, $fn=64, center=true);
//         cylinder(r=pulley_ir, h=pulley_w*2, $fn=64, center=true);
//         rotate_extrude($fn=64)
//             translate([pulley_or, 0, 0])
//                 circle(r=pulley_w/2);
        
//     }
// }

// // ! pulley();

// rake_ir = 11/64 * IN_MM / 2;
// rake_pitch = 0.5 * IN_MM;
// rake_w = 5;
// rake_h = 60;

// module rake() {
//     difference() {
//         union() {
//             cylinder(r=5, h=2*rake_w);
//             translate([rake_pitch, 0, 0])
//                 cylinder(r=5, h=2*rake_w);
//             translate([rake_pitch/2, 0, rake_w/2])
//                 cube([rake_pitch, rake_w*2, rake_w], center=true);
//             translate([rake_pitch, rake_h + rake_w/2, 0])
//             difference() {
//                 cylinder(r=rake_h, h=rake_w, $fn=64);
//                 cylinder(r=rake_h - rake_w/2, h=rake_w*3, center=true, $fn=64);
//                 translate([0, rake_h/2, 0])
//                     cube([2*rake_h, rake_h, 30], center=true);
//                 translate([rake_h/2, 0, 0])
//                     cube([rake_h, 2*rake_h, 30], center=true);
//             }
            
//         }
//         cylinder(r=rake_ir, h=rake_w*5, center=true);
//         translate([rake_pitch, 0, 0])
//             cylinder(r=rake_ir, h=rake_w*5, center=true);
        
//     }
    
// }

// // ! rake();


// module bushing68() {
//     difference() {
//         cylinder(r=3.8, h=7, $fn=128);
//         cylinder(r=3, h=20, center=true, $fn=64);
//     }
// }

// ! bushing68();

module bushing38() {
    difference() {
        cylinder(r=3.8, h=8, $fn=128);
        cylinder(r=3/2, h=20, center=true, $fn=64);
    }
}

// ! bushing38();

flange_or = 13;
flange_ir = 3;
flange_hole_ir = 3/2;
flange_hole_offs = 3/4 * IN_MM/2;
flange_h = 5;
flange_hub_h = 4;
flange_hub_or = 1/2 * IN_MM/2;

module flange_holes() {
    // cylinder(r=flange_ir, h=20, center=true, $fn=64);
    for (r=[0:5])
        rotate([0, 0, 60*r])
        translate([flange_hole_offs, 0, 0])
        // cylinder(r=flange_hole_ir, h=(r == 0 || r == 3) ? 30: 18, center=true);
        cylinder(r=flange_hole_ir, h=30, center=true);
}

module flange() {
    cylinder(r=flange_or, h=flange_h, $fn=128);
    cylinder(r=flange_hub_or, h=flange_h+flange_hub_h, $fn=64);
    
}


adapter_or = 20;
adapter_h = 9;

module adapter_holes() {
    cylinder(r=3/2, h=40, center=true);
    // translate([0, 0, 17])
    //     cube([15.2, 15.2, 30], center=true);
    translate([0, 0, 17])
        openbeam(30);
    for (r=[0:5])
        rotate([0, 0, 60*r])
        translate([flange_hole_offs, 0, 7])
        cylinder(r=3, h=10, center=true);
}

// ! adapter_holes();

module flange_adapter() {
    disc_th = 2;
    stub_h = 4;
    difference() {
        union() {
            // cube([15, 15, 15], center=true);
            cylinder(r=flange_or, h=disc_th);
            translate([0, 0, disc_th + stub_h/2])
                cube([19, 19, stub_h], center=true);
        }

        // # 
        adapter_holes();
        rotate([0, 180, 0])
            flange();
        flange_holes();
    }

}

// !flange_adapter();

module mini_motor_mount() {
    difference() {
        translate([-15.5, -16, -3])
            cube([46, 16+kp08_c_h+21, 5]);
        cylinder(r=4, h=20, center=true, $fn=64);
        mini_motor_holes();
        
        for (x=[0, 20])
            translate([x, kp08_c_h+11, 0])
            cylinder(r=5/2, h=20, center=true);

        // kp08_c_h
        // translate([0, 0, 2])
        //     rotate([180, 0, 0]) {
        //     mini_motor();
        //     mini_motor_holes();
        // }

       mini_motor();
       translate([-50, kp08_c_h + 1, -20])
            cube([100, 20, 20]);
    }
    
        
}

// ! mini_motor_mount();

rake_plate_w = 100;
rake_plate_h = 15;
rake_plate_th = 1;
rake_tong_w = 5;
rake_tong_l = 60;

module rake_plate() {
    difference() {
        union() {
            translate([-rake_plate_h/2, -rake_plate_h/2, 0])
                cube([rake_plate_h, rake_plate_w - 4, rake_plate_th]);
            for (y=[10:2*rake_tong_w * sqrt(2):rake_plate_w])
                translate([rake_tong_l/2, y - 10, 0])
                rotate([45, 0, 0])
                cube([rake_tong_l, rake_tong_w, rake_tong_w], center=true);
        }
        translate([-rake_plate_h/2, -rake_plate_h/2, -10])
            cube([rake_tong_l + 20, rake_plate_w, 10]);
        translate([-rake_plate_h/2, -rake_plate_h/2, rake_plate_th])
            cube([rake_tong_l + 20, rake_plate_w, 10]);
        for (x=[0, (rake_plate_w - rake_plate_h)/2, rake_plate_w - rake_plate_h])
            translate([0, x, 0])
            cylinder(r=3/2, h=10, center=true);
    }
}

! rake_plate();

module combine() {
    for (r=[0:3])
        rotate([0, 0, 90*r])
        translate([0, -15/2, 14])
            rotate([90, 0, 0])
                rake_plate();
    % translate([0, 0, 52])
        openbeam(100);
        // cube([15, 15, 100], center=true);
}

! combine();

module side_plate() {
    // % combine();
    mini_motor_mount();
    difference() {
        translate([-15.5, -rake_tong_l, 0])
            cube([46, rake_tong_l - 15, 2]);
        for (x=[0, 20])
            translate([x, -rake_tong_l + 10, 0])
            cylinder(r=5/2, h=20, center=true);
    }
}

// ! side_plate();

module design() {
    // translate([0, 0, rake_plate_w - 10])
    //     adapter();
    // translate([0, 0, (rake_plate_w-10)/2])
    //     adapter();
    flange_adapter();
    
    // *% translate([0, 0, 120])
    //     rotate([0, 90, -90])
    //     sk8();

    % translate([0, 0, 120])
        rotate([0, 90, -90]) 
        kp08();
    // % translate([0, sk8_c_h, 0])
    //     cube([20, 20, 150]);
    // % translate([-30, kp08_c_h, 0])
    //     cube([20, 20, 150]);

    translate([0, 0, -4]) {
        side_plate();
        // mini_motor_mount();
        % mini_motor();
    }

    rotate([0, 0, -$t*360])
        combine();
    translate([0, 0, 102])
        bushing38();
    translate([0, 0, 110])
        bushing38();
    translate([0, 0, 120])
        bushing38();

    // translate([0, 0, 130])
    //     side_plate();
    translate([0, 0, 108])
        side_plate();
    translate([5.5, -rake_tong_l + 10, -14])
        rotate([0, 90, 0])
        t20(50);
    translate([5.5, -rake_tong_l + 10, 120])
        rotate([0, 90, 0])
        t20(50);

    translate([0, 26, 120])
        rotate([0, 90, 0])
        t20(300);
    translate([0, 26, -14])
        rotate([0, 90, 0])
        t20(300);
}
design();
