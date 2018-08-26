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
    return  [self replaceOccurrencesOfString:lookup withString:replacement options:0 range:NSMakeRange(0, self.length)];
}

@end
