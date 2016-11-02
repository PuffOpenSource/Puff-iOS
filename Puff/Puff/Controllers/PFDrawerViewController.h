//
//  PFDrawerViewController.h
//  Puff
//
//  Created by bob.sun on 18/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFDrawerViewControllerDelegate <NSObject>

@required
- (void)loadAccountsInCategory:(uint64_t)catId;

@end

@interface PFDrawerViewController : UIViewController
@property (weak, nonatomic) id<PFDrawerViewControllerDelegate> delegate;

- (void)resetTitleLabel;
@end
