//
//  RegistrationViewController.m
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "RegistrationViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TabBarViewController.h"
#import "LetsStart.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface RegistrationViewController () {
    
    WebServiceConnection *registrationConnection;
    
    Indicator *indicator;
    
    Validation *validationObj;
    
    id activeField;
}
@end

@implementation RegistrationViewController

@synthesize firstNameTxtField, last_nameTxtField, emailTxtField, passwordTxtField, confirm_pswdTxtField, FacebookBtn, LinkedInBtn, scrollView, creatAccountBtn, orView, Term_Con_Btn, fbSignUpView, fb_img;

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    registrationConnection = [WebServiceConnection connectionManager];
    
    validationObj = [Validation validationManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    [scrollView addGestureRecognizer:tapScroll];
    
    [self prepareInterface];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Gmail"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PayPal"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Hotmail"];
    
    scrollView.frame = self.view.frame;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

-(void) prepareInterface {
    
    fb_img.image = [UIImage imageNamed:@"facebook"];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        orView.layer.cornerRadius = 30.0f;
        
        CGFloat hieght = 45.0f;
        
        CGRect frameRect = emailTxtField.frame;
        frameRect.size.height = hieght;
        emailTxtField.frame = frameRect;
        
        CGRect frameRect1 = firstNameTxtField.frame;
        frameRect1.size.height = hieght;
        firstNameTxtField.frame = frameRect1;
        
        CGRect frameRect2 = last_nameTxtField.frame;
        frameRect2.size.height = hieght;
        last_nameTxtField.frame = frameRect2;
        
        CGRect frameRect3 = passwordTxtField.frame;
        frameRect3.size.height = hieght;
        passwordTxtField.frame = frameRect3;
        
        CGRect frameRect4 = confirm_pswdTxtField.frame;
        frameRect4.size.height = hieght;
        confirm_pswdTxtField.frame = frameRect4;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        orView.layer.cornerRadius = 20.0f;
    }
    
    NSMutableAttributedString *mes1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"By clicking Create Account, you agree to ECAhub's "] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSMutableAttributedString *mes2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Terms & Conditions "] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Text_colore"]]}];
    
    NSMutableAttributedString *mes3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"and "] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    NSMutableAttributedString *mes4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Privacy Policy"] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Text_colore"]]}];
    
    [mes1 appendAttributedString:mes2];
    
    [mes1 appendAttributedString:mes3];
    
    [mes1 appendAttributedString:mes4];
    
    [Term_Con_Btn setAttributedTitle:mes1 forState:UIControlStateNormal];
    
    FacebookBtn.layer.cornerRadius = 5.0f;
    
    LinkedInBtn.layer.cornerRadius = 5.0f;
    
    creatAccountBtn.layer.cornerRadius = 5.0f;
    
    emailTxtField.layer.borderWidth = 0.5f;
    emailTxtField.layer.cornerRadius = 5.0f;
    emailTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    firstNameTxtField.layer.borderWidth = 0.5f;
    firstNameTxtField.layer.cornerRadius = 5.0f;
    firstNameTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    last_nameTxtField.layer.borderWidth = 0.5f;
    last_nameTxtField.layer.cornerRadius = 5.0f;
    last_nameTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    passwordTxtField.layer.borderWidth = 0.5f;
    passwordTxtField.layer.cornerRadius = 5.0f;
    passwordTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    confirm_pswdTxtField.layer.borderWidth = 0.5f;
    confirm_pswdTxtField.layer.cornerRadius = 5.0f;
    confirm_pswdTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
}

- (IBAction)tappedCreateAccBtn:(id)sender {
    
    validationObj = [[Validation alloc] init];
    
    NSString *message;
    
    if (![validationObj validateBlankField:firstNameTxtField.text]) {
        
        message = @"Please enter letters only in the First Name field.";
        
    } else if (![validationObj validateBlankField:last_nameTxtField.text]) {
        
        message = @"Please enter letters only in the Last Name field.";
        
    } if (![validationObj validateCharacters:firstNameTxtField.text]) {
        
        message = @"Please enter letters only in the First Name field.";
        
    } else if (![validationObj validateCharacters:last_nameTxtField.text]) {
        
        message = @"Please enter letters only in the Last Name field.";
        
    } else if (![validationObj validateEmail:emailTxtField.text]) {
        
        message = @"Please enter a valid email address.";
        
    } else if (![validationObj validatePassword:passwordTxtField.text]) {
        
        message = @"Your password must be at least 6 characters long.";
        
    } else if (![validationObj validateString:passwordTxtField.text equalTo:confirm_pswdTxtField.text]){
        
        message = @"Please check the password and confirm password matches.";
        
        passwordTxtField.text = @"";
        
        confirm_pswdTxtField.text = @"";
    }
    
    if ([message length] > 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        NSDictionary *urlParam = @{@"first_name" : firstNameTxtField.text , @"last_name" : last_nameTxtField.text, @"email" : emailTxtField.text, @"password" : passwordTxtField.text, @"confirm_password" : confirm_pswdTxtField.text};
        
        [self.view addSubview:indicator];
        
        [registrationConnection startConnectionWithString:[NSString stringWithFormat:@"user_registration"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([registrationConnection responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                NSString *message;
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                    
                    //                    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:0] animated:YES];
                    //
                    //                    message = @"Welcome to ecaHUB! Before you get started, please check your email inbox and junk mail folder for the verification email sent to you.";
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"Signup"];
                    
                    NSDictionary *login = @{@"login" : @"1", @"ecaHubLogin" : @"1"};
                    
                    [[NSUserDefaults standardUserDefaults] setValue:login forKey:@"login"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[receivedData valueForKey:@"member_info"] forKey:@"userInfo"];
                    
                    [self performSegueWithIdentifier:@"startSegue" sender:self];
                    
                } else {
                    
                    emailTxtField.text = @"";
                    
                    message = @"This email address is already in use.";
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
            }
        }];
    }
}

