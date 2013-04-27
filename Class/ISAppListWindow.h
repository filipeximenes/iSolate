//
//  ISAppListWindow.h
//  Isolate
//
//  Created by Filipe Ximenes on 4/26/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISAppListView.h"

@interface ISAppListWindow : NSWindow

@property ISAppListView *appListView;

@property NSArray *appList;

- (id)initWithAppList:(NSArray*) appList;
- (void)hightlightItemOnPosition:(int) pos;

@end
