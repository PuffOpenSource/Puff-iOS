//
//  PFTypeManager.m
//  Puff
//
//  Created by bob.sun on 16/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFTypeManager.h"

@implementation PFTypeManager

+(instancetype)sharedManager {
    return nil;
}

- (NSError*)saveType:(PFType*)type {
    return nil;
}
- (NSError*)saveTypeFromDict:(NSDictionary*)dict {
    return nil;
}

-(NSArray*)fetchAll {
    return nil;
}
-(NSArray*)fetchTypeByCategory:(int64_t)categoryId {
    return nil;
}

@end
