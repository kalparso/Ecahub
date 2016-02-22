//
//  MessageViewController.h
//  ecaHUB
//
//  Created by promatics on 4/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table_View;

@property (strong, nonatomic) IBOutlet UILabel *message_lbl;

@property (weak, nonatomic) IBOutlet UIButton *unreadMsgBtn;
@property (weak, nonatomic) IBOutlet UILabel *unreadMsg;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UILabel *numer_chat;
@property (weak, nonatomic) IBOutlet UIButton *send_msgBtn;
@property (weak, nonatomic) IBOutlet UIButton *user_btn;
@property (weak, nonatomic) IBOutlet UIButton *business_btn;
@property (strong, nonatomic) IBOutlet UIButton *delete_bttn;
- (IBAction)tapdelete_bttn:(id)sender;

- (IBAction)tapBusinessBtn:(id)sender;
- (IBAction)tapUserBtn:(id)sender;
- (IBAction)tapSeachBtn:(id)sender;
- (IBAction)tapNewMsgBtn:(id)sender;
- (IBAction)tapUnreadBtn:(id)sender;
- (IBAction)tapChatBtn:(id)sender;
- (IBAction)tapDeleteBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *reportAbuse_btn;
- (IBAction)tapAbuse_btn:(id)sender;

@end
