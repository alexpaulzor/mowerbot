include <lib/roller_chain.scad>;
include <lib/motion_hardware.scad>;
include <lib/motors.scad>;
include <lib/casting.scad>;

module drive_arm() {
    difference() {
        translate([-arm_drive_offs, -arm_w/2, 0])
            cube([arm_l, arm_w, arm_h]);
        translate([arm_clear_r, -arm_w/2, 0])
            cube([arm_l-arm_clear_r, arm_w, arm_clear_h]);
        translate([-arm_drive_offs, -arm_w/2, arm_h - arm_clear_h])
            cube([arm_clear_r + arm_drive_offs, arm_w, arm_clear_h]);
        translate([0, 0, arm_h/2])
            cylinder(r=arm_hole_ir, h=arm_h*2, center=true);
        translate([arm_r, 0, arm_h/2])
            cylinder(r=arm_hole_ir, h=arm_h*2, center=true);
    }
}

module driven_sprocket(bore, hub_d, hub_h) {  // #!AUTOSTL
    zratio = LINK_PIN_W / (IN_MM * get_thickness(CHAIN_SIZE));
    difference() {
        scale([1, 1, zratio])
            sprocket(size=CHAIN_SIZE, teeth=DRIVE_TEETH, bore=bore/ IN_MM, hub_diameter=hub_d / IN_MM, hub_height=hub_h / IN_MM / zratio);
        for(j=[0:num_holes])  {
            rotate([0,0,j*360 / num_holes])
                translate([arm_r, 0, 0]) {
                    cylinder(h=hub_h*2, r=arm_hole_ir);
                }
        }
    }
}

module drive_sprocket(use_stl=false) {  // #!AUTOSTL
    if (use_stl) {
        import("drive_sprocket.stl");
    } else {
        translate([0, 0, -ROLLER_W / 2]) {
            difference() {
                driven_sprocket(DRIVE_BORE, (arm_l - arm_drive_offs) * 2, hub_h);
                
                translate([0, 0, LINK_PIN_W])
                    cylinder(r=arm_clear_r, h=arm_h);
            }
        }
    }
}

module idle_drive_sprocket(use_stl=false) {  // #!AUTOSTL
    if (use_stl) {
        import("idle_drive_sprocket.stl");
    } else {
        translate([0, 0, -ROLLER_W / 2]) {
            difference() {
                driven_sprocket(bearing_ir*2, (bearing_or*2 + 2*wall_th), bearing_h);
                
                translate([0, 0, bearing_h/2]) bearing();
            }
        }
    }
}


module small_drive_sprocket(use_stl=false) {  // #!AUTOSTL
    zratio = LINK_PIN_W / (IN_MM * get_thickness(CHAIN_SIZE));
    hole_offs = (IDLER_PITCH_OR - ROLLER_OR + bearing_or) / 2;
    if (use_stl) {
        import("small_drive_sprocket.stl");
    } else {
        difference() {
            sprocket(size=CHAIN_SIZE, teeth=IDLER_TEETH, bore=0, hub_diameter=(bearing_or*2 + 2*wall_th) / IN_MM, hub_height=(bearing_h)/IN_MM / zratio);
            translate([0, 0, -1])
                drive_pulley_40t(0, LINK_PIN_W + 2);
                //import("stl/drive_pulley_40t.chain_drive.stl");
            for(j=[0:num_holes])  {
                rotate([0,0,j*360 / num_holes])
                    translate([hole_offs, 0, 0])
                        cylinder(h=hub_h*2, r=arm_hole_ir);
            }
        }
    }
}

