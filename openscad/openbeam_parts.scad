include <lib/openbeam.scad>;
include <lib/motion_hardware.scad>;

wall_th = 4;

module mount_block(ir) {
    block_outside = 2*ir + 2 * wall_th;
    difference() {
        union() {
            translate([0, 0, wall_th/2])
                cube([3 * openbeam_w, openbeam_w, wall_th], center=true);
            translate([0, 0, block_outside/4])
                cube([block_outside, openbeam_w, block_outside/2], center=true);
            translate([0, 0, ir + wall_th])
                rotate([90, 0, 0]) 
                cylinder(r=block_outside/2, h=openbeam_w, center=true);
            * translate([ir + wall_th, 0, sqrt(2)/4*block_brace_w + wall_th/2])
                rotate([0, 45, 0])
                cube([block_brace_w, openbeam_w, block_brace_w/2], center=true);
            * translate([-ir - wall_th, 0, sqrt(2)/4*block_brace_w + wall_th/2])
                rotate([0, -45, 0])
                cube([block_brace_w, openbeam_w, block_brace_w/2], center=true);
            translate([-ir - wall_th + 1, -openbeam_w/2 + block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, -45, 0])
                cube([openbeam_w, block_brace_w/2, openbeam_w], center=true);
            * translate([-ir - wall_th + 1, openbeam_w/2 - block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, -45, 0])
                cube([openbeam_w, block_brace_w/2, openbeam_w], center=true);
            translate([ir + wall_th - 1, -openbeam_w/2 + block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, 45, 0])
                cube([openbeam_w, block_brace_w/2, openbeam_w], center=true);
            * translate([ir + wall_th - 1, openbeam_w/2 - block_brace_w/4, sqrt(2)/4*block_brace_w])
                rotate([0, 45, 0])
                cube([openbeam_w, block_brace_w/2, openbeam_w], center=true);
        }
        translate([0, 0, ir + wall_th])
            rotate([90, 0, 0]) 
            cylinder(r=ir, h=openbeam_w+1, center=true, $fn=64);
        translate([openbeam_w, 0, 0])
            cylinder(r=beam_hole_or, h=wall_th*2);
        translate([-openbeam_w, 0, 0])
            cylinder(r=beam_hole_or, h=wall_th*2);
        
        translate([0, 0, -openbeam_w/2])
            cube([3*openbeam_w + 1, openbeam_w + 1, openbeam_w], center=true);
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
        cube(2*openbeam_w, center=true);
        
        translate([0, 0, 0])
            beam(openbeam_w*2);
        * translate([0, 0, -openbeam_w])
            beam(openbeam_w);
        translate([0, 0, 0])
            rotate([90, 0, 0])
            beam(openbeam_w*2);
        * translate([0, -openbeam_w, 0])
            rotate([90, 0, 0])
            beam(openbeam_w);
        translate([0, 0, 0])
            rotate([0, 90, 0])
            beam(openbeam_w*2);
        * translate([-openbeam_w, 0, 0])
            rotate([0, 90, 0])
            beam(openbeam_w);
    }
}


// wall_th = 4;
mount_cube_w = 55;
mount_cube_h = openbeam_w + 2 * wall_th;
mount_cube_l = 3 * openbeam_w + 2*wall_th;

module mount_cube(mount_cube_l=openbeam_w) {
    difference() {
        cube([mount_cube_l, mount_cube_w, mount_cube_h], center=true);
        rotate([0, 90, 0])
            beam_hole(mount_cube_l+1);
        cylinder(r=3/2, h=2*mount_cube_h, center=true);
        rotate([90, 0, 0])
            cylinder(r=3/2, h=2*mount_cube_w, center=true);
        shaft_pillow_holes(mount_cube_h + openbeam_w);
        rod_mount_holes(mount_cube_h + openbeam_w);
        for (i=[-1, 1]) {
            rotate([i * 90, 0, 0]) {
                translate([0, 0, openbeam_w / 2 + wall_th])
                    cylinder(r=m3_nut_or, h=mount_cube_w/2);
                # translate([0, 0, openbeam_w / 2 + m3_nut_h/2 + wall_th])
                    m3_nut();
            }            
            translate([0, 0, i*(openbeam_w / 2 - m3_nut_h/2 + 2 * wall_th)])
                m3_nut();
        }
       
    }
}

