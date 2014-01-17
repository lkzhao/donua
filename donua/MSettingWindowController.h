//
//  MSettingWindowController.h
//  Miya
//
//  Created by Luke Zhao on 2013-01-22.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class OPIndexManager,MAppDelegate,MASShortcutView;
@interface MSettingWindowController : NSWindowController
@property (weak) IBOutlet NSButton *startUpLoginCheckBox;
@property (assign) IBOutlet NSWindow *pathPanel;
@property (assign) IBOutlet NSWindow *searchPanel;
@property (strong) IBOutlet NSDictionaryController *programListController;
@property (strong) IBOutlet NSDictionaryController *searchListController;
@property (strong) IBOutlet NSWindow *factoryDefaultPanel;
@property (weak) IBOutlet NSProgressIndicator *factoryDefaultProgressIndicator;
@property (weak) IBOutlet NSButton *factoryDefaultCancelButton;

@property (assign) OPIndexManager *im;
@property (assign) MAppDelegate *ap;
@property (weak) IBOutlet MASShortcutView *shortcutView;
@property (weak) IBOutlet NSSlider *opacitySlider;
@property (weak) IBOutlet NSTableView *programListTable;
@property (weak) IBOutlet NSTableView *searchListTable;
@property (assign) NSView *currentContentView;
@property (weak) IBOutlet NSTextField *pathTF;
@property (weak) IBOutlet NSTextField *keywordTF;
@property (weak) IBOutlet NSTextField *domainTF;
@property (weak) IBOutlet NSTextField *suffixTF;
@property (weak) IBOutlet NSImageView *iconChooser;
@property (weak) IBOutlet NSTextField *iconChooserPromt;
@property (weak) IBOutlet NSButton *removeIconButton;

- (IBAction)factoryDefault:(id)sender;
- (IBAction)changeOpacity:(id)sender;
- (IBAction)exportIndex:(id)sender;
- (IBAction)openAbout:(id)sender;
- (IBAction)browsePath:(id)sender;
- (IBAction)iconDropped:(id)sender;
- (IBAction)removeIcon:(id)sender;

- (IBAction)removeSelected:(id)sender;
- (IBAction)addNew:(id)sender;

- (IBAction)closeSheet:(id)sender;


- (void)openSetting;
@end