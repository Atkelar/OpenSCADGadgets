
/*

Basic dimensions:
    h=7mm
    w=45mm
    hNotch = 2mm
    iNotch= 3mm
    wNotch = 4mm
    distNotch=32mm
    
    wOuter = 55
    hOuter=5.5
    clipDepth = 2mm
    
    nPin = 11
    pinSpace = 3mm
    pinThick = 1
    
    sockDepth = 15mm
    pinDepth = 6mm
    
NOTE 1: The notches are prepared to take these connectors:

https://www.molex.com/molex/products/part-detail/crimp_terminals/0008550102

NOTE 2: the top/bottom covers might still need some alignment pegs, but I found the screws to be enough. 

NOTE 3: Hole size is set for M3 countersunk screws, the thread can be cut into the base part.

*/

$fn = 40;

h = 6.8;
w = 44.8;
sockDepth = 15;
// pinlength = 10;
wOuter = 55;

clipThick = 1.4;
clipDepth = 2.7;
clipHeight = 5.7;
clipNotch = 1;

gripHeight = 10;

wNotch = 2.9;
hNotch = 1.7;
distNotch = 32.4;

nPin = 11;
pinDistance = 40;

pinWidth=1.1;
pinHeight=2.2;
pinDepth = 9;

dWire = 1.9;

gripDepth = 15;

//crimpDepth2 = 10;
crimpDepth = 3.9;
crimpHeight = 2;
crimpWidth = 2.5;
crimpOffset = 0.3;
crimpNesting1 = 1;
crimpNesting2 = 5.5;
crimpNotchOffset = 3.2;
crimpNotchDepth = 1.5;

module PinRow()
{
    pinStep = pinDistance / (nPin-1);
    translate([-(pinDistance+pinWidth) / 2,-0.1,-pinHeight /2])
    for(i=[0:1:nPin-1])
    {
        translate([i * pinStep, 0,0])
        {
            cube([pinWidth, pinDepth+0.1,pinHeight]);
/*            translate([-dWire, dWire*2,0])
                cylinder(d = dWire, h = pinHeight);
            translate([-pinStep/6, pinDepth / 2,0])
            difference()
            {
                cylinder(d = pinStep/1.3, h = pinHeight+2);
                hull()
                {
                    translate([0,pinStep/3 - dWire * 0.8,0])
                        cylinder(d = pinStep/3 - dWire * 0.8, h = pinHeight-0.3);
                    translate([0,-(pinStep/3 - dWire * 0.8),0])
                        cylinder(d = pinStep/3 - dWire * 0.8, h = pinHeight-0.3);
                }
            }
            translate([-dWire *1.5, dWire*2,pinHeight - dWire])
                rotate(-20)
                cube([dWire, pinDepth / 2 - dWire * 3, dWire]);
            */
            // (i == 1) // ground pin
            crimpNesting = i == 1 ? crimpNesting1 : crimpNesting2;
            
            if (i > 0)
            {
                translate([(-crimpWidth) + pinWidth+ crimpOffset,crimpNesting,pinHeight - crimpHeight])
                    cube([crimpWidth,crimpDepth,crimpHeight]);
                translate([-1.8,crimpNesting + crimpNotchOffset-crimpNotchDepth,pinHeight - crimpHeight+0.01])
                    cube([1,crimpNotchDepth,crimpHeight]);
                translate([-dWire + 0.8 , crimpNesting+crimpDepth -0.1,(pinHeight - dWire)/2])
                    cube([dWire*1.2, 30, dWire*1.5]);
            }
            else
            {
                translate([-crimpOffset,crimpNesting,pinHeight - crimpHeight])
                    cube([crimpWidth,crimpDepth,crimpHeight]);
                translate([crimpWidth-0.8,crimpNesting + crimpNotchOffset-crimpNotchDepth,pinHeight - crimpHeight+0.01])
                    cube([1,crimpNotchDepth,crimpHeight]);
                translate([crimpWidth-2*dWire+1, crimpNesting+crimpDepth - 0.1,(pinHeight - dWire)/2])
                    cube([dWire*1.3, 30, dWire*1.5]);
            }

        }
    }
}

