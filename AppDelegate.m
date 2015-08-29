//
//  AppDelegate.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 27.8.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _subtitleData = nil;
    
    
    [_statusLabel setStringValue:@"File not loaded"];
    [_exportButton setEnabled:NO];


}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [_statusLabel setStringValue:@"Loading file"];
    [_exportButton setEnabled:NO];
    [_statusLabel setStringValue:@""];
    _subtitleData = nil;
}

- (void)clickedOpenButton:(id)sender {
    CavenaImporter *reader = [[CavenaImporter alloc] init];
    _subtitleData = nil;
    BOOL didLoad = [reader readFileWithPath:@"/Users/kati/Dropbox/Työ/tekstitys/test.890"];
    if (didLoad) {
        _subtitleData = [[SubtitleData alloc] init];
        _subtitleData.title = reader.title;
        _subtitleData.subtitles = reader.subtitles;
        _subtitleData.pathToSource = reader.path;
        _subtitleData.timecodeBase = @(25.0);
        NSString *statusStr = [NSString stringWithFormat:@"Loaded: %lu subtitles", (unsigned long)[_subtitleData.subtitles count]];
        [_statusLabel setStringValue:statusStr];
        [_exportButton setEnabled:YES];
    } else {
        _subtitleData = nil;
        [_statusLabel setStringValue:@"Could not open file"];
        [_exportButton setEnabled:NO];
    }
    reader = nil;
    
}

-(void)clickedExportButton:(id)sender {
    if (_subtitleData == nil) return;
    
    TTMLExporter *exporter = [[TTMLExporter alloc] init];
    [exporter export:_subtitleData toPath:@"/Users/kati/Dropbox/Työ/tekstitys/test.xml"];
    [_statusLabel setStringValue:@"Wrote file"];
}

@end
