//
//  CavenaImporter.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 28.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "CavenaImporter.h"

@implementation CavenaImporter


-(NSString *)bytesToStringFromPosition:(long long)start length:(long)length {
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:128];
    
    if (start + length > _byteCount || _data == nil || _isLoaded == NO) return nil;
    
    const char * fileBytes = (const char *)[_data bytes];
    
    long long index = start;
    long counter = 0;
    BOOL dotsnext = NO;
    
    while (counter < length && index < _byteCount) {
        char aByte = fileBytes[index];
        unsigned char numByte = (unsigned char) aByte;
        
        if (numByte >= 32 && numByte < 127) {
            if (dotsnext) {
                if (aByte == 'a') [newString appendString:@"ä"];
                if (aByte == 'o') [newString appendString:@"ö"];
                if (aByte == 'A') [newString appendString:@"Ä"];
                if (aByte == 'O') [newString appendString:@"Ö"];
                if (aByte == 'u') [newString appendString:@"ü"];
                if (aByte == 'U') [newString appendString:@"Ü"];
                dotsnext = NO;
            } else {
                [newString appendFormat:@"%c", aByte];
            }
        
        } else {
            dotsnext = NO;
            switch (numByte) {
                case 190:
                     [newString appendString:@"-"];
                    break;
                case 134:
                    dotsnext = YES;
                    break;
                case 0:
                    break;
                case 127:
                    break;
                case 136:
                   // [newString appendString:@"<i>"];
                    break;
                case 152:
                   // [newString appendString:@"</i>"];
                    break;
                default:
                    [newString appendFormat:@"(%03d)", numByte];
                    break;
            }

        }
      
        counter++;
        index++;
    }
    return [NSString stringWithString:newString];
}

- (unsigned char)byteAtPosition:(long long)position {
    const char * fileBytes = (const char *)[_data bytes];
    unsigned char byteValue = (unsigned char) fileBytes[position];
    if (position < _byteCount) {
        return byteValue;
    }
    return 0;
    
}
-(Subtitle *)readFromPosition:(long long)start {
    Subtitle * newSub = [[Subtitle alloc] init];
    NSString *line1 = [self bytesToStringFromPosition:start+20 length:51];
    NSString *line2 = [self bytesToStringFromPosition:start+77 length:51];
    
//    frFrameIn = data(nPos + 6) * 256 * 256 + data(nPos + 7) * 256 + data(nPos + 8)
//    frFrameOut = data(nPos + 9) * 256 * 256 + data(nPos + 10) * 256 + data(nPos + 11)
    
    long inPoint = [self byteAtPosition:start + 6] * 256 * 256
                    + [self byteAtPosition:start + 7] * 256
                    + [self byteAtPosition:start + 8];
    long outPoint = [self byteAtPosition:start + 9] * 256 * 256
                    + [self byteAtPosition:start + 10] * 256
                    + [self byteAtPosition:start + 11];
    TimeCode * inTC = [TimeCode timeCodeWithFrames:inPoint timecodeBase:@(25.0)];
    TimeCode * outTC = [TimeCode timeCodeWithFrames:outPoint timecodeBase:@(25.0)];
    NSLog(@"%@ --> %@", [inTC getTimeCodeStringWithFrames], [outTC getTimeCodeStringWithFrames]);
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    if (line1 != nil && ![line1 isEqualTo:@""]) {
        NSLog(@"%@", line1);
        [lines addObject:line1];
    }
    if (line2 != nil && ![line2 isEqualTo:@""]) {
        NSLog(@"%@", line2);
        [lines addObject:line2];
    }
    newSub.lines = lines;
    newSub.timecodeIn = inTC;
    newSub.timecodeOut = outTC;
    newSub.text = @"<not implemented>";
    
    return newSub;
}

-(BOOL)readFileWithPath:(NSString *)path {
    NSData *loadedFile = [NSData dataWithContentsOfFile:path];
    NSMutableArray *newSubtitles = [[NSMutableArray alloc] initWithCapacity:3000];
    if (loadedFile != nil) {
        _path = path;
        _isLoaded = YES;
        _data = loadedFile;
        _byteCount = _data.length;

        _title = [self bytesToStringFromPosition:40 length:28];
        _sid = [self bytesToStringFromPosition:2 length:20];
        
        long long position = 384;
        long subCount = 0;
        
        while (_byteCount >= position + 127) {
            Subtitle *newSub = [self readFromPosition:position];
            
            if (newSub != nil) {
                [newSubtitles addObject:newSub];
                subCount++;
            }
            
            position += 128;
        }
        if (subCount>0) {
            _subtitles = [NSArray arrayWithArray:newSubtitles];
        }
        
        return YES;
    }
    return NO;
}

-(id) init {
    if (self = [super init]) {
        _path = nil;
        _isLoaded = NO;
        _byteCount = 0;
        _subtitleCount = 0;
        _subtitles = [[NSMutableArray alloc] initWithCapacity:3000];
        _firstTimecode = nil;
        _lastTimecode = nil;
        _data = nil;
        _title = nil;
        _sid = nil;
    }
    
    return self;
}

@end
