//
//  MasterViewController.m
//  Puff
//
//  Created by bob.sun on 16/9/14.
//  Copyright © 2016年 bob.sun. All rights reserved.
//

#import "MasterViewController.h"

#import "PFBlowfish.h"
#import "NSObject+Events.h"

//#import <MMDrawerController/UIViewController+MMDrawerController.h>

#import "PFAccountManager.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    for (int i = 0; i < 1000; i++) {
//        [self _cryptoTest];
////        [self _encryptTest];
//    }
//    for (int i = 0; i < 10; i++) {
//        [self _coreDataWriteTest];
//    }
    [self _coreDataReadTest];
    
}

- (void)_cryptoTest {
    NSString *rawStr = @"oTNgWmpVF0WqPs8bGB/lop5b/fyI8tP3K2SIyj3V+7L8CAhrtfjnNxqV48VQYqKY";
    
    PFBlowfish *fish = [[PFBlowfish alloc]init];
    
    fish.Key = @"123456";
    fish.IV = @"";
    [fish prepare];
    NSString * result = [fish decrypt:rawStr withMode:modeEBC withPadding:paddingRFC];
    NSLog(@"%@", result);
}

- (void)_encryptTest {
    PFBlowfish *fish = [[PFBlowfish alloc] init];
    fish.Key = @"123456";
    fish.IV = @"";
    [fish prepare];
    NSString *result = [fish encrypt:@"ghgghvg7b0d7bf8-7ac5-4d58-95af-18892b7a712a" withMode:modeEBC withPadding:paddingRFC];
    NSLog(@"%@", result);
}

- (NSString*)_padString:(NSString*)input {
    NSUInteger paddedLength = input.length + (8 - (input.length % 8));
    return [input stringByPaddingToLength:paddedLength withString:@" " startingAtIndex:0];
}

- (void)_coreDataWriteTest {
    PFAccount *acct = [[PFAccount alloc] init];
    acct.name = @"aaaaa";
    acct.category = 1234567;
    PFAccountManager *manager = [PFAccountManager sharedManager];
    [manager saveAccount:acct];
}

- (void)_coreDataReadTest {
    PFAccountManager *manager = [PFAccountManager sharedManager];
    NSArray *accts = [manager fetchAccountsByCategory:1234567];
    return;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didClickOpenDrawerButton:(id)sender {
//    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark - Segues

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showDetail"]) {
////        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
////        Event *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
////        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
////        [controller setDetailItem:object];
////        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
////        controller.navigationItem.leftItemsSupplementBackButton = YES;
//    }
//}


#pragma mark - Fetched results controller
/**
 
- (NSFetchedResultsController<Event *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Event *> *fetchRequest = Event.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController<Event *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

 */

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
