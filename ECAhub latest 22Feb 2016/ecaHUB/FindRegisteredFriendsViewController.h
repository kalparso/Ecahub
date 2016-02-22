//
//  FindRegisteredFriendsViewController.h
//  ecaHUB
//
//  Created by promatics on 8/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindRegisteredFriendsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *tellThemBtn;
- (IBAction)tap_tellThemBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *learnMoreBtn;

- (IBAction)tap_learnMoreBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *skipBtn;
- (IBAction)tap_skipBtn:(id)sender;

@property bool isfb;

@end
