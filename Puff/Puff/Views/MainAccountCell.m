//
//  MainAccountCell.m
//  Puff
//
//  Created by bob.sun on 20/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "MainAccountCell.h"

#import "PFAccount.h"
#import "PFTypeManager.h"

@interface MainAccountCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *pinButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UIButton *cpyButton;

@end

@implementation MainAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithAccount:(PFAccount *)account {
    _nameLabel.text = account.name;
    _accountLabel.text = account.masked_account;
    PFType *type = [[PFTypeManager sharedManager] fetchTypeById:account.type];
    _typeLabel.text = type.name;
}

@end
