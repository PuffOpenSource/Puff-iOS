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
#import <MaterialControls/MDSnackbar.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>

#import "PFBlowfish.h"
#import "NSObject+Events.h"
#import "PFResUtil.h"
#include "Constants.h"
#import "MainAccountCell.h"
#import "PFAddAccountViewController.h"
#import "PFAccountDetailViewController.h"
#import "PFPasswordGenViewController.h"
#import "PFSettingsViewController.h"
#import "PFKeychainHelper.h"
#import "PFAccountManager.h"
#import "PFCategoryManager.h"
#import "PFAppLock.h"
#import "PFSpinner.h"
#import "PFCardShowTrainsition.h"

#import "PFDialogViewController.h"
#import "PFAddTypeView.h"
#import "PFAddCategoryView.h"

@interface MasterViewController () <PFDrawerViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, MainAccountCellDelegate, PFSpinnerDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) AppDelegate *app;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) IBOutlet MDButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *rippleView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UILabel *toolbarTitle;

@property (strong, nonatomic) PFSpinner* menuSpinner;
@property (strong, nonatomic) NSArray* menus;
@property (strong, nonatomic) PFSpinnerCellConfigureBlock menuConfigBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rippleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rippleWidth;


@property (strong, nonatomic) NSArray<PFAccount*> *data;

@property (weak, nonatomic) MainAccountCell *clickedCell;

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
    ret.delegate = self;
    return ret;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && ![[PFAppLock sharedLock] isLocked]) {
        return 210;
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
            [self presentViewController: [PFAddAccountViewController viewControllerFromStoryboard]animated:NO completion:^() {
                _rippleView.backgroundColor = [UIColor clearColor];
                _rippleView.frame = CGRectMake(_addButton.frame.origin.x, _addButton.frame.origin.y, 56, 56);
                [_rippleView.layer removeAnimationForKey:@"cornerRadius"];
            }];
        }
    }];
}

- (IBAction)didClickMenuButton:(id)sender {
    //Open drawer
    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)didClickMoreButton:(id)sender {
    //Pop menu
    _menuSpinner.configureCallback = _menuConfigBlock;
    _menuSpinner.spinnerDelegate = self;
    [_menuSpinner presentInView:self.view];
}

#pragma mark - PFDrawerViewControllerDelegate

- (void)loadAccountsInCategory:(uint64_t)catId {
    if (catId == catIdRecent) {
        [self _loadInitCategory];
        return;
    }
    
    _toolbarTitle.text = [[PFCategoryManager sharedManager] fetchCategoryById:catId].name;
    
    _data = [[PFAccountManager sharedManager] fetchAccountsByCategory:catId];
    if (_data.count == 0) {
        _emptyView.hidden = NO;
        _tableView.hidden = YES;
    } else {
        _emptyView.hidden = YES;
        _tableView.hidden = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - PFMainAccountDelegate
- (void)mainAccountCell:(MainAccountCell *)cell didTapOnViewButton:(PFAccount *)account {
    //TODO: Animation!
    [account decrypt:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        if (error) {
            //TODO: Snackbar
            return;
        }
        
        _clickedCell = cell;
        PFAccountDetailViewController *vc = [PFAccountDetailViewController viewControllerFromStoryboardWithAccount:account andInfo:result];
        vc.transitioningDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

- (void)mainAccountCell:(MainAccountCell *)cell didPinedAccount:(PFAccount *)account {
    MDSnackbar *snack = [[MDSnackbar alloc] initWithText:NSLocalizedString(@"Pinned to Today Widget.", nil) actionTitle:@""];
    [snack show];
}

#pragma mark - PFSpinnerDelegate
- (void)pfSpinner:(PFSpinner *)spinner didSelectItem:(id)item {
    [_menuSpinner dismiss:^(){
        NSUInteger idx = [_menus indexOfObject:item];
        UIViewController *vc;
        switch (idx) {
            case 0:
                vc = [PFPasswordGenViewController viewControllerFromStoryboard];
                break;
            case 1:
                [PFAddTypeView presentInDialogViewController:self];
                return;
            case 2:
                [PFAddCategoryView presentInDialogViewController:self];
                return;
            case 3:
                vc = [PFSettingsViewController navigationControllerFromStoryboard];
                break;
            default:
                vc = nil;
                break;
        }
        if (!vc) {
            return;
        }
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

#pragma mark - AnimationDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    PFCardShowTrainsition *ret = [[PFCardShowTrainsition alloc] init];
    NSIndexPath *path = [_tableView indexPathForCell:_clickedCell];
    CGRect scrSize = [PFResUtil screenSize];
    
    CGRect frame = _clickedCell.frame;
    frame = CGRectOffset(frame, _tableView.frame.origin.x - _tableView.contentOffset.x, _tableView.frame.origin.y - _tableView.contentOffset.y);
//    frame.size.width = 90 + 32;
//    frame.size.height = 90 + 40 + 16;
    
    ret.originFrame = frame;
    ret.keyEleDestFrame = CGRectMake(16, 16, scrSize.size.width - 32, 200 - 32);
    ret.keyElementShot = [PFResUtil imageForName:[_data objectAtIndex:path.row].icon];
    
    UIGraphicsBeginImageContext(frame.size);
    [_clickedCell.contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    ret.viewShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return nil;
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
    
    _tableView.hidden = NO;
    _emptyView.hidden = YES;
    
    //Spinner
    _menus = @[NSLocalizedString(@"Password Generator", nil), NSLocalizedString(@"New Type", nil), NSLocalizedString(@"New Category", nil), NSLocalizedString(@"Settings", nil),];
    CGRect scrSize = [PFResUtil screenSize];
    CGRect frame = CGRectMake(scrSize.size.width - 200, 20, 200, 40);
    _menuSpinner = [[PFSpinner alloc] initAsMenuWithData:_menus andFrame:frame];
    _menuConfigBlock = ^(UITableViewCell* cell, NSIndexPath *indexPath, NSObject *dataItem) {
        PFSpinnerMenuCell *typedCell = cell;
        typedCell.menuLabel.text = dataItem;
    };
}

- (void)_loadInitCategory {
    _data = [[PFAccountManager sharedManager] fetchRecentUsed:10];
    if (_data.count != 0) {
        _emptyView.hidden = YES;
        _tableView.hidden = NO;
        [self.tableView reloadData];
    } else {
        _emptyView.hidden = NO;
        _tableView.hidden = YES;
    }
    _toolbarTitle.text = NSLocalizedString(@"Recent", nil);
}

@end
