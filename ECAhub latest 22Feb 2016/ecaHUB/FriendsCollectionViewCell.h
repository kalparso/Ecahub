//
//  FriendsCollectionViewCell.h
//  ecaHUB
//
//  Created by promatics on 9/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UIView *sub_view;
@property (weak, nonatomic) IBOutlet UILabel *name_Lbl;
@property (weak, nonatomic) IBOutlet UIButton *msg_btn;
@property (weak, nonatomic) IBOutlet UIView *star_View;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@end
