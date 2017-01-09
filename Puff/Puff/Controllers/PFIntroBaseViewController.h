//
//  PFIntroBaseViewController.h
//  Puff
//
//  Created by bob.sun on 30/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFIntroViewControllerDelegate <NSObject>
@required
- (void)next;
- (void)previous;

@end

@interface PFIntroBaseViewController : UIViewController

@property (weak, nonatomic) id<PFIntroViewControllerDelegate> delegate;
@end
