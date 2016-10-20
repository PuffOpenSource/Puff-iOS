//
//  PFAccountManager.h
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_PFAccount+CoreDataClass.h"
#import "PFAccount.h"

static NSString * const kEntityNamePFAccount        =   @"PFAccount";

@interface PFAccountManager : NSObject

+(instancetype)sharedManager;

- (NSError*)saveAccount:(PFAccount*)account;
- (NSError*)saveAccountFromDict:(NSDictionary*)dict;

-(NSArray*)fetchAll;
-(NSArray*)fetchAccountsByCategory:(int64_t)categoryId;
-(NSArray*)fetchAccountsByType:(int64_t)typeId;
-(NSArray*)fetchRecentUsed:(NSInteger)limit;

@end
