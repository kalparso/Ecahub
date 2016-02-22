//
//  AddEventT_CViewController.h
//  ecaHUB
//
//  Created by promatics on 4/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface AddEventT_CViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, listingDelegate>

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
@property (weak, nonatomic) IBOutlet UIButton *changes_bookingBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherChargesCurrencyBtn;
@property (weak, nonatomic) IBOutlet UITextField *otherChargesTextField;
@property (strong, nonatomic) IBOutlet UIView *size_view;
@property (strong, nonatomic) IBOutlet UIButton *currencyAcpt_btn;
- (IBAction)tapCurrncyAcpt_btn:(id)sender;

- (IBAction)tappaymentDeadLine:(id)sender;
- (IBAction)tapDepositeBtn:(id)sender;
- (IBAction)tapCancellationBtn:(id)sender;
- (IBAction)tapRefundBtn:(id)sender;
- (IBAction)tapmake_upLession:(id)sender;
- (IBAction)tapservere_weather:(id)sender;
- (IBAction)tapBooks_materialBtn:(id)sender;
- (IBAction)tapSecurityDeposit:(id)sender;
- (IBAction)tapChangesBooking:(id)sender;
- (IBAction)tapOtherChrgesCurrencyBtn:(id)sender;

- (IBAction)tappSaveBtn:(id)sender;
- (IBAction)tappCancelBtn:(id)sender;
- (IBAction)tapChangeEnrollment:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *cancellation_textfield;

@property (weak, nonatomic) IBOutlet UIButton *enterFeesAndChargesBtn;
- (IBAction)tap_EnterFeesAndChargesBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
- (IBAction)tap_infoBtn:(id)sender;

@property NSDictionary *eventData;

@end
