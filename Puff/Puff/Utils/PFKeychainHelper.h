//
//  PFKeychainHelper.h
//  Puff
//
//  Created by bob.sun on 22/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const keyChainStoreKey        =   @"masterpwd";
static NSString * const keyChainAccessGroup     =   @"sun.bob.leela";

@interface PFKeychainHelper : NSObject
+ (instancetype)sharedInstance;

- (BOOL)checkPassword:(NSString*)password;
- (BOOL)hasMasterPassword;
- (BOOL)setMasterPassword:(NSString*)pwd;
- (void)cleanMasterPassword;
- (NSString*)getMasterPassword;
- (BOOL)updateMasterPassword:(NSString*)newPass;
@end
