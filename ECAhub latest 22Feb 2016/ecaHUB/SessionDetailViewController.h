//
//  SessionDetailViewController.h
//  ecaHUB
//
//  Created by promatics on 3/30/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *session_name;
@property (weak, nonatomic) IBOutlet UILabel *main_lang;
@property (weak, nonatomic) IBOutlet UILabel *support_lang;
@property (weak, nonatomic) IBOutlet UILabel *day_time;
@property (weak, nonatomic) IBOutlet UILabel *age_group;
@property (weak, nonatomic) IBOutlet UILabel *age_groupValue;
@property (weak, nonatomic) IBOutlet UILabel *gender_lable;
@property (weak, nonatomic) IBOutlet UILabel *gender_value;
@property (weak, nonatomic) IBOutlet UILabel *max_sizeLbl;
@property (weak, nonatomic) IBOutlet UILabel *max_size_value;
@property (weak, nonatomic) IBOutlet UILabel *available_places;
@property (weak, nonatomic) IBOutlet UILabel *available_places_value;
@property (weak, nonatomic) IBOutlet UILabel *course_fees_lable;
@property (weak, nonatomic) IBOutlet UILabel *course_fees_value;
@property (weak, nonatomic) IBOutlet UIButton *requestToEnrollBtn;
@property (weak, nonatomic) IBOutlet UIButton *enquireBtn;
@property (weak, nonatomic) IBOutlet UILabel *venue_lbl;

- (IBAction)tapRequestToBtn:(id)sender;
- (IBAction)tapEnduireBtn:(id)sender;
- (IBAction)tapEditBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *venueSt_lbl;
@property (weak, nonatomic) IBOutlet UILabel *venue_tag_lbl;
@property (weak, nonatomic) IBOutlet UILabel *noOfLessons_LbL;
@property (weak, nonatomic) IBOutlet UILabel *noOfLessons_Value;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBtn;
- (IBAction)tap_editBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *deletebtn;
- (IBAction)tap_deletebtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *instruction_lang_lbl;
@property (weak, nonatomic) IBOutlet UILabel *support_lang_lbl;
@property (weak, nonatomic) IBOutlet UILabel *date_time_lbl;
@property (weak, nonatomic) IBOutlet UILabel *no_of_less_lbl;

@property BOOL isEdit;

@property BOOL isPrevAddAvail;

@end


