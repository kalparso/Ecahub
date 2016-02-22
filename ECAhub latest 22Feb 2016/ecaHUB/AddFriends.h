//
//  AddFriends.h
//  ecaHUB
//
//  Created by promatics on 3/31/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import "YahooSDK.h"

@interface AddFriends : UIViewController <YahooSessionDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;

@property (strong, nonatomic) YahooSession *session;
@property (weak, nonatomic) IBOutlet UITableView *friendList_tbl;
@property (weak, nonatomic) IBOutlet UITableView *myFrnd_tbl;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendInvitationBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectAllFriendBtn;
@property (weak, nonatomic) IBOutlet UIButton *tellYourFrndBtn;

- (IBAction)tapTellYourFriendBtn:(id)sender;
- (IBAction)tapSelectAllFrndBtn:(id)sender;

- (IBAction)tapSendInvitaion:(id)sender;
- (IBAction)tapSelectAll:(id)sender;

- (IBAction)tapGmailBtn:(id)sender;
- (IBAction)tapYmailBtn:(id)sender;
- (IBAction)tapOutlokkBtn:(id)sender;
- (IBAction)tapHotmailBtn:(id)sender;
- (IBAction)tapSendBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *skipBtn;
- (IBAction)tap_skipBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *learnMoreBtn;
- (IBAction)tap_learnMoreBtn:(id)sender;

@end
