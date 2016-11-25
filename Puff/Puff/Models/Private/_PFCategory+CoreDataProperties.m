//
//  _PFCategory+CoreDataProperties.m
//  
//
//  Created by bob.sun on 25/11/2016.
//
//

#import "_PFCategory+CoreDataProperties.h"

@implementation _PFCategory (CoreDataProperties)

+ (NSFetchRequest<_PFCategory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PFCategory"];
}

@dynamic icon;
@dynamic identifier;
@dynamic name;
@dynamic type;

@end
