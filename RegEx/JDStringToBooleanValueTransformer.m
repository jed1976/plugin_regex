//
//  JDStringToBooleanValueTransformer.m
//  Regex
//
//  Created by Joe Dakroub on 9/6/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import "JDStringToBooleanValueTransformer.h"

@implementation JDStringToBooleanValueTransformer

+ (Class)transformedValueClass
{
    return [NSAttributedString class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    NSLog(@"%@", value);
    return value;
}

@end
