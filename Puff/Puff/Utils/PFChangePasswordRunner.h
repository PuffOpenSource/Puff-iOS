//
//  PFChangePasswordRunner.h
//  Puff
//
//  Created by bob.sun on 09/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PFChangePasswordCallback)();

@interface PFChangePasswordRunner : NSObject
- (void)runWithCompletion:(PFChangePasswordCallback)callback;
@end
