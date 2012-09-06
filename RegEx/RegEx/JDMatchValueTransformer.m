//
//  JDMatchValueTransformer.m
//  Regex
//
//  Created by Joe Dakroub on 9/6/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import "JDMatchValueTransformer.h"

@implementation JDMatchValueTransformer

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
    NSString *prefix = [NSString stringWithFormat:@"%@ ", [value isEqualTo:[NSNumber numberWithInt:0]] ? @"No" : value];
    NSString *suffix = [NSString stringWithFormat:@"character %@", [value isEqualTo:[NSNumber numberWithInt:1]] ? @"match" : @"matches"];
    
    return [NSString stringWithFormat:@"%@%@", prefix, suffix];
}

@end
