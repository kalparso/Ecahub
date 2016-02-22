//
//  MyRecommendationViewController.h
//  ecaHUB
//
//  Created by promatics on 4/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRecommendationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *recommdTable;
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIButton *addRecomm_btn;
@property (weak, nonatomic) IBOutlet UIButton *selectFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UITextField *filterTxtField;
@property (weak, nonatomic) IBOutlet UIButton *filterTableBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *add_btn;

- (IBAction)tapAddBtn:(id)sender;
- (IBAction)tapRecomBtn:(id)sender;

- (IBAction)tapSelectFilter:(id)sender;
- (IBAction)tapStatusBtn:(id)sender;
- (IBAction)tapRestBtn:(id)sender;
- (IBAction)tapFilterDataBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *search_btn;
- (IBAction)tapSearch_btn:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *filter_view;
@property (weak, nonatomic) IBOutlet UILabel *noDataLbl;

@end
