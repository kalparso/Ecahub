//
//  MessageTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 4/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface MessageTableViewCell : UITableViewCell <RatingViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *userImgIcon_bttn;

@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *time_lbl;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UIView *rating_view;
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIImageView *msg_type_img;

@property (strong, nonatomic) RatingView *star_ratingView;

@property (nonatomic, readwrite) float rate_no;

-(void)setRating;

@end
