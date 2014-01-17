//
//  OPIndexManager.m
//  op
//
//  Created by Luke Zhao on 2013-01-14.
//  Copyright (c) 2013 Luke Zhao. All rights reserved.
//

#import "OPIndexManager.h"
#import "Information.h"
#import "MSelectionViewController.h"

#define programList [self.index objectForKey:@"programList"]
#define searchList [self.index objectForKey:@"searchList"]
#define programIconList [self.userIcons objectForKey:@"programList"]
#define searchIconList [self.userIcons objectForKey:@"searchList"]

#define iconFor(name,type) [[NSImage alloc]initByReferencingFile:[[NSBundle mainBundle] pathForResource:name ofType:type]]
NSString* convertToURL(NSString *s){
    if ([s hasPrefix:@"http://"]||[s hasPrefix:@"https://"]) {
        return s;
    }
    if ([s hasPrefix:@"www."]){
        s=[s substringFromIndex:4];
    }
    return [NSString stringWithFormat:@"http://www.%@", s];
}

@implementation OPIndexManager{
    NSString *indexPATH,*iconPATH;
    BOOL massEditing;
}

-(id)init{
    if (self=[super init]) {
        massEditing=NO;
        //load index
        indexPATH =[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        
        NSFileManager *fm=[NSFileManager defaultManager];
        //icon
        iconPATH =[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        iconPATH=[iconPATH stringByAppendingPathComponent:@"icon"];
        if ([fm fileExistsAtPath:iconPATH]) {
            NSData *indexData = [NSData dataWithContentsOfFile:iconPATH];
            self.userIcons=(NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData: indexData];
        }
        //if icon not found: create a new default index and save it
        if (self.userIcons==nil) {
            NSLog(@"icon is nil, creating new index.");
            [self factoryDefault];
        }
        
        indexPATH=[indexPATH stringByAppendingPathComponent:@"index"];
        //NSLog(@"%@",indexPATH);
        if ([fm fileExistsAtPath:indexPATH]) {
            NSData *indexData = [NSData dataWithContentsOfFile:indexPATH];
            self.index=(NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData: indexData];
        }
        //if index not found: create a new default index and save it
        if (self.index==nil) {
            NSLog(@"index is nil, creating new index.");
            [self factoryDefault];
        }
        
        

    }
    return self;
}

//default list
-(void)factoryDefault{
    self.index=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableDictionary dictionary],@"searchList",[NSMutableDictionary dictionary],@"programList", nil];
    self.userIcons=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableDictionary dictionary],@"searchList",[NSMutableDictionary dictionary],@"programList", nil];
    
    massEditing=YES;
    [self addProgramKey:@"finder" forValue:@"/" icon:nil];
    [self addSearchKey:@"google" domain:convertToURL(@"google.com") suffix:@"/search?q=" description:@"Google" icon:iconFor(@"google",@"png")];
    [self addSearchKey:@"wolframalpha" domain:convertToURL(@"wolframalpha.com") suffix:@"/input/?i=" description:@"WolframAlpha" icon:iconFor(@"wolframalpha",@"png")];
    [self addSearchKey:@"youtube" domain:convertToURL(@"youtube.com") suffix:@"/results?search_query=" description:@"YouTube" icon:iconFor(@"youtube",@"png")];
    [self addSearchKey:@"bing" domain:convertToURL(@"bing.com") suffix:@"/search?q=" description:@"Bing" icon:iconFor(@"bing",@"png")];
    [self addSearchKey:@"deviantart" domain:convertToURL(@"deviantart.com") suffix:@"/?q=" description:@"deviantART" icon:iconFor(@"deviantart",@"icns")];
    [self addSearchKey:@"yahoo" domain:@"http://search.yahoo.com/" suffix:@"/search?p=" description:@"Yahoo" icon:iconFor(@"yahoo",@"png")];
    [self addSearchKey:@"facebook" domain:convertToURL(@"facebook.com") suffix:@"/search/results.php?q=" description:@"Facebook" icon:iconFor(@"facebook",@"icns")];
    massEditing=NO;
    [self saveIndex];
}
-(void)setProgramIcon:(NSImage *)icon forKey:(NSString *)key{
    [programIconList setValue:icon forKey:key];
}
-(void)setSearchIcon:(NSImage *)icon forKey:(NSString *)key{
    [searchIconList setValue:icon forKey:key];
}
-(NSImage *)programIconForKey:(NSString *)key{
    return [programIconList valueForKey:key];
}
-(NSImage *)searchIconForKey:(NSString *)key{
    return [searchIconList valueForKey:key];
}
-(void)addSearchKey:(NSString *)k domain:(NSString *)d suffix:(NSString *)s{
    [searchList setObject:[[OPSearcher alloc] initWithDomain:d suffix:s description:k] forKey:k];
    [self saveIndex];
}

//search keys
-(void)addSearchKey:(NSString *)k domain:(NSString *)d suffix:(NSString *)s description:(NSString *)des icon:(NSImage *)icon{
    if (des==nil) {
        des=k;
    }
    [searchList setObject:[[OPSearcher alloc] initWithDomain:d suffix:s description:des] forKey:k];
    if (icon!=nil) {
        [searchIconList setValue:icon forKey:k];
    }
    [self saveIndex];
}

-(NSString *)domainForSearchKey:(NSString *)k{
    return [self urlAttributesForSearchKey:k].domain;
}

-(OPSearcher *)urlAttributesForSearchKey:(NSString *)k{
    OPSearcher *value=[searchList objectForKey:k];
    if (value==nil) {
        NSLog(@"Key not found in search list!");
    }
    return value;
}


//program keys
-(void)addProgramKey:(NSString *)k forValue:(NSString *)v icon:(NSImage *)icon{
    [programList setObject:v forKey:k];
    if (icon!=nil) {
        [programIconList setValue:icon forKey:k];
    }
    [self saveIndex];
}


-(NSString *)valueForProgramKey:(NSString *)k{
    NSString *value=[programList objectForKey:k];
    if (value==nil) {
        value=[self domainForSearchKey:k];
        if (value==nil) {
            NSLog(@"Key not found in program list!");
            return nil;
        }
    }
    return value;
}


-(void)removeKey:(NSString *)k{
    if ([programList objectForKey:k]!=nil) {
        [programList removeObjectForKey:k];
        [programIconList removeObjectForKey:k];
    }else if ([searchList objectForKey:k]!=nil) {
        [searchList removeObjectForKey:k];
        [searchIconList removeObjectForKey:k];
    }else{
        NSLog(@"Key not found.");
    }
    [self saveIndex];
}


-(BOOL)saveIndex{
    if (!massEditing) {
        NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:self.index];
        [indexData writeToFile:indexPATH atomically:YES];
        NSLog(@"index contents:%@",self.index);
        NSData *iconData = [NSKeyedArchiver archivedDataWithRootObject:self.userIcons];
        [iconData writeToFile:iconPATH atomically:YES];
        [gSelectionViewController buildIndexArrays];
    }
    return YES;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@",self.index];
}

@end
