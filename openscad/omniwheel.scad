include <lib/salvaged_parts.scad>;
include <lib/metric.scad>;
include <lib/casting.scad>;
include <lib/motors.scad>;
include <lib/roller_chain.scad>;

bearing_h = 7;
bearing_ir = 4;
bearing_or = 11;

// po_or = 120;
po_hub_or = 80; //po_or - platter_or + platter_ir;
po_num_slots = 16;
po_spacer_num_holes = 6;
po_hub_h = 20;
//$fn = 60;
po_hole_or = 4 / 2;
po_axle_or = 3 / 32 * IN_MM / 2;
po_axle_l = 20;
po_axle_offset = 4;

po_spacer_h = 6;
po_slot_length = platter_or + 2;
po_spacer_or = platter_ir + platter_h;
draft_angle = 2;
have_stl = true;
nudge = 1;

module cast_po_hub(draft_angle=draft_angle) {
    da = 360 / po_num_slots;
    difference() {
        for (i=[0:po_num_slots-1])
            rotate([0, 90, i*da])
            cylinder(r=po_hub_h/2, h=po_hub_or);
        for (i=[0:po_num_slots-1])
            rotate([0, 0, (i+0.5)*da])
            translate([po_hub_or - po_axle_offset, 0, 0]) 
            po_disc(draft_angle=draft_angle);
        for (i=[0:po_num_slots-1])
            rotate([0, 0, i*da])
            translate([po_hub_or - 2 * po_axle_offset, 0, 0])
            draft_cylinder(r=po_hole_or, h=po_hub_h/2, invert=false, draft_angle=-draft_angle);
        translate([0, 0, -po_hub_h/2])
            cylinder(r=po_hub_or+5, h=po_hub_h/2);
        translate([0, 0, po_hub_h/2 - bearing_h/2]) {
            % bearing();
            draft_cylinder(r=bearing_or, h=bearing_h, draft_angle=-draft_angle/2, center=true, invert=false);
        }
        draft_cylinder(r=9 / 2, h=po_hub_h/2, center=false, draft_angle=-draft_angle, invert=false);
        
    }
    
}



module po_hub(use_stl=false) {
    if (use_stl) {
        import("stl/po_hub.omniwheel.stl");
    } else {
        cast_po_hub(draft_angle);
    }
}

module offset_po_slot(po_num_slots=po_num_slots, dr=0) {
    roller_angle = 360 / po_num_slots;
    for(j=[1:po_num_slots])
        rotate([0,0,j*roller_angle])
        translate([po_hub_or - 6 + dr, 0, 0])
        children();
}

module po_spacer(use_stl=false) {
    if (use_stl) {
        import("stl/po_spacer.omniwheel.stl");
    } else {
        hole_angle = 360 / po_spacer_num_holes;
        difference() {
            union() {
                translate([0, 0, -po_spacer_h/2])
                    cylinder(r=platter_ir, h=po_spacer_h/2+platter_h/2);
                translate([0, 0, -po_spacer_h/2]) 
                    cylinder(r=po_spacer_or, h=po_spacer_h/2);
            }   
            platter();
            
            cylinder(r=po_axle_or, h=po_spacer_h, center=true);

            for(j=[1:po_spacer_num_holes]) {
                rotate([0,0,j*hole_angle])
                translate([0, 0, -platter_h/2 ]) 
                linear_extrude(po_spacer_h/2 + platter_h/2) {
                    polygon(
                        points=[
                            [0,0],
                            [po_spacer_or,0],
                            [po_spacer_or * sin(hole_angle), po_spacer_or * cos(hole_angle)]
                        ], 
                        paths=[[0,1,2]]);
                }
            }
        }
    }
}

module po_roller() {
    % po_spacer(have_stl);
    // translate([0, 0, 0]) 
    //    rotate([0, 180, 360 / po_spacer_num_holes]) po_spacer();
    // platter();
    cylinder(r=po_axle_or, h=po_axle_l, center=true);
}

module po_disc(hub_h=po_hub_h, draft_angle=draft_angle) {
    rotate([90, 0, 0]) {
       po_roller();
    }
    translate([0, 0, hub_h/4])
        draft_cube([po_slot_length*2, platter_h + 1, hub_h/2], center=true, draft_angle=-2*draft_angle, invert=false);
    translate([0, 0, hub_h/4])
        draft_cube([po_spacer_or*2, po_spacer_h + 1, hub_h/2], center=true, draft_angle=-draft_angle, invert=false);
}

