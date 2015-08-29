//
//  AppDelegate.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 27.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CavenaImporter.h"
#import "SubtitleData.h"
#import "TTMLExporter.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property SubtitleData * subtitleData;


@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSButton *exportButton;

- (IBAction)clickedOpenButton:(id)sender;
- (IBAction)clickedExportButton:(id)sender;


@end

