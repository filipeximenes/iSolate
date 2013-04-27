//
//  ISAppListView.m
//  Isolate
//
//  Created by Filipe Ximenes on 4/26/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import "ISAppListView.h"
#import "ISIconView.h"

#define ICON_SIZE 140
#define MARGIN 25

@implementation ISAppListView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconViews = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)hightlightItemOnPosition:(int) pos
{
    for (ISIconView* icon in self.iconViews){
        icon.isHighlighted = FALSE;
    }
    
    ISIconView *icon = [self.iconViews objectAtIndex:pos];
    icon.isHighlighted = TRUE;
    
    [self setNeedsDisplay:TRUE];
    
    for (ISIconView* icon in self.iconViews){
        [icon setNeedsDisplay];
    }
}

- (void) drawApplicationImages:(NSMutableArray*) appList
{    
    int iconHeight = CGRectGetHeight(self.frame)/2 - ICON_SIZE/2;
    
    for (int i = 0; i < appList.count; i++){
        NSRunningApplication *app = [appList objectAtIndex:i];
        
        NSRect frame = NSMakeRect(MARGIN + i * ICON_SIZE, iconHeight, ICON_SIZE, ICON_SIZE);
        ISIconView *imageView = [[ISIconView alloc] initWithFrame:frame];
        NSImage *appImage = [app icon];
        [appImage setSize:NSMakeSize(ICON_SIZE, ICON_SIZE)];
        imageView.image = appImage;
        
        [self addSubview:imageView];
        [self.iconViews addObject:imageView];
    }
    
//    
}

- (void)drawRect:(NSRect)rect
{
    NSColor *bgColor = [NSColor colorWithCalibratedWhite:0.0 alpha:0.35];
    NSRect bgRect = rect;
    int minX = NSMinX(bgRect);
    int midX = NSMidX(bgRect);
    int maxX = NSMaxX(bgRect);
    int minY = NSMinY(bgRect);
    int midY = NSMidY(bgRect);
    int maxY = NSMaxY(bgRect);
    float radius = 25.0; // correct value to duplicate Panther's App Switcher
    NSBezierPath *bgPath = [NSBezierPath bezierPath];
    
    // Bottom edge and bottom-right curve
    [bgPath moveToPoint:NSMakePoint(midX, minY)];
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, minY)
                                     toPoint:NSMakePoint(maxX, midY)
                                      radius:radius];
    
    // Right edge and top-right curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, maxY)
                                     toPoint:NSMakePoint(midX, maxY)
                                      radius:radius];
    
    // Top edge and top-left curve
    [bgPath appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY)
                                     toPoint:NSMakePoint(minX, midY)
                                      radius:radius];
    
    // Left edge and bottom-left curve
    [bgPath appendBezierPathWithArcFromPoint:bgRect.origin
                                     toPoint:NSMakePoint(midX, minY)
                                      radius:radius];
    [bgPath closePath];
    
    [bgColor set];
    [bgPath fill];
}

@end
