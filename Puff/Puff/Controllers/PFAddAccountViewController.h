//
//  PFAddAccountViewController.h
//  Puff
//
//  Created by bob.sun on 19/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFAccount;
@protocol PFEditAccountDelegate <NSObject>

@required
- (void)accountChanged:(PFAccount*)result andInfo:(NSDictionary*)info;

@end
@interface PFAddAccountViewController : UIViewController
@property (weak, nonatomic) id<PFEditAccountDelegate> delegate;
+ (instancetype)viewControllerFromStoryboard;
+ (instancetype)viewControllerFromStoryboard:(PFAccount*)account andInfo:(NSDictionary*)info;
@end
