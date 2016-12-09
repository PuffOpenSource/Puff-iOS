//
//  PFAboutViewController.m
//  Puff
//
//  Created by bob.sun on 07/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFAboutViewController.h"


@interface PFAboutViewController ()

@end

@implementation PFAboutViewController

+(instancetype)viewControllerFromStoryboard {
    PFAboutViewController *ret;
    ret = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:self.class]] instantiateViewControllerWithIdentifier:@"PFAboutViewController"];
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)didTapOnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)didTapOnContactUs:(id)sender {
    NSURL *url = [NSURL URLWithString:@"mailto:bob.sun@outlook.ie"];
    [[UIApplication sharedApplication] openURL:url];
}
- (IBAction)didTapOnVisit:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://github.com/PuffOpenSource/"];
    [[UIApplication sharedApplication] openURL:url];
}
- (IBAction)didTapOnGithub:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://github.com/PuffOpenSource/Puff-iOS"];
    [[UIApplication sharedApplication] openURL:url];
}
- (IBAction)didTapOnIcons8:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://icons8.com/"];
    [[UIApplication sharedApplication] openURL:url];
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
