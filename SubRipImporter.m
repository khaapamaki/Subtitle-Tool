//
//  SubRipImporter.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 30.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "SubRipImporter.h"

@implementation SubRipImporter

-(BOOL)readFileWithPath:(NSString *)path {

    NSError *err = nil;
    NSMutableArray *subtitleArray = [[NSMutableArray alloc] initWithCapacity:3000];
    NSString *contentString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];

    if (err != nil || contentString == nil) {
        return NO;
    }
    NSArray *linesInFile = [contentString componentsSeparatedByString:@"\n"];
    
    NSString *regexPattern = @"^([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}) --> ([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3})$";
    
    for (long index=0; index < [linesInFile count]; index++) {
        NSLog(@"%04lu:%@", index, linesInFile[index]);
        
        NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regexPattern options:regexOptions error:nil];
        NSTextCheckingResult *match = [regex firstMatchInString:linesInFile[index] options:0 range:NSMakeRange(0, [linesInFile[index] length])];
        
        if (match) {
            Subtitle *newSubtitle = [[Subtitle alloc] init];
            NSRange inTCRange = [match rangeAtIndex:1];
            NSRange outTCRange= [match rangeAtIndex:2];

            newSubtitle.timecodeIn = [Timecode timecodeWithString:[linesInFile[index] substringWithRange:inTCRange]];
            newSubtitle.timecodeOut = [Timecode timecodeWithString:[linesInFile[index] substringWithRange:outTCRange]];
            int lineIndex = 1;
            while ([linesInFile[index+lineIndex] isNotEqualTo:@""] && index+lineIndex < [linesInFile count]) {
                [newSubtitle.lines addObject:linesInFile[index+lineIndex]];
                lineIndex++;
            }
            if (lineIndex > 1) {
                [subtitleArray addObject:newSubtitle];
            }
            index += lineIndex;
            index++; // jump over blank line
        }
    }
    
    if ([subtitleArray count] > 0) {
        self.subtitles = [subtitleArray copy];
        
        return YES;
    }
    
    return NO;
}

- (id)init {
    if (self = [super init]) {
        _subtitles = nil;
    }
    return self;
}

@end
