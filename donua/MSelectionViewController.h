//
//  MSelectionViewController.h
//  Miya
//
//  Created by Luke Zhao on 2013-01-25.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MItunesWatcher.h"

@class MSelectionItem,MCollectionView;
@interface MSelectionViewController : NSObject

@property (strong) IBOutlet NSArrayController *selectionItemArrayController;

@property (weak) IBOutlet MCollectionView *collectionView;
@property (strong) NSMutableArray *selectionItemArray;
@property (strong) NSIndexSet *selectedIndexes;
@property (strong) NSMutableArray *queue;

@property (strong) NSMutableArray* applicationsArray;
@property (strong) NSMutableArray* functionsArray;
@property (strong) NSMutableArray* searchesArray;
@property (strong) MSelectionItem *calculation;
@property (strong) MSelectionItem *focusItem;
@property (strong) MItunesWatcher *itunesWatcher;


-(void)updateCalculation:(NSString *)expression;

-(void)triggerCurrentSelectedItem;
-(void)updateItunes;
-(void)nextSelection;
-(void)previousSelection;

-(void)buildIndexArrays;
//addInQueqe: and updateContent need to use together..
-(void)updateContent:(NSString *)input;
-(void)addInQueqe:(MSelectionItem *)path;
-(void)updateFromQueue;

-(int)viewHeight;
-(void)add;
@end

MSelectionViewController *gSelectionViewController;