//
//  TimeCode.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 27.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "TimeCode.h"

@implementation TimeCode


#pragma mark - Setters and getters

-(double)timeValue {
    return __timeInSeconds.doubleValue;
}

-(void)setTimeValue:(double) aValue {
    __timeInSeconds = [NSNumber numberWithDouble:aValue];
}

-(int)hours {
    return (int) floor(self.timeValue / 3600.0);
}

-(void)setHours:(int)hours {
    __timeInSeconds = [NSNumber numberWithDouble:
                        (hours * 3600.0 + self.minutes * 60.0 + self.seconds + self.milliseconds / 1000.0)];
}

-(int)minutes {
    return (int) floor((self.timeValue - self.hours * 3600.0) / 60.0);
}

-(void)setMinutes:(int)minutes {
    __timeInSeconds = [NSNumber numberWithDouble:
                          (self.hours * 3600.0 + minutes * 60.0 + self.seconds + self.milliseconds / 1000.0)];
}

-(int)seconds {
    return (int) floor(self.timeValue - self.hours * 3600.0 - self.minutes * 60.0);
}

-(void)setSeconds:(int)seconds {
    __timeInSeconds = [NSNumber numberWithDouble:
                          (self.hours * 3600.0 + self.minutes * 60.0 + seconds + self.milliseconds / 1000.0)];
}

-(int)frames {
    return (int) floor((self.timeValue - floor(self.timeValue) + 0.0005) * __timecodeBase.doubleValue);
}

-(void)setFrames:(int)frames {
    __timeInSeconds = [NSNumber numberWithDouble:
                          (self.hours * 3600.0 + self.minutes * 60.0 + self.seconds + frames / __timecodeBase.doubleValue)];
}

-(int)milliseconds {
    return (int) floor((self.timeValue - floor(self.timeValue)) * 1000.0 + 0.5);
}

-(void)setMilliseconds:(int)milliseconds {
    __timeInSeconds = [NSNumber numberWithDouble:
                          (self.hours * 3600.0 + self.minutes * 60.0 + self.seconds + milliseconds / 1000.0)];
}

#pragma mark - String methods

- (NSString *)getTimeCodeStringWithFrames {
    NSString *tcString = [NSString stringWithFormat:@"%02d:%02d:%02d:%02d",
                          self.hours, self.minutes, self.seconds, self.frames];
    return tcString;
}

- (NSString *)getTimeCodeStringWithMilliseconds {
    NSString *tcString = [NSString stringWithFormat:@"%02d:%02d:%02d,%03d",
                          self.hours, self.minutes, self.seconds, self.milliseconds];
    return tcString;
}

- (void)setTimeCodeByString:(NSString *)tcString {
    NSNumber *time = [[self class] parseTimeCodeString:tcString timecodeBase:__timecodeBase];
    if (time != nil) {
        __timeInSeconds = time;
    }
}

+ (NSNumber *)parseTimeCodeString:(NSString *)tcString {
    return [self parseTimeCodeString:tcString timecodeBase:@25.0];
}

+ (NSNumber *)parseTimeCodeString:(NSString *)tcString timecodeBase:(NSNumber *)tcBase {

    NSString *regexPattern = @"^([0-9]{2}):([0-9]{2}):([0-9]{2})([:|;|.|,])([0-9]{2,3})$";
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regexPattern options:regexOptions error:nil];
    NSTextCheckingResult *match = nil;
    match = [regex firstMatchInString:tcString options:0 range:NSMakeRange(0, [tcString length])];
    
    if (!match) {
        return nil;
    } else {
        // NSRange matchRange = [match range];
        NSRange hourRange = [match rangeAtIndex:1];
        NSRange minRange = [match rangeAtIndex:2];
        NSRange secRange = [match rangeAtIndex:3];
        // NSRange dotRange = [match rangeAtIndex:4];
        NSRange fractRange = [match rangeAtIndex:5];
        
        if (hourRange.location != NSNotFound) {
            int hours = [[tcString substringWithRange:hourRange] intValue];
            int mins = [[tcString substringWithRange:minRange] intValue];
            int secs = [[tcString substringWithRange:secRange] intValue];
            int fracts = [[tcString substringWithRange:fractRange] intValue];
            if (fractRange.length > 2) {
                return @(hours * 3600.0 + mins * 60.0 + secs + fracts / 1000.0); // millis
            } else {
                return @(hours * 3600.0 + mins * 60.0 + secs + fracts / tcBase.doubleValue);  // frames
            }
        }
    }
    return nil;
}

#pragma mark - Class Makers

