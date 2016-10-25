//
//  PFAppLock.m
//  Puff
//
//  Created by bob.sun on 25/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAppLock.h"

#import "PFLockViewController.h"
#import "AppDelegate.h"

@interface PFAppLock(){
    @private
    BOOL locked;
}

@property(strong, nonatomic) PFLockViewController *lockView;

@end

@implementation PFAppLock
+ (instancetype)sharedLock {
    static PFAppLock *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PFAppLock alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self -> locked = YES;
        self.lockView = [PFLockViewController viewController];
    }
    return self;
}

- (BOOL)isLocked {
    return self->locked;
}

- (void)lock {
    self->locked = YES;
}

- (void)showLock {
    self->locked = YES;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    [[win.subviews firstObject] addSubview:_lockView.view];
    [_lockView showLockView];
}

- (void)unlock {
    self->locked = NO;
}

- (void)unlockAndDismiss {
    self->locked = NO;
    [_lockView dismissLockView];
    [_lockView.view removeFromSuperview];
}

@end
