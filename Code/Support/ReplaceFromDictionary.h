//
//  ReplaceFromDictionary.h
//  LibraryExample
//
//  Created by Speechkey on 25.01.2013.
//  Copyright (c) 2013 Speechkey. All rights reserved.
//

#import <Foundation/Foundation.h>

//TODO: Rename categoryy to something more understandable, it replace string begins with colon
@interface NSString (ReplaceFromDictionary)

- (NSString *)stringByReplacingStringsFromDictionary:(NSDictionary *)dict;

@end

