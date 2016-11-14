//
//  PFAccountDetailViewController.h
//  Puff
//
//  Created by bob.sun on 03/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFAccount;

@interface PFAccountDetailViewController : UIViewController
+ (instancetype)viewControllerFromStoryboardWithAccount:(PFAccount*)account;
@end
