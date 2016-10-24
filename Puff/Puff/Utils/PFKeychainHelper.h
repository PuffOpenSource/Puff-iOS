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

- (NSString*)getMasterPassword;
- (BOOL)setMasterPassword:(NSString*)pwd;
@end
