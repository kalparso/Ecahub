//
//  AddRecommendationViewController.m
//  ecaHUB
//
//  Created by promatics on 4/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AddRecommendationViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "RecommendationViewController.h"

@interface AddRecommendationViewController () {
    
    WebServiceConnection *sendRecommConn;
    
    Indicator *indicator;
    
    Validation *validationObj;
}
@end

@implementation AddRecommendationViewController

@synthesize scrollView, educator_name, city, email, district, sendRecommBtn,firstname_textfield,lastname_textfield;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    sendRecommConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    validationObj = [Validation validationManager];
    
    sendRecommBtn.layer.cornerRadius = 5.0f;
    
    scrollView.frame = self.view.frame;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+70);
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGFloat hieght = 45.0f;
        
        CGRect frameRect = email.frame;
        frameRect.size.height = hieght;
        email.frame = frameRect;
        
        frameRect = firstname_textfield.frame;
        frameRect.size.height = hieght;
        firstname_textfield.frame = frameRect;
        
        frameRect = lastname_textfield.frame;
        frameRect.size.height = hieght;
        lastname_textfield.frame = frameRect;
        
        CGRect frameRect1 = educator_name.frame;
        frameRect1.size.height = hieght;
        educator_name.frame = frameRect1;
        
        CGRect frameRect2 = city.frame;
        frameRect2.size.height = hieght;
        city.frame = frameRect2;
        
        CGRect frameRect3 = district.frame;
        frameRect3.size.height = hieght;
        district.frame = frameRect3;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
//        scrollView.frame = self.view.frame;
//        
//        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 900);
    }
    
    city.layer.cornerRadius = 5.0f;
    
    city.layer.borderWidth = 0.5f;
    
    city.layer.borderColor = [UIColor blackColor].CGColor;
    
    email.layer.cornerRadius = 5.0f;
    
    email.layer.borderWidth = 0.5f;
    
    email.layer.borderColor = [UIColor blackColor].CGColor;
    
    firstname_textfield.layer.cornerRadius = 5.0f;
    
    firstname_textfield.layer.borderWidth = 0.5f;
    
    firstname_textfield.layer.borderColor = [UIColor blackColor].CGColor;
    
    lastname_textfield.layer.cornerRadius = 5.0f;
    
    lastname_textfield.layer.borderWidth = 0.5f;
    
    lastname_textfield.layer.borderColor = [UIColor blackColor].CGColor;
    
    educator_name.layer.cornerRadius = 5.0f;
    
    educator_name.layer.borderWidth = 0.5f;
    
    educator_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    district.layer.cornerRadius = 5.0f;
    
    district.layer.borderWidth = 0.5f;
    
    district.layer.borderColor = [UIColor blackColor].CGColor;
    
    CGRect frame = sendRecommBtn.frame;
    
    frame.origin.x = (self.view.frame.size.width - frame.size.width)/2;
    
    sendRecommBtn.frame = frame;
}

#pragma mark - UITextfield Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    

    [textField resignFirstResponder];
    
   if (textField == email) {
    
        [self tapRecommBtn:textField];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = textField.text;
    
    if (textField == email) {
        
        
    } else {
    
        if ([textField.text length] == 1) {
        
            textField.text = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
        }
    }
    return true;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGFloat y = textField.frame.origin.y;
    
    y = self.view.frame.size.height - y;
    
    if (y < 70) {
        
        scrollView.frame = CGRectMake(0, -40, self.view.frame.size.width, self.view.frame.size.height);
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)tapRecommBtn:(id)sender {
    
    NSString *message;
    
//    if (![validationObj validateBlankField:firstname_textfield.text]) {
//    
//        message = @"Please enter first name.";
//  
//    } else if (![validationObj validateBlankField:lastname_textfield.text]) {
//        
//        message = @"Please enter last name.";
//    
//    } else
    if (![validationObj validateBlankField:educator_name.text]) {
    
        message = @"Please enter educator name.";
        
    } else if (![validationObj validateBlankField:city.text]) {
        
        message = @"Please enter city.";
        
//    } else if (![validationObj validateBlankField:district.text]) {
//        
//        message = @"Please enter Suburb or District.";
//        
    } else if (![validationObj validateEmail:email.text]) {
        
        message = @"Please enter a valid email address.";
    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.view addSubview:indicator];

        NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"rec_email":email.text, @"sender_first_name":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"], @"name":educator_name.text, @"city":city.text, @"district":district.text,@"first_name":firstname_textfield.text,@"last_name":lastname_textfield.text};
        
        [sendRecommConn startConnectionWithString:@"send_recommendation" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([sendRecommConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Thank you for recommending this educator to ECAhub. It helps students get in touch with more educators. Plus, as soon as they join you receive another point towards your star awards." delegate:nil cancelButtonTitle:@"OK Thanks" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                
                } else {
                    
                    id msg = [[[receivedData valueForKey:@"error"] valueForKey:@"rec_email"] objectAtIndex:0];
                    
                    if ([msg length] > 1) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"You have already recommended this educator." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alert show];
                        
                        educator_name.text = @"";
                        city.text = @"";
                        district.text = @"";
                        email.text = @"";
                    }
                }}
        }];
    }
}

@end

