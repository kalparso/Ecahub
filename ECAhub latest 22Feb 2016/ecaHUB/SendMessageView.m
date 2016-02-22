//
//  SendMessageView.m
//  ecaHUB
//
//  Created by promatics on 4/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "SendMessageView.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "ListingViewController.h"

@interface SendMessageView () {
    
    WebServiceConnection *sendMsgConn,*getFriendsConn;
    
    NSArray *friendsArray;
    
    Indicator *indicator;
    
    Validation *validationObj;
}
@end

@implementation SendMessageView

@synthesize to_textField, subject, message, main_view, send_msgBtn, cancelBtn, view_frame,to_btn,message_textview,toMsg_btn,toTextField,send_btn,closeMsg_btn, scrollView,toMailId;

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
    
    sendMsgConn = [WebServiceConnection connectionManager];
    
    getFriendsConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.frame];
    
   // toMsg_btn.hidden = YES;    
    
   // scrollView.frame = self.frame;
    
   // scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height + 150);
    
    validationObj = [Validation validationManager];
}

-(void)intializer {
    
    subject.layer.cornerRadius = 5.0f;
    
    send_msgBtn.layer.cornerRadius = 5.0f;
    
    CGRect frame = subject.frame;
    frame.size.height = 31.0f;
    subject.frame = frame;
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    main_view.layer.cornerRadius = 10.0f;
    
    scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height+80);
    
    cancelBtn.hidden = YES;
}

#pragma mark - UITextfield Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    float y;
    
    y = textField.frame.origin.y - 70;
    
    if (y > 70) {
        
        CGRect frame = self.frame;
        
        frame.origin.y = -y;
        
        self.frame = frame;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    CGRect frame = self.frame;
    
    frame.origin.y = 0;
    
    self.frame = frame;
}

#pragma mark - UITextview Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"";
    }

    float y;
    
    y = textView.frame.origin.y - 100;
    
    CGRect frame = self.frame;
    
    frame.origin.y = -y;
    
    self.frame = frame;

    return true;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    CGRect frame = self.frame;
    
    frame.origin.y = 0;
    
    self.frame = frame;
}

- (IBAction)tapSendMsg:(id)sender {    
        
    NSString *to_msg = to_textField.text;
    
    if ([to_msg containsString:@", "]) {
        
        to_msg = [[NSUserDefaults standardUserDefaults] valueForKey:@"enquir_to"];
    }
    
    indicator = [[Indicator alloc] initWithFrame:view_frame];
    
    NSString *msg;
    
    if ([to_textField.text isEqualToString:@""]) {
        
        msg = @"Please enter valid email";
    
    } else if (![validationObj validateBlankField:subject.text]) {
        
        msg = @"Please enter the Subject";
    
    } else if ([message.text isEqualToString:@"Enter Message"]) {
        
        msg = @"Please enter message";
    }
    
    if ([msg length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
    
        [self addSubview:indicator];
    
        NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"email_to":to_textField.text, @"subject":subject.text, @"message_content":message.text};
    
        [sendMsgConn startConnectionWithString:@"send_message" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
            [indicator removeFromSuperview];
        
            if ([sendMsgConn responseCode] == 1) {
            
                NSLog(@"%@",receivedData);
                
                NSString *msg;
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 0) {
                    
                    msg = [[[receivedData valueForKey:@"error"]valueForKey:@"email_to"]objectAtIndex:0];
                
                } else {
                    
                    msg = [[[receivedData valueForKey:@"error"]valueForKey:@"email_to"] objectAtIndex:0];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchMessages" object:nil];
                    
                    [self removeFromSuperview];
                }                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }];
    }
}

- (IBAction)tapCancelBtn:(id)sender {
    
    [self removeFromSuperview];
}


- (IBAction)tapCloseBtn:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)tapSend_btn:(id)sender {
    
    NSString *to_msg = toTextField.text;
    
    if ([to_msg containsString:@", "]) {
        
        to_msg = [[NSUserDefaults standardUserDefaults] valueForKey:@"enquir_to"];
    }
    
    indicator = [[Indicator alloc] initWithFrame:view_frame];
    
    NSString *msg;
    
    if ([toTextField.text isEqualToString:@""]) {
        
        msg = @"Please enter valid email";
        
//    } else if (![validationObj validateBlankField:subject.text]) {
//        
//        msg = @"Please enter the Subject";
//        
//    }
    }else if (![validationObj validateBlankField:message_textview.text]) {
        
        msg = @"Please enter message";
    }
    
    if ([msg length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self addSubview:indicator];
        
        NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"email_to":toTextField.text, @"subject":@"subject", @"message_content":message_textview.text};
        
        [sendMsgConn startConnectionWithString:@"send_message" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([sendMsgConn responseCode] == 1) {
                
                NSLog(@"%@",receivedData);
                
                NSString *msg;
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 0) {
                    
                    msg = @"User email is not registered";
                    
                } else {
                    
                    msg = @"Your message has been sent successfully";
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchMessages" object:nil];
                    
                    [self removeFromSuperview];
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }];
    }
}

    

- (IBAction)tapCloseMsg_btn:(id)sender {
    
     [self removeFromSuperview];
}
@end

