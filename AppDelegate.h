//
//  AppDelegate.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 27.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SubtitleData.h"
#import "CavenaImporter.h"
#import "TTMLExporter.h"
#import "SubRipExporter.h"
#import "SubRipImporter.h"
#import "SubtitlePreviewControl.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic) SubtitleData * subtitleData;

@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSTextField *sequenceTitle;
@property (weak) IBOutlet NSButton *exportTTMLButton;
@property (weak) IBOutlet NSButton *exportSubRipButton;
@property (weak) IBOutlet NSButton *addPlaceholderOption;
@property (weak) IBOutlet NSMenuItem *exportTTMLMenuItem;
@property (weak) IBOutlet NSMenuItem *exportSubRipMenuItem;


- (IBAction)openFile:(id)sender;
- (IBAction)exportTTML:(id)sender;
- (IBAction)exportSubRip:(id)sender;

- (NSString *)selectFilePathForReading:(NSString*)initialPath;
- (NSString *)selectFilePathForWriting:(NSString*)initialPath fileName:(NSString*)fileName;
- (NSString *)getExportFileNameWithoutExtension;

@property (weak) IBOutlet SubtitlePreviewControl *tableViewController;

@end

