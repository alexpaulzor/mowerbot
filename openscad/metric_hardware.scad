include <constants.scad>;

module m_nut(ir, or, h) {
	difference() {
		cylinder(r=or, h=h, center=true, $fn=6);
		cylinder(r=ir, h=h, center=true);
	}

}

module m3_nut() {
	nut(3/2, m3_nut_or, m3_nut_h);
}

module m4_nut() {
	nut(4/2, m4_nut_or, m4_nut_h);
}

module m5_nut() {
	nut(5/2, m5_nut_or, m5_nut_h);
}

module m6_nut() {
	nut(6/2, m6_nut_or, m6_nut_h);
}