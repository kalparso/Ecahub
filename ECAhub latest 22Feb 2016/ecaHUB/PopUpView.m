//
//  PopUpView.m
//  ecaHUB
//
//  Created by promatics on 3/30/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "PopUpView.h"
#import "AddFriends.h"

@implementation PopUpView

@synthesize VC;

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

-(void)awakeFromNib{
    
    [self intializer];
    
}

-(void)intializer
{
    
    self.popview.layer.borderWidth = 1.0f;
    
    self.popview.layer.borderColor = [UIColor grayColor].CGColor;
    
        //self.submit.layer.borderWidth = 1.0f;
    //[self.submit setTitleColor:[UIColor blueColor ]forState:UIControlStateHighlighted];
    //self.submit.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //[self.submit setBackgroundColor : [UIColor redColor]];
    
   // CGRect frame = self.submit.frame;
    
   // frame.size.height = 30.0f;
    
    //self.submit.frame = frame;
    
    //CGRect frame1 = self.cancel.frame;
    
   // frame1.size.height = 30.0f;
    
    //self.cancel.frame = frame1;
    
    
//#pragma mark- uitextview delgate
    
    
    
       // [textview setText:@"fgdfc gcfgh cfghfgvhcghgvhfvghfgvhvvbhvj gvjgvhg jghvj ghvj bghjgh  "];
    // textview.text = @"bh vhc cghfghch gvhvghgvhvghfvghcghvghvh vghvg hvhjgv";
    
    
    
}



- (IBAction)OK:(id)sender {

    [self removeFromSuperview];
}

- (IBAction)LATER:(id)sender {
    
       if ([VC isEqualToString:@"1"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapLaterAddFamily" object:nil];
           
         //  [self removeFromSuperview];
        
    } else if ([VC isEqualToString:@"2"]) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapLaterAddFriends" object:nil];
        
     //   [self removeFromSuperview];
        
    } else if ([VC isEqualToString:@"3"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tapLaterSearchFriends" object:nil];
      //  [self removeFromSuperview];
    }
    
}

- (IBAction)CHECKBOX:(id)sender {
}
@end
