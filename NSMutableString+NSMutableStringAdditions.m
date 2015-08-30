//
//  NSMutableString+NSMutableStringAdditions.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 30.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "NSMutableString+NSMutableStringAdditions.h"

@implementation NSMutableString (NSMutableStringAdditions)


- (long)replaceString:(NSString *)lookup withString:(NSString *)replacement {
    long counter = 0;
    NSRange aRange = NSMakeRange(NSNotFound, 0);
    do {
        aRange = [self rangeOfString:lookup];
        if (aRange.location != NSNotFound) {
            [self replaceCharactersInRange:aRange withString:replacement];
            counter++;
        }
    } while (aRange.location != NSNotFound);
    return counter;
}

@end
