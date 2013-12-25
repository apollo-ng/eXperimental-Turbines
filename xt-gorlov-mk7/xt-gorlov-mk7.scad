use <naca4.scad>

//---------------------------------------------------------------------------------------------------
// NACA 4-digit fully parametric Helical Vertical Axis (Gorlov) Wind Turbine (mk7)
// Copyright 2011. Author: Quentin Harley (qharley)
// This derivative design is licensed under GPLv2.
//
// To make a funtional turbine you need to print at least the base and top sections, and as many atomic sections as you like, 
// taking the stability of your support rod into account.  The length of your turbine will increase by (hx_length / 3) for every 
// atomic section added.  For a constant torque turbine, you need 2+(3n) atomic sections.

// Be careful not to be too agressive with camber.  A recent study has shown that a very low camber of 2 may assist in self starting,
// but that the efficiency of the turbine is optimal at a camber of Zero.  The foil profile used in the study was NACA2415.
// I would therefore recommend to use a different starting mechanism. 

// This iteration incorporates a parametric Savonius turbine for starting.  
// to optimise the savonius turbine, the scoops should be two time as high as its diameter,
// and should overlap by 15 to 30% of the diameter


//************************************************
//* Global parameters for the Turbine below...                       *
//************************************************

Length 		= 150;		// Maximum build hight for the components
Base 			= 60;		// blade width
Radius 			= 95;		// Support Radius

Camber 		= 0;		// Negative Camber creates inwards force on the blades at speed.
Position 		= 0;		// Position has no influence if Camber is Zero
Thickness 		= 18;		// Thickness of profile

Guide_hole 	= 4;		// mm Diameter of the guide hole in the blade

Reinforcement	= 0;		// 1 to add reinforcement, 0 for solid blade
GapSize		= 0.08;

Support_Tabs 	= 0;		// 1 to enable printing support tabs for raftless printing.
Support_Ring 	= 1;		// 1 to enable printing support ring
Tab_Thickness 	= 0.35;		// Tab thickness in mm




Savonius_Starter = 0;	// 1 to use a savonius turbine to facilitate starting.  Starter will be situated in the Top section.

/*  	Select module:
	
	Assembled 				= 1
	Atomic with support		= 2
	Atomic without support	= 3
	Turbine Base				= 4	
	Turbine Top				= 5
	Savonius only				= 6
	Base and 3 Atoms			= 7
	Atomic, inverted no shaft = 8
*/

Module = 4;

// *****************************Modules************************************

if (Module == 1){
	Turbine_Assembled();
} 

if (Module ==2){
	helical_wing_atomic(	ha_length = Length, ha_base = Base, ha_radius = Radius, ha_support = 8.01);
}

if (Module ==3) {
	//*** Extention Module No support arm
	helical_wing_atomic_no_support(	ha_length = Length, ha_base = Base, ha_radius = Radius, ha_support = 8.01);
}

if (Module ==4){
	//*** Turbine Base - placed for printing
	helical_wing_base(hb_length = Length, hb_base = Base, hb_radius = Radius);
}

if (Module ==5){
//*** Turbine Top, placed upside down for printing.
	translate([0,0,Length])	
		rotate([0,180,0])
			helical_wing_top(ht_length = Length, ht_base = Base, ht_radius = Radius);
}

if (Module == 6){
	Savonius_Module(hs_length = Length, hs_overlap = 0.30, hs_thickness = 2);
} 

if (Module == 7){
	Turbine_Base_n_atoms();
} 

if (Module == 8){
	difference(){
		translate([0,0,Length])
			rotate([0,180,0])
				helical_wing_atomic_no_support(	ha_length = Length, ha_base = Base, ha_radius = Radius, ha_support = 8.01);	
		translate([0,0,-1])	
			cylinder(r= Radius / 2, h=Length + 2);
	}
			
}

//******************************************************************

//wing_support(Radius,8);

