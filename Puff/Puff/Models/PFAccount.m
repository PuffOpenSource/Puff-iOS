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
#import "PFBlowfish.h"
#import "PFKeychainHelper.h"


@implementation PFAccount

- (PFAccount*)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        //TODO:
    }
    return self;
}

- (PFAccount*)initWithRaw:(_PFAccount*)raw {
    self = [super init];
    if (self) {
        self.baseModel = raw;
    }
    return self;
}


- (NSManagedObject*)managedObjectWithEntity:(NSEntityDescription *)entity andContext:(NSManagedObjectContext *)context {
    _PFAccount *ret = self.baseModel;
    if (!ret) {
        ret = [[_PFAccount alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        self.baseModel = ret;
    }
    ret.account = _account;
    ret.account_salt = _account_salt;
    ret.masked_account = _masked_account;
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

- (_PFAccount*)getBaseModel {
    return self.baseModel;
}

- (void)encrypt:(PFAccountEncryptCallback) callback {
    [self _asyncEncrypt:callback];
}
- (void)decrypt:(PFAccountEncryptCallback) callback {
    [self _asyncDecrypt:callback];
}

- (void)_asyncEncrypt:(PFAccountEncryptCallback) callback {
    NSString *password = [[PFKeychainHelper sharedInstance] getMasterPassword];
    _account_salt = [[NSUUID UUID] UUIDString];
    _salt = [[NSUUID UUID] UUIDString];
    if (_additional.length > 0) {
        _additional_salt = [[NSUUID UUID] UUIDString];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError *err = nil;
        @try {
            PFBlowfish *fish = [[PFBlowfish alloc] init];
            fish.Key = password;
            fish.IV = @"";
            [fish prepare];
            _account = [fish encrypt:[_account stringByAppendingString:_account_salt] withMode:modeEBC withPadding:paddingRFC];
            
            fish = [[PFBlowfish alloc] init];
            fish.Key = password;
            fish.IV = @"";
            [fish prepare];
            _hash_value = [fish encrypt:[_hash_value stringByAppendingString:_salt] withMode:modeEBC withPadding:paddingRFC];
            
            if (_additional.length > 0) {
                fish = [[PFBlowfish alloc] init];
                fish.Key = password;
                fish.IV = @"";
                [fish prepare];
                _additional = [fish encrypt:[_additional stringByAppendingString:_additional_salt] withMode:modeEBC withPadding:paddingRFC];
            }
        } @catch (NSException *exception) {
            err = [NSError errorWithDomain:PFAccountErrorDomain code:-1 userInfo:@{@"exception":exception}];
        } @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil, self);
            });
        }
    });
}

- (void)_asyncDecrypt:(PFAccountEncryptCallback) callback {
    NSString *password = [[PFKeychainHelper sharedInstance] getMasterPassword];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError *err = nil;
        @try {
            PFBlowfish *fish = [[PFBlowfish alloc] init];
            fish.Key = password;
            fish.IV = @"";
            [fish prepare];
            _account = [[fish decrypt:_account withMode:modeEBC withPadding:paddingRFC] stringByReplacingOccurrencesOfString:_account_salt withString:@""];
            
            fish = [[PFBlowfish alloc] init];
            fish.Key = password;
            fish.IV = @"";
            [fish prepare];
            _hash_value = [[fish decrypt:_hash_value withMode:modeEBC withPadding:paddingRFC] stringByReplacingOccurrencesOfString:_salt withString:@""];
            
            if (_additional.length > 0) {
                fish = [[PFBlowfish alloc] init];
                fish.Key = password;
                fish.IV = @"";
                [fish prepare];
                _additional = [[fish decrypt:_additional withMode:modeEBC withPadding:paddingRFC] stringByReplacingOccurrencesOfString:_additional_salt withString:@""];
            }
        } @catch (NSException *exception) {
            err = [NSError errorWithDomain:PFAccountErrorDomain code:-1 userInfo:@{@"exception":exception}];
        } @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(nil, self);
            });
        }
    });
}
@end
