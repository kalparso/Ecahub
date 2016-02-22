//
//  PaypalAccountViewController.h
//  ecaHUB
//
//  Created by promatics on 5/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaypalAccountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbl_view;

- (IBAction)tapAddAccountBtn:(id)sender;

@end
