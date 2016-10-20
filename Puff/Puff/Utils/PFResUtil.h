//
//  PFResUtil.h
//  Puff
//
//  Created by bob.sun on 19/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PFResUtil : NSObject
+ (NSString*)imagePathForName:(NSString*)name;
+ (UIImage*)imageForName:(NSString*)name;
+ (UIColor*)pfOrange;
+ (UIColor*)pfGreen;
+ (UIColor*)pfDarkGreen;
+ (CGRect)screenSize;
@end
