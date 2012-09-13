//
//  JDOutlineDataCell.m
//  Regex
//
//  Created by Joe Dakroub on 8/31/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import "JDOutlineDataCell.h"

@implementation JDOutlineDataCell

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
    [self setWraps:NO];
    [self setIsFirstCellOfSection:NO];
    [self setIsLastCellOfSection:NO];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect frame = [controlView frame];
    
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    
    [ctx setShouldAntialias:NO];        
    
    // Draw background
    NSRect backgroundRect = NSMakeRect(5.0, cellFrame.origin.y + 6.0, frame.size.width - 10.0, cellFrame.size.height - 11.0);
    
    NSGradient *gradient = nil;
    
    if ([self isHighlighted])
    {
        if ([NSColor currentControlTint] == NSGraphiteControlTint)
        {
            gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.288 green:0.374 blue:0.463 alpha:1.000]
                                                     endingColor:[NSColor colorWithCalibratedRed:0.514 green:0.580 blue:0.651 alpha:1.000]];
        }
        else
        {
            gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.226 green:0.467 blue:0.773 alpha:1.000]
                                                     endingColor:[NSColor colorWithCalibratedRed:0.379 green:0.633 blue:0.863 alpha:1.000]];            
        }
    }
    else
    {
        gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.888 green:0.901 blue:0.931 alpha:1.000]
                                      endingColor:[NSColor colorWithCalibratedRed:0.946 green:0.950 blue:0.961 alpha:1.000]];
    }
    
    [gradient drawInRect:backgroundRect angle:270];

    // Draw top shadow if first cell
    if ([self isFirstCellOfSection])
    {
        NSColor *topShadowColor = [NSColor colorWithCalibratedRed:0.789 green:0.806 blue:0.835 alpha:1.000];
        [topShadowColor set];
        
        [NSBezierPath strokeLineFromPoint:NSMakePoint(0.0, cellFrame.origin.y + 1.0) toPoint:NSMakePoint(frame.size.width, cellFrame.origin.y + 1.0)];
    }

    // Draw bottom shadow if last cell
    if ([self isLastCellOfSection])
    {
        NSColor *bottomShadowColor = [NSColor colorWithCalibratedRed:0.626 green:0.675 blue:0.788 alpha:1.000];
        [bottomShadowColor set];
        
        [NSBezierPath strokeLineFromPoint:NSMakePoint(0.0, cellFrame.origin.y + cellFrame.size.height) toPoint:NSMakePoint(frame.size.width, cellFrame.origin.y + cellFrame.size.height)];
    }

    // Outer frame
    NSColor *tintedBorderColor = nil;
    NSColor *tintedInnerBorderColor = nil;
    
    tintedBorderColor = [NSColor currentControlTint] == NSGraphiteControlTint
        ? [NSColor colorWithCalibratedRed:0.259 green:0.343 blue:0.438 alpha:1.000]
        : [NSColor colorWithCalibratedRed:0.194 green:0.441 blue:0.773 alpha:1.000];

    tintedInnerBorderColor = [NSColor currentControlTint] == NSGraphiteControlTint
        ? [NSColor colorWithCalibratedRed:0.666 green:0.714 blue:0.760 alpha:1.000]
        : [NSColor colorWithCalibratedRed:0.569 green:0.753 blue:0.911 alpha:1.000];
    
    NSColor *borderColor = [self isHighlighted] ? tintedBorderColor : [NSColor colorWithCalibratedRed:0.626 green:0.675 blue:0.788 alpha:1.000];
    [borderColor set];
    
    // Top
    [NSBezierPath strokeLineFromPoint:NSMakePoint(7.0, cellFrame.origin.y + 5.0) toPoint:NSMakePoint(frame.size.width - 7.0, cellFrame.origin.y + 5.0)];
    
    // Left
    [NSBezierPath strokeLineFromPoint:NSMakePoint(6.0, cellFrame.origin.y + 6.0) toPoint:NSMakePoint(5.0, cellFrame.origin.y + cellFrame.size.height - 5.0)];
    
    // Right
    [NSBezierPath strokeLineFromPoint:NSMakePoint(frame.size.width - 6.0, cellFrame.origin.y + 6.0) toPoint:NSMakePoint(frame.size.width - 5.0, cellFrame.origin.y + cellFrame.size.height - 5.0)];
    
    CGFloat startX = 6.0;
    
    for (NSInteger i = 0; i < ((cellFrame.size.width - 16) / 4) + 10; i++)
    {
        [NSBezierPath strokeLineFromPoint:NSMakePoint(startX , cellFrame.origin.y + cellFrame.size.height - 4.0) toPoint:NSMakePoint(startX + 2.0, cellFrame.origin.y + cellFrame.size.height - 6.0)];

        [NSBezierPath strokeLineFromPoint:NSMakePoint(startX + 3.0, cellFrame.origin.y + cellFrame.size.height - 6.0) toPoint:NSMakePoint(startX + 5.0, cellFrame.origin.y + cellFrame.size.height - 4.0)];
        
        startX += 4;
    }

    // Inner frame
    NSColor *innerBorderColor = [self isHighlighted] ? tintedInnerBorderColor : [NSColor colorWithCalibratedRed:0.990 green:0.990 blue:0.995 alpha:1.000];
    [innerBorderColor set];
    
    // Top
    [NSBezierPath strokeLineFromPoint:NSMakePoint(7.0, cellFrame.origin.y + 6.0) toPoint:NSMakePoint(frame.size.width - 8.0, cellFrame.origin.y + 6.0)];

    tintedInnerBorderColor = [NSColor currentControlTint] == NSGraphiteControlTint
        ? [NSColor colorWithCalibratedRed:0.433 green:0.507 blue:0.585 alpha:1.000]
        : [NSColor colorWithCalibratedRed:0.364 green:0.620 blue:0.858 alpha:1.000];
    
    innerBorderColor = [self isHighlighted] ? tintedInnerBorderColor : innerBorderColor;
    [innerBorderColor set];
    
    // Left
    [NSBezierPath strokeLineFromPoint:NSMakePoint(6.0, cellFrame.origin.y + 6.0) toPoint:NSMakePoint(6.0, cellFrame.origin.y + cellFrame.size.height - 6.0)];
    
    // Right
    [NSBezierPath strokeLineFromPoint:NSMakePoint(frame.size.width - 7.0, cellFrame.origin.y + 6.0) toPoint:NSMakePoint(frame.size.width - 6.0, cellFrame.origin.y + cellFrame.size.height - 6.0)];


    // Shadow
    NSColor *shadowBorderColor = [NSColor colorWithCalibratedRed:0.742 green:0.763 blue:0.821 alpha:1.000];
    [shadowBorderColor set];
    
    startX = 6.0;
    
    for (NSInteger i = 0; i < ((cellFrame.size.width - 16) / 4) + 10; i++)
    {
        [NSBezierPath strokeLineFromPoint:NSMakePoint(startX , cellFrame.origin.y + cellFrame.size.height - 3.0) toPoint:NSMakePoint(startX + 2.0, cellFrame.origin.y + cellFrame.size.height - 5.0)];
        
        [NSBezierPath strokeLineFromPoint:NSMakePoint(startX + 3.0, cellFrame.origin.y + cellFrame.size.height - 5.0) toPoint:NSMakePoint(startX + 5.0, cellFrame.origin.y + cellFrame.size.height - 3.0)];
        
        startX += 4;
    }
    
    [ctx setShouldAntialias:YES];
    
    // Name
    NSRect textCellFrame = cellFrame;
    textCellFrame.origin.x = 7.0;
    textCellFrame.origin.y += 7.0;
    textCellFrame.size.width = frame.size.width - 15.0;
    
    NSTextFieldCell *nameCell = [[NSTextFieldCell alloc] initTextCell:[self title]];
    if ([self isHighlighted]) [nameCell setBackgroundStyle:NSBackgroundStyleLowered];
    [nameCell setFont:[NSFont boldSystemFontOfSize:11.0]];
    [nameCell setLineBreakMode:NSLineBreakByTruncatingTail];
    [nameCell setTextColor:[self isHighlighted] ? [NSColor whiteColor] : [NSColor blackColor]];
    [nameCell setTruncatesLastVisibleLine:YES];    
    [nameCell setWraps:NO];
    [nameCell drawWithFrame:textCellFrame inView:controlView];
    
    // Description
    NSRect descriptionCellFrame = cellFrame;
    descriptionCellFrame.origin.x = 7.0;
    descriptionCellFrame.origin.y += 25.0;
    descriptionCellFrame.size.height = 35.0;
    descriptionCellFrame.size.width = frame.size.width - 14.0;
    
    NSTextFieldCell *descriptionCell = [[NSTextFieldCell alloc] initTextCell:[self regexDescription]];
    if ([self isHighlighted]) [descriptionCell setBackgroundStyle:NSBackgroundStyleLowered];
    [descriptionCell setFont:[NSFont systemFontOfSize:11.0]];
    [descriptionCell setLineBreakMode:NSLineBreakByTruncatingTail];
    [descriptionCell setTextColor:[self isHighlighted] ? [NSColor whiteColor] : [NSColor blackColor]];
    [descriptionCell setTruncatesLastVisibleLine:YES];
    [descriptionCell setWraps:YES];
    [descriptionCell drawWithFrame:descriptionCellFrame inView:controlView];
}

@end
