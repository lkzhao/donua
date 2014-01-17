//
//  MMainWindowController.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-22.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MMainWindowController.h"
#import "MAppDelegate.h"
#import "MSettingWindowController.h"
#import "MSelectionViewController.h"
#import "MSelectionItem.h"


@interface MMainWindowController ()

@end

@implementation MMainWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"MMainWindowController" owner:self];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window setStyleMask:NSBorderlessWindowMask];
    [self updateHeight];
    //no focus ring on command box
    [self.commandTextBox setFocusRingType:NSFocusRingTypeNone];
    
}


- (IBAction)openSetting:(id)sender {
    [gAppDelegate.settingWindowController openSetting];
}


-(void)controlTextDidChange:(id)sender
{
    if ([sender isKindOfClass:[NSNotification class]])
    {
        NSNotification *test = sender;
        id object = [test object];
        if ([object isKindOfClass:[NSTextField class]])
        {
            NSTextField *tf = object;
            NSString *s=[tf stringValue];
            if (s.length==0) {
                [[self.openSettingButton animator] setAlphaValue:1];
                [[self.openSettingButton animator] setEnabled:YES];
            }else{
                [[self.openSettingButton animator] setAlphaValue:0];
                [[self.openSettingButton animator] setEnabled:NO];
            }
            
            [gSelectionViewController updateContent:s];
            [gSelectionViewController updateCalculation:s];
            [self updateHeight];
        }
    }
}


-(void)updateHeight{
    int selectionViewHeight=[gSelectionViewController viewHeight];
    int windowHeight=58;
    NSRect windowFrame=self.window.frame;
    int oldHeight=windowFrame.size.height;
    if (selectionViewHeight>0) {
        windowFrame.size.height=windowHeight+selectionViewHeight+7;
    }else{
        windowFrame.size.height=windowHeight+selectionViewHeight;
    }
    windowFrame.origin.y-=(windowFrame.size.height-oldHeight);
    
    [self.window setFrame:windowFrame display:YES animate:NO];
}


//detect up and down key presses
- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView
doCommandBySelector:(SEL)command
{
    if (command == @selector(moveDown:)) {
        //[self.window makeFirstResponder:self.collectionView];
        [gSelectionViewController nextSelection];
        return YES;
    }
    if (command == @selector(moveUp:)) {
        [gSelectionViewController previousSelection];
        return YES;
    }
    return NO;
}


- (IBAction)runCommand:(id)sender {
    //[self.window close];
    [gSelectionViewController triggerCurrentSelectedItem];
}

@end
