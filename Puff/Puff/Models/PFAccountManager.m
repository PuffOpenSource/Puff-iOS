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
    NSManagedObjectContext *ctx = [_dbManager context];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityNamePFAccount inManagedObjectContext:ctx];
    [account managedObjectWithEntity:entity andContext:ctx];
    
    NSError *err;
    [[_dbManager context] save:&err];
    return err;
}

- (NSError*)saveAccountFromDict:(NSDictionary*)dict {
    return [self saveAccount:[[PFAccount alloc] initWithDict:dict]];
}

-(NSArray*)fetchAll {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:kEntityNamePFAccount];
    NSManagedObjectContext *ctx = [_dbManager context];
    NSError *err;
    NSAsynchronousFetchResult *result = [ctx executeRequest:req error:&err];
    if (err) {
        return nil;
    }
    NSArray *results = [result finalResult];
    NSMutableArray *ret = [@[] mutableCopy];
    for (_PFAccount *raw in results) {
        PFAccount *acct = [[PFAccount alloc] init];
        [acct copyFromCDRaw:raw];
        [ret addObject:acct];
    }
    return ret;
}



-(NSArray*)fetchAccountsByCategory:(int64_t)categoryId {
    return @[];
}
-(PFAccount*)fetchAccountById:(int64_t)acctId {
    return nil;
}
@end
