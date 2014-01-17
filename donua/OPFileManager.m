//
//  OPFileManager.m
//  op
//
//  Created by Luke Zhao on 2013-01-14.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "OPFileManager.h"

@implementation OPFileManager
-(id)init{
    if(self=[super init]){
        self.fm=[NSFileManager defaultManager];
    }return self;
}
-(BOOL)copyFrom:(NSString *)f to:(NSString *)t{
    if([self.fm fileExistsAtPath:f]==NO){
        NSLog(@"file not exist at path:%@",f);
        return NO;
    }
    
    NSError* error;
    if([self.fm copyItemAtPath:f toPath:t error:&error]==NO){
        NSLog(@"copy failed with error:%@",error);
        return NO;
    };
    
    return YES;
}
@end
