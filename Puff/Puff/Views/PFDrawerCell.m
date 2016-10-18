//
//  PFDrawerCell.m
//  Puff
//
//  Created by bob.sun on 18/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFDrawerCell.h"

#import "PFCategory.h"

@interface PFDrawerCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation PFDrawerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithCategory:(PFCategory*)category {
    _nameLabel.text = category.name;
}

@end
