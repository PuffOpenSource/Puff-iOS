//
//  FCAccount.h
//  Puff
//
//  Created by bob.sun on 12/01/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

#import <FCModel/FCModel.h>

@class PFAccount;
@interface FCAccount : FCModel

@property (nonatomic) int64_t _id;
@property (nullable, nonatomic, strong) NSString *account;
@property (nullable, nonatomic, strong) NSString *account_salt;
@property (nullable, nonatomic, strong) NSString *masked_account;
@property (nullable, nonatomic, strong) NSString *additional;
@property (nullable, nonatomic, strong) NSString *additional_salt;
@property (nonatomic) int64_t category;
@property (nullable, nonatomic, strong) NSString *hash_value;
@property (nullable, nonatomic, strong) NSString *icon;
@property (nonatomic) int64_t last_access;
@property (nullable, nonatomic, strong) NSString *name;
@property (nullable, nonatomic, strong) NSString *salt;
@property (nonatomic) int64_t type;
@property (nullable, nonatomic, strong) NSString *website;

//Unused for now
@property (nullable, nonatomic, strong) NSString *tag;
@property (nonatomic) int64_t hide_name;

//Selectors
- (instancetype) initWithPFModel:(PFAccount*)model;
-(void) populateWith:(PFAccount*)model;
@end
