axis_dia = 12;
connector_width = 20;
connector_height = 2;
connector_length = 177;
base_height = 8;
bearing_d1 = 30;
bearing_d2 = 55;
bearing_h = 11;

module center_top() {
	difference() {
		union() {
			difference() {
				cylinder(r=50, h=base_height);
				for (rotation = [0,120,240]){
					rotate(rotation)
						translate([0,68,-1])
							cylinder(r=38,h=12);
				}
				rotate(60)
					for (rotation = [0,120,240]){
						rotate(rotation) {
							translate([0,40,base_height-connector_height/2])
								cube([connector_width,40,2.05],center=true);
							translate([0,42,-1])
								cylinder(r=1.5,h=base_height+2);
							translate([0,28,-1])
								cylinder(r=1.5,h=base_height+2);
						}
					}
			}
			cylinder(r1=axis_dia*2,r2=axis_dia, h=15);
		}
		translate([0,0,-1])
			cylinder(r=axis_dia/2,h=100);
	}
}


module center_middle_cover(axis_d) {
	difference() {
		union() {
			translate([0,0,bearing_h])
				cylinder(r=60, h=2);
			translate([0,0,bearing_h+2])
				cylinder(r1=60,r2=bearing_d1/2, h=4);
			rotate(60)
				for (rotation = [0,120,240]){
					rotate(rotation) {
						translate([0,50,bearing_h])
							cylinder(r=4,h=4);
						translate([0,40,bearing_h])
							cylinder(r=4,h=4);
					}
				}
		}
		for (rotation = [0,120,240]){
					rotate(rotation)
						translate([0,80,bearing_h-0.05])
							cylinder(r=45,h=16);
		}
		rotate(60)
			for (rotation = [0,120,240]){
				rotate(rotation) {
					translate([0,50,-1])
						cylinder(r=1.5,h=base_height+10);
					translate([0,40,-1])
						cylinder(r=1.5,h=base_height+10);
				}
			}
		cylinder(r=axis_d/2,h=100);
	}
}


module center_middle(axis_d) {
	difference() {
		union() {
			difference() {
				union() {
					cylinder(r=60, h=bearing_h);
					
				}
				for (rotation = [0,120,240]){
					rotate(rotation)
						translate([0,80,-1])
							cylinder(r=45,h=16);
				}
				rotate(60)
					for (rotation = [0,120,240]){
						rotate(rotation) {
							translate([0,50,bearing_h])
								cube([connector_width,40,6],center=true);
							translate([0,50,-1])
								cylinder(r=1.5,h=base_height+2);
							translate([0,40,-1])
								cylinder(r=1.5,h=base_height+2);
						}
					}
			}
			
		}
		translate([0,0,-0.05])
			cylinder(r=axis_d/2,h=bearing_h+0.1);
	}
}

module connectors(){
	rotate(60)
		for(rotation=[0,120,240]){
			rotate(rotation)
				translate([0,120,bearing_h-connector_height+1])
					cube([connector_width,connector_length,2],center=true);
		}
}

module wings(){
	rotate(60)
		for(rotation=[0,120,240]){
			rotate(rotation)
				translate([0,0,-350])
						linear_extrude(height = 550, twist=120) 
								translate([100,160,0])
									rotate(70)
										import("lenz_profile.dxf");	
		}
}

module axis(){
	translate([0,0,-800]){
		difference() {
			cylinder(h=800,r=30/2);
			translate([0,0,-0.1])
				cylinder(h=801,r=30/2-3);
			}
		cylinder(h=830,r=axis_dia/2);
	}
}

rotate(20){
	color([1,0,1])
		center_middle_cover(axis_dia*3);
	center_middle(axis_dia);
	color([0,1,0,0.5])
		connectors();
}

rotate(60){
	translate([0,0,-190]){
		center_middle(bearing_d2);
		color([1,0,1])
			center_middle_cover(bearing_d1+2);
		color([0,1,0,0.5])
			connectors();
	}
}

wings();
color([0,1,0,0.5])
	axis();


