//
//  myRecommTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 4/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myRecommTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date_submit;
@property (weak, nonatomic) IBOutlet UILabel *educator_name;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIButton *send_recommBtn;
@property (weak, nonatomic) IBOutlet UIView *main_view;

@end
