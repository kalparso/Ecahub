//
//  viewMyEnrollView.m
//  ecaHUB
//
//  Created by promatics on 6/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "viewMyEnrollView.h"

@implementation viewMyEnrollView

@synthesize scroll_view, main_view;

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self intializer];
    }
    return self;
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self intializer];
    }
    return self;
}

-(void)awakeFromNib {
    
    [self intializer];
}

-(void)intializer {
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
                
        scroll_view.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scroll_view.contentSize = CGSizeMake(self.frame.size.width, 900);
    }
    
    main_view.layer.cornerRadius = 5.0f;
    main_view.layer.masksToBounds = YES;
}

- (IBAction)tapCloseBtn:(id)sender {
    
    [self removeFromSuperview];
}
@end
