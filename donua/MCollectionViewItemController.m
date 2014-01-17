//
//  MCollectionViewItemController.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-25.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MCollectionViewItemController.h"
#import "MGradientView2.h"

@interface MCollectionViewItemController ()

@end

@implementation MCollectionViewItemController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)setSelected:(BOOL)flag
{
    [super setSelected:flag];
    [(MGradientView2 *)[self view] setSelected:flag];
    [(MGradientView2 *)[self view] setNeedsDisplay:YES];
}

@end
