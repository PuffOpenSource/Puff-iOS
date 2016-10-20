//
//  PFResUtil.m
//  Puff
//
//  Created by bob.sun on 19/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFResUtil.h"

@implementation PFResUtil
+ (NSString*)imagePathForName:(NSString*)name {
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(
                                                             NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    libPath = [libPath stringByAppendingString:@"/cats"];
    return [libPath stringByAppendingString:name];
}
+ (UIImage*)imageForName:(NSString*)name {
    return nil;
}

+ (UIColor*)pfOrange {
    return [UIColor colorWithRed:1.00 green:0.43 blue:0.17 alpha:1.00];
}

+ (UIColor*)pfGreen {
    return [UIColor colorWithRed:0.61 green:0.79 blue:0.38 alpha:1.00];
}

+ (UIColor*)pfDarkGreen {
    return [UIColor colorWithRed:0.41 green:0.62 blue:0.22 alpha:1.00];
}

+ (CGRect)screenSize {
    return [UIScreen mainScreen].bounds;
}
@end
