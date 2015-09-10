//
//  TTMLExporter.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 29.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "TTMLExporter.h"

@implementation TTMLExporter

- (BOOL)export:(SubtitleData *)subtitleData toPath:(NSString *)path options:(NSNumber *)options {
    NSMutableString *newFile = [_headerTemplate mutableCopy];
    NSError *err = nil;
    self.errorMessage = nil;
    self.lastError = nil;
    
    const float originX = 15.0f;
    const float originY = 84.0f;
    const float originYDecrement = 5.0f;
    
    if (options != nil) {
        // add placeholder to the beginning of first hour
        if ([options integerValue] != 0) {
            int firstHour = subtitleData.firstTimecode.hours;
            Timecode *inTC = [Timecode timecodeWithHours:firstHour minutes:0 seconds:0 frames:0 timecodeBase:subtitleData.timecodeBase];
            Timecode *outTC = [inTC timecodeByAddingSeconds:@(1)];
            NSMutableString * subtitleString = [_subtitleTemplate mutableCopy];
            [subtitleString replaceString:@"#TCIN#"
                     withString:[inTC getTimecodeStringWithFrames]];
            [subtitleString replaceString:@"#TCOUT#"
                     withString:[outTC getTimecodeStringWithFrames]];
            [subtitleString replaceString:@"#LINE#"
                     withString:[NSString stringWithFormat:@"TC %@", [inTC getTimecodeStringWithFrames]]];
            [subtitleString replaceString:@"#ORIGIN-X#"
                     withString:[NSString stringWithFormat:@"%f%%", originX]];
            [subtitleString replaceString:@"#ORIGIN-Y#"
                     withString:[NSString stringWithFormat:@"%f%%", originY]];
            [newFile appendString:subtitleString];
        }
    }
    
    for (Subtitle * thisSub in subtitleData.subtitles) {
        int lineCount = (int) [thisSub.lines count] - 1; // going down to zero
        for (NSString *thisLine in thisSub.lines) {
            NSMutableString * subtitleString = [_subtitleTemplate mutableCopy];
            NSMutableString * fixedLine = [thisLine mutableCopy];
            [fixedLine replaceString:@"<i>" withString:@"_"];
            [fixedLine replaceString:@"</i>" withString:@"_"];
            [subtitleString replaceString:@"#TCIN#"
                     withString:[thisSub.timecodeIn getTimecodeStringWithFrames]];
            [subtitleString replaceString:@"#TCOUT#"
                     withString:[thisSub.timecodeOut getTimecodeStringWithFrames]];
            [subtitleString replaceString:@"#LINE#"
                     withString:fixedLine];
            [subtitleString replaceString:@"#ORIGIN-X#"
                     withString:[NSString stringWithFormat:@"%f%%", originX]];
            [subtitleString replaceString:@"#ORIGIN-Y#"
                     withString:[NSString stringWithFormat:@"%f%%", originY - originYDecrement * lineCount]];
            lineCount--;
            
            [newFile appendString:subtitleString];
        }
        
    }
    [newFile appendString:_footerTemplate];
    
    if (path != nil) {
        [newFile writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
        newFile = nil;
        if (err != nil) {
            self.lastError = err;
            self.errorMessage = [err localizedDescription];
            return NO;
        }
        
        return YES;
    }
    
    self.errorMessage = @"No path";
    return NO;
}

- (id)init {
    if (self = [super init]) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *headerTemplate = [mainBundle pathForResource: @"ttml_header" ofType: @"xml"];
        NSString *subtitleTemplate = [mainBundle pathForResource: @"ttml_subtitle" ofType: @"xml"];
        NSString *footerTemplate = [mainBundle pathForResource: @"ttml_footer" ofType: @"xml"];
        
        _headerTemplate = [[NSString alloc] initWithContentsOfFile:headerTemplate encoding:NSUTF8StringEncoding error:nil];
        _subtitleTemplate = [[NSString alloc] initWithContentsOfFile:subtitleTemplate encoding:NSUTF8StringEncoding error:nil];
        _footerTemplate = [[NSString alloc] initWithContentsOfFile:footerTemplate encoding:NSUTF8StringEncoding error:nil];
        _errorMessage = nil;
        _lastError = nil;
    }
    return self;
}

@end

