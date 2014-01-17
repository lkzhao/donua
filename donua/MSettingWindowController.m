//
//  MSettingWindowController.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-22.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MSettingWindowController.h"
#import "MDispatcher.h"
#import "MAppDelegate.h"
#import "OPIndexManager.h"
#import "MMainWindowController.h"
#import "MIndexPorter.h"
#import "MASShortcutView+UserDefaults.h"
@implementation MSettingWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"MSettingWindowController" owner:self];

    //used by xib bindings:
    self.im=gIndexManager;
    self.ap=gAppDelegate;
    
    
    //short cut:

    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)openSetting{
    [self showWindow:self.window];
    [self.window makeKeyAndOrderFront:self];
}

-(void)awakeFromNib{
    self.shortcutView.associatedUserDefaultsKey=gDonuaShortcutKey;
}

- (IBAction)factoryDefault:(id)sender {
    if ([[(NSButton *)sender identifier] isEqualToString:@"proceed"]) {
        [self.factoryDefaultCancelButton setHidden:YES];
        [sender setHidden:YES];
        [self.factoryDefaultProgressIndicator setHidden:NO];
        [self.factoryDefaultProgressIndicator setUsesThreadedAnimation:YES];
        [self.factoryDefaultProgressIndicator startAnimation:self];
        [NSThread detachNewThreadSelector:@selector(factoryDefaultThread) toTarget:self withObject:nil];
    }else{
        if (!self.factoryDefaultPanel) {
            [NSBundle loadNibNamed:@"factoryDefault" owner:self];
        }
        [NSApp beginSheet:self.factoryDefaultPanel modalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
    }
}
-(void)factoryDefaultThread{
    [self willChangeValueForKey:@"im"];
    [gIndexManager factoryDefault];
    [self didChangeValueForKey:@"im"];
    [self performSelectorOnMainThread:@selector(factoryDefaultFinishes) withObject:nil waitUntilDone:NO];
}
-(void)factoryDefaultFinishes{
    [self.factoryDefaultProgressIndicator stopAnimation:self];
    [NSApp endSheet:self.factoryDefaultPanel];
    [self.factoryDefaultPanel close];
    self.factoryDefaultPanel=nil;
}

- (IBAction)changeOpacity:(id)sender {
    NSSlider *slider=sender;
    float opacity=slider.floatValue;
    [gAppDelegate.mainWindowController.window setAlphaValue:opacity];
}

- (IBAction)exportIndex:(id)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setExtensionHidden:NO];

    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"dkp"]];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger ret){
        if (ret == NSFileHandlingPanelOKButton) {
            [[MIndexPorter new]exportToFileURL:[panel URL]];
        }
    }];
}


- (IBAction)openAbout:(id)sender {
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:nil];
}

- (IBAction)browsePath:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setExtensionHidden:NO];
    [panel setCanChooseDirectories:YES];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"dkp"]];
    [panel beginWithCompletionHandler:^(NSInteger ret){
        if (ret == NSFileHandlingPanelOKButton) {
            self.pathTF.stringValue=panel.URL.path;
            self.keywordTF.stringValue=panel.URL.path.lastPathComponent.lowercaseString;
            self.iconChooser.image=[[NSWorkspace sharedWorkspace] iconForFile:panel.URL.path];
            self.iconChooser.image.size=NSMakeSize(128, 128);
            [self iconDropped:nil];
        }
    }];
}

- (IBAction)iconDropped:(id)sender {
    if (self.iconChooser.image!=nil) {
        [self.iconChooserPromt setHidden:YES];
        [self.removeIconButton setHidden:NO];
    }else{
        [self.iconChooserPromt setHidden:NO];
        [self.removeIconButton setHidden:YES];
    }
}

- (IBAction)removeIcon:(id)sender {
    [self.iconChooserPromt setHidden:NO];
    self.iconChooser.image=nil;
    [sender setHidden:YES];
}

- (IBAction)removeSelected:(id)sender {
    BOOL isRemovingPath=[[(NSButton *)sender identifier] isEqualToString:@"removePath"];
    NSUInteger index;
    if (isRemovingPath) 
        index= self.programListTable.selectedRowIndexes.firstIndex;
    else
        index= self.searchListTable.selectedRowIndexes.firstIndex;
    
    if (index!=NSNotFound) {
        [self willChangeValueForKey:@"im"];
        if (isRemovingPath) 
            [gIndexManager removeKey:[[self.programListController.arrangedObjects objectAtIndex:index] key]];
        else
            [gIndexManager removeKey:[[self.searchListController.arrangedObjects objectAtIndex:index] key]];
        [self didChangeValueForKey:@"im"];
    }
}

- (IBAction)addNew:(id)sender {
    if ([[(NSButton *)sender identifier] isEqualToString:@"addPath"]) {
        if (!self.pathPanel) {
            [NSBundle loadNibNamed:@"pathSheet" owner:self];
        }
        [NSApp beginSheet:self.pathPanel modalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
    }else{
        if (!self.searchPanel) {
            [NSBundle loadNibNamed:@"searchSheet" owner:self];
        }
        [NSApp beginSheet:self.searchPanel modalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
    }

}

- (IBAction)closeSheet:(id)sender {
    if (self.pathPanel) {
        if ([((NSButton *)sender).identifier isEqualToString:@"add"]) {
            if ([self.pathTF.stringValue isEqualToString: @""]||[self.keywordTF.stringValue isEqualToString: @""]) {
                [[NSAlert alertWithMessageText:@"Please fill in all the fields." defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""]runModal];
            }else{
                [self willChangeValueForKey:@"im"];
                [gIndexManager addProgramKey:self.keywordTF.stringValue forValue:self.pathTF.stringValue icon:[self.iconChooser image]];
                [self didChangeValueForKey:@"im"];
                [NSApp endSheet:self.pathPanel];
                [self.pathPanel close];
                self.pathPanel=nil;
            }
        }else{//canceled
            [NSApp endSheet:self.pathPanel];
            [self.pathPanel close];
            self.pathPanel=nil;
        }
    }else if(self.searchPanel){//is searchPanel
        if ([((NSButton *)sender).identifier isEqualToString:@"add"]) {
            if ([self.domainTF.stringValue isEqualToString: @""]||[self.keywordTF.stringValue isEqualToString: @""]||[self.suffixTF.stringValue isEqualToString: @""]) {
                [[NSAlert alertWithMessageText:@"Please fill in all the fields." defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""]runModal];
            }else{
                [self willChangeValueForKey:@"im"];
                [gIndexManager addSearchKey:self.keywordTF.stringValue domain:self.domainTF.stringValue suffix:self.suffixTF.stringValue description:nil icon:[self.iconChooser image]];
                [self didChangeValueForKey:@"im"];
                [NSApp endSheet:self.searchPanel];
                [self.searchPanel close];
                self.searchPanel=nil;
            }
        }else{//canceled
            [NSApp endSheet:self.searchPanel];
            [self.searchPanel close];
            self.searchPanel=nil;
        }
    }else{
        [NSApp endSheet:self.factoryDefaultPanel];
        [self.factoryDefaultPanel close];
        self.factoryDefaultPanel=nil;
    }
}

- (void)dealloc
{
    // Cleanup
    
}

@end
