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
    self.keyEleDestFrame = [PFResUtil screenSize];
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
//    return 4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    PFCardView *card = [[PFCardView alloc] initWithFrame:_originFrame];
    card.elevation = 10;
    card.cornerRadius = 5;
    card.backgroundColor = [UIColor whiteColor];
    //Transform key element frame.
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectInset(card.bounds, 16, 16)];
    wrapper.backgroundColor = [UIColor colorWithRed:0.87 green:0.91 blue:0.83 alpha:0.8];
    wrapper.alpha = 1;
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:wrapper.bounds];
    background.image = self.viewShot;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.clipsToBounds = YES;
    [wrapper addSubview:background];
    
    UIImageView *shot = [[UIImageView alloc] initWithFrame:CGRectMake(16, 40, 90, 90)];
    shot.contentMode = UIViewContentModeScaleAspectFill;
    shot.alpha = 1;
    shot.clipsToBounds = YES;
    [wrapper addSubview:shot];
    
    [card addSubview:wrapper];
    
    shot.image = self.keyElementShot;
    [containerView addSubview:toVC.view];
    [containerView addSubview:card];
    toVC.view.hidden = YES;
    CGRect half = CGRectMake(([PFResUtil screenSize].size.width - _originFrame.size.width) / 2,
                             0,
                             _originFrame.size.width + 30, _originFrame.size.height + 30);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewKeyframeAnimationOptionLayoutSubviews
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:2/3.0 animations:^{
                                      card.frame = half;
                                      wrapper.frame = card.bounds;
                                      background.frame = wrapper.bounds;
                                      background.alpha = 0;
                                      shot.frame = wrapper.bounds;
                                  }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations:^{
                                      shot.frame = _keyEleDestFrame;
                                      wrapper.frame = CGRectMake(0, 0, [PFResUtil screenSize].size.width, 200);
                                      background.frame = wrapper.bounds;
                                      card.frame = toVC.view.frame;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations:^{
                                      shot.alpha = 0.8;
                                  }];
                              } completion:^(BOOL finished) {
                                  if (finished) {
                                      toVC.view.hidden = NO;
                                      [shot removeFromSuperview];
                                      [background removeFromSuperview];
                                      [wrapper removeFromSuperview];
                                      [card removeFromSuperview];
                                      [transitionContext completeTransition:YES];
                                  }
                              }];
}

@end
