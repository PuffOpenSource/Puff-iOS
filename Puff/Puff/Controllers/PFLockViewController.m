//
//  PFLockViewController.m
//  Puff
//
//  Created by bob.sun on 25/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFLockViewController.h"

#import "PFResUtil.h"
#import "PFAppLock.h"

@interface PFLockViewController ()
@property (weak, nonatomic) IBOutlet UIView *lockView;
@property (weak, nonatomic) IBOutlet UITextField *lockPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *lockTouchIdIcon;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickedKeyboardAction:(id)sender {
    [_lockPasswordField resignFirstResponder];
}

- (void)showLockView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissLockView) name:UIKeyboardWillHideNotification object:nil];
    _lockView.bounds = [PFResUtil screenSize];
    _lockView.layer.cornerRadius = 0;
    _lockView.hidden = NO;
    for (UIView *view in _lockView.subviews) {
        view.hidden = NO;
    }
    [self.view layoutIfNeeded];
}

- (void)dismissLockView {
    if (![self _authorize]) {
        //TODO: Shake it baby.
        return;
    }
    
//    CGRect screenRect = [PFResUtil screenSize];
//    CGFloat fullSize = screenRect.size.height * 2;
//    _lockView.bounds = CGRectMake(0, 0, fullSize, fullSize);
//    
//    [_lockView.layer removeAllAnimations];
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.fromValue = [NSNumber numberWithFloat:fullSize / 2];
//    animation.toValue = [NSNumber numberWithFloat:0];
//    animation.duration = 0.5;
//    [_lockView.layer addAnimation:animation forKey:@"cornerRadius"];
//    
//    [_lockView.layer setCornerRadius:0];
    
    CGRect screenRect = [PFResUtil screenSize];
    CGFloat fullSize = screenRect.size.height * 2;
    _lockView.bounds = CGRectMake(0, 0, fullSize, fullSize);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:fullSize / 2];
    animation.toValue = [NSNumber numberWithFloat:0];
    animation.duration = 0.5;
    [_lockView.layer addAnimation:animation forKey:@"cornerRadius"];
    
    [_lockView.layer setCornerRadius:0];
    
    for (UIView *view in [_lockView subviews]) {
        view.hidden = YES;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _lockView.bounds = CGRectMake(screenRect.origin.x / 2, screenRect.origin.y / 2, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            _lockView.hidden = YES;
            for (UIView *view in [_lockView subviews]) {
                view.hidden = NO;
            }
            [self.view layoutIfNeeded];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
            [[PFAppLock sharedLock] unlockAndDismiss];
        }
    }];
}

- (BOOL)_authorize {
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
