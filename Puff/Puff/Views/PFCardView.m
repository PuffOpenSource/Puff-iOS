//
//  PFCardView.m
//  Puff
//
//  Created by bob.sun on 23/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "PFCardView.h"

@implementation PFCardView

- (instancetype)init {
    if (self = [super init])
        [self initLayer];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder])
        [self initLayer];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
        [self initLayer];
    return self;
}

-(void)initLayer {
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, self.elevation);
    self.layer.shadowOpacity = 0.8;
//    self.layer.shadowRadius = self.elevation / 4;
    self.layer.cornerRadius = self.cornerRadius;
    
    self.layer.masksToBounds = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
