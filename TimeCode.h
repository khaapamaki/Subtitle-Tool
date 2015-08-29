//
//  TimeCode.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 27.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeCode : NSObject

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
@property (nonatomic) double timeValue;


#pragma mark - String Methods

- (NSString *)getTimeCodeStringWithFrames;
- (NSString *)getTimeCodeStringWithMilliseconds;
- (void)setTimeCodeByString:(NSString *)tcString;
+ (NSNumber *)parseTimeCodeString:(NSString *) tcString timecodeBase:(NSNumber *) tcBase;

#pragma mark - Calculus

/* IMPLEMENT
 
- (TimeCode *)timeCodeByAddingTimeCode:(TimeCode *)tc;
- (TimeCode *)timeCodeBySubtractingTimeCode:(TimeCode *)tc;
- (TimeCode *)timeCodeByAddingSeconds:(NSNumber *)timeValue;
- (TimeCode *)timeCodeBySubtractingSeconds:(NSNumber *)timeValue;
- (TimeCode *)timeCodeByAddingFrames:(NSNumber *)frames;
- (TimeCode *)timeCodeBySubtractingFrames:(NSNumber *)frames;
*/

#pragma mark - Class Makers

+ (TimeCode *)timeCodeWithFrames:(long)frames;
+ (TimeCode *)timeCodeWithFrames:(long)frames timecodeBase:(NSNumber *) tcBase;
+ (TimeCode *)timeCodeWithString:(NSString *)tcString;
+ (TimeCode *)timeCodeWithString:(NSString *)tcString timecodeBase:(NSNumber *) tcBase;
+ (TimeCode *)timeCodeWithHours:(int) h minutes:(int) m seconds:(int) s frames:(int) fr;
+ (TimeCode *)timeCodeWithHours:(int) h minutes:(int) m seconds:(int) s frames:(int) fr timecodeBase:(NSNumber *) tcBase;
+ (TimeCode *)timeCodeWithHours:(int) h minutes:(int) m seconds:(int) s milliseconds:(int) ms;
+ (TimeCode *)timeCodeWithHours:(int) h minutes:(int) m seconds:(int) s milliseconds:(int) ms timecodeBase:(NSNumber *) tcBase;

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
