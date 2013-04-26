//
//  ISAppDelegate.h
//  Isolate
//
//  Created by Filipe Ximenes on 4/24/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISIsolator.h"

@interface ISAppDelegate : NSObject <NSApplicationDelegate>

@property ISIsolator *isolator;

@property (assign) IBOutlet NSWindow *window;
@property NSEvent *monitor;

@property NSWindow* iswindow;

@end
