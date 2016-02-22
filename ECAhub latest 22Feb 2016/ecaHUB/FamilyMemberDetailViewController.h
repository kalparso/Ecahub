//
//  FamilyMemberDetailViewController.h
//  ecaHUB
//
//  Created by promatics on 3/13/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyMemberDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *img_view;
@property (weak, nonatomic) IBOutlet UIImageView *member_img;
@property (weak, nonatomic) IBOutlet UILabel *f_name;
@property (weak, nonatomic) IBOutlet UILabel *family_name;
@property (weak, nonatomic) IBOutlet UILabel *dob;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UIView *line_view;
@property (weak, nonatomic) IBOutlet UIButton *editBn;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll_view;

@end