module plate() {
     rotate([180, 0, 0])
     po_hub(have_stl);
     translate([0, 0, -platter_h/2])
     rotate([0, 0, 360 / po_num_slots/2])
     offset_po_slot(po_num_slots/2, 20)
        po_spacer(have_stl);
    
}
module po_grid() {
    
    translate([-5*(po_spacer_or + nudge), -5*(po_spacer_or + nudge), 0])
    for (i=[0:5]) {
        for (j=[0:5]) {
            translate([i*2*(po_spacer_or + nudge), j*2*(po_spacer_or + nudge), 0])
            po_spacer(true);
        }
    }
}

module sprue2() {
    sprue_th = 2;
    sprue_w = 4;
   #  for (i=[-3:2]) {
        translate([0, po_spacer_or/2 + i*2*(po_spacer_or + nudge), -po_spacer_h/2 + sprue_th/2])
            draft_cube([12 * po_spacer_or, sprue_w, sprue_th], center=true);
        translate([po_spacer_or/2 + i*2*(po_spacer_or + nudge), 0, -po_spacer_h/2 + sprue_th/2])
            draft_cube([sprue_w, 12 * po_spacer_or, sprue_th], center=true);
        
    }
}

module grid_plate() {
 scale(CAST_EXPANSION) {
     po_grid();
     sprue2();
     // *for (i=[0:16]) {
     //    rotate([0, 0, 360/16*i])
     //    translate([100, 0, po_spacer_h/2])
     //    po_spacer(true);

     }
 }

 module cast_plate3() {
 scale(CAST_EXPANSION) {
     po_hub(true);  
     // *for (i=[0:16]) {
     //    rotate([0, 0, 360/16*i])
     //    translate([100, 0, po_spacer_h/2])
     //    po_spacer(true);

     }
 } 

// % flask();
// grid_plate();
// cast_plate3();

// bldc2_wheel_or = 250 / 2;
// bldc2_wheel_num_nubs = 16;
// // bldc2_wheel_nub_r = (bldc2_wheel_or - bldc2_od/2)/8;
// bldc2_wheel_nub_r = bldc2_hub_h/2;
// // bldc2_wheel_num_nubs = floor((bldc2_wheel_or + bldc2_od/2)/2 * PI / bldc2_wheel_nub_r)-1;
// // bldc2_wheel_num_nubs = floor(bldc2_wheel_or * PI / bldc2_wheel_nub_r)-1;

tread_w = 35;
tread_th = 3;
tread_pitch = 8;
tread_depth = 3;

bldc2_tread_teeth = ceil(bldc2_rim_od * PI / tread_pitch);
bldc2_tread_ir = bldc2_tread_teeth * tread_pitch / PI / 2 - tread_th;

echo(bldc2_tread_teeth=bldc2_tread_teeth);

module tread(teeth=2, curve=0) {
    translate([0, -tread_w/2, -tread_th])
        cube([tread_pitch, tread_w, tread_th]);
    
    translate([tread_pitch/2, 0, tread_depth - tread_pitch/4])
        rotate([90, 0, 0])
        cylinder(r=tread_pitch/4, h=tread_w, center=true, $fn=12);
    translate([tread_pitch/2, 0, tread_depth/4])
        cube([tread_pitch/2, tread_w, tread_depth/2], center=true);
    if (teeth > 1) {
        curve_angle = curve / teeth;
        translate([tread_pitch, 0, 0])
        rotate([0, curve_angle, 0])
        tread(teeth=teeth-1, curve=curve - curve_angle);
    }
}

