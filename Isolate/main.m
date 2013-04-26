//
//  main.m
//  Isolate
//
//  Created by Filipe Ximenes on 4/24/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ISAppDelegate.h"

int main(int argc, char *argv[])
{
//    return NSApplicationMain(argc, (const char **)argv);
    
    
    NSApplication * application = [NSApplication sharedApplication];
    
    ISAppDelegate * appDelegate = [[ISAppDelegate alloc] init];
    
    [application setDelegate:appDelegate];
    [application run];
    
    return EXIT_SUCCESS;
}
