//
//  PFDBManager.m
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFDBManager.h"

@interface PFDBManager();
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
        NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.sun.bob.leela"];
        containerURL = [containerURL URLByAppendingPathComponent:coreDataDBName];
        
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL: [[NSBundle bundleWithIdentifier:@"sun.bob.leela.PuffExtensionKit"] URLForResource:@"Puff" withExtension:@"momd"]];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:containerURL options:nil error:nil];
        
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = coordinator;
    }
    return self;
}

@end
