//
//  MSelectionItem.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-25.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MSelectionItem.h"
#import "MDispatcher.h"

@implementation MSelectionItem

+(MSelectionItem *)itemFromFullPath:(NSString*)path{
    NSString *title=[path lastPathComponent];
    title=[title substringToIndex:[title length]-4];
    MSelectionItem *item=[[MSelectionItem alloc]initWithTitle:title subTitle:path icon:[[NSWorkspace sharedWorkspace]iconForFile:path]];
    item.icon.size=NSMakeSize(512, 512);
    return item;
}
-(id)initWithTitle:(NSString *)t subTitle:(NSString *)s icon:(NSImage *)i{
    self=[self init];
    self.title=t;
    self.name=t;
    self.subtitle=s;
    self.costomTrigger=s;
    self.icon=i;
    return self;
}
-(void)trigger{
    if (self.target!=nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
    }else if (self.costomTrigger!=nil)
        [MDispatcher openWithPath:self.costomTrigger];
}
-(void)triggerLeft{
    if (self.targetLeft!=nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.targetLeft performSelector:self.selectorLeft withObject:self];
#pragma clang diagnostic pop
        NSLog(@"left trigger fired");
    }else if (self.costomTrigger!=nil)
        [MDispatcher openWithPath:self.costomTrigger];
}
-(void)triggerRight{
    if (self.targetRight!=nil) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.targetRight performSelector:self.selectorRight withObject:self];
#pragma clang diagnostic pop
    }else if (self.costomTrigger!=nil)
        [MDispatcher openWithPath:self.costomTrigger];
}
-(id)init{
    self=[super init];
    if (self) {
        self.title=@"";
        self.name=@"";
        self.subtitle=@"";
        self.calculation=@"";
        self.description=@"";
        self.costomTrigger=nil;
        self.icon=nil;
        self.target=nil;
        self.selector=nil;
    }
    return self;
}
-(void)setTarget:(id)t selector:(SEL)s{
    self.target=t;
    self.selector=s;
}
-(void)setTargetRight:(id)t selectorRight:(SEL)s{
    self.targetRight=t;
    self.selectorRight=s;
}
-(void)setTargetLeft:(id)t selectorLeft:(SEL)s{
    self.targetLeft=t;
    self.selectorLeft=s;
}
-(void)setIconWithIcnsNameInResource:(NSString *)imageName{
    self.icon=[[NSImage alloc]initByReferencingFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"icns"]];
    self.icon.size=NSMakeSize(512, 512);
}
-(void)setIconWithPath:(NSString *)path{
    self.icon=[[NSWorkspace sharedWorkspace] iconForFile:path];
    self.icon.size=NSMakeSize(512, 512);
}
@end
