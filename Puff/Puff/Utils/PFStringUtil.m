//
//  PFStringUtil.m
//  Puff
//
//  Created by bob.sun on 02/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFStringUtil.h"

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
