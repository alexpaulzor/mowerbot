// $fn = max($fn, 32);

draft_angle = 2;

// Aluminium = 2% shrinkage during solidification
CAST_EXPANSION = 1.02;
FLASK_SIZE = [7.5, 7.5, 3.5] * 25.4; // 3.5 inches

module flask() {
    color("#00330066") {
        translate([0, 0, FLASK_SIZE[2]/2])
            cube(FLASK_SIZE, center=true);
    }
}

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

module draft_cylinder(r=1, h=1, center=false, draft_angle=draft_angle, invert=false, fn=1000, face_draft=0) {
	if (!center) {
		translate([0, 0, h/2])
		_draft_cylinder(r=r, h=h, draft_angle=draft_angle, invert=invert, fn=fn, face_draft=face_draft);
	} else {
		_draft_cylinder(r=r, h=h, draft_angle=draft_angle, invert=invert, fn=fn, face_draft=face_draft);
	}
}

module _draft_cylinder(r=1, h=1, draft_angle=draft_angle, invert=false, fn=1000, face_draft=0) {
    draft_r = r - h * sin(draft_angle);
	draft_h = h + 2*abs(r * sin(face_draft));
    // echo(draft_angle=draft_angle, face_draft=face_draft, h=h, draft_h=draft_h, r=r, draft_r=draft_r);
    intersection() {
        rotate([invert ? 180 : 0, 0, 0])
	       cylinder(r1=r, r2=draft_r, h=draft_h, center=true, $fn=min(fn, 8*r));
        if (face_draft != 0) 
            rotate([-90, 0, 0])
            draft_cube([3*r, h, 3*r], center=true, draft_angle=face_draft);
    }
}

module shell(or=10, ir=9, half=true) {
    difference() {
     sphere(or);
     sphere(ir);
     if (half)
         translate([0, 0, -or/2])
         cube([2*or, 2*or, or], center=true);
    }
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

sprue_h = 10;

module _sprue_notch(d, h, w, ext=0) {
    for (i=[0:3])
        rotate([0, 0, i*90])
        translate([0, d/2 + w/6, 0])
        rotate([0, 90, 0]) {
            cylinder(r=w/4, h=d + w/3 + ext, center=true);
            translate([0, w/5*0, d/2 + w/6]) 
                sphere(r=w/4);
        }
        //draft_cube([d + 1.5*w, w/2, 1], draft_angle=2*a, center=true);
}

module sprue(d=20, h=sprue_h, w=4, closed=false) {
    top_d = d + 4*w;
    a = -atan2(top_d - d, h);
    difference() {
        draft_cube([top_d, top_d, h], center=true, draft_angle=-a, invert=true);
        draft_cube([d, d, h], center=true, draft_angle=a, invert=false);
        
        translate([0, 0, -h/2 + w/6]) 
            _sprue_notch(d, h, w, w*4);
    }
    translate([0, 0, h/2 + w/6])
        _sprue_notch(d + 2*w, h, w);
    * if (closed)
        translate([0, 0, -h/2 + 1/2])
        draft_cube([d, d, 1], center=true, draft_angle=a, invert=false);
        
}

module sprue_stack(count=6, stacks=2, dz=sprue_h, count_start=0) {
    h = 12;
    
    d = 20;
    w = 4;
    for (i=[count_start:count-1]) {
        translate([(i + 2) % stacks * 80, 0, i*dz])
            sprue(d=d + i * 2*w, h=h, w=w, closed=false && (i < stacks-1));
    }
}

module sprue_plate(count=5, stacks=2) {
    sprue_stack(count=count, stacks=stacks, dz=0, count_start=0);
}


// sprue_stack(2, dz=15);