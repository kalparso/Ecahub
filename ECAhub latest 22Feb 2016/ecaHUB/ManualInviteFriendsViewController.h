//
//  ManualInviteFriendsViewController.h
//  ecaHUB
//
//  Created by promatics on 8/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualInviteFriendsViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UIButton *sendInviteBtn;
- (IBAction)tap_sendInviteBTn:(id)sender;
- (IBAction)tap_skipBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *skipBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
