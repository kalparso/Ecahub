//
//  Term_ConditionViewController.h
//  ecaHUB
//
//  Created by promatics on 3/19/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface Term_ConditionViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, listingDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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
@property (strong, nonatomic) IBOutlet UIButton *othercharge_btnn;
@property (strong, nonatomic) IBOutlet UITextField *othrCharge_textfield;

@property (strong, nonatomic) IBOutlet UITextField *cancellation_textfield;
@property (strong, nonatomic) IBOutlet UIView *size_view;
@property (strong, nonatomic) IBOutlet UIButton *currencyAccpt_btn;
- (IBAction)tapCurrencyAccpt_btn:(id)sender;

- (IBAction)tapOtherCharge_btnn:(id)sender;
- (IBAction)tappaymentDeadLine:(id)sender;
- (IBAction)tapDepositeBtn:(id)sender;
- (IBAction)tapCancellationBtn:(id)sender;
- (IBAction)tapRefundBtn:(id)sender;
- (IBAction)tapmake_upLession:(id)sender;
- (IBAction)tapservere_weather:(id)sender;
- (IBAction)tapBooks_materialBtn:(id)sender;
- (IBAction)tapSecurityDeposit:(id)sender;

- (IBAction)tappSaveBtn:(id)sender;
- (IBAction)tappCancelBtn:(id)sender;
- (IBAction)tapChangeEnrollment:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *feesAndCharegsBtn;
- (IBAction)Tap_feesAndChargesBtn:(id)sender;
@property NSDictionary *termDataDict;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
- (IBAction)tap_infoBtn:(id)sender;

@end