- (IBAction)tappesTCBtn:(id)sender {
    
    NSString* launchUrl = @"http://mercury.promaticstechnologies.com/ecaHub/Homes/terms_and_condition";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
    
}

- (IBAction)tappedLinekInBtn:(id)sender {
    
    NSString* launchUrl = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=78imindwbpf3mg&redirect_uri=http%3A%2F%2Fmercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect&state=ecaHub987654321&scope=r_fullprofile%20r_emailaddress%20w_share";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
    
}

#pragma mark - Facebook Sign Up

- (IBAction)tappedFB_Btn:(id)sender {
    
    if ([FBSDKAccessToken currentAccessToken]){
        
        [FBSDKAccessToken setCurrentAccessToken:nil];
        
    }
    else{
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile",@"user_friends",@"email"]
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 
                 NSLog(@"%@",result);
                 
                 NSLog(@"%@",FBSDKAccessToken.currentAccessToken);
                 
                 FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me?fields=id,name,email,birthday,first_name,last_name,gender,picture,friends" parameters:nil  HTTPMethod:@"GET"];
                 
                 [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     
                     NSLog(@"Data%@",result);
                     
                     if ([result isKindOfClass:[NSDictionary class]]) {
                         
                         NSDictionary *data = result;
                         
                         [self facebookLogin:[data objectForKey:@"email"] fb_id:[data objectForKey:@"id"] firstname:[data objectForKey:@"first_name"] lastname:[data objectForKey:@"last_name"]];
                     }
                     [login logOut];
                     // Insert your code here
                 }];
                 
             }
             [FBSDKAccessToken setCurrentAccessToken:nil];
         }];
    }
}

- (void) facebookLogin:(NSString*)email fb_id:(NSString*)fb_id firstname : (NSString*)firstname lastname:(NSString*)lastname {
    
    NSDictionary *urlParam = @{@"facebook_id" :fb_id, @"first_name" : firstname, @"last_name" : lastname, @"email_id" : email};
    
    NSLog(@"FBLogin UrlParam : %@", urlParam);
    
    [self.view addSubview:indicator];
    
    [registrationConnection startConnectionWithString:[NSString stringWithFormat:@"facebook_login"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([registrationConnection responseCode] == 1) {
            
            NSLog(@"Received Data %@",receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                NSDictionary *login = @{@"login" : @"1", @"ecaHubLogin" : @"0"};
                
                [[NSUserDefaults standardUserDefaults] setValue:login forKey:@"login"];
                
                [[NSUserDefaults standardUserDefaults] setValue:[receivedData valueForKey:@"info" ] forKey:@"userInfo"];
                
                UIStoryboard *storyboard = self.storyboard;
                
                TabBarViewController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
                
                [self presentViewController:tabBarVC animated:YES completion:nil];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark- Textfield Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == confirm_pswdTxtField) {
        
        [theTextField resignFirstResponder];
        
        [self tappedCreateAccBtn:theTextField];
        
    } else if (theTextField == firstNameTxtField) {
        
        [last_nameTxtField becomeFirstResponder];
        
    }  else if (theTextField == last_nameTxtField) {
        
        [emailTxtField becomeFirstResponder];
        
    }  else if (theTextField == emailTxtField) {
        
        [passwordTxtField becomeFirstResponder];
        
    }  else if (theTextField == passwordTxtField) {
        
        [confirm_pswdTxtField becomeFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    activeField = nil;
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    float kbHeight = 0.0;
    
    if (kbSize.width > kbSize.height) {
        
        kbHeight = kbSize.height;
        
    } else {
        
        kbHeight = kbSize.width;
    }
    
    NSLog(@"%f", self.view.frame.origin.x);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
   // [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    scrollView.contentInset = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbHeight;
    
    UIView *activeView = activeField;
    
    if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
        
        [scrollView scrollRectToVisible: activeView.frame  animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
   //scrollView.contentOffset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
   scrollView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
  
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
     scrollView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view endEditing:YES];
}

@end
