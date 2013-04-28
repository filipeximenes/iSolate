//
//  ISIsolator.m
//  Isolate
//
//  Created by Filipe Ximenes on 4/26/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import "ISIsolator.h"
#import "ISAppListWindow.h"

@implementation ISIsolator

ISIsolator *isolator;

- (id)init
{
    self = [super init];
    if (self) {
        self.commandKeyUp = FALSE;
        self.tabKeyUp = FALSE;
        self.switchedApplication = FALSE;
        self.currentSelected = 0;        
        
        isolator = self;
        
        [self setupEventDrain];
    }
    
    return self;
}

- (void)setupEventDrain
{
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

- (NSRunningApplication*) selectedApplication
{
    if (self.spaceAppList.count){
        return [self.spaceAppList objectAtIndex:self.currentSelected];
    }else{
        return nil;
    }
}

- (void) switchApplication
{
    NSRunningApplication *app = [self selectedApplication];
    
    if (app != nil){
        [app activateWithOptions:(NSApplicationActivateIgnoringOtherApps|NSApplicationActivateAllWindows)];
//        NSLog(@"*%@", [app localizedName]);
    }
    
    [self.appWindow close];
    self.appWindow  = nil;
    
    self.switchedApplication = FALSE;
    self.currentSelected = 0;
    self.spaceAppList = nil;
}

- (void) setupApplicationEnvironment
{
    NSMutableArray *pids = [ISIsolator getPidsForApplicationsOnCurrentSpace];
    NSMutableDictionary *appDict = [ISIsolator getPidApplicationDictionary];
    
    self.spaceAppList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < pids.count; i++){
        NSRunningApplication *app = [appDict objectForKey:[pids objectAtIndex:i]];
        [self.spaceAppList addObject:app];
    }    
}

- (void) nextApplication
{    
    self.switchedApplication = TRUE;
    
    if (self.appWindow == nil){
        self.appWindow = [[ISAppListWindow alloc] initWithAppList:self.spaceAppList];
        [self.appWindow makeKeyAndOrderFront:self];
    }
    
    if (self.spaceAppList.count > 0){
        self.currentSelected = (self.currentSelected + 1) % self.spaceAppList.count;
        [self.appWindow hightlightItemOnPosition:self.currentSelected];
    }
    
//    NSRunningApplication *selectedApp = [self selectedApplication];
//    if (selectedApp){
//        NSLog(@"%@", [selectedApp localizedName]);
//    }
}

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
    if (CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode) == 0x37) {
        if (isolator.commandKeyUp && isolator.switchedApplication){
            [isolator switchApplication];
        }else{
            [isolator setupApplicationEnvironment];
        }
        
        isolator.commandKeyUp = !isolator.commandKeyUp;
    }
    
    if (CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode) == 0x30) {
        if (isolator.commandKeyUp && !isolator.tabKeyUp)
        {
            [isolator nextApplication];
            CGEventSetType(event, kCGEventNull);
        }
        
        isolator.tabKeyUp = !isolator.tabKeyUp;
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
