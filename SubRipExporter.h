//
//  SubRipExporter.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 30.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubtitleData.h"
#import "NSMutableString+NSMutableStringAdditions.h"

@interface SubRipExporter : NSObject

- (BOOL)export:(SubtitleData *)subtitleData toPath:(NSString *)path options:(NSNumber *)options;

@end
