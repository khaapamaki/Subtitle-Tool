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

@property (nonatomic) SubtitleData *sData;
@property (weak) IBOutlet NSTableView *aTableView;

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView; // NSTableViewDataSource
-(id)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row; // NSTableViewDelegate

-(void)reload;


@end
