//
//  HelloWorldAppDelegate.h
//  Miya
//
//  Created by Luke Zhao on 2013-01-17.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Information.h"

@class MSettingWindowController,MMainWindowController,OPIndexManager,MASShortcutView,MSelectionViewController;
@interface MAppDelegate : NSObject <NSApplicationDelegate>
@property (strong) MSettingWindowController *settingWindowController;
@property (strong) MMainWindowController *mainWindowController;



- (IBAction)startAtLoginChanged:(id)sender;



@end
MAppDelegate *gAppDelegate;
OPIndexManager *gIndexManager;
NSDictionary *gDefaultFunctions;
NSString *gDonuaShortcutKey;