include <lib/salvaged_parts.scad>;
include <lib/metric.scad>;
include <lib/casting.scad>;

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
grid_plate();
// cast_plate3();