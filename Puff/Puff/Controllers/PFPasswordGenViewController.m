//
//  PFPasswordGenViewController.m
//  Puff
//
//  Created by bob.sun on 19/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFPasswordGenViewController.h"

#import <Foundation/NSNumberFormatter.h>
#import <MaterialControls/MDTextField.h>
#import <BFPaperCheckbox/BFPaperCheckbox.h>

#import "PFResUtil.h"
#import "PFPasswordGenerator.h"

typedef NS_ENUM(NSInteger){
    PTNumber = 80,
    PTSecure,
    PTSecure2,
} PasswordType;

@interface PFPasswordGenViewController () <UIScrollViewDelegate, BFPaperCheckboxDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewButtom;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray<NSLayoutConstraint*> *viewCenters;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *viewBottoms;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet MDTextField *lengthField;
@property (weak, nonatomic) IBOutlet BFPaperCheckbox *cbNumber;
@property (weak, nonatomic) IBOutlet BFPaperCheckbox *cbSecure;
@property (weak, nonatomic) IBOutlet BFPaperCheckbox *cbSecure2;
@property (strong, nonatomic) IBOutletCollection(BFPaperCheckbox) NSArray *checkBoxes;

@property (strong, nonatomic) IBOutletCollection(MDTextField) NSArray *tFields;

@property (assign, nonatomic) NSInteger length;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) PasswordType passwordType;
@property (assign, nonatomic) BOOL keyboardShown;

@end

@implementation PFPasswordGenViewController

+(instancetype)viewControllerFromStoryboard {
    PFPasswordGenViewController* ret;
    ret = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]] instantiateViewControllerWithIdentifier:@"PasswordGenViewController"];
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 0;
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = _currentPage;
    
    _lengthField.keyboardType = UIKeyboardTypeNumberPad;
    _lengthField.returnKeyType = UIReturnKeyDone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _cbSecure.delegate = self;
    _cbNumber.delegate = self;
    _cbSecure2.delegate = self;
    
    [_cbSecure checkAnimated:YES];
    
    for (MDTextField *tf in _tFields) {
        tf.hidden = YES;
    }
    _keyboardShown = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

#pragma mark - IBActions
- (IBAction)didTapOnClose:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapOnPrev:(id)sender {
    [self.view endEditing:YES];
    if (_currentPage == 0) {
        [PFResUtil shakeItBaby:sender withCompletion:nil];
        return;
    }
    _currentPage -= 1;
    _pageControl.currentPage = _currentPage;
    CGFloat width = _scrollview.frame.size.width;
    CGFloat height = _scrollview.frame.size.height;
    [_scrollview scrollRectToVisible:CGRectMake(width * _currentPage, 0, width, height) animated:YES];
    
}
- (IBAction)didTapOnNext:(id)sender {
    [self.view endEditing:YES];
    if (![self _validateCurrentInput]) {
        return;
    }
    if (_currentPage == 2) {
        //Generate password and close.
        NSString *result = [self _generatePassword];
        NSLog(@"Generated password %@", result);
        [PFResUtil shakeItBaby:sender withCompletion:nil];
        return;
    }
    _currentPage += 1;
    _pageControl.currentPage = _currentPage;
    CGFloat width = _scrollview.frame.size.width;
    CGFloat height = _scrollview.frame.size.height;
    [_scrollview scrollRectToVisible:CGRectMake(width * _currentPage, 0, width, height) animated:YES];
}
- (IBAction)didTapOnDone:(id)sender {
    
}

#pragma mark - Checkbox

- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox {
    if (!checkbox.isChecked) {
        return;
    }
    [self.view endEditing:YES];
    _passwordType = checkbox.tag;
    for (MDTextField *tf in _tFields) {
        tf.hidden = _passwordType != PTSecure2;
    }
    for (BFPaperCheckbox *cb in _checkBoxes) {
        if (cb != checkbox) {
            [cb uncheckAnimated:YES];
            cb.userInteractionEnabled = YES;
        }
    }
    checkbox.userInteractionEnabled = !checkbox.isChecked;
}

#pragma mark - Keyboard
- (void)_keyboardWillShow:(NSNotification*)notification {
    if (_keyboardShown) {
        return;
    }
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _viewCenters[_currentPage].constant -= kbSize.height;
    for (NSLayoutConstraint *constraint in _viewBottoms) {
        constraint.constant += kbSize.height;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    _keyboardShown = YES;
}
- (void)_keyboardWillHide:(NSNotification*)notification {
    if (!_keyboardShown) {
        return;
    }
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _viewCenters[_currentPage].constant += kbSize.height;
    for (NSLayoutConstraint *constraint in _viewBottoms) {
        constraint.constant -= kbSize.height;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    _keyboardShown = NO;
}

#pragma mark - Misc
- (BOOL)_validateCurrentInput {
    BOOL ret = YES;
    switch (_currentPage) {
        case 0: {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            _length = [[f numberFromString:_lengthField.text] integerValue];
            ret = _length >= 4;
            if (!ret) {
                [PFResUtil shakeItBaby:_lengthField withCompletion:nil];
            }
            break;
        }
        case 1:
            break;
        default:
            break;
    }
    return ret;
}

- (NSString*)_generatePassword {
    switch (_passwordType) {
        case PTNumber:
            return [PFPasswordGenerator genNumberWithLength:_length];
        case PTSecure:
            return [PFPasswordGenerator genPasswordWithLength:_length];
        case PTSecure2:{
            NSMutableArray *words = [@[] mutableCopy];
            for (MDTextField *mdTF in _tFields) {
                if (mdTF.text.length > 0) {
                    [words addObject:mdTF.text];
                }
            }
            return [PFPasswordGenerator genPasswordWithLength:_length andWords:words];
        }
        default:
            return @"";
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
