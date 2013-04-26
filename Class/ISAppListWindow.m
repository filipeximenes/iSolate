//
//  ISAppListWindow.m
//  Isolate
//
//  Created by Filipe Ximenes on 4/26/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import "ISAppListWindow.h"

#define VIEW_HEIGHT 180
#define ICON_SIZE 140
#define MARGIN 25

@implementation ISAppListWindow

- (id)initWithAppList:(NSMutableArray*) appList
{    
    NSRect frame = [ISAppListWindow calculateWindowFrameFromAppList:appList];
    
    self = [super initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    
    if (self != nil) {
        [self setLevel: NSStatusWindowLevel];
        [self setBackgroundColor: [NSColor clearColor]];
        [self setAlphaValue:1.0];
        [self setOpaque:NO];
        [self setHasShadow:NO];
        
        self.appList = appList;
        
        NSRect viewFrame = NSMakeRect(0, 0, CGRectGetWidth(self.frame), VIEW_HEIGHT);
        self.appListView = [[ISAppListView alloc] initWithFrame: viewFrame];
        [self.appListView drawApplicationImages:appList];
        [[self contentView] addSubview:self.appListView];
    }
    
    return self;
}

+ (NSRect) calculateWindowFrameFromAppList:(NSMutableArray*) appList
{
    int x;
    int y;
    int w;
    int h;
    
    w = (appList.count * ICON_SIZE) + (MARGIN * 2);
    
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    
    x = CGRectGetWidth(screenFrame)/2 - w/2;
    
    long windowHeight = 200;
    
    y = CGRectGetHeight(screenFrame)/2 - windowHeight/2;
    
    h = VIEW_HEIGHT;
    
    return NSMakeRect(x, y, w, h);
}

- (BOOL) canBecomeKeyWindow
{
    return YES;
}

@end
