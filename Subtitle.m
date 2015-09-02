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

- (id)init {
    if (self = [super init]) {
        _lines = [NSMutableArray new];
        _test = @"00:00:00:00";
    }
    return self;
}
@end
