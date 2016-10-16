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
    return [self _rawResultsToWrapped:[result finalResult]];
}


-(NSArray*)fetchAccountsByCategory:(int64_t)categoryId {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:kEntityNamePFAccount];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"category == %llu", categoryId];
    [req setPredicate: filter];
    NSManagedObjectContext *ctx = [_dbManager context];
    NSError *err;
    NSAsynchronousFetchResult *result = [ctx executeRequest:req error:&err];
    if (err) {
        return nil;
    }
    return [self _rawResultsToWrapped:[result finalResult]];
}

- (NSArray*)fetchAccountsByType:(int64_t)typeId {
    return @[];
}

- (NSArray*)_rawResultsToWrapped:(NSArray*)raws {
    NSMutableArray *ret = [@[] mutableCopy];
    for (_PFAccount *raw in raws) {
        PFAccount *acct = [[PFAccount alloc] init];
        [acct copyFromCDRaw:raw];
        [ret addObject:acct];
    }
    return ret;
}
@end
