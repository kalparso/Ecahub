//
//  RatingView.h
//  ecaHUB
//
//  Created by promatics on 4/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RatingView;

@protocol RatingViewDelegate <NSObject>

@optional

-(void)starRatingView:(RatingView *)view score:(float)score;
@end

@interface RatingView : UIView

@property (nonatomic, readonly) float numberOfStar;

@property (nonatomic, readonly) float star_width;

@property (nonatomic, weak) id <RatingViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame numberOfStar:(float)number starWidth:(float) starWidth;

- (void)setScore:(float)score withAnimation:(bool)isAnimate;

- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName;

@end

#define BACKGROUND_STAR @"nonstar"

#define FOREGROUND_STAR @"star"

#define NUMBER_OF_STAR  5
