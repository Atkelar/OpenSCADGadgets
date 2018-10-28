/*

Created by Atkelar, 2018-10-28

OpenSCAD cable spool holder assembly idea.

Design goals: 
Simple to cut and assemble from plywood or similiar material, hence going
for only straight cuts and joints that can be glued.

Just use a single simple crossbar (="pin") to hold the spool, resting in an 
indent on top.

Use a piece of pipe/shrink tube or similar to encase the pin to avoid
movement between the side pieces (="roller")

The front crossbar might be replace by a piece of bent wire even to 
simplify the design further...

BOM-Echos:
The render process computes some coordinates and lengths, so in order to
cut our materials, we need to know these distances.

Pin and Roller will be A=length, B=diameter
BackPlane and Front will be A=length, B=width, C=thickness

Side panel uses A-G for measurements. Refer to drawing "outline.png" 
for details.



Version history:

1  - Initial release
2  - Added "BOM" echo outputs, refer to drawing for details

*/


// All units assumed [mm]

// Thickness of side material
SideThickness = 6;

// Thickness of front material
FrontThickness = 1;

// Width of the front material
FrontWidth = 10;

// Spool holder clearence, sideways and in circumference
ClearenceSides = 3;
ClearenceBack = 5;

// diameter of pin
PinDiameter = 3;

// diameter of roll
RollDiameter = 4;

// backplane thickness (0 = omit backplane)
BackPlaneThickness = 3;

// Diameter for the feeding hole in the front plate
FeedDiameter = 2;


// Front plate parameters
FrontColor = "silver";
FrontAngle = 45;   // 10-70°, angle from the pin to put the cross bar.



// Color for the base unit
BaseColor = "white";

// Spool Parameters
SpoolColor = "blue";
ShowSpool = true;

// Pin Parameters
PinColor = "silver";
ShowRoll = true;
RollColor = "red";

/*
SpoolHolder

loc = center location
w = width of spool
d = diameter of spool
dHole = inner hole diameter of the roll
n = number of slots (spools)
name = Name for referencing the BOM-echo output...

*/

module SpoolHolder(loc = [0,0,0], w = 40, d = 50, dHole = 14, n = 1, name="Spool")
{
   
    r = d / 2;
    rHole = dHole / 2;
    // compute the location for the front cross bar...
    
    // distance from center = spool radius + radial spacing
    rDistance = r + ClearenceBack;
    if (FrontAngle < 10 || FrontAngle > 70)
        echo("FrontAngle is untested/invalid: ", FrontAngle);
    // the spool will "sag" by the hole radius minus the roll radius...
    frontX = ceil(cos(FrontAngle) * rDistance + rHole - (RollDiameter / 2));
    frontY = ceil(sin(FrontAngle) * rDistance);
    //echo("X=",frontX, " Y=",frontY);
    
    // Calculate full width, based on number of spools...
    TotalWidth = (SideThickness + ClearenceSides) * 2 + w * n + (SideThickness + ClearenceSides * 2) *(n-1);
    
