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
#import "PFTypeManager.h"
#import "PFCategoryManager.h"
#import "PFSpinner.h"

@interface PFAddAccountViewController () <UIScrollViewDelegate, PFSpinnerDelegate>
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

@property (strong, nonatomic) PFSpinner *typeSpinner;
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) PFSpinnerCellConfigureBlock typeConfigureBlock;
@property (strong, nonatomic) PFSpinner *categorySpinner;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) PFSpinnerCellConfigureBlock categoryConfigureBlock;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGSize scrollViewContentSize;
@property (assign, nonatomic) BOOL keyboardShown;

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
    _keyboardShown = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _types = [[PFTypeManager sharedManager] fetchAll];
    _categories = [[PFCategoryManager sharedManager] fetchAll];
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
    account.hash_value = _passwordField.text;
    account.additional = _additionalField.text;
    
    //TODO: Show loading indicator.
    [account encrypt:^(NSError * _Nullable error, PFAccount * _Nullable result) {
        if (error) {
            //TODO: Shake it and dismiss indicator.
            return;
        }
        id err = [[PFAccountManager sharedManager] saveAccount:account];
        if (err == nil) {
            //TODO: Dismis indicator.
            [account decrypt:^(NSError * _Nullable error, PFAccount * _Nullable result) {
                if (error) {
                    return;
                }
            }];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)spinnerTest:(id)sender {
    [self _toggleTypeSpinner:sender];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!scrollView.isDragging) {
        _lastContentOffset = 0;
    }
    
    if (scrollView != _scrollView || _keyboardShown) {
        return;
    }
    
    [self _closeSpinners];

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
    
    _typeConfigureBlock = ^(UITableViewCell* cell, NSIndexPath* indexPath, NSObject* dataItem) {
        PFType* typedItem = dataItem;
        PFSpinnerCell *typedCell = cell;
        typedCell.label.text = typedItem.name;
        typedCell.iconView.image = [PFResUtil imageForName:typedItem.icon];
    };
    
    _categoryConfigureBlock = ^(UITableViewCell* cell, NSIndexPath* indexPath, NSObject* dataItem) {
        PFCategory *cat = dataItem;
        PFSpinnerCell *typedCell = cell;
        typedCell.label.text = cat.name;
        typedCell.iconView.image = [PFResUtil imageForName:cat.icon];
    };
    
    
}
- (void)_keyboardWillShow:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //Suppose to be 16 + kbSize.height, sub 16 margin.
    _layoutBottom.constant = kbSize.height;
    _lastContentOffset += kbSize.height;
    if (![_nameField isFirstResponder]) {
        _headerHeight.constant = actionBarHeight;
        _lastContentOffset -= (toolBarHeight - actionBarHeight);
    }
    [self.scrollView setNeedsLayout];
    [UIView animateWithDuration:0.5 animations:^{
        [_headerView layoutIfNeeded];
        [self.scrollView layoutIfNeeded];
    }];
    _keyboardShown = YES;
}

- (void)_keyboardWillHide:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _layoutBottom.constant = 16;
    _lastContentOffset -= kbSize.height;
    if (![_nameField isFirstResponder]) {
        _headerHeight.constant = toolBarHeight;
        _lastContentOffset += (toolBarHeight - actionBarHeight);
    }
    [self.scrollView setNeedsLayout];
    [UIView animateWithDuration:0.5 animations:^{
        [_headerView layoutIfNeeded];
        [self.scrollView layoutIfNeeded];
    }];
    _keyboardShown = NO;
}

- (BOOL)_validateFiels {
    return YES;
}


#pragma mark - Spinners

- (void)_toggleTypeSpinner:(id)sender {
    if (_typeSpinner) {
        [_typeSpinner dismiss:^{
            _typeSpinner = nil;
        }];
        return;
    }
    [self.view endEditing:YES];
    UIView *typedSender = sender;
    CGPoint pos = [typedSender convertPoint:typedSender.frame.origin toView:nil];
    CGRect spinnerRect = CGRectMake(pos.x,pos.y, typedSender.superview.frame.size.width - 32, 0);
    _typeSpinner = [[PFSpinner alloc] initAsSpinnerWithData:_types andFrame:spinnerRect];
    _typeSpinner.configureCallback = _typeConfigureBlock;
    _typeSpinner.spinnerDelegate = self;
    [_typeSpinner presentInView:self.view];
}

- (void)_toggleCategorySpinner:(id)sender {
    if (_categorySpinner) {
        [_categorySpinner dismiss:^{
            _categorySpinner = nil;
        }];
        return;
    }
    [self.view endEditing:YES];
    UIView *typedSender = sender;
    CGPoint pos = [typedSender convertPoint:typedSender.frame.origin toView:nil];
    CGRect spinnerRect = CGRectMake(pos.x,pos.y, typedSender.superview.frame.size.width - 32, 0);
    _categorySpinner = [[PFSpinner alloc] initAsSpinnerWithData:_categories andFrame:spinnerRect];
    _categorySpinner.configureCallback = _categoryConfigureBlock;
    _categorySpinner.spinnerDelegate = self;
    [_categorySpinner presentInView:self.view];
}

- (void)_closeSpinners {
    if (_typeSpinner) {
        [_typeSpinner dismiss:^{
            _typeSpinner = nil;
        }];
    }
    
    if (_categorySpinner) {
        [_categorySpinner dismiss:^{
            _categorySpinner = nil;
        }];
        return;
    }
}

#pragma mark - PFSpinnerDelegate
- (void)pfSpinner:(PFSpinner *)spinner didSelectItem:(id)item {
    [self _closeSpinners];
    if (spinner == _typeSpinner) {
        return;
    }
    if (spinner == _categorySpinner) {
        return;
    }
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
