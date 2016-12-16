//
//  PFKeyElementsTransitionController.h
//  Puff
//
//  Created by bob.sun on 12/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface PFCardShowTrainsition : NSObject <UIViewControllerAnimatedTransitioning>
@property (assign, nonatomic) CGRect originFrame;
@property (assign, nonatomic) CGRect keyEleDestFrame;

@property (strong, nonatomic) UIImage *keyElementShot;
@end