    // Assume that the pin will only rest on 50% of the sides, makes it easier for n>1 cases...
    PinWidth = SideThickness + ClearenceSides * 2 + w;
    RollWidth = PinWidth - SideThickness;
    
    
    AxisCenterZ = BackPlaneThickness + ClearenceBack + r;
    SideHeight = (FrontWidth + frontX);
    SideDepth = ClearenceBack + r;
    translate(loc)
    {
        
        if (BackPlaneThickness > 0)
        {
            translate([0,0,BackPlaneThickness / 2])
                cube([TotalWidth,SideHeight,BackPlaneThickness],center=true);
        }
        
        for(current = [0:1:n-1])
        {
            translate([(current * PinWidth) - (n-1) * PinWidth /2,0,0])
            {
                    // Side panel
                color(BaseColor)
                translate([-(SideThickness / 2 + w / 2 + ClearenceSides),0,BackPlaneThickness + SideDepth / 2])
                {
                    rotate([0,-90,0])
                    linear_extrude(height=SideThickness, center=true)
                    {
                        polygon(points=[ 
                            [-SideDepth / 2,-SideHeight / 2],
                            [-SideDepth / 2,SideHeight / 2], 
                            [SideDepth / 2 + frontY, SideHeight / 2], 
                            [SideDepth / 2 + frontY, SideHeight / 2 - FrontWidth], 
                            [SideDepth / 2 + RollDiameter, -SideHeight / 2], 
                            [SideDepth / 2 + PinDiameter / 2, -SideHeight / 2], 
                            [SideDepth / 2 + PinDiameter / 2, -SideHeight / 2 + PinDiameter], 
                            [SideDepth / 2 - PinDiameter / 2, -SideHeight / 2 + PinDiameter], 
                            [SideDepth / 2 - PinDiameter / 2, -SideHeight / 2] ]);
                    }
                    //cube([SideThickness, SideHeight, r + ClearenceBack], center=true);
                }
                // Spindle assembly...
                translate([0,-SideHeight / 2 + PinDiameter / 2, AxisCenterZ])
                rotate([0,90,0])
                {
                    color(PinColor, alpha=0.5)
                    {
                        cylinder(r=PinDiameter / 2, h=PinWidth ,center=true);
                    }
                    if (ShowRoll)
                    {
                        color(RollColor)
                        cylinder(r=RollDiameter / 2, h=RollWidth, center=true);
                       
                    }
                    if (ShowSpool)
                    {
                        color(SpoolColor, alpha=0.5)
                        {
                            translate([0,rHole - RollDiameter / 2,0])
                            difference()
                            {
                                union()
                                {
                                    cylinder(r=max(r / 2, rHole * 1.1), h = w, center=true);
                                    translate([0,0,w * 0.9 / 2])
                                        cylinder(r=r, h = w*0.1, center=true);
                                    translate([0,0,-w * 0.9 / 2])
                                        cylinder(r=r, h = w*0.1, center=true);
                                }
                                cylinder(r=rHole,h=w + 2,center=true);
                            }
                        }
                    }
                }
            }
        }
        color(BaseColor)
        translate([(SideThickness / 2 + w / 2 + ClearenceSides + (n-1)*PinWidth / 2),0,BackPlaneThickness + SideDepth / 2])
        rotate([0,-90,0])
        linear_extrude(height=SideThickness, center=true)
        {
            polygon(points=[ 
                [-SideDepth / 2,-SideHeight / 2],
                [-SideDepth / 2,SideHeight / 2], 
                [SideDepth / 2 + frontY, SideHeight / 2], 
                [SideDepth / 2 + frontY, SideHeight / 2 - FrontWidth], 
                [SideDepth / 2 + RollDiameter, -SideHeight / 2], 
                [SideDepth / 2 + PinDiameter / 2, -SideHeight / 2], 
                [SideDepth / 2 + PinDiameter / 2, -SideHeight / 2 + PinDiameter], 
                [SideDepth / 2 - PinDiameter / 2, -SideHeight / 2 + PinDiameter], 
                [SideDepth / 2 - PinDiameter / 2, -SideHeight / 2] ]);
        }
        
            // front plane...
        color(FrontColor)
        {
            translate([0,SideHeight / 2 - FrontWidth / 2, SideDepth / 2 + BackPlaneThickness + SideDepth / 2 + frontY + FrontThickness / 2])
            {
                //difference()
                //{
                    cube([TotalWidth,FrontWidth,FrontThickness], center=true);
                    //cylinder(r=FeedDiameter / 2, h = FrontThickness+2, center = true);
                //}
            }
        }


        name = str(name);

        echo(name,n,"Pin",n, PinWidth,PinDiameter);
        echo(name,n,"Roller",n, RollWidth,RollDiameter);
        if (BackPlaneThickness > 0)
        {
            echo(name,n,"BackPlane",1,TotalWidth,SideHeight,BackPlaneThickness);
        }
        echo(name,n,"Front",1,TotalWidth,FrontWidth,FrontThickness);
        echo(name,n,"Side",n+1,SideDepth + frontY, SideHeight, SideDepth + RollDiameter, SideDepth - PinDiameter / 2, PinDiameter, FrontWidth, SideThickness);
    }
}


// SAMPLE CODE - Adjust as needed: 
// Creates a "Backplane" and adds various sizes of holders:

translate([-250,0,-3])
cube([400,250,6], center=true);

translate([250,0,-3])
cube([450,250,6], center=true);

echo("Holder","nCount","Part","Pcs","A","B","C","D","E","F","G");

// small, wide: 7
SpoolHolder(loc=[-250,-80,0],d = 50, dHole=14, w=40, n=7, name="small, wide");
SpoolHolder(loc=[-250,-20,0],d = 50, dHole=14, w=40, n=7, name="small, wide");

// large, narrow: 2
SpoolHolder(loc=[370,-60,0],d = 75, dHole=14, w=20, n=6, name="larger, narrow");

// small, narrow: 2
SpoolHolder(loc=[150,-70,0],d = 55, dHole=20, w=20, n=7, name="small, narrow");

// medium narrower: 1
SpoolHolder(loc=[250,20,0],d = 50, dHole=25, w=60, n=6, name="medium, narrower");

// medium wide: 3
SpoolHolder(loc=[250,100,0],d = 56, dHole=25, w=75, n=5, name="medium, wide");

// large, narrow: 2
SpoolHolder(loc=[-170,90,0], d = 105, dHole=15, w=45, n=4, name="large, narrow");
