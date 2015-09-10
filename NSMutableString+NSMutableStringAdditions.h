//
//  NSMutableString+NSMutableStringAdditions.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 30.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (NSMutableStringAdditions)

// a bit simpler to use than default replaceOccurences...
- (long)replaceString:(NSString*)lookup withString:(NSString*)replacement;

@end
