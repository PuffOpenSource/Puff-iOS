//
//  PFCategoryUtil.h
//  Puff
//
//  Created by bob.sun on 17/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const       kAssetsFolder        =       @"cats";
static NSString * const       kCategoryFolder      =       @"cats/icon_category";

@interface PFCategoryUtil : NSObject
- (void)initBuiltInCategories;
+ (instancetype)sharedInstance;
@end
