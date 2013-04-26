//
//  ISAppListView.m
//  Isolate
//
//  Created by Filipe Ximenes on 4/26/13.
//  Copyright (c) 2013 Filipe Ximenes. All rights reserved.
//

#import "ISAppListView.h"

@implementation ISAppListView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    frame = NSInsetRect(self.frame, 3.0, 3.0);
    
    [NSBezierPath setDefaultLineWidth:6.0];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frame
                                                         xRadius:6.0 yRadius:6.0];
    [[NSColor redColor] set];
    [path stroke];
}

@end
