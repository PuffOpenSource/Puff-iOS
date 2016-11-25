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

@interface PFExtAccoutnCell : UITableViewCell
- (void)configWithAccount:(PFAccount*)act;
@end
