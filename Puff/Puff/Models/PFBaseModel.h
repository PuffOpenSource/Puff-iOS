//
//  PFBaseModel.h
//  Puff
//
//  Created by bob.sun on 14/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>
#import <objc/runtime.h>

@interface PFBaseModel : NSObject
- (NSManagedObject*)managedObjectWithEntity:(NSEntityDescription*) entity andContext:(NSManagedObjectContext*)context;

//Try to fetch properties with same name from rawObj then pop it to self
//Requires rawObj's properties contains self properties.
//Will crash if not.
- (void)copyFromCDRaw:(NSManagedObject*)rawObj;
@end
