//
//  CourseDetailViewController.h
//  ecaHUB
//
//  Created by promatics on 3/25/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface CourseDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,MFMailComposeViewControllerDelegate>

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
@property (weak, nonatomic) IBOutlet UITextView *course_dscriptionTxtView;
@property (weak, nonatomic) IBOutlet UILabel *course_category;
@property (weak, nonatomic) IBOutlet UILabel *course_duration;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *course_all_lang;
@property (weak, nonatomic) IBOutlet UIButton *pin_favBtn;
@property (weak, nonatomic) IBOutlet UIButton *report_abuseBtn;

@property (weak, nonatomic) IBOutlet UITableView *session_table;
@property (weak, nonatomic) IBOutlet UIView *review_view;
@property (weak, nonatomic) IBOutlet UITableView *review_table;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (strong, nonatomic) IBOutlet UIButton *pinToFav_btn;
- (IBAction)tapPintpFav_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *message_btn;

- (IBAction)tapmessage_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *reportabuse_btn;

- (IBAction)tapReportabuse_btn:(id)sender;

- (IBAction)tapshare_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *share_btn;
@property (strong, nonatomic) IBOutlet UIView *term_view;

- (IBAction)tapTermBtn:(id)sender;
- (IBAction)tapOtherFeesBtn:(id)sender;
- (IBAction)tapEditBt:(id)sender;
- (IBAction)tapPinToFav:(id)sender;
- (IBAction)tapReportAbuse:(id)sender;
- (IBAction)tapPostBtn:(id)sender;

- (IBAction)tapTwitterBtn:(id)sender;
- (IBAction)tapFbBtn:(id)sender;
- (IBAction)tapLinkedInBtn:(id)sender;
- (IBAction)tapEmailBtn:(id)sender;
- (IBAction)tapMsgBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *type_lbl;
@property (strong, nonatomic) IBOutlet UILabel *language_lbl;
@property (strong, nonatomic) IBOutlet UIButton *reqestToEnrol_btn;
- (IBAction)tapRequestToEnrol_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *teachingMethod_lbl;
@property (weak, nonatomic) IBOutlet UILabel *courseDetailLbl;

//- (void)setupScrollView:(UIScrollView*)scrMain ;
@property (weak, nonatomic) IBOutlet UIView *detailview;
@property (weak, nonatomic) IBOutlet UILabel *sessionOptionLbl;
@property (weak, nonatomic) IBOutlet UIView *termsView;
@property (weak, nonatomic) IBOutlet UIView *reviews_view;
@property (weak, nonatomic) IBOutlet UILabel *course_dscriptionLbl;
@property (weak, nonatomic) IBOutlet UIButton *about_EducatorBtn;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIView *listingnmView;
@property (weak, nonatomic) IBOutlet UILabel *courseDescriptionLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImgView;
@property (weak, nonatomic) IBOutlet UILabel *category_lbl;
@property (weak, nonatomic) IBOutlet UILabel *courseDurationLbl;
@property (weak, nonatomic) IBOutlet UILabel *teachingMethodLbl;
@property (weak, nonatomic) IBOutlet UILabel *referenceID;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UIButton *right_Arrow;
@property (weak, nonatomic) IBOutlet UIButton *left_arrow;
- (IBAction)tap_left_arrow:(id)sender;
- (IBAction)tap_right_arrow:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *otherListingBtn;
- (IBAction)tap_otherListingBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *flagImg_view;

@end
