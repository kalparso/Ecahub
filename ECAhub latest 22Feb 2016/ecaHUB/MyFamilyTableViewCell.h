//
//  MyFamilyTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 3/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFamilyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *member_img;
@property (weak, nonatomic) IBOutlet UILabel *f_name;
@property (weak, nonatomic) IBOutlet UILabel *l_name;
@property (weak, nonatomic) IBOutlet UILabel *dob;
@property (weak, nonatomic) IBOutlet UILabel *interestIn;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (strong, nonatomic) IBOutlet UIView *img_view;
@property (strong, nonatomic) IBOutlet UILabel *gender;

@end
