//
//  CavenaImporter.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 28.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeCode.h"
#import "Subtitle.h"

@interface CavenaImporter : NSObject

@property NSData * data;
@property BOOL isLoaded;
@property NSString * sequenceName;
@property NSArray * subtitles;
@property TimeCode * firstTimecode;
@property TimeCode * lastTimecode;
@property NSString * path;
@property long long byteCount;
@property long subtitleCount;
@property NSString *title;
@property NSString *sid;

-(NSString *)bytesToStringFromPosition:(long long)start length:(long)length;
- (unsigned char)byteAtPosition:(long long)position;
-(BOOL)readFileWithPath:(NSString *)path;


@end
