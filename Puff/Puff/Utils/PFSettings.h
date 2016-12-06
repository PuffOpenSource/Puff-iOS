//
//  PFSettings.h
//  Puff
//
//  Created by bob.sun on 06/12/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFSettings : NSObject
+ (instancetype)sharedInstance;

- (void)save;
- (BOOL)touchIDEnabled;
- (void)setTouchIDEnabled:(BOOL)enabled;
- (BOOL)clearInfo;
- (void)setClearInfo:(BOOL)clearInfo;
@end
