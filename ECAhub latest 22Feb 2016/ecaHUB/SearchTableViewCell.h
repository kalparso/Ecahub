//
//  SearchTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 4/15/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (strong, nonatomic) IBOutlet UIView *listing_view;
@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *listing_name;
@property (weak, nonatomic) IBOutlet UILabel *business_name;
@property (weak, nonatomic) IBOutlet UILabel *cat_name;
@property (weak, nonatomic) IBOutlet UILabel *post_date;
@property (weak, nonatomic) IBOutlet UILabel *expired;
@property (weak, nonatomic) IBOutlet UIButton *check_Btn;
@property (strong, nonatomic) IBOutlet UILabel *type_city_lbl;
@property (strong, nonatomic) IBOutlet UIButton *fave_pin_btn;
@property (strong, nonatomic) IBOutlet UILabel *category_lbl;
@property (strong, nonatomic) IBOutlet UILabel *expiry_lbl;
@property (strong, nonatomic) IBOutlet UILabel *post_lbl;
@property (strong, nonatomic) IBOutlet UILabel *reviewrecord_lbl;
@property (strong, nonatomic) IBOutlet UIButton *praise_btn;

@end
