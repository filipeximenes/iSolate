//
//  ISAppDelegate.m
//  Isolate
//
//  Created by Filipe Ximenes on 4/24/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import "ISAppDelegate.h"

@implementation ISAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.isolator = [[ISIsolator alloc] init];
}

@end
