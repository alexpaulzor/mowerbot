include <constants.scad>;

module m3_nut() {
	difference() {
		cylinder(r=m3_nut_or, h=m3_nut_h, center=true, $fn=6);
		cylinder(r=3/2, h=m3_nut_h, center=true);
	}

}