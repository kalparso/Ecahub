//
//  myFavTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 4/10/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myFavTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *listing_name;
@property (weak, nonatomic) IBOutlet UILabel *business_name;
@property (weak, nonatomic) IBOutlet UITextView *description_txtView;
@property (weak, nonatomic) IBOutlet UIButton *status_btn;
@property (strong, nonatomic) IBOutlet UIButton *fav_pin_btn;
@property (strong, nonatomic) IBOutlet UILabel *category_lbl;
@property (strong, nonatomic) IBOutlet UILabel *type_city_lbl;
@property (strong, nonatomic) IBOutlet UIButton *pinToFav_btn;
@property (strong, nonatomic) IBOutlet UIView *favTile_view;

@property (weak, nonatomic) IBOutlet UIView *sub_view;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *type_cityLbl;
@property (weak, nonatomic) IBOutlet UIButton *praiseIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *praise_count;

@end
