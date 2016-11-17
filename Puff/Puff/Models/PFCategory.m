//
//  PFCategory.m
//  Puff
//
//  Created by bob.sun on 16/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFCategory.h"

#import "_PFCategory+CoreDataClass.h"

@implementation PFCategory

- (instancetype)initWithDict:(NSDictionary *)dict {
    return nil;
}

- (NSManagedObject*)managedObjectWithEntity:(NSEntityDescription *)entity andContext:(NSManagedObjectContext *)context {
    _PFCategory *ret = self.baseModel;
    if (!ret) {
        ret = [[_PFCategory alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        self.baseModel = ret;
    }
    ret.name = _name;
    ret.type = _type;
    ret.identifier = _identifier;
    ret.icon = _icon;
    return ret;
}
@end
