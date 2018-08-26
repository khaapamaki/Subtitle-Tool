//
//  Subtitle.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 28.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "Subtitle.h"

@implementation Subtitle

-(NSString *)timecodeInString {
    if (_timecodeIn != nil) {
        return [_timecodeIn getTimecodeStringWithFrames];
    }
    return @"";
}

-(NSString *)timecodeOutString {
    if (_timecodeIn != nil) {
        return [_timecodeOut getTimecodeStringWithFrames];
    }
    return @"";
}

-(NSString*)text {
    if (_lines != nil) {
        NSMutableString *displayStr = [[self.lines componentsJoinedByString:@" "] mutableCopy];
        [displayStr replaceString:@"<i>" withString:@""];
        [displayStr replaceString:@"</i>" withString:@""];
        return displayStr;
    }
    return @"";
}

-(instancetype)init {
    if (self = [super init]) {
        _lines = [NSMutableArray new];
    }
    return self;
}
@end
