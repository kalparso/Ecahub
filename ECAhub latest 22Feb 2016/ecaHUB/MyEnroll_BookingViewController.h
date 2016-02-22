//
//  MyEnroll_BookingViewController.h
//  ecaHUB
//
//  Created by promatics on 4/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
#import "ListingViewController.h"

@interface MyEnroll_BookingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, PayPalPaymentDelegate,UIPopoverControllerDelegate,PayPalFuturePaymentDelegate, UIAlertViewDelegate, listingDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myEnroolTable;

//-----Paypal----//

@property(nonatomic, strong, readwrite) NSString *environment;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@property(nonatomic, strong, readwrite) NSString *resultText;

@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;

@property (strong, nonatomic) IBOutlet UILabel *enrolBook_lbl;



@end
