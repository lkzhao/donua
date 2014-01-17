//
//  MTableView.m
//  Donut
//
//  Created by Luke Zhao on 2013-01-30.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MTableView.h"
#import "MSelectionViewController.h"
@implementation MTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)textDidEndEditing:(NSNotification *)notification{
    [super textDidEndEditing:notification];
    [gSelectionViewController buildIndexArrays];
}

@end
