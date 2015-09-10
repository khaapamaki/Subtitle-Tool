//
//  SubtitlePreviewControl.m
//  SubtitleTool
//
//  Created by Kati Haapamäki on 2.9.2015.
//  Copyright (c) 2015 Kati Haapamäki. All rights reserved.
//

#import "SubtitlePreviewControl.h"

@implementation SubtitlePreviewControl

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (self.sData == nil) return 0;
    return [self.sData.subtitles count];
}

-(id)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

     NSTableCellView *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];

    if ([tableColumn.identifier isEqualToString:@"tcIn"]) {
        Subtitle *subtitle = [_sData.subtitles objectAtIndex:row];
        result.textField.stringValue = [[subtitle timecodeIn] getTimecodeStringWithFrames];
    }
    else if ([tableColumn.identifier isEqualToString:@"tcOut"]) {
        Subtitle *subtitle = [_sData.subtitles objectAtIndex:row];
        result.textField.stringValue = [[subtitle timecodeOut] getTimecodeStringWithFrames];
    } else if ([tableColumn.identifier isEqualToString:@"text"]) {
        Subtitle *subtitle = [_sData.subtitles objectAtIndex:row];
        result.textField.stringValue = [subtitle text];
    } else {
        result.textField.stringValue = @"";
    }

    return result;
}

-(void)redraw {
    [self.aTableView reloadData];
}

-(id)init {
    if (self = [super init]) {
        _sData = nil;
    }
    return self;
}


@end
