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
    _baseModel = rawObj;
}

//Return properties' names only
- (NSArray*)_getProperties {
    NSMutableArray *ret = [@[] mutableCopy];
    unsigned int total;
    objc_property_t *props = class_copyPropertyList([self class], &total);
    for (int i = 0; i < total; i++) {
        objc_property_t p = props[i];
        @try {
            const char *pName = property_getName(p);
            NSString *typedName = [NSString stringWithCString:pName encoding:[NSString defaultCStringEncoding]];
            if ([typedName isEqualToString:@"baseModel"]) {
                continue;
            }
            [ret addObject:typedName];
        } @catch (NSException *exception) {
            if (DEBUG) {
                @throw exception;
            } else {
                NSLog(@"Exception Threw from PFBaseMode with reason: %@ and userinfo %@", exception.reason, exception.userInfo);
            }
        }
    }
    return ret;
}

- (NSString*)description {
    NSString * ret = @"PFModel Object - \n";
    NSArray *properties = [self _getProperties];
    for (NSString *p in properties) {
        NSString * pStr = [NSString stringWithFormat:@"\t%@ : %@ \n", p, [self valueForKey:p]];
        ret = [ret stringByAppendingString:pStr];
    }
    return ret;
}

+ (NSArray*)convertFromRaws:(NSArray*)raws toWrapped:(Class)clazz {
    NSMutableArray *ret = [@[] mutableCopy];
    for (NSManagedObject *raw in raws) {
        PFBaseModel *cat = [[clazz alloc] init];
        [cat copyFromCDRaw:raw];
        [ret addObject:cat];
    }
    return ret;
}
@end
