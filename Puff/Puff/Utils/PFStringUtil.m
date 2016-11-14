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
@end
