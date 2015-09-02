//
//  SubtitlePreviewControl.h
//  SubtitleTool
//
//  Created by Kati Haapamäki on 2.9.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SubtitleData.h"

@interface SubtitlePreviewControl : NSObject <NSTableViewDataSource, NSTableViewDataSource> 

@property SubtitleData *sData;
@property (weak) IBOutlet NSTableView *aTableView;

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView; // NSTableViewDataSource
-(id)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row; // NSTableViewDataSource
@property (weak) IBOutlet NSTableCellView *testCellView;
@property (weak) IBOutlet NSTextField *textTextField;

-(void)redraw;


@end
