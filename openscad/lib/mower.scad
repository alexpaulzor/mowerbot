
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

// dc_mower
dc_m_h = 81;
dc_m_or = 51/2;
dc_m_shaft_h = 110;
dc_m_shaft_or = 5/2;
dc_m_neck_h = 87;
dc_m_neck_or = 22/2;
dc_m_threads_h = 16;
module dc_mower() {
    translate([0, 0, -dc_m_shaft_h + dc_m_threads_h]) {
        cylinder(r=dc_m_or, h=dc_m_h);
        cylinder(r=dc_m_shaft_or, h=dc_m_shaft_h);
        % cylinder(r=dc_m_shaft_or + 0.5, h=dc_m_shaft_h-dc_m_threads_h);
        cylinder(r=dc_m_neck_or, h=dc_m_neck_h);
    }
}

// cutting head
ch_or = 92/2;
ch_h = 15;
ch_hub_h = 49;
ch_hub_or = 35/2;
ch_hub_ir = 10.3/2;
ch_hub_hex_ir = 16/2;
ch_top_h = 5;
ch_num_strings = 3;
ch_string_offset = 19;
ch_string_or = 0.095*IN_MM/2;
ch_mower_or = 230;


module cutting_head() {
    difference() {
        union() {
            color("black")
                cylinder(r=ch_or, h=ch_h);
            color("black")
                cylinder(r=ch_hub_or, h=ch_hub_h);
            color("blue")
                translate([0, 0, ch_string_offset])
                for (i=[0:ch_num_strings])
                for (di=[-10, 10])
                rotate([0, 90, 360/ch_num_strings*i+di])
                cylinder(r=ch_string_or, h=ch_mower_or);
            
        }
        
        cylinder(r=ch_hub_ir, h=ch_hub_h);
        cylinder(r=ch_hub_hex_ir, h=ch_hub_h - ch_top_h, $fn=6);
    }
}
