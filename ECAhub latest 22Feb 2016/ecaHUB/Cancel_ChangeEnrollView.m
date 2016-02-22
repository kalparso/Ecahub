//
//  Cancel_ChangeEnrollView.m
//  ecaHUB
//
//  Created by promatics on 6/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "Cancel_ChangeEnrollView.h"

@interface Cancel_ChangeEnrollView () {
    
    CGFloat main_y;
}
@end

@implementation Cancel_ChangeEnrollView

@synthesize main_view, close_btn, confirm_Btn, list_name, title, session_btn, session_name, member, student, date, message, amount_txtField, scroll_view,selctDay_btn,selctDay_lbl;

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
    
    main_y = main_view.frame.origin.y;
    
    confirm_Btn.layer.cornerRadius = 5.0f;    
    close_btn.layer.cornerRadius = 5.0f;
    main_view.layer.cornerRadius = 10.0f;
    
    session_btn.layer.borderWidth = 1.0f;
    session_btn.layer.cornerRadius = 5.0f;
    session_btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    selctDay_btn.layer.borderWidth = 1.0f;
    selctDay_btn.layer.cornerRadius = 5.0f;
    selctDay_btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    amount_txtField.layer.cornerRadius = 5.0f;
    amount_txtField.layer.borderWidth = 1.0f;
    amount_txtField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    message.layer.cornerRadius = 5.0f;
    message.layer.borderWidth = 1.0f;
    message.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.scroll_view.frame = self.frame;
    
 //   self.scroll_view.contentSize = CGSizeMake(self.frame.size.width, self.main_view.frame.origin.y+self.main_view.frame.size.height +60);

  //  scroll_view.contentSize = CGSizeMake(self.frame.size.width, 700);
}

#pragma mark - UITextfield Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    float y;
    
    y = textField.frame.origin.y - textField.frame.size.height - 30;
        
    CGRect frame = self.main_view.frame;
        
    frame.origin.y = y;
        
    self.main_view.frame = frame;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    CGRect frame = self.main_view.frame;
    
    frame.origin.y = main_y;
    
    self.main_view.frame = frame;
}

#pragma mark - UITextview Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Enter Message"]) {
        
        textView.text = @"";
    }
    
    float y;
    
    y = textView.frame.origin.y - textView.frame.size.height - 30;
    
    CGRect frame = self.main_view.frame;
    
    frame.origin.y =  y;
    
    self.main_view.frame = frame;
    
    return true;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    CGRect frame = self.main_view.frame;
    
    frame.origin.y = main_y;
    
    self.main_view.frame = frame;
    
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"Enter Message";
    }
}

- (IBAction)tapCloseBtn:(id)sender {
    
    [self removeFromSuperview];
}
@end
