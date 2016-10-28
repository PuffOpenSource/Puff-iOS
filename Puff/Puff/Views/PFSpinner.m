//
//  PFSpinner.m
//  Puff
//
//  Created by bob.sun on 27/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFSpinner.h"

typedef NS_ENUM(NSUInteger) {
    ShowModeSpinner,
    ShowModeMenu,
} ShowMode;

@interface PFSpinner() <UITableViewDelegate, UITableViewDataSource>
@property (assign, nonatomic) ShowMode showMode;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation PFSpinner

static NSString * const kPFSpinnerMenuCellReuseId   = @"kPFSpinnerMenuCellReuseId";
static NSString * const kPFSpinnerCellReuseId       = @"kPFSpinnerCellReuseId";

- (instancetype)initAsMenuWithData:(NSArray *)data andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showMode = ShowModeMenu;
        [self _initUI];
        [_tableView registerClass:PFSpinnerMenuCell.class forCellReuseIdentifier:kPFSpinnerMenuCellReuseId];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _data = data;
    }
    return self;
}

- (instancetype)initAsSpinnerWithData:(NSArray *)data andFrame:(CGRect)frame {
    frame.size.height = 56 * data.count <= 200 ? : 200;
    if (frame.size.height != 0) {
        frame.size.height += 16;
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.showMode = ShowModeSpinner;
        [self _initUI];
        [_tableView registerClass:PFSpinnerCell.class forCellReuseIdentifier:kPFSpinnerCellReuseId];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _data = data;
    }
    return self;
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *ret;
    if (_showMode == ShowModeSpinner) {
        ret = [tableView dequeueReusableCellWithIdentifier:kPFSpinnerCellReuseId];
    } else {
        ret = [tableView dequeueReusableCellWithIdentifier:kPFSpinnerMenuCellReuseId];
    }
    if (_configureCallback) {
        _configureCallback(ret, indexPath, [_data objectAtIndex:indexPath.row]);
    }
    return ret;
}

#pragma mark - Misc

- (void) _initUI {
    
    CGRect tableViewFrame = self.bounds;
    tableViewFrame.size.width -= 16;
    tableViewFrame.size.height -= 16;
    tableViewFrame.origin.x += 8;
    tableViewFrame.origin.y += 8;
    _tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    
    _tableView.layer.shadowColor = [UIColor grayColor].CGColor;
    _tableView.layer.shadowOffset = CGSizeMake(5, 5);
    _tableView.layer.shadowOpacity = 0.8;
    _tableView.layer.masksToBounds = NO;
    
    [self addSubview:_tableView];
    self.clipsToBounds = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

@end

#pragma mark - Cells.

@implementation PFSpinnerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initUI];
    return self;
}

- (void)initUI {
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 40, 40)];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(64, 8, self.frame.size.width - 80, 40)];
    
    [self.contentView addSubview:_iconView];
    [self.contentView addSubview:_label];
}

@end

@implementation PFSpinnerMenuCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor greenColor];
    return self;
}
@end
