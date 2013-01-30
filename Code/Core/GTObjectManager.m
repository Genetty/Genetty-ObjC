    //
//  GTObjectManager.m
//  LibraryExample
//
//  Created by Speechkey on 24.01.2013.
//  Copyright (c) 2013 Speechkey. All rights reserved.
//

#import "GTObjectManager.h"
#import "GTResource.h"
#import "ReplaceFromDictionary.h"

static GTObjectManager  *sharedManager = nil;

@implementation GTObjectManager

- (id)initManagerWithBaseURL:(NSURL *)serviceURL
{
    self = [super init];
    if (self) {
        if (nil == sharedManager) {
            self.restKitObjectManager = [RKObjectManager managerWithBaseURL:serviceURL];
            
            NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
            RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
            self.restKitObjectManager.managedObjectStore = managedObjectStore;

            [managedObjectStore createPersistentStoreCoordinator];
            NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"genetty.sqlite"];
            NSError *error;
            NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
            NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
            
            // Create the managed object contexts
            [managedObjectStore createManagedObjectContexts];
            
            // Configure a managed object cache to ensure we do not create duplicate objects
            managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];

            [GTObjectManager setSharedManager:self];
        }
    }
    
    return self;
}

+ (instancetype)sharedManager
{
    return sharedManager;
}

+ (instancetype)managerWithBaseURL:(NSURL *)serviceURL
{
    return [[self alloc] initManagerWithBaseURL:serviceURL];
}

+ (void)setSharedManager:(GTObjectManager *)manager
{
    sharedManager = manager;
}

- (void)entityForClass:(Class <GTResource>)entityClass
            andAbsoluteId:(NSDictionary *)absoluteId
                  success:(void (^)(id <GTResource>))success
                  failure:(void (^)(NSError *error))failure
{
    if(![self.managedEntitiesClassNames containsObject:NSStringFromClass(entityClass)])
    {
        [self.restKitObjectManager addResponseDescriptor:[[entityClass entityMapping] managedEntityResponseDescriptorWithManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]]];
        [self.managedEntitiesClassNames addObject:NSStringFromClass(entityClass)];
    }
    
    __block void (^s)(id <GTResource> entity) = success;
    __block void (^f)(NSError *error) = failure;
    
    //TODO: Check if a key in absoluteId is complete 

    [[RKObjectManager sharedManager] getObjectsAtPath:[[[entityClass entityMapping] path] stringByReplacingStringsFromDictionary:absoluteId]
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  s([mappingResult firstObject]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  f(error);
                                              }];
}

- (void)createEntity:(id <GTResource>)entity
             success:(void (^)(id <GTResource> entity))success
             failure:(void (^)(NSError *error))failure;
{
    Class entityClass = [entity class];

    if(![self.managedEntitiesClassNames containsObject:NSStringFromClass(entityClass)])
    {
        [self.restKitObjectManager addResponseDescriptor:[[[entity class] entityMapping] managedEntityResponseDescriptorWithManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]]];
        [self.restKitObjectManager addRequestDescriptor:[[[entity class] entityMapping] entityRequestDescriptor]];

        [self.managedEntitiesClassNames addObject:NSStringFromClass(entityClass)];
    }

    __block void (^s)(id <GTResource> entity) = success;
    __block void (^f)(NSError *error) = failure;

    RKObjectManager *RKManager = [RKObjectManager sharedManager];
    RKManager.requestSerializationMIMEType = RKMIMETypeJSON;

    [[RKObjectManager sharedManager] postObject:entity path:@"/org.library/library"
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            
                                            NSHTTPURLResponse *response = [[operation HTTPRequestOperation] response];
                                            if([[response allHeaderFields] objectForKey:@"Location"] != nil){
                                            }
                                            s([mappingResult firstObject]);
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            f(error);
                                        }];
}

- (void)deleteEntity:(id <GTResource>)entity
             success:(void (^)())success
             failure:(void (^)(NSError *error))failure
{
    Class entityClass = [entity class];
    
    if(![self.managedEntitiesClassNames containsObject:NSStringFromClass(entityClass)])
    {
        [self.restKitObjectManager addResponseDescriptor:[[[entity class] entityMapping] managedEntityResponseDescriptorWithManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]]];
        [self.restKitObjectManager addRequestDescriptor:[[[entity class] entityMapping] entityRequestDescriptor]];
        
        [self.managedEntitiesClassNames addObject:NSStringFromClass(entityClass)];
    }
    
    __block void (^s)(id <GTResource> entity) = success;
    __block void (^f)(NSError *error) = failure;
    RKObjectManager *RKManager = [RKObjectManager sharedManager];
    RKManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    NSString *path = [[[[entity class] entityMapping] path] stringByReplacingStringsFromDictionary:[entity entityKey]];
    [[RKObjectManager sharedManager] deleteObject:entity path:path
                                     parameters:nil
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            s([mappingResult firstObject]);
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            f(error);
                                        }];
}

- (void)updateEntity:(id <GTResource>)entity
             success:(void (^)())success
             failure:(void (^)(NSError *error))failure
{
    Class entityClass = [entity class];
    
    if(![self.managedEntitiesClassNames containsObject:NSStringFromClass(entityClass)])
    {
        [self.restKitObjectManager addResponseDescriptor:[[[entity class] entityMapping] managedEntityResponseDescriptorWithManagedObjectStore:[[RKObjectManager sharedManager] managedObjectStore]]];
        [self.restKitObjectManager addRequestDescriptor:[[[entity class] entityMapping] entityRequestDescriptor]];
        
        [self.managedEntitiesClassNames addObject:NSStringFromClass(entityClass)];
    }
    
    __block void (^s)(id <GTResource> entity) = success;
    __block void (^f)(NSError *error) = failure;

    RKObjectManager *RKManager = [RKObjectManager sharedManager];
    RKManager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    NSString *path = [[[[entity class] entityMapping] path] stringByReplacingStringsFromDictionary:[entity entityKey]];
    [[RKObjectManager sharedManager] putObject:entity path:path
                                       parameters:nil
                                          success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                              NSError *error;
//TODO: Save context only on quit?
                                              if(![[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] saveToPersistentStore:&error]){
                                                  NSLog(@"Whoops: %@", error);
                                              }

                                              s([mappingResult firstObject]);
                                          }
                                          failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                              f(error);
                                          }];    
}

@end
