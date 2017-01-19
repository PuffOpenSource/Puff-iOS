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
static NSString * const kIntroShown         = @"kIntroShown%@";

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
    return [_store boolForKey:kTouchIDEnabled];
}
- (void)setTouchIDEnabled:(BOOL)enabled {
    [_store setBool:enabled forKey:kTouchIDEnabled];
}

- (BOOL)clearInfo {
    return [_store boolForKey:kClearInfo];
}
- (void)setClearInfo:(BOOL)enabled {
    [_store setBool:enabled forKey:kClearInfo];
}

- (void)save {
    [_store synchronize];
}

- (BOOL)introShown {
    NSString *key = [NSString stringWithFormat:kIntroShown, [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleVersion"]];
    return [_store boolForKey:key];
}

- (void)shownIntro {
    NSString *key = [NSString stringWithFormat:kIntroShown, [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleVersion"]];
    [_store setBool:YES forKey:key];
    [_store synchronize];
}

- (void)initDefaults {
    [_store setBool:YES forKey:kHasSettings];
    [_store setBool:YES forKey:kTouchIDEnabled];
    [_store setBool:YES forKey:kClearInfo];
    [_store synchronize];
}
@end
