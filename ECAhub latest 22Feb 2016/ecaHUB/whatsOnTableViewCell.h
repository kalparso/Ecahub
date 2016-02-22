//
//  whatsOnTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 4/16/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface whatsOnTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *listing_name;
@property (weak, nonatomic) IBOutlet UILabel *post_date;
@property (weak, nonatomic) IBOutlet UILabel *description_lbl;
@property (weak, nonatomic) IBOutlet UIButton *check_Btn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *Message_bttn;
@property (strong, nonatomic) IBOutlet UIButton *enroll_btnn;
@property (strong, nonatomic) IBOutlet UILabel *educatorname_lbl;
@property (strong, nonatomic) IBOutlet UILabel *expiry_lbl;
@property (strong, nonatomic) IBOutlet UIButton *favPin_btn;

@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIView *action_view;

@end
