//
//  LoginViewController.m
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "LoginViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TabBarViewController.h"
#import "ecaIntroViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>



@interface LoginViewController () {
    
    WebServiceConnection *loginConnection;
    
    WebServiceConnection *linkedInConnection;
    
    WebServiceConnection *userInfoConnection;
    
    WebServiceConnection *linkedInLoginConn;
    
    Indicator *indicator;
    
    Validation *validationObj;
    
    NSArray *loginInfoArray;
    
    id activeField;
    
    TabBarViewController *tabVC;
}
@end

@implementation LoginViewController

@synthesize scrollView, emailTextField, passwordTextField, FacebookBtn, linkedInBtn, loginBtn, orView, fbLoginView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    loginConnection = [WebServiceConnection connectionManager];
    
    linkedInLoginConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.bounds];
    
    validationObj = [Validation validationManager];
    
    [self registerForKeyboardNotifications];
    
   // scrollView.frame = self.view.frame;
    
    //scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    [scrollView addGestureRecognizer:tapScroll];
    
    [self prepareInterface];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Gmail"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PayPal"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Hotmail"];
}

-(void) prepareInterface {
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        //scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);

        orView.layer.cornerRadius = 30.0f;
        
        CGFloat hieght = 45.0f;
        
        CGRect frameRect = emailTextField.frame;
        
        frameRect.size.height = hieght;
        
        emailTextField.frame = frameRect;
        
        CGRect frameRect1 = passwordTextField.frame;
        
        frameRect1.size.height = hieght;
        
        passwordTextField.frame = frameRect1;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        //scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
 
        orView.layer.cornerRadius = 20.0f;
    }
    
    emailTextField.layer.borderWidth = 0.5f;
    emailTextField.layer.cornerRadius = 5.0f;
    emailTextField.layer.borderColor = [UIColor blackColor].CGColor;
    
    passwordTextField.layer.borderWidth = 0.5f;
    passwordTextField.layer.cornerRadius = 5.0f;
    passwordTextField.layer.borderColor = [UIColor blackColor].CGColor;
    
    loginBtn.layer.cornerRadius = 5.0f;
    
    FacebookBtn.layer.cornerRadius = 5.0f;
    
    linkedInBtn.layer.cornerRadius = 5.0f;
}

#pragma mark login to ecaHUB

