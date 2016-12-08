//
//  PFAccountAccess.h
//  Puff
//
//  Created by bob.sun on 08/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFAccountAccess : NSObject
+ (void)pinToday:(NSDictionary*)result withIcon:(NSString*)icon;
+ (void)copyToClipBoard:(NSDictionary*) result;
@end
