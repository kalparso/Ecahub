//
//  ViewMemberDetailViewController.h
//  ecaHUB
//
//  Created by promatics on 6/24/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewMemberDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *member_image_view;
@property (weak, nonatomic) IBOutlet UILabel *member_lbl;
@property (weak, nonatomic) IBOutlet UIImageView *star1_img_view;
@property (weak, nonatomic) IBOutlet UIImageView *star2_img_view;
@property (weak, nonatomic) IBOutlet UIImageView *star3_img_view;
@property (weak, nonatomic) IBOutlet UIImageView *star4_img_view;
@property (weak, nonatomic) IBOutlet UIImageView *star5_img_view;
@property (weak, nonatomic) IBOutlet UIView *star_rating_view;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIView *sub_view;
@property (weak, nonatomic) IBOutlet UILabel *member_name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *phone_no_lbl;
@property (weak, nonatomic) IBOutlet UILabel *student_name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *session_lbl;
@property (weak, nonatomic) IBOutlet UILabel *date_time_lbl;
@property (weak, nonatomic) IBOutlet UILabel *enrollment_date_lbl;
@property (weak, nonatomic) IBOutlet UILabel *lesson_fees_lbl;
@property (weak, nonatomic) IBOutlet UILabel *member_name_value;
@property (weak, nonatomic) IBOutlet UILabel *phone_no_value;
@property (weak, nonatomic) IBOutlet UILabel *student_name_value;
@property (weak, nonatomic) IBOutlet UILabel *session_value;
@property (weak, nonatomic) IBOutlet UILabel *date_time_value;
@property (weak, nonatomic) IBOutlet UILabel *enrollment_date_value;
@property (weak, nonatomic) IBOutlet UILabel *lesson_fees_value;
@property (weak, nonatomic) IBOutlet UILabel *dateofbirth_lbl;
@property (weak, nonatomic) IBOutlet UILabel *dateofBirth_value;

@property (retain, nonatomic) NSDictionary *memberDetail;

@end
