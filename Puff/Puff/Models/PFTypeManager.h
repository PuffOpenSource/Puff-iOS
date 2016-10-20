//
//  PFTypeManager.h
//  Puff
//
//  Created by bob.sun on 16/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFDBManager.h"
#import "_PFType+CoreDataClass.h"
#import "PFType.h"

static NSString * const kEntityNamePFType       = @"PFType";

@interface PFTypeManager : NSObject

+(instancetype)sharedManager;

- (NSError*)saveType:(PFType*)type;
- (NSError*)saveTypeFromDict:(NSDictionary*)dict;

-(NSArray*)fetchAll;
-(NSArray*)fetchTypeByCategory:(int64_t)categoryId;
-(PFType*)fetchTypeById:(int64_t)identifier;

@end
