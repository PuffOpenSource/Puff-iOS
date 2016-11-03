//
//  PFAccountDetailViewController.m
//  Puff
//
//  Created by bob.sun on 03/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAccountDetailViewController.h"

#import <MaterialControls/MDTextField.h>
#import <MaterialControls/MDButton.h>

#import "PFAccount.h"
#import "PFResUtil.h"
#import "PFSpinner.h"

@interface PFAccountDetailViewController () <PFSpinnerDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) PFAccount *account;
@property (weak, nonatomic) IBOutlet MDTextField *accountField;
@property (weak, nonatomic) IBOutlet MDTextField *passwordField;
@property (weak, nonatomic) IBOutlet MDTextField *additionalField;
@property (weak, nonatomic) IBOutlet MDTextField *websiteField;
@property (weak, nonatomic) IBOutlet UILabel *toolBarLabel;

@property (strong, nonatomic) PFSpinner *menuSpinner;
@property (strong, nonatomic) NSArray *menus;
@property (strong, nonatomic) PFSpinnerCellConfigureBlock menuConfigBlock;

@end

@implementation PFAccountDetailViewController

+ (instancetype)viewControllerFromStoryboardWithAccount:(PFAccount*)account {
    PFAccountDetailViewController *ret = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class] ] instantiateViewControllerWithIdentifier:@"PFAccountDetailViewController"];
    ret.account = account;
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _accountField.text = _account.account;
    _passwordField.text = _account.hash_value;
    _additionalField.text = _account.additional;
    _websiteField.text = _account.website;
    _toolBarLabel.text = _account.name;
    _headerImageView.image = [PFResUtil imageForName:_account.icon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)didTapOnBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapOnMoreButton:(id)sender {
    _menuSpinner.configureCallback = _menuConfigBlock;
    _menuSpinner.spinnerDelegate = self;
    [_menuSpinner presentInView:self.view];
}

#pragma mark - PFSpinnerDelegate
- (void)pfSpinner:(PFSpinner *)spinner didSelectItem:(id)item {
    [_menuSpinner dismiss:nil];
}

#pragma mark - Misc
- (void)initUI {
    _menus = @[NSLocalizedString(@"Edit", nil)];
    CGRect scrSize = [PFResUtil screenSize];
    CGRect frame = CGRectMake(scrSize.size.width - 160 - 8, 20 + 8, 160, 40);
    _menuSpinner = [[PFSpinner alloc] initAsMenuWithData:_menus andFrame:frame];
    _menuConfigBlock = ^(UITableViewCell* cell, NSIndexPath *indexPath, NSObject *dataItem) {
        PFSpinnerMenuCell *typedCell = cell;
        typedCell.menuLabel.text = dataItem;
    };
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