module idler_sprocket(use_stl=false) {  // #!AUTOSTL
    if (use_stl) {
        import("idler_sprocket.stl");
    } else {
        zratio = LINK_PIN_W / (IN_MM * get_thickness(CHAIN_SIZE));
        hole_offs = (IDLER_PITCH_OR - ROLLER_OR + bearing_or) / 2;
        translate([0, 0, -ROLLER_W / 2])
        difference() {
            scale([1, 1, zratio]) {
                sprocket(size=CHAIN_SIZE, teeth=IDLER_TEETH, bore=bearing_ir*2/IN_MM, hub_diameter=(bearing_or*2 + 2*wall_th) / IN_MM, hub_height=(bearing_h)/IN_MM / zratio);
            }
            for(j=[0:num_holes])  {
                rotate([0,0,j*360 / num_holes])
                    translate([hole_offs, 0, 0])
                        cylinder(h=hub_h*2, r=arm_hole_ir);
            }
            # translate([0, 0, bearing_h/2]) bearing();
        }
    }
}

module idle_sprocket_spacer() {
    gap = CHAIN_GAP + bearing_h;
    difference() {
        cylinder(r=bearing_ir + wall_th/2, h=gap);
        cylinder(r=bearing_ir, h=gap);
    }
}

module link_clip(use_stl=false) {  // #!AUTOSTL
    if (use_stl) {
        import("link_clip.stl");
    } else {
        link_or = (LINK_L - CHAIN_PITCH) / 2;
        difference() {
            union() {
                for (i=[0:CHAIN_STRANDS - 1]) {
                    translate([pad_th / 2 - (LINK_H + pad_th * 2) / 2, CHAIN_PITCH/2 - pad_l /2, -(LINK_LARGE_W + 2 * wall_th)/2 + i * (LINK_LARGE_W + CHAIN_GAP)])
                        cube([LINK_H + pad_th * 2, pad_l, LINK_LARGE_W + 2 * wall_th]);
                    if (i > 0)
                        translate([LINK_H/2 + wall_th, CHAIN_PITCH / 2, LINK_LARGE_W / 2 + CHAIN_GAP/2])
                            rotate([0, 0, 45])
                            cube([LINK_H, LINK_H, pad_w], center=true);
                }
                translate([LINK_H/2 + pad_th / 2, CHAIN_PITCH/2 - pad_l / 2, -LINK_LARGE_W / 2 - wall_th])
                    cube([pad_th, pad_l, pad_w]);
                    
            }
            // translate([LINK_H/2 + 3*pad_th / 2, CHAIN_PITCH/2 - pad_l / 2, 0])
             //       cube([pad_th, pad_l, pad_w]);
            for (i=[0:CHAIN_STRANDS - 1]) {
                translate([0, 0, i * (CHAIN_GAP + LINK_LARGE_W)]) {
                    translate([0, 0, -LINK_LARGE_W/2])
                        chain_link_wall(LINK_LARGE_W);
                    gap_w = LINK_SMALL_W;  
                    translate([-LINK_H/2, 0, -gap_w/2])
                        chain_link_wall(gap_w);
                    large_link();
                    link_pins(LINK_LARGE_W);
                }
            }
       }
   }
}

module bearing_spacer() {
    difference() {
        cylinder(r=bearing_ir, h=bearing_h, center=true);
        cylinder(r=arm_hole_ir, h=bearing_h, center=true);
    }
}


module design_chain_drive() {   
   
    * translate([-DRIVE_PITCH_OR, 0, 0])
        rotate([0, 0, 180 + DRIVE_TEETH_DEG / 2])
        chain(floor(DRIVE_TEETH / 2), DRIVE_TEETH_DEG);
    
    * translate([-DRIVE_PITCH_OR, 0, 0])
        rotate([0, 0, -spread_angle])
        mirror([1, 0, 0])
        chain(axle_spread_links, offs=5);
    
    * translate([DRIVE_PITCH_OR, 0, 0])
        rotate([0, 0, spread_angle])
        chain(axle_spread_links, offs=3);
    
