//
//  DashboardTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 3/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *title_lable;
@property (weak, nonatomic) IBOutlet UILabel *total_numbers;
@property (strong, nonatomic) IBOutlet UIButton *addSign_btn;




@end
