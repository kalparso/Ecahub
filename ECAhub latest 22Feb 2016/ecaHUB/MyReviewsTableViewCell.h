//
//  MyReviewsTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 4/15/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyReviewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *comment_view;
@property (weak, nonatomic) IBOutlet UIView *list_view;
@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *comment_date;
@property (weak, nonatomic) IBOutlet UILabel *comment;

@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *listing_name;
@property (weak, nonatomic) IBOutlet UILabel *business_name;
@property (weak, nonatomic) IBOutlet UILabel *cat_name;
@property (weak, nonatomic) IBOutlet UIButton *check_Btn;
@property (weak, nonatomic) IBOutlet UIButton *giveReviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseItBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UIImageView *shareIt_Img;

@end
