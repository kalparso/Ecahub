//
//  ViewBusinessProfileViewController.h
//  ecaHUB
//
//  Created by promatics on 7/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewBusinessProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *sub_view;
@property (weak, nonatomic) IBOutlet UILabel *offr_lbl;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *educator_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *educator_image;
@property (weak, nonatomic) IBOutlet UILabel *educator_name;
@property (weak, nonatomic) IBOutlet UILabel *educator_description;
@property (weak, nonatomic) IBOutlet UILabel *established_year;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *offers;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *country;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *businesType;
- (IBAction)tapEditBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *yearStatic_lbl;

@end
