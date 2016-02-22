//
//  viewMyEnrollView.h
//  ecaHUB
//
//  Created by promatics on 6/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface viewMyEnrollView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UILabel *list_name;
@property (weak, nonatomic) IBOutlet UILabel *for_lbl;
@property (weak, nonatomic) IBOutlet UILabel *from_lbl;
@property (weak, nonatomic) IBOutlet UILabel *to_lbl;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *enroll_date;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *payment_status;
@property (weak, nonatomic) IBOutlet UILabel *books_matPrice;
@property (weak, nonatomic) IBOutlet UILabel *security;
@property (weak, nonatomic) IBOutlet UILabel *other;
@property (weak, nonatomic) IBOutlet UILabel *listing_chages;
@property (weak, nonatomic) IBOutlet UILabel *total_fees;
@property (weak, nonatomic) IBOutlet UILabel *refrence;

- (IBAction)tapCloseBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *ForLbl;
@property (weak, nonatomic) IBOutlet UILabel *forValue;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailValue;
@property (weak, nonatomic) IBOutlet UILabel *educatorLbl;
@property (weak, nonatomic) IBOutlet UILabel *educatorValue;
@property (weak, nonatomic) IBOutlet UILabel *sessionLbl;
@property (weak, nonatomic) IBOutlet UILabel *sessionValue;
@property (weak, nonatomic) IBOutlet UILabel *referenceIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *referenceValue;
@property (weak, nonatomic) IBOutlet UILabel *courseDurationLbl;
@property (weak, nonatomic) IBOutlet UILabel *coursedurationValue;
@property (weak, nonatomic) IBOutlet UILabel *teachingMethodLbl;
@property (weak, nonatomic) IBOutlet UILabel *teachingMethodValue;
@property (weak, nonatomic) IBOutlet UILabel *languagemediumLbl;
@property (weak, nonatomic) IBOutlet UILabel *languageMediumValue;
@property (weak, nonatomic) IBOutlet UILabel *genderLbl;
@property (weak, nonatomic) IBOutlet UILabel *genderValue;
@property (weak, nonatomic) IBOutlet UILabel *agegroupLbl;
@property (weak, nonatomic) IBOutlet UILabel *ageGroupValue;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *datetimeValue;
@property (weak, nonatomic) IBOutlet UILabel *venueLbl;
@property (weak, nonatomic) IBOutlet UILabel *venueValue;
@property (weak, nonatomic) IBOutlet UILabel *enrollmentdateLbl;
@property (weak, nonatomic) IBOutlet UILabel *enrollmentdateValue;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusValue;
@property (weak, nonatomic) IBOutlet UILabel *courseLbl;
@property (weak, nonatomic) IBOutlet UILabel *courseValue;
@property (weak, nonatomic) IBOutlet UILabel *totalChargeslbl;
@property (weak, nonatomic) IBOutlet UILabel *totalChargesValue;
@property (weak, nonatomic) IBOutlet UILabel *educatorTandClbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentddlneLbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentddlneValue;
@property (weak, nonatomic) IBOutlet UILabel *depositLbl;
@property (weak, nonatomic) IBOutlet UILabel *depositValue;
@property (weak, nonatomic) IBOutlet UILabel *changesenrolmntLbl;
@property (weak, nonatomic) IBOutlet UILabel *changesenrlmntValue;
@property (weak, nonatomic) IBOutlet UILabel *cancellationLbl;
@property (weak, nonatomic) IBOutlet UILabel *cancelationValue;
@property (weak, nonatomic) IBOutlet UILabel *makeUpLessonsLbl;
@property (weak, nonatomic) IBOutlet UILabel *makeuplessonsValue;
@property (weak, nonatomic) IBOutlet UILabel *severeWeatherLbl;
@property (weak, nonatomic) IBOutlet UILabel *severeWeatherValue;
@property (weak, nonatomic) IBOutlet UILabel *refundLbl;
@property (weak, nonatomic) IBOutlet UILabel *refundValue;
@property (weak, nonatomic) IBOutlet UILabel *codeofconductLbl;
@property (weak, nonatomic) IBOutlet UILabel *codeofconductValue;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *paymentTerm_lbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentTerm_Value;
@property (weak, nonatomic) IBOutlet UILabel *enrollment_lbl;
@property (weak, nonatomic) IBOutlet UILabel *enrollment_value;
@property (weak, nonatomic) IBOutlet UILabel *sessionOptnLbl;
@property (weak, nonatomic) IBOutlet UILabel *sessionOptnValue;

@end
