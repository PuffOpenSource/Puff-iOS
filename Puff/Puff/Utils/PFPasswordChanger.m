//
//  PFPasswordChanger.m
//  Puff
//
//  Created by bob.sun on 17/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFPasswordChanger.h"

#import "PFAccountManager.h"
#import "PFBlowfish.h"

@implementation PFPasswordChanger

+ (void)changePwdTo:(NSString *)pwd {
    NSArray<PFAccount*> *all = [[PFAccountManager sharedManager] fetchAll];
    for (PFAccount *act in all) {
        [act reEncrypt:pwd];
        [[PFAccountManager sharedManager] saveAccount:act];
    }
}

@end
