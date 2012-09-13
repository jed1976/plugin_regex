//
//  JDOutlineDataCell.h
//  Regex
//
//  Created by Joe Dakroub on 8/31/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JDOutlineDataCell : NSTextFieldCell

@property (assign) BOOL isFirstCellOfSection;
@property (assign) BOOL isLastCellOfSection;
@property (assign) NSString *regexDescription;

@end
