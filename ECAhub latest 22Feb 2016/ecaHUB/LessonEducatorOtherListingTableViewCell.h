//
//  LessonEducatorOtherListingTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 9/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonEducatorOtherListingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *listing_name;

@property (weak, nonatomic) IBOutlet UILabel *cat_name;

@property (strong, nonatomic) IBOutlet UILabel *type_city_lbl;



@property (weak, nonatomic) IBOutlet UIButton *praise_btn;
@property (weak, nonatomic) IBOutlet UILabel *praise_count;

@property (weak, nonatomic) IBOutlet UIButton *favpinBtn;
@property (weak, nonatomic) IBOutlet UILabel *educatorName;
@property (weak, nonatomic) IBOutlet UIView *subcellView;

@end
