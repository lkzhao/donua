//
//  MSelectionViewController.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-25.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MSelectionViewController.h"

#import "MSelectionItem.h"
#import "Information.h"
#import "MAppDelegate.h"
#import "MMainWindowController.h"
#import "MDispatcher.h"
#import "DDExpression.h"
#import "OPIndexManager.h"
#import "OPSearcher.h"


#define selectionItemHeight 60

BOOL isSpecialItem(MSelectionItem *test){
    NSArray *specialItem=[NSArray arrayWithObjects:@"calculation",@"iTunesWatcher", nil];
    return [specialItem containsObject:test.name];
}
@implementation MSelectionViewController

-(void)awakeFromNib{
    //selection item test;
    gSelectionViewController=self;
    
    //disable animation
    [self.collectionView setValue:@(0) forKey:@"_animationDuration"];
    
    //initialize arrays
    self.queue=[NSMutableArray array];
    self.selectedIndexes=[NSIndexSet indexSet];
    self.selectionItemArray=[NSMutableArray array];
    
    [self buildArrays];
    
    //constuct calculation SelectionItem
    self.calculation=[MSelectionItem new];
    self.calculation.name=@"calculation";
    self.calculation.title=@"";
    self.calculation.subtitle=@"";
    [self.calculation  setTarget:self selector:@selector(nothing:)];
    //self.calculation.icon=[[NSWorkspace sharedWorkspace]iconForFile:@"/Applications/Calculator.app"];
    //self.calculation.icon.size=NSMakeSize(512, 512);
    
    //constuct iTunes watcher selectionItem with its costum class:

    self.itunesWatcher=[MItunesWatcher new];
    [self updateItunes];//update itunes at start (itunes might be playing musics before application starts)

}
-(void)buildArrays{
    [self buildIndexArrays];

    [self buildfunctionArray];

}
-(void)buildIndexArrays{
    [self buildApplicationArray];
    [self buildSearchArray];
}
-(void)buildSearchArray{
    self.searchesArray=[NSMutableArray array];
    NSDictionary *tempD=[gIndexManager.index objectForKey:@"searchList"];
    for (NSString* k in [tempD allKeys]) {
        MSelectionItem *sear=[MSelectionItem new];
        OPSearcher *searcher=[tempD objectForKey:k];
        sear.name=k;
        sear.description=searcher.description;
        

        sear.title=[NSString stringWithFormat:@"Search %@:",sear.description];
        
        //make icon:
        NSImage*userIcon=[gIndexManager searchIconForKey:k];
        if(userIcon!=nil){
            sear.icon=userIcon;
            sear.icon.size=NSMakeSize(512, 512);
        }
        
        sear.subtitle=[NSString stringWithFormat:@"%@ - %@%@",sear.name,searcher.domain,searcher.suffix];
        [sear setTarget:self selector:@selector(triggerKeyWord:)];
        [self.searchesArray addObject:sear];
    }
}
-(void)buildfunctionArray{
    self.functionsArray=[NSMutableArray array];
    for (NSString* k in [[gDefaultFunctions allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        MSelectionItem *func=[MSelectionItem new];
        func.name=k;
        func.title=k;
        func.subtitle=[gDefaultFunctions valueForKey:k];
        [func setTarget:self selector:@selector(triggerKeyWord:)];
        [self.functionsArray addObject:func];
    }
}
-(void)buildApplicationArray{
    self.applicationsArray=[NSMutableArray array];
    
    NSDictionary *tempD=[gIndexManager.index objectForKey:@"programList"];
    for (NSString* k in [tempD allKeys]) {
        MSelectionItem *prog=[MSelectionItem new];
        prog.title=k;
        prog.name=k;
        prog.subtitle=[tempD valueForKey:k];
        
        //make icon:
        NSImage*userIcon=[gIndexManager programIconForKey:k];
        if(userIcon!=nil){
            prog.icon=userIcon;
            prog.icon.size=NSMakeSize(512, 512);
        }else if ([prog.subtitle hasPrefix:@"http"]) {
            [prog setIconWithPath:@"/Applications/Google Chrome.app"];
        }else if([prog.subtitle hasPrefix:@"/"]){
            [prog setIconWithPath:prog.subtitle];
        }
        [prog setTarget:self selector:@selector(triggerKeyWord:)];
        [self.applicationsArray addObject:prog];
    }
    //construct application list from /Applications folder*****
    NSFileManager *fm=[NSFileManager defaultManager];
    NSArray *tempA=[[fm contentsOfDirectoryAtPath:@"/Applications" error:nil]sortedArrayUsingSelector:(@selector(localizedCaseInsensitiveCompare:))];
    for(NSString* k in tempA){
        NSString *path = [NSString stringWithFormat:@"/Applications/%@",k];
        BOOL isDir = NO;
        [fm fileExistsAtPath:path isDirectory:(&isDir)];
        if(isDir) {
            NSArray *inDir=[[fm contentsOfDirectoryAtPath:path error:nil]sortedArrayUsingSelector:(@selector(localizedCaseInsensitiveCompare:))];
            for(NSString* j in inDir){
                if ([j hasSuffix:@".app"]) {
                    [self.applicationsArray addObject:[MSelectionItem itemFromFullPath:[path stringByAppendingPathComponent:j]]];
                }
            }
        }
        if ([k hasSuffix:@".app"]) {
            [self.applicationsArray addObject:[MSelectionItem itemFromFullPath:path]];
        }
    }//***********************************************************
}



-(void)updateCalculation:(NSString *)expression{
    //parse the expression to a answer**************
    NSError *error = nil;
    if ([expression rangeOfString:@"="].location!=NSNotFound||expression.length==0) {
        error=[NSError new];
    }
    NSString *answer;
    
    //to make ^ work with ddmathparser
    expression=[expression stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    
    if (error==nil) {
        DDExpression *e = [DDExpression expressionFromString:expression error:&error];
        answer=[NSString stringWithFormat: @"%@",[e evaluateWithSubstitutions:nil evaluator:nil error:&error]];
    }
    if (error!=nil) {
        answer=@"";
    }//**********************************************
    
    
    //update calculation selection item
    [self willChangeValueForKey:@"selectionItemArray"];
    if (answer.length==0) {
        if ([self.selectionItemArray containsObject:self.calculation]) {
            [self.selectionItemArray removeObject:self.calculation];
        }
    }else{
        self.calculation.calculation=answer;
        if (![self.selectionItemArray containsObject:self.calculation]) {
            [self.selectionItemArray insertObject:self.calculation atIndex:0];
        }
    }
    [self didChangeValueForKey:@"selectionItemArray"];
}

-(void)updateItunes{
    [self willChangeValueForKey:@"selectionItemArray"];
    //update itunes
    if ([self.itunesWatcher.itunesSelectionItem.title isEqualToString:@"Stopped"]) {
        if ([self.selectionItemArray containsObject:self.itunesWatcher.itunesSelectionItem]) {
            [self.selectionItemArray removeObject:self.itunesWatcher.itunesSelectionItem];
        }
    }else{
        if (![self.selectionItemArray containsObject:self.itunesWatcher.itunesSelectionItem]) {
            [self.selectionItemArray addObject:self.itunesWatcher.itunesSelectionItem];
        }
    }
    [gAppDelegate.mainWindowController updateHeight];
    [self didChangeValueForKey:@"selectionItemArray"];
}

-(void)updateItem:(MSelectionItem *)item withInput:(NSString *)input{
    NSMutableArray *arguments=[[input componentsSeparatedByString:@" "] mutableCopy];
    if([self.functionsArray containsObject:item]){
        if (arguments.count>1&&[arguments objectAtIndex:1]!=nil) {
            [arguments removeObjectAtIndex:0];
            item.title=[NSString stringWithFormat:@"%@: %@",item.name,[arguments componentsJoinedByString:@" "]];
        }else{
            item.title=item.name;
        }
    }
    if([self.searchesArray containsObject:item]){
        if (arguments.count>1&&[arguments objectAtIndex:1]!=nil) {
            [arguments removeObjectAtIndex:0];
            item.title=[NSString stringWithFormat:@"Search %@: %@",item.description,[arguments componentsJoinedByString:@" "]];
        }else{
            if ([item.name isEqualToString:item.description]) {
                item.title=item.name;
            }else{
                item.title=[NSString stringWithFormat:@"%@ - %@",item.name,item.description];
            }
        }
    }
}

-(void)updateContent:(NSString *)input{
    if (self.focusItem!=nil) {
        if (input!=nil&&[input rangeOfString:@" "].location!=NSNotFound) {
            [self updateItem:self.focusItem withInput:input];
            [self addInQueqe:self.focusItem];
            [self updateFromQueue];
            return;
        }else{
            self.focusItem=nil;
        }
    }

    NSString *temp;
    if (input.length!=0) {
        BOOL lastCharIsSpace=input.length>0&&[[input substringFromIndex:input.length-1] isEqualToString:@" "];
        unsigned long index=self.selectedIndexes.firstIndex;
        MSelectionItem *selectedItem;
        if(self.selectionItemArray.count>index)
            selectedItem=[self.selectionItemArray objectAtIndex:index];
        if (lastCharIsSpace&&selectedItem!=nil&&([self.searchesArray containsObject:selectedItem]||[self.functionsArray containsObject:selectedItem])) {
            self.focusItem=selectedItem;
            [self updateItem:self.focusItem withInput:input];
            [self addInQueqe:selectedItem];
        }else{
            NSString* lowerInput=[input lowercaseString];
            NSMutableArray *arguments=[[lowerInput componentsSeparatedByString:@" "] mutableCopy];
            //update function
            for (MSelectionItem *item in self.functionsArray) {
                temp=[item.name lowercaseString];
                if (([temp hasPrefix:[arguments objectAtIndex:0]]&&arguments.count==1)||[temp isEqualToString:[arguments objectAtIndex:0]]){
                    [self addInQueqe:item];
                }
            }
            //update searches
            for (MSelectionItem *item in self.searchesArray) {
                temp=[item.name lowercaseString];
                if (([temp hasPrefix:[arguments objectAtIndex:0]]&&arguments.count==1)||[temp isEqualToString:[arguments objectAtIndex:0]]){
                    [self addInQueqe:item];
                }
            }
            //update application
            for (MSelectionItem *item in self.applicationsArray) {
                temp=[item.name lowercaseString];
                if ([temp rangeOfString:[NSString stringWithFormat:@" %@",input]].location!=NSNotFound||[temp hasPrefix:[arguments objectAtIndex:0]]){
                    [self addInQueqe:item];
                }
            }
        }
    }[self updateFromQueue];
}

-(void)addInQueqe:(MSelectionItem *)item{
    if (self.queue.count>=5) {
        return;
    }
    for(MSelectionItem* k in self.queue){
        if (k==item)
            return;
    }
    [self.queue addObject:item];
}

-(void)updateFromQueue{
    [self willChangeValueForKey:@"selectionItemArray"];

    MSelectionItem *tempItem;
    
    //remove items in selectionItemArray that are not in queue
    for(int k=0;k<self.selectionItemArray.count;k++){
        tempItem=[self.selectionItemArray objectAtIndex:k];
        if ([self.queue containsObject:tempItem]){
            [self.queue removeObject:tempItem];
            continue;
        }else{
            if (!isSpecialItem(tempItem)) {
                [self.selectionItemArray removeObjectAtIndex:k];
                k--;
            }
        }
    }
    
    //add the rest in queue to the selectionItemArray
    BOOL hasItunes=[self.selectionItemArray containsObject: self.itunesWatcher.itunesSelectionItem];
    if (hasItunes) [self.selectionItemArray removeObject:self.itunesWatcher.itunesSelectionItem];
    for (MSelectionItem* item in self.queue) [self.selectionItemArray addObject:item];
    if (hasItunes) [self.selectionItemArray addObject:self.itunesWatcher.itunesSelectionItem];
    
    //clear queue
    [self.queue removeAllObjects];
    [self didChangeValueForKey:@"selectionItemArray"];
    [self resetSelection];//reset selection index to 0
}



-(void)resetSelection{
    if (self.selectionItemArray.count>0) {
        self.selectedIndexes=[NSIndexSet indexSetWithIndex:0];
    }
}
-(void)nextSelection{
    if (self.selectionItemArray.count>self.selectedIndexes.firstIndex+1) {
        self.selectedIndexes=[NSIndexSet indexSetWithIndex:self.selectedIndexes.firstIndex+1];
    }
}
-(void)previousSelection{

    if (self.selectedIndexes.firstIndex>0) {
        self.selectedIndexes=[NSIndexSet indexSetWithIndex:self.selectedIndexes.firstIndex-1];
    }
}


-(int)viewHeight{
    return selectionItemHeight*(int)[self.selectionItemArray count];
}//return the height of the selectionView

-(void)triggerCurrentSelectedItem{
    if (self.selectionItemArray.count>self.selectedIndexes.firstIndex) {
        [((MSelectionItem *)[self.selectionItemArray objectAtIndex:self.selectedIndexes.firstIndex]) trigger];
    }else{
        [self triggerKeyWord:nil];
    }
}

-(void)nothing:(MSelectionItem *)item{}//for seletionItem that do nothing

-(void)triggerKeyWord:(MSelectionItem *)item{
    NSString *command = gAppDelegate.mainWindowController.commandTextBox.stringValue;
    if (command.length==0) {
        //[[NSAlert alertWithMessageText:@"Empty Command!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
        return;
    }
    
    NSMutableArray *arguments=[[command componentsSeparatedByString:@" "] mutableCopy];
    NSString *keyWord;
    if (item!=nil) {
        keyWord=item.name;
        [arguments replaceObjectAtIndex:0 withObject:keyWord];
    }
    MDispatcher *dispatcher=[[MDispatcher alloc]init];
    
    if(![dispatcher processArgList:arguments]){
             //if displayed fail:
            [[NSAlert alertWithMessageText:@"Key not found!" defaultButton:@"OK"
                           alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
    }
    
    if ([keyWord isEqualToString:@"remove"]) {
        [self buildApplicationArray];
        [self buildSearchArray];
    }else if ([keyWord isEqualToString:@"add"]) {
        [self buildApplicationArray];
    }else if ([keyWord isEqualToString:@"adds"]) {
        [self buildSearchArray];
    }
}


-(void)add{
    [self willChangeValueForKey:@"selectionItemArray"];
    [self.selectionItemArray addObject:[MSelectionItem new]];
    [self didChangeValueForKey:@"selectionItemArray"];
}
@end
