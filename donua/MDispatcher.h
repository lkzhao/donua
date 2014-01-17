//
//  OPDispatcher.h
//  op
//
//  Created by Luke Zhao on 2013-01-14.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPIndexManager;
@interface MDispatcher : NSObject

@property(nonatomic,retain) NSArray *keyWords;
@property(nonatomic,retain) NSArray *args;
@property(nonatomic,retain) NSString *firstArg;
-(BOOL)processArgList:(NSArray *)a;
+(void)openWithPath:(NSString *)path;
@end
