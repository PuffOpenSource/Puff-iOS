//
//  PFSettings.m
//  Puff
//
//  Created by bob.sun on 06/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFSettings.h"
#import "Constants.h"

static NSString * const kHasSettings        = @"kHasSettings";
static NSString * const kTouchIDEnabled     = @"kTouchIdEnabled";
static NSString * const kClearInfo          = @"kClearInfo";

@interface PFSettings()
@property (strong, nonatomic) NSUserDefaults *store;
@end

@implementation PFSettings

+ (instancetype)sharedInstance {
    static PFSettings *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PFSettings alloc] init];
        instance.store = [[NSUserDefaults alloc] initWithSuiteName:kUserDefaultGroup];
        id hasSettings = [instance.store objectForKey:kHasSettings];
        if (hasSettings == nil) {
            [instance initDefaults];
        }
    });
    return instance;
}

- (BOOL)touchIDEnabled {
    return YES;
}
- (void)setTouchIDEnabled:(BOOL)enabled {
    
}

- (BOOL)clearInfo {
    return YES;
}
- (void)setClearInfo:(BOOL)clearInfo {
    
}

- (void)initDefaults {
    [_store setBool:YES forKey:kHasSettings];
    [_store setBool:YES forKey:kTouchIDEnabled];
    [_store setBool:YES forKey:kClearInfo];
    [_store synchronize];
}
@end
