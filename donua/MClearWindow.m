//
//  MMainWindows.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-17.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MClearWindow.h"

@implementation MClearWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation
{
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if (self) {
        [self setBackgroundColor:[NSColor clearColor]];
        
        // Turn off opacity so that the parts of the window that are not drawn into are transparent.
        [self setOpaque:NO];
        [self setMovableByWindowBackground:YES];
    }
    return self;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}
@end
