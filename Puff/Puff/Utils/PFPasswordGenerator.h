//
//  PFPasswordGenerator.h
//  Puff
//
//  Created by bob.sun on 21/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFPasswordGenerator : NSObject
+ (NSString*)genPasswordWithLength:(NSInteger)length;
+ (NSString*)genNumberWithLength:(NSInteger)length;
+ (NSString*)genPasswordWithLength:(NSInteger)length andWords:(NSArray*)words;
@end
