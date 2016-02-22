//
//  FindFriendsViewController.h
//  ecaHUB
//
//  Created by promatics on 8/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import "YahooSDK.h"

@interface FindFriendsViewController : UIViewController<YahooSessionDelegate>

@property (strong, nonatomic) YahooSession *session;
@property (weak, nonatomic) IBOutlet UIButton *gmailBtn;
@property (weak, nonatomic) IBOutlet UIButton *yahooBtn;
@property (weak, nonatomic) IBOutlet UIButton *outlookBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotmailBtn;
- (IBAction)tap_gmailBtn:(id)sender;
- (IBAction)tap_yahooBtn:(id)sender;
- (IBAction)tap_outlookBtn:(id)sender;
- (IBAction)tap_hotmailBtn:(id)sender;


@end
