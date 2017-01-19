//
//  PFDBExporter.m
//  Puff
//
//  Created by bob.sun on 12/01/2017.
//  Copyright © 2017 bob.sun. All rights reserved.
//

#import "PFDBExporter.h"

#import <FCModel/FCModel.h>

#import "FCAccount.h"
#import "PFAccountManager.h"

@implementation PFDBExporter

- (void)runWithCompletion:(PFDBExporterCallback)callback {
    [self _createDB];
    NSArray<PFAccount*> *accounts = [[PFAccountManager sharedManager] fetchAll];
    FCAccount *toAdd;
    for (PFAccount *acct in accounts) {
        toAdd = [[FCAccount alloc] init];
        [toAdd save:^{
            [toAdd populateWith:acct];
        }];
    }
    callback(nil, nil);
}

- (void)_createDB {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"PuffExport.db"];
    [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
    
    [FCModel openDatabaseAtPath:dbPath withDatabaseInitializer:^(FMDatabase *db) {
        [db beginTransaction];
        [db executeUpdate:
         @"CREATE TABLE 'ACCOUNT' ('_id' INTEGER PRIMARY KEY ,'name' TEXT NOT NULL ,'type' INTEGER NOT NULL ,'account' TEXT,'masked_account' TEXT,'hide_name' INTEGER NOT NULL,'account_salt' TEXT,'salt' TEXT NOT NULL ,'hash_value' TEXT NOT NULL ,'additional' TEXT,'additional_salt' TEXT,'category' INTEGER NOT NULL ,'tag' TEXT NOT NULL ,'website' TEXT,'last_access' INTEGER NOT NULL,'icon' TEXT);"
         ];
        [db commit];
    } schemaBuilder:^(FMDatabase *db, int *schemaVersion) {
        
    } moduleName:nil className:@"FCAccount"];
}
@end
