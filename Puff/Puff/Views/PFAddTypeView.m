//
//  PFAddType.m
//  Puff
//
//  Created by bob.sun on 21/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAddTypeView.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <MaterialControls/MDTextField.h>

#import "PFDialogViewController.h"
#import "PFResUtil.h"
#import "PFTypeManager.h"
#import "PFCategoryManager.h"
#import "PFAppLock.h"
#import "Constants.h"
#import "PFSpinner.h"

@interface PFAddTypeView() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MDTextFieldDelegate, PFSpinnerDelegate>
@property (weak, nonatomic) id<PFDialogViewDelegate> delegate;
@property (strong, nonatomic) NSString * icon;
@property (weak, nonatomic) IBOutlet MDTextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *categoryContainer;

@property (assign, nonatomic) uint64_t categoryId;
@property (strong, nonatomic) PFSpinner *categorySpinner;
@property (strong, nonatomic) NSArray *categories;
@end

@implementation PFAddTypeView

+ (instancetype)loadViewFromNib:(id)owner{
    PFAddTypeView *ret;
    ret = [[[NSBundle bundleForClass:self.class] loadNibNamed:@"PFAddTypeView" owner:owner options:nil] firstObject];
    return ret;
}

+ (void)presentInDialogViewController:(id) owner {
    PFDialogViewController *dialog = [PFDialogViewController viewControllerFromStoryboard];
    PFAddTypeView *me = [self loadViewFromNib:owner];
    me.delegate = (id<PFDialogViewDelegate>)dialog;
    me.categories = [[PFCategoryManager sharedManager] fetchAll];
    [dialog present:me inParent:owner];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameTextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.delegate = self;
}

- (BOOL)_validateFields {
    if (_nameTextField.text.length == 0) {
        [PFResUtil shakeItBaby:_nameTextField withCompletion:nil];
        return NO;
    }
    if (_categoryId == 0) {
        [PFResUtil shakeItBaby:_categoryContainer withCompletion:nil];
        return NO;
    }
    if (_icon == 0) {
        [PFResUtil shakeItBaby:_iconImageView withCompletion:nil];
        return NO;
    }
    return YES;
}

#pragma mark - IBActions

- (IBAction)didTapOnSave:(id)sender {
    
    if (![self _validateFields]) {
        return;
    }
    uint64_t typeId = [[PFTypeManager sharedManager] fetchAll].count;
    typeId += 1;
    while ([[PFTypeManager sharedManager] fetchTypeById:typeId] != nil) {
        //Find an available typeId.
        typeId += 1;
    }
    PFType *toAdd = [[PFType alloc] init];
    toAdd.name = _nameTextField.text;
    toAdd.icon = _icon;
    toAdd.category = _categoryId;
    toAdd.identifier = typeId;
    
    [[PFTypeManager sharedManager] saveType:toAdd];
    
    if (self.delegate) {
        [self.delegate close];
    }
}

- (IBAction)didTapOnImage:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    
    picker.delegate = self;
    [self endEditing:YES];
    
    //For the first time poping image chooser, should pause locking.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:kPFImageChooserPoped] == nil) {
        [[PFAppLock sharedLock] pauseLocking];
        [ud setBool:YES forKey:kPFImageChooserPoped];
        [ud synchronize];
    }
    [self.delegate showViewController:picker];
}
- (IBAction)didTapOnCategory:(id)sender {
    if (!_categorySpinner) {
        _categorySpinner = [[PFSpinner alloc] initAsSpinnerWithData:_categories andFrame:_categoryContainer.frame];
        _categorySpinner.spinnerDelegate = self;
        _categorySpinner.configureCallback = ^(UITableViewCell* cell, NSIndexPath* indexPath, NSObject* dataItem) {
            PFCategory *cat = dataItem;
            PFSpinnerCell *typedCell = cell;
            typedCell.spinnerLabel.text = cat.name;
            typedCell.iconView.image = [PFResUtil imageForName:cat.icon];
        };
    }
    [_categorySpinner presentInView:self];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    _icon = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

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

#pragma mark - MDTextFieldDelegate
- (BOOL)textFieldShouldReturn:(MDTextField *)textField {
    [self endEditing:YES];
    return NO;
}

#pragma mark - PFSpinnerDelegate
- (void)pfSpinner:(PFSpinner *)spinner didSelectItem:(id)item {
    [spinner dismiss:nil];
    _categoryId = ((PFCategory*)item).identifier;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
