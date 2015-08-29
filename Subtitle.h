//
//  Subtitle.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 28.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeCode.h"

@interface Subtitle : NSObject

@property NSMutableArray *lines;
@property NSString *text;
@property BOOL italics;
@property TimeCode *timecodeIn;
@property TimeCode *timecodeOut;
@property long subtitleNumber;


@end
