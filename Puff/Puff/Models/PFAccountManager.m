//
//  PFAccountManager.m
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAccountManager.h"

#import "PFDBManager.h"

@interface PFAccountManager ()
@property (strong) PFDBManager *dbManager;
@end

@implementation PFAccountManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PFAccountManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[PFAccountManager alloc] init];
        instance.dbManager = [PFDBManager sharedManager];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSError*)saveAccount:(PFAccount *)account {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:[_dbManager context]];
    [account managedObjectWithEntity:entity andContext:[_dbManager context]];
    
    NSError *err;
    [[_dbManager context] save:&err];
    return err;
}

@end
