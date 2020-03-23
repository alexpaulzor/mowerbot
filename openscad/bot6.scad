include <involute_parts.scad>;

wall_th = 3;

module transform_hs() {
	translate(gearset_offs - bldc_hub_offs)
	rotate(hs_rot)
	translate(hs_offs)
	children();
}

module transform_hs_inv() {
	translate(-hs_offs)
	rotate(-hs_rot)
	translate(-gearset_offs)
	children();
}

module transform_ch_inv() {
	translate(-hs_ch_offs - [0, 0, ch_string_offset])
	transform_hs_inv() 
	children();
}

module transform_bldc_inv() {
	
	transform_ch_inv()
	translate(gearset_offs)
	children();
}


// module gearbox_in_place() {
// 	transform_ch_inv()
// 		gearbox_internals();
// 	// translate([0, 0, -hs_collar_h - bearing_h])
// 	// color("gray")
// 	// bearing();
// }

// module bot6_body() {
// 	scale([1, 1, 0.25])
// 		shell(or=ch_mower_or + wall_th, ir=ch_mower_or);
// 	transform_bldc_inv()
// 		cube([200, 10, 100], center=true);
// }

module gearbox_internals() {
	translate(bldc_hub_offs) 
		bldc_hub();
	gearset2(true);
}

module gearbox(use_stl=false) {
	// difference() {
		gearbox_shell(use_stl);
		// gearbox_internals();
	// }
}

module gearbox_shell(use_stl=false) {
	gearbox_shell_half_left(use_stl);
	* % gearbox_shell_half_right(use_stl);
}

module gearbox_shell_half_left(use_stl=false) {
	if (use_stl) {
		import("stl/gearbox_shell_half_left.bot6.stl");
	} else {
		_gearbox_shell_half_left();
	}
}

module _gearbox_shell_half_left(use_stl=false) {
	intersection() {
		color("silver")
			gearbox_shell_whole(true);
		translate([0, 100, 0])
			cube([300, 200, 200], center=true);
	}
}

module gearbox_shell_half_right(use_stl=false) {
	if (use_stl) {
		import("stl/gearbox_shell_half_right.bot6.stl");
	} else {
		_gearbox_shell_half_right();
	}
}

module _gearbox_shell_half_right() {
	intersection() {
		// color("silver")
			gearbox_shell_whole(true);
		translate([0, -100, 0])
			cube([300, 200, 200], center=true);
	}
}

module face_draft_bearing(r=bearing_or, h=bearing_h, face_draft=2) {
	difference() {
		rotate([0, 0, 180])
			draft_cylinder(r=r, h=h, center=true, draft_angle=0, face_draft=face_draft);
		translate([0, r/2, 0])
			cube([2*r+1, r, 2*h], center=true);
	}
	difference() {
			draft_cylinder(r=r, h=h, center=true, draft_angle=0, face_draft=face_draft);
		translate([0, -r/2, 0])
			cube([2*r+1, r, 2*h], center=true);
	}
}

module draft_peg(r=5/2, h=7, draft_angle=10) {
	translate([0, 0, -h/2])
		draft_cylinder(r=r, h=h/2, center=false, draft_angle=draft_angle, invert=true);
	
		draft_cylinder(r=r, h=h/2, center=false, draft_angle=draft_angle);
}

module gearbox_shell_surface(use_stl=false) {
	if (use_stl) {
		import("stl/gearbox_shell_surface.bot6.stl");
	} else {
		_gearbox_shell_surface();
	}
}

module _gearbox_shell_surface() {
	face_draft_bearing(
		r=170/2 + wall_th*2, 
		h=80 + wall_th*2,
		face_draft=1);
	cube([
		170 + 2*wall_th + 2*t20_w, 
		wall_th*2, 
		80 + wall_th*2 + 2*t20_w], center=true);
	transform_hs() {
		translate([0, 0, -bearing_h/2 - 30]) {
			cylinder(r=bearing_or + wall_th, h=50, center=true);
			cube([
				2*bearing_or + wall_th*2 + 2*t20_w, 
				2*wall_th, 50], center=true);
		}
	}
	cylinder(r=bldc_bearing_od/2, h=80 + wall_th*4, center=true);
}

