//
//  JDTextView.m
//  Regex
//
//  Created by Joe Dakroub on 8/27/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import "JDTextView.h"

@implementation JDTextView

- (NSArray *)readablePasteboardTypes
{
    return [NSArray arrayWithObjects:NSPasteboardTypeString, nil];
}

@end
