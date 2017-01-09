//
//  PFIntroViewController.m
//  Puff
//
//  Created by bob.sun on 30/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFIntroViewController.h"
#import "PFSetMasterPasswordViewController.h"

@interface PFIntroViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) NSMutableArray<UIViewController*> *vcs;
@end

@implementation PFIntroViewController

+ (instancetype)viewControllerFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Intro" bundle:[NSBundle bundleForClass:self.class]] instantiateInitialViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Intro" bundle:[NSBundle bundleForClass:self.class]];
    _vcs = [@[] mutableCopy];
    for (int i = 0; i < 3; i++) {
        [_vcs addObject: [sb instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"introVC%d", i + 1]]];
    }
    self.delegate = self;
    self.dataSource = self;
    [self setViewControllers:@[_vcs[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
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
