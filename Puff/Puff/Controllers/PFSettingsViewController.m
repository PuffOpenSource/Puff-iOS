//
//  PFSettingsViewController.m
//  Puff
//
//  Created by bob.sun on 19/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFSettingsViewController.h"

#import <BFPaperCheckbox/BFPaperCheckbox.h>

#import "PFSettings.h"
#import "PFSetMasterPasswordViewController.h"
#import "PFAppLock.h"

@interface PFSettingsViewController () <BFPaperCheckboxDelegate>
@property (weak, nonatomic) IBOutlet BFPaperCheckbox *cbTouchId;
@property (weak, nonatomic) IBOutlet BFPaperCheckbox *cbClear;

@property (assign, nonatomic) BOOL changed;
@end

@implementation PFSettingsViewController

+ (UINavigationController*)navigationControllerFromStoryboard {
    UINavigationController *ret;
    ret = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]] instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    _changed = NO;
}

- (void)initUI {
    
    PFSettings *settings = [PFSettings sharedInstance];
    if ([settings touchIDEnabled]) {
        [_cbTouchId checkAnimated:NO];
    } else {
        [_cbTouchId uncheckAnimated:NO];
    }
    if ([settings clearInfo]) {
        [_cbClear checkAnimated:NO];
    } else {
        [_cbClear uncheckAnimated:NO];
    }
    
    _cbTouchId.delegate = self;
    _cbClear.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)didClickOnBack:(id)sender {
    //Save
    PFSettings *settings = [PFSettings sharedInstance];
    [settings setClearInfo:_cbClear.isChecked];
    [settings setTouchIDEnabled:_cbTouchId.isChecked];
    [settings save];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapOnTouchId:(id)sender {
    _changed = YES;
    if (_cbTouchId.isChecked) {
        [_cbTouchId uncheckAnimated:YES];
    } else {
        [_cbTouchId checkAnimated:YES];
    }
}

- (IBAction)didTapOnClear:(id)sender {
    _changed = YES;
    if (_cbClear.isChecked) {
        [_cbClear uncheckAnimated:YES];
    } else {
        [_cbClear checkAnimated:YES];
    }
}

- (IBAction)didTapOnChangeMaster:(id)sender {
    [[PFAppLock sharedLock] verify:^(BOOL verified) {
        if (!verified) {
            return;
        }
        PFSetMasterPasswordViewController *vc = [PFSetMasterPasswordViewController viewControllerFromStoryBoard];
        vc.showMode = showModeEdit;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - Checkbox Delegate
- (void)paperCheckboxChangedState:(BFPaperCheckbox *)checkbox {
    _changed = YES;
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
