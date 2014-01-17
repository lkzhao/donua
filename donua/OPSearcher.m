//
//  OPSearcher.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-21.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "OPSearcher.h"
#import "MAppDelegate.h"
#import "OPIndexManager.h"

@implementation OPSearcher

-(id)initWithDomain:(NSString *)d suffix:(NSString *)s description:(NSString *)des{
    self=[super init];
    self.domain=d;
    self.suffix=s;
    self.description=des;
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.domain forKey:@"domain"];
    [encoder encodeObject:self.suffix forKey:@"suffix"];
    [encoder encodeObject:self.description forKey:@"description"];
}
-(void)setDescription:(NSString *)description{
    [self willChangeValueForKey:@"description"];
    _description=description;
    [self didChangeValueForKey:@"description"];
    [gIndexManager saveIndex];
}
-(void)setDomain:(NSString *)domain{
    [self willChangeValueForKey:@"domain"];
    _domain=domain;
    [self didChangeValueForKey:@"domain"];
    [gIndexManager saveIndex];
}
-(void)setSuffix:(NSString *)suffix{
    [self willChangeValueForKey:@"suffix"];
    _suffix=suffix;
    [self didChangeValueForKey:@"suffix"];
    [gIndexManager saveIndex];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.domain = [decoder decodeObjectForKey:@"domain"];
        self.suffix = [decoder decodeObjectForKey:@"suffix"];
        self.description = [decoder decodeObjectForKey:@"description"];
    }
    return self;
}

-(id)copyWithZone:(NSZone*)zone{
    //NSLog(@"Searcher:{%@} got copied",self);
    return self;
}
@end
