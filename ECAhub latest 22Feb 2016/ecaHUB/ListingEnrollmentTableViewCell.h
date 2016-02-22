//
//  ListingEnrollmentTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 5/21/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingEnrollmentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *From_lbl;
@property (strong, nonatomic) IBOutlet UILabel *to_lbl;
@property (strong, nonatomic) IBOutlet UILabel *details_lbl;

@property (strong, nonatomic) IBOutlet UILabel *venue_lbl;

@property (strong, nonatomic) IBOutlet UILabel *enrolBy_lbl;


@property (strong, nonatomic) IBOutlet UILabel *enrolBookingDate_lbl;
@property (strong, nonatomic) IBOutlet UIImageView *status;
@property (strong, nonatomic) IBOutlet UILabel *reference_lbl;
@property (weak, nonatomic) IBOutlet UIButton *viewBtn;
@property (strong, nonatomic) IBOutlet UILabel *action_lbl;
@property (strong, nonatomic) IBOutlet UIButton *message_bttn;
@property (strong, nonatomic) IBOutlet UIButton *approved_bttn;
@property (strong, nonatomic) IBOutlet UIButton *pending_bttn;
@property (strong, nonatomic) IBOutlet UIButton *changeEnrol_bttn;
@property (strong, nonatomic) IBOutlet UIButton *cancelEnroll_bttn;
@property (strong, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UILabel *sessionName;
@property (weak, nonatomic) IBOutlet UIView *first_view;
@property (weak, nonatomic) IBOutlet UIView *second_view;

@property (weak, nonatomic) IBOutlet UILabel *student_lbl;
@property (weak, nonatomic) IBOutlet UILabel *status_lbl;

@property (weak, nonatomic) IBOutlet UILabel *from_value;
@property (weak, nonatomic) IBOutlet UILabel *to_value;
@property (weak, nonatomic) IBOutlet UIButton *datail_btn;
@property (weak, nonatomic) IBOutlet UILabel *venue_value;
@property (weak, nonatomic) IBOutlet UILabel *enrollby_value;
@property (weak, nonatomic) IBOutlet UILabel *student_value;
@property (weak, nonatomic) IBOutlet UILabel *enrollment_value;
@property (weak, nonatomic) IBOutlet UILabel *status_value;
@property (weak, nonatomic) IBOutlet UILabel *reference_value;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

- (IBAction)tap_detailBtn:(id)sender;
- (IBAction)tap_actionBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *actionImgView;
@property (weak, nonatomic) IBOutlet UILabel *listingName_lbl;
@property (weak, nonatomic) IBOutlet UILabel *sessionName_lbl;
@property (weak, nonatomic) IBOutlet UIButton *infoimgBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoAcnBtn;

@end
