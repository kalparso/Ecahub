//
//  myMsgTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 4/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myMsgTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *msg_view;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIImageView *arrow_img;
@property (weak, nonatomic) IBOutlet UIView *background_view;

@end
