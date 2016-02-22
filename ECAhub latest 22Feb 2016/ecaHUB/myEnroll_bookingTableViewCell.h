//
//  myEnroll_bookingTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 4/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myEnroll_bookingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *type_label;
@property (weak, nonatomic) IBOutlet UILabel *type_name;
@property (weak, nonatomic) IBOutlet UIView *main_View;
@property (weak, nonatomic) IBOutlet UILabel *for_name;
@property (weak, nonatomic) IBOutlet UILabel *from_date;
@property (weak, nonatomic) IBOutlet UILabel *to_date;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *enroll_date;
@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet UILabel *reference_no;
@property (weak, nonatomic) IBOutlet UILabel *payment_status;
@property (weak, nonatomic) IBOutlet UIImageView *status_mage;
@property (weak, nonatomic) IBOutlet UIButton *send_msgBtn;
@property (weak, nonatomic) IBOutlet UIButton *pay_nowBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelPayment;
@property (weak, nonatomic) IBOutlet UIButton *viewDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeEnrollBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelEnrollBtn;
@property (weak, nonatomic) IBOutlet UILabel *listingReference;
@property (weak, nonatomic) IBOutlet UIButton *detail_btn;

- (IBAction)tap_detailBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuslbl;
@property (weak, nonatomic) IBOutlet UILabel *listingrfrncLbl;
@property (weak, nonatomic) IBOutlet UILabel *enrolmentRfrnclbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *enrolmentDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *venueLbl;
@property (weak, nonatomic) IBOutlet UILabel *tolbl;
@property (weak, nonatomic) IBOutlet UILabel *fromLbl;
@property (weak, nonatomic) IBOutlet UILabel *forLbl;
@property (weak, nonatomic) IBOutlet UILabel *status_Value;
@property (weak, nonatomic) IBOutlet UILabel *actionLbl;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *action_imgview;
@property (weak, nonatomic) IBOutlet UIButton *infoActionBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;

@end
