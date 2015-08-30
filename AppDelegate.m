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
    [_exportTTMLButton setEnabled:NO];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [_statusLabel setStringValue:@"Loading file"];
    [_exportTTMLButton setEnabled:NO];
    [_statusLabel setStringValue:@""];
    _subtitleData = nil;
}

- (void)clickedOpenButton:(id)sender {
    CavenaImporter *reader = [[CavenaImporter alloc] init];
    _subtitleData = nil;
    NSString *path = [self selectFilePathForReading:nil];
    if (path == nil) {
        return;
    }
    BOOL didLoad = [reader readFileWithPath:path];
    //BOOL didLoad = [reader readFileWithPath:@"/Users/kati/Dropbox/Työ/tekstitys/test.890"];
    if (didLoad) {
        _subtitleData = [[SubtitleData alloc] init];
        
        _subtitleData.title = reader.title;
        if (reader.sid != nil) {
            if ([reader.sid isNotEqualTo:@""]) {
                _subtitleData.title = [NSString stringWithFormat:@"%@ %@", reader.sid, reader.title];
            }
        }
        
        _subtitleData.subtitles = reader.subtitles;
        _subtitleData.pathToSource = reader.path;
        _subtitleData.timecodeBase = @(25.0);
        NSString *statusStr = [NSString stringWithFormat:@"Read %lu subtitles", (unsigned long)[_subtitleData.subtitles count]];
        [_statusLabel setStringValue:statusStr];
        [_exportTTMLButton setEnabled:YES];
        [_exportSRTButton setEnabled:YES];
        [_sequenceTitle setStringValue:_subtitleData.title];
    } else {
        _subtitleData = nil;
        [_statusLabel setStringValue:@"Could not open file"];
        [_exportTTMLButton setEnabled:NO];
        [_exportSRTButton setEnabled:NO];
        [_sequenceTitle setStringValue:@""];
        
    }
    reader = nil;
    
}

-(void)clickedExportTTMLButton:(id)sender {
    if (_subtitleData == nil) return;

    NSString *initialPath = [_subtitleData.pathToSource stringByDeletingLastPathComponent];
    NSString *fileName = [NSString stringWithFormat:@"%@.xml", _subtitleData.title];

    NSString *pathToWrite = [self selectFilePathForWriting:initialPath fileName:fileName];
    NSNumber *options = @(0);
    if (self.addPlaceholderOption.state == YES) {
        options = @(1);
    }
    if (pathToWrite != nil) {
        TTMLExporter *exporter = [[TTMLExporter alloc] init];
        [exporter export:_subtitleData toPath:pathToWrite options:options];
        [_statusLabel setStringValue:@"Wrote TTML file"];
    } else {
        [_statusLabel setStringValue:@"Did not export"];
    }
}

-(void)clickedExportSRTButton:(id)sender {
    if (_subtitleData == nil) return;
    
    NSString *initialPath = [_subtitleData.pathToSource stringByDeletingLastPathComponent];
    NSString *fileName = [NSString stringWithFormat:@"%@.srt", _subtitleData.title];
    
    NSString *pathToWrite = [self selectFilePathForWriting:initialPath fileName:fileName];
    NSNumber *options = @(0);
    if (self.addPlaceholderOption.state == YES) {
        options = @(1);
    }
    if (pathToWrite != nil) {
        SubRipExporter *exporter = [[SubRipExporter alloc] init];
        [exporter export:_subtitleData toPath:pathToWrite options:options];
        [_statusLabel setStringValue:@"Wrote SubRip file"];
    } else {
        [_statusLabel setStringValue:@"Did not export"];
    }
}

-(NSString*)selectFilePathForReading:(NSString*)initialPath {
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    NSString *pathToOpen = nil;
    [openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"890", nil]];
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setCanCreateDirectories:NO];
    [openDlg setDirectoryURL:[NSURL URLWithString:initialPath]];
    [openDlg setAnimationBehavior:NSWindowAnimationBehaviorNone];
    if ([openDlg runModal] == NSOKButton) {
        pathToOpen = [[openDlg URL] path];
    }
    return pathToOpen;
}

- (NSString*)selectFilePathForWriting:(NSString*)initialPath fileName:(NSString*)fileName {
    NSString *extension = [fileName pathExtension];
    
    NSSavePanel *saveDlg = [NSSavePanel savePanel] ;
    NSString *path = nil;
    [saveDlg setCanCreateDirectories:YES];
    [saveDlg setAllowedFileTypes:[NSArray arrayWithObjects:extension, nil]];
    [saveDlg setDirectoryURL:[NSURL URLWithString:initialPath]];
    [saveDlg setAllowsOtherFileTypes:YES];
    [saveDlg setNameFieldLabel:@"Export file name"];
    [saveDlg setNameFieldStringValue:fileName];
    [saveDlg setAnimationBehavior:NSWindowAnimationBehaviorNone];
    if ([saveDlg runModal] == NSOKButton) {
        path = [[saveDlg URL] path];
        
    }
    return path;
}

@end
