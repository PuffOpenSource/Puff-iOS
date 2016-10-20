//
//  PFDrawerViewController.m
//  Puff
//
//  Created by bob.sun on 18/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFDrawerViewController.h"

#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "PFDrawerCell.h"
#import "PFCategoryManager.h"

@interface PFDrawerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) NSArray * data;
@end

@implementation PFDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _iconImage.layer.cornerRadius = 50;
}

- (void)viewWillAppear:(BOOL)animated {
    self.data = [[PFCategoryManager sharedManager] fetchAll];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFDrawerCell *ret = [tableView dequeueReusableCellWithIdentifier:kReuseIdPFDrawerCell forIndexPath:indexPath];
    [ret configWithCategory:[_data objectAtIndex:indexPath.row]];
    return ret;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Jump to corresponding page & close drawer.
    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    PFCategory *cat = [self.data objectAtIndex:indexPath.row];
    if (cat && self.delegate) {
        [self.delegate loadAccountsInCategory:cat.identifier];
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
