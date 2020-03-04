use <lib/lib_involute.scad>;
include <lib/motors.scad>;
use <lib/casting.scad>;

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


gear1_teeth = bldc_teeth * 2;
gear2_teeth = hs_teeth * 2;
bevel_pd = 180;
bevel_cp = bevel_pd / gear1_teeth * 180;
ring_gear_thickness = 10;
// bldc_gear_cp = 1000;
// bldc_gear_pd = bldc_gear_cp * bldc_teeth / 180;

module bldc_gear() {
	translate([0, 0, -rim_thickness/2]) {
		difference() {
			gear(number_of_teeth=bldc_teeth,
				circular_pitch=bldc_gear_cp, 
				// diametral_pitch=false,
				pressure_angle=pressure_angle,
			// 	clearance = 0.2,
				gear_thickness=rim_thickness,
				rim_thickness=rim_thickness,
			// 	rim_width=5,
			// 	hub_thickness=10,
				hub_diameter=0,
				bore_diameter=bldc_od-10,
				circles=0
			// 	backlash=0,
			// 	twist=0,
				// involute_facets=0
			);
			translate([0, 0, -0.1])
				draft_cylinder(r=bldc_od/2, h=rim_thickness+0.2);
			// # bldc_gear_pins();
		}
	}
}

// module bldc_gear_pins() {
// 	num_pins = 8;
// 	for (i=[0:num_pins])
// 		rotate([0, 0, i / num_pins * 360])
// 		translate([bldc_od / 2 + 5, 0, 0])
// 		draft_cylinder(r=1/4*IN_MM/2, h=rim_thickness);
// }


hs_gear_cp = bldc_gear_cp;
// hs_gear_cp = hs_gear_pd / hs_teeth * 180;
hs_gear_pd = hs_gear_cp * hs_teeth / 180;
hs_id = 8;
hs_rotation =  (hs_teeth % 2 + 1) * 360 / hs_teeth / 2;
//360/hs_teeth/2;


module hs_gear() {
	translate([0, 0, -rim_thickness/2])
	difference() {
		gear(number_of_teeth=hs_teeth,
			circular_pitch=bldc_gear_cp, 
			// diametral_pitch=false,
			pressure_angle=pressure_angle,
		// 	clearance = 0.2,
			gear_thickness=rim_thickness,
			rim_thickness=rim_thickness,
		// 	rim_width=5,
		// 	hub_thickness=10,
			hub_diameter=0,
			bore_diameter=hs_id-1,
			circles=0
		// 	backlash=0,
		// 	twist=0,
			// involute_facets=0
		);
		translate([0, 0, -0.1])
		draft_cylinder(r=hs_id/2, h=rim_thickness+0.2);
	}
}	

bldc_max_rpm = 990;
mower_or = 180;
hs_max_rpm = bldc_max_rpm*bldc_teeth/hs_teeth;
tip_speed_mmpm = hs_max_rpm*mower_or*2*PI;
tip_speed_fpm = tip_speed_mmpm/IN_MM/12;
 
module gearset() {
	bldc_gear();
	// hs_gear();
	translate([bldc_gear_pd/2 + hs_gear_pd/2, 0, 0]) {
		rotate([0, 0, hs_rotation]) {
			hs_gear();
		}
	}
}


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
	//translate ([0,0,pitch_apex1+20])
	//{
		translate([0,0,-pitch_apex1])
		ring_gear(use_stl);
	
		
		rotate([0,-(pitch_angle1+pitch_angle2),0])
		translate([0,0,-pitch_apex2])
		rotate([0, 0, 360 / gear2_teeth / 2])
		hs_gear2(use_stl || true);
	//}
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
			bevel_gear (
				number_of_teeth=gear1_teeth,
				cone_distance=cone_distance,
				pressure_angle=30,
				outside_circular_pitch=bevel_cp,
				bore_diameter=bldc_od-1,
				gear_thickness=ring_gear_thickness,
				face_width=20,
				finish=2);
			translate([0, 0, -ring_gear_thickness - 3])
				draft_cylinder(r=bldc_od/2, h=ring_gear_thickness+1, center=false, draft_angle=2, invert=true);
			
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
				face_width=20,
				finish=0);
			# translate([0, 0, -0.1])
				draft_cylinder(r=hs_id/2, h=20+0.2, invert=true);
		}
	}
}

// bevel_gear (
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
// {


module plate() {
	* bldc_hub();
	% translate([0, 0, 30])
		gearset2 (false);
	translate([0, 0, 12])
		ring_gear(true);
	hs_gear2(true);
	/*
	*% for(i=[-1, 1]) translate([0, 0, i*rim_thickness])
		gearset();
	gearset();
	echo(
		rim_thickness=rim_thickness,
		bldc_max_rpm=bldc_max_rpm,
		bldc_teeth=bldc_teeth,
		hs_teeth=hs_teeth,
		ratio=bldc_teeth/hs_teeth,
		hs_max_rpm=hs_max_rpm,
		mower_or=mower_or,
		tip_speed_mps=tip_speed_mmpm/60/1000,
		tip_speed_fpm=tip_speed_fpm,
		tip_speed_mph=tip_speed_fpm * 60 / 5280
	);*/
}
plate();