//
//  PFCategory.h
//  Puff
//
//  Created by bob.sun on 16/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFBaseModel.h"

@interface PFCategory : PFBaseModel
@property (nullable, nonatomic, strong) NSString *icon;
@property (nonatomic, assign) int64_t identifier;
@property (nullable, nonatomic, strong) NSString *name;
@property (nonatomic, assign) int64_t type;
@end
