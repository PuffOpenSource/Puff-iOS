//
//  PFLoadingViewController.m
//  Puff
//
//  Created by bob.sun on 23/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFLoadingView.h"
#import <Masonry/Masonry.h>

#define SHOW_DELAY          0.3

@interface PFLoadingView ()
@property (weak, nonatomic) UIViewController *owner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *theLabel;

@end

@implementation PFLoadingView

+ (instancetype)sharedInstance {
    static PFLoadingView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[NSBundle bundleForClass:self] loadNibNamed:@"PFLoadingView" owner:nil options:nil] firstObject];
    });
    return instance;
}

+ (void)showIn:(UIViewController *)vc {
    PFLoadingView *instance = [self sharedInstance];
    instance.owner = vc;
    [instance performSelector:@selector(show) withObject:nil afterDelay:SHOW_DELAY];
}


+ (void)dismiss {
    PFLoadingView *instance = [self sharedInstance];
    if (instance.owner == nil) {
        return;
    }
    instance.owner = nil;
    [instance.indicator stopAnimating];
    [instance removeFromSuperview];
}

+ (void)updateLabel:(NSString *)update {
    PFLoadingView *instance = [self sharedInstance];
    if (instance.owner == nil) {
        return;
    }
    instance.theLabel.text = update;
}

- (void)show {
    if (_owner == nil) {
        return;
    }
    [_owner.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_owner.view);
    }];
    
    [_indicator startAnimating];
}

@end
