//
//  TextReviewTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 5/7/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextReviewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *listingname_lbl;

@property (strong, nonatomic) IBOutlet UILabel *category_lbl;
@property (strong, nonatomic) IBOutlet UIImageView *ReviewImg_view;

@property (strong, nonatomic) IBOutlet UIView *list_view;
@property (strong, nonatomic) IBOutlet UIButton *check_bttn;
@property (strong, nonatomic) IBOutlet UITextView *reviewText_view;
@property (strong, nonatomic) IBOutlet UIButton *giveReview_bttn;

@property (strong, nonatomic) IBOutlet UIButton *praiseIt_bttn;

@property (strong, nonatomic) IBOutlet UILabel *emptyreview_lbl;

@end

