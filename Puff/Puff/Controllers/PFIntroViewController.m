//
//  PFIntroViewController.m
//  Puff
//
//  Created by bob.sun on 30/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFIntroViewController.h"
#import "PFSetMasterPasswordViewController.h"
#import "PFResUtil.h"

@interface PFIntroViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSMutableArray<UIViewController*> *vcs;
@end

@implementation PFIntroViewController

+ (instancetype)viewControllerFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Intro" bundle:[NSBundle bundleForClass:self.class]] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Intro" bundle:[NSBundle bundleForClass:self.class]];
    _vcs = [@[] mutableCopy];
    for (int i = 0; i < 3; i++) {
        [_vcs addObject: [sb instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"introVC%d", i + 1]]];
    }
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    
//    _pageVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);

    
    [_pageVC setViewControllers:@[_vcs[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:_pageVC];
    [_pageVC didMoveToParentViewController:self];
    [self.view addSubview:_pageVC.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismiss {
    PFSetMasterPasswordViewController *vc = [PFSetMasterPasswordViewController viewControllerFromStoryBoard];
    vc.showMode = showModeSet;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger idx = [_vcs indexOfObject:viewController];
    if (idx == 0) {
        return nil;
    }
    return [_vcs objectAtIndex:idx - 1];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger idx = [_vcs indexOfObject:viewController];
    if (idx == _vcs.count - 1) {
        return nil;
    }
    return [_vcs objectAtIndex:idx + 1];
}

@end
