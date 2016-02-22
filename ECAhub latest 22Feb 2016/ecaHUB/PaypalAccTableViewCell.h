//
//  PaypalAccTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 5/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaypalAccTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sr_no;
@property (weak, nonatomic) IBOutlet UILabel *account_id;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *delete_btn;

@end
