//
//  PFDBManager.m
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFDBManager.h"

@interface PFDBManager()
@property (strong) NSPersistentContainer* persistentContainer;
@end

@implementation PFDBManager

+ (instancetype)sharedManager {
    static PFDBManager *instance = nil;
    dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[PFDBManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _persistentContainer = [[NSPersistentContainer alloc] initWithName:coreDataDBName];
        [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull desc, NSError * _Nullable err) {
            if (err) {
                
            }
        }];
    }
    return self;
}

- (NSManagedObjectContext*) context {
    return _persistentContainer.viewContext;
}

@end
