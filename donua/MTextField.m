//
//  MTextField.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-26.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MTextField.h"

@implementation MTextField
#define theme 1
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)rect
{
    
    [[NSColor windowBackgroundColor] set];
    [NSGraphicsContext saveGraphicsState];
    
    float cornerRadius = 2;
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:cornerRadius yRadius:cornerRadius];
    
        NSGradient *gradient;
    switch (theme) {
        case 0:
            //white
            gradient= [[NSGradient alloc] initWithColorsAndLocations:
                       [NSColor colorWithCalibratedRed:0.7f green:0.7f blue:0.7f alpha:1.00f], 0.0f,
                       [NSColor colorWithCalibratedRed:0.95f green:0.95f blue:0.95f alpha:1.00f], 0.3f,
                       [NSColor colorWithCalibratedRed:0.95f green:0.95f blue:0.95f alpha:1.00f], 0.7f,
                       [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.00f], 1.0f,
                       nil];
            break;
        case 1:
            gradient= [[NSGradient alloc] initWithColorsAndLocations:
                       [NSColor colorWithCalibratedRed:0.8f green:0.8f blue:0.8f alpha:1.00f], 0.0f,
                       [NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.00f], 1.0f,
                       nil];
            break;
        default:
            //black
            gradient= [[NSGradient alloc] initWithColorsAndLocations:
                       [NSColor colorWithCalibratedRed:0.1f green:0.1f blue:0.1f alpha:1.00f], 0.0f,
                       [NSColor colorWithCalibratedRed:0.3f green:0.3f blue:0.3f alpha:1.00f], 1.0f,
                       nil];
            break;
    }
    
    [gradient drawInBezierPath:path angle:90];
    
    [NSGraphicsContext restoreGraphicsState];
}

@end
