//
//  HomeFavoritesTableCell.h
//  ecaHUB
//
//  Created by promatics on 4/23/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeFavoritesTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *favImg_view;

@property (strong, nonatomic) IBOutlet UILabel *favListing_lbl;
@property (strong, nonatomic) IBOutlet UILabel *faveBusines_lbl;
//@property (strong, nonatomic) IBOutlet UITextView *favDescription_textview;
@property (strong, nonatomic) IBOutlet UIButton *favChk_bttn;
@property (strong, nonatomic) IBOutlet UILabel *favDescription_textview;

@property (strong, nonatomic) IBOutlet UIView *favView;

@property (strong, nonatomic) IBOutlet UIButton *favPin_bttn;
@property (strong, nonatomic) IBOutlet UILabel *category_lbl;
@property (strong, nonatomic) IBOutlet UILabel *type_city_lbl;
@property (weak, nonatomic) IBOutlet UILabel *award_countLbl;
@property (weak, nonatomic) IBOutlet UIButton *award_btn;
@property (weak, nonatomic) IBOutlet UIButton *viewMore_Btn;
@property (weak, nonatomic) IBOutlet UIView *MoreBtn_View;

@end
