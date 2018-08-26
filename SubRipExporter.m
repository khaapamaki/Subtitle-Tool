//
//  SubRipExporter.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 30.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "SubRipExporter.h"

@implementation SubRipExporter

- (BOOL)export:(SubtitleData *)subtitleData toPath:(NSString *)path options:(NSNumber *)options {
    NSMutableString *newFile = [NSMutableString new];

    unsigned long subtitleCounter = 1;
    NSError *err = nil;
    _lastError = nil;
    _errorMessage = nil;
    
    if (options != nil) {
        // add placeholder to the begining of first hour
        if ([options integerValue] != 0) {
            int firstHour = subtitleData.firstTimecode.hours;
            Timecode *inTC = [Timecode timecodeWithHours:firstHour minutes:0 seconds:0 frames:0 timecodeBase:subtitleData.timecodeBase];
            Timecode *outTC = [inTC timecodeByAddingSeconds:@(1)];

            [newFile appendString:[NSString stringWithFormat:@"%lu\n", subtitleCounter++]];
            [newFile appendString:[NSString stringWithFormat:@"%@ --> %@\n",
                                   [inTC getTimecodeStringWithMilliseconds],
                                   [outTC getTimecodeStringWithMilliseconds]]];
            [newFile appendString:[NSString stringWithFormat:@"TC %@\n", [inTC getTimecodeStringWithFrames]]];
            [newFile appendString:@"\n"];
        }
    }
    
    for (Subtitle * thisSub in subtitleData.subtitles) {
        [newFile appendString:[NSString stringWithFormat:@"%lu\n", subtitleCounter++]];
        [newFile appendString:[NSString stringWithFormat:@"%@ --> %@\n",
                               [thisSub.timecodeIn getTimecodeStringWithMilliseconds],
                               [thisSub.timecodeOut getTimecodeStringWithMilliseconds]]];
        for (NSString *thisLine in thisSub.lines) {
            NSMutableString * fixedLine = [thisLine mutableCopy];
            
            [newFile appendString:[fixedLine stringByAppendingString:@"\n"]];
       
        }
        [newFile appendString:@"\n"];
    }

    if (path != nil) {
        NSString *BOMstring = [[NSString alloc] initWithFormat:@"\357\273\277%@", newFile];
        [BOMstring writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
        newFile = nil;
        
        if (err != nil) {
            _lastError = err;
            _errorMessage = [err localizedDescription];
            return NO;
        }
        
        return YES;
    }
    _errorMessage = @"No path";
    
    return NO;

}

-(instancetype) init {
    if (self = [super init]) {
        _errorMessage = nil;
        _lastError = nil;
    }
    
    return self;
}

@end
