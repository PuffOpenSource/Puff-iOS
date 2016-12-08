//
//  PFAuthorizeDialog.m
//  Puff
//
//  Created by bob.sun on 08/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAuthorizeDialog.h"

#import "EXTScope.h"
#import "PFKeychainHelper.h"

@interface PFAuthorizeDialog() <UITextFieldDelegate>
@property (strong, nonatomic) UIAlertController *dialog;
@property (strong, nonatomic) NSString *enterdPwd;
@end

@implementation PFAuthorizeDialog

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static PFAuthorizeDialog *ret;
    dispatch_once(&onceToken, ^{
        ret = [[PFAuthorizeDialog alloc] init];
    });
    return ret;
}

- (void)authorize:(UIViewController*)sender callback:(PFAuthorizeCallBack)callback {
    [self _createDialog:callback];
    [sender presentViewController:_dialog animated:YES completion:nil];
}


- (void)_createDialog:(PFAuthorizeCallBack)callback {
    _dialog = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Authorize", nil) message:NSLocalizedString(@"Enter Master Password", nil) preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    [_dialog addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        @strongify(self)
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.delegate = self;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Okay", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        callback([self _authorize]);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self)
        [self.dialog dismissViewControllerAnimated:YES completion:^(void){
            callback(NO);
        }];
    }];
    
    [_dialog addAction:okAction];
    [_dialog addAction:cancelAction];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return NO;
}

- (void)textFieldDidChange:(UITextField*)sender {
    _enterdPwd = sender.text;
}

#pragma mark - Misc
- (BOOL)_authorize {
    return [[PFKeychainHelper sharedInstance] checkPassword:_enterdPwd];
}
@end
