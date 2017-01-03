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
#import "PFKeychainHelper.h"

@interface PFAppLock(){
    @private
    BOOL locked;
    BOOL lockViewShowing;
    BOOL pauseLocking;
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
        self -> lockViewShowing = NO;
        self -> pauseLocking = NO;
        self.lockView = [PFLockViewController viewController];
    }
    return self;
}

- (BOOL)isLocked {
    return self->locked;
}

- (void)lock {
    if (![[PFKeychainHelper sharedInstance] hasMasterPassword]) {
        //Won't lock if doesn't have a master password.
        return;
    }
    self->locked = YES;
}

- (void)showLock {
    if (![[PFKeychainHelper sharedInstance] hasMasterPassword]) {
        //Won't lock if doesn't have a master password.
        return;
    }
    if (self -> pauseLocking) {
        //Won't lock for some exceptions.
        self -> pauseLocking = NO;
        return;
    }
    self->locked = YES;
    if (self->lockViewShowing) {
        return;
    }
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = win.rootViewController.presentedViewController;
    if (vc == nil) {
        vc = win.rootViewController;
    }
    [win addSubview:_lockView.view];
//    [vc presentViewController:_lockView animated:NO completion:nil];
    [_lockView showLockView];
    self->lockViewShowing = YES;
}

- (void)unlock {
    self->locked = NO;
}

- (void)unlockAndDismiss {
    self->locked = NO;
    if (!self->lockViewShowing) {
        return;
    }
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = win.rootViewController.presentedViewController;
    if (vc == nil) {
        vc = win.rootViewController;
    }
    [vc viewWillAppear:YES];
    [_lockView dismissLockView];
    self->lockViewShowing = NO;
}

- (void)pauseLocking {
    self -> pauseLocking = YES;
}

@end
