//
//  PFDrawerCell.m
//  Puff
//
//  Created by bob.sun on 18/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFDrawerCell.h"

#import "PFCategory.h"
#import "PFResUtil.h"

@interface PFDrawerCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

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
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath: [PFResUtil imagePathForName: category.icon] isDirectory:NO]];
//    UIImage *img = [UIImage imageWithData:data];
    self.icon.image = [PFResUtil imageForName:category.icon];
}

@end
