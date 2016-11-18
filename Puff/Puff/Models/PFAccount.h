//
//  PFAccount.h
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  strongright © 2016 bob.sun. All rights reserved.
//

#import "PFBaseModel.h"

@class PFAccount;
@class _PFAccount;

static NSString * const kResultAccount              = @"kResultAccount";
static NSString * const kResultPassword             = @"kResultPassword";
static NSString * const kResultAdditional           = @"kResultAdditional";

typedef void(^PFAccountEncryptCallback)( NSError * _Nullable error, PFAccount* _Nullable result);
typedef void(^PFAccountDecryptCallback)(NSError * _Nullable error, NSDictionary* _Nullable result);

#define PFAccountErrorDomain    @"bob.sun.leela"

@interface PFAccount : PFBaseModel
@property (nullable, nonatomic, strong) NSString *account;
@property (nullable, nonatomic, strong) NSString *account_salt;
@property (nullable, nonatomic, strong) NSString *masked_account;
@property (nullable, nonatomic, strong) NSString *additional;
@property (nullable, nonatomic, strong) NSString *additional_salt;
@property (nonatomic) int64_t category;
@property (nullable, nonatomic, strong) NSString *hash_value;
@property (nullable, nonatomic, strong) NSString *icon;
@property (nullable, nonatomic, strong) NSDate *last_access;
@property (nullable, nonatomic, strong) NSString *name;
@property (nullable, nonatomic, strong) NSString *salt;
@property (nonatomic) int64_t type;
@property (nullable, nonatomic, strong) NSString *website;

- (PFAccount* _Nonnull)initWithDict:(NSDictionary* _Nonnull)dict;
- (_PFAccount*)getBaseModel;
- (void)encrypt:(PFAccountEncryptCallback) callback;
- (void)decrypt:(PFAccountDecryptCallback) callback;
@end
