//
//  PFBaseModel.m
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFBaseModel.h"


@implementation PFBaseModel
-(NSManagedObject*)managedObjectWithEntity:(NSEntityDescription *)entity andContext:(NSManagedObjectContext *)context {
    NSException *e = [NSException exceptionWithName:@"BaseModelNotOverriden" reason:@"BaseModle function not overriden!" userInfo:nil];
    @throw e;
}
@end
