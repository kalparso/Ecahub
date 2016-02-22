//
//  HomeMsgCellViewController.h
//  ecaHUB
//
//  Created by promatics on 4/23/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMsgCellViewController : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *msgImg_View;

@property (strong, nonatomic) IBOutlet UILabel *msgName_lbl;
@property (strong, nonatomic) IBOutlet UILabel *msgTime_lbl;
@property (strong, nonatomic) IBOutlet UILabel *msgSubjct_lbl;
@property (strong, nonatomic) IBOutlet UIImageView *arrow_imgView;
@property (strong, nonatomic) IBOutlet UILabel *message_lbl;
@property (strong, nonatomic) IBOutlet UIView *msgView;


@end
