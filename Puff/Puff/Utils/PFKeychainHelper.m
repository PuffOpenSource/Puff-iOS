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

- (NSString*)masterPassword {
    
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
    
//    NSMutableDictionary *queries = [@{} mutableCopy];
//    [queries setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
//    [queries setObject:keyChainStoreKey forKey:(id)kSecAttrDescription];
//    [queries setObject:(id)kCFBooleanTrue forKey:(id)kSecMatchCaseInsensitive];
//    [queries setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
//    [queries setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
//    [queries setObject:keyChainAccessGroup forKey:(id)kSecAttrAccessGroup];
//    
//    NSData *rawResult = nil;
//    CFTypeRef typed = (__bridge CFTypeRef)rawResult;
//    
//    OSStatus err = noErr;
//    err = SecItemCopyMatching((CFDictionaryRef)queries, &typed);
//    if (err != errSecSuccess) {
//        return @"";
//    }
//    return [NSString stringWithUTF8String:rawResult.bytes];
}

- (BOOL)setMasterPassword:(NSString*)pwd {
    NSMutableDictionary *keyChainQuery = [self newSearchDictionary:keyChainStoreKey];
    [keyChainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:[pwd dataUsingEncoding:NSUTF8StringEncoding]]
                      forKey:(__bridge_transfer id)kSecValueData];

    OSStatus err = SecItemAdd((__bridge_retained CFDictionaryRef)keyChainQuery, nil);
    return err == errSecSuccess;
//    NSMutableDictionary *toAdd = [@{} mutableCopy];
//    [toAdd setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
//    [toAdd setObject:[NSBundle bundleForClass:self.class].bundleIdentifier forKey:(id)kSecAttrDescription];
//    [toAdd setObject:keyChainAccessGroup forKey:(id)kSecAttrAccessGroup];
//    [toAdd setObject:[NSKeyedArchiver archivedDataWithRootObject:pwd] forKey:(id)kSecValueData];
//    
//    OSStatus err = noErr;
//    err = SecItemAdd((CFDictionaryRef) toAdd, NULL);
//    return err == errSecSuccess;
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
    
    //[searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

@end
