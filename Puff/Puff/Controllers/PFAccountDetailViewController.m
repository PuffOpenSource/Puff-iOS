//
//  PFAccountDetailViewController.m
//  Puff
//
//  Created by bob.sun on 03/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAccountDetailViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <MaterialControls/MDTextField.h>
#import <MaterialControls/MDButton.h>

#import "EXTScope.h"

#import "PFAddAccountViewController.h"
#import "PFAccountManager.h"
#import "PFResUtil.h"
#import "PFSpinner.h"

@interface PFAccountDetailViewController () <PFSpinnerDelegate, UIGestureRecognizerDelegate, PFEditAccountDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) PFAccount *account;
@property (strong, nonatomic) NSDictionary *info;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MDTextField *accountField;
@property (weak, nonatomic) IBOutlet MDTextField *passwordField;
@property (weak, nonatomic) IBOutlet MDTextField *additionalField;
@property (weak, nonatomic) IBOutlet MDTextField *websiteField;
@property (weak, nonatomic) IBOutlet UILabel *toolBarLabel;
@property (weak, nonatomic) IBOutlet UIView *passwordTouchArea;

@property (strong, nonatomic) UIMenuController *popMenu;
@property (strong, nonatomic) NSArray *popItems;
@property (strong, nonatomic) PFSpinner *menuSpinner;
@property (strong, nonatomic) NSArray *menus;
@property (strong, nonatomic) PFSpinnerCellConfigureBlock menuConfigBlock;

@end

@implementation PFAccountDetailViewController

+ (instancetype)viewControllerFromStoryboardWithAccount:(PFAccount*)account andInfo:(NSDictionary*)info {
    PFAccountDetailViewController *ret = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class] ] instantiateViewControllerWithIdentifier:@"PFAccountDetailViewController"];
    ret.account = account;
    ret.info = info;
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _accountField.text = [_info objectForKey:kResultAccount];
    _passwordField.text = [_info objectForKey:kResultPassword];
    _additionalField.text = [_info objectForKey:kResultAdditional];
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
    //Save to update timestamp.
    [[PFAccountManager sharedManager] saveAccount:_account];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapOnMoreButton:(id)sender {
    _menuSpinner.configureCallback = _menuConfigBlock;
    _menuSpinner.spinnerDelegate = self;
    [_menuSpinner presentInView:self.view];
}
- (IBAction)didTapOnPassword:(id)sender {
    UITapGestureRecognizer *tSender = sender;
    CGRect menuRect = tSender.view.frame;
    [_popMenu setTargetRect:CGRectMake(0, 0, menuRect.size.width, menuRect.size.height) inView:tSender.view];
    [_popMenu setMenuVisible:YES animated:YES];
}

#pragma mark - PFEditAccountDelegate
-(void)accountChanged:(PFAccount *)result andInfo:(NSDictionary*)info{
    self.account = result;
    self.info = info;
}

#pragma mark - PFSpinnerDelegate
- (void)pfSpinner:(PFSpinner *)spinner didSelectItem:(id)item {
    [_menuSpinner dismiss:nil];
    if ([item isEqualToString:NSLocalizedString(@"Edit", nil)]) {
        //Edit
        PFAddAccountViewController *vc = [PFAddAccountViewController viewControllerFromStoryboard:_account andInfo:_info];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        //Delete
        @weakify(self)
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            [[PFAccountManager sharedManager] deleteAccount:self.account];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Confirm", nil) message:NSLocalizedString(@"Delete this account?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
        [ac addAction:actionOk];
        [ac addAction:actionCancel];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
}

#pragma mark - Misc
- (void)initUI {
    _menus = @[NSLocalizedString(@"Edit", nil), NSLocalizedString(@"Delete", nil)];
    CGRect scrSize = [PFResUtil screenSize];
    CGRect frame = CGRectMake(scrSize.size.width - 160 - 8, 20 + 8, 160, 40);
    _menuSpinner = [[PFSpinner alloc] initAsMenuWithData:_menus andFrame:frame];
    _menuConfigBlock = ^(UITableViewCell* cell, NSIndexPath *indexPath, NSObject *dataItem) {
        PFSpinnerMenuCell *typedCell = cell;
        typedCell.menuLabel.text = dataItem;
    };
    if (!_popMenu) {
        _popMenu = [UIMenuController sharedMenuController];
    }
    _popItems = @[
                  [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Copy", nil) action:@selector(_didClickCopyMenu)]
                  ];
    _popMenu.menuItems = _popItems;
    [self becomeFirstResponder];
}

-(BOOL) canBecomeFirstResponder{
    return YES;
}

- (void)_didClickCopyMenu {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setValue:_passwordField.text forPasteboardType:(NSString*)kUTTypeText];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