module HoldingClip()
{
    union()
    {
        cube([clipThick, clipDepth, clipHeight]);
        difference()
        {
            translate([-clipNotch,-clipDepth+0.1,0])
            {
                cube([clipThick + clipNotch, clipDepth, clipHeight]);
            }
            translate([-clipNotch,-clipDepth+0.1,clipHeight / 2])
            {
                rotate(45)
                cube([clipThick + clipNotch * 1.3,(clipThick + clipNotch)*2,clipHeight+1], center=true);
            }
        }
        translate([0,-0.01,0])
            cube([clipThick, gripDepth, clipHeight]);
        difference()
        {
            translate([gripDepth*0.95,gripDepth/2,0])
                cylinder(d = 2*gripDepth, h = clipHeight);
            translate([clipThick,-50,-0.1])
                cube(100);
        }
        translate([2*clipThick,gripDepth+0.5,0])
            cube([clipThick*2,clipThick*2,clipHeight]);
        difference()
        {
            translate([2*clipThick,gripDepth+0.5,0])
                cylinder(d = 4* clipThick, h= clipHeight);
            translate([2.5*clipThick,gripDepth-clipThick*2 + 0.5,-0.01])
                cylinder(d=3*clipThick, h = clipHeight+2);
        }
    }
}

module Connector()
{
    union()
    {
        difference()
        {
            union()
            {
                cube([w, sockDepth, h]);
            }
            translate([w / 2, 0, h / 2])
                PinRow();
        }
    
        translate([w/2 - distNotch/2 - wNotch ,0,h-0.1])
            cube([wNotch, sockDepth, hNotch+0.1]);
        translate([w/2 + distNotch/2 ,0,h-0.1])
            cube([wNotch, sockDepth, hNotch+0.1]);
    }
}

module GripCase()
{
    difference()
    {
        union()
        {
            difference()
            {
                cube([w + (wOuter- w) / 3,gripDepth,gripHeight]);
                translate([(wOuter- w) / 5*1.2,-0.01,h / 2 - dWire])
                    cube([w-(wOuter- w) / 5,gripDepth+1,dWire * 2.5]);
            }
            translate([4,gripDepth-4,0])
                cylinder(d = 5, h = gripHeight);
            translate([w + (wOuter- w) / 3 - 4,gripDepth-4,0])
                cylinder(d = 5, h = gripHeight);
        }
        translate([4,gripDepth-4,-0.1])
            cylinder(d = 2.5, h = gripHeight+1);
        translate([w + (wOuter- w) / 3 - 4,gripDepth-4,-0.1])
            cylinder(d = 2.5, h = gripHeight+1);
        translate([4,gripDepth-4,4])
            cylinder(d = 3.2, h = gripHeight+1);
        translate([w + (wOuter- w) / 3 - 4,gripDepth-4,4])
            cylinder(d = 3.2, h = gripHeight+1);
        translate([4,gripDepth-4,gripHeight-1.9])
            cylinder(d1 = 3.2, d2=6, h = 2);
        translate([w + (wOuter- w) / 3 - 4,gripDepth-4,gripHeight-1.9])
            cylinder(d1 = 3.2, d2=6, h = 2);
        
    }
}

difference() // bottom 
{
    union()
    {
        difference()
        {
            Connector();
            translate([-30,-30, h / 2 + (pinHeight / 2) - 0.01])
                cube(100);
        }
        translate([-(wOuter- w) / 6,sockDepth-0.01,0])
            GripCase();
                  
        translate([-(wOuter- w) / 2, sockDepth - clipDepth,0])
            HoldingClip();
        
        translate([w + (wOuter- w) / 2, sockDepth - clipDepth,0])
            scale([-1,1,1])
                HoldingClip();
    }
    translate([-3,0, clipHeight])
        cube(wOuter);
    translate([0.05,sockDepth-0.01, h / 2 + (pinHeight / 2)])
        rotate([5,0,0])
            cube(w-0.1);
   
  
}

if (true) // debug top
{
translate([0,-35,-(h / 2 + (pinHeight / 2) - 0.01)])
intersection()
{
    union()
    {
        Connector();
        translate([-(wOuter- w) / 6,sockDepth-0.01,0])
            GripCase();
    }
    union()
    {
    translate([-30,-0.01, h / 2 + (pinHeight / 2) - 0.01])
        cube([100,sockDepth,100]);
    translate([-3,0, clipHeight])
        cube(wOuter);
    translate([-0.01,sockDepth-0.01, h / 2 + (pinHeight / 2)])
        rotate([5,0,0])
            cube(w-0.1);
    }
}

}
