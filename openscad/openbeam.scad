include <constants.scad>;
use <motion_hardware.scad>;
use <metric_hardware.scad>;
IN_MM = 25.4;
$fn = 32;

wall_th = 4;

BEAM_W = 15;
bracket_th = 1.5;
beam_notch_d = 5;
beam_notch_w = 3;
beam_hole_or = 3/2;

module beam(length=50) {
    translate([0, 0, -length/2])
    linear_extrude(length) {
        difference() {
            square([BEAM_W, BEAM_W], center=true);
            for (i=[0:3]) {
                rotate([0, 0, 90 * i]) {
                    translate([BEAM_W/2 - beam_notch_d / 2, 0, 0]) {
                        square([beam_notch_d, beam_notch_w], center=true);
                    }
                }
            }
            //circle(r=beam_hole_or);
        }
    }
}

module beam_hole(length) {
    beam(length);
    cube([BEAM_W - 2, BEAM_W - 2, length+1], center=true);
}

module tee_bracket() {
    difference() {
        union() {
            translate([0, BEAM_W, 0]) 
                cube([BEAM_W, 3 * BEAM_W, bracket_th], center=true);
            translate([0, 0, 0]) 
                cube([3 * BEAM_W, BEAM_W, bracket_th], center=true);
        }
        for (xi=[-1, 0, 1]) {
            translate([xi * BEAM_W, 0, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
            translate([0, (xi+1) * BEAM_W, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
        }
    }
}

module mount_block(ir) {
    block_outside = 2*ir + 2 * wall_th;
    difference() {
        union() {
            translate([0, 0, wall_th/2])
                cube([3 * BEAM_W, BEAM_W, wall_th], center=true);
            translate([0, 0, block_outside/4])
                cube([block_outside, BEAM_W, block_outside/2], center=true);
            translate([0, 0, ir + wall_th])
                rotate([90, 0, 0]) 
                cylinder(r=block_outside/2, h=BEAM_W, center=true);
            * translate([ir + wall_th, 0, sqrt(2)/4*block_brace_w + wall_th/2])
                rotate([0, 45, 0])
                cube([block_brace_w, BEAM_W, block_brace_w/2], center=true);
            * translate([-ir - wall_th, 0, sqrt(2)/4*block_brace_w + wall_th/2])
                rotate([0, -45, 0])
                cube([block_brace_w, BEAM_W, block_brace_w/2], center=true);
            translate([-ir - wall_th + 1, -BEAM_W/2 + block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, -45, 0])
                cube([BEAM_W, block_brace_w/2, BEAM_W], center=true);
            * translate([-ir - wall_th + 1, BEAM_W/2 - block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, -45, 0])
                cube([BEAM_W, block_brace_w/2, BEAM_W], center=true);
            translate([ir + wall_th - 1, -BEAM_W/2 + block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, 45, 0])
                cube([BEAM_W, block_brace_w/2, BEAM_W], center=true);
            * translate([ir + wall_th - 1, BEAM_W/2 - block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, 45, 0])
                cube([BEAM_W, block_brace_w/2, BEAM_W], center=true);
        }
        translate([0, 0, ir + wall_th])
            rotate([90, 0, 0]) 
            cylinder(r=ir, h=BEAM_W+1, center=true, $fn=64);
        translate([BEAM_W, 0, 0])
            cylinder(r=beam_hole_or, h=wall_th*2);
        translate([-BEAM_W, 0, 0])
            cylinder(r=beam_hole_or, h=wall_th*2);
        
        translate([0, 0, -BEAM_W/2])
            cube([3*BEAM_W + 1, BEAM_W + 1, BEAM_W], center=true);
    }
}

bearing_h = 7;
bearing_ir = 4;
bearing_or = 11;
block_brace_w = 5;
module pillow_block() {
   mount_block(bearing_or);
}

module corner_mount() {
    difference() {
        cube(2*BEAM_W, center=true);
        
        translate([0, 0, 0])
            beam(BEAM_W*2);
        * translate([0, 0, -BEAM_W])
            beam(BEAM_W);
        translate([0, 0, 0])
            rotate([90, 0, 0])
            beam(BEAM_W*2);
        * translate([0, -BEAM_W, 0])
            rotate([90, 0, 0])
            beam(BEAM_W);
        translate([0, 0, 0])
            rotate([0, 90, 0])
            beam(BEAM_W*2);
        * translate([-BEAM_W, 0, 0])
            rotate([0, 90, 0])
            beam(BEAM_W);
    }
}


// wall_th = 4;
mount_cube_w = 55;
mount_cube_h = BEAM_W + 2 * wall_th;
mount_cube_l = 3 * BEAM_W + 2*wall_th;

module mount_cube(mount_cube_l=BEAM_W) {
    difference() {
        cube([mount_cube_l, mount_cube_w, mount_cube_h], center=true);
        rotate([0, 90, 0])
            beam_hole(mount_cube_l+1);
        cylinder(r=3/2, h=2*mount_cube_h, center=true);
        rotate([90, 0, 0])
            cylinder(r=3/2, h=2*mount_cube_w, center=true);
        shaft_pillow_holes(mount_cube_h + BEAM_W);
        rod_mount_holes(mount_cube_h + BEAM_W);
        for (i=[-1, 1]) {
            rotate([i * 90, 0, 0]) {
                translate([0, 0, BEAM_W / 2 + wall_th])
                    cylinder(r=m3_nut_or, h=mount_cube_w/2);
                # translate([0, 0, BEAM_W / 2 + m3_nut_h/2 + wall_th])
                    m3_nut();
            }            
            translate([0, 0, i*(BEAM_W / 2 - m3_nut_h/2 + 2 * wall_th)])
                m3_nut();
        }
       
    }
}

module mount_cube_inline() {
    difference() {
        translate([0, BEAM_W, 0])
            cube([mount_cube_w, mount_cube_l, mount_cube_h], center=true);
        translate([0, BEAM_W, -mount_cube_h / 2])
            cube([mount_cube_w+1, mount_cube_l+1, mount_cube_h], center=true);
        rotate([0, 90, 0])
            beam_hole(mount_cube_w+1);
        rotate([0, 90, 90])
            beam_hole(2*mount_cube_w+1);
        for (xi=[1, 2]) {
            translate([0, xi*BEAM_W, 0]) 
                rotate([0, 0, 90])
                shaft_pillow_holes(mount_cube_h + BEAM_W);
            translate([0, xi*BEAM_W, 0]) 
                rotate([0, 0, 90])
                rod_mount_holes(mount_cube_h + BEAM_W);
        }
        
        translate([0, BEAM_W, 0])
            cylinder(r=3/2, h=2*mount_cube_h, center=true); 
        translate([0, 0, mount_cube_h/2 - bracket_th/2])
            tee_bracket();
        for (xi=[-1, 0, 1]) {
            translate([xi * BEAM_W, 0, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
            translate([0, (xi+1) * BEAM_W, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
        }
    }
}

module _design_mount_cube_inline() {
    mount_cube_inline();
    * rotate([0, 180, 0])
        mount_cube_inline();
    
    % translate([0, BEAM_W, BEAM_W/2 + rod_mount_c_h + wall_th]) 
        rotate([0, 0, 90])
        rod_mount();
    %  translate([0, BEAM_W, -BEAM_W/2 - shaft_pillow_c_h - wall_th]) 
        rotate([0, 180, 90])
        shaft_pillow();
}

! _design_mount_cube_inline();

module cap_mount_8mm() {
    difference() {
        cube([3*BEAM_W, BEAM_W + 2 * wall_th, BEAM_W + 2 * wall_th], center=true);
        translate([-BEAM_W * 1.5/2, 0, 0])
            cube([1.5* BEAM_W, BEAM_W - 2, BEAM_W - 2], center=true);
        translate([-BEAM_W * 1.5/2, 0, 0])
            rotate([0, 90, 0])
            beam(BEAM_W*1.5);
        rod();
        for (i=[0, 1]) {
            for (j=[-1, 0, 1]) {
                translate([j * BEAM_W, 0, 0])
                    rotate([i*90, 0, 0])
                    cylinder(r=3/2, h=BEAM_W *2, center=true);
            }                
        }
        for (j=[0:3]) {
            # translate([BEAM_W, 0, 0])
            rotate([j * 90, 0, 0])
            for (dz=[0, -m3_nut_h+1]) {
                translate([0, 0, 4 + m3_nut_h/2 + dz])
                m3_nut();
            }
        }
    }
}

module mini_inline_mount_8mm() {
    difference() {
        translate([0, 4 + m3_nut_h / 2, 0])
            cube([BEAM_W, BEAM_W + 8 + 2*wall_th + m3_nut_h, BEAM_W + 2 * wall_th], center=true);
        rotate([0, 90, 0])
            beam(BEAM_W+1);
        cube([BEAM_W+1, BEAM_W - 2, BEAM_W - 2], center=true);
        
        # for (y=[0, BEAM_W / 2 + 4]) {
            translate([0, y, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
        }
        
        rotate([90, 0, 0])
            cylinder(r=3/2, h=2*mount_cube_w, center=true);
        
        translate([-BEAM_W/2 - 1, BEAM_W/2 + 4, 0]) 
            rod(BEAM_W + 2);
        # translate([0, BEAM_W/2 + 4, BEAM_W/2 + wall_th + 1]) 
            rotate([0, 90, 0])
            rod(BEAM_W + 2 + 2 * wall_th);
        //# for (j=[0, 2, 3]) {
            translate([0, BEAM_W / 2 + 4, 0])
            rotate([-90, 0, 0])
            # for (dz=[0, -
        +1]) {
                translate([0, 0, 4 + m3_nut_h/2 + dz])
                m3_nut();
            }
        //}
       
    }
}