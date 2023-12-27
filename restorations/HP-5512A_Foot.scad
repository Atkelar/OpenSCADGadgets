
/*

HP 5512A (and similar cases) foot replacement.

NOTES

The original was also featuring a small "edge" or "lip" on the bottom so you could stack devices. 

It also featured a spring loaded button that locked into the center part.

This simple replacement is "friction fit" which means that you might need to "tune" it with a small file or sandpaper, so print one at first and see if and where it is too tight based on your printer.abs


*/

$fn = 40;

module Clamp()
{
    translate([0,0,1.6])
        cube([4.5,9,10], center=true);
    // 1.5mm sheet metal...
    translate([2.5/2,0,6])
        cube([7,9,2], center=true);
}

module Foot()
{
    
    union()
    {
        difference()
        {
            cube([40,40,7], center=true);
            translate([0,0,2])
                cube([36,36,5], center=true);
        }
        // 30.5  20.6
        translate([0,5.0,0])
            difference()
            {
                cylinder(h=6.9, d=6, center=true);
                translate([0,0,3])  
                        cylinder(h=6.9, d=2.5, center=true);
            }
        translate([12.7,3.5,0])
            Clamp();
        scale([-1,1,1])
            translate([12.7,3.5,0])
                Clamp();
    }
}



Foot();

//color("blue") translate([0,0,4]) cube([30.5,1,1], center=true);
