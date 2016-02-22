//
//  HomeEnrollmentTableCell.h
//  ecaHUB
//
//  Created by promatics on 4/23/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeEnrollmentTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *enroll_view;

@property (strong, nonatomic) IBOutlet UILabel *enroltype_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enrolname_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enrolFor_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enrolForname_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enrolfrom_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enrolfromdate_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enrolto_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enroltodate_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enroladdrs_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enrolDate_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enrolCost_lbl;
@property (strong, nonatomic) IBOutlet UILabel *enrolrefrnce_lbl;
@property (strong, nonatomic) IBOutlet UIButton *enrolsendMsg_bttn;
- (IBAction)tapenrolsend_bttn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *status_imgView;

@end
