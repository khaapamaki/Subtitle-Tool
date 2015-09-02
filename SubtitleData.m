//
//  SubtitleData.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 29.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "SubtitleData.h"

@implementation SubtitleData

-(Timecode *)firstTimecode {
    if (self.subtitles == nil) return nil;
    
    Timecode *lowest = nil;
    for (Subtitle *thisSub in self.subtitles) {
        if (lowest == nil) {
            lowest = thisSub.timecodeIn;
        } else {
            if (thisSub.timecodeIn.timeValue < lowest.timeValue) lowest = thisSub.timecodeIn;
        }
    }
    return lowest;
}

-(Timecode *)lastTimecode {
    if (self.subtitles == nil) return nil;
    
    Timecode *highest = nil;
    for (Subtitle *thisSub in self.subtitles) {
        if (highest == nil) {
            highest = thisSub.timecodeOut;
        } else {
            if (thisSub.timecodeIn.timeValue > highest.timeValue) highest = thisSub.timecodeIn;
        }
    }
    return highest;
}


-(id)init {
    if (self = [super init]) {
        _subtitles = nil;
        _title = nil;
        _timecodeBase = nil;
        _pathToSource = nil;
    }
    return self;
}
@end

