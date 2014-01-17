//
//  MItunesWatcher.m
//  Miya
//
//  Created by Luke Zhao on 2013-01-26.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "MItunesWatcher.h"
#import "MSelectionViewController.h"
@implementation MItunesWatcher
-(id)init{
    self=[super init];
    iTunes=[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    
    //setup itunes selecitonitem:
    self.itunesSelectionItem=[MSelectionItem itemFromFullPath:@"/Applications/iTunes.app"];
    self.itunesSelectionItem.name=@"iTunesWatcher";
    self.itunesSelectionItem.title=@"Stopped";
    
    [self.itunesSelectionItem setTarget:self selector:@selector(playPause:)];
    [self.itunesSelectionItem setTargetLeft:self selectorLeft:@selector(previousSong:)];
    [self.itunesSelectionItem setTargetRight:self selectorRight:@selector(nextSong:)];
    
    track=[iTunes currentTrack];
    if ([iTunes isRunning]) {
        self.itunesSelectionItem.title=@"iTunes";
        
        if ([track name]!=nil) {
            NSString* state;
            if ([iTunes playerState]==iTunesEPlSPlaying) {
                state=@"Playing";
            }else if ([iTunes playerState]==iTunesEPlSPaused){
                state=@"Paused";
            }else if ([iTunes playerState]==iTunesEPlSStopped){
                state=@"Stopped";
            }
            [self setArtWork];
            self.itunesSelectionItem.title=[NSString stringWithFormat:@"%@: %@",state,[track name]];
            self.itunesSelectionItem.subtitle=[NSString stringWithFormat:@"By: %@   Album: %@",[track artist],[track album]];
        }
    }
    
    //setup listener
    NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(updateTrackInfo:) name:@"com.apple.iTunes.playerInfo" object:nil];
    
    return self;
}
-(void)nextSong:(MSelectionItem *)sender{
    if (![iTunes isRunning]) {
        [iTunes run];
    }
    [iTunes nextTrack];
}
-(void)previousSong:(MSelectionItem *)sender{
    if (![iTunes isRunning]) {
        [iTunes run];
    }
    [iTunes previousTrack];
}
-(void)playPause:(MSelectionItem *)sender{
    if (![iTunes isRunning]) {
        [iTunes run];
    }
    [iTunes playpause];
}

-(void)setArtWork{
    NSArray* theArtworks = [[track artworks]get];
    if ([theArtworks count]>0) {
        NSLog(@"MItunesWatcher-setArtWork: current music has icon");
        self.itunesSelectionItem.icon=[[NSImage alloc] initWithData:[[theArtworks lastObject] rawData]];
        self.itunesSelectionItem.icon.size=NSMakeSize(400, 400);
    }else{
        [self.itunesSelectionItem setIconWithPath:@"/Applications/iTunes.app"];
    }
}

- (void) updateTrackInfo:(NSNotification *)notification {
    track=[iTunes currentTrack];
    NSDictionary *information = [notification userInfo];
    //NSLog(@"track information: %@", information);
    NSString *state=[information objectForKey:@"Player State"];
    if ([state isEqualToString:@"Playing"]||[state isEqualToString:@"Paused"]) {
        [self setArtWork];
        self.itunesSelectionItem.title=[NSString stringWithFormat:@"%@: %@",state,[track name]];
        self.itunesSelectionItem.subtitle=[NSString stringWithFormat:@"By: %@   Album: %@",[track artist],[track album]];
    }else{
        self.itunesSelectionItem.title=@"Stopped";
    }
    [gSelectionViewController updateItunes];
}


-(void)setLabelWithPlaying:(BOOL)state{
    
}
@end
