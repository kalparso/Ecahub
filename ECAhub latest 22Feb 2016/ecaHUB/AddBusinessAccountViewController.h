//
//  AddBusinessAccountViewController.h
//  ecaHUB
//
//  Created by promatics on 8/20/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBusinessAccountViewController : UIViewController
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
- (IBAction)tap_selectAccount:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)tap_Save:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)tapCancelBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_View;
@end
