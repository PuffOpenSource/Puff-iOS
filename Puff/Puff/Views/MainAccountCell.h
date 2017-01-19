//
//  MainAccountCell.h
//  Puff
//
//  Created by bob.sun on 20/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kMainAccountCellReuseId         = @"kMainAccountCellReuseId";

@class PFAccount;
@class MainAccountCell;

@protocol MainAccountCellDelegate <NSObject>
@required
- (void)mainAccountCell:(MainAccountCell*)cell didTapOnViewButton:(PFAccount*) account;
- (void)mainAccountCell:(MainAccountCell*)cell didPinedAccount:(PFAccount*)account;
- (void)mainAccountCell:(MainAccountCell*)cell didCopiedAccount:(PFAccount*)account;

@end

@interface MainAccountCell : UITableViewCell
@property (weak, nonatomic) id<MainAccountCellDelegate> delegate;

- (void)configWithAccount:(PFAccount*)account;

@end
