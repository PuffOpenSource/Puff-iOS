//
//  PFPasswordGenViewController.m
//  Puff
//
//  Created by bob.sun on 19/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFPasswordGenViewController.h"
#import "PFResUtil.h"

@interface PFPasswordGenViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation PFPasswordGenViewController

+(instancetype)viewControllerFromStoryboard {
    PFPasswordGenViewController* ret;
    ret = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]] instantiateViewControllerWithIdentifier:@"PasswordGenViewController"];
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 0;
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = _currentPage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

#pragma mark - IBActions
- (IBAction)didTapOnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapOnPrev:(id)sender {
    if (_currentPage == 0) {
        [PFResUtil shakeItBaby:sender withCompletion:nil];
        return;
    }
    _currentPage -= 1;
    _pageControl.currentPage = _currentPage;
    CGFloat width = _scrollview.frame.size.width;
    CGFloat height = _scrollview.frame.size.height;
    [_scrollview scrollRectToVisible:CGRectMake(width * _currentPage, 0, width, height) animated:YES];
    
}
- (IBAction)didTapOnNext:(id)sender {
    if (_currentPage == 2) {
        [PFResUtil shakeItBaby:sender withCompletion:nil];
        return;
    }
    _currentPage += 1;
    _pageControl.currentPage = _currentPage;
    CGFloat width = _scrollview.frame.size.width;
    CGFloat height = _scrollview.frame.size.height;
    
    [_scrollview scrollRectToVisible:CGRectMake(width * _currentPage, 0, width, height) animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
