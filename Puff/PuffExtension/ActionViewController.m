//
//  ActionViewController.m
//  PuffExtension
//
//  Created by bob.sun on 18/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <LocalAuthentication/LocalAuthentication.h>

//
//#import "PFAccountManager.h"

@interface ActionViewController ()

@property(strong,nonatomic) IBOutlet UIImageView *imageView;
//@property(strong, nonatomic) NSArray<PFAccount*> *accounts;
@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
//    _accounts = [[PFAccountManager sharedManager] fetchAll];
    
    [self _authorizeWithTouchId];
    
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL imageFound = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
                // This is an image. We'll load it, then place it in our image view.
                __weak UIImageView *imageView = self.imageView;
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error) {
                    if(image) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [imageView setImage:image];
                        }];
                    }
                }];
                
                imageFound = YES;
                break;
            }
        }
        
        if (imageFound) {
            // We only handle one image, so stop looking for more.
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

- (void)_authorizeWithTouchId {
    LAContext *ctx = [[LAContext alloc] init];
    if ([self _hasTouchID]) {
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"Unlock with Touch ID", nil) reply:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    
                }
                if (error) {
                    if (error.code == LAErrorUserFallback) {
                        
                    } else {
                        
                    }
                }
            });
        }];
    }
}

- (BOOL)_hasTouchID {
    LAContext *ctx = [[LAContext alloc] init];
    NSError *err;
    return [ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err];
}

@end
