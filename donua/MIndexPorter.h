//
//  MIndexPorter.h
//  Miya
//
//  Created by Luke Zhao on 2013-01-24.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OPIndexManager;
@interface MIndexPorter : NSObject
@property (strong) NSDictionary *buffer;

-(void)importFromFilePath:(NSString *)path;
-(void)exportToFileURL:(NSURL *)path;

@end
