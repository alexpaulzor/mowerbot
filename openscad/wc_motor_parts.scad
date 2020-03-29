include <lib/motors.scad>;
include <lib/metric.scad>;
include <lib/casting.scad>;

hub_ir = (1 + 3/8) * IN_MM / 2;
hub_h = 48;
washer_th = 3;
hub_slice_h = 6;
num_hub_slices = hub_h/hub_slice_h;
num_ridges = 32;
face_draft = 5;
pin_or = 3/2; 
pin_h = 5;

module wheel_hub(key=false) {
    // % difference() {
    //     cylinder(r=hub_ir + 3, h=hub_h + washer_th);
    //     cylinder(r=hub_ir, h=hub_h);
    // }
    translate([0, 0, -wc_shaft_h + hub_h]) {
        // difference() {
            rotate([0, 0, -45])
                wc_motor_shaft(key=key);
        //     wc_motor_shaft_key_offset()
        //         translate([0, 10, 0]) 
        //         wc_motor_shaft_key();
        // }
    }
}   

module wc_hub_adapter(key=false) {
    
    difference() {
        translate([0, 0, hub_h/2])
        intersection() {
            rotate([0, 0, -45])
                draft_cylinder(r=hub_ir, h=hub_h, draft_angle=0, face_draft=face_draft, fn=128, center=true);
            rotate([0, 0, 180-45])
                draft_cylinder(r=hub_ir, h=hub_h - sin(face_draft) * hub_ir * sqrt(2), draft_angle=0, face_draft=face_draft, fn=128, center=true);
        }
        wheel_hub(key=key);
    }

}



module wc_hub_adapter_slice(key=false) {
    intersection() {
        wc_hub_adapter(key=key);
        cube([hub_ir, hub_ir, hub_h]);
    }
}

module wc_hub_adapter_key_slice_bottom() {
    wc_hub_adapter_slice_bottom(key=true);
}
// wc_hub_adapter_slice(true);
// % wc_hub_adapter();
module wc_hub_adapter_slice_offset() {
    translate([0, 0, -hub_ir* sqrt(2)/2])
    rotate([90, -45, 0])
    children();
}

module slice_pin() {
    for (z=[-1, 1])
        translate([0, 0, z * pin_h/2])
        sphere(r=pin_or, $fn=32);
    cylinder(r=pin_or, h=pin_h, center=true, $fn=32);
}

module slice_pins() {
    translate([0, -hub_h/2, 0])
        for (y=[-1, 1])
        translate([0, y * hub_h/3])
        slice_pin();
}

module wc_hub_adapter_slice_top() {
    difference() {
        wc_hub_adapter_slice_offset()
            wc_hub_adapter_slice();
        translate([0, -hub_h/2, -hub_ir/2])
            cube([hub_ir*2, hub_h + 1, hub_ir], center=true);
        slice_pins();
    }
}

module wc_hub_adapter_slice_bottom(key=false) {
    difference() {
        wc_hub_adapter_slice_offset()
            wc_hub_adapter_slice(key=key);
        translate([0, -hub_h/2, hub_ir/2])
            cube([hub_ir*2, hub_h + 1, hub_ir], center=true);
        slice_pins();
    }
}


plate_gap = 3;

module plate_sprues() {
    shell();
    translate([0, 0, 0]) 
        sprue_runner(h=3, l=35);
}

module cast_plate_top() {
    translate([0, -hub_h/2, 0])
        plate_sprues();
    for (p=[
            [0, hub_h/2 + 4],
            [0, -hub_h/2 - 4],
            [hub_ir * 1.5, 0],
            [-hub_ir * 1.5, 0],

        ]) {
        translate(p)
            wc_hub_adapter_slice_top();       
        
    }
}

module cast_plate_bottom() {
    translate([0, -hub_h/2, 0])
        plate_sprues();
    // for (x=[-1, 1]) 
    //     for (y=[-1, 1])
    //     translate([x * hub_ir, y * (hub_h/2 + plate_gap), 0])
    ps = [
        [0, hub_h/2 + 4],
        [0, -hub_h/2 - 4],
        [hub_ir * 1.5, 0],
        [-hub_ir * 1.5, 0],

    ];
    for (p=[0:len(ps)-1]) {
        translate(ps[p])
        rotate([0, 180, 0])
        wc_hub_adapter_slice_bottom(key=(p == 2));
    }
}

module cast_plate() {
    scale (CAST_EXPANSION/CAST_EXPANSION) {      
        translate([0, hub_h/2, 0]) {  
            cast_plate_top();     
            % rotate([0, 180, 0])
                cast_plate_bottom();
                
            translate([-3 * hub_ir, hub_h, 0])
                cast_plate_bottom();
            for (y=[-7:2]) {
                translate([45, y * (pin_h + 2*pin_or), pin_or])
                rotate([90, 0, 0])
                slice_pin();
            }
        }

        
        // for (i=[1:num_hub_slices - 1]) {
        //     // % wc_hub_adapter_slice(i * hub_slice_h, hub_slice_h);
        //     rotate([180, 0, i * 360 / (num_hub_slices - 1)]) {
        //         translate([2.7 * hub_ir, 0, -hub_slice_h -i * hub_slice_h + washer_th/2 - washer_th / sqrt(2)/2])
        //             wc_hub_adapter_slice(i * hub_slice_h, hub_slice_h);
        //     }
        //     // rotate([0, 0, i * 360 / (num_hub_slices - 1)]) {
        //     //     translate([2.7 * hub_ir/2, 0, 0])
        //     //     sprue_runner(l=14);
        //     // }
        // }
        // difference() {
        //     draft_cylinder(r=70, h=4, draft_angle=10);
        //     translate([0, 0, -1])
        //     draft_cylinder(r=64, h=6, draft_angle=-10);
        // }
    }
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

// crucible();
rotate([0, 0, 45])
small_flask();
cast_plate();
// flask();

