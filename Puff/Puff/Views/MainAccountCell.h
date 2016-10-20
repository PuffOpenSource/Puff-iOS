//
//  MainAccountCell.h
//  Puff
//
//  Created by bob.sun on 20/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFAccount;
@interface MainAccountCell : UITableViewCell

- (void)configWithAccount:(PFAccount*)account;

@end
