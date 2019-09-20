draft_angle = 3;

module draft_cube(dims, center=false, draft_angle=draft_angle, invert=false) {
    translate(center ? [0, 0, 0] : -dims/2)
        rotate(invert ? [180, 0, 0] : [0, 0, 0])
		_draft_cube(dims, draft_angle=draft_angle);
	
}

module _draft_cube(dims, draft_angle=draft_angle) {
	draft_dims = [
		dims[0] - dims[2] * sin(draft_angle),
		dims[1] - dims[2] * sin(draft_angle),
		dims[2]];
	hull() {
        translate([0,0,-dims[2]/2])
		cube([dims[0], dims[1], .1], center = true);
		translate([0,0,dims[2]/2])
			cube([draft_dims[0], draft_dims[1], .1], center = true);
	}
}

module draft_cylinder(r=1, h=1, center=false, draft_angle=draft_angle, invert=false) {
	if (!center) {
		translate([0, 0, h/2])
		_draft_cylinder(r=r, h=h, draft_angle=draft_angle, invert=invert);
	} else {
		_draft_cylinder(r=r, h=h, draft_angle=draft_angle, invert=invert);
	}
}

module _draft_cylinder(r=1, h=1, draft_angle=draft_angle, invert=false) {
	draft_r = r - h * sin(draft_angle);
	rotate([invert ? 180 : 0, 0, 0])
	cylinder(r1=r, r2=draft_r, h=h, center=true);
}
/*

module draft(h, draft_angle=3) {
    hull() {   
        translate([0, 0, h/2])
            scale([1.01, 1.01, 0.01])
                children();
        * translate([0, 0, -h/2])
            scale([1, 1, 0.01])
            children();
    }
}*/

module sprue(d=10, a=30, h=10, w=2) {
    difference() {
        draft_cube([d+2*w, d+2*w, h], center=true, draft_angle=a, invert=true);
        draft_cube([d, d, h], center=true, draft_angle=a, invert=true);
        
        # for (i=[0:3])
            rotate([0, 0, i*90])
            translate([0, (d - h * sin(a)) / 2 + w/2, -h/2 + 1/2])
            draft_cube([d - h * sin(a) + w*1.5, w/2, 1], draft_angle=2*a, center=true);
    }
    for (i=[0:3])
        rotate([0, 0, i*90])
        translate([0, (d+w)/2, h/2 + 1/2])
        draft_cube([d + 1.5*w, w/2, 1], draft_angle=2*a, center=true);
        
}

module sprue_stack() {
    h = 10;
    a = 30;
    d = 15;
    w = 2;
    for (i=[0:7]) {
        sprue(d=d + i * h*sin(a), a=a, h=h, w=w);
        % translate([0, 0, i*h])
            sprue(d=d + i * h*sin(a), a=a, h=h, w=w);
    }
}

sprue_stack();