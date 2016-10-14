//
//  PFBaseModel.m
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFBaseModel.h"

#import "Config.h"


@implementation PFBaseModel
-(NSManagedObject*)managedObjectWithEntity:(NSEntityDescription *)entity andContext:(NSManagedObjectContext *)context {
    NSException *e = [NSException exceptionWithName:@"BaseModelNotOverriden" reason:@"BaseModle function not overriden!" userInfo:nil];
    @throw e;
}

- (void)copyFromCDRaw:(NSManagedObject *)rawObj {
    NSArray *properties = [self _getProperties];
    
    for (NSString *p in properties) {
        [self setValue:[rawObj valueForKey:p] forKey:p];
    }
}

//Return properties' names only
- (NSArray*)_getProperties {
    NSMutableArray *ret = [@[] mutableCopy];
    unsigned int total;
    objc_property_t *props = class_copyPropertyList([self class], &total);
    for (int i = 0; i < total; i++) {
        objc_property_t p = props[i];
        const char *pName = property_getName(p);
        [ret addObject:[NSString stringWithCString:pName encoding:[NSString defaultCStringEncoding]]];
    }
    return ret;
}
@end
