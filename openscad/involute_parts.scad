use <lib/lib_involute.scad>;
include <lib/motors.scad>;
include <lib/metric.scad>;
include <lib/casting.scad>;

// module gear (
// 	number_of_teeth=15,
// 	circular_pitch=false, diametral_pitch=false,
// 	pressure_angle=28,
// 	clearance = 0.2,
// 	gear_thickness=5,
// 	rim_thickness=8,
// 	rim_width=5,
// 	hub_thickness=10,
// 	hub_diameter=15,
// 	bore_diameter=5,
// 	circles=0,
// 	backlash=0,
// 	twist=0,
// 	involute_facets=0)

// module bevel_gear (
// 	number_of_teeth=11,
// 	cone_distance=100,
// 	face_width=20,
// 	outside_circular_pitch=1000,
// 	pressure_angle=30,
// 	clearance = 0.2,
// 	bore_diameter=5,
// 	gear_thickness = 15,
// 	backlash = 0,
// 	involute_facets=0,
// 	finish = -1)
rim_thickness = bldc_hub_h/3;
pressure_angle = 28;

hs_teeth = 8;
bldc_teeth = 40;

bldc_gear_pd = 140; //bldc_od + 50;
bldc_gear_cp = bldc_gear_pd / bldc_teeth * 180;


gear1_teeth = bldc_teeth * 1;
gear2_teeth = hs_teeth * 1;
bevel_pd = 160;
bevel_cp = bevel_pd / gear1_teeth * 180;
ring_gear_thickness = 6;
bevel_face = 10;
ring_sleeve_width = 5;
hs_id = 7.7;
// bldc_gear_cp = 1000;
// bldc_gear_pd = bldc_gear_cp * bldc_teeth / 180;

// module bldc_gear() {
// 	translate([0, 0, -rim_thickness/2]) {
// 		difference() {
// 			gear(number_of_teeth=bldc_teeth,
// 				circular_pitch=bldc_gear_cp, 
// 				// diametral_pitch=false,
// 				pressure_angle=pressure_angle,
// 			// 	clearance = 0.2,
// 				gear_thickness=rim_thickness,
// 				rim_thickness=rim_thickness,
// 			// 	rim_width=5,
// 			// 	hub_thickness=10,
// 				hub_diameter=0,
// 				bore_diameter=bldc_od-10,
// 				circles=0
// 			// 	backlash=0,
// 			// 	twist=0,
// 				// involute_facets=0
// 			);
// 			translate([0, 0, -0.1])
// 				draft_cylinder(r=bldc_od/2, h=rim_thickness+0.2);
// 			// # bldc_gear_pins();
// 		}
// 	}
// }

// // module bldc_gear_pins() {
// // 	num_pins = 8;
// // 	for (i=[0:num_pins])
// // 		rotate([0, 0, i / num_pins * 360])
// // 		translate([bldc_od / 2 + 5, 0, 0])
// // 		draft_cylinder(r=1/4*IN_MM/2, h=rim_thickness);
// // }


// hs_gear_cp = bldc_gear_cp;
// // hs_gear_cp = hs_gear_pd / hs_teeth * 180;
// hs_gear_pd = hs_gear_cp * hs_teeth / 180;

// hs_rotation =  (hs_teeth % 2 + 1) * 360 / hs_teeth / 2;
// //360/hs_teeth/2;


// module hs_gear() {
// 	translate([0, 0, -rim_thickness/2])
// 	difference() {
// 		gear(number_of_teeth=hs_teeth,
// 			circular_pitch=bldc_gear_cp, 
// 			// diametral_pitch=false,
// 			pressure_angle=pressure_angle,
// 		// 	clearance = 0.2,
// 			gear_thickness=rim_thickness,
// 			rim_thickness=rim_thickness,
// 		// 	rim_width=5,
// 		// 	hub_thickness=10,
// 			hub_diameter=0,
// 			bore_diameter=hs_id-1,
// 			circles=0
// 		// 	backlash=0,
// 		// 	twist=0,
// 			// involute_facets=0
// 		);
// 		translate([0, 0, -0.1])
// 		draft_cylinder(r=hs_id/2, h=rim_thickness+0.2);
// 	}
// }	

// bldc_max_rpm = 990;
// mower_or = 180;
// hs_max_rpm = bldc_max_rpm*bldc_teeth/hs_teeth;
// tip_speed_mmpm = hs_max_rpm*mower_or*2*PI;
// tip_speed_fpm = tip_speed_mmpm/IN_MM/12;
 
// module gearset() {
// 	bldc_gear();
// 	// hs_gear();
// 	translate([bldc_gear_pd/2 + hs_gear_pd/2, 0, 0]) {
// 		rotate([0, 0, hs_rotation]) {
// 			hs_gear();
// 		}
// 	}
// }


module gearset2(use_stl=false) {
	axis_angle = 90;
	outside_pitch_radius1 = gear1_teeth * bevel_cp / 360;
	outside_pitch_radius2 = gear2_teeth * bevel_cp / 360;
	pitch_apex1=outside_pitch_radius2 * sin (axis_angle) + 
		(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
	cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
	pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
	echo ("cone_distance", cone_distance);
	pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
	pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
	echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
	echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);
	echo(pitch_apex1=pitch_apex1, pitch_apex2=pitch_apex2, ring_gear_thickness=ring_gear_thickness);
	//rotate([0,0,90])
	translate ([0,0,pitch_apex1 + bevel_face])
	{
		translate([0,0,-pitch_apex1])
			ring_gear(use_stl);
	
		
		rotate([0,-(pitch_angle1+pitch_angle2),0])
		translate([pitch_apex1*0,0,-pitch_apex2])
		rotate([0, 0, 360 / gear2_teeth / 2]) {
			hs_gear2(use_stl);
			% hs_gear2(true);
		}
	}
}

