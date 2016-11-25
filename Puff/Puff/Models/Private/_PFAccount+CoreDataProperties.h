//
//  _PFAccount+CoreDataProperties.h
//  
//
//  Created by bob.sun on 25/11/2016.
//
//

#import "_PFAccount+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface _PFAccount (CoreDataProperties)

+ (NSFetchRequest<_PFAccount *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *account;
@property (nullable, nonatomic, copy) NSString *account_salt;
@property (nullable, nonatomic, copy) NSString *additional;
@property (nullable, nonatomic, copy) NSString *additional_salt;
@property (nonatomic) int64_t category;
@property (nullable, nonatomic, copy) NSString *hash_value;
@property (nullable, nonatomic, copy) NSString *icon;
@property (nullable, nonatomic, copy) NSDate *last_access;
@property (nullable, nonatomic, copy) NSString *masked_account;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *salt;
@property (nonatomic) int64_t type;
@property (nullable, nonatomic, copy) NSString *website;

@end

NS_ASSUME_NONNULL_END
