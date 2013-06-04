//
//  ISIsolator.h
//  Isolate
//
//  Created by Filipe Ximenes on 4/26/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISAppListWindow.h"

@interface ISIsolator : NSObject

@property BOOL commandKeyDown;
@property BOOL switchedApplication;
@property int currentSelected;

@property NSMutableArray *spaceAppList;

//@property NSMutableArray *pids;
//@property NSMutableDictionary *appDict;

@property ISAppListWindow *appWindow;

- (NSRunningApplication*) selectedApplication;
- (void) switchApplication;
- (void) setupApplicationEnvironment;

@end
