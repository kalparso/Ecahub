//
//  EventViewController.h
//  ecaHUB
//
//  Created by promatics on 4/7/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface EventViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logo_img;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *img_scrollView;
@property (weak, nonatomic) IBOutlet UILabel *listing_name;
@property (weak, nonatomic) IBOutlet UILabel *educator_name;
@property (weak, nonatomic) IBOutlet UILabel *course_tech;
@property (weak, nonatomic) IBOutlet UILabel *courses;
@property (weak, nonatomic) IBOutlet UILabel *main_lang;
@property (weak, nonatomic) IBOutlet UILabel *total_praises;
@property (weak, nonatomic) IBOutlet UILabel *total_reviews;
@property (weak, nonatomic) IBOutlet UILabel *total_purchased;
@property (weak, nonatomic) IBOutlet UITextView *lession_dscriptionTxtView;
@property (weak, nonatomic) IBOutlet UILabel *lession_category;
@property (weak, nonatomic) IBOutlet UILabel *lession_duration;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *lession_all_lang;
@property (weak, nonatomic) IBOutlet UIButton *pin_favBtn;
@property (weak, nonatomic) IBOutlet UIButton *report_abuseBtn;

@property (weak, nonatomic) IBOutlet UITableView *session_table;
@property (weak, nonatomic) IBOutlet UIView *review_view;
@property (weak, nonatomic) IBOutlet UITableView *review_table;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *message_btn;

- (IBAction)tapmessage_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *reportAbuse_btn;

- (IBAction)tapReportabuse_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *share_btn;

- (IBAction)tapShare_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *pinToFav_btn;
- (IBAction)tapPinToFav_btn:(id)sender;

- (IBAction)tapTermBtn:(id)sender;
- (IBAction)tapOtherFeesBtn:(id)sender;
- (IBAction)tapEditBt:(id)sender;
- (IBAction)tapPinToFav:(id)sender;
- (IBAction)tapReportAbuseBtn:(id)sender;
- (IBAction)tapPostBtn:(id)sender;

- (IBAction)tapTwitterBtn:(id)sender;
- (IBAction)tapFbBtn:(id)sender;
- (IBAction)tapLinkedInBtn:(id)sender;
- (IBAction)tapEmailBtn:(id)sender;
- (IBAction)tapMsgBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *type_lbl;
@property (strong, nonatomic) IBOutlet UILabel *language_lbl;
@property (strong, nonatomic) IBOutlet UIView *term_view;
@property (strong, nonatomic) IBOutlet UIButton *requestToEnrol_btn;
- (IBAction)tapRequestToEnrol_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *aboutEducatorBtn;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *eventDurationLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UILabel *teachingMethodLbl;
@property (weak, nonatomic) IBOutlet UILabel *referenceIDLbl;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *eventDetailsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *flagimg_view;
@property (weak, nonatomic) IBOutlet UIView *listing_view;
@property (weak, nonatomic) IBOutlet UILabel *eventDiscrp_lbl;


@end
