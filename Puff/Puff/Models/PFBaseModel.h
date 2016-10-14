//
//  PFBaseModel.h
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface PFBaseModel : NSObject
- (NSManagedObject*)managedObjectWithEntity:(NSEntityDescription*) entity andContext:(NSManagedObjectContext*)context;
@end
