/*

Capacitor clamp script. Based on a clamp found in a Philips 1542 power supply, coded by Atkelar in 2022. Free to use in non-commercial manners, please consider putting a bit in my Ko-Fi account over here https://ko-fi.com/atkelar if you like it! Thanks!

Two equal clamps are needed. They are going to grip the capacitor and lock it in place when put into a square hole for each.

The "show use" option will print out measurements for the hole pattern, which can be seen as such:

    +--+            +--+ <----
    |  |            |  |     |
    |  |<-distance->|  |   width
    |  |            |  |     |
    +--+            +--+ <----
    ^--^ height
*/

/* [Tab] [Sizes] */

// Outer diameter of the capacitor, in mm.
dCapacitor = 40;

// Thickness (or height) of the clamp band, in mm.
hClamp = 8;

// Width of the tab for the mounting clip. Make sure the actual hole is ever so slightly larger!
wTab = 12;

// Height of the tab (hole) for the mounting clip. Make sure the actual hole is ever so slightly larger!
hTab = 6;

// Thickness of the sheet metal that holds the clip
hSheet = 1;

// Height of the capacitor in mm. used for visualization and hole computation.abs
hCapacitor = 75;


// Show the applied use; Read debug output for hole pattern description.
showUse = true;

/* [Tab] [Tuning (advanced)] */

// Percentage to "shrink" the clamp around the capacitor to provide "springiness". Default 2.5 will cause 39mm clamp for 40mm capacitor.
pSpring = 2.5; 

// Percentage for the standard wall thickness, measured against the height of the band.
pThickness = 20;

// Percentage for the "inset" or "lip" that will hold the capacitor and prevent sliding out. Measured against the capacitor diameter.
pInset = 5;

// resolution (higher = smoother, I go with 80 usually)
$fn=80; // [20:10:100]

module Holder(dmajor, hnorm, dinset, wwall, wtab, htab, hsheet, dminor, wback)
{
    difference()
    {
        union() // raw, full outline.
        {
            hull()
            {
                cylinder(h=hnorm, d=dmajor + 2*wwall);
                translate([-wback/2,2*wwall,0])
                    cube([wback, dmajor/2, hnorm]);
            }
            translate([-wtab / 2, dmajor/2 + wwall + hsheet,hnorm-htab])
                cube([wtab, wwall + hsheet + 0.1, 10]);
        }
        translate([-wtab / 2 *1.1, dmajor / 2 + wwall*2+hsheet, hnorm-hTab])
            rotate([-45,0,0])
                cube([14,5,5]);
        translate([0,-1,-0.5])
            cylinder(d=dinset, h=hnorm+1);
        translate([0,0,wwall])
            hull()
            {
                cylinder(d=dmajor, h=hnorm+1);
                translate([0,dmajor*0.1,0])
                    cylinder(d=dminor, h=hnorm+1);
            }
        translate([-dinset/2,-dmajor / 2,-.5])
            cube([dinset, dmajor / 2, hnorm+1]);
        translate([-(dmajor / 2 + wwall*1.1), -(dmajor / 2 - hSheet), hnorm])
            cube([dmajor+wwall*2.2,dmajor+wwall*2, hnorm]);
        translate([0,dmajor * 0.25,-0.5])
            rotate([0,0,-135])
                cube([dmajor,dmajor, hnorm+1]);
    }
}

module Sheet(width, height, thick, wtab, htab, yoffset, hnorm, dist)
{
    echo(str("Holes are supposed to be ", wtab, "mm wide and ", htab, "mm heigh, with an inner distance of ", dist, "mm"));
    
    
    difference()
    {
        translate([-width/2,yoffset ,-height/4]) // align the back end with 0 Y so the test-sheet can align easily.

            cube([width, thick, height]);
        translate([-wtab/2,yoffset-0.1,hnorm-htab])
            cube([wtab,thick+0.3,htab]);
        translate([-wtab/2,yoffset-0.1,hnorm+dist])
            cube([wtab,thick+0.3,htab]);
    }
}

dminor = dCapacitor * 0.923076923;
wback = dCapacitor * 0.717948718;

Holder(dCapacitor, hClamp, dCapacitor / (1+(pInset / 100)), hClamp * (pThickness / 100), wTab, hTab, hSheet, dminor, wback);

if (showUse)
{
    
    color("gray", 0.2)
    translate([0,0,hCapacitor + hClamp * (pThickness / 100)*2])
        rotate([0,180,0])
    Holder(dCapacitor, hClamp, dCapacitor / (1+(pInset / 100)), hClamp * (pThickness / 100), wTab, hTab, hSheet, dminor, wback);
    color("blue", 0.2)
        translate([0,0,hClamp * (pThickness / 100)])
            cylinder(d = dCapacitor, h = hCapacitor);

    color("white", 0.4)
        Sheet(hCapacitor*2, hCapacitor * 2, hSheet, wTab, hTab, dCapacitor / 2 + hClamp * (pThickness / 100) *2, hClamp, hCapacitor - hClamp * (pThickness / 100) * 2-hTab * 2  );
}