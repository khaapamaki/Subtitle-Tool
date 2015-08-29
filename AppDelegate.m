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
    
  
    CavenaImporter *reader = [[CavenaImporter alloc] init];
    [reader readFileWithPath:@"/Users/kati/Dropbox/Työ/tekstitys/test.890"];
    
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
