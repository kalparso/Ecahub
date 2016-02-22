//
//  InviteFriendsViewController.h
//  ecaHUB
//
//  Created by promatics on 8/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
- (IBAction)tap_LearnMoreBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *inviteThemBtn;
- (IBAction)tap_InviteThemBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *learnMoteBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *skipBtn;
- (IBAction)tap_skipBtn:(id)sender;

@end
