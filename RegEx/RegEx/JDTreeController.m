//
//  JDTreeController.m
//  Regex
//
//  Created by Joe Dakroub on 9/1/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import "JDTreeController.h"

@implementation JDTreeController

- (void)add:(id)sender
{
    NSMutableArray *child = [NSMutableArray array];
    NSMutableDictionary *group = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"Untitled Group", @"name",
                                  child, @"children",
                                  nil];
    [self insertObject:group atArrangedObjectIndexPath:[NSIndexPath indexPathWithIndex:0]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JDTreeControllerAddedGroup" object:group];
}

- (void)addChild:(id)sender
{
    if ([[[self selectedObjects] lastObject] valueForKey:@"children"] != nil)
    {
        [self insertObject:sender atArrangedObjectIndexPath:[[self selectionIndexPath] indexPathByAddingIndex:0]];
    }
    else
    {
        [self addObject:sender];
    }    
}

- (void)remove:(id)sender
{
    [[[self undoManager] prepareWithInvocationTarget:self] insertObject:[[self selectedObjects] lastObject]
                                              atArrangedObjectIndexPath:[self selectionIndexPath]];
    
    [super remove:sender];
}

@end
