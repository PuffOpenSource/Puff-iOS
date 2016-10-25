//
//  PFAddAccountViewController.m
//  Puff
//
//  Created by bob.sun on 19/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAddAccountViewController.h"

#import <MaterialControls/MDTextField.h>
#import <MaterialControls/MDButton.h>
#import "PFResUtil.h"
#import "PFAccountManager.h"

@interface PFAddAccountViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *toolBarLabel;
@property (weak, nonatomic) IBOutlet MDTextField *nameField;
@property (weak, nonatomic) IBOutlet MDButton *fab;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBottom;


@property (weak, nonatomic) IBOutlet MDTextField *accountField;
@property (weak, nonatomic) IBOutlet MDTextField *passwordField;
@property (weak, nonatomic) IBOutlet MDButton *btnGenerator;
@property (weak, nonatomic) IBOutlet MDTextField *additionalField;

@property (weak, nonatomic) IBOutlet MDTextField *websiteField;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet MDButton *bottomSaveBtn;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGSize scrollViewContentSize;

@end

@implementation PFAddAccountViewController 

static const CGFloat actionBarHeight = 64;
static const CGFloat toolBarHeight     = 180;

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]];
    return [sb instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameField.unifiedBackgroundColor = [PFResUtil pfGreen];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self _initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)didClickBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickFab:(id)sender {
    
    if (![self _validateFiels]) {
        return;
    }
    
    PFAccount *account = [[PFAccount alloc] init];
    account.name = _nameField.text;
    
    //Encryption!
    account.account = _accountField.text;
    
    id err = [[PFAccountManager sharedManager] saveAccount:account];
    if (err == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.dragging || scrollView != _scrollView) {
        _lastContentOffset = 0;
        return;
    }

    if (_lastContentOffset < scrollView.contentOffset.y) {
        //Down
        if (_headerHeight.constant < actionBarHeight) {
            _headerHeight.constant = actionBarHeight;
        } else {
            CGFloat size = _headerHeight.constant;
            size -= (scrollView.contentOffset.y - _lastContentOffset);
            if (size < actionBarHeight) {
                size = actionBarHeight;
            }
            _headerHeight.constant = size;
        }
    } else {
        //Up
        if (_headerHeight.constant > toolBarHeight) {
            _headerHeight.constant = toolBarHeight;
        } else {
            CGFloat size = _headerHeight.constant;
            size += _lastContentOffset - scrollView.contentOffset.y;
            if (size > toolBarHeight) {
                size = toolBarHeight;
            }
            _headerHeight.constant = size;
        }
    }
    _lastContentOffset = scrollView.contentOffset.y;
    if (_headerHeight.constant == actionBarHeight) {
        _toolBarLabel.text = _nameField.text.length == 0 ? NSLocalizedString(@"Add Account", nil) : _nameField.text;
    } else if (_headerHeight.constant == toolBarHeight) {
        _toolBarLabel.text = NSLocalizedString(@"Add Account", nil);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

#pragma mark - Misc
- (void)_initUI {
    _btnGenerator.backgroundColor = [UIColor lightGrayColor];
    _bottomSaveBtn.backgroundColor = [UIColor lightGrayColor];
}
- (void)_keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //Suppose to be 16 + kbSize.height, sub 16 margin.
    _layoutBottom.constant = kbSize.height;
    _lastContentOffset += kbSize.height;
    [self.scrollView setNeedsLayout];
    [UIView animateWithDuration:0.25 animations:^{
        [self.scrollView layoutIfNeeded];
    }];
}

- (void)_keyboardWillHide:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _layoutBottom.constant = 16;
    _lastContentOffset -= kbSize.height;
    [self.scrollView setNeedsLayout];
    [UIView animateWithDuration:0.25 animations:^{
        [self.scrollView layoutIfNeeded];
    }];
}

- (BOOL)_validateFiels {
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
