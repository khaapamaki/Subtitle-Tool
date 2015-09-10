//
//  TTMLExporter.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 29.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubtitleData.h"
#import "NSMutableString+NSMutableStringAdditions.h"

@interface TTMLExporter : NSObject {
    NSString *_headerTemplate;
    NSString *_subtitleTemplate;
    NSString *_footerTemplate;
}

@property NSError *lastError;
@property NSString *errorMessage;

- (BOOL)export:(SubtitleData *)subtitleData toPath:(NSString *)path options:(NSNumber *)options;

@end
