//
//  PFSetMasterPasswordViewController.m
//  Puff
//
//  Created by bob.sun on 19/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFSetMasterPasswordViewController.h"

#import <MaterialControls/MDTextField.h>
#import <MaterialControls/MDButton.h>

#import "PFKeychainHelper.h"
#import "PFAppLock.h"
#import "PFResUtil.h"

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
    if ([self validateField]) {
        PFKeychainHelper *kcHelper = [PFKeychainHelper sharedInstance];
        [kcHelper setMasterPassword:_passwordField.text];
        [[PFAppLock sharedLock] unlock];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [PFResUtil shakeItBaby:_passwordField withCompletion:^{
        [_passwordField becomeFirstResponder];
    }];
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
        [self.view endEditing:YES];
    }
    return NO;
}

#pragma mark - Keyboard

- (void)_keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _headerHeight.constant = toolBarHeight;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)_keyboardWillHide:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
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
    if (str1.length == 0 || str2.length == 0) {
        return false;
    }
    return [str1 isEqualToString:str2];
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
