//
//  PFKeychainHelper.m
//  Puff
//
//  Created by bob.sun on 22/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFKeychainHelper.h"

#import <Security/Security.h>

@interface PFKeychainHelper()

@end

@implementation PFKeychainHelper
+ (instancetype)sharedInstance {
    static PFKeychainHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PFKeychainHelper alloc] init];
    });
    return instance;
}

- (BOOL)checkPassword:(NSString*)password {
    return [[self getMasterPassword] isEqualToString:password];
}

- (BOOL)hasMasterPassword {
    return [self getMasterPassword].length != 0;
}

- (void)cleanMasterPassword {
    NSMutableDictionary *query = [self newSearchDictionary:keyChainStoreKey];
    OSStatus err = SecItemDelete((__bridge_retained CFDictionaryRef)query);
    if (err == errSecSuccess) {
        return;
    }
}

- (NSString*)getMasterPassword {
    
    NSData *ret = nil;
    NSMutableDictionary *keyChainQuery = [self newSearchDictionary:keyChainStoreKey];
    [keyChainQuery setObject:(id)kCFBooleanTrue
                      forKey:(__bridge_transfer id)kSecReturnData];
    [keyChainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne
                      forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keyChainQuery, (CFTypeRef*)&keyData) == noErr)
    {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData*)keyData];
    } else {
        return nil;
    }
    
    
    return [NSString stringWithUTF8String:ret.bytes];
}

- (BOOL)setMasterPassword:(NSString*)pwd {
    NSMutableDictionary *keyChainQuery = [self newSearchDictionary:keyChainStoreKey];
    [keyChainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:[pwd dataUsingEncoding:NSUTF8StringEncoding]]
                      forKey:(__bridge_transfer id)kSecValueData];

    
    OSStatus err = SecItemAdd((__bridge_retained CFDictionaryRef)keyChainQuery, nil);
    return err == errSecSuccess;
}

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier
{
    
    NSMutableDictionary * searchDictionary = [[NSMutableDictionary alloc] init];
    NSData *encodeInditifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:(__bridge_transfer id)kSecClassGenericPassword
                         forKey:(__bridge_transfer id)kSecClass];
    [searchDictionary setObject:encodeInditifier forKey:(__bridge_transfer id)kSecAttrGeneric];
    [searchDictionary setObject:encodeInditifier forKey:(__bridge_transfer id)kSecAttrAccount];
    [searchDictionary setObject:(__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock
                         forKey:(__bridge_transfer id)kSecAttrAccessible];
//    NSString *prefix = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppIdentifierPrefix"];
//    NSString *group = [prefix stringByAppendingString:keyChainAccessGroup];
//    [searchDictionary setObject:[group dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge_transfer id)kSecAttrAccessGroup];
    //[searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

- (BOOL)updateMasterPassword:(NSString*)newPass {
    [self cleanMasterPassword];
    return [self setMasterPassword:newPass];
}

@end
