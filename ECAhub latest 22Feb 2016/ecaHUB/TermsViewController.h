//
//  TermsViewController.h
//  ecaHUB
//
//  Created by promatics on 3/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *course_name;
@property (weak, nonatomic) IBOutlet UILabel *payment;
@property (weak, nonatomic) IBOutlet UILabel *deposit;
@property (weak, nonatomic) IBOutlet UILabel *changes;
@property (weak, nonatomic) IBOutlet UILabel *cancellation;
@property (weak, nonatomic) IBOutlet UILabel *makeupLessions;
@property (weak, nonatomic) IBOutlet UILabel *severe_weather;
@property (weak, nonatomic) IBOutlet UILabel *refundLbl;
@property (weak, nonatomic) IBOutlet UILabel *refund_Value;
@property (weak, nonatomic) IBOutlet UILabel *SevereLbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentLbl;
@property (weak, nonatomic) IBOutlet UILabel *depositeLbl;
@property (weak, nonatomic) IBOutlet UILabel *cancelLbl;
@property (weak, nonatomic) IBOutlet UILabel *changeLbl;
@property (weak, nonatomic) IBOutlet UILabel *makeLbl;

@end
