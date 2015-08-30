//
//  NSMutableString+NSMutableStringAdditions.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 30.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (NSMutableStringAdditions)

// returns number of replacements done
- (long)replaceString:(NSString*)lookup withString:(NSString*)replacement;

@end
