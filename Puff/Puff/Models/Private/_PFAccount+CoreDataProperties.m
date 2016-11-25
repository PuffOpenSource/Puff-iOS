//
//  _PFAccount+CoreDataProperties.m
//  
//
//  Created by bob.sun on 25/11/2016.
//
//

#import "_PFAccount+CoreDataProperties.h"

@implementation _PFAccount (CoreDataProperties)

+ (NSFetchRequest<_PFAccount *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PFAccount"];
}

@dynamic account;
@dynamic account_salt;
@dynamic additional;
@dynamic additional_salt;
@dynamic category;
@dynamic hash_value;
@dynamic icon;
@dynamic last_access;
@dynamic masked_account;
@dynamic name;
@dynamic salt;
@dynamic type;
@dynamic website;

@end
