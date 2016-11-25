//
//  _PFType+CoreDataProperties.m
//  
//
//  Created by bob.sun on 25/11/2016.
//
//

#import "_PFType+CoreDataProperties.h"

@implementation _PFType (CoreDataProperties)

+ (NSFetchRequest<_PFType *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PFType"];
}

@dynamic category;
@dynamic icon;
@dynamic identifier;
@dynamic name;

@end
