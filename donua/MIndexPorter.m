//
//  MIndexPorter.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-24.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MIndexPorter.h"
#import "OPIndexManager.h"
#import "MAppDelegate.h"
#import "MSettingWindowController.h"
#import "OPSearcher.h"


@implementation MIndexPorter


-(void)importFromFilePath:(NSString *)path{
    NSData *indexData = [NSData dataWithContentsOfFile:path];
    self.buffer=(NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData: indexData];
    [gAppDelegate.settingWindowController willChangeValueForKey:@"im"];
    [self importBufferPrograms];
    [self importBufferSearches];
    [gAppDelegate.settingWindowController didChangeValueForKey:@"im"];
}

-(void)importBufferPrograms{
    NSDictionary *programList=[self.buffer objectForKey:@"programList"];
    for (NSString *key in [programList allKeys]) {
        [gIndexManager addProgramKey:key forValue:[programList objectForKey:key] icon:nil];
    }
}
-(void)importBufferSearches{
    NSDictionary *searchList=[self.buffer objectForKey:@"searchList"];
    OPSearcher *temp=nil;
    for (NSString *key in [searchList allKeys]) {
        temp=[searchList objectForKey:key];
        [gIndexManager addSearchKey:key domain:temp.domain suffix:temp.suffix];
    }
}
-(void)exportToFileURL:(NSURL *)path{
    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:gIndexManager.index];
    [indexData writeToURL:path atomically:YES];
}
@end
