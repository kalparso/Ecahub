//
//  ForgotPasswordViewController.m
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"

@interface ForgotPasswordViewController (){
    
    WebServiceConnection *forgotPswdConnection;
    
    Indicator *indicator;
    
    Validation *validation;
}
@end

@implementation ForgotPasswordViewController

@synthesize submitBtn, emailTxtField;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     //self.navigationController.navigationBar.topItem.title = @"";
    
    submitBtn.layer.cornerRadius = 5.0f;
    
    forgotPswdConnection = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    validation = [Validation validationManager];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGFloat hieght = 45.0f;
        
        CGRect frameRect = emailTxtField.frame;
        
        frameRect.size.height = hieght;
        
        emailTxtField.frame = frameRect;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
    }
    
    emailTxtField.layer.borderWidth = 0.5f;
    emailTxtField.layer.cornerRadius = 5.0f;
    emailTxtField.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedSubmitBtn:(id)sender {
    
    NSString *message;
    
    if (![validation validateEmail:emailTxtField.text]) {
      
        message = @"Please enter valid email";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        emailTxtField.text = @"";
        
    } else {
        
        NSDictionary *urlParam = @{@"email_id" : emailTxtField.text};
        
        [self.view addSubview:indicator];
        
        [forgotPswdConnection startConnectionWithString:[NSString stringWithFormat:@"forgot_password"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([forgotPswdConnection responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                NSString *message;
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                    
                    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:0] animated:YES];
                                      
                    message = [[@"A link to reset your password has been sent to " stringByAppendingString:emailTxtField.text]stringByAppendingString:@". If it's not in your inbox, it may be in junk mail."];
                    
                    emailTxtField.text = @"";
                
                } else {
                    
                    emailTxtField.text = @"";
                    
                    message = @"Entered email doesn't exists";
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
                [alert show];
            }
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return TRUE;
}

@end
