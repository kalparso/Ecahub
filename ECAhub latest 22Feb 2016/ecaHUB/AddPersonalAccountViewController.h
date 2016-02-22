//
//  AddPersonalAccountViewController.h
//  ecaHUB
//
//  Created by promatics on 8/20/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPersonalAccountViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (weak, nonatomic) IBOutlet UITextField *paypal_emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *countryTxt;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *swiftCodeText;
@property (weak, nonatomic) IBOutlet UITextField *branchLocationText;
@property (weak, nonatomic) IBOutlet UITextField *bankCodeText;
@property (weak, nonatomic) IBOutlet UITextField *branchCodeText;
@property (weak, nonatomic) IBOutlet UITextField *accountNameText;
@property (weak, nonatomic) IBOutlet UITextField *accountNumberText;
@property (weak, nonatomic) IBOutlet UIButton *selectAccountBtn;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)tap_selectBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)tap_cancelBtn:(id)sender;

- (IBAction)tap_saveBtn:(id)sender;

@property BOOL IsPersonalAcntView;

@property BOOL isEdit;

@property NSDictionary *editAccountDict;

@property (weak, nonatomic) IBOutlet UILabel *infoLbl;

@property (weak, nonatomic) IBOutlet UIButton *infoPayPal_btn;

- (IBAction)tapInfoPayPal_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *infoBankAcc_btn;


- (IBAction)tapInfoBankAcc_btn:(id)sender;

@end
