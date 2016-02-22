//
//  MyListingTableViewCell.m
//  ecaHUB
//
//  Created by promatics on 3/16/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "MyListingTableViewCell.h"

@implementation MyListingTableViewCell

@synthesize listing_name, business_name, post_date, expired, image_view, cat_name, check_Btn;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
