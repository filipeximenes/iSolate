//
//  ISAppListView.h
//  Isolate
//
//  Created by Filipe Ximenes on 4/26/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ISAppListView : NSView

@property NSMutableArray *iconViews;

- (void) drawApplicationImages:(NSMutableArray*) appList;
- (void)hightlightItemOnPosition:(int) pos;

@end
