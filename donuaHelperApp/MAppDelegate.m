//
//  MAppDelegate.m
//  donuaHelperApp
//
//  Created by Luke Zhao on 2013-01-31.
//  Copyright (c) 2013 mochaka. All rights reserved.
//

#import "MAppDelegate.h"

@implementation MAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *appPath = [[[[[[NSBundle mainBundle] bundlePath]
                            stringByDeletingLastPathComponent]
                           stringByDeletingLastPathComponent]
                          stringByDeletingLastPathComponent]
                         stringByDeletingLastPathComponent]; // Removes path down to /Applications/Great.app
    NSString *binaryPath = [[NSBundle bundleWithPath:appPath] executablePath]; // Uses string with bundle binary executable
    [[NSWorkspace sharedWorkspace] launchApplication:binaryPath]; // Launches binary
    //        NSAlert *alert = [NSAlert alertWithMessageText:binaryPath defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"hi"];
    //        [alert runModal]; // Use this NSAlert if your helper does not automatically open your main application to see what path it's trying to open.
    [NSApp terminate:nil]; // Required to kill helper app
}

@end
