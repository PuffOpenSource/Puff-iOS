//
//  ActionViewController.h
//  PuffExtension
//
//  Created by bob.sun on 18/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFAccount;
@interface ActionViewController : UIViewController

@end

@protocol PFExtAccountCellDelegate <NSObject>

@required
- (void)didClickOnPin:(NSInteger)idx;
- (void)didClickOnCopy:(NSInteger)idx;

@end

@interface PFExtAccountCell : UITableViewCell
@property (weak, nonatomic) id<PFExtAccountCellDelegate> delegate;
- (void)configWithAccount:(PFAccount*)act andIndex:(NSInteger)index;
@end
