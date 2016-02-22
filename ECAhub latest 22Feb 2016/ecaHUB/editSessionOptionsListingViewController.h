//
//  editSessionOptionsListingViewController.h
//  ecaHUB
//
//  Created by promatics on 11/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface editSessionOptionsListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listing_tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *add_barbutton;
- (IBAction)tap_add_barbutton:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *donebutton;
- (IBAction)tap_donebutton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *info_lbl;

@property NSString *listing_type;

@property NSInteger type;

@end
