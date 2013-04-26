//
//  ISAppDelegate.m
//  Isolate
//
//  Created by Filipe Ximenes on 4/24/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import "ISAppDelegate.h"
#import "ISAppListWindow.h"

@implementation ISAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.window close];

    CFRunLoopSourceRef runLoopSource;
    
    CFMachPortRef eventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault, kCGEventMaskForAllEvents, myCGEventCallback, NULL);
    
    if (!eventTap) {
        NSLog(@"Couldn't create event tap!");
        exit(1);
    }
    
    runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    
    CGEventTapEnable(eventTap, true);
    
    CFRunLoopRun();
    
    CFRelease(eventTap);
    CFRelease(runLoopSource);
    
}

BOOL commandKeyUp = FALSE;
BOOL tabKeyUp = FALSE;
BOOL switchedApplication = FALSE;
int currentSelected = 0;

NSMutableArray *pids;
NSMutableDictionary *appDict;

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
    
    
    if (CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode) == 0x37) {
        if (commandKeyUp && switchedApplication){
            NSRunningApplication *app = [appDict objectForKey:[pids objectAtIndex:currentSelected]];
            
            if (app){
                [app activateWithOptions:NSApplicationActivateIgnoringOtherApps];
                NSLog(@"*%@", [app localizedName]);
            }
            
            switchedApplication = FALSE;
            currentSelected = 0;
        }else{
            //            NSLog(@"%@", pids);
            //            NSLog(@"%@", appDict);
            pids = [ISAppDelegate getPidsForApplicationsOnCurrentSpace];
            appDict = [ISAppDelegate getPidApplicationDictionary];
        }
        
        commandKeyUp = !commandKeyUp;
    }
    
    if (commandKeyUp && CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode) == 0x30) {
        if (!tabKeyUp)
        {
            switchedApplication = TRUE;
            currentSelected = (currentSelected + 1) % pids.count;
            
            NSRunningApplication *selectedApp = [appDict objectForKey:[pids objectAtIndex:currentSelected]];
            
            if (selectedApp){
                NSLog(@"%@", [selectedApp localizedName]);
            }
        }
        
        tabKeyUp = !tabKeyUp;
        //        CGEventSetIntegerValueField(event, kCGKeyboardEventKeycode, 0x3f);
        CGEventSetType(event, kCGEventNull);
    }
    
    return event;
}

+ (NSMutableDictionary*) getPidApplicationDictionary
{
    NSMutableDictionary *appDict = [[NSMutableDictionary alloc] init];
    NSArray *appNames = [[NSWorkspace sharedWorkspace] runningApplications];
    
    for (id currApp in appNames) {
        [appDict setObject:currApp forKey:[NSNumber numberWithInt:[currApp processIdentifier]]];
    }
    
    return appDict;
}

+ (NSMutableArray*) getPidsForApplicationsOnCurrentSpace
{
    NSMutableArray *applicationIds = [[NSMutableArray alloc] init];
    
    CFArrayRef windowsInSpace = CGWindowListCopyWindowInfo(kCGWindowListOptionAll | kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    
    for (NSMutableDictionary *thisWindow in (__bridge NSArray *)windowsInSpace)
    {
        if ([[thisWindow objectForKey:(id)kCGWindowLayer] intValue] == 0 )
        {
            NSString *pid = [thisWindow objectForKey:(id)kCGWindowOwnerPID];
            if (![applicationIds containsObject:pid])
            {
                [applicationIds addObject:pid];
            }
        }
    }
    
    return applicationIds;
}

@end
