//
//  Timecode.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 27.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timecode : NSObject

// stored values
@property (nonatomic) NSNumber * _timeInSeconds;
@property (nonatomic) NSNumber * _timecodeBase;
@property (nonatomic) NSNumber * _defaultTimecodeBase;

// computed properties
@property (nonatomic) int hours;
@property (nonatomic) int minutes;
@property (nonatomic) int seconds;
@property (nonatomic) int frames;
@property (nonatomic) int milliseconds;
@property (nonatomic) double timeValue; // time in seconds


#pragma mark - String Methods

- (NSString *)getTimecodeStringWithFrames;
- (NSString *)getTimecodeStringWithMilliseconds;
- (void)setTimecodeByString:(NSString *)tcString;
+ (NSNumber *)parseTimecodeString:(NSString *) tcString timecodeBase:(NSNumber *) tcBase;

#pragma mark - Calculus

/* IMPLEMENT
 */
- (Timecode *)timecodeByAddingTimecode:(Timecode *)tc;
- (Timecode *)timecodeBySubtractingTimecode:(Timecode *)tc;
- (Timecode *)timecodeByAddingSeconds:(NSNumber *)timeValue;
- (Timecode *)timecodeBySubtractingSeconds:(NSNumber *)timeValue;
- (Timecode *)timecodeByAddingFrames:(NSInteger)frames;
- (Timecode *)timecodeBySubtractingFrames:(NSInteger)frames;


#pragma mark - Class Makers

+ (Timecode *)timecodeWithValue:(NSNumber *)timeValue;
+ (Timecode *)timecodeWithValue:(NSNumber *)timeValue timecodeBase:(NSNumber *) tcBase;
+ (Timecode *)timecodeWithFrames:(long)frames;
+ (Timecode *)timecodeWithFrames:(long)frames timecodeBase:(NSNumber *) tcBase;
+ (Timecode *)timecodeWithString:(NSString *)tcString;
+ (Timecode *)timecodeWithString:(NSString *)tcString timecodeBase:(NSNumber *) tcBase;
+ (Timecode *)timecodeWithHours:(int) h minutes:(int) m seconds:(int) s frames:(int) fr;
+ (Timecode *)timecodeWithHours:(int) h minutes:(int) m seconds:(int) s frames:(int) fr timecodeBase:(NSNumber *) tcBase;
+ (Timecode *)timecodeWithHours:(int) h minutes:(int) m seconds:(int) s milliseconds:(int) ms;
+ (Timecode *)timecodeWithHours:(int) h minutes:(int) m seconds:(int) s milliseconds:(int) ms timecodeBase:(NSNumber *) tcBase;

#pragma mark - Initializers

- (id)initWithFrames:(long)frames;
- (id)initWithFrames:(long)frames timecodeBase:(NSNumber *) tcBase;
- (id)initWithValue:(NSNumber *)timeValue;
- (id)initWithValue:(NSNumber *)timeValue timecodeBase:(NSNumber *) tcBase;
- (id)initWithTimecodeString:(NSString *)tcString;
- (id)initWithTimecodeString:(NSString *)tcString timecodeBase:(NSNumber *) tcBase;
- (id)initWithHours:(int) h minutes:(int) m seconds:(int) s frames:(int) fr;
- (id)initWithHours:(int) h minutes:(int) m seconds:(int) s frames:(int) fr timecodeBase:(NSNumber *) tcBase;
- (id)initWithHours:(int) h minutes:(int) m seconds:(int) s milliseconds:(int) ms;
- (id)initWithHours:(int) h minutes:(int) m seconds:(int) s milliseconds:(int) ms timecodeBase:(NSNumber *) tcBase;


@end
