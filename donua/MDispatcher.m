//
//  MDispatcher.m
//  op
//
//  Created by Luke Zhao on 2013-01-14.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//





/*****************************************************
 gets called when a string command is entered.
 dispatches tasks from command given
 
 instance gets created and used for one ONLY one command.
 
 Note: this should only process information that is passed by return
 
*****************************************************/



#import "MDispatcher.h"
#import "OPFileManager.h"
#import "OPIndexManager.h"
#import "Information.h"
#import "MAppDelegate.h"
#import "MSettingWindowController.h"
#import "MSelectionViewController.h"

@implementation MDispatcher
-(BOOL)processArgList:(NSArray *)a{
    self.keyWords=[[gDefaultFunctions allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.args=a;

    self.firstArg=[self.args objectAtIndex:0];
    
    if ([self.keyWords containsObject:self.firstArg]) {
        NSLog(@"Doing %@",self.firstArg);
        return [self dispatchFunction];
    }else{
        return [self openFromIndex];
    }
    
    return YES;
}

-(void)setArgs:(NSArray *)args{
    _args=args;
    if ([self.args count]<1) {
        self.firstArg=nil;
    }else
        self.firstArg=[self.args objectAtIndex:0];
}

//use to dispatch special functions from the keywords list
-(BOOL)dispatchFunction{
    OPFileManager *fm=[[OPFileManager alloc]init];
    
    //@"list",@"help",@"move",@"delete",@"rename",@"setURL",@"w",@"g"
#define is(NSString) [self.firstArg isEqualToString:NSString]
#define argCount [self.args count]
    //list function
    if(is(@"list")){
        NSLog(@"showing index:%@",gIndexManager);
    }
    
    //copy function
    if(is(@"copy")){
        if (argCount==3) {
            [fm copyFrom:[self.args objectAtIndex:1] to:[self.args objectAtIndex:2]];
        }else if([self.args count]>3){
            //copy more files
        }else{
            NSLog(@"usage failed: copy [src1 src2 ... dest]");
        }
    }
    
    [gAppDelegate.settingWindowController willChangeValueForKey:@"im"];
    
    //add index function
    if(is(@"add")){
        if (argCount==3) {
            //setting program
            NSString *key=[self.args objectAtIndex:1];
            NSString *value=[self.args objectAtIndex:2];
            [gIndexManager addProgramKey:key forValue:value icon:nil];
            NSLog(@"Key-value added successfully, launching...");
            self.args=[NSArray arrayWithObjects:key, nil];
            [self openFromIndex];
        }if (argCount>=3) {
            //setting program
            NSString *key=[self.args objectAtIndex:1];
            NSString *value=[self stringAppendFromArray:self.args startsAt:2];
            [gIndexManager addProgramKey:key forValue:value icon:nil];
            NSLog(@"Key-value added successfully, launching...");
            self.args=[NSArray arrayWithObjects:key, nil];
            [self openFromIndex];
        }else if(argCount==1){
            //display add
        }else{
            NSLog(@"usage failed: add");
        }
    }
    
    //remove index function
    if(is(@"remove")){
        if (argCount==2) {
            [gIndexManager removeKey:[self.args objectAtIndex:1]];
        }else if(argCount==1){
            //display remove
        }else{
            NSLog(@"usage failed: remove");
        }
    }
    
    //setURL index function
    if(is(@"adds")){
        if (argCount==3) {
            NSString *key=[self.args objectAtIndex:1];
            NSString *value=convertToURL([self.args objectAtIndex:2]);
            [gIndexManager addProgramKey:key forValue:value icon:nil];
            NSLog(@"Key-value added successfully, launching...");
            self.args=[NSArray arrayWithObjects:key, nil];
            [self openFromIndex];
        }else if(argCount==4){
            //setting search:
            NSString *key=[self.args objectAtIndex:1];
            NSString *domain=convertToURL([self.args objectAtIndex:2]);
            NSString *suffix=[self.args objectAtIndex:3];
            [gIndexManager addSearchKey:key domain:domain suffix:suffix];
            NSLog(@"Key-Domain-Suffix added successfully.");
            self.args=[NSArray arrayWithObjects:key, nil];
            [self openFromIndex];
        }else if(argCount==1){
            //display add
        }else{
            NSLog(@"usage failed: adds");
        }
    }
    //setURL index function
    if(is(@"nextsong")){
        if(argCount==1){
            [gSelectionViewController.itunesWatcher nextSong:nil];
        }else{
            NSLog(@"usage failed: nextsong");
        }
    }
    if(is(@"previoussong")){
        if(argCount==1){
            [gSelectionViewController.itunesWatcher previousSong:nil];
        }else{
            NSLog(@"usage failed: previoussong");
        }
    }
    if(is(@"play/pause")){
        if(argCount==1){
            [gSelectionViewController.itunesWatcher playPause:nil];
        }else{
            NSLog(@"usage failed: play/pause");
        }
    }
    
    
    [gAppDelegate.settingWindowController didChangeValueForKey:@"im"];
    return YES;
}


-(NSString *) stringAppendFromArray:(NSArray *)arr startsAt:(int)s{
    NSMutableArray *temp=[NSMutableArray new];
    for (int i = s; i<[arr count]; i++) {
        [temp addObject:[arr objectAtIndex:i]];
    }
    return [temp componentsJoinedByString:@" "];
}


//URL related:
-(NSArray *) searchKeywordsFromArgs{
    NSMutableArray *temp=[NSMutableArray new];
    for (int i = 1; i<[self.args count]; i++) {
        [temp addObject:[self.args objectAtIndex:i]];
    }
    return temp;
}
-(void)searchWithDomain:(NSString *)d suffix:(NSString *)s keywords:(NSArray *)k{
    NSMutableArray *filteredKeyWords=[NSMutableArray new];
    for (NSString *c in k) {
        [filteredKeyWords addObject:[c stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]];
    }
    NSString *keywords=[filteredKeyWords componentsJoinedByString:@"+"];
    d = [NSString stringWithFormat:@"%@%@%@",d,s,keywords];
    [MDispatcher openWithPath:d];
}





-(BOOL)openFromIndex{
    NSString *key = self.firstArg;
    if ([self.args count]>=2) {
        //must be a search:
        OPSearcher *command = [gIndexManager urlAttributesForSearchKey:key];
        if (command==nil) {
            NSLog(@"Search key not found.");
            return NO;
        }
        NSArray *keywords=[self searchKeywordsFromArgs];
        [self searchWithDomain:command.domain suffix:command.suffix keywords:keywords];
    }else{
        //must be opening a program or url:
        NSString *command = [gIndexManager valueForProgramKey:key];
        if(command!=nil)
            [MDispatcher openWithPath:command];
        else{
            NSLog(@"command not found!");
            return NO;
        }
        
    }return YES;
}
+(void)openWithPath:(NSString *)path{
    NSArray *arguments=[NSArray arrayWithObject:path];
    [[NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" arguments:arguments] waitUntilExit];
}

@end
