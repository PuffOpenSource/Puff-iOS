//
//  PFSetMasterPasswordViewController.h
//  Puff
//
//  Created by bob.sun on 19/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger){
    showModeSet,
    showModeEdit,
}PFSetMasterShowMode;

@interface PFSetMasterPasswordViewController : UIViewController

@property(assign, nonatomic)PFSetMasterShowMode showMode;

+ (instancetype)viewControllerFromStoryBoard;

@end
