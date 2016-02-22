//
//  WhatsOnPostViewController.h
//  ecaHUB
//
//  Created by promatics on 4/16/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ListingViewController.h"
@interface WhatsOnPostViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UITabBarControllerDelegate,UITabBarDelegate,listingDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tble_view;

@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tapAddBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filter_btn;

- (IBAction)tap_filter_btn:(id)sender;
@end
