//
//  SubtitleFile.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 29.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "SubtitleData.h"

@implementation SubtitleData

-(id)init {
    if (self = [super init]) {
        _firstTimecode = nil;
        _lastTimecode = nil;
        _subtitles = nil;
        _title = nil;
        _timecodeBase = nil;
        _pathToSource = nil;
    }
    return self;
}
@end

