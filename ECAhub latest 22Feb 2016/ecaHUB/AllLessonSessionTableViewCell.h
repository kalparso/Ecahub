//
//  AllLessonSessionTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 6/22/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllLessonSessionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (weak, nonatomic) IBOutlet UILabel *session_name;
@property (weak, nonatomic) IBOutlet UILabel *main_lang;
@property (weak, nonatomic) IBOutlet UILabel *main_langValue;
@property (weak, nonatomic) IBOutlet UILabel *sup_lang;
@property (weak, nonatomic) IBOutlet UILabel *sup_langValue;
@property (weak, nonatomic) IBOutlet UILabel *day_time;
@property (weak, nonatomic) IBOutlet UILabel *day_timeValue;
@property (weak, nonatomic) IBOutlet UILabel *age_group;
@property (weak, nonatomic) IBOutlet UILabel *age_groupValue;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *genderValue;
@property (weak, nonatomic) IBOutlet UILabel *max_class;
@property (weak, nonatomic) IBOutlet UILabel *max_classValue;
@property (weak, nonatomic) IBOutlet UILabel *places;
@property (weak, nonatomic) IBOutlet UILabel *placesValue;
@property (weak, nonatomic) IBOutlet UILabel *fee;
@property (weak, nonatomic) IBOutlet UILabel *feeValue;
@property (weak, nonatomic) IBOutlet UIButton *requestToEnrollBtn;
@property (weak, nonatomic) IBOutlet UIButton *enquireBtn;


@end
