include <lib/openbeam.scad>;
include <lib/motion_hardware.scad>;
use <roller_chain_parts.scad>;
use <openbeam_parts.scad>;

tread_l = 300;
tread_w = 100;

module design() {
    for (i=[-1, 1]) {
        translate([0, i*(tread_w + openbeam_w) /2, 0])
            rotate([0, 90, 0])
            openbeam(tread_l);
        translate([i * (tread_l - 3*openbeam_w)/2, 0, 0])
            rotate([0, 90, 90])
            openbeam(tread_w);
        for (j=[-1, 1]) {
            translate([j * (tread_l - 3*openbeam_w)/2, i*(tread_w + openbeam_w) /2, 0])
                rotate([0, 0, 90*(i+1)]) {
                    mount_cube_inline();
                    rotate([0, 180, 0])
                        mount_cube_inline();
                }
            translate([-i*(tread_l - 3*openbeam_w) / 2, j*(openbeam_w - tread_w) / 2, -(sk8_c_h + 23/2)])
                rotate([180, 0, 90]){
                    rotate([0, 0, j*90+90]) 
                        rail(tread_w);
                    sk8();
                    translate([-j*(2*openbeam_w + 20), 0, 0])
                        rotate([0, 90, 0])
                        small_drive_sprocket();
                }
        }
        translate([i * (tread_l - 3*openbeam_w) / 2, i*(-tread_w / 2 - openbeam_w - nema23_mount_flange_h), nema23_mount_c_h + 23/2]) {
            rotate([0, 0, i*90])
                nema23_mount();
            translate([0, -i*20, 0])
                rotate([90, 0, 0])
                small_drive_sprocket();
        }
        translate([-i*(tread_l - 3*openbeam_w) / 2, i*(openbeam_w - tread_w) / 2, sk8_c_h + 23/2])
            rotate([0, 0, 90]) {
                rotate([0, 0, i*90+90]) 
                    rail(tread_w);
                sk8();
                # translate([-i*(2*openbeam_w + 20), 0, 0])
                        rotate([0, 90, 0])
                        small_drive_sprocket();
            }
    }
}
// 
design();

* mount_cube_inline();