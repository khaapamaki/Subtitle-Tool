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
    [_exportTTMLMenuItem setEnabled:NO];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [_statusLabel setStringValue:@"Quiting application..."];
    _subtitleData = nil;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}
    
#pragma mark - Open and Export Buttons

- (void)openFile:(id)sender {
    
    NSString *path = [self selectFilePathForReading:nil];
    if (path == nil) {
        return;
    }
    
    NSString *extension = [[path pathExtension] lowercaseString];
    BOOL didLoad = NO;
    NSString *errorMessage = nil;
    
    // Import Cavena
    if ([extension isEqualToString:@"890"]) {


        CavenaImporter *reader = [[CavenaImporter alloc] init];
        didLoad = [reader readFileWithPath:path];
        errorMessage = reader.errorMessage;
        _subtitleData = [[SubtitleData alloc] init];
        _subtitleData.title = reader.title;
        if (reader.sid != nil) {
            if ([reader.sid isNotEqualTo:@""]) {
                _subtitleData.title = [NSString stringWithFormat:@"%@ %@", reader.sid, reader.title];
            }
        }
        _subtitleData.subtitles = reader.subtitles;
        reader = nil;
    }

    // Import SubRip
    if ([extension isEqualToString:@"srt"]) {
        SubRipImporter *reader = [[SubRipImporter alloc] init];
        didLoad = [reader readFileWithPath:path];
        errorMessage = reader.errorMessage;
        _subtitleData = [[SubtitleData alloc] init];
        _subtitleData.subtitles = reader.subtitles;
        _subtitleData.title = [[path lastPathComponent] stringByDeletingPathExtension];
        
        reader = nil;
    }
    
    
    // Common for all formats
    if (didLoad) {
        _subtitleData.pathToSource = path;
        _subtitleData.timecodeBase = @25.0;
        NSString *statusStr = [NSString stringWithFormat:@"Read %lu subtitle%@",
                               (unsigned long) [_subtitleData.subtitles count],
                               [_subtitleData.subtitles count] == 1 ? @"" : @"s"];
        [_statusLabel setStringValue:statusStr];
        [_exportTTMLButton setEnabled:YES];
        [_exportSubRipButton setEnabled:YES];
        [_exportSubRipMenuItem setEnabled:YES];
        [_exportTTMLMenuItem setEnabled:YES];
        [_sequenceTitle setStringValue:_subtitleData.title];
        _tableViewController.sData = _subtitleData;

    } else {
        [_statusLabel setStringValue:@"Could not open file"];
        [_statusLabel setStringValue:errorMessage];
        _subtitleData = nil;
        [_exportTTMLButton setEnabled:NO];
        [_exportSubRipButton setEnabled:NO];
        [_sequenceTitle setStringValue:@""];
    }
    [_tableViewController reload];
}


-(void)exportTTML:(id)sender {
    if (_subtitleData == nil) return;

    NSString *initialPath = [_subtitleData.pathToSource stringByDeletingLastPathComponent];
    NSString *fileName = [NSString stringWithFormat:@"%@.xml", [self getExportFileNameWithoutExtension]];

    NSString *pathToWrite = [self selectFilePathForWriting:initialPath fileName:fileName];
    NSNumber *options = @0;
    if (self.addPlaceholderOption.state == YES) {
        options = @1;
    }
    if (pathToWrite != nil) {
        TTMLExporter *exporter = [[TTMLExporter alloc] init];
        if ([exporter export:_subtitleData toPath:pathToWrite options:options]) {
            [_statusLabel setStringValue:@"Wrote TTML file"];
        } else {
            [_statusLabel setStringValue:exporter.errorMessage];
        }

    } else {
        [_statusLabel setStringValue:@"Did not export"];
    }
}

-(void)exportSubRip:(id)sender {
    if (_subtitleData == nil) return;
    
    NSString *initialPath = [_subtitleData.pathToSource stringByDeletingLastPathComponent];
    NSString *fileName = [NSString stringWithFormat:@"%@.srt", [self getExportFileNameWithoutExtension]];
    
    NSString *pathToWrite = [self selectFilePathForWriting:initialPath fileName:fileName];
    NSNumber *options = @0;
    if (self.addPlaceholderOption.state == YES) {
        options = @1;
    }
    if (pathToWrite != nil) {
        SubRipExporter *exporter = [[SubRipExporter alloc] init];
        if ([exporter export:_subtitleData toPath:pathToWrite options:options]) {
            [_statusLabel setStringValue:@"Wrote SubRip file"];
        } else {
            [_statusLabel setStringValue:exporter.errorMessage];
        }
    } else {
        [_statusLabel setStringValue:@"Did not export"];
    }
}

- (NSString *)getExportFileNameWithoutExtension {
    if ([[self.sequenceTitle stringValue] isNotEqualTo:@""]) {
        return [self.sequenceTitle stringValue];
    }
    if ([self.subtitleData.title isNotEqualTo:@""]) {
        return self.subtitleData.title;
    }
    return @"untitled";
}

#pragma mark - File selection

-(NSString*)selectFilePathForReading:(NSString*)initialPath {
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    NSString *pathToOpen = nil;

    [openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"890", @"srt", nil]];
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
