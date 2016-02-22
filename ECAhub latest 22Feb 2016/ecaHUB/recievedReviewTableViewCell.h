//
//  recievedReviewTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 12/4/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface recievedReviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UILabel *name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *date_lbl;
@property (weak, nonatomic) IBOutlet UILabel *comment_lbl;

@end