+ (TimeCode *)timeCodeValue:(NSNumber *)timeValue  {
    return [[TimeCode alloc] initWithValue:timeValue];
}
+ (TimeCode *)timeCodetWithValue:(NSNumber *)timeValue timecodeBase:(NSNumber *) tcBase {
    return [[TimeCode alloc] initWithValue:timeValue timecodeBase:tcBase];
}
+ (TimeCode *)timeCodeWithFrames:(long)frames {
    return [[TimeCode alloc] initWithFrames:frames];
}
+ (TimeCode *)timeCodeWithFrames:(long)frames timecodeBase:(NSNumber *) tcBase {
    return [[TimeCode alloc] initWithFrames:frames timecodeBase:tcBase];
}
+ (TimeCode *)timeCodeWithString:(NSString *)tcString {
    return [[TimeCode alloc] initWithTimecodeString:tcString];
}
+ (TimeCode *)timeCodeWithString:(NSString *)tcString timecodeBase:(NSNumber *) tcBase {
    return [[TimeCode alloc] initWithTimecodeString:tcString timecodeBase:tcBase];
}
+ (TimeCode *)timeCodeWithHours:(int) h minutes:(int) m seconds:(int) s frames:(int) fr {
    return [[TimeCode alloc] initWithHours:h minutes:m seconds:s frames:fr];
}
+ (TimeCode *)timeCodeWithHours:(int) h minutes:(int) m seconds:(int) s frames:(int) fr timecodeBase:(NSNumber *) tcBase {
    return [[TimeCode alloc] initWithHours:h minutes:m seconds:s frames:fr timecodeBase:tcBase];
}
+ (TimeCode *)timeCodeWithHours:(int) h minutes:(int) m seconds:(int) s milliseconds:(int) ms {
    return [[TimeCode alloc] initWithHours:h minutes:m seconds:s milliseconds:ms];
}
+ (TimeCode *)timeCodeWithHours:(int) h minutes:(int) m seconds:(int) s milliseconds:(int) ms timecodeBase:(NSNumber *) tcBase {
    return [[TimeCode alloc] initWithHours:h minutes:ms seconds:s milliseconds:ms timecodeBase:tcBase];
}


#pragma mark - Initializers

- (id)initWithValue:(NSNumber *)timeValue {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = [__defaultTimecodeBase copy];
        __timeInSeconds = [NSNumber numberWithDouble:[timeValue doubleValue]];
    }
    return self;
}

- (id)initWithValue:(NSNumber *)timeValue timecodeBase:(NSNumber *) tcBase {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = tcBase;
        __timeInSeconds = [NSNumber numberWithDouble:[timeValue doubleValue]];
    }
    return self;
}

- (id)initWithFrames:(long)frames {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = [__defaultTimecodeBase copy];
        __timeInSeconds = [NSNumber numberWithDouble:((double)frames / [__timecodeBase doubleValue])];
    }
    return self;
}

- (id)initWithFrames:(long)frames timecodeBase:(NSNumber *) tcBase {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = tcBase;
        __timeInSeconds = [NSNumber numberWithDouble:((double)frames / [__timecodeBase doubleValue])];
    }
    return self;
}

- (id)initWithTimecodeString:(NSString *)tcString {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = [__defaultTimecodeBase copy];
        NSNumber *time = [[self class] parseTimeCodeString:tcString timecodeBase:__timecodeBase];
        __timeInSeconds = time != nil ? time : @0.0;
    }
    
    return self;
}

- (id)initWithTimecodeString:(NSString *)tcString timecodeBase:(NSNumber *) tcBase {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = tcBase;
        NSNumber *time = [[self class] parseTimeCodeString:tcString timecodeBase:__timecodeBase];
        __timeInSeconds = time != nil ? time : @0.0;
    }
    
    return self;
}

- (id)initWithHours:(int) h minutes:(int) m seconds:(int) s frames:(int) fr {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = [__defaultTimecodeBase copy];
        __timeInSeconds = [NSNumber numberWithDouble: h * 3600.0 + m * 60.0 + s + fr / __timecodeBase.doubleValue];
    }
    return self;
}

- (id)initWithHours:(int) h minutes:(int) m seconds:(int) s frames:(int) fr timecodeBase:(NSNumber *) tcBase {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = tcBase;
        __timeInSeconds = [NSNumber numberWithDouble: h * 3600.0 + m * 60.0 + s + fr / __timecodeBase.doubleValue];
    }
    return self;
}

- (id)initWithHours:(int) h minutes:(int) m seconds:(int) s milliseconds:(int) ms {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = [__defaultTimecodeBase copy];
        __timeInSeconds = [NSNumber numberWithDouble: h * 3600.0 + m * 60.0 + s + ms / 1000.0];
    }
    return self;
}

- (id)initWithHours:(int) h minutes:(int) m seconds:(int) s milliseconds:(int) ms timecodeBase:(NSNumber *) tcBase {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = tcBase;
        __timeInSeconds = [NSNumber numberWithDouble: h * 3600.0 + m * 60.0 + s + ms /1000.0];
    }
    return self;
}

- (id) init {
    if (self = [super init]) {
        __defaultTimecodeBase = @25.0;
        __timecodeBase = [__defaultTimecodeBase copy];
        __timeInSeconds = @0.0;
    }
    
    return self;
}

@end
