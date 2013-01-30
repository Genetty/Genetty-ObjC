//
//  GTObjectManager.h
//  LibraryExample
//
//  Created by Speechkey on 24.01.2013.
//  Copyright (c) 2013 Speechkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <GTResource.h>

@interface GTObjectManager : NSObject

@property (nonatomic, strong) NSMutableSet *managedEntitiesClassNames;
@property (nonatomic, strong) RKObjectManager *restKitObjectManager;

+ (instancetype)managerWithBaseURL:(NSURL *)serviceURL;

- (id)initManagerWithBaseURL:(NSURL *)serviceURL;

+ (instancetype)sharedManager;

+ (void)setSharedManager:(GTObjectManager *)manager;

- (void)entityForClass:(Class <GTResource>)entityClass
            andAbsoluteId:(NSDictionary *)absoluteId
                  success:(void (^)(id <GTResource> entity))success
                  failure:(void (^)(NSError *error))failure;

- (void)createEntity:(id <GTResource>)entity
             success:(void (^)(id <GTResource> entity))success
             failure:(void (^)(NSError *error))failure;

- (void)updateEntity:(id <GTResource>)entity
             success:(void (^)())success
             failure:(void (^)(NSError *error))failure;

- (void)deleteEntity:(id <GTResource>)entity
             success:(void (^)())success
             failure:(void (^)(NSError *error))failure;
@end
