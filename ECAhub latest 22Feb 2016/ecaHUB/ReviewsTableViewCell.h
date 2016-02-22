//
//  ReviewsTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 3/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface ReviewsTableViewCell : UITableViewCell <RatingViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UIView *rate_view;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *user_review;

@property (strong, nonatomic) RatingView *star_ratingView;

@property (nonatomic, readwrite) float rate_no;

-(void)setRating;

@end
