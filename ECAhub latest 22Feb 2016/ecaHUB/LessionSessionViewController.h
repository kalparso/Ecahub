//
//  LessionSessionViewController.h
//  ecaHUB
//
//  Created by promatics on 4/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessionSessionViewController : UIViewController

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

- (IBAction)tapRequestToBtn:(id)sender;
- (IBAction)tapEnduireBtn:(id)sender;
- (IBAction)tapEditBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *venue_lbl;
@property (weak, nonatomic) IBOutlet UILabel *venue_value;

@property (weak, nonatomic) IBOutlet UILabel *instruction_lang_lbl;
@property (weak, nonatomic) IBOutlet UILabel *support_lang_lbl;
@property (weak, nonatomic) IBOutlet UILabel *date_time_lbl;
@property (weak, nonatomic) IBOutlet UILabel *main_lang_lbl;

@property BOOL isEdit;
@property BOOL isView;
@property BOOL isPrevAddAvail;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *edit_btn;
- (IBAction)tapEdit_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *delete_btn;

- (IBAction)tapDelete_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *maxStudent_lbl;
@property (weak, nonatomic) IBOutlet UILabel *maxStudent_value;
@property (weak, nonatomic) IBOutlet UILabel *seats_remainiglbl;
@property (weak, nonatomic) IBOutlet UILabel *seats_remaining_value;

@end


