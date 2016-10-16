//
//  PFCategoryManager.m
//  Puff
//
//  Created by bob.sun on 16/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFCategoryManager.h"

@implementation PFCategoryManager
- (instancetype)sharedManager {
    return nil;
}

- (NSError*)saveCategory:(PFCategory*)category {
    return nil;
}
- (NSError*)saveCategoryFromDict:(NSDictionary*)dict {
    return nil;
}

-(NSArray*)fetchAll {
    return nil;
}
-(NSArray*)fetchCategoryByType:(int64_t)typeId {
    return nil;
}
@end
