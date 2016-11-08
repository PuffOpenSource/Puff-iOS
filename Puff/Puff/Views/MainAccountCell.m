//
//  MainAccountCell.m
//  Puff
//
//  Created by bob.sun on 20/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "MainAccountCell.h"

#import <MobileCoreServices/UTCoreTypes.h>

#import "PFAccount.h"
#import "PFResUtil.h"
#import "PFTypeManager.h"

@interface MainAccountCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *pinButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UIButton *cpyButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) PFAccount *account;

@end

@implementation MainAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.opaque = NO;
    self.backgroundView = [[UIView alloc] init];
    self.backgroundColor = [UIColor clearColor];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithAccount:(PFAccount *)account {
    _nameLabel.text = account.name;
    _accountLabel.text = account.masked_account;
    int64_t typeId = [@(account.type) longValue];
    PFType *type = [[PFTypeManager sharedManager] fetchTypeById:typeId];
    _typeLabel.text = type.name;
    if (account.icon.length > 0) {
        UIImage *img = [PFResUtil imageForName:account.icon];
        if (img) {
            _iconImage.image = img;
        } else {
            _iconImage.image = nil;
        }
    } else {
        _iconImage.image = nil;
    }
    _account = account;
}

#pragma mark - IBActions
- (IBAction)didTapOnViewButton:(id)sender {
    if (_delegate) {
        [_delegate mainAccountCell:self didTapOnViewButton:_account];
    }
}

- (IBAction)didTapOnCopyButton:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setValue:_account.hash_value forKey:(NSString*)kUTTypeText];
}

@end
