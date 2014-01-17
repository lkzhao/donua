//
//  MMainWindowController.h
//  Miya
//
//  Created by Luke Zhao on 2013-01-22.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MCollectionView.h"

@interface MMainWindowController : NSWindowController <NSTextFieldDelegate>
@property (weak) IBOutlet NSScrollView *selectionView;
@property (weak) IBOutlet NSTextField *commandTextBox;
@property (weak) IBOutlet NSButton *openSettingButton;

@property (strong) NSString *currentCommand;

-(void)updateHeight;

- (IBAction)runCommand:(id)sender;
- (IBAction)openSetting:(id)sender;

@end
