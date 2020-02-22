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

% bldc_hub();
rim_thickness = bldc_hub_h;
pressure_angle = 28;

bldc_teeth = 40;
bldc_gear_pd = 175; //bldc_od + 50;
bldc_gear_cp = bldc_gear_pd / bldc_teeth * 180;
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
				bore_diameter=bldc_od/2,
				circles=0
			// 	backlash=0,
			// 	twist=0,
				// involute_facets=0
			);
			# draft_cylinder(r=bldc_od/2, h=rim_thickness);
		}
	}
}

hs_teeth = 8;
hs_gear_cp = bldc_gear_cp;
// hs_gear_cp = hs_gear_pd / hs_teeth * 180;
hs_gear_pd = hs_gear_cp * hs_teeth / 180;
hs_id = 8;



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
			bore_diameter=hs_id/2,
			circles=0
		// 	backlash=0,
		// 	twist=0,
			// involute_facets=0
		);
		draft_cylinder(r=hs_id/2, h=rim_thickness);
	}
}	

bldc_max_rpm = 990;
mower_or = 180;
hs_max_rpm = bldc_max_rpm*bldc_teeth/hs_teeth;
tip_speed_mmpm = hs_max_rpm*mower_or*2*PI;
tip_speed_fpm = tip_speed_mmpm/IN_MM/12;
 

echo(
	bldc_max_rpm=bldc_max_rpm,
	bldc_teeth=bldc_teeth,
	hs_teeth=hs_teeth,
	ratio=bldc_teeth/hs_teeth,
	hs_max_rpm=hs_max_rpm,
	mower_or=mower_or,
	tip_speed_mps=tip_speed_mmpm/60/1000,
	tip_speed_fpm=tip_speed_fpm,
	tip_speed_mph=tip_speed_fpm * 60 / 5280
);

module plate() {
	bldc_gear();
	hs_gear();
	% translate([bldc_gear_pd/2 + hs_gear_pd/2, 0, 0]) {
		rotate([0, 0, 360/hs_teeth/2]) {
			hs_gear();
		}
	}
}
plate();