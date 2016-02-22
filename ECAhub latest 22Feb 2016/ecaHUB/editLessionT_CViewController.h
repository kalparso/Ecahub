//
//  editLessionT_CViewController.h
//  ecaHUB
//
//  Created by promatics on 4/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface editLessionT_CViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, listingDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *enrollmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *minimumPaymentBtn;
@property (weak, nonatomic) IBOutlet UIButton *paymentDeadLineBtn;
@property (weak, nonatomic) IBOutlet UIButton *depositeBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeEnrollmentBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancellationBtn;
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
@property (weak, nonatomic) IBOutlet UIButton *make_upLessionBtn;
@property (weak, nonatomic) IBOutlet UIButton *servere_weatherBtn;
@property (weak, nonatomic) IBOutlet UIButton *books_materialBtn;
@property (weak, nonatomic) IBOutlet UIButton *securityDepositBtn;
@property (weak, nonatomic) IBOutlet UITextField *books_materialPrice;
@property (weak, nonatomic) IBOutlet UITextField *securityPriceTxtField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *otherCharge_bttn;
- (IBAction)tapOthercharge_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *otherCharge_textfield;
@property (strong, nonatomic) IBOutlet UIButton *currencyAcpt_btn;
- (IBAction)tapcurrencyAcpt_btn:(id)sender;

- (IBAction)tapMini_PaymentBtn:(id)sender;

- (IBAction)tapEnrollmentBtn:(id)sender;

- (IBAction)tappaymentDeadLine:(id)sender
;
- (IBAction)tapDepositeBtn:(id)sender;

- (IBAction)tapChangeEnrollment:(id)sender;

- (IBAction)tapCancellationBtn:(id)sender;

- (IBAction)tapRefundBtn:(id)sender;

- (IBAction)tapmake_upLession:(id)sender;

- (IBAction)tapservere_weather:(id)sender;

- (IBAction)tapBooks_materialBtn:(id)sender;

- (IBAction)tapSecurityDeposit:(id)sender;

- (IBAction)tappSaveBtn:(id)sender;

- (IBAction)tappCancelBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *cancellation_textfield;
@property (strong, nonatomic) IBOutlet UIView *size_view;
- (IBAction)tapInfo_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *info_btn;
@property (weak, nonatomic) IBOutlet UIButton *feesCharges_btn;
- (IBAction)tapFeesCharges_btn:(id)sender;

@property NSDictionary *lessonData;

@property (weak, nonatomic) IBOutlet UILabel *enrolment_stlbl;
@property (weak, nonatomic) IBOutlet UILabel *payment_stlbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentddln_stlbl;
@property (weak, nonatomic) IBOutlet UILabel *deposit_stlbl;
@property (weak, nonatomic) IBOutlet UILabel *cancellation_stlbl;
@property (weak, nonatomic) IBOutlet UILabel *refund_stlbl;
@property (weak, nonatomic) IBOutlet UILabel *makeup_stlbl;
@property (weak, nonatomic) IBOutlet UILabel *severweather_stlbl;
@property (weak, nonatomic) IBOutlet UILabel *payment_valuelbl;
@property (weak, nonatomic) IBOutlet UITextView *payment_textview;

@end


