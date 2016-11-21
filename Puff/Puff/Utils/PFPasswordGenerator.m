//
//  PFPasswordGenerator.m
//  Puff
//
//  Created by bob.sun on 21/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFPasswordGenerator.h"

@implementation PFPasswordGenerator

static NSString * const lettersAlphabet  = @"abcdefghijklmnopqrstuvwxyz";
static NSString * const capitalsAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static NSString * const digitsAlphabet   = @"0123456789";
static NSString * const symbolsAlphabet  = @"!@#$%*[];?()";
static NSString * const allChars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%*[];?()";

+ (NSString*)genPasswordWithLength:(NSInteger)length {
    NSMutableString *ret = [@"" mutableCopy];
    for (int l = 0; l < length; l ++) {
        [ret appendString: [self _randomCharFromList:allChars]];
    }
    return ret;
}

+ (NSString*)genPasswordWithLength:(NSInteger)length andWords:(NSArray *)words {
    NSMutableString *ret = [@"" mutableCopy];
    for (NSString *w in words) {
        [ret appendString:[self _maskedString:w]];
    }
    return ret;
}

+ (NSString*)genNumberWithLength:(NSInteger)length {
    NSMutableString *ret = [@"" mutableCopy];
    for (int l = 0; l < length; l ++) {
        [ret appendString: [self _randomCharFromList:digitsAlphabet]];
    }
    return ret;
}

+ (NSString*)_randomCharFromList:(NSString*)list {
    uint32_t random = 0;
    if (list.length > 0) {
        random = arc4random_uniform(list.length);
    }
    return [list substringWithRange:NSMakeRange(random, 1)];
}

+ (BOOL)_randomBoolean {
    return arc4random_uniform(100) > 49;
}

+ (NSString*)_maskedString:(NSString*)str {
    NSMutableString *ret = [@"" mutableCopy];
    NSDictionary *mapping = [self _charMapping];
    unichar *rawChars = malloc(sizeof(unichar) * str.length);
    [str getCharacters:rawChars range:NSMakeRange(0, str.length)];
    NSString *typedChar;
    for (int l = 0; l < str.length; l ++) {
        typedChar = [NSString stringWithCharacters:&rawChars[l] length:1];
        if ([self _randomBoolean]) {
            NSString *masked = [mapping objectForKey:[typedChar uppercaseString]];
            if (masked.length > 0) {
                typedChar = [self _randomCharFromList:masked];
            }
        }
        [ret appendString:typedChar];
    }
    free(rawChars);
    return ret;
}

+ (NSDictionary*)_charMapping {
    static NSDictionary *mapping;
    if (mapping == nil) {
        mapping = @{
                    @"A":@"@4",
                    @"B":@"8",
                    @"E":@"3",
                    @"G":@"6",
                    @"H":@"#",
                    @"I":@"!1",
                    @"O":@"0",
                    @"Q":@"9",
                    @"S":@"5$",
                    @"T":@"7",
                    @"V":@"\\/",
                    @"Z":@"2",
                    };
    }
    return mapping;
}

@end
