//
//  PFAddCategoryViewController.h
//  Puff
//
//  Created by bob.sun on 09/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFDialogViewController : UIViewController
+ (instancetype)viewControllerFromStoryboard;
- (void)present:(UIView*)view inParent:(UIViewController*)vc;
@end
