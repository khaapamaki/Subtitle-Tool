//
//  TTMLExporter.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 29.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "TTMLExporter.h"

@implementation TTMLExporter


- (BOOL)export:(SubtitleData *)subtitleData toPath:(NSString *)path {
    NSMutableString *newFile = [_headerTemplate mutableCopy];
    float originX = 15.0f;
    float originY = 79.0f;
    float originYIncrement = 5.0f;
    
    for (Subtitle * thisSub in subtitleData.subtitles) {
        int lineCount = 0;
        for (NSString *aLine in thisSub.lines) {
            NSMutableString * subtitleString = [_subtitleTemplate mutableCopy];
            [self replaceString:@"#TCIN#"
                     withString:[thisSub.timecodeIn getTimecodeStringWithFrames]
                             in:&subtitleString];
            [self replaceString:@"#TCOUT#"
                     withString:[thisSub.timecodeOut getTimecodeStringWithFrames]
                             in:&subtitleString];
            [self replaceString:@"#LINE#"
                     withString:aLine
                             in:&subtitleString];
            [self replaceString:@"#ORIGIN-X#"
                     withString:[NSString stringWithFormat:@"%f%%", originX]
                             in:&subtitleString];
            [self replaceString:@"#ORIGIN-Y#"
                     withString:[NSString stringWithFormat:@"%f%%", originY + originYIncrement * lineCount]
                             in:&subtitleString];
            lineCount++;
            
            [newFile appendString:subtitleString];
        }
        
    }
    [newFile appendString:_footerTemplate];
    
    if (path != nil) {
        [newFile writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    newFile = nil;
    
    return NO;
}

- (long)replaceString:(NSString*)lookup withString:(NSString*)replacement in:(NSMutableString**)aString {
    long counter = 0;
    NSRange aRange = NSMakeRange(NSNotFound, 0);
    do {
        aRange = [*aString rangeOfString:lookup];
        if (aRange.location != NSNotFound) {
            [*aString replaceCharactersInRange:aRange withString:replacement];
            counter++;
        }
    } while (aRange.location != NSNotFound);
    return counter;
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

        
    }
    return self;
}

@end

