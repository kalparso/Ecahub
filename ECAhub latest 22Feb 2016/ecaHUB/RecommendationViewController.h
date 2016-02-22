//
//  RecommendationViewController.h
//  ecaHUB
//
//  Created by promatics on 4/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendationViewController : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *date_submit;
@property (weak, nonatomic) IBOutlet UILabel *educator;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *district;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *date_join;
@property (weak, nonatomic) IBOutlet UIButton *send_requestBtn;

- (IBAction)addBtn:(id)sender;
- (IBAction)tapSendRequestBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lastNAme;
@property (strong, nonatomic) IBOutlet UILabel *firstName;

@property NSString *emailId;

@property NSDictionary *recDict;

@end
