//  MyWhatsOnListing.h
//  ecaHUB
//
//  Created by promatics on 5/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ListingViewController.h"
#import "PayPalMobile.h"

@interface MyWhatsOnListing : UIViewController <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate, PayPalPaymentDelegate,UIPopoverControllerDelegate, UIAlertViewDelegate, listingDelegate>

//-----Paypal----//

@property(nonatomic, strong, readwrite) NSString *environment;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@property(nonatomic, strong, readwrite) NSString *resultText;

@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;

@property (weak, nonatomic) IBOutlet UITableView *tble_view;

@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tapAddBtn;

- (IBAction)tapAdd_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *postLbl_btn;

- (IBAction)tapPostLbl_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *post_lbl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *info_btn;
- (IBAction)tapInfo_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *sub_view;

@end