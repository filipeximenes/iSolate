//
//  ISIconView.m
//  Isolate
//
//  Created by Filipe Ximenes on 4/26/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import "ISIconView.h"

@implementation ISIconView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isHighlighted = FALSE;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(dirtyRect, 2, 2) xRadius:10 yRadius:10];
    
    [path setLineWidth:4.0];
    [path addClip];
    
    [super drawRect:dirtyRect];
    
    NSColor *strokeColor;
    if(self.self.isHighlighted){
        [[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.6] set];
        NSRectFill(dirtyRect);
        strokeColor = [NSColor whiteColor];
    }
    else{
        strokeColor = [NSColor clearColor];
    }
    
    [strokeColor set];
    [NSBezierPath setDefaultLineWidth:8.0];
    [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(dirtyRect, 2, 2) xRadius:10 yRadius:10] stroke];
    
//    [[NSColor blackColor]  setFill];
    
    [self.image drawAtPoint: NSZeroPoint
                   fromRect:dirtyRect
                  operation:NSCompositeSourceOver
                   fraction: 1.0];
}

@end
