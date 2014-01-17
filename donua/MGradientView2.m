//
//  MGradientView2.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-24.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//
#define theme 0
#import "MGradientView2.h"
@implementation MGradientView2

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    [[NSColor windowBackgroundColor] set];
    [NSGraphicsContext saveGraphicsState];
    
    float cornerRadius = 0;
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:cornerRadius yRadius:cornerRadius];
    
    NSGradient *gradient;
    float firstcolor,secondcolor,thirdcolor,lastcolor,outlinecolor;
    switch (theme) {
        case 0:
            if (!self.selected) {
                firstcolor=1.0;
                secondcolor=0.94;
                thirdcolor=0.92;
                lastcolor=0.87;
                outlinecolor=0.5;
                gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            [NSColor colorWithCalibratedRed:outlinecolor green:outlinecolor blue:outlinecolor alpha:1.00f], 0.0,
                            [NSColor colorWithCalibratedRed:firstcolor green:firstcolor blue:firstcolor alpha:1.00f], 0.02,
                            [NSColor colorWithCalibratedRed:secondcolor green:secondcolor blue:secondcolor alpha:1.00f], 0.5,
                            [NSColor colorWithCalibratedRed:thirdcolor green:thirdcolor blue:thirdcolor alpha:1.00f], 0.51,
                            [NSColor colorWithCalibratedRed:lastcolor green:lastcolor blue:lastcolor alpha:1.00f], 1.0,
                            nil];
            }else{
                firstcolor=0.55;
                secondcolor=0.5;
                thirdcolor=0.48;
                lastcolor=0.40;
                outlinecolor=0.2;
                gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            [NSColor colorWithCalibratedRed:outlinecolor green:outlinecolor blue:outlinecolor alpha:1.00f], 0.0,
                            [NSColor colorWithCalibratedRed:0.35 green:0.35 blue:0.35 alpha:1.00f], 0.05,
                            [NSColor colorWithCalibratedRed:firstcolor green:firstcolor blue:firstcolor alpha:1.00f], 0.06,
                            [NSColor colorWithCalibratedRed:secondcolor green:secondcolor blue:secondcolor alpha:1.00f], 0.5,
                            [NSColor colorWithCalibratedRed:thirdcolor green:thirdcolor blue:thirdcolor alpha:1.00f], 0.51,
                            [NSColor colorWithCalibratedRed:lastcolor green:lastcolor blue:lastcolor alpha:1.00f], 0.94,
                            [NSColor colorWithCalibratedRed:0.30 green:0.30 blue:0.30 alpha:1.00f], 0.95,
                            [NSColor colorWithCalibratedRed:outlinecolor green:outlinecolor blue:outlinecolor alpha:1.00f], 1.0,
                            nil];//*/
            }
            break;
        case 1:
            if (self.selected) {
                firstcolor=1.0;
                secondcolor=0.94;
                thirdcolor=0.92;
                lastcolor=0.87;
                outlinecolor=0.5;
                gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            [NSColor colorWithCalibratedRed:outlinecolor green:outlinecolor blue:outlinecolor alpha:1.00f], 0.0,
                            [NSColor colorWithCalibratedRed:firstcolor green:firstcolor blue:firstcolor alpha:1.00f], 0.02,
                            [NSColor colorWithCalibratedRed:secondcolor green:secondcolor blue:secondcolor alpha:1.00f], 0.5,
                            [NSColor colorWithCalibratedRed:thirdcolor green:thirdcolor blue:thirdcolor alpha:1.00f], 0.51,
                            [NSColor colorWithCalibratedRed:lastcolor green:lastcolor blue:lastcolor alpha:1.00f], 1.0,
                            nil];
            }else{
                firstcolor=0.55;
                secondcolor=0.5;
                thirdcolor=0.48;
                lastcolor=0.40;
                outlinecolor=0.2;
                gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            [NSColor colorWithCalibratedRed:outlinecolor green:outlinecolor blue:outlinecolor alpha:1.00f], 0.0,
                            [NSColor colorWithCalibratedRed:outlinecolor green:outlinecolor blue:outlinecolor alpha:1.00f], 0.02,
                            [NSColor colorWithCalibratedRed:firstcolor green:firstcolor blue:firstcolor alpha:1.00f], 0.03,
                            [NSColor colorWithCalibratedRed:secondcolor green:secondcolor blue:secondcolor alpha:1.00f], 0.5,
                            [NSColor colorWithCalibratedRed:thirdcolor green:thirdcolor blue:thirdcolor alpha:1.00f], 0.51,
                            [NSColor colorWithCalibratedRed:lastcolor green:lastcolor blue:lastcolor alpha:1.00f], 1.0,
                            nil];//*/
            }
            break;
        default:
            break;
    }

    
    [gradient drawInBezierPath:path angle:270];
    [NSGraphicsContext restoreGraphicsState];
    
}
-(BOOL)canBecomeKeyView{
    return YES;
}

@end
