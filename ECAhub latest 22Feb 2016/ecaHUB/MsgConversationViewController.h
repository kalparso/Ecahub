//
//  MsgConversationViewController.h
//  ecaHUB
//
//  Created by promatics on 4/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface MsgConversationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RatingViewDelegate, UITextViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *msg_table;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *listing_name;
@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UIView *rating_view;
@property (weak, nonatomic) IBOutlet UITextView *msg_textView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwordBtn;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reportabuse_btn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *delete_btn;

@property (strong, nonatomic) RatingView *star_ratingView;
@property (nonatomic, readwrite) float rate_no;
- (IBAction)tapAbuse_btn:(id)sender;

- (IBAction)tapDeleteBtn:(id)sender;
-(void)setRating;

@property (weak, nonatomic) IBOutlet UIButton *warningBtn;

- (IBAction)tapWarningBtn:(id)sender;

- (IBAction)tapShareBtn:(id)sender;
- (IBAction)tapForwordBtn:(id)sender;
- (IBAction)tapReplyBtn:(id)sender;

@end


