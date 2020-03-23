use <lib/lib_involute.scad>;
include <lib/motors.scad>;
include <lib/mower.scad>;
include <lib/casting.scad>;
include <lib/motion_hardware.scad>;
include <lib/t20beam.scad>;

// ARBITRARY CHOICES
gear1_teeth = 40;
gear2_teeth = 8;

bevel_pd = 160;
bevel_cp = bevel_pd / gear1_teeth * 180;
ring_gear_thickness = 6;
bevel_face = 10;
ring_sleeve_width = 5;

axis_angle = 90;

// MEASUREMENTS
bldc_max_rpm = 990;
hs_id = 7.7;
hs_length = 100;
hs_collar_h = 10;

m8d_nut_or = 15.3/2;
m8d_nut_h = 5.5;

// DERIVED
hs_max_rpm = bldc_max_rpm*gear1_teeth/gear2_teeth;
tip_speed_mmpm = hs_max_rpm*ch_mower_or*2*PI;
tip_speed_fpm = tip_speed_mmpm/IN_MM/12;

echo(
	bldc_max_rpm=bldc_max_rpm,
	gear1_teeth=gear1_teeth,
	gear2_teeth=gear2_teeth,
	ratio=gear1_teeth/gear2_teeth,
	hs_max_rpm=hs_max_rpm,
	ch_mower_or=ch_mower_or,
	tip_speed_mps=tip_speed_mmpm/60/1000,
	tip_speed_fpm=tip_speed_fpm,
	tip_speed_mph=tip_speed_fpm * 60 / 5280
);

function outside_pitch_radius(teeth) = teeth * bevel_cp / 360;
outside_pitch_radius1 = outside_pitch_radius(gear1_teeth);
outside_pitch_radius2 = outside_pitch_radius(gear2_teeth);
pitch_apex1 = (
	outside_pitch_radius2 * sin(axis_angle) + 
	(outside_pitch_radius2 * cos(axis_angle) + 
		outside_pitch_radius1) / tan(axis_angle));
cone_distance = sqrt(
	pow(pitch_apex1, 2) + pow(outside_pitch_radius1, 2));
pitch_apex2 = sqrt(
	pow(cone_distance, 2) - pow(outside_pitch_radius2, 2));
pitch_angle1 = asin(outside_pitch_radius1 / cone_distance);
pitch_angle2 = asin(outside_pitch_radius2 / cone_distance);
	