module gearbox_shell_holes(use_stl=false) {
	if (use_stl) {
		import("stl/gearbox_shell_holes.bot6.stl");
	} else {
		_gearbox_shell_holes();
	}
}

module _gearbox_shell_holes() {
	face_draft_bearing(
			r=170/2, 
			h=80,
			face_draft=1);
	transform_hs() {
		translate([0, 0, -bearing_h/2 - 10]) 
			face_draft_bearing();
		translate([0, 0, -bearing_h/2 - 10 - 2*t20_w])
			face_draft_bearing();
		translate([0, 0, -hs_length])
			cylinder(r=8, h=hs_length);
	}
	bldc_shaft();
	for (i=[-1, 1]) {
		for (j=[-1, 1]) {
			translate([i*(170/2+wall_th+t20_w/2), 0, j*(40+wall_th+t20_w/2)])
				rotate([90, 0, 0])
				draft_peg();
			translate([i*(3*t20_w/2), 0, j*(40+wall_th+t20_w/2)])
				rotate([90, 0, 0])
				draft_peg();
			# transform_hs()
				translate([i*20, 0, j*20])
				rotate([90, 0, 0])
				draft_peg();
		}
		translate([0, 0, i*(40+2*wall_th + t20_w/2)])
			draft_cylinder(r=bldc_bearing_od/2, h=t20_w, center=true, draft_angle=0, face_draft=2);
	}
}

module gearbox_shell_whole(use_stl=false) {
	if (use_stl) {
		import("stl/gearbox_shell_whole.bot6.stl");
	} else {
		_gearbox_shell_whole(true);
	}
}

module _gearbox_shell_whole(use_stl=false) {
	// TODO: chamfer outside corners
	
	difference() {
		gearbox_shell_surface(use_stl);
		// % gearbox_shell_surface(false);
		gearbox_shell_holes(use_stl);
	}
}
// gearbox_shell_surface();
% gearbox_shell_holes();
// ! gearbox_shell_surface(false);
// module _gearbox_shell() {
// 	wall_th = 3;
// 	gearbox_dims = [170, 40, 80];
// 	difference() {
// 		cube(gearbox_dims+2*[wall_th, -wall_th, wall_th], center=true);
// 		cube(gearbox_dims, center=true);
// 		# translate([bearing_h/2 + 10, 0, 0])
// 			transform_hs()
// 			bearing();
// 	}
// }

buck_board_l = 77;
buck_board_w = 23;
buck_board_h = 21;
buck_board_hole_or = 2;
buck_board_hole_c_c = [69.3, 17];
module buck_board() {
    // difference() {
        translate([0, 0, buck_board_h/2])
        cube([buck_board_l, buck_board_w, buck_board_h], center=true);
        // buck_board_holes();
    // }
}

module buck_board_holes() {
    for (x=[-1, 1])
        for (y=[-1, 1])
        translate([x * buck_board_hole_c_c[0]/2, y * buck_board_hole_c_c[1]/2, -0.1])
        cylinder(r=buck_board_hole_or, h=buck_board_h*2, center=true);
}

buck_board_plate_h = 3;
buck_board_walls = 2;

module buck_board_plate() {
	difference() {
		translate([0, 0, buck_board_plate_h/2])
			cube([
				buck_board_l + buck_board_walls, 
				buck_board_w + buck_board_walls, 
				buck_board_plate_h + buck_board_walls], 
				center=true);
		translate([0, 0, buck_board_plate_h/2])
			buck_board();
		buck_board_holes();
	}
}


module design() {
	// buck_board_plate();
	
	gearbox();
	translate(-bldc_hub_offs) 
		gearbox_internals();
	// * translate([0, 0, ring_gear_thickness]) 
	// 	ring_sleeve(true);
	// ring_gear(false);
}
design();
// gearbox_shell_whole();

// transform_hs()
	