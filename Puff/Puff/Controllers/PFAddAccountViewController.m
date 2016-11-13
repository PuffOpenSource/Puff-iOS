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
#import <MaterialControls/MDSnackBar.h>

#import <MobileCoreServices/MobileCoreServices.h>

#import "PFResUtil.h"
#import "PFAccountManager.h"
#import "PFTypeManager.h"
#import "PFCategoryManager.h"
#import "PFSpinner.h"

#define ADD_ACCOUNT_STR NSLocalizedString(@"Add Account", nil)
#define EDIT_ACCOUNT_STR NSLocalizedString(@"Edit Account", nil)

@interface PFAddAccountViewController () <UIScrollViewDelegate, PFSpinnerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MDTextFieldDelegate>
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

//Collection
@property (strong, nonatomic) IBOutletCollection(MDTextField) NSArray *textFields;

//Spinners
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;


@property (strong, nonatomic) PFSpinner *typeSpinner;
@property (strong, nonatomic) NSArray *types;
@property (strong, nonatomic) PFSpinnerCellConfigureBlock typeConfigureBlock;
@property (strong, nonatomic) PFSpinner *categorySpinner;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) PFSpinnerCellConfigureBlock categoryConfigureBlock;
@property (strong, nonatomic) NSString *toolBarTitle;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGSize scrollViewContentSize;
@property (assign, nonatomic) BOOL keyboardShown;

//Data
@property (strong, nonatomic) PFType *accountType;
@property (strong, nonatomic) PFCategory *category;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) PFAccount* account;
@end

@implementation PFAddAccountViewController 

static const CGFloat actionBarHeight = 64;
static const CGFloat toolBarHeight   = 180;

+ (instancetype)viewControllerFromStoryboard {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]];
    return [sb instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
}

+ (instancetype)viewControllerFromStoryboard:(PFAccount *)account {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]];
    PFAddAccountViewController *ret = [sb instantiateViewControllerWithIdentifier:@"AddAccountViewController"];
    ret.account = account;
    return ret;
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
    if (_account) {
        _nameField.text = _account.name;
        _accountField.text = _account.account;
        _passwordField.text = _account.hash_value;
        _additionalField.text = _account.additional;
        _websiteField.text = _account.website;
        self.accountType = [[PFTypeManager sharedManager] fetchTypeById:_account.type];
        self.category = [[PFCategoryManager sharedManager] fetchCategoryById:_account.category];
        _toolBarTitle = EDIT_ACCOUNT_STR;
    } else {
        _toolBarTitle = ADD_ACCOUNT_STR;
    }
    _toolBarLabel.text = _toolBarTitle;
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
    
    [self.view endEditing:YES];
    
    if (![self _validateFiels]) {
        return;
    }
    
    PFAccount *account = [[PFAccount alloc] init];
    account.name = _nameField.text;
    
    //Encryption!
    account.account = _accountField.text;
    account.masked_account = _accountField.text;
    account.hash_value = _passwordField.text;
    account.additional = _additionalField.text;
    account.category = _category.identifier;
    account.type = _accountType.identifier;
    if (_icon.length == 0) {
        _icon = _accountType.icon;
    }
    account.icon = _icon;
    
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

- (IBAction)didClickTypeSpinner:(id)sender {
    [self _toggleTypeSpinner:sender];
}

- (IBAction)didClickCategorySpinner:(id)sender {
    [self _toggleCategorySpinner:sender];
}

