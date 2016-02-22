//
//  recievedReviewViewController.h
//  ecaHUB
//
//  Created by promatics on 12/4/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recievedReviewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIImageView *list_img_view;
@property (weak, nonatomic) IBOutlet UIButton *chech_btn;
- (IBAction)tap_check_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *desc_lbl;
@property (weak, nonatomic) IBOutlet UILabel *no_review_lbl;
@property (weak, nonatomic) IBOutlet UITableView *reviewTable;

@property NSString *list_type;

@property NSString *list_id;

@property NSString *listName;

@property NSString *url;

@property NSString *status;

@property NSString *desc;

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;


@end
