//
//  JDOutlineHeaderCell.m
//  Regex
//
//  Created by Joe Dakroub on 8/29/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import "JDOutlineHeaderCell.h"

@implementation JDOutlineHeaderCell


- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self finalizeInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self)
    {
        [self finalizeInit];
    }

    return self;
}

- (id)initTextCell:(NSString *)aString
{
    self = [super initTextCell:aString];

    if (self)
    {
        [self finalizeInit];
    }

    return self;
}

- (void)finalizeInit
{
    [self setControlSize:NSSmallControlSize];
    [self setEditable:YES];
    [self setFont:[NSFont boldSystemFontOfSize:11.0]];
    [self setIsLastCellOfSection:NO];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    [ctx setShouldAntialias:NO];
        
    // Background
    NSRect backgroundRect = cellFrame;
    backgroundRect.origin.x = -1.0;
    backgroundRect.size.width += [controlView frame].size.width + 1.0;
        
    NSGradient *gradient = nil;
 
    if ([self isHighlighted])
    {
        if ([NSColor currentControlTint] == NSGraphiteControlTint)
        {
            gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.262 green:0.347 blue:0.438 alpha:1.000]
                                                     endingColor:[NSColor colorWithCalibratedRed:0.502 green:0.571 blue:0.642 alpha:1.000]];
        }
        else
        {
            gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.200 green:0.445 blue:0.778 alpha:1.000]
                                                     endingColor:[NSColor colorWithCalibratedRed:0.360 green:0.620 blue:0.858 alpha:1.000]];
        }
    }
    else
    {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.752 green:0.786 blue:0.863 alpha:1.000]
                                                 endingColor:[NSColor colorWithCalibratedRed:0.902 green:0.916 blue:0.941 alpha:1.000]];            
    }
        
    [gradient drawInRect:backgroundRect angle:270];
    
    if ( ! [self isHighlighted])
    {
        // Top
        [[NSColor colorWithCalibratedRed:0.902 green:0.916 blue:0.941 alpha:1.000] setFill];
        NSRect topBorderRect = cellFrame;
        topBorderRect.origin.x = -1.0;
        topBorderRect.origin.y += 0.0;
        topBorderRect.size.height = 1.0;
        topBorderRect.size.width = [controlView frame].size.width + 2.0;
        NSRectFill(topBorderRect);

        // Bottom
        [[NSColor colorWithCalibratedRed:0.535 green:0.591 blue:0.705 alpha:1.000] setFill];
        NSRect bottomBorderRect = cellFrame;
        bottomBorderRect.origin.x = -1.0;
        bottomBorderRect.origin.y += cellFrame.size.height - ([self isLastCellOfSection] ? 2.0 : 1.0);
        bottomBorderRect.size.height = 1.0;
        bottomBorderRect.size.width = [controlView frame].size.width + 2.0;
        NSRectFill(bottomBorderRect);
        
        if ([self isLastCellOfSection])
        {
            // Shadow
            [[NSColor colorWithCalibratedRed:0.784 green:0.797 blue:0.826 alpha:1.000] setFill];
            NSRect shadowBorderRect = cellFrame;
            shadowBorderRect.origin.x = -1.0;
            shadowBorderRect.origin.y += cellFrame.size.height - 1.0;
            shadowBorderRect.size.height = 1.0;
            shadowBorderRect.size.width = [controlView frame].size.width + 2.0;
            NSRectFill(shadowBorderRect);            
        }
    }

    [ctx setShouldAntialias:YES];
    
    [super drawWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect textCellFrame = [self titleRectForBounds:cellFrame];
    textCellFrame.origin.y += 3.0;

    [self setTextColor:[self isHighlighted] ? [NSColor whiteColor] : [NSColor colorWithDeviceRed:0.40f green:0.47f blue:0.58f alpha:1.00f]];
    [self setBackgroundStyle:[self isHighlighted] ? NSBackgroundStyleLowered : NSBackgroundStyleRaised];

    [super drawInteriorWithFrame:textCellFrame inView:controlView];
}

- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj
{
    textObj = [super setUpFieldEditorAttributes:textObj];
    
    [textObj setBackgroundColor:[NSColor whiteColor]];
    [textObj setDrawsBackground:YES];
    [textObj setFieldEditor:YES];
    
    return textObj;
}

- (NSRect)adjustEditorFrame:(NSRect)aRect
{
    aRect.origin.y += 4.0;
    aRect.size.height = 15.0;
 
    return aRect;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{    
    [super editWithFrame:[self adjustEditorFrame:aRect] inView:controlView editor:textObj delegate:anObject event:theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start: (NSInteger)selStart length:(NSInteger)selLength
{
    [super selectWithFrame:[self adjustEditorFrame:aRect] inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

@end

