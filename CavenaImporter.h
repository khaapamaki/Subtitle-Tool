//
//  CavenaImporter.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 28.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timecode.h"
#import "Subtitle.h"

@interface CavenaImporter : NSObject {
    NSData *_data;
}

@property (nonatomic, copy) NSArray *subtitles;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sid;
@property (readonly) NSError *lastError;
@property (readonly) NSString *errorMessage;

- (BOOL)readFileWithPath:(NSString *)path;

- (NSString *)bytesToStringFromPosition:(long long)start length:(long)length;
- (unsigned char)byteAtPosition:(long long)position;


@end
 