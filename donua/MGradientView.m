//
//  MMainWindowView.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-17.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MGradientView.h"

@implementation MGradientView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    [[NSColor windowBackgroundColor] set];
    [NSGraphicsContext saveGraphicsState];
    
    float cornerRadius = 5;
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:cornerRadius yRadius:cornerRadius];
    
    
    /*NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            [NSColor colorWithCalibratedRed:0.96f green:0.96f blue:0.96f alpha:1.00f], 0.0f,
                            [NSColor colorWithCalibratedRed:0.84f green:0.84f blue:0.84f alpha:1.00f], 1.0f,
                            nil];*/
    NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            [NSColor colorWithCalibratedRed:0.4f green:0.4f blue:0.4f alpha:1.0f], 0.0f,
                            [NSColor colorWithCalibratedRed:0.2f green:0.2f blue:0.2f alpha:1.0f], 1.0f,
                            nil];
    
    [gradient drawInBezierPath:path angle:270];
    
    [NSGraphicsContext restoreGraphicsState];
}
@end