module helical_wing(h_length, h_base,h_radius,h_twist = -60, tab_position =1, guide_hole = 3, Tabs = 0) { 
	linear_extrude(height = h_length, convexity = 10, twist = h_twist,$fn=100) 
		translate([-h_base/2,h_radius,0])
			scale([h_base,h_base,1])
				difference(){
					airfoil(Camber,Position,Thickness);
					if (Reinforcement) {						// Conditional reinforcement
						union(){
							translate([-.01,0,0])	
								scale([1.01,1,1])
									airfoil(Camber,Position,GapSize*100/h_base);
								translate([.25,-.5,-.5])
									square([GapSize/h_base,1]);
								translate([.5,-0.5,-.5])
									square([GapSize/h_base,1]);
								translate([.75,-0.5,-.5])
									square([GapSize/h_base,1]);
						}
					}
					translate([.25,0.00875*Camber,0])
						circle(guide_hole/2/h_base, $fn=20);
				}
	if (Tabs){
		if (tab_position == 1){	
			translate([h_base/2.2+5,h_radius,0])
				cylinder (r=10, h=Tab_Thickness, $fn=20);
			translate([h_base/2.2-50,h_radius,0])
				cylinder (r=10, h=Tab_Thickness, $fn=20);
		}
		else {
			rotate([0,0,-h_twist])
				translate([h_base/2.2,h_radius,h_length-Tab_Thickness])
					cylinder (r=10, h=Tab_Thickness, $fn=20);
		}
	}
}

module helical_wing_atomic(ha_length, ha_base, ha_radius, ha_twist=-60, ha_support = 8.01) {
	difference() {
		union() {
			cylinder(h = ha_length / 3, r = ha_support);
			helical_wing(ha_length, ha_base, ha_radius, ha_twist, guide_hole = Guide_hole);
			wing_support(ha_radius,ha_support);
		}
		translate([0,0,-1])
			cylinder(h = ha_length / 3+2, r = ha_support/2);
	}
}

module helical_wing_atomic_no_support(ha_length, ha_base, ha_radius, ha_twist=-60, ha_support = 8.01) {
	difference() {
		union() {
			cylinder(h = ha_length / 3, r = ha_support);
			helical_wing(ha_length, ha_base, ha_radius, ha_twist, guide_hole = Guide_hole);
		}
		translate([0,0,-1])
			cylinder(h = ha_length / 3+2, r = ha_support/2);
	}
}

module wing_support(hs_radius, hs_support){
	translate([-hs_support,0,hs_support / 10])
		union(){

			minkowski(){
				cube(size = [hs_support*2,  hs_radius, (hs_support / 5)]); 
				rotate([90,0,0])
					cylinder(r=hs_support/10, $fn=12);
			}
			
			translate([hs_support/4,hs_radius-(hs_support*(0.4+Camber*-.05))-1.5,hs_support/5])	
			    	minkowski(){
					cube([hs_support*1.5, hs_support / 8, hs_support/8]);
					sphere(r=hs_support/5, $fn=12);
				}
		}
}


module helical_wing_base(hb_length, hb_base, hb_radius, hb_twist=-60, hb_support = 8.01) { 
	difference(){
		cylinder(r=hb_radius*1.07, h=Tab_Thickness);
		translate([0,0,-Tab_Thickness]){
			cylinder(r=hb_radius*0.95, h=Tab_Thickness*3);
		}
	}
	helical_wing(hb_length, hb_base, hb_radius, h_twist = hb_twist, guide_hole = Guide_hole, Tabs = Support_Tabs);
	rotate([0,0,120])
		helical_wing(hb_length/3*2, hb_base, hb_radius, h_twist = hb_twist/3*2, guide_hole = Guide_hole, Tabs = Support_Tabs);
	rotate([0,0,240])
		helical_wing(hb_length/3, hb_base, hb_radius, h_twist = hb_twist/3, guide_hole = Guide_hole, Tabs = Support_Tabs);
	
	 difference(){
	    	union(){

			for (wing_a = [0,120,240]){
				rotate([0,0,wing_a])
					wing_support(hb_radius,hb_support);
			}
			
			cylinder(h = hb_length / 3, r = hb_support);
		
			translate([0,0,hb_support/5.25])
				minkowski(){
					cylinder(h = hb_length / 10, r = hb_support * 1.5);
					//rotate([90,90,0])
							sphere(r=hb_support/5, $fn=10);
				}
		}
	    	
		translate([0,0,-1])
			cylinder(h = (hb_length / 3)+2, r = hb_support/2);
		translate([0,0,5])	
			rotate([0,180,0])
				cylinder(h = 6, r = 8, $fn=6);
				
	}

}

module helical_wing_top(ht_length, ht_base, ht_radius, ht_twist=-60, ht_support = 8.01) { 
	helical_wing(ht_length, ht_base, ht_radius, h_twist = ht_twist,tab_position =2, guide_hole = Guide_hole);
	rotate([0,0,-100])
		translate([0,0,ht_length/3])
			helical_wing(ht_length/3*2, ht_base, ht_radius, h_twist = ht_twist/3*2,tab_position =2, guide_hole = Guide_hole);
	rotate([0,0,-200])
		translate([0,0,ht_length/3*2])
			helical_wing(ht_length/3, ht_base, ht_radius, h_twist = ht_twist/3,tab_position =2, guide_hole = Guide_hole);

