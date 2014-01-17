//
//  HelloWorldAppDelegate.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-17.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <ServiceManagement/ServiceManagement.h>

#import "MAppDelegate.h"
#import "MDispatcher.h"
#import "OPIndexManager.h"
#import "MMainWindowController.h"
#import "MSettingWindowController.h"
#import "MIndexPorter.h"
#import "DDHotKeyCenter.h"
#import "MASShortcut+UserDefaults.h"
#import "MSelectionItem.h"
#import "MASShortcut+Monitoring.h"

@implementation MAppDelegate{
    __weak id _constantShortcutMonitor;
}





- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    gAppDelegate=self;
    gIndexManager=[OPIndexManager new];
    gDonuaShortcutKey = @"DonuaShortcut";
    gDefaultFunctions=[NSDictionary dictionaryWithObjectsAndKeys:@"copy files",@"copy",@"remove a keyword from index",@"remove",@"set a keyword with a path",@"set",@"set a keyword with a path",@"add",@"add a search keyword with a domain and a suffix",@"adds",@"Next iTunes music track",@"nextsong",@"Previous iTunes music track",@"previoussong",@"play or pause iTunes",@"play pause", nil];
    self.mainWindowController=[[MMainWindowController alloc]init];
    [self.mainWindowController.window makeKeyAndOrderFront:self.mainWindowController];
    
    self.settingWindowController=[[MSettingWindowController alloc]init];
    
    
    //setup global hotkey
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:gDonuaShortcutKey handler:^{
        NSLog(@"shortcut working.%@",[self.mainWindowController.window isKeyWindow]?@"true":@"false");
        if ([self.mainWindowController.window isKeyWindow]) {
            [self.mainWindowController.window close];
        }else{
            [self.mainWindowController.window makeKeyAndOrderFront:self];
            [self.mainWindowController.window makeFirstResponder:self.mainWindowController.commandTextBox];
            [[NSApplication sharedApplication] activateIgnoringOtherApps : YES];
        }
    }];
    //setup default hotkey
    MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_F2 modifierFlags:NSCommandKeyMask];
    _constantShortcutMonitor = [MASShortcut addGlobalHotkeyMonitorWithShortcut:shortcut handler:^{
        NSLog(@"shortcut working.%@",[self.mainWindowController.window isKeyWindow]?@"true":@"false");
        if ([self.mainWindowController.window isKeyWindow]) {
            [self.mainWindowController.window close];
        }else{
            [self.mainWindowController.window makeKeyAndOrderFront:self];
            [self.mainWindowController.window makeFirstResponder:self.mainWindowController.commandTextBox];
            [[NSApplication sharedApplication] activateIgnoringOtherApps : YES];
        }
    }];
    
    //user default:
    [self setUserDefault];
}
- (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    [self.mainWindowController.window  makeKeyAndOrderFront:self];
    return NO;
}

-(void)applicationDidResignActive:(NSNotification *)notification{
    [self.mainWindowController.window close];
}

-(void)applicationWillTerminate:(NSNotification *)notification{
    //[MAppDelegate setStartAtLogin:[ud boolForKey:@"startAtLogin"]];
    [gIndexManager saveIndex];
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames{
    [self.mainWindowController.window makeKeyAndOrderFront:nil];
    NSLog(@"Importing from %@",[[filenames objectAtIndex:0] class]);
    MIndexPorter *porter=[MIndexPorter new];
    [porter importFromFilePath:[filenames objectAtIndex:0]];
    [[NSAlert alertWithMessageText:@"Import finished" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
}


- (IBAction)startAtLoginChanged:(id)sender {
    BOOL enable;
    enable=[sender state];
    
	// Setting login
	if (!SMLoginItemSetEnabled((CFStringRef)@"com.mochaka.donuaHelperApp",enable)) {
		NSLog(@"SMLoginItemSetEnabled failed!");
            [[NSAlert alertWithMessageText:@"SMLoginItemSetEnabled Failed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""]runModal];
	}
}


-(void)setUserDefault{
    NSMutableDictionary *factoryDefault=[NSMutableDictionary new];
    
    //factory default:
    [factoryDefault setObject:[NSNumber numberWithFloat: 1.0] forKey:@"opacity"];
    [factoryDefault setObject:[NSNumber numberWithBool:NO] forKey:@"startAtLogin"];
    //get screen size...
    [ud registerDefaults:factoryDefault];
    
    //set opacity from default
    [self.mainWindowController.window setAlphaValue:[[ud objectForKey:@"opacity"] floatValue]];
    [self.settingWindowController.opacitySlider setFloatValue:[[ud objectForKey:@"opacity"] floatValue]];
    
    
    if ([ud boolForKey:@"rememberPosition"]) {
        //[self.mainWindowController.window setFrameAutosaveName:@"mainWindowFrame"];
    }else{
        [NSWindow removeFrameUsingName:@"mainWindowFrame"];
    }
}









@end
