//
//  PFAddCategoryViewController.m
//  Puff
//
//  Created by bob.sun on 09/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFDialogViewController.h"

#import "PFCardView.h"
#import <Masonry/Masonry.h>

@interface PFDialogViewController () <PFDialogViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet PFCardView *container;

@property (strong, nonatomic) UIView *content;
@end


static CGFloat const    fullHeight          =       380;
static CGFloat const    fullWidth           =       280;
@implementation PFDialogViewController

+ (instancetype)viewControllerFromStoryboard {
    PFDialogViewController *ret;
    ret = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]] instantiateViewControllerWithIdentifier:@"PFDialogViewController"];
    return ret;
}

- (void)present:(UIView*)view inParent:(UIViewController*)vc {
    self.transitioningDelegate = vc.transitioningDelegate;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.content = view;
    [vc presentViewController:self animated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentHeight.constant = 50;
    _contentWidth.constant = 50;
    [self.container addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _contentWidth.constant = fullWidth;
    _contentHeight.constant = fullHeight;
    self.content.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            self.content.hidden = NO;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)didTapOnEmpty:(id)sender {
    self.content.hidden = YES;
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

#pragma mark - Keyboards

- (void)keyboardWillShow:(NSNotification*) notification {
    
}

- (void)keyboardWillHide:(NSNotification*) notification {
    
}

- (void)keyboardDidHide:(NSNotification*) notification {
    
}

#pragma mark - delegate
- (void)close {
    [self didTapOnEmpty:nil];
}

- (void)showViewController:(UIViewController *)vc {
    [self presentViewController:vc animated:YES completion:nil];
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
