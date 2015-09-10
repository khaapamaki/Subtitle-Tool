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
    
    if (_data == nil) return nil;
    if (start + length > _data.length) return nil;
    
    const char * fileBytes = (const char *)[_data bytes];
    
    long long index = start;
    long counter = 0;
    BOOL specialCharMode = NO; // takes in two bytes
    unsigned char specialCode = 0;
    
    while (counter < length && index < _data.length) {
        char aByte = fileBytes[index];
        unsigned char numByte = (unsigned char) aByte;
        
        NSString * newChar = nil;
        if ((numByte >= 0x81 && numByte <= 0x87) || numByte == 0x89  || numByte == 0x8C) {
            specialCharMode = YES;
            specialCode = numByte;
        } else {
            if (numByte==190) newChar = @"-";
            else if (numByte == 0x1B) newChar = @"æ";
            else if (numByte == 0x1C) newChar = @"ø";
            else if (numByte == 0x1D) newChar = @"å";
            else if (numByte == 0x5B) newChar = @"Æ";
            else if (numByte == 0x5C) newChar = @"Ø";
            else if (numByte == 0x5D) newChar = @"Å";
            else if (numByte == 127 || numByte == 0) newChar = @"";
            else if (numByte == 0x88) newChar = @"<i>";
            else if (numByte == 0x98) newChar = @"</i>";
            else {
                if (specialCharMode) {
                    if (specialCode == 0x86) {
                        if (aByte == 'a') newChar = @"ä";
                        if (aByte == 'A') newChar = @"Ä";
                        if (aByte == 'e') newChar = @"ë";
                        if (aByte == 'E') newChar = @"Ë";
                        if (aByte == 'i') newChar = @"ï";
                        if (aByte == 'I') newChar = @"Ï";
                        if (aByte == 'o') newChar = @"ö";
                        if (aByte == 'O') newChar = @"Ö";
                        if (aByte == 'u') newChar = @"ü";
                        if (aByte == 'U') newChar = @"Ü";
                        if (aByte == 'y') newChar = @"ÿ";
                        if (aByte == 'Y') newChar = @"Ÿ";
                    }
                    if (specialCode == 0x8C) {
                        if (aByte == 'a') newChar = @"å";
                        if (aByte == 'A') newChar = @"Å";
                    }
                    if (specialCode == 0x81) {
                        if (aByte == 'a') newChar = @"à";
                        if (aByte == 'A') newChar = @"À";
                        if (aByte == 'e') newChar = @"è";
                        if (aByte == 'E') newChar = @"È";
                        if (aByte == 'i') newChar = @"ì";
                        if (aByte == 'I') newChar = @"Ì";
                        if (aByte == 'o') newChar = @"ò";
                        if (aByte == 'O') newChar = @"Ò";
                        if (aByte == 'u') newChar = @"ù";
                        if (aByte == 'U') newChar = @"Ù";
                    }
                    if (specialCode == 0x82) {
                        if (aByte == 'a') newChar = @"á";
                        if (aByte == 'A') newChar = @"Á";
                        if (aByte == 'e') newChar = @"é";
                        if (aByte == 'E') newChar = @"É";
                        if (aByte == 'i') newChar = @"í";
                        if (aByte == 'I') newChar = @"Í";
                        if (aByte == 'o') newChar = @"ó";
                        if (aByte == 'O') newChar = @"Í";
                        if (aByte == 'u') newChar = @"ú";
                        if (aByte == 'U') newChar = @"Ú";
                    }
                    if (specialCode == 0x83) {
                        if (aByte == 'a') newChar = @"â";
                        if (aByte == 'A') newChar = @"Â";
                        if (aByte == 'e') newChar = @"ê";
                        if (aByte == 'E') newChar = @"Ê";
                        if (aByte == 'i') newChar = @"î";
                        if (aByte == 'I') newChar = @"Î";
                        if (aByte == 'o') newChar = @"ô";
                        if (aByte == 'O') newChar = @"Ô";
                        if (aByte == 'u') newChar = @"û";
                        if (aByte == 'U') newChar = @"Û";
                    }
                    if (specialCode == 0x89) {
                        if (aByte == 'a') newChar = @"ă";
                        if (aByte == 'A') newChar = @"Ă";
                        if (aByte == 's') newChar = @"š";
                        if (aByte == 'S') newChar = @"Š";
                        if (aByte == 'z') newChar = @"ž";
                        if (aByte == 'Z') newChar = @"Ž";
                        if (aByte == 'k') newChar = @"ǩ";
                        if (aByte == 'K') newChar = @"Ǩ";
                        if (aByte == 'c') newChar = @"č";
                        if (aByte == 'C') newChar = @"Č";
                        if (aByte == 'g') newChar = @"ǧ";
                        if (aByte == 'G') newChar = @"ǧ";
                    }
                    if (specialCode == 0x87) {
                        if (aByte == 's') newChar = @"ş";
                        if (aByte == 'S') newChar = @"Ş";
                        if (aByte == 'c') newChar = @"ç";
                        if (aByte == 'C') newChar = @"Ç";
                        if (aByte == 't') newChar = @"ţ";
                        if (aByte == 'T') newChar = @"ţ";
                    }
                }
            }
            if (newChar == nil) {
                if (numByte >= 0x20 && numByte < 0x7F) {
                    newChar = [NSString stringWithFormat:@"%c", aByte];
                } else {
                    newChar = [NSString stringWithFormat:@"#%03d", numByte];
                }
            }
            [newString appendFormat:@"%@", newChar];
            specialCharMode = NO;
        }
        counter++;
        index++;
    }
    return [NSString stringWithString:newString];
}

