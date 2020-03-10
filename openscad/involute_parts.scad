use <lib/lib_involute.scad>;
include <lib/motors.scad>;
include <lib/casting.scad>;

rim_thickness = bldc_hub_h/3;
pressure_angle = 28;

hs_teeth = 8;
bldc_teeth = 40;

bldc_gear_pd = 140;
bldc_gear_cp = bldc_gear_pd / bldc_teeth * 180;


gear1_teeth = bldc_teeth * 1;
gear2_teeth = hs_teeth * 1;
bevel_pd = 160;
bevel_cp = bevel_pd / gear1_teeth * 180;
ring_gear_thickness = 6;
bevel_face = 10;
ring_sleeve_width = 5;
hs_id = 7.7;
axis_angle = 90;

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
	

module gearset2(use_stl=false) {
	translate ([0,0,pitch_apex1 + bevel_face])
	{
		translate([0,0,-pitch_apex1])
			ring_gear(use_stl);

		rotate([0,-(pitch_angle1+pitch_angle2),0])
		translate([pitch_apex1*0,0,-pitch_apex2])
		rotate([0, 0, 360 / gear2_teeth / 2]) {
			hs_gear3(use_stl);
			% hs_gear3(true);
		}
	}
}

module ring_gear(use_stl=false) {
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

m8_nut_or = 15.3/2;
m8_nut_h = 5.5;
module m8_nut_draft() {
	draft_cylinder(r=m8_nut_or, h=m8_nut_h, center=true, draft_angle=-2, invert=false, fn=6);
}

module hs_gear3(use_stl=false) {
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
				draft_cylinder(r=hs_id/2, h=bevel_face-m8_nut_h + 0.2, draft_angle=2, invert=true);
			translate([0, 0, bevel_face-m8_nut_h/2]) 
				m8_nut_draft();
		}
	}
}

module gearbox() {
	% translate([0, 0, bldc_hub_h/2]) 
		bldc_hub();
	% gearset2 (true);
}

module design() {
	gearbox();
		
	// * translate([0, 0, ring_gear_thickness]) 
	// 	ring_sleeve(true);
	// ring_gear(false);
}
design();

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

module shell(or=10, ir=9, half=true) {
	difference() {
		sphere(or);
		sphere(ir);
		if (half)
			translate([0, 0, -or/2])
			cube([2*or, 2*or, or], center=true);
	}

}

module sprue3() {
	color("#330000cc") {
	translate([-23, 0, 0])
		difference() {
			translate([0, 0, 3/2])
				draft_cube([30, 5, 3], center=true);
			translate([0, 0, -0.1])
				draft_cylinder(r=1, h=3, draft_angle=15);
		}
	// translate([-65, 0, 3/2])
	// 	draft_cube([20, 5, 3], center=true);
	translate([23, 0, 0])
		difference() {
			translate([0, 0, 5/2]) 
				draft_cube([30, 5, 5], center=true);
			translate([0, 0, -0.1])
				draft_cylinder(r=1, h=3, draft_angle=15);
		}
	translate([45, 0, 0])
		shell(half=true);
	
	translate([-41, 0, 0])
		shell(or=5, ir=4, half=true);
	}
}

module cast_plate3() {
	scale(CAST_EXPANSION) {
		// translate([0, 0, bevel_face])
		// 	ring_gear(true);
		// for (i=[-1:1])
			// translate([i * 45, 0, 0])
			hs_gear3(false);
		% hs_gear3(true);			
		sprue3();
	}
	// % flask();
	
}
// cast_plate3();