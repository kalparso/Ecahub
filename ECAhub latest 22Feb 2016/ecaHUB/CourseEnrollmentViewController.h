//
//  CourseEnrollmentViewController.h
//  ecaHUB
//
//  Created by promatics on 4/9/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseEnrollmentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;


- (IBAction)tapContinueBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *studentHeading;
@property (weak, nonatomic) IBOutlet UILabel *name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *dob_lbl;
@property (weak, nonatomic) IBOutlet UILabel *GenderStd_lbl;
@property (weak, nonatomic) IBOutlet UILabel *courseDetailsHeading;
@property (weak, nonatomic) IBOutlet UILabel *courseName_lbl;
@property (weak, nonatomic) IBOutlet UILabel *educator_lbl;
@property (weak, nonatomic) IBOutlet UILabel *session_lbl;
@property (weak, nonatomic) IBOutlet UILabel *referenceId_lbl;
@property (weak, nonatomic) IBOutlet UILabel *courseDuration_lbl;
@property (weak, nonatomic) IBOutlet UILabel *teachingMethod_lbl;
@property (weak, nonatomic) IBOutlet UILabel *language_lbl;
@property (weak, nonatomic) IBOutlet UILabel *gender_lbl;
@property (weak, nonatomic) IBOutlet UILabel *ageGroup_lbl;
@property (weak, nonatomic) IBOutlet UILabel *dateandtimes_lbl;
@property (weak, nonatomic) IBOutlet UILabel *location_lbl;
@property (weak, nonatomic) IBOutlet UILabel *courseFeeHeading;
@property (weak, nonatomic) IBOutlet UILabel *courseFee_lbl;
@property (weak, nonatomic) IBOutlet UILabel *otherFeesHeading;
@property (weak, nonatomic) IBOutlet UILabel *book_lbl;
@property (weak, nonatomic) IBOutlet UILabel *security_lbl;
@property (weak, nonatomic) IBOutlet UILabel *otherFees;
@property (weak, nonatomic) IBOutlet UILabel *educatorTermsHeading;
@property (weak, nonatomic) IBOutlet UILabel *paymentDeadline_lbl;
@property (weak, nonatomic) IBOutlet UILabel *deposite_lbl;
@property (weak, nonatomic) IBOutlet UILabel *changesEnroll_lbl;
@property (weak, nonatomic) IBOutlet UILabel *cancellation_lbl;
@property (weak, nonatomic) IBOutlet UILabel *makeupEvent_lbl;
@property (weak, nonatomic) IBOutlet UILabel *severeWeather_lbl;
@property (weak, nonatomic) IBOutlet UILabel *refund_lbl;
@property (weak, nonatomic) IBOutlet UILabel *name_value;
@property (weak, nonatomic) IBOutlet UILabel *dob_value;
@property (weak, nonatomic) IBOutlet UILabel *genderStd_value;
@property (weak, nonatomic) IBOutlet UILabel *courseName_value;
@property (weak, nonatomic) IBOutlet UILabel *educator_value;
@property (weak, nonatomic) IBOutlet UILabel *session_value;
@property (weak, nonatomic) IBOutlet UILabel *teachingMethod_value;
@property (weak, nonatomic) IBOutlet UILabel *language_value;
@property (weak, nonatomic) IBOutlet UILabel *gender_value;
@property (weak, nonatomic) IBOutlet UILabel *ageGroup_value;
@property (weak, nonatomic) IBOutlet UILabel *datesandTimes_value;
@property (weak, nonatomic) IBOutlet UILabel *location_value;
@property (weak, nonatomic) IBOutlet UILabel *courseFee_value;
@property (weak, nonatomic) IBOutlet UILabel *bookMaterial_value;
@property (weak, nonatomic) IBOutlet UILabel *security_value;

@property (weak, nonatomic) IBOutlet UILabel *otherFees_value;
@property (weak, nonatomic) IBOutlet UILabel *paymentdeadline_value;
@property (weak, nonatomic) IBOutlet UILabel *changesEnroll_value;
@property (weak, nonatomic) IBOutlet UILabel *deposite_value;
@property (weak, nonatomic) IBOutlet UILabel *cancellation_value;
@property (weak, nonatomic) IBOutlet UILabel *makeupEvant_value;
@property (weak, nonatomic) IBOutlet UILabel *severeWeather_value;
@property (weak, nonatomic) IBOutlet UILabel *refund_value;

@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
- (IBAction)tap_bookBtn:(id)sender;

- (IBAction)tap_securityBtn:(id)sender;
- (IBAction)tap_otherFeesBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *otherFeesBtn;

@property (weak, nonatomic) IBOutlet UIButton *securityBtn;
@property (weak, nonatomic) IBOutlet UILabel *referenceId_value;
@property (weak, nonatomic) IBOutlet UILabel *courseDuration_value;
@property (weak, nonatomic) IBOutlet UILabel *nooflessons_lbl;

@property (weak, nonatomic) IBOutlet UILabel *nooflessons_value;

@end


