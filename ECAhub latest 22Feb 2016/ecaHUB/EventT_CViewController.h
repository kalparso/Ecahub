//
//  EventT_CViewController.h
//  ecaHUB
//
//  Created by promatics on 4/7/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventT_CViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *paymentLbl;
@property (weak, nonatomic) IBOutlet UILabel *changesLbl;
@property (weak, nonatomic) IBOutlet UILabel *cancellationlbl;
@property (weak, nonatomic) IBOutlet UILabel *refundLbl;
@property (weak, nonatomic) IBOutlet UILabel *makeupLbl;
@property (weak, nonatomic) IBOutlet UILabel *severeWeatherLbl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *event_name;
@property (weak, nonatomic) IBOutlet UILabel *payment;
@property (weak, nonatomic) IBOutlet UILabel *deposit;
@property (weak, nonatomic) IBOutlet UILabel *changes_booking;
@property (weak, nonatomic) IBOutlet UILabel *changes;
@property (weak, nonatomic) IBOutlet UILabel *cancellation;
@property (weak, nonatomic) IBOutlet UILabel *makeupLessions;
@property (weak, nonatomic) IBOutlet UILabel *severe_weather;



@end
