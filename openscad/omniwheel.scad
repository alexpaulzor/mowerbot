use <purchased_electrics.scad>;

$fn = 30;
bearing_h = 7;
bearing_ir = 4;
bearing_or = 11;

hub_h = 10;
hub_ir = 2;
hub_or = 70;
roller_h = 5;
roller_ir = 2;
roller_or = 25;
roller_axle_or = 2;
roller_axle_l = 2;
roller_axle_head_or = 2 * roller_axle_or;
roller_axle_head_h = 2 * roller_axle_or;
roller_clearance = 12;
slot_clearance = 2;

num_rollers = 10;
roller_angle = 360 / num_rollers;
slot_offset = hub_or - roller_or - roller_clearance;
slot_width = roller_h + slot_clearance;

optical_slot_clearance = 5;
num_optical_slots = num_rollers * 2;
optical_slot_angle = 360 / num_optical_slots;
optical_slot_offset = bearing_or + optical_slot_clearance;
optical_slot_length = slot_offset - optical_slot_offset - optical_slot_clearance;
optical_slot_width = 2;

module slot() {
    translate([slot_offset, -slot_width/2, 0]) 
        cube([roller_or + roller_clearance, 
              slot_width,
              hub_h]);
    translate([hub_or - roller_axle_or / 2 - roller_clearance / 2,
               roller_axle_l + slot_width / 2,
               hub_h / 2])
        rotate([90, 0, 0]) {
            cylinder(h=slot_width + 2 * roller_axle_l, r=roller_axle_or);
            translate([0, 0, -roller_axle_l - roller_axle_head_h + slot_clearance/2])
                cylinder(h=roller_axle_head_h + slot_clearance/2, r=roller_axle_head_or);
            translate([0, 0, 2 * roller_axle_l + slot_width])
                cylinder(h=roller_axle_head_h + slot_clearance/2, r=roller_axle_head_or);
        }
    % translate([hub_or - roller_axle_or / 2 - roller_clearance / 2,
               roller_h / 2,
               hub_h / 2])
               roller();   
}

module optical_slot(depth=hub_h) {
    translate([optical_slot_offset, -optical_slot_width/2, 0]) 
        cube([optical_slot_length, 
              optical_slot_width,
              depth]);
}

module roller_disc() {
    difference() {
        cylinder(h=roller_h, r=roller_or);
        cylinder(h=roller_h, r=roller_axle_or);
    }
}

module roller() {
    rotate([90, 0, 0])
    roller_disc();
}

module hub() {
    difference() {
        cylinder(h=hub_h/2, r=hub_or);
        for(j=[1:num_rollers])  {
            rotate([0,0,j*roller_angle]) {
                slot();
                * if (j % 2 == 0)
                    translate([2 * slot_offset / 3, 0, 0])
                        cylinder(h=hub_h, r=hub_ir);
            }
            rotate([0,0,(j + 0.5)*roller_angle])
                translate([4 * hub_or / 5, 0, 0])
                        cylinder(h=hub_h * 2, r=hub_ir);
                
        }
        translate([0, 0, (hub_h - bearing_h)/2])
            cylinder(h=hub_h, r=bearing_or, $fn=60);
        cylinder(h=hub_h, r=bearing_ir);
        
        for(j=[1:num_optical_slots])  {
            rotate([0,0,j*optical_slot_angle]) {
                optical_slot();
            }                
        }
    }
}

sens_holder_wall_th = 2;
sens_holder_tighten_ir = 3/2;
sens_holder_h = optical_slot_offset + bearing_ir + optical_slot_length + 2 * sens_holder_wall_th;
ir_sens_holder_w = 20;
ir_sens_holder_l = 24;

module ir_sens_holder() {
    difference() {
        translate([0, 0, optical_slot_offset/2 + optical_slot_length/2 - sens_holder_wall_th])
            cube([ir_sens_holder_l, ir_sens_holder_w, sens_holder_h], center=true);
        for (i=[0:3:12]) {
            translate([-i, 0, optical_slot_offset])
                ir_sensor();
        }
        rotate([0, 90, 0]) {
            cylinder(r=bearing_ir, h=ir_sens_holder_l+1, center=true);
            % translate([0, 0, ir_sens_holder_l/2]) hub();
            # rotate([0, 0, 180]) optical_slot(ir_sens_holder_l);
        }
            
        translate([0, 0, bearing_ir * 1.5])
            cube([ir_sens_holder_l, sens_holder_wall_th, bearing_ir * 3], center=true);
        translate([0, -ir_sens_holder_w/2  + sens_holder_wall_th/2, bearing_ir * 3])
            cube([ir_sens_holder_l, ir_sens_holder_w, sens_holder_wall_th], center=true);
        translate([0, 0, bearing_ir * 2])
            rotate([90, 0, 0])
            cylinder(r=sens_holder_tighten_ir, h=ir_sens_holder_w, center=true);
    }

}

* ir_sens_holder();

ir_emit_holder_w = 20;
ir_emit_holder_l = 24;

module ir_emit_holder() {
    difference() {
        translate([0, 0, optical_slot_offset/2 + optical_slot_length/2 - sens_holder_wall_th])
            cube([ir_emit_holder_l, ir_emit_holder_w, sens_holder_h], center=true);
        for (i=[0:3:12]) {
            # translate([-i, 0, optical_slot_offset + optical_slot_length / 2])
                ir_emit();
        }
        rotate([0, 90, 0]) {
            cylinder(r=bearing_ir, h=ir_emit_holder_l+1, center=true);
            % translate([0, 0, ir_emit_holder_l/2]) 
                hub();
            rotate([0, 0, 180]) 
                optical_slot(ir_emit_holder_l);
        }
        translate([0, 0, bearing_ir * 1.5])
            cube([ir_emit_holder_l, sens_holder_wall_th, bearing_ir * 3], center=true);
        translate([0, -ir_emit_holder_w/2  + sens_holder_wall_th/2, bearing_ir * 3])
            cube([ir_emit_holder_l, ir_emit_holder_w, sens_holder_wall_th], center=true);
        translate([0, 0, bearing_ir * 2])
            rotate([90, 0, 0])
            cylinder(r=sens_holder_tighten_ir, h=ir_emit_holder_w, center=true);
    }

}

ir_emit_holder();

module plate() {
    hub();
    translate([2 * hub_or + roller_clearance, 0, 0])
        hub();
    * for(i=[0:4]) {
        for (j=[0:1]) {
            translate([-hub_or + roller_or + i * (2 * roller_or + roller_clearance/2), 
                    hub_or + roller_or + roller_clearance/2 + j * (2 * roller_or + roller_clearance / 2), 0])
                roller_disc();
        }   
        }
}