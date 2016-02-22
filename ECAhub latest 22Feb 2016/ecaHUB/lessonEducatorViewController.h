//
//  lessonEducatorViewController.h
//  ecaHUB
//
//  Created by promatics on 4/4/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lessonEducatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *educator_imgView;
@property (weak, nonatomic) IBOutlet UIImageView *educator_image;
@property (weak, nonatomic) IBOutlet UILabel *educator_name;
@property (weak, nonatomic) IBOutlet UITextView *educator_description;
@property (weak, nonatomic) IBOutlet UILabel *total_praises;
@property (weak, nonatomic) IBOutlet UILabel *total_review;
@property (weak, nonatomic) IBOutlet UILabel *total_purchased;
@property (weak, nonatomic) IBOutlet UILabel *established_year;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *offers;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *sub_cat;
@property (weak, nonatomic) IBOutlet UILabel *location_lable;
@property (weak, nonatomic) IBOutlet UIView *sub_View;
@property (weak, nonatomic) IBOutlet UILabel *establisedLbl;
@property (weak, nonatomic) IBOutlet UILabel *offersLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UILabel *achivments_lbl;
@property (weak, nonatomic) IBOutlet UIView *awards_view;
@property (weak, nonatomic) IBOutlet UILabel *otherListingLbl;
@property (weak, nonatomic) IBOutlet UITableView *listing_table;
@property (weak, nonatomic) IBOutlet UIImageView *profile_view;
@property (weak, nonatomic) IBOutlet UIView *picture_view;

@end
