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
        NSString *statusStr = [NSString stringWithFormat:@"%@ (%lu subtitles)", _subtitleData.title, (unsigned long)[_subtitleData.subtitles count]];
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

    NSString *initialPath = [_subtitleData.pathToSource stringByDeletingLastPathComponent];
    NSString *fileName = [NSString stringWithFormat:@"%@.xml", _subtitleData.title];

    NSString *pathToWrite = [self selectFilePathForWriting:initialPath fileName:fileName];
    if (pathToWrite != nil) {
        TTMLExporter *exporter = [[TTMLExporter alloc] init];
        [exporter export:_subtitleData toPath:pathToWrite];
        [_statusLabel setStringValue:@"Wrote file"];
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
    NSSavePanel *saveDlg = [NSSavePanel savePanel] ;
    NSString *path = nil;
    [saveDlg setCanCreateDirectories:YES];
    [saveDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"xml", nil]];
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