module ring_gear(use_stl=false) {
	if (use_stl) {
		import("stl/ring_gear.involute_parts.stl");
	} else {
		// gearset2(true, false, 0);
		axis_angle = 90;
		outside_pitch_radius1 = gear1_teeth * bevel_cp / 360;
		outside_pitch_radius2 = gear2_teeth * bevel_cp / 360;
		pitch_apex1=outside_pitch_radius2 * sin (axis_angle) + 
			(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
		cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
		pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
		// echo ("cone_distance", cone_distance);
		pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
		pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
		// echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
		// echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);

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

module hs_gear2(use_stl=false) {
	if (use_stl) {
		import("stl/hs_gear2.involute_parts.stl");
	} else {
		// gearset2(false, true, 0);
		axis_angle = 90;
		outside_pitch_radius1 = gear1_teeth * bevel_cp / 360;
		outside_pitch_radius2 = gear2_teeth * bevel_cp / 360;
		pitch_apex1=outside_pitch_radius2 * sin (axis_angle) + 
			(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
		cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
		pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
		// echo ("cone_distance", cone_distance);
		pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
		pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
		// echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
		// echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);
		difference() {
			bevel_gear (
				number_of_teeth=gear2_teeth,
				cone_distance=cone_distance,
				pressure_angle=30,
				outside_circular_pitch=bevel_cp,
				bore_diameter=hs_id-2,
				gear_thickness=ring_gear_thickness,
				face_width=bevel_face,
				finish=0);
			translate([0, 0, -0.1])
				draft_cylinder(r=hs_id/2, h=bevel_face+0.2, invert=true, draft_angle=5);
		}
	}
}

module hs_gear3(use_stl=false) {
	if (use_stl) {
		import("stl/hs_gear3.involute_parts.stl");
	} else {
		/*
		bearing ID:
		  - 8mm (8.15)
          - 1/2 in (12.72)
          - 5/8 in (16.29)
        bolt OD:
          - 10mm (9.8)
          - 7/16 in (10.94)
          - 15/32 in (11.86)
          - 5/16 in (7.8)
          - 1/2 in (12.5)

		*/
		// gearset2(false, true, 0);
		axis_angle = 90;
		outside_pitch_radius1 = gear1_teeth * bevel_cp / 360;
		outside_pitch_radius2 = gear2_teeth * bevel_cp / 360;
		pitch_apex1=outside_pitch_radius2 * sin (axis_angle) + 
			(outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
		cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
		pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
		// echo ("cone_distance", cone_distance);
		pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
		pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
		// echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
		// echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);
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
			// hs_gear2(true);
			// # draft_cylinder(r=hs_id/2, h=80, draft_angle=-1, invert=true);
			draft_cylinder(r=hs_id/2, h=bevel_face-m8_nut_h, draft_angle=10, invert=true);
			translate([0, 0, bevel_face-m8_nut_h/2]) 
				m8_nut();
			// draft_cylinder(r=hs_id/2, h=FLASK_SIZE[2]/CAST_EXPANSION, draft_angle=1);
			// % cylinder(r=hs_id/2, h=FLASK_SIZE[2]/CAST_EXPANSION);
			// translate([0, 0, 10])
			// draft_cylinder(r=hs_id/2+4, h=5, draft_angle=45);
		}
	}
}

module design() {
	* translate([0, 0, bldc_hub_h/2]) 
		bldc_hub();
	gearset2 (false);
		
	// * translate([0, 0, ring_gear_thickness]) 
	// 	ring_sleeve(true);
	// ring_gear(false);
}
* % design();

module sprue() {
	color("#003300aa") {
	difference() {
		union() {
			translate([40, 0, 0])
				draft_cylinder(r=10, h=20, draft_angle=1);
			translate([35, 3, 4])
				draft_cube([20, 6, 4]);
			translate([65, 5, 5])
				draft_cube([20, 10, 5]);
		}
		translate([40, 0, -0.5])
				draft_cylinder(r=9, h=21, invert=true, draft_angle=3);
	}

	translate([-40, 0, 2])
		draft_cube([47, 4, 4], center=true);
	translate([-40, 0, 0])
		draft_cylinder(r=3, h=20);
	}
}

module cast_plate() {
	scale(CAST_EXPANSION) {
		translate([0, 0, bevel_face])
			ring_gear(true);
		
		translate([0, 0, 0])
			hs_gear2(true);
		sprue();
	}
}
// cast_plate();

module sprue3() {
	color("#330000cc") {
	translate([-23, 0, 3/2])
		draft_cube([30, 5, 3], center=true);
	translate([-65, 0, 3/2])
		draft_cube([20, 5, 3], center=true);
	translate([23, 0, 5/2])
		draft_cube([30, 5, 5], center=true);
	translate([65, 0, 5/2])
		draft_cube([20, 10, 5], center=true);
	}
}

module cast_plate3() {
	scale(CAST_EXPANSION) {
		// translate([0, 0, bevel_face])
		// 	ring_gear(true);
		for (i=[-1:1])
			translate([i * 45, 0, 0])
			hs_gear3(true);
		sprue3();
	}
	// % flask();
	
}
cast_plate3();