- (IBAction)presentImagePicker:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    
    picker.delegate = self;
    [self.view endEditing:YES];
    [self presentViewController:picker animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(MDTextField *)textField {
    NSInteger index = [_textFields indexOfObject:textField];
    [textField resignFirstResponder];
    if (index < _textFields.count - 1) {
        [[_textFields objectAtIndex:index + 1] becomeFirstResponder];
    }
    return NO;
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
        _toolBarLabel.text = _nameField.text.length == 0 ? _toolBarTitle : _nameField.text;
    } else if (_headerHeight.constant == toolBarHeight) {
        _toolBarLabel.text = _toolBarTitle;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

#pragma mark - Misc
- (void)_initUI {
    _btnGenerator.backgroundColor = [UIColor lightGrayColor];
    _bottomSaveBtn.backgroundColor = [UIColor lightGrayColor];
    _nameField.returnKeyType = UIReturnKeyNext;
    
    _typeConfigureBlock = ^(UITableViewCell* cell, NSIndexPath* indexPath, NSObject* dataItem) {
        PFType* typedItem = dataItem;
        PFSpinnerCell *typedCell = cell;
        typedCell.spinnerLabel.text = typedItem.name;
        typedCell.iconView.image = [PFResUtil imageForName:typedItem.icon];
    };
    
    _categoryConfigureBlock = ^(UITableViewCell* cell, NSIndexPath* indexPath, NSObject* dataItem) {
        PFCategory *cat = dataItem;
        PFSpinnerCell *typedCell = cell;
        typedCell.spinnerLabel.text = cat.name;
        typedCell.iconView.image = [PFResUtil imageForName:cat.icon];
    };
    
    for (MDTextField *t in _textFields) {
        t.returnKeyType = UIReturnKeyNext;
        t.delegate = self;
    }
    ((MDTextField*)[_textFields lastObject]).returnKeyType = UIReturnKeyDone;
}
- (void)_keyboardWillShow:(NSNotification*)notification {
    [self _closeSpinners];
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
    if (_nameField.text.length == 0) {
        [_nameField setHasError:YES];
        [PFResUtil shakeItBaby:_nameField withCompletion:nil];
        return NO;
    }
    if (_passwordField.text.length == 0) {
        [_passwordField setHasError:YES];
        [PFResUtil shakeItBaby:_passwordField withCompletion:nil];
        return NO;
    }
    if (_category == nil || _accountType == nil) {
        [self.view endEditing:YES];
        MDSnackbar *snackBar = [[MDSnackbar alloc] initWithText:NSLocalizedString(@"Please choose category and type.", nil) actionTitle:nil duration:3.0];
        [snackBar show];
        return NO;
    }
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
    if (_categorySpinner) {
        [_categorySpinner dismiss:^{
            _categorySpinner = nil;
        }];
    }
    [self.view endEditing:YES];
    UIView *typedSender = sender;
    CGPoint pos = [typedSender convertPoint:typedSender.frame.origin toView:nil];
    CGRect spinnerRect = CGRectMake(32 ,pos.y, typedSender.superview.frame.size.width - 32, 0);
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
    if (_typeSpinner) {
        [_typeSpinner dismiss:^{
            _typeSpinner = nil;
        }];
    }
    [self.view endEditing:YES];
    UIView *typedSender = sender;
    CGPoint pos = [typedSender convertPoint:typedSender.frame.origin toView:nil];
    CGRect spinnerRect = CGRectMake(32 ,pos.y, typedSender.superview.frame.size.width - 32, 0);
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
    if (spinner == _typeSpinner) {
        self.accountType = item;
    }
    if (spinner == _categorySpinner) {
        self.category = item;
    }
    [self _closeSpinners];
}

#pragma mark - UIImagePickerViewControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *originalImage, *editedImage, *imageToUse;
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if ((CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
         == kCFCompareEqualTo)) {
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
    }
    if (imageToUse) {
        _icon = [PFResUtil saveImage:imageToUse];
        _iconImageView.image = imageToUse;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    _icon = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getters & Setters

- (void)setAccountType:(PFType *)type {
    _typeImage.image = [PFResUtil imageForName:type.icon];
    [_typeButton setTitle:type.name forState:UIControlStateNormal];
    _accountType = type;
    
    PFCategory *cat = [[PFCategoryManager sharedManager] fetchCategoryById:type.category];
    self.category = cat;
    
    _icon = type.icon;
    _iconImageView.image = [PFResUtil imageForName:type.icon];
}

- (void)setCategory:(PFCategory *)category {
    _categoryImage.image = [PFResUtil imageForName:category.icon];
    
    [_categoryButton setTitle:category.name forState:UIControlStateNormal];
    
    _category = category;
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
