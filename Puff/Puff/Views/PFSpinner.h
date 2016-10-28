//
//  PFSpinner.h
//  Puff
//
//  Created by bob.sun on 27/10/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFSpinner;
@protocol PFSpinnerDelegate <NSObject>

@required
- (void)pfSpinner:(PFSpinner* _Nonnull)spinner didSelectItem:(id) item;

@end

typedef  void(^PFSpinnerCellConfigureBlock)(UITableViewCell* cell, NSIndexPath* indexPath, NSObject* dataItem);

@interface PFSpinner : UIView

@property (weak, nonatomic) id<PFSpinnerDelegate> spinnerDelegate;
@property (strong, nonatomic) PFSpinnerCellConfigureBlock configureCallback;
- (instancetype)initAsSpinnerWithData:(NSArray* _Nonnull)data andFrame:(CGRect)frame;
- (instancetype)initAsMenuWithData:(NSArray* _Nonnull)data andFrame:(CGRect)frame;


@end

@interface PFSpinnerCell : UITableViewCell
@property (strong, nonatomic) UIImageView* iconView;
@property (strong, nonatomic) UILabel* label;
@end

@interface PFSpinnerMenuCell : UITableViewCell
@property (strong, nonatomic) UILabel *label;
@end
