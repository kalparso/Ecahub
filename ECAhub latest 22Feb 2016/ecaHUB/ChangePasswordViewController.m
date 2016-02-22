//
//  ChangePasswordViewController.m
//  ecaHUB
//
//  Created by promatics on 3/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"

@interface ChangePasswordViewController () {
    
    WebServiceConnection *changePswdConnection;
    
    Indicator *indicator;
    
    Validation *validationObj;
}
@end

@implementation ChangePasswordViewController

@synthesize current_password, password_new, confirm_password, saveBtn, cancelBtn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     //self.navigationController.navigationBar.topItem.title = @"";
    
    saveBtn.layer.cornerRadius = 10.0f;
    
    cancelBtn.layer.cornerRadius = 10.0f;
    
    current_password.layer.cornerRadius = 5.0f;
    password_new.layer.cornerRadius = 5.0f;
    confirm_password.layer.cornerRadius = 5.0f;

    
    current_password.layer.borderWidth = 1.0f;
    password_new.layer.borderWidth = 1.0f;
    confirm_password.layer.borderWidth = 1.0f;
    
    current_password.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    password_new.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    confirm_password.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    changePswdConnection = [WebServiceConnection connectionManager];
    
    validationObj = [Validation validationManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGFloat hieght = 45.0f;
        
        CGRect frameRect = current_password.frame;
        frameRect.size.height = hieght;
        current_password.frame = frameRect;
        
        frameRect = password_new.frame;
        frameRect.size.height = hieght;
        password_new.frame = frameRect;
        
        frameRect = confirm_password.frame;
        frameRect.size.height = hieght;
        confirm_password.frame = frameRect;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
    }
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    saveBtn.layer.cornerRadius = 5.0f;
}

- (IBAction)tappedSaveBtn:(id)sender {
    
    NSString *message;
    
    if (![validationObj validateBlankField:current_password.text]) {
        
        message = @"Please enter current password";
        
    } else if (![validationObj validatePassword:password_new.text]) {
        
        message = @"Password should be 6 charcters long";
    
    } else if (![validationObj validateString:password_new.text equalTo:confirm_password.text]) {
        
        message =@"New password & confirm password don't match";
    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    
    } else {
        
        [self.view addSubview:indicator];

        NSDictionary *paramURL = @{@"id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo" ] valueForKey:@"Member"] valueForKey:@"id"], @"old_password" : current_password.text, @"new_password" : password_new.text, @"confirm_password" : confirm_password.text};
        
        [changePswdConnection startConnectionWithString:[NSString stringWithFormat:@"change_password"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            if ([changePswdConnection responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                [indicator removeFromSuperview];
                
                NSString *msg;
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                    
                    msg = @"Successfully saved. You can now use this password to Log In.";
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                } else {
                    
                    msg = [[[receivedData valueForKey:@"error"] valueForKey:@"old_password"] objectAtIndex:0];
                }
                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                
            }
        }];
    }
    
}

- (IBAction)tappedCancelBtn:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - TextFiel Delegates & Datasources

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == confirm_password) {
        
        [textField becomeFirstResponder];
        
        [self tappedSaveBtn:self];
        
    } else if (textField == current_password) {
        
        [password_new becomeFirstResponder];
        
    } else if (textField == password_new) {
        
        [confirm_password becomeFirstResponder];
    }
    
    return TRUE;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
