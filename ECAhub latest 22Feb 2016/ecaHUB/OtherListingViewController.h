//
//  OtherListingViewController.h
//  ecaHUB
//
//  Created by promatics on 9/18/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Social/Social.h>
@interface OtherListingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listing_table;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filter_btn;
- (IBAction)tap_filterBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;

- (IBAction)tapAddBtn:(id)sender;

@end

