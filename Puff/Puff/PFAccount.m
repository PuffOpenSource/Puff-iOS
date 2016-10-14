//
//  PFAccount.m
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAccount.h"
#import "_PFAccount+CoreDataClass.h"
#import "_PFAccount+CoreDataProperties.h"

@implementation PFAccount

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        //TODO:
    }
    return self;
}


- (NSManagedObject*)managedObjectWithEntity:(NSEntityDescription *)entity andContext:(NSManagedObjectContext *)context {
    _PFAccount *ret = [[_PFAccount alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    ret.account = _account;
    ret.account_salt = _account_salt;
    ret.additional = _additional;
    ret.additional_salt = _additional_salt;
    ret.category = _category;
    ret.hash_value = _hash_value;
    ret.icon = _icon;
    ret.last_access = _last_access;
    ret.name = _name;
    ret.salt = _salt;
    ret.type = _type;
    ret.website = _website;
    return ret;
}

@end
