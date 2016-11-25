//
//  ActionViewController.m
//  PuffExtension
//
//  Created by bob.sun on 18/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <LocalAuthentication/LocalAuthentication.h>


#import "PFAccountManager.h"

static NSString * const kPFExtActCellReuseId        =   @"kPFExtActCellReuseId";

@interface ActionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray<PFAccount*> *accounts;
@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _accounts = [[PFAccountManager sharedManager] fetchAll];
    
    NSLog(@"Fetched accounts count %lu", (unsigned long)_accounts.count);
    
    [self _authorizeWithTouchId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

#pragma mark UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFAccount *act = [_accounts objectAtIndex:indexPath.row];
    PFExtAccoutnCell *ret = [tableView dequeueReusableCellWithIdentifier:kPFExtActCellReuseId forIndexPath:indexPath];
    [ret configWithAccount:act];
    return ret;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _accounts.count;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)_authorizeWithTouchId {
    LAContext *ctx = [[LAContext alloc] init];
    if ([self _hasTouchID]) {
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"Unlock with Touch ID", nil) reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [self.tableView reloadData];
                }
                if (error) {
                    if (error.code == LAErrorUserFallback) {
                        
                    } else {
                        
                    }
                }
            });
        }];
    }
}

- (BOOL)_hasTouchID {
    LAContext *ctx = [[LAContext alloc] init];
    NSError *err;
    return [ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err];
}

@end

@interface PFExtAccoutnCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation PFExtAccoutnCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)configWithAccount:(PFAccount*)act {
    self.nameLabel.text = act.masked_account;
}

@end
