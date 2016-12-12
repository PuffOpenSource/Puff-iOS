//
//  PFAppLock.h
//  Puff
//
//  Created by bob.sun on 25/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kAppUnlocked        = @"kAppUnlocked";
static NSString * const kAppLocked          = @"kAppLocked";

@interface PFAppLock : NSObject

+(instancetype)sharedLock;
- (void)lock;
- (void)unlock;
- (BOOL)isLocked;
- (void)showLock;
- (void)unlockAndDismiss;
- (void)pauseLocking;
@end
