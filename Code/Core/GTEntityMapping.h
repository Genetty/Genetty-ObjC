//
//  GTEntityMapping.h
//  LibraryExample
//
//  Created by Speechkey on 25.01.2013.
//  Copyright (c) 2013 Speechkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface GTEntityMapping : NSObject

@property (nonatomic, strong) Class entityClass;
@property (nonatomic, strong) NSArray *identificationAttributes;
@property (nonatomic, strong) NSArray *attributeMappings;
@property (nonatomic, strong) NSArray *relationships;
@property (nonatomic, strong) NSArray *connections;
@property (nonatomic, strong) NSString *path;

- (RKEntityMapping *)managedEntityMappingWithManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;
- (RKObjectMapping *)entityRequestMapping;
- (RKResponseDescriptor *)managedEntityResponseDescriptorWithManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;
- (RKRequestDescriptor *)entityRequestDescriptor;

@end
