//
//  ReplaceFromDictionary.m
//  LibraryExample
//
//  Created by Speechkey on 25.01.2013.
//  Copyright (c) 2013 Speechkey. All rights reserved.
//

#import "ReplaceFromDictionary.h"

@implementation NSString (ReplaceFromDictionary)
- (NSString *)stringByReplacingStringsFromDictionary:(NSDictionary *)dict
{
    NSMutableString *string = [self mutableCopy];
    for (NSString *target in dict) {
        [string replaceOccurrencesOfString:[NSString stringWithFormat:@":%@", target] withString:[dict objectForKey:target]
                                   options:0 range:NSMakeRange(0, [string length])];
    }
    return string;
}
@end