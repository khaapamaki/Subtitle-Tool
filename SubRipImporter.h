//
//  SubRipImporter.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 30.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timecode.h"
#import "Subtitle.h"

@interface SubRipImporter : NSObject

@property (nonatomic, copy) NSArray *subtitles;
@property (readonly) NSError *lastError;
@property (readonly) NSString *errorMessage;

- (BOOL)readFileWithPath:(NSString *)path;

@end
