//
//  TodayViewController.m
//  Today
//
//  Created by bob.sun on 18/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "TodayViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <NotificationCenter/NotificationCenter.h>

#include "Constants.h"

@interface TodayViewController () <NCWidgetProviding>
@property (strong, nonatomic) NSUserDefaults *store;
@property (strong, nonatomic) NSString * account;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _store = [[NSUserDefaults alloc] initWithSuiteName:kUserDefaultGroup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    _account = [_store objectForKey:kTodayAccount];
    completionHandler(NCUpdateResultNewData);
}
- (IBAction)didTapOnAccount:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setString:_account];
}

@end
