//
//  PFAddCategoryView.m
//  Puff
//
//  Created by bob.sun on 22/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAddCategoryView.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <MaterialControls/MDTextField.h>

#import "PFDialogViewController.h"
#import "PFResUtil.h"
#import "PFTypeManager.h"
#import "PFCategoryManager.h"
#import "PFAppLock.h"
#import "Constants.h"
#import "PFSpinner.h"
#import "NSObject+Events.h"

@interface PFAddCategoryView() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MDTextFieldDelegate>
@property (weak, nonatomic) id<PFDialogViewDelegate> delegate;
@property (strong, nonatomic) NSString * icon;
@property (weak, nonatomic) IBOutlet MDTextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation PFAddCategoryView

+ (instancetype)loadViewFromNib:(id)owner{
    PFAddCategoryView *ret;
    ret = [[[NSBundle bundleForClass:self.class] loadNibNamed:@"PFAddCategoryView" owner:owner options:nil] firstObject];
    return ret;
}

+ (void)presentInDialogViewController:(id) owner {
    PFDialogViewController *dialog = [PFDialogViewController viewControllerFromStoryboard];
    PFAddCategoryView *me = [self loadViewFromNib:owner];
    me.delegate = (id<PFDialogViewDelegate>)dialog;
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
    
    uint64_t categoryId = [[PFCategoryManager sharedManager] fetchAll].count;
    categoryId += 1;
    while ([[PFCategoryManager sharedManager] fetchCategoryById:categoryId] != nil) {
        //Find an available typeId.
        categoryId += 1;
    }

    PFCategory *toAdd = [[PFCategory alloc] init];
    toAdd.name = _nameTextField.text;
    toAdd.icon = _icon;
    toAdd.type = catTypeCustom;
    toAdd.identifier = categoryId;
    
    [[PFCategoryManager sharedManager] saveCategory:toAdd];
    
    [self publish:kUserCategoryChanged];
    
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
@end
