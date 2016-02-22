//
//  IncomeViewController.h
//  ecaHUB
//
//  Created by promatics on 5/13/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *incomeTabel_view;
@property (strong, nonatomic) IBOutlet UILabel *income_lbl;

@property (weak, nonatomic) IBOutlet UIButton *startDate;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;

- (IBAction)tapStartBtn:(id)sender;
- (IBAction)tapEndDate:(id)sender;
- (IBAction)tapFilterDateBtn:(id)sender;
- (IBAction)tapFilterBtn:(id)sender;

@end
