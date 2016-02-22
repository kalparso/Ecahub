//
//  AccountViewController.h
//  ecaHUB
//
//  Created by promatics on 8/21/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bankAcntdetailView;
@property (weak, nonatomic) IBOutlet UILabel *paypal_emailTxt;
@property (weak, nonatomic) IBOutlet UILabel *businessLbl;
@property (weak, nonatomic) IBOutlet UILabel *personalLbl;
@property (weak, nonatomic) IBOutlet UILabel *countrylbl;
@property (weak, nonatomic) IBOutlet UILabel *banknameLbl;
@property (weak, nonatomic) IBOutlet UILabel *swiftCodelbl;
@property (weak, nonatomic) IBOutlet UILabel *branchLocationLbl;
@property (weak, nonatomic) IBOutlet UILabel *bankCodeLbl;
@property (weak, nonatomic) IBOutlet UILabel *branchCodelbl;
@property (weak, nonatomic) IBOutlet UILabel *accountNamelbl;
@property (weak, nonatomic) IBOutlet UILabel *accountNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *AccountTypeLbl;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UILabel *memberIDValuelbl;
@property (weak, nonatomic) IBOutlet UILabel *memberIDlbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property BOOL IsPersonalAcntView;
- (IBAction)tapEditBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *defaultAccountlbl;
@property (weak, nonatomic) IBOutlet UILabel *bankAccount_lbl;

@end