    * translate([IDLER_PITCH_OR, axle_spread, 0])
        rotate([0, 0, IDLER_TEETH_DEG / 2])
        chain(floor(IDLER_TEETH / 2), IDLER_TEETH_DEG, offs=2);
    * translate([0, axle_spread])
        idler_sprocket();
    * drive_sprocket();
    * translate([0, 0, LINK_LARGE_W + CHAIN_GAP])
        idle_drive_sprocket();
    * translate([0, 0, LINK_LARGE_W + CHAIN_GAP])
        idler_sprocket();
    * idler_sprocket();
    * translate([0, 0, bearing_h/2])
        idle_sprocket_spacer();
}

bldc_teeth = 40;
hs_sprocket_teeth = 8;
hs_hub_od = 20;
hs_hub_h = 20;

drive_ratio = bldc_teeth / hs_sprocket_teeth; 
hs_axle_od = 6;
bldc_max_rpm = 990;
hs_max_rpm = bldc_max_rpm * bldc_teeth / hs_sprocket_teeth;
bldc_hole_or = 3/32 * IN_MM / 2;
echo("bldc: ", bldc_teeth, ":", hs_sprocket_teeth,  " (", drive_ratio, ") ", hs_max_rpm, " rpm");

module bldc_sprocket(use_stl=false) {
    if (use_stl) {
        import("stl/bldc_sprocket.roller_chain_parts.stl");
    } else {
        difference() {
            sprocket(size=CHAIN_SIZE, teeth=bldc_teeth, bore=bldc_od/IN_MM);
            bldc_holes();
        }
    }
}

module hs_sprocket(use_stl=false) {
    if (use_stl) {
        import("stl/hs_sprocket.roller_chain_parts.stl");
    } else {
        difference() {
            union() {
                sprocket(size=CHAIN_SIZE, teeth=hs_sprocket_teeth, bore=(hs_axle_od-2)/IN_MM, hub_diameter=0*hs_hub_od/IN_MM, hub_height=0*hs_hub_h/IN_MM);
                // # draft_cylinder(r=hs_hub_od/2, h=hs_hub_h, draft_angle=2);
            }
            # hs_sprocket_holes();
            
            translate([0, 0, hs_hub_h/2])
            rotate([180, 0, 0])
            draft_cylinder(r=hs_axle_od/2, h=hs_hub_h, draft_angle=2, center=true);
        }
    }
}

module hs_sprocket_holes() {
    hs_sprocket_num_holes = floor(hs_sprocket_teeth / 2);
    hs_sprocket_hole_angle = 360 / hs_sprocket_num_holes;
    
    for (i=[0:hs_sprocket_num_holes-1]) {
        rotate([0, 0, i*hs_sprocket_hole_angle])
        translate([hs_axle_od, 0, 0])
        cylinder(r=bldc_hole_or, h=bldc_hub_h, center=true);
    }
}  

module bldc_holes() {
    bldc_num_holes = floor(bldc_teeth / 4);
    bldc_hole_angle = 360 / bldc_num_holes;
    
    for (i=[0:bldc_num_holes-1]) {
        rotate([0, 0, i*bldc_hole_angle])
        translate([bldc_od/2 + 3, 0, 0])
        cylinder(r=bldc_hole_or, h=bldc_hub_h, center=true);
    }
}  

module bldc_sleeve() {
    gear_h = IN_MM * get_thickness(CHAIN_SIZE);
    difference() {
        cylinder(r=bldc_rim_od/2, h=(bldc_hub_h-gear_h)/2, center=true, $fn=90);
        cylinder(r=bldc_od/2, h=(bldc_hub_h-gear_h)/2, center=true, $fn=90);
        # bldc_holes();
    }
}

module bldc_design() {
    gear_h = IN_MM * get_thickness(CHAIN_SIZE);
    translate([0, 0, -gear_h/2])
        bldc_sprocket(false);
    translate([100, 100, 0])
        hs_sprocket(false);
    *% bldc_hub();
    *for (i=[-1,1])
        translate([0, 0, i*(gear_h/2 + (bldc_hub_h-gear_h)/4)])
        bldc_sleeve();
        
}

bldc_design();

