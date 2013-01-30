//
//  GTEntityMapping.m
//  LibraryExample
//
//  Created by Speechkey on 25.01.2013.
//  Copyright (c) 2013 Speechkey. All rights reserved.
//

#import "GTEntityMapping.h"
#import "GTClass.h"

@implementation GTEntityMapping

@synthesize entityClass;
@synthesize identificationAttributes;
@synthesize attributeMappings;
//TODO: Override setter by relationships to check if withMapping dictionary value conforms GTEmbeddedEntity, see withMapping:[[(id <GTEmbeddedEntity>)[relationship valueF...
@synthesize relationships;
@synthesize connections;
@synthesize path;

- (RKEntityMapping *)managedEntityMappingWithManagedObjectStore:(RKManagedObjectStore *)managedObjectStore
{
    // NSParameterAssert([self.entityClass conformsToProtocol:@protocol(GTEmbeddedEntity) ]);
    RKEntityMapping *entityMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass(entityClass) inManagedObjectStore:managedObjectStore];
    
    entityMapping.identificationAttributes = identificationAttributes;
    [entityMapping addAttributeMappingsFromArray:attributeMappings];

    for(NSDictionary *relationship in relationships){
        [entityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[relationship valueForKey:@"fromKeyPath"]
                                                                                       toKeyPath:[relationship valueForKey:@"toKeyPath"]
                                                                                    withMapping:[[(id <GTClass>)[relationship valueForKey:@"withMapping"] entityMapping] managedEntityMappingWithManagedObjectStore:    managedObjectStore]]];
        
    }

    for(NSDictionary *connection in connections){
        [entityMapping addConnectionForRelationship:[connection valueForKey:@"forRelationship"] connectedBy:[connection valueForKey:@"connectedBy"]];
    }
    
    return entityMapping;
}

- (RKObjectMapping *)entityRequestMapping
{
    RKObjectMapping *entityMapping = [RKObjectMapping requestMapping];
    [entityMapping addAttributeMappingsFromArray:attributeMappings];
    
    for(NSDictionary *relationship in relationships){
        [entityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:[relationship valueForKey:@"fromKeyPath"] toKeyPath:[relationship valueForKey:@"toKeyPath"] withMapping:[[(id <GTClass>)[relationship valueForKey:@"withMapping" ] entityMapping] entityRequestMapping]]];
    }

    return entityMapping;
}

- (RKResponseDescriptor *)managedEntityResponseDescriptorWithManagedObjectStore:(RKManagedObjectStore *)managedObjectStore
{
    return [RKResponseDescriptor responseDescriptorWithMapping:[self managedEntityMappingWithManagedObjectStore:managedObjectStore ]
                                                   pathPattern:path
                                                       keyPath:nil
                                                   statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

- (RKRequestDescriptor *)entityRequestDescriptor
{
    return [RKRequestDescriptor requestDescriptorWithMapping:[self entityRequestMapping] objectClass:entityClass rootKeyPath:nil];
}
@end
