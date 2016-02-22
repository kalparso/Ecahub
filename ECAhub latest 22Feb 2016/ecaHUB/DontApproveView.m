//
//  DontApproveView.m
//  ecaHUB
//
//  Created by promatics on 6/29/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "DontApproveView.h"

@implementation DontApproveView

@synthesize main_view, submit_btn, closeBtn, message_txtView;

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
    
    closeBtn.layer.cornerRadius = 5.0f;
    submit_btn.layer.cornerRadius = 5.0f;
    main_view.layer.cornerRadius = 10.0f;
    
    message_txtView.layer.borderWidth = 1.0f;
    message_txtView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    message_txtView.layer.cornerRadius = 5.0f;
    message_txtView.layer.masksToBounds = YES;
    
}

#pragma mark - UITextview Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Please provide a rejection reason"]) {
        
        textView.text = @"";
    }
    
//    float y;
//    
//    y = textView.frame.origin.y - textView.frame.size.height - 30;
//    
//    CGRect frame = self.main_view.frame;
//    
//    frame.origin.y =  y;
//    
//    self.main_view.frame = frame;
    
    return true;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
//    CGRect frame = self.main_view.frame;
//    
//    frame.origin.y = main_y;
//    
//    self.main_view.frame = frame;
    
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"Please provide a rejection reason";
    }
}


- (IBAction)tapCloseBtn:(id)sender {
    
    [self removeFromSuperview];
}

@end


