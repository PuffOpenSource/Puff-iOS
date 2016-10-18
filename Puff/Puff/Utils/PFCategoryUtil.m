//
//  PFCategoryUtil.m
//  Puff
//
//  Created by bob.sun on 17/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFCategoryUtil.h"

#include "Constants.h"

#import "PFCategoryManager.h"
#import "PFCategory.h"
#import "PFTypeManager.h"
#import "PFType.h"

@interface PFCategoryUtil ()
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *catNames;
@property (strong, nonatomic) NSArray *catIds;
@end

@implementation PFCategoryUtil

+ (instancetype)sharedInstance {
    static PFCategoryUtil *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PFCategoryUtil alloc] init];
        BOOL newInstall = [[NSUserDefaults standardUserDefaults] objectForKey:kPFNewInstall] == nil;
        if (newInstall) {
            //Save built in categories for new install only.
            [instance _initNames];
            [instance initBuiltInCategories];
            [instance initBuiltInTypes];
            [[NSUserDefaults standardUserDefaults] setBool:@(1) forKey:kPFNewInstall];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    });
    return instance;
}

- (void)initBuiltInCategories {
    PFCategoryManager *manager = [PFCategoryManager sharedManager];
    PFCategory *cat = nil;
    
    cat = [[PFCategory alloc] init];
    cat.name = @"Recent";
    cat.type = catTypeBuiltIn;
    cat.identifier = catIdRecent;
    cat.icon = [[NSBundle bundleForClass:self.class] pathForResource:[kCategoryFolder stringByAppendingString:@"/cat_recent.png"] ofType:nil];
    [manager saveCategory:cat];
    
    cat = [[PFCategory alloc] init];
    cat.name = @"Cards";
    cat.type = catTypeBuiltIn;
    cat.identifier = catIdCards;
    cat.icon = [[NSBundle bundleForClass:self.class] pathForResource:[kCategoryFolder stringByAppendingString:@"/cat_cards.png"] ofType:nil];
    [manager saveCategory:cat];
    
    cat = [[PFCategory alloc] init];
    cat.name = @"Computers";
    cat.type = catTypeBuiltIn;
    cat.identifier = catIdComputers;
    cat.icon = [[NSBundle bundleForClass:self.class] pathForResource:[kCategoryFolder stringByAppendingString:@"/cat_computer.png"] ofType:nil];
    [manager saveCategory:cat];
    
    cat = [[PFCategory alloc] init];
    cat.name = @"Devices";
    cat.type = catTypeBuiltIn;
    cat.identifier = catIdDevices;
    cat.icon = [[NSBundle bundleForClass:self.class] pathForResource:[kCategoryFolder stringByAppendingString:@"/cat_device.png"] ofType:nil];
    [manager saveCategory:cat];
    
    cat = [[PFCategory alloc] init];
    cat.name = @"Entry";
    cat.type = catTypeBuiltIn;
    cat.identifier = catIdEntry;
    cat.icon = [[NSBundle bundleForClass:self.class] pathForResource:[kCategoryFolder stringByAppendingString:@"/cat_entry.png"] ofType:nil];
    [manager saveCategory:cat];
    
    cat = [[PFCategory alloc] init];
    cat.name = @"Mail";
    cat.type = catTypeBuiltIn;
    cat.identifier = catIdMail;
    cat.icon = [[NSBundle bundleForClass:self.class] pathForResource:[kCategoryFolder stringByAppendingString:@"/cat_mail.png"] ofType:nil];
    [manager saveCategory:cat];
    
    cat = [[PFCategory alloc] init];
    cat.name = @"Social";
    cat.type = catTypeBuiltIn;
    cat.identifier = catIdSocial;
    cat.icon = [[NSBundle bundleForClass:self.class] pathForResource:[kCategoryFolder stringByAppendingString:@"/cat_social.png"] ofType:nil];
    [manager saveCategory:cat];
    
    cat = [[PFCategory alloc] init];
    cat.name = @"Website";
    cat.type = catTypeBuiltIn;
    cat.identifier = catIdWebsite;
    cat.icon = [[NSBundle bundleForClass:self.class] pathForResource:[kCategoryFolder stringByAppendingString:@"/cat_website.png"] ofType:nil];
    [manager saveCategory:cat];
    
    _categories = [manager fetchAll];
    
}

- (void)initBuiltInTypes {
    
    NSURL *typeFolderUrl = nil;
    
    for (int i = 0; i < self.catNames.count; i++) {
        typeFolderUrl = [NSURL fileURLWithPath: [[NSBundle bundleForClass:self.class]
                                                 pathForResource:[kAssetsFolder stringByAppendingString:self.catNames[i]]
                                                 ofType:nil]
                                   isDirectory: YES];
        
        [self _loopFolderAddType:typeFolderUrl andCategoryId:[self.catIds[i] longLongValue]];
    }

}

- (void)_loopFolderAddType:(NSURL*)typeFolderUrl andCategoryId:(uint64_t)catId {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    PFTypeManager *tm = [PFTypeManager sharedManager];
    PFType *toAdd = nil;
    
    NSDirectoryEnumerator *dEnum = [fm enumeratorAtURL:typeFolderUrl includingPropertiesForKeys:@[NSURLNameKey] options:0 errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
        return YES;
    }];
    
    for (NSURL *url in dEnum) {
        toAdd = [[PFType alloc] init];
        toAdd.name = [url.lastPathComponent stringByReplacingOccurrencesOfString:@".png" withString:@""];
        toAdd.category = catId;
        toAdd.icon = url.path;
        [tm saveType:toAdd];
    }
}

- (void) _initNames {
    self.catNames = @[@"/cat_cards", @"/cat_computers", @"/cat_device", @"/cat_entry", @"/cat_mail", @"/cat_social", @"/cat_website"];
    self.catIds = @[@(catIdCards), @(catIdComputers), @(catIdDevices), @(catIdEntry), @(catIdMail), @(catIdSocial), @(catIdWebsite)];
    
}

@end
