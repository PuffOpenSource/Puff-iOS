//
//  FCAccount.m
//  Puff
//
//  Created by bob.sun on 12/01/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

#import "FCAccount.h"

#import "PFAccount.h"

@implementation FCAccount 
- (instancetype) initWithPFModel:(PFAccount*)model {
    self = [super init];
    if (self) {
        _account = model.account;
        _account_salt = model.account_salt;
        _masked_account = model.masked_account;
        _additional = model.additional;
        _additional_salt = model.additional_salt;
        _category = model.category;
        _hash_value = model.hash_value;
        _salt = model.salt;
        _icon = model.icon;
        _last_access = [model.last_access timeIntervalSince1970];;
        _name = model.name;
        _type = model.type;
        _website = model.website ? : @"";
    }
    return self;
}

-(void) populateWith:(PFAccount*)model {
    _account = model.account;
    _account_salt = model.account_salt;
    _masked_account = model.masked_account;
    _additional = model.additional;
    _additional_salt = model.additional_salt;
    _category = model.category;
    _hash_value = model.hash_value;
    _salt = model.salt;
    _icon = model.icon;
    _last_access = [model.last_access timeIntervalSince1970];;
    _name = model.name;
    _type = model.type;
    _website = model.website ? : @"";
    
    _tag = @"";
    _hide_name = 0;
}
#pragma mark - Delegate
- (NSString*)customizeTableName {
    return @"ACCOUNT";
}
@end
