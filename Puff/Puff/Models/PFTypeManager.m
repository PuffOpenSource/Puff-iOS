//
//  PFTypeManager.m
//  Puff
//
//  Created by bob.sun on 16/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFTypeManager.h"
#import "_PFType+CoreDataClass.h"


@interface PFTypeManager()
@property (strong) PFDBManager *dbManager;
@end

@implementation PFTypeManager

+(instancetype)sharedManager {
    static PFTypeManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance) {
            return;
        }
        instance = [[PFTypeManager alloc] init];
        instance.dbManager = [[PFDBManager alloc] init];
//        instance.dbManager = [PFDBManager sharedManager];
    });
    
    return instance;
}

- (NSError*)saveType:(PFType*)type {
    NSManagedObjectContext *ctx = [_dbManager context];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityNamePFType inManagedObjectContext:ctx];
    [type managedObjectWithEntity:entity andContext:ctx];
    
    NSError *err;
    [ctx save: &err];
    return err;
}
- (NSError*)saveTypeFromDict:(NSDictionary*)dict {
    return [self saveType: [[PFType alloc] initWithDict:dict]];
}

-(NSArray*)fetchAll {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:kEntityNamePFType];
    NSManagedObjectContext *ctx = [_dbManager context];
    NSError *err;
    NSAsynchronousFetchResult *result = [ctx executeRequest:req error:&err];
    if (err) {
        return nil;
    }
    return [PFType convertFromRaws:[result finalResult] toWrapped:[PFType class]];
}
-(NSArray*)fetchTypeByCategory:(int64_t)categoryId {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:kEntityNamePFType];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"category == %llu", categoryId];
    [req setPredicate:filter];
    NSManagedObjectContext *ctx = [_dbManager context];
    NSError *err;
    NSAsynchronousFetchResult *result = [ctx executeRequest:req error:&err];
    if (err) {
        return nil;
    }
    
    return [PFType convertFromRaws:[result finalResult] toWrapped:[PFType class]];
}

- (PFType*)fetchTypeById:(int64_t)identifier {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:kEntityNamePFType];
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"category == %llu", identifier];
    [req setPredicate:filter];
    NSManagedObjectContext *ctx = [_dbManager context];
    NSError *err;
    NSAsynchronousFetchResult *result = [ctx executeRequest:req error:&err];
    if (err) {
        return nil;
    }
    
    return [[PFType convertFromRaws:[result finalResult] toWrapped:[PFType class]] firstObject];
}

@end
