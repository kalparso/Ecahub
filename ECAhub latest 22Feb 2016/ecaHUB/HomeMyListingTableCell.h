//
//  HomeMyListingTableCell.h
//  ecaHUB
//
//  Created by promatics on 4/23/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMyListingTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *mylisting_imgview;
@property (strong, nonatomic) IBOutlet UIButton *listingchk_bttn;

@property (strong, nonatomic) IBOutlet UILabel *listingname_lbl;

@property (strong, nonatomic) IBOutlet UILabel *busines_lbl;

@property (strong, nonatomic) IBOutlet UILabel *listCategory_lbl;

@property (strong, nonatomic) IBOutlet UILabel *listpostdate_lbl;
@property (strong, nonatomic) IBOutlet UIView *listing_view;
@property (weak, nonatomic) IBOutlet UILabel *expireDate;


@end
