m3_nut_or = 6.1 / 2;
m3_nut_h = 2.5;

m4_nut_or = 7.7 / 2;
m4_nut_h = 3.2;

m5_nut_or = 8.8 / 2;
m5_nut_h = 4.7;

m6_nut_or = 11.1 / 2;
m6_nut_h = 5.2;

module m_nut(ir, or, h) {
	difference() {
		cylinder(r=or, h=h, center=true, $fn=6);
		cylinder(r=ir, h=h, center=true);
	}

}

module m3_nut() {
	m_nut(3/2, m3_nut_or, m3_nut_h+0.1);
}

module m4_nut() {
	m_nut(4/2, m4_nut_or, m4_nut_h+0.1);
}

module m5_nut() {
	m_nut(5/2, m5_nut_or, m5_nut_h+0.1);
}

module m6_nut() {
	m_nut(6/2, m6_nut_or, m6_nut_h+0.1);
}