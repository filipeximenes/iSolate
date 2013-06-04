//
//  ISAppDelegate.m
//  Isolate
//
//  Created by Filipe Ximenes on 4/24/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import "ISAppDelegate.h"

@implementation ISAppDelegate

NSStatusItem *statusItem;
NSMenu *theMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{        
    [self performSelectorInBackground:@selector(runner) withObject:nil];
    [self setupMenuItem];
}

- (void) setupMenuItem
{
    NSMenuItem *tItem = nil;
    
    theMenu = [[NSMenu alloc] initWithTitle:@""];
    [theMenu setAutoenablesItems:NO];
    
    [theMenu addItemWithTitle:@"About Isolate" action:@selector(showAboutPane) keyEquivalent:@""];
    [theMenu addItem:[NSMenuItem separatorItem]];    
    tItem = [theMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    [statusItem setImage:[NSImage imageNamed:@"bar_icon.png"]];
    [statusItem setHighlightMode:YES];
    [statusItem setMenu:theMenu];
}

- (void) runner
{
    self.isolator = [[ISIsolator alloc] init];
}

- (void) showAboutPane
{
    NSApplication *app = [NSApplication sharedApplication];
    [app orderFrontStandardAboutPanel:self];
    [app activateIgnoringOtherApps:YES];
}

@end
