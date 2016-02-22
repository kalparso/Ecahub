//
//  SuggestionTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 5/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *listing_name;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;
@property (weak, nonatomic) IBOutlet UIView *listing_view;
@property (strong, nonatomic) IBOutlet UIButton *favPingray_bttn;
@property (strong, nonatomic) IBOutlet UILabel *category_lbl;
@property (strong, nonatomic) IBOutlet UILabel *type_city_lbl;
@property (weak, nonatomic) IBOutlet UILabel *educator_name;
@property (weak, nonatomic) IBOutlet UILabel *award_countLbl;
@property (weak, nonatomic) IBOutlet UIButton *award_btn;
@property (weak, nonatomic) IBOutlet UIButton *ViewMore_Btn;
@property (weak, nonatomic) IBOutlet UIView *moreBtn_view;

@end
