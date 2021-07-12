/*

Replacement Commodore 1520 "RSB" (Roller Shaft Bracket)

Copyright 2021 by Atkelar, free for personal, non commercial use!

If you have any improvements, let me know via comment and/or pull request.

usage: The "FullRSB" module will render a full RSB model, as it is used on the "right" side of the plotter, when seen from the front.

The "HaflRSB" module takes a boolean parameter to indicate which half (left/right) to render (or which to "cut away") from the full model. This can be used to create matching halves that can be glued together to make it easier to remove the inner supports.abs

To indicate what part to render, you can use the RenderMode variable as follows:

    0 = right side, full
    1 = left side, full
    2 = right side, right half
    3 = right side, left half
    4 = left side, left half
    5 = left side, right half

The result might need some cleaning up, depending on the print quality, but the measurements are tested with PLA and work "OK". I didn't parameterize the sizes, since it is supposed to be a drop in replacement for the existing (and possibly lost) ones.
*/

// use a high enough value to create "round" sections
$fn=50;

// Set the requested render mode
RenderMode = 0;



module FullRSB()
{
    union()
    {
        
        difference()
        {
            union() // base shape
            {
                cube([10,18,63]);
                translate([5,9,63])
                    rotate([0,90,0])
                    cylinder(d=18, h=10, center=true);
                translate([5+(1.5/2),9,63])
                    rotate([0,90,0])
                    cylinder(d=25, h=8.5, center=true);
                translate([6,9,63])
                    rotate([0,90,0])
                    cylinder(d=18, h=12, center=true);
            }
            rotate([35,0,0])    // angle
                translate([-1,0,-30])
                    cube([12,30,30], center=false);
            translate([3.5,0,49.7])
                rotate([35,0,0])
                    union()
                    {
                        cube([3,40,12],center=false);
                        translate([6,15,6])
                        rotate([0,90,0])
                        {
                            cylinder(d=8.2, h=10, center=true);
                            translate([-4.1,0,-5])
                            cube([8.2,20,30]);
                        }
                        
                    }
            difference()
            {
                translate([2.5,-2,0])
                    cube([5,18,55]);
                rotate([35,0,0])
                    translate([2,-8,-12.5])
                    cube([6,30,15]);
                translate([0,0,60])
                rotate([35,0,0])
                    translate([2,-12,-12.5])
                    cube([6,30,15]);
            }
            translate([0.5,0,60])
            {
                rotate([35,0,0])
                    translate([2,-20,-9.5])
                    cube([6,30,15]);
                    translate([5,10.3,4.8])
                rotate([0,90,0])
                    cylinder(d=15,h=6, center=true);
            }
        }
        rotate([35,0,0])    // mounting bracket
        {
            difference()
            {
                union()
                {
                    translate([3.85,0,-3.9])
                        cube([2.4,22,4], center=false);
                    translate([2.65,0,-9.55])
                        cube([4.75,22,6.9], center=false);
                }
                translate([0,-0.01,-9.65])
                    cube([10,3,3], center=false);
            }
        }
    }
}

module HalfRSB(left=true)
{
    difference()
    {
        FullRSB();
        if (left)
        {
            translate([5,-10,-30])
            cube([100,100,150]);
        }
        else
        {
            translate([-95,-10,-30])
            cube([100,100,150]);
        }
    }
}

if (RenderMode < 2)
{
    if (RenderMode <1)
    {
        FullRSB();
    } else {
        scale([-1,1,1])
            FullRSB();
    }
}
else
{
    if (RenderMode < 4)
    {
        HalfRSB(RenderMode > 2);
    } else {
        scale([-1,1,1])
            HalfRSB(RenderMode > 4);
    }
}
