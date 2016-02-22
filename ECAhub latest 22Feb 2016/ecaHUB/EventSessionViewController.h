//
//  EventSessionViewController.h
//  ecaHUB
//
//  Created by promatics on 4/7/15.
//  Copyright (c) 2015 promatics. All rights reserved.


//date_time_lbl,day_time,venue_lbl,venue_value,age_group,age_groupValue
//gender_lable,gender_value,_lang_medium_lbl,main_lang,support_lang_lbl,support_lang

//max_sizeLbl,max_size_value,available_places,available_places_value,course_fees_value,otherCharges_lbl,otherChargesValue

#import <UIKit/UIKit.h>

@interface EventSessionViewController : UIViewController

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
//@property (weak, nonatomic) IBOutlet UILabel *venue_lbl;

- (IBAction)tapRequestToBtn:(id)sender;
- (IBAction)tapEnduireBtn:(id)sender;
- (IBAction)tapEditBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *venue_value;
@property (weak, nonatomic) IBOutlet UILabel *venue_lbl;
@property (weak, nonatomic) IBOutlet UILabel *otherCharges_lbl;

@property (weak, nonatomic) IBOutlet UILabel *otherChargesValue;
@property (weak, nonatomic) IBOutlet UILabel *_lang_medium_lbl;
@property (weak, nonatomic) IBOutlet UILabel *support_lang_lbl;
@property (weak, nonatomic) IBOutlet UILabel *date_time_lbl;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *add_barBtn;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancel_barbutton;

@property BOOL isPrevAddAvail;
- (IBAction)tap_edit_btn:(id)sender;
- (IBAction)tap_delete_btn:(id)sender;

@property BOOL isView;
@property BOOL isEdit;

@end
