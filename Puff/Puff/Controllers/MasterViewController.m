//
//  MasterViewController.m
//  Puff
//
//  Created by bob.sun on 16/9/14.
//  Copyright © 2016年 bob.sun. All rights reserved.
//

#import "MasterViewController.h"

#import "PFDrawerViewController.h"
#import "AppDelegate.h"

#import <MaterialControls/MDButton.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>

#import "PFBlowfish.h"
#import "NSObject+Events.h"
#import "PFResUtil.h"
#include "Constants.h"
#import "MainAccountCell.h"
#import "PFAddAccountViewController.h"
#import "PFAccountManager.h"
#import "PFAppLock.h"

@interface MasterViewController () <PFDrawerViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) AppDelegate *app;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) IBOutlet MDButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *rippleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rippleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rippleWidth;


@property (strong, nonatomic) NSArray<PFAccount*> *data;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self _loadInitCategory];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && ![[PFAppLock sharedLock] isLocked]) {
        return _data.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainAccountCell *ret = [tableView dequeueReusableCellWithIdentifier:kMainAccountCellReuseId];
    [ret configWithAccount:_data[indexPath.row]];
    return ret;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && ![[PFAppLock sharedLock] isLocked]) {
        return 260;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - IBActions
- (IBAction)didClickAddButton:(id)sender {
    _rippleView.backgroundColor = _addButton.backgroundColor;
    
    CGFloat fullSize = [PFResUtil screenSize].size.height * 2;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:28];
    animation.toValue = [NSNumber numberWithFloat:fullSize / 2];
    animation.duration = 0.4;
    [_rippleView.layer addAnimation:animation forKey:@"cornerRadius"];
    
    [_rippleView.layer setCornerRadius:fullSize / 2];
    
    [UIView animateWithDuration:0.4 animations:^{
        _rippleView.bounds = CGRectMake(0, 0, fullSize, fullSize);
    } completion:^(BOOL finished) {
        if (finished) {
            _rippleView.backgroundColor = [UIColor clearColor];
            _rippleView.frame = CGRectMake(_addButton.frame.origin.x, _addButton.frame.origin.y, 56, 56);
            [_rippleView.layer removeAnimationForKey:@"cornerRadius"];
            
            //TODO (Bob): Jump to new view controller here.
            
            [self presentViewController: [PFAddAccountViewController viewControllerFromStoryboard]animated:NO completion:nil];
        }
    }];
}

- (IBAction)didClickMenuButton:(id)sender {
    //Open drawer
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)didClickMoreButton:(id)sender {
    //Pop menu
}

#pragma mark - PFDrawerViewControllerDelegate

- (void)loadAccountsInCategory:(uint64_t)catId {
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
    }
}

#pragma mark - Misc

- (void)_initUI {
    
    //RippleView
    _rippleView.layer.cornerRadius = 28;
    
    //Toolbar
    CALayer *layer = _toolbar.layer;
    layer.shadowOffset = CGSizeMake(0, 2);
    layer.shadowColor = [[UIColor grayColor] CGColor];
    layer.shadowRadius = 1.0;
    layer.shadowOpacity = 1.0;
    
    //TableView
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"MainAccountCell" bundle:[NSBundle bundleForClass:self.class]] forCellReuseIdentifier:kMainAccountCellReuseId];
}

- (void)_loadInitCategory {
    _data = [[PFAccountManager sharedManager] fetchRecentUsed:10];
    if (_data.count != 0) {
        [self.tableView reloadData];
    } else {
        //TODO: Show empty view
    }
}

@end
