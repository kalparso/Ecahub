//
//  MyWhtsOnListingTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 5/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWhtsOnListingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *listing_name;
@property (weak, nonatomic) IBOutlet UILabel *post_date;
@property (weak, nonatomic) IBOutlet UILabel *description_lbl;
@property (weak, nonatomic) IBOutlet UIButton *check_Btn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIView *action_view;
@property (weak, nonatomic) IBOutlet UIButton *pay_btn;

@property (strong, nonatomic) IBOutlet UILabel *edit_lbl;
@property (strong, nonatomic) IBOutlet UILabel *post_lbl;

@property (strong, nonatomic) IBOutlet UILabel *delete_lbl;

@property (strong, nonatomic) IBOutlet UILabel *share_lbl;

@property (strong, nonatomic) IBOutlet UILabel *expirydate_lbl;

@property (strong, nonatomic) IBOutlet UILabel *educator_lbl;

@property (weak, nonatomic) IBOutlet UILabel *post_date_label;

@end
