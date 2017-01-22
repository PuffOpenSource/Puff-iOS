//
//  PFSetMasterPasswordViewController.m
//  Puff
//
//  Created by bob.sun on 19/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFSetMasterPasswordViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import <MaterialControls/MDTextField.h>
#import <MaterialControls/MDButton.h>
#import <MaterialControls/MDSnackbar.h>

#import "PFKeychainHelper.h"
#import "PFAppLock.h"
#import "PFResUtil.h"
#import "PFPasswordChanger.h"
#import "PFLoadingView.h"
#import "PFSettings.h"

@interface PFSetMasterPasswordViewController () <MDTextFieldDelegate>
@property (weak, nonatomic) IBOutlet MDTextField *passwordField;
@property (weak, nonatomic) IBOutlet MDTextField *confirmField;
@property (weak, nonatomic) IBOutlet MDButton *backButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@end

@implementation PFSetMasterPasswordViewController

static CGFloat toolBarHeight        = 64.0;
static CGFloat headerHeight         = 160;

+ (instancetype)viewControllerFromStoryBoard {
    PFSetMasterPasswordViewController *ret;
    ret = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]] instantiateViewControllerWithIdentifier:@"SetMasterPasswordViewController"];
    ret.showMode = showModeSet;
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    if (self.showMode == showModeSet) {
        _backButton.hidden = YES;
    } else {
        _backButton.hidden = NO;
    }
    
    _passwordField.delegate = self;
    _confirmField.delegate = self;
    _passwordField.returnKeyType = UIReturnKeyNext;
    _confirmField.returnKeyType = UIReturnKeyDone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didClickFab:(id)sender {
    if (![self validateField]) {
        return;
    }
    [self.view endEditing:YES];
    if (self.showMode == showModeSet) {
        [self _askTouchId];
    } else  {
        PFKeychainHelper *kcHelper = [PFKeychainHelper sharedInstance];
        
        [PFLoadingView showIn:self];
        [PFPasswordChanger changePwdTo:_passwordField.text];
        [PFLoadingView dismiss];
        
        [kcHelper updateMasterPassword:_passwordField.text];
        [[PFAppLock sharedLock] unlock];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return;
}

- (IBAction)didTapOnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - MDTextFieldDelegate
- (BOOL)textFieldShouldReturn:(MDTextField *)textField {
    if (_passwordField.isFirstResponder) {
        [_confirmField becomeFirstResponder];
    } else {
        [_confirmField resignFirstResponder];
        [self.view endEditing:YES];
    }
    return NO;
}

#pragma mark - Keyboard

- (void)_keyboardWillShow:(NSNotification*)notification {
    _headerHeight.constant = toolBarHeight;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)_keyboardWillHide:(NSNotification*)notification {
    _headerHeight.constant = headerHeight;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - Misc
- (BOOL)validateField {
    //TODO: Security Validate.
    NSString *str1, *str2;
    str1 = _passwordField.text;
    str2 = _confirmField.text;
    if (str1.length == 0) {
        [self _showError:NSLocalizedString(@"Password is empty!", nil) view:_passwordField];
        return NO;
    }
    BOOL ret = [str1 isEqualToString:str2];
    if (!ret) {
        [self _showError:NSLocalizedString(@"Password don't match!", nil) view:_confirmField];
    } else {
        ret = str1.length >= 6;
        if (!ret) {
            [self _showError:NSLocalizedString(@"Password is too short!", nil) view:_passwordField];
        }
    }
    return ret;
}

- (void)_showError:(NSString*)err view:(UIView*)view {
    [self.view endEditing:YES];
    [[[MDSnackbar alloc] initWithText:err actionTitle:@"" duration:1.5] show];
    [PFResUtil shakeItBaby:view withCompletion:nil];
}

- (void)_askTouchId {
    if (![self _hasTouchID]) {
        [self _savePassword];
        return;
    }
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[PFSettings sharedInstance] setTouchIDEnabled:YES];
        [self _savePassword];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[PFSettings sharedInstance] setTouchIDEnabled:NO];
        [self _savePassword];
    }];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Enable Touch ID ?" message:@"You can change this in settings." preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:yes];
    [ac addAction:no];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)_savePassword {
    PFKeychainHelper *kcHelper = [PFKeychainHelper sharedInstance];
    [kcHelper setMasterPassword:_passwordField.text];
    [[PFAppLock sharedLock] unlock];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)_hasTouchID {
    LAContext *ctx = [[LAContext alloc] init];
    NSError *err;
    return [ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err];
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
