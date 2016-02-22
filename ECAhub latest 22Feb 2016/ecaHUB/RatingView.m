//
//  RatingView.m
//  ecaHUB
//
//  Created by promatics on 4/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "RatingView.h"

@interface RatingView (){
    
    float rate_no;
}

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;


@end

@implementation RatingView

@synthesize numberOfStar, star_width;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:NUMBER_OF_STAR starWidth:25];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    numberOfStar = NUMBER_OF_STAR;
    
    [self commonInit];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(float)number starWidth:(float)starWidth
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        numberOfStar = number;
        
        rate_no = numberOfStar;
        
        star_width = starWidth;
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    if (numberOfStar == 0) {
        
        numberOfStar = 5.0;
        
        self.starBackgroundView = [self buidlStarViewWithImageName:BACKGROUND_STAR];
        
        [self addSubview:self.starBackgroundView];
        
    }  else {
        
        self.starForegroundView = [self buidlStarViewWithImageName:FOREGROUND_STAR];
        
        numberOfStar =rate_no;
        
        [self addSubview:self.starForegroundView];
        
    }
}

#pragma mark - Set Score

- (void)setScore:(float)score withAnimation:(bool)isAnimate
{
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion
{
    NSAssert((score >= 0)&&(score <= 1), @"score must be between 0 and 1");
    
    if (score < 0)
              {
        score = 0;
              }
    
    if (score > 1)
              {
        score = 1;
              }
    
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate)
              {
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^
         {
   
   [weakSelf changeStarForegroundViewWithPoint:point];
   
         } completion:^(BOOL finished)
         {
   if (completion)
             {
       completion(finished);
             }
         }];
              }
    else
              {
        [self changeStarForegroundViewWithPoint:point];
              }
}

#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    if(CGRectContainsPoint(rect,point))
              {
        
        [self changeStarForegroundViewWithPoint:point];
              }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^
     {
[weakSelf changeStarForegroundViewWithPoint:point];

     }];
}

#pragma mark - Buidl Star View

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    view.clipsToBounds = YES;
    
    for (int i = 0; i < self.numberOfStar; i ++)
              {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        
        imageView.frame = CGRectMake((i * star_width)+1, 0, star_width, frame.size.height);
        
        [view addSubview:imageView];
        
              }
    return view;
}

#pragma mark - Change Star Foreground With Point

- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
              {
        p.x = 0;
              }
    
    if (p.x > self.frame.size.width)
              {
        p.x = self.frame.size.width;
              }
    
    NSString * str = [NSString stringWithFormat:@"%0.1f",p.x / self.frame.size.width];
    
    float score = [str floatValue];
    
    p.x = score * self.frame.size.width;
    
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
              {
        [self.delegate starRatingView:self score:score];
              }
}

@end
