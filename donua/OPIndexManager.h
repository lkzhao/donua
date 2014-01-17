//
//  OPIndexManager.h
//  op
//
//  Created by Luke Zhao on 2013-01-14.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPSearcher.h"

NSString* convertToURL(NSString *s);
@interface OPIndexManager : NSObject
@property(strong) NSMutableDictionary *index;
@property(strong) NSMutableDictionary *userIcons;

-(id)init;

//icon related:
-(void)setProgramIcon:(NSImage *)icon forKey:(NSString *)key;
-(void)setSearchIcon:(NSImage *)icon forKey:(NSString *)key;
-(NSImage *)programIconForKey:(NSString *)key;
-(NSImage *)searchIconForKey:(NSString *)key;




-(void)addSearchKey:(NSString *)k domain:(NSString *)d suffix:(NSString *)s description:(NSString *)des icon:(NSImage *)icon;
-(void)addSearchKey:(NSString *)k domain:(NSString *)d suffix:(NSString *)s;
-(NSString *)domainForSearchKey:(NSString *)k;
-(OPSearcher *)urlAttributesForSearchKey:(NSString *)k;




-(void)addProgramKey:(NSString *)k forValue:(NSString *)v icon:(NSImage *)icon;
-(NSString *)valueForProgramKey:(NSString *)k;

-(void)factoryDefault;
-(void)removeKey:(NSString *)k;
-(BOOL)saveIndex;

@end
