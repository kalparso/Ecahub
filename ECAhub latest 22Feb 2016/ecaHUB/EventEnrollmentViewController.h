//
//  EventEnrollmentViewController.h
//  ecaHUB
//
//  Created by promatics on 4/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventEnrollmentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *student_name;
@property (weak, nonatomic) IBOutlet UILabel *dob;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *course_name;
@property (weak, nonatomic) IBOutlet UILabel *session_name;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *mints;
@property (weak, nonatomic) IBOutlet UILabel *hours;
@property (weak, nonatomic) IBOutlet UILabel *fees;
@property (weak, nonatomic) IBOutlet UIButton *T_CBtn;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@property (weak, nonatomic) IBOutlet UILabel *fees_label1;
@property (weak, nonatomic) IBOutlet UILabel *fees_lebel2;
@property (weak, nonatomic) IBOutlet UILabel *fees_lebel3;
@property (weak, nonatomic) IBOutlet UIButton *fees_btn1;
@property (weak, nonatomic) IBOutlet UIButton *fees_btn2;
@property (weak, nonatomic) IBOutlet UIButton *fees_btn3;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

- (IBAction)tapFee_btn1:(id)sender;
- (IBAction)tapFee_btn2:(id)sender;
- (IBAction)tapFee_btn3:(id)sender;
- (IBAction)tapAgreeBtn:(id)sender;

- (IBAction)tapContinueBtn:(id)sender;
- (IBAction)tapT_CBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *forHeading;
@property (weak, nonatomic) IBOutlet UILabel *name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *dob_lbl;
@property (weak, nonatomic) IBOutlet UILabel *noOfattendees_lbl;
@property (weak, nonatomic) IBOutlet UILabel *eventDetailsHeading;
@property (weak, nonatomic) IBOutlet UILabel *eventName_lbl;
@property (weak, nonatomic) IBOutlet UILabel *educator_lbl;
@property (weak, nonatomic) IBOutlet UILabel *session_lbl;
@property (weak, nonatomic) IBOutlet UILabel *referenceId_lbl;
@property (weak, nonatomic) IBOutlet UILabel *eventDuration_lbl;
@property (weak, nonatomic) IBOutlet UILabel *typeOfEvent_lbl;
@property (weak, nonatomic) IBOutlet UILabel *language_lbl;
@property (weak, nonatomic) IBOutlet UILabel *gender_lbl;
@property (weak, nonatomic) IBOutlet UILabel *ageGroup_lbl;
@property (weak, nonatomic) IBOutlet UILabel *datesTimes_lbl;
@property (weak, nonatomic) IBOutlet UILabel *location_lbl;
@property (weak, nonatomic) IBOutlet UILabel *eventEntryFeeHeading;
@property (weak, nonatomic) IBOutlet UILabel *eventEntryFee_lbl;
@property (weak, nonatomic) IBOutlet UILabel *otherFeesHeading;
@property (weak, nonatomic) IBOutlet UILabel *otherFees;
@property (weak, nonatomic) IBOutlet UILabel *educatorTermsHeading;
@property (weak, nonatomic) IBOutlet UILabel *paymentDeadline_lbl;
@property (weak, nonatomic) IBOutlet UILabel *changesBooking_lbl;
@property (weak, nonatomic) IBOutlet UILabel *cancellation_lbl;
@property (weak, nonatomic) IBOutlet UILabel *makeupEvent_lbl;
@property (weak, nonatomic) IBOutlet UILabel *severeWeather_lbl;
@property (weak, nonatomic) IBOutlet UILabel *refund_lbl;
@property (weak, nonatomic) IBOutlet UILabel *name_value;
@property (weak, nonatomic) IBOutlet UILabel *dob_value;
@property (weak, nonatomic) IBOutlet UILabel *noOfattendees_value;
@property (weak, nonatomic) IBOutlet UILabel *evantName_value;
@property (weak, nonatomic) IBOutlet UILabel *educator_value;
@property (weak, nonatomic) IBOutlet UILabel *session_value;
@property (weak, nonatomic) IBOutlet UILabel *typeOfEvent_value;
@property (weak, nonatomic) IBOutlet UILabel *language_value;
@property (weak, nonatomic) IBOutlet UILabel *gender_value;
@property (weak, nonatomic) IBOutlet UILabel *ageGroup_value;
@property (weak, nonatomic) IBOutlet UILabel *datesTimes_value;
@property (weak, nonatomic) IBOutlet UILabel *location_value;
@property (weak, nonatomic) IBOutlet UILabel *eventEntryFee_value;
@property (weak, nonatomic) IBOutlet UILabel *otherFees_value;
@property (weak, nonatomic) IBOutlet UILabel *paymentdeadline_value;
@property (weak, nonatomic) IBOutlet UILabel *changesBooking_value;
@property (weak, nonatomic) IBOutlet UILabel *cancellation_value;
@property (weak, nonatomic) IBOutlet UILabel *makeupEvant_value;
@property (weak, nonatomic) IBOutlet UILabel *severeWeather_value;
@property (weak, nonatomic) IBOutlet UILabel *refund_value;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
- (IBAction)tap_infoBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)tap_checkBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *referenceId_value;
@property (weak, nonatomic) IBOutlet UILabel *eventDuration_value;
@property NSDictionary *attendiesDict;
@end


