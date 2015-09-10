//
//  Subtitle.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 28.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timecode.h"
#import "NSMutableString+NSMutableStringAdditions.h"

@interface Subtitle : NSObject

@property (nonatomic, copy) NSMutableArray *lines;
@property (nonatomic) Timecode *timecodeIn;
@property (nonatomic) Timecode *timecodeOut;
@property (readonly) NSString *timecodeInString;
@property (readonly) NSString *text; // computed property with joined lines, italics removed

@end

