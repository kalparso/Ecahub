//
//  giveReview.m
//  ecaHUB
//
//  Created by promatics on 4/15/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "giveReview.h"
#import "WebServiceConnection.h"
#import "Indicator.h"

@interface giveReview() {
 
    WebServiceConnection *giveReviewConn;
    
    Indicator *indecator;
}
@end

@implementation giveReview

@synthesize review_txtView, reviewView, cancelBtn, submit_btn, list_id, type;

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
    giveReviewConn = [WebServiceConnection connectionManager];
    
    indecator = [[Indicator alloc] initWithFrame:self.bounds];
    
    review_txtView.text = @"Enter Review";
    
    reviewView.layer.cornerRadius = 10.0f;
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    submit_btn.layer.cornerRadius = 5.0f;
    
    CGRect frame = reviewView.frame;
    
    frame.size.width = self.frame.size.width - 80;
    
    reviewView.frame = frame;
    
    review_txtView.layer.cornerRadius = 5.0f;
    
    reviewView.layer.borderWidth = 1.0f;
    
    reviewView.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }

    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Enter Review"]) {
        
        textView.text = @"";
    }
        
    return true;
}

- (IBAction)tapCancelBtn:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)tapSubmitBtn:(id)sender {
    
    if ([review_txtView.text length] < 70) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please enter minimum 70 words" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    
    } else {
        
        [self addSubview:indecator];
        
        if ([type isEqualToString:@"Course"]) {
            
            type = @"1";
            
        } else if ([type isEqualToString:@"Lesson"]) {
            
            type = @"3";
            
        } else if ([type isEqualToString:@"Event"]) {
            
            type = @"2";
        }
        
        NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"content":review_txtView.text, @"type":type, @"list_id":list_id};
        
        [giveReviewConn startConnectionWithString:@"give_review" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
            
            [indecator removeFromSuperview];
            
            if ([giveReviewConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReviewNotification" object:nil];
                
                [self removeFromSuperview];
            }
        }];
    }
}
@end
