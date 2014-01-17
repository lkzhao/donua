//
//  MCollectionView.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-25.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MCollectionView.h"
#import "MSelectionItem.h"
#import "MGradientView2.h"

@implementation MCollectionView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
/*-(BOOL)becomeFirstResponder{
    [self setSelectionIndexes:[NSMutableIndexSet indexSetWithIndex:0]];return YES;
}
-(BOOL)resignFirstResponder{
    [super setSelectionIndexes:[NSMutableIndexSet indexSet]];return YES;
}//*/

//detecting return key:
- (void)keyDown:(NSEvent*)event
{   NSLog(@"%d",[event keyCode]);
    if([event keyCode]==0x24){//return key
        [((MSelectionItem *)[self itemAtIndex:[[self selectionIndexes] firstIndex]].representedObject) trigger];
    }else if([event keyCode]==0x7B){//left arrow key
        [((MSelectionItem *)[self itemAtIndex:[[self selectionIndexes] firstIndex]].representedObject) triggerLeft];
    }else if([event keyCode]==0x7C){//right arrow key
        [((MSelectionItem *)[self itemAtIndex:[[self selectionIndexes] firstIndex]].representedObject) triggerRight];
    }else
        [super keyDown:event];
}



//detecting mouse trigger:
-(void)mouseDown:(NSEvent *)theEvent{
    int previousIndex=(int)[[self selectionIndexes] firstIndex];
    //change index with position
    NSLog(@"%f,%f",[theEvent locationInWindow].x,[theEvent locationInWindow].y);
    NSPoint mouseLocation=[theEvent locationInWindow];
    if(self.subviews.count>0){
        int height=((NSView *)[self.subviews objectAtIndex:0]).frame.size.height;
        int selection=((int)mouseLocation.y+1)/height+1;
        self.selectionIndexes=[NSIndexSet indexSetWithIndex:self.subviews.count-selection];
    }
    if (previousIndex==(int)[[self selectionIndexes] firstIndex]) {
        [((MSelectionItem *)[self itemAtIndex:previousIndex].representedObject) trigger];
    }//
}

- (void)drawRect:(NSRect)dirtyRect
{

}

@end
