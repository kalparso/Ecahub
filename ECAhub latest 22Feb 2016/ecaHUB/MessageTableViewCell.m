//
//  MessageTableViewCell.m
//  ecaHUB
//
//  Created by promatics on 4/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell () {
    
    RatingView *back_StarView;
    
    CGFloat star_width;
}
@end

@implementation MessageTableViewCell

@synthesize rate_no, rating_view, star_ratingView;

- (void)awakeFromNib {
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        star_width = 16.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        star_width = 14.0f;
        
    }
    
    back_StarView = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, rating_view.frame.size.width, rating_view.frame.size.height) numberOfStar:0 starWidth:star_width];
    
    back_StarView.userInteractionEnabled = NO;
    
    back_StarView.delegate =self;
    
    [rating_view addSubview:back_StarView];
}

-(void)setRating{
    
    [star_ratingView removeFromSuperview];
    
    star_ratingView = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, ((star_width +1.3) * rate_no) - rate_no, rating_view.frame.size.height) numberOfStar:rate_no starWidth:star_width];
    
    star_ratingView.userInteractionEnabled = NO;
    
    star_ratingView.delegate =self;
    
    [rating_view addSubview:star_ratingView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
