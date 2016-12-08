//
//  PFAccountAccess.m
//  Puff
//
//  Created by bob.sun on 08/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAccountAccess.h"
#import "Constants.h"
#import "PFAccount.h"

#import <UIKit/UIKit.h>

@implementation PFAccountAccess

+ (void)pinToday:(NSDictionary*)result withIcon:(NSString*)icon {
    if (result.allKeys.count == 0) {
        return;
    }
    NSUserDefaults *ud = [[NSUserDefaults alloc] initWithSuiteName:kUserDefaultGroup];
    [ud setBool:YES forKey:kTodayNewData];
    [ud setObject:[result objectForKey:kResultAccount] forKey:kTodayAccount];
    [ud setObject:[result objectForKey:kResultPassword] forKey:kTodayPassword];
    [ud setObject:[result objectForKey:kResultAdditional] forKey:kTodayAdditional];
    [ud setObject:icon forKey:kTodayIcon];
    [ud synchronize];
}

+ (void)copyToClipBoard:(NSDictionary*) result {
    NSString *pwd = [result objectForKey:kResultPassword];
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString: pwd == nil ? @"" : pwd];
}

@end
