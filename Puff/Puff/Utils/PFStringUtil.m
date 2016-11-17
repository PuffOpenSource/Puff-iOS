//
//  PFStringUtil.m
//  Puff
//
//  Created by bob.sun on 02/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFStringUtil.h"

static NSString * REG_EX_EMAIL = @"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";


@implementation PFStringUtil

+ (NSString*)getMaskedEmail:(NSString*)email {
    if (email.length == 0) {
        return @"";
    }
    NSError *err;
    NSRegularExpression *magic = [NSRegularExpression regularExpressionWithPattern:@"(?<=.).(?=[^@]*?.@)" options:NSRegularExpressionCaseInsensitive error:&err];
    NSMutableString *ret = [email mutableCopy];
    [magic replaceMatchesInString:ret options:NSMatchingReportCompletion range:NSMakeRange(0, email.length) withTemplate:@"*"];
    return ret;
    
}

+ (NSString*)getMaskedPhoneNumber:(NSString*)phone {
    if (phone.length == 0) {
        return @"";
    }
    NSString *ret;
    if (phone.length < 4) {
        ret = [[phone substringToIndex:1] stringByAppendingString:[self getStars:[phone substringFromIndex:1]]];
    } else {
        ret = [phone substringFromIndex:phone.length - 4];
        ret = [[self getStars:[phone substringToIndex:phone.length - 4]] stringByAppendingString:ret];
    }
    
    return ret;
    
}

+ (BOOL)isEmail:(NSString *)email {
    if (email.length == 0) {
        return NO;
    }
    NSError *err;
    NSRegularExpression *magic = [NSRegularExpression regularExpressionWithPattern:REG_EX_EMAIL options:NSRegularExpressionCaseInsensitive error:&err];
    return [magic matchesInString:email options:NSMatchingReportCompletion range:NSMakeRange(0, email.length)].count != 0;
}

+ (NSString*)getStars:(NSString*) src {
    if (src.length == 0) {
        return @"";
    }
    NSError *err;
    NSRegularExpression *magic = [NSRegularExpression regularExpressionWithPattern:@"\\S" options:NSRegularExpressionCaseInsensitive error:&err];
    NSMutableString *ret = [src mutableCopy];
    [magic replaceMatchesInString:ret options:NSMatchingReportCompletion range:NSMakeRange(0, src.length) withTemplate:@"*"];
    return ret;
}

+ (NSString*)getStarsIgnoreWhite:(NSString*) src {
    if (src.length == 0) {
        return @"";
    }
    NSError *err;
    NSRegularExpression *magic = [NSRegularExpression regularExpressionWithPattern:@"\\s" options:NSRegularExpressionCaseInsensitive error:&err];
    NSMutableString *ret = [src mutableCopy];
    [magic replaceMatchesInString:ret options:NSMatchingReportCompletion range:NSMakeRange(0, src.length) withTemplate:@"*"];
    return ret;
}

@end
