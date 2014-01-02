axis_dia = 12;
connector_width = 20;
connector_height = 2;
connector_length = 200;
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


module center_middle_cover() {
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
		cylinder(r=bearing_d1/2,h=100);
	}
}

module center_middle() {
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
			cylinder(r=bearing_d2/2,h=bearing_h+0.1);
		cylinder(r=bearing_d1/2,h=100);
	}
}

module connectors(){
	rotate(60)
		for(rotation=[0,120,240]){
			rotate(rotation)
				translate([0,120,base_height-connector_height+1])
					cube([connector_width,connector_length,2],center=true);
		}
}

module wings(){
	rotate(60)
		for(rotation=[0,120,240]){
			rotate(rotation)
				translate([0,190,-350])
					cylinder(h=550,r=40);
		}
}

center_top();
color([0,1,0])
	connectors();

translate([0,0,-190]){
	center_middle();
	color([1,0,1])
		center_middle_cover();
	color([0,1,0])
		connectors();
}

wings();

translate([0,0,-800])
	cylinder(h=800,r=30/2);