   translate([0,0,ht_length])
      rotate([0,180,60]) 
	difference(){
	   union(){
			wing_support(ht_radius,ht_support);

			rotate([0,0,120])
				wing_support(ht_radius,ht_support);

			rotate([0,0,240])
				wing_support(ht_radius,ht_support);

			translate([0,0,ht_support/5.25])
				minkowski(){
					cylinder(h = ht_length / 10, r = ht_support * 1.5);
						sphere(r=ht_support/5, $fn=10);
				}

			if (Savonius_Starter == 1){
				//rotate([0,0,-15])
					Savonius_Module(hs_length = ht_length, hs_overlap = 1.7, hs_thickness = 2);
			}
			else
			{
				cylinder(h = (ht_length), r = ht_support);
			}
		}
	   
		translate([0,0,-1])
			cylinder(h = (ht_length)+2, r = ht_support/2);
	   translate([0,0,5])	
			rotate([0,180,0])
				cylinder(h = 6, r = 8, $fn=6);
	    	
	}

}

module Savonius_Blade(sb_length, sb_thickness){
	// Savonius blade with set length and diameter of length / 2

	minkowski(){	
		difference(){
			cylinder(h=sb_length, r = sb_length / 4, $fn=50);
			translate([0,0,-1]){
				cylinder(h=sb_length + 2, r = (sb_length / 4) - 0.001, $fn=50);
				translate([-sb_thickness / 2,-sb_length / 4 -1,0 ])
					cube([sb_length / 4 + 2,sb_length / 2 + 2,sb_length + 2]);
			}
		}
		cylinder(r=sb_thickness / 2, $fn=12);
	}
	difference(){
			
		union(){
			cylinder(h=sb_thickness, r = sb_length / 4);
			translate([0,0,sb_length - sb_thickness/2])
				cylinder(h=sb_thickness, r = sb_length / 4);
		}
		translate([0,-sb_length / 4 -1,-1 ])
			cube([sb_length / 4 + 2,sb_length / 2 + 2,sb_length + 3]);
	}	
}

module Savonius_Module(hs_length, hs_overlap, hs_thickness){
	// Savonius Started module
	
	translate([0,(hs_length / 4) - (hs_length / 4 * hs_overlap),0])
		Savonius_Blade(sb_length = hs_length,sb_thickness = hs_thickness);
	rotate([0,0,180])
		translate([0,(hs_length / 4) - (hs_length / 4 * hs_overlap),0])
			Savonius_Blade(sb_length = hs_length,sb_thickness = hs_thickness);

}

module Turbine_Assembled(){
	//helical wing base
	helical_wing_base(hb_length = Length, hb_base = Base, hb_radius =Radius);

	// helical wing top
	translate([0,0,Length])
		rotate([0,0,60])
			helical_wing_top(ht_length = Length, ht_base = Base, ht_radius = Radius);

	//Helical wing atomic #1 demo
	rotate([0,0,-100])
		translate([0,0,Length/3])	
			helical_wing_atomic_no_support(	ha_length = Length, ha_base = Base, ha_radius = Radius, ha_support = 8);

	//Helical wing atomic #2 demo
	rotate([0,0,160])
		translate([0,0,Length/3*2])	
			helical_wing_atomic_no_support(	ha_length = Length, ha_base = Base, ha_radius = Radius, ha_support = 8);
}

module Turbine_Base_n_atoms(){
	//helical wing base
	helical_wing_base(hb_length = Length, hb_base = Base, hb_radius =Radius);

	//Helical wing atomic #1 demo
	rotate([0,0,-100])
		translate([0,0,Length/3])	
			helical_wing_atomic_no_support(	ha_length = Length, ha_base = Base, ha_radius = Radius, ha_support = 8);

	//Helical wing atomic #2 demo
	rotate([0,0,160])
		translate([0,0,Length/3*2])	
			helical_wing_atomic_no_support(	ha_length = Length, ha_base = Base, ha_radius = Radius, ha_support = 8);

	//Helical wing atomic #3 demo
	rotate([0,0,60])
		translate([0,0,Length])	
			helical_wing_atomic_no_support(	ha_length = Length, ha_base = Base, ha_radius = Radius, ha_support = 8);
}
