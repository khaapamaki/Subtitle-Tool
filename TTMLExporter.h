//
//  TTMLExporter.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 29.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubtitleData.h"

@interface TTMLExporter : NSObject

@property NSString * headerTemplate;
@property NSString * subtitleTemplate;
@property NSString * footerTemplate;

- (BOOL)export:(SubtitleData *)subtitleData toPath:(NSString *)path;
- (long)replaceString:(NSString*)lookup withString:(NSString*)replacement in:(NSMutableString**)aString;

@end
