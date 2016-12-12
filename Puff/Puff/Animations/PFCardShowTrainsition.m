//
//  PFKeyElementsTransitionController.m
//  Puff
//
//  Created by bob.sun on 12/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFCardShowTrainsition.h"

#import "PFCardView.h"
#import "PFResUtil.h"

@implementation PFCardShowTrainsition

- (instancetype)init {
    self = [super init];
    self.originFrame = CGRectZero;
    self.keyEleOriginFrame = CGRectZero;
    self.keyEleDestFrame = [PFResUtil screenSize];
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    PFCardView *card = [[PFCardView alloc] initWithFrame:_originFrame];
    card.elevation = 10;
    card.cornerRadius = 5;
    card.backgroundColor = [UIColor whiteColor];
    //TODO: Transform key element frame.
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [PFResUtil screenSize].size.width, 200)];
    wrapper.backgroundColor = [PFResUtil pfGreen];
    wrapper.alpha = 0.8;
    wrapper.clipsToBounds = YES;
    UIImageView *shot = [[UIImageView alloc] initWithFrame:_keyEleOriginFrame];
    shot.contentMode = UIViewContentModeScaleAspectFill;
    [wrapper addSubview:shot];
    
    [card addSubview:wrapper];
    
    shot.image = self.keyElementShot;
    [containerView addSubview:toVC.view];
    [containerView addSubview:card];
    toVC.view.hidden = YES;
    CGRect half = CGRectMake(0, 0, toVC.view.frame.size.width, toVC.view.frame.size.height / 2.0);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewKeyframeAnimationOptionLayoutSubviews
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:2/3.0 animations:^{
                                      shot.frame = _keyEleDestFrame;
                                      card.frame = half;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations:^{
                                      card.frame = toVC.view.frame;
                                  }];
                              } completion:^(BOOL finished) {
                                  if (finished) {
                                      toVC.view.hidden = NO;
                                      [shot removeFromSuperview];
                                      [wrapper removeFromSuperview];
                                      [card removeFromSuperview];
                                      [transitionContext completeTransition:YES];
                                  }
                              }];
}

@end