- (IBAction)tappedLoginBtn:(id)sender {
    
    validationObj = [[Validation alloc] init];
    
    NSString *message;
    
    if (![validationObj validateEmail:emailTextField.text]) {
        
        message = @"Please check your email is entered correctly.";
        
    } else if (![validationObj validatePassword:passwordTextField.text]){
        
        message = @"Password should be 6 characters long";
    }
    
    if([message length]>0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        NSDictionary *urlParam = @{@"email_login" : emailTextField.text, @"password_login" : passwordTextField.text};
        
        [self.view addSubview:indicator];
        
        [loginConnection startConnectionWithString:[NSString stringWithFormat:@"login"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([loginConnection responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                NSString *msg;
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                    
                    loginInfoArray = [receivedData valueForKey:@"info"];
                    
                    msg = [receivedData valueForKey:@"message"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Signup"];
                    
                    NSDictionary *login = @{@"login" : @"1", @"ecaHubLogin" : @"1"};
                    
                    [[NSUserDefaults standardUserDefaults] setValue:login forKey:@"login"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[receivedData valueForKey:@"info"] forKey:@"userInfo"];
                                        
                    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"]);
                    
                    [self performSegueWithIdentifier:@"TabBar" sender:self];
                    
                } else {
                    
                   // emailTextField.text = @"";
                    
                    //passwordTextField.text = @"";
                    
                    msg = [[receivedData valueForKey:@"message"] objectAtIndex:0];
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }];
    }
}

#pragma mark Facebook login

- (IBAction)tappedFacebookBtn:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Hotmail"];
    
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

//    
//    if (FBSession.activeSession.state == FBSessionStateOpen
//        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
//        
//        // Close the session and remove the access token from the cache
//        // The session state handler (in the app delegate) will be called automatically
//        [FBSession.activeSession closeAndClearTokenInformation];
//        
//        // If the session state is not any of the two "open" states when the button is clicked
//    } else {
//        // Open a session showing the user the login UI
//        // You must ALWAYS ask for public_profile permissions when opening a session
//        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"]
//                                           allowLoginUI:YES
//                                      completionHandler:
//         ^(FBSession *session, FBSessionState state, NSError *error) {
//             
//             [[FBRequest requestForMe] startWithCompletionHandler:
//              ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
//                  if (!error) {
//                      NSLog(@"accesstoken %@",[NSString stringWithFormat:@"%@",session.accessTokenData]);
//                      NSLog(@"user id %@",user.objectID);
//                      NSLog(@"user id %@",user.first_name);
//                      NSLog(@"user id %@",user.last_name);
//                      NSLog(@"Email %@",[user objectForKey:@"email"]);
//                      NSLog(@"User Name %@",user.name);
//                      
//                      [self facebookLogin:[user objectForKey:@"email"] fb_id:user.objectID firstname:user.first_name lastname:user.last_name];
//                      
//                      [FBSession.activeSession closeAndClearTokenInformation];
//                  }
//              }];
//             
//             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//             
//             [appDelegate sessionStateChanged:session state:state error:error];
//         }];
//    }

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    //self.profilePictureView.profileID = user.id;
    //self.nameLabel.text = user.name;
    
    NSLog(@"%@", user);
    
    [self facebookLogin:(NSString*)[user objectForKey:@"email" ]  fb_id: (NSString*)[user objectForKey:@"id" ] firstname : (NSString*)[user objectForKey:@"first_name"] lastname:(NSString*)[user objectForKey:@"last_name"]];
    
}
// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void) facebookLogin:(NSString*)email fb_id:(NSString*)fb_id firstname : (NSString*)firstname lastname:(NSString*)lastname {
    
    NSDictionary *urlParam = @{@"facebook_id" :fb_id, @"first_name" : firstname, @"last_name" : lastname, @"email_id" : email};
    
    NSLog(@"FBLogin UrlParam : %@", urlParam);
    
    [self.view addSubview:indicator];
    
    [loginConnection startConnectionWithString:[NSString stringWithFormat:@"facebook_login"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([loginConnection responseCode] == 1) {
            
            NSLog(@"Received Data %@",receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                NSDictionary *login = @{@"login" : @"1", @"ecaHubLogin" : @"0"};
                
                [[NSUserDefaults standardUserDefaults] setValue:login forKey:@"login"];
                
                [[NSUserDefaults standardUserDefaults] setValue:[receivedData valueForKey:@"info" ] forKey:@"userInfo"];
                
                [self performSegueWithIdentifier:@"TabBar" sender:self];
            }
        }
    }];
}

#pragma mark LinkedIn login

- (IBAction)tappedLinkedInBtn:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"linkinShare"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Hotmail"];
    
    //  http://mercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect?code=AQShLXlxPNYdWiw7fq00pn6AWjyiMwE5THmY81ZRl9lRLB2JPdEE0DhE4R5ZJ4boVybB39Rv4KrH09_NymlJlgMyIFaAluIQlHXsAw3AVkb0_aUOZ80&state=987654321
    // http://mercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect
    
    NSString* launchUrl = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=78imindwbpf3mg&redirect_uri=http%3A%2F%2Fmercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect&state=ecaHub987654321&scope=r_fullprofile%20r_emailaddress%20w_share";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

#pragma mark- Textfield Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == passwordTextField) {
        
        [theTextField resignFirstResponder];
        
        [self tappedLoginBtn:theTextField];
        
    } else if (theTextField == emailTextField) {
        
        [passwordTextField becomeFirstResponder];
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

// Called when the UIKeyboardDidShowNotification is sent.

- (void)registerForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(-40, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
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
    
    scrollView.contentInset = contentInsets;
    
    scrollView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
    
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    scrollView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);

    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)done{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
