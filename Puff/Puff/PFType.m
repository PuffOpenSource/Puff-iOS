//
//  PFType.m
//  Puff
//
//  Created by bob.sun on 16/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFType.h"

#import "_PFType+CoreDataClass.h"

@implementation PFType

- (instancetype)initWithDict:(NSDictionary*)dict {
    return nil;
}

- (NSManagedObject*)managedObjectWithEntity:(NSEntityDescription *)entity andContext:(NSManagedObjectContext *)context {
    _PFType *ret = [[_PFType alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    ret.name = _name;
    ret.category = _category;
    ret.identifier = _identifier;
    ret.icon = _icon;
    return ret;
}
@end
