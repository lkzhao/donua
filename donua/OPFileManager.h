//
//  OPFileManager.h
//  op
//
//  Created by Luke Zhao on 2013-01-14.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPFileManager : NSObject
@property(nonatomic,retain) NSFileManager* fm;
-(id)init;
-(BOOL)copyFrom:(NSString *)f to:(NSString *)t;
@end
