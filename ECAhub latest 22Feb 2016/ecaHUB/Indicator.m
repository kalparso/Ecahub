//
//  Indicator.m
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "Indicator.h"

@implementation Indicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.0];
        //self.backgroundColor = [UIColor whiteColor];

        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        //[_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView setCenter: self.center];
        //_indicatorView.color = UIColorFromRGB(title_color_hexcode);//[UIColor whiteColor];
        
        _indicatorView.layer.cornerRadius = 5.0;
        _indicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];//UIColorFromRGB(text_color_hexcode);
        [_indicatorView startAnimating];
        [self addSubview:_indicatorView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, 100, 20)];
        //label.text = @"Loading...";
        label.textAlignment = NSTextAlignmentCenter;
        //label.textColor = UIColorFromRGB(title_color_hexcode);//[UIColor whiteColor];
        [_indicatorView addSubview:label];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
