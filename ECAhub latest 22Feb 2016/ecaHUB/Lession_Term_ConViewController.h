//
//  Lession_Term_ConViewController.h
//  ecaHUB
//
//  Created by promatics on 4/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Lession_Term_ConViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *minimum_payment;
@property (weak, nonatomic) IBOutlet UILabel *enrollment;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lession_name;
@property (weak, nonatomic) IBOutlet UILabel *payment;
@property (weak, nonatomic) IBOutlet UILabel *deposit;
@property (weak, nonatomic) IBOutlet UILabel *changes;
@property (weak, nonatomic) IBOutlet UILabel *cancellation;
@property (weak, nonatomic) IBOutlet UILabel *makeupLessions;
@property (weak, nonatomic) IBOutlet UILabel *severe_weather;
@property (weak, nonatomic) IBOutlet UILabel *refund;
@property (weak, nonatomic) IBOutlet UILabel *enrollment_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *minimumPayment_lbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentDeadline_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *deposit_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *changes_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *cancellation_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *refund_lbl;
@property (weak, nonatomic) IBOutlet UILabel *makeup_lbl;
@property (weak, nonatomic) IBOutlet UILabel *serverWeather_Lbl;

@end