module mount_cube_inline() {
    difference() {
        translate([0, openbeam_w, 0])
            cube([mount_cube_w, mount_cube_l, mount_cube_h], center=true);
        translate([0, openbeam_w, -mount_cube_h / 2])
            cube([mount_cube_w+1, mount_cube_l+1, mount_cube_h], center=true);
        rotate([0, 90, 0])
            beam_hole(mount_cube_w+1);
        rotate([0, 90, 90])
            beam_hole(2*mount_cube_w+1);
        for (xi=[1, 2]) {
            translate([0, xi*openbeam_w, 0]) 
                rotate([0, 0, 90])
                shaft_pillow_holes(mount_cube_h + openbeam_w);
            translate([0, xi*openbeam_w, 0]) 
                rotate([0, 0, 90])
                rod_mount_holes(mount_cube_h + openbeam_w);
        }
        
        translate([0, openbeam_w, 0])
            cylinder(r=3/2, h=2*mount_cube_h, center=true); 
        translate([0, 0, mount_cube_h/2 - bracket_th/2])
            tee_bracket();
        for (xi=[-1, 0, 1]) {
            translate([xi * openbeam_w, 0, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
            translate([0, (xi+1) * openbeam_w, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
        }
    }
}

module _design_mount_cube_inline() {
    mount_cube_inline();
    * rotate([0, 180, 0])
        mount_cube_inline();
    
    % translate([0, openbeam_w, openbeam_w/2 + rod_mount_c_h + wall_th]) 
        rotate([0, 0, 90])
        rod_mount();
    %  translate([0, openbeam_w, -openbeam_w/2 - shaft_pillow_c_h - wall_th]) 
        rotate([0, 180, 90])
        shaft_pillow();
}

! _design_mount_cube_inline();

module cap_mount_8mm() {
    difference() {
        cube([3*openbeam_w, openbeam_w + 2 * wall_th, openbeam_w + 2 * wall_th], center=true);
        translate([-openbeam_w * 1.5/2, 0, 0])
            cube([1.5* openbeam_w, openbeam_w - 2, openbeam_w - 2], center=true);
        translate([-openbeam_w * 1.5/2, 0, 0])
            rotate([0, 90, 0])
            beam(openbeam_w*1.5);
        rod();
        for (i=[0, 1]) {
            for (j=[-1, 0, 1]) {
                translate([j * openbeam_w, 0, 0])
                    rotate([i*90, 0, 0])
                    cylinder(r=3/2, h=openbeam_w *2, center=true);
            }                
        }
        for (j=[0:3]) {
            # translate([openbeam_w, 0, 0])
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
            cube([openbeam_w, openbeam_w + 8 + 2*wall_th + m3_nut_h, openbeam_w + 2 * wall_th], center=true);
        rotate([0, 90, 0])
            beam(openbeam_w+1);
        cube([openbeam_w+1, openbeam_w - 2, openbeam_w - 2], center=true);
        
        # for (y=[0, openbeam_w / 2 + 4]) {
            translate([0, y, 0])
                cylinder(r=3/2, h=2*mount_cube_h, center=true);
        }
        
        rotate([90, 0, 0])
            cylinder(r=3/2, h=2*mount_cube_w, center=true);
        
        translate([-openbeam_w/2 - 1, openbeam_w/2 + 4, 0]) 
            rod(openbeam_w + 2);
        # translate([0, openbeam_w/2 + 4, openbeam_w/2 + wall_th + 1]) 
            rotate([0, 90, 0])
            rod(openbeam_w + 2 + 2 * wall_th);
        //# for (j=[0, 2, 3]) {
            translate([0, openbeam_w / 2 + 4, 0])
            rotate([-90, 0, 0])
            # for (dz=[0, -
        +1]) {
                translate([0, 0, 4 + m3_nut_h/2 + dz])
                m3_nut();
            }
        //}
       
    }
}