module bldc2_tread() {
    difference() {
        draft_cylinder(r=bldc2_rim_od/2, h=bldc2_hub_h, center=true, fn=256, draft_angle=0.5);
        cylinder(r=bldc2_od/2, h=bldc2_hub_h+1, center=true, $fn=256);
        difference() {
            cylinder(r=bldc2_rim_od/2 + tread_depth, h=tread_w, center=true);
            draft_cylinder(r=bldc2_rim_od/2 - tread_th, h=tread_w, center=true, fn=256, draft_angle=0.5);
        }
        n_holes = 20;
        for (i=[0:n_holes/2]) {
            rotate([90, 0, i * 360/n_holes])
            cylinder(r=2, h=bldc2_rim_od, center=true, $fn=12);
        }
    }
    *% translate([0, -bldc2_tread_ir - tread_th, 0])
        rotate([90, 0, 0])
        tread(teeth=bldc2_tread_teeth/2, curve=180);
    *%bldc2_hub();
}
module bldc2_tread_half() {
    intersection() {
        bldc2_tread();
        translate([0, 0, -bldc2_hub_h/4])
            cube([bldc2_rim_od, bldc2_rim_od, bldc2_hub_h/2], center=true);
    }
}
bldc2_tread_half();

// bldc2_adapter_th = 5;
// bldc2_adapter_num_holes = 12;
// bldc2_adapter_hole_or = 3;
// bldc2_adapter_or = bldc2_rim_od/2 + bldc2_adapter_th * 3 + 2 * bldc2_adapter_hole_or;
// bldc_adapter_h = max(tread_w, bldc2_hub_h) + 2 * bldc2_adapter_th;
// min_draft_angle = 2; // 2;
// max_draft_angle = 5;

// module draft_peg(r=5/2, h=10, draft_angle=30) {
//     translate([0, 0, -h/2])
//         draft_cylinder(r=r, h=h/2, center=false, draft_angle=draft_angle, invert=true);
    
//         draft_cylinder(r=r, h=h/2, center=false, draft_angle=draft_angle);
// }

// module bldc2_adapter_holes() {
//     rotate([0, 0, 360/bldc2_adapter_num_holes/2])
//     for (i=[0:bldc2_adapter_num_holes])
//         rotate([0, 0, i*360/bldc2_adapter_num_holes])
//         translate([bldc2_adapter_or - 2 * bldc2_adapter_hole_or, 0, bldc2_adapter_th])
//         draft_peg();
//         // draft_cylinder(r=bldc2_adapter_hole_or, h=4*bldc2_adapter_th, center=true, invert=true, draft_angle=max_draft_angle);
// }
// module bldc2_adapter(holes=true, use_stl=false) {
//     if (use_stl) {
//         import("stl/bldc2_adapter.omniwheel.stl");
//     } else {
//         _bldc2_adapter(holes=holes);
//     }
// }
// ! _bldc2_adapter();
// module _bldc2_adapter(holes=true) {
//     zratio = 1; //LINK_PIN_W / (IN_MM * get_thickness(CHAIN_SIZE));
//     chain_pitch = 0.5 * IN_MM;
//     num_teeth = ceil(bldc2_adapter_or * 2 * PI / chain_pitch) + 2;
//     echo(num_teeth=num_teeth);
//     // % bldc2_hub();
//     difference() {
//         union() {
//             draft_cylinder(r=bldc2_od/2 + 2*bldc2_adapter_th, h=bldc2_hub_h, draft_angle=max_draft_angle);
//             draft_cylinder(r=bldc2_adapter_or, h=bldc2_adapter_th, draft_angle=max_draft_angle);
//             cylinder(r=bldc2_od/2 + 3*bldc2_adapter_th, h=bldc2_adapter_th*2);
            
//             sprocket(size=CHAIN_SIZE, teeth=num_teeth, bore=bldc2_adapter_or * 2 / IN_MM, hub_diameter=0 / IN_MM, hub_height=hub_h / IN_MM / zratio);
//         }
//         // if (holes)
//         //     cylinder(r=bldc2_od/2, h=bldc2_hub_h+1, $fn=128);
//         translate([0, 0, bldc2_adapter_th*2])
//             rotate_extrude()
//             translate([bldc2_od/2 + 3*bldc2_adapter_th - 0.5, 0, 0])
//             circle(r=bldc2_adapter_th);
//         if (holes) {
//             bldc2_adapter_holes();
//             # draft_cylinder(r=bldc2_od/2, h=bldc2_hub_h+1, draft_angle=-min_draft_angle, invert=false);
//         }
//     }
// }

