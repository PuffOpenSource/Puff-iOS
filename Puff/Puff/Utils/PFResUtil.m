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
    NSURL *libURL = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.bob.sun.leela"] URLByAppendingPathComponent:@"cats" isDirectory:NO];
    return [[libURL URLByAppendingPathComponent:name] absoluteString];
}
+ (UIImage*)imageForName:(NSString*)name {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: [self imagePathForName: name]]];
    UIImage *img = [UIImage imageWithData:data];
    return img;
}

//All images go to `~/Library/cats` in this APP.
+ (NSString*)saveImage:(UIImage*)image {
    NSString *path = [[[NSUUID UUID] UUIDString] stringByAppendingString:@".png"];
    path = [@"/" stringByAppendingString:path];

    
    NSURL *libURL = [[[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.bob.sun.leela"]
                      URLByAppendingPathComponent:@"cats" isDirectory:YES]
                     URLByAppendingPathComponent:path];
    
    [UIImagePNGRepresentation(image) writeToURL:libURL atomically:YES];

    return path;
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

+ (void)shakeItBaby:(UIView *)sender withCompletion:(nullable void (^)(void))completion {
    [CATransaction begin];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:6];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([sender center].x - 5.0f, [sender center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([sender center].x + 5.0f, [sender center].y)]];
    animation.removedOnCompletion = YES;
    [CATransaction setCompletionBlock:completion];
    
    [[sender layer] addAnimation:animation forKey:@"position"];
    [CATransaction commit];
}
@end
