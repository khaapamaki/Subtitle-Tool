//
//  SubtitleData.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 29.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timecode.h"
#import "Subtitle.h"

@interface SubtitleData : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSArray * subtitles;
@property (readonly) Timecode * firstTimecode;
@property (readonly) Timecode * lastTimecode;
@property (nonatomic, copy) NSNumber * timecodeBase;
@property (nonatomic, copy) NSString * pathToSource;

@end
