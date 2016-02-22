//
//  SessionTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 3/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *session_name;
@property (weak, nonatomic) IBOutlet UILabel *session_date;
@property (weak, nonatomic) IBOutlet UIView *line_view;
@property (weak, nonatomic) IBOutlet UIView *sepertaor_view;
@property (weak, nonatomic) IBOutlet UIView *lineSeprater_view;
@end
