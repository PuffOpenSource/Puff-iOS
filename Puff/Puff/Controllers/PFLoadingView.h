//
//  PFLoadingViewController.h
//  Puff
//
//  Created by bob.sun on 23/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFLoadingView : UIView
+ (void)showIn:(UIViewController*)vc;
+ (void)dismiss;

+ (void)updateLabel:(NSString*)update;
@end
