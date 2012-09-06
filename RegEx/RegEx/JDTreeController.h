//
//  JDTreeController.h
//  Regex
//
//  Created by Joe Dakroub on 9/1/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JDTreeController : NSTreeController

@property (unsafe_unretained) NSUndoManager *undoManager;

@end
