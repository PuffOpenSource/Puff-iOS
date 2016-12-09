//
//  PFAddCategoryViewController.m
//  Puff
//
//  Created by bob.sun on 09/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFDialogViewController.h"

#import "PFCardView.h"

@interface PFDialogViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet PFCardView *container;
@end


static CGFloat const    fullHeight          =       400;
static CGFloat const    fullWidth           =       280;
@implementation PFDialogViewController

+ (instancetype)viewControllerFromStoryboard {
    PFDialogViewController *ret;
    ret = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]] instantiateViewControllerWithIdentifier:@"PFAddCategoryViewController"];
    return ret;
}

- (void)presentIn:(UIViewController*)vc {
    self.transitioningDelegate = vc.transitioningDelegate;
    self.modalPresentationStyle = UIModalPresentationCustom;
    [vc presentViewController:self animated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentHeight.constant = 50;
    _contentWidth.constant = 50;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _contentWidth.constant = fullWidth;
    _contentHeight.constant = fullHeight;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)didTapOnEmpty:(id)sender {
    _contentHeight.constant = 50;
    _contentWidth.constant = 50;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
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
