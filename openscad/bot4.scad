include <constants.scad>;
use <openbeam.scad>;
use <motion_hardware.scad>;
use <chain_drive.scad>;

tread_l = 300;
tread_w = 100;

module design() {
    for (i=[-1, 1]) {
        translate([0, i*(tread_w + BEAM_W) /2, 0])
            rotate([0, 90, 0])
            beam(tread_l);
        translate([i * (tread_l - 3*BEAM_W)/2, 0, 0])
            rotate([0, 90, 90])
            beam(tread_w);
        for (j=[-1, 1]) {
            translate([j * (tread_l - 3*BEAM_W)/2, i*(tread_w + BEAM_W) /2, 0])
                rotate([0, 0, 90*(i+1)]) {
                    mount_cube_inline();
                    rotate([0, 180, 0])
                        mount_cube_inline();
                }
            translate([-i*(tread_l - 3*BEAM_W) / 2, j*(BEAM_W - tread_w) / 2, -(rod_mount_c_h + 23/2)])
                rotate([180, 0, 90]){
                    rotate([0, 0, j*90+90]) 
                        rod(tread_w);
                    rod_mount();
                    translate([-j*(2*BEAM_W + 20), 0, 0])
                        rotate([0, 90, 0])
                        small_drive_sprocket();
                }
        }
        translate([i * (tread_l - 3*BEAM_W) / 2, i*(-tread_w / 2 - BEAM_W), nema23_mount_c_h + 23/2]) {
            rotate([0, 0, i*90])
                nema23_mount();
            translate([0, -i*20, 0])
                rotate([90, 0, 0])
                small_drive_sprocket();
        }
        translate([-i*(tread_l - 3*BEAM_W) / 2, i*(BEAM_W - tread_w) / 2, rod_mount_c_h + 23/2])
            rotate([0, 0, 90]) {
                # rotate([0, 0, i*90+90]) 
                    rod(tread_w);
                rod_mount();
                translate([-i*(2*BEAM_W + 20), 0, 0])
                        rotate([0, 90, 0])
                        small_drive_sprocket();
            }
    }
}
// 
design();

!mount_cube_inline();