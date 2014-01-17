//
//  MItunesWatcher.h
//  Miya
//
//  Created by Luke Zhao on 2013-01-26.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"
#import "MSelectionItem.h"

@interface MItunesWatcher : NSObject{
    iTunesApplication *iTunes;
    iTunesTrack *track;
}
@property (strong) MSelectionItem * itunesSelectionItem;
-(void)nextSong:(MSelectionItem *)sender;
-(void)previousSong:(MSelectionItem *)sender;
-(void)playPause:(MSelectionItem *)sender;
@end