echo("cone_distance", cone_distance);
echo("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
echo("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);
echo(pitch_apex1=pitch_apex1, pitch_apex2=pitch_apex2, ring_gear_thickness=ring_gear_thickness);

gearset_offs = [0,0,pitch_apex1 + bevel_face];
bldc_hub_offs = [0, 0, bldc_hub_h/2];
ring_gear_offs = [0,0,-pitch_apex1];

hs_offs = [0,0,-pitch_apex2];
hs_rot = [0,-(pitch_angle1+pitch_angle2),0];

hs_ch_offs = [0, 0, -hs_length + bevel_face - ch_hub_h + ch_top_h + m8d_nut_h];

module gearset2(use_stl=false) {
	translate(gearset_offs)
	{
		translate(ring_gear_offs) {
			rotate([0, 0, $t*360*3/gear1_teeth])
			ring_gear(use_stl);
		}

		rotate(hs_rot)
			translate(hs_offs)
			hs_axis(use_stl);
	}
}

module hs_axis(use_stl=false) {
	hs_spin = 360 / gear2_teeth / 2 - $t*360*3/gear2_teeth;
	rotate([0, 0, hs_spin]) {
		hs_gear3(use_stl);
		translate([0, 0, -hs_length + bevel_face])
			color("silver")
			cylinder(r=hs_id/2, h=hs_length);
		translate(hs_ch_offs)
			cutting_head();
			
	}
	// % translate([0, 0, -hs_collar_h - bearing_h])
	// 	color("gray")
	// 	bearing();
	// translate([0, 0, -hs_collar_h - bearing_h - 2 * t20_w])
	// 	color("gray")
		// bearing();
	// translate([0, 0, -bevel_face - hs_collar_h - 2 * m8_nut_h]) {
	// 	rotate([0, 90, 0])
	// 		kp08();
	// 	translate([-kp08_c_h - t20_w/2, 0, 0])
	// 		rotate([90, 0, 0])
	// 		t20(300);
	// }
	// translate([0, 0, -bevel_face - hs_collar_h - 2 * m8_nut_h - t20_w]) {
	// 	rotate([0, 90, 0])
	// 		kp08();
	// 	translate([-kp08_c_h - t20_w/2, 0, 0])
	// 		rotate([90, 0, 0])
	// 		t20(260);
	// 	}
}

module ring_gear(use_stl=false) {
	color("silver")
	if (use_stl) {
		import("stl/ring_gear.involute_parts.stl");
	} else {
		difference() {
			union() {
				bevel_gear (
					number_of_teeth=gear1_teeth,
					cone_distance=cone_distance,
					pressure_angle=30,
					outside_circular_pitch=bevel_cp,
					bore_diameter=bldc_od-1,
					gear_thickness=ring_gear_thickness,
					face_width=bevel_face,
					finish=2);
				translate([0, 0, -bevel_face])
				draft_cylinder(
					r=bldc_od/2 + ring_sleeve_width, 
					h=bldc_hub_h, center=false, draft_angle=5);
			}
			translate([0, 0, -bevel_face - 0.5])
				draft_cylinder(
					r=bldc_od/2, 
					h=bldc_hub_h+1, 
					center=false, draft_angle=1, invert=true);
		}
	}
}

module m8_nut_draft() {
	color("silver")
	draft_cylinder(r=m8d_nut_or, h=m8d_nut_h, center=true, draft_angle=-2, invert=false, fn=6);
}

module hs_gear3(use_stl=false) {
	color("silver")
	if (use_stl) {
		import("stl/hs_gear3.involute_parts.stl");
	} else {
		difference() {
			bevel_gear (
				number_of_teeth=gear2_teeth,
				cone_distance=cone_distance,
				pressure_angle=30,
				outside_circular_pitch=bevel_cp,
				bore_diameter=hs_id-3,
				gear_thickness=ring_gear_thickness,
				face_width=bevel_face,
				finish=0);
			translate([0, 0, -0.1])
				draft_cylinder(r=hs_id/2, h=bevel_face-m8d_nut_h + 0.2, draft_angle=2, invert=true);
			translate([0, 0, bevel_face-m8d_nut_h/2]) 
				m8d_nut_draft();
		}
	}
}


// module sprue() {
// 	color("#003300aa") {
// 	difference() {
// 		union() {
// 			translate([40, 0, 0])
// 				draft_cylinder(r=10, h=20, draft_angle=1);
// 			translate([35, 3, 4])
// 				draft_cube([20, 6, 4]);
// 			translate([65, 5, 5])
// 				draft_cube([20, 10, 5]);
// 		}
// 		translate([40, 0, -0.5])
// 				draft_cylinder(r=9, h=21, invert=true, draft_angle=3);
// 	}

// 	translate([-40, 0, 2])
// 		draft_cube([47, 4, 4], center=true);
// 	translate([-40, 0, 0])
// 		draft_cylinder(r=3, h=20);
// 	}
// }

// module cast_plate() {
// 	scale(CAST_EXPANSION) {
// 		translate([0, 0, bevel_face])
// 			ring_gear(true);
		
// 		translate([0, 0, 0])
// 			hs_gear2(true);
// 		sprue();
// 	}
// }
// // cast_plate();

// module shell(or=10, ir=9, half=true) {
// 	difference() {
// 		sphere(or);
// 		sphere(ir);
// 		if (half)
// 			translate([0, 0, -or/2])
// 			cube([2*or, 2*or, or], center=true);
// 	}

// }

// module sprue3() {
// 	color("#330000cc") {
// 	translate([-23, 0, 0])
// 		difference() {
// 			translate([0, 0, 3/2])
// 				draft_cube([30, 5, 3], center=true);
// 			translate([0, 0, -0.1])
// 				draft_cylinder(r=1, h=3, draft_angle=15);
// 		}
// 	// translate([-65, 0, 3/2])
// 	// 	draft_cube([20, 5, 3], center=true);
// 	translate([23, 0, 0])
// 		difference() {
// 			translate([0, 0, 5/2]) 
// 				draft_cube([30, 5, 5], center=true);
// 			translate([0, 0, -0.1])
// 				draft_cylinder(r=1, h=3, draft_angle=15);
// 		}
// 	translate([45, 0, 0])
// 		shell(half=true);
	
// 	translate([-41, 0, 0])
// 		shell(or=5, ir=4, half=true);
// 	}
// }

// module cast_plate3() {
// 	scale(CAST_EXPANSION) {
// 		// translate([0, 0, bevel_face])
// 		// 	ring_gear(true);
// 		// for (i=[-1:1])
// 			// translate([i * 45, 0, 0])
// 			hs_gear3(false);
// 		% hs_gear3(true);			
// 		sprue3();
// 	}
// 	// % flask();
	
// }
// cast_plate3();