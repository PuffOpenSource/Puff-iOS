//
//  ActionViewController.m
//  PuffExtension
//
//  Created by bob.sun on 18/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <LocalAuthentication/LocalAuthentication.h>


#import "PFAccountManager.h"
#import "PFAuthorizeDialog.h"
#import "PFSettings.h"
#import "PFResUtil.h"
#import "PFAccountAccess.h"
#import "PFLoadingView.h"


static NSString * const kPFExtActCellReuseId        =   @"kPFExtActCellReuseId";

@interface ActionViewController () <UITableViewDelegate, UITableViewDataSource, PFExtAccountCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *lockView;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;

@property(strong, nonatomic) NSArray<PFAccount*> *accounts;
@property (assign, nonatomic) BOOL unlocked;
@property (weak, nonatomic) IBOutlet UIView *snackBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *snackbarHeight;

@property (weak, nonatomic) IBOutlet UILabel *snackBarTitle;
@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _accounts = [[PFAccountManager sharedManager] fetchAll];
    if (_accounts.count == 0) {
        _emptyView.hidden = NO;
    } else {
        _emptyView.hidden = YES;
    }
    _unlocked = NO;
    if ([[PFSettings sharedInstance] touchIDEnabled]) {
        [self _authorizeWithTouchId];
    } else {
        [self _authorizeWithPassword];
    }
    _snackbarHeight.constant = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

#pragma mark UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFAccount *act = [_accounts objectAtIndex:indexPath.row];
    PFExtAccountCell *ret = [tableView dequeueReusableCellWithIdentifier:kPFExtActCellReuseId forIndexPath:indexPath];
    [ret configWithAccount:act andIndex:indexPath.row];
    ret.delegate = self;
    return ret;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _unlocked ? _accounts.count : 0;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //Default action is copy password. Click pin button to pin
    PFAccount *selected = [_accounts objectAtIndex:indexPath.row];
    [PFLoadingView showIn:self];
    [selected decrypt:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        [PFLoadingView dismiss];
        [PFAccountAccess copyToClipBoard:result];
        [self showSnackbarWithTitle:@"Copied!" autoClose:YES];
    }];
}

#pragma mark - IBActions
- (IBAction)didTapOnLock:(id)sender {
    if ([[PFSettings sharedInstance] touchIDEnabled]) {
        [self _authorizeWithTouchId];
    } else {
        [self _authorizeWithPassword];
    }
}

#pragma mark - Authorize
- (void)_authorizeWithTouchId {
    LAContext *ctx = [[LAContext alloc] init];
    if ([self _hasTouchID]) {
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"Unlock with Touch ID", nil) reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    _unlocked = YES;
                    self.lockView.hidden = YES;
                    [self.tableView reloadData];
                }
                if (error) {
                    self.lockView.hidden = NO;
                    [self _authorizeWithPassword];
                }
            });
        }];
    }
}

- (void)_authorizeWithPassword {
    [[PFAuthorizeDialog sharedInstance] authorize:self callback:^(BOOL verified) {
        _unlocked = verified;
        self.lockView.hidden = _unlocked;
        if (_unlocked) {
            [self.tableView reloadData];
        } else {
            [PFResUtil shakeItBaby:_unlockButton withCompletion:nil];
        }
    }];
}

- (BOOL)_hasTouchID {
    LAContext *ctx = [[LAContext alloc] init];
    NSError *err;
    return [ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err];
}

#pragma mark - CellDelegate
- (void)didClickOnPin:(NSInteger)idx {
    PFAccount *act = [_accounts objectAtIndex:idx];
    [PFLoadingView showIn:self];
    [act decrypt:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        [PFLoadingView dismiss];
        [PFAccountAccess pinToday:result withIcon:act.icon];
        [self showSnackbarWithTitle:@"Pinned!" autoClose:YES];
    }];
}

- (void)didClickOnCopy:(NSInteger)idx {
    PFAccount *act = [_accounts objectAtIndex:idx];
    [PFLoadingView showIn:self];
    [act decrypt:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        [PFLoadingView dismiss];
        [PFAccountAccess copyToClipBoard:result];
        [self showSnackbarWithTitle:@"Copied!" autoClose:YES];
    }];
}

#pragma mark - Snackbar

- (void)showSnackbarWithTitle:(NSString*)title autoClose:(BOOL)autoClose {
    _snackbarHeight.constant = 50;
    _snackBarTitle.text = title;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    if (autoClose) {
        [self performSelector:@selector(hideSnackbar) withObject:nil afterDelay:1.5];
    }
}

- (void)hideSnackbar {
    _snackbarHeight.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}



@end

@interface PFExtAccountCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIButton *btnPin;
@property (weak, nonatomic) IBOutlet UIButton *btnCopy;

@property (assign, nonatomic) NSInteger index;
@end

@implementation PFExtAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configWithAccount:(PFAccount*)act andIndex:(NSInteger)index {
    self.icon.image = [PFResUtil imageForName:act.icon];
    self.nameLabel.text = act.masked_account;
    self.index = index;
}
- (IBAction)didTapOnPin:(id)sender {
    if (self.delegate) {
        [self.delegate didClickOnPin:_index];
    }
}
- (IBAction)didTapOnCopy:(id)sender {
    if (self.delegate) {
        [self.delegate didClickOnCopy:_index];
    }
}

@end
