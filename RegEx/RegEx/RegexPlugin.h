//
//  RegexPlugin.h
//  RegEx
//
//  Created by Joe Dakroub on 9/6/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CodaPlugInsController.h"
#import "JDOutlineDataCell.h"
#import "JDOutlineHeaderCell.h"
#import "NSColor-Additions.h"
#import "RegexKitLite.h"

@class CodaPlugInsController;

@interface RegexPlugin : NSObject <CodaPlugIn, NSTextFieldDelegate, NSTableViewDelegate>

@end
