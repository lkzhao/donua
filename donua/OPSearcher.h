//
//  OPSearcher.h
//  Miya
//
//  Created by Luke Zhao on 2013-01-21.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPSearcher : NSObject <NSCopying>
@property(nonatomic) NSString *domain,*suffix,*description;

-(id)initWithDomain:(NSString *)d suffix:(NSString *)s description:(NSString *)des;
- (void)encodeWithCoder:(NSCoder *)encoder;

- (id)initWithCoder:(NSCoder *)decoder;
-(id)copyWithZone:(NSZone*)zone;
@end
