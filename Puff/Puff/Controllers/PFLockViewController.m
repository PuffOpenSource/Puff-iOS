//
//  PFLockViewController.m
//  Puff
//
//  Created by bob.sun on 25/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFLockViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>

#import "PFResUtil.h"
#import "PFAppLock.h"
#import "PFKeychainHelper.h"
#import "PFSettings.h"

@interface PFLockViewController ()
@property (weak, nonatomic) IBOutlet UIView *lockView;
@property (weak, nonatomic) IBOutlet UITextField *lockPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *btnTouchId;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (assign, nonatomic) BOOL shouldValidate;
@end

@implementation PFLockViewController

+(instancetype)viewController {
    PFLockViewController *ret = [[PFLockViewController alloc] initWithNibName:@"PFLockViewController" bundle:[NSBundle bundleForClass:self.class]];
    ret.view.frame = [PFResUtil screenSize];
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Lock View
    _lockPasswordField.layer.cornerRadius = 20;
    _lockView.layer.needsDisplayOnBoundsChange = YES;
    _lockView.frame = self.view.frame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _btnTouchId.hidden = ![self _hasTouchID] || ![[PFSettings sharedInstance] touchIDEnabled];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)didClickedKeyboardAction:(id)sender {
    _shouldValidate = YES;
    [_lockPasswordField resignFirstResponder];
}
- (IBAction)didClickTouchId:(id)sender {
    _shouldValidate = NO;
    [_lockPasswordField resignFirstResponder];
    [self _authorizeWithTouchId];
}

#pragma mark - UI
- (void)showLockView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    _lockView.bounds = [PFResUtil screenSize];
    _lockView.layer.cornerRadius = 0;
    _lockView.hidden = NO;
    for (UIView *view in _lockView.subviews) {
        view.hidden = NO;
    }
    _lockPasswordField.text = @"";
    [self.view layoutIfNeeded];
}

- (void)dismissLockView {
    
    for (UIView *view in [_lockView subviews]) {
        view.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)_shakeItBaby {
    [PFResUtil shakeItBaby:_lockPasswordField withCompletion:^{
        [_lockPasswordField becomeFirstResponder];
    }];
}

#pragma mark - Misc
- (BOOL)_authorize {
    NSString *password = _lockPasswordField.text;
    if (password.length == 0) {
        return NO;
    }
    if (![[PFKeychainHelper sharedInstance] checkPassword:password]) {
        return NO;
    }
    return YES;
}

- (void)_authorizeWithTouchId {
    LAContext *ctx = [[LAContext alloc] init];
    if ([self _hasTouchID]) {
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"Unlock with Touch ID", nil) reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [[PFAppLock sharedLock] unlockAndDismiss];
                }
                if (error) {
                    if (error.code == LAErrorUserFallback) {
                        [_lockPasswordField becomeFirstResponder];
                    } else {
                        [PFResUtil shakeItBaby:_btnTouchId withCompletion:nil];
                    }
                }
            });
        }];
    }
}

- (BOOL)_hasTouchID {
    LAContext *ctx = [[LAContext alloc] init];
    NSError *err;
    return [ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err];
}

- (void)_keyboardDidHide {
    if (!_shouldValidate) {
        return;
    }
    if (![self _authorize]) {
        [self _shakeItBaby];
        return;
    }
    [[PFAppLock sharedLock] unlockAndDismiss];
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