// // module bldc2_wheel_rim() {
// //     difference() {
// //         draft_cylinder(r=bldc2_wheel_or - tread_th, h=tread_w/2+bldc2_adapter_th, draft_angle=min_draft_angle);
// //         draft_cylinder(r=bldc2_wheel_or - bldc2_adapter_th, h=tread_w+2*bldc2_adapter_th+1, draft_angle=-min_draft_angle);
        
// //     }
// //     difference() {
// //         union() {
// //             draft_cylinder(r=bldc2_wheel_or- tread_th, h=2*bldc2_adapter_th);
// //             draft_cylinder(r=bldc2_wheel_or, h=(bldc_adapter_h-tread_w)/2, draft_angle=max_draft_angle);
// //         }
// //         translate([0, 0, bldc2_adapter_th*2])
// //             rotate_extrude()
// //             translate([bldc2_wheel_or - 2*bldc2_adapter_th, 0, 0])
// //             circle(r=bldc2_adapter_th);
// //         cylinder(r=bldc2_wheel_or - 2*bldc2_adapter_th, h=3*bldc2_adapter_th+1);
// //     }
// //     difference() {
// //         draft_cylinder(r=bldc2_wheel_or, h=bldc2_adapter_th, draft_angle=max_draft_angle);
// //         draft_cylinder(r=bldc2_rim_od/2+1, h=bldc2_adapter_th, draft_angle=-max_draft_angle);
// //         bldc2_adapter_holes();
// //     }
// // }

// // module bldc2_wheel_rim_slice(use_stl=false) {
// //     if (use_stl) {
// //         import("stl/bldc2_wheel_rim_slice.omniwheel.stl");
// //     } else {
// //         _bldc2_wheel_rim_slice();
// //     }
// // }

// // module _bldc2_wheel_rim_slice() {
// //     deg_per_pitch = 360 * tread_pitch / ((bldc2_wheel_or - tread_th) * 2 * PI);
// //     difference() {
// //         intersection() {
// //             bldc2_wheel_rim();
// //             # draft_cube([bldc2_wheel_or, bldc2_wheel_or, bldc2_hub_h], draft_angle=max_draft_angle);
// //         }
// //         translate([0, 0, bldc2_hub_h/2 + bldc2_adapter_th])
// //         for (i=[0, 45, 90]) {
// //             rotate([0, 0, i - deg_per_pitch])
// //                 draft_cube([bldc2_wheel_or*2, tread_th, tread_w], center=true, draft_angle=-min_draft_angle);
// //             rotate([0, 0, i + deg_per_pitch])
// //                 draft_cube([bldc2_wheel_or*2, tread_th, tread_w], center=true, draft_angle=-min_draft_angle);
// //         }
// //     }
// // }

// // // ! bldc2_wheel_rim_slice();
// // module bldc2_wheel() {
// //     // translate([0, 0, bldc2_hub_h/2])
// //         % bldc2_hub();  
// //     translate([0, 0, bldc2_hub_h/2])
// //         rotate([0, 180, 0])
// //         bldc2_adapter(use_stl=true);
// //     translate([0, 0, -bldc2_hub_h/2])
// //         bldc2_adapter(use_stl=true);
// //     // rotate([180, 0, 0])
// //     //     bldc2_adapter();
// //     for (i=[0, 90, 180, 270])
// //     rotate([0, 0, i]) {
// //         translate([0, 0, -bldc2_adapter_th-bldc2_hub_h/2])
// //             bldc2_wheel_rim_slice(use_stl=true);
// //         translate([0, 0, bldc2_hub_h/2])
// //             rotate([0, 180, -90])
// //             bldc2_wheel_rim_slice(use_stl=true);
// //     }
// // }

// module bldc2_adapter_cast_plate() {
//     scale(CAST_EXPANSION) {
//         bldc2_adapter(use_stl=true); 
//     }
//     % big_flask();   
// }

// module bldc2_rim_cast_plate() {
//     scale(CAST_EXPANSION) {
//         for (i=[1/3, 2/3])
//             translate([-i*bldc2_wheel_or, -i*bldc2_wheel_or, 0])
//             bldc2_wheel_rim_slice(use_stl=true);
//     }
//     * % flask();
// }

// bldc2_adapter_cast_plate();
// // bldc2_rim_cast_plate();
