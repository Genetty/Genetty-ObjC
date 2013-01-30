//
//  GTEmbeddedEntity.h
//  LibraryExample
//
//  Created by Speechkey on 24.01.2013.
//  Copyright (c) 2013 Speechkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTEntityMapping.h"

@protocol GTClass <NSObject>

+ (GTEntityMapping *)entityMapping;

@end
