/*
Probe tip spacers, for use with copper heating pipes
to make custom (and shielded) probe tips for old lab
equipment;

Copyrithgt By Atkelar, 2023, commercial rights reserved.
*/

// Show the "end cap" side element
ShowCap = true;

// Show the "sprint retainer" side element
ShowRetain = true;

// Tube inner diameter
InnerDiameter = 13.0;   // 0.01
// Tube outer diameter
OuterDiameter = 15.0;   // 0.01

// Diameter of the spring for the end cap
SpringDiameter = 7.3;   // 0.01

// The height of the retainer ring
RetainerHeight = 12;   // 0.01

// The slit in the retainer ring.abs
RetainerSlit = 1;   // 0.01

// The exposed height of the probe tip
TipHeight = 12;   // 0.01

// The diameter of the hole for the probe tip (usually inner diameter for a thread)
TipHole = 4.2;   // 0.01

// Outer diameter of the probe tip
TipDiameter = 6;   // 0.01

// the "sunken" part of the tip for mounting surface.
TipSleeveHeight = 12;   // 0.01


module ProbeCap()
{
    difference()
    {
        union()
        {
            cylinder(h = TipSleeveHeight, d = InnerDiameter);
            translate([0,0,TipSleeveHeight-$t])
                cylinder(d1 = OuterDiameter, d2 = TipDiameter, h = TipHeight);
        }
        translate([0,0,-$t])
            cylinder(h = TipSleeveHeight + TipHeight + 2*$t, d = TipHole);
    }
}

module ProbeRetainer()
{
    difference()
    {
        cylinder(h = RetainerHeight, d = InnerDiameter);
        translate([$t,-RetainerSlit / 2, -$t])
            cube([InnerDiameter / 2,RetainerSlit,RetainerHeight + 2*$t]);
        translate([0,0,-$t])
            cylinder(d = SpringDiameter, h = RetainerHeight + 2*$t);
    }
}

$t = 0.01;  // overlap for shapes to avoid visual artifacts.
$fn = 80;   // quality (# of faces on curved objects)

// distance between elements
$dist = (ShowCap && ShowRetain) ? OuterDiameter : 0;

if (ShowCap)
    translate([-$dist, 0, 0])
        ProbeCap();

if (ShowRetain)
{
    translate([$dist, 0,0])
        ProbeRetainer();
}