- (unsigned char)byteAtPosition:(long long)position {
    const char * fileBytes = (const char *)[_data bytes];
    unsigned char byteValue = (unsigned char) fileBytes[position];
    if (position < _data.length) {
        return byteValue;
    }
    return 0;
    
}
-(Subtitle *)readFromPosition:(long long)start {
    Subtitle * newSub = [[Subtitle alloc] init];
    NSString *line1 = [self bytesToStringFromPosition:start+20 length:51];
    NSString *line2 = [self bytesToStringFromPosition:start+77 length:51];
    
    long inPoint = [self byteAtPosition:start + 6] * 256 * 256
    + [self byteAtPosition:start + 7] * 256
    + [self byteAtPosition:start + 8];
    long outPoint = [self byteAtPosition:start + 9] * 256 * 256
    + [self byteAtPosition:start + 10] * 256
    + [self byteAtPosition:start + 11];
    Timecode * inTC = [Timecode timecodeWithFrames:inPoint timecodeBase:@25.0];
    Timecode * outTC = [Timecode timecodeWithFrames:outPoint timecodeBase:@25.0];

    NSMutableArray *lines = [[NSMutableArray alloc] init];
    if (line1 != nil && ![line1 isEqualTo:@""]) {
        [lines addObject:line1];
    }
    if (line2 != nil && ![line2 isEqualTo:@""]) {
        [lines addObject:line2];
    }
    newSub.lines = lines;
    newSub.timecodeIn = inTC;
    newSub.timecodeOut = outTC;
    
    return newSub;
}

-(BOOL)readFileWithPath:(NSString *)path {
    NSError *err = nil;
    
    _data  = [NSData dataWithContentsOfFile:path options:0 error:&err];
    _lastError = err;
    _errorMessage = nil;
    
    if (err != nil) {
        _errorMessage = [err localizedDescription];
        return NO;
    }
    if (_data == nil) {
        _errorMessage = @"Empty file";
        return NO;
    }
    NSMutableArray *newSubtitles = [[NSMutableArray alloc] initWithCapacity:3000];
    
    _title = [self bytesToStringFromPosition:40 length:28];
    _sid = [self bytesToStringFromPosition:2 length:20];
    
    long long position = 384;
    long subCount = 0;
    
    while (_data.length >= position + 127) {
        Subtitle *newSub = [self readFromPosition:position];
        
        if (newSub != nil) {
            [newSubtitles addObject:newSub];
            subCount++;
        }
        
        position += 128;
    }
    if (subCount > 0) {
        _subtitles = [NSArray arrayWithArray:newSubtitles];
    }
    return YES;
    

}

-(id) init {
    if (self = [super init]) {
        _subtitles = nil;
        _data = nil;
        _title = nil;
        _sid = nil;
        _errorMessage = nil;
        _lastError = nil;
    }
    
    return self;
}

@end
