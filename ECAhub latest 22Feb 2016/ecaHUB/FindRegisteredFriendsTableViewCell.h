//
//  FindRegisteredFriendsTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 8/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindRegisteredFriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)tap_checkBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgview;

@end
