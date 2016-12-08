//
//  PFAuthorizeDialog.h
//  Puff
//
//  Created by bob.sun on 08/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef void (^PFAuthorizeCallBack)(BOOL verified);


@interface PFAuthorizeDialog : NSObject
+ (instancetype)sharedInstance;
- (void)authorize:(UIViewController*)sender callback:(PFAuthorizeCallBack) callback;
@end
