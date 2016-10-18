//
//  PFDrawerCell.h
//  Puff
//
//  Created by bob.sun on 18/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const     kReuseIdPFDrawerCell = @"kReuseIdPFDrawerCell";

@class PFCategory;
@interface PFDrawerCell : UITableViewCell
- (void)configWithCategory:(PFCategory*)category;
@end
