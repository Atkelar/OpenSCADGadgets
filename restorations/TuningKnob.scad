/*

A module that creates a "knob". The style is similar to fasteners that might be found on mechanical equipment, but the base is suitable for potentiometers and similar applications. The design came about because of a restoration project that used this style of knob and had to be remade. Parameterization includes all the diameters, see the parameter list for a quick description.

File is Copyright 2022 by Atkelar; free for non-commercial use - please share any improvements or suggestions!

*/

$fn = 80;
xTolerance = 0.1;   // grow/shrink to make the model fit when needed.

module TuningKnob(
    dBase = 20,     // the base (stem) diameter
    hBase= 15,      // the length of the base (stem)
    dTop = 50,      // the outer diameter of the top part
    hTop = 18,      // the height of the top part
    dAxle = 6,      // the diameter of the axle (6 or 4mm?)
    dScrew = 2.5,   // the diameter for the screw-holes (2.5 ~ M3)
    dGrip = 30,     // the diameter for the grip notches
    gSmooth = 0.4,  // the offset multiplier for the notches (about 0.4-ish should work)
    gCount = 8      // the number of grip notches around the top part.
    )
{
    difference()
    {
        union()
        {
            difference()
            {
                translate([0,0,(hBase + hTop /2 )-xTolerance])
                    difference()
                    {
                        scale([1,1,(hTop / dTop) * 2])
                            sphere(d = dTop);
                        translate([-dTop/2, -dTop/2,hTop/2])
                            cube([dTop, dTop, hTop]);
                        translate([-dTop/2, -dTop/2,-3*hTop/2])
                            cube([dTop, dTop, hTop]);
                        translate([0,0,dTop * 1.09])
                            sphere(d = 2 * dTop);
                    }
            }
            translate([0,0,hBase*1.5])
                sphere(d = dBase);
            cylinder(d = dBase, h= hBase); // base with screw holes
        }
        union() // "drill" the holes on the base
        {
                for(i=[0:gCount-1])
                {
                    rotate([0,0,i * (360/gCount)])
                    translate([0,dTop / 2 + dGrip * gSmooth,0])
                        cylinder(h = hBase + hTop, d = dGrip);
                }
            translate([0,0,-xTolerance])
                cylinder(d = dAxle + xTolerance, h = hBase);
            translate([0,0,hBase / 2])
                rotate([0,90,0])
                    cylinder(d = dScrew + xTolerance, h = dBase);
            translate([0,0,hBase / 2])
                rotate([90,0,0])
                    cylinder(d = dScrew + xTolerance, h = dBase);
        }
    }
}

TuningKnob();
