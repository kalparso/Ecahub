//
//  EnrollmentViewController.h
//  ecaHUB
//
//  Created by promatics on 4/9/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface EnrollmentViewController : UIViewController <listingDelegate>

@property (weak, nonatomic) IBOutlet UIButton *select_memberBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *enter_member_detailBtn;
@property (weak, nonatomic) IBOutlet UILabel *or_lable;

- (IBAction)memberBtn:(id)sender;
- (IBAction)nextBtn:(id)sender;
- (IBAction)enterMemberBtn:(id)sender;

@end
