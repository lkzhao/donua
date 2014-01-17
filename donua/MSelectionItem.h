//
//  MSelectionItem.h
//  Miya
//
//  Created by Luke Zhao on 2013-01-25.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSelectionItem : NSObject
@property (strong) NSString *title,*subtitle,*calculation,*costomTrigger,*name,*description;
@property (strong) NSImage *icon;
@property (strong) id target,targetRight,targetLeft;
@property SEL selector,selectorRight,selectorLeft;

+(MSelectionItem *)itemFromFullPath:(NSString*)path;

-(void)trigger;
-(void)triggerLeft;
-(void)triggerRight;
-(void)setTarget:(id)t selector:(SEL)s;
-(void)setTargetRight:(id)t selectorRight:(SEL)s;
-(void)setTargetLeft:(id)t selectorLeft:(SEL)s;

-(id)initWithTitle:(NSString *)t subTitle:(NSString *)s icon:(NSImage *)i;

-(void)setIconWithIcnsNameInResource:(NSString *)imageName;
-(void)setIconWithPath:(NSString *)path;
@end
