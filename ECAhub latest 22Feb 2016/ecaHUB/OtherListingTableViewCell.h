//
//  OtherListingTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 9/18/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherListingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *listing_name;
@property (weak, nonatomic) IBOutlet UILabel *business_name;
@property (weak, nonatomic) IBOutlet UILabel *cat_name;
@property (weak, nonatomic) IBOutlet UILabel *post_date;
@property (weak, nonatomic) IBOutlet UILabel *expired;
@property (weak, nonatomic) IBOutlet UIButton *check_Btn;
@property (strong, nonatomic) IBOutlet UILabel *postDate_lbl;

@property (strong, nonatomic) IBOutlet UILabel *type_city_lbl;

@property (strong, nonatomic) IBOutlet UILabel *expiry_lbl;

@property (strong, nonatomic) IBOutlet UIButton *view_bttn;
@property (strong, nonatomic) IBOutlet UIButton *edit_bttn;
@property (strong, nonatomic) IBOutlet UIView *button_view;

@property (strong, nonatomic) IBOutlet UIButton *delete_btn;

@property (strong, nonatomic) IBOutlet UIButton *post_bttn;
@property (strong, nonatomic) IBOutlet UIButton *review_bttn;
@property (strong, nonatomic) IBOutlet UIButton *share_btnn;




@end

