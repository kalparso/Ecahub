//
//  AppDelegate.m
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "WebServiceConnection.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "HomeViewController.h"
#import <GooglePlus/GooglePlus.h>
#import "PayPalMobile.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate (){
    
    WebServiceConnection *linkedInConnection;
    WebServiceConnection *userInfoConnection;
    WebServiceConnection *linkedInLoginConn;
    WebServiceConnection *linkedInShareConn;
    WebServiceConnection *messageConn;
    NSString *link_url;
}
@end

@implementation AppDelegate

static NSString * const kClientId = @"826883180395-bcuk9vv9h8p1sl09gm6mnoujh5r5lqc5.apps.googleusercontent.com";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
      [self registerRemoteNotification];
    
    //textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
    // Override point for customization after application launch
    // Whenever a person opens app, check for a cached session
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{
                                                           PayPalEnvironmentProduction : @"AYISD0cJCSoc9FpHh4JN59el3xgfnmvMz9FYS3QLOU2CI8FEMah0Ofpl0kQcYPon21Z_V9XFe9SGkQBf",
                                                           PayPalEnvironmentSandbox : @"AdwyGtuWaosgsct2VIxm5C8y6N9KNM-p92-hqKyaJGJclVwIi9G-CqEg7u5TEdyc1EbQ6OmycDqoReeB"}];
    
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        
//        NSLog(@"Found a cached session");
//        // If there's one, just open the session silently, without showing the user the login UI
//        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
//                                           allowLoginUI:NO
//                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                                          // Handler for session state changes
//                                          // This method will be called EACH time the session state changes,
//                                          // also for intermediate states and NOT just when the session open
//                                          [self sessionStateChanged:session state:state error:error];
//                                      }];
//        
//        // If there's no cached session, we will show a login button
//    } else {
//        UIButton *signUpButton = [self.registrationVC FacebookBtn];
//        [signUpButton setTitle:@"Sign Up with Facebook" forState:UIControlStateNormal];
//    }
//    
//    
      sleep(3.0);
//    
//    [FBLoginView class];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        
        // Show the user the logged-in UI
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
            }
        }
        // Clear this token
        
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // Show the user the logged-out UI
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
     [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL wasHandled;
    
    link_url = [url absoluteString];
    
    NSArray *urlArray = [link_url componentsSeparatedByString:@"?"];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"PayPal"] isEqualToString:@"1"]) {
        
        wasHandled = TRUE;
        
        return wasHandled;
        
    } else {
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Gmail"] isEqualToString:@"1"]) {
            
            //ecahub://manoj.com?code=4/ldetO-gqgvLVnx8cUJm6z1UFxw0mMj7iurwo4_u_unY.Iq-KAOwpj7kecp7tdiljKKYtImIdmgImercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect&state=1
            NSArray *stringArray = [link_url componentsSeparatedByString:@"code="];
            
            NSString *state= [stringArray objectAtIndex:1];
            
            NSLog(@"%@", state);
            
            NSArray *codeArray = [state componentsSeparatedByString:@"mercury"];
            
            NSString *code = [codeArray objectAtIndex:0];
            
            NSString *redirect_uri = [@"http://mercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            
            NSString *client_id = @"78imindwbpf3mg";
            
            NSString *client_secret = @"G5Wl3zAe4ZcoHqGW";
            
            NSDictionary *urlParam = @{@"grant_type": @"authorization_code", @"code": code, @"redirect_uri": redirect_uri, @"client_id": client_id, @"client_secret": client_secret};
            
            NSLog(@"Access Token Param- %@", urlParam);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchGMailContacts" object:urlParam];
            
            wasHandled = TRUE;
            
        } else {
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Hotmail"] isEqualToString:@"0"]) {
                
                if ([[urlArray objectAtIndex:0] isEqualToString:@"ecahub://manoj.com"]) {
                    
                    [self loginToLinkedIn:link_url];
                    
                    wasHandled = TRUE;
                    
                } else {
                    
                    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
                    
                    //wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
                    
                    wasHandled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                          openURL:url
                                                                sourceApplication:sourceApplication
                                                                       annotation:annotation];
                }
                
            } else {
                
                NSLog(@"%@", link_url);
                
                // fetchHotMailContacts
                
                wasHandled = TRUE;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchHotMailContacts" object:link_url];
                
                return wasHandled;
            }
        }
    }
    [GPPURLHandler handleURL:url
           sourceApplication:sourceApplication
                  annotation:annotation];
    
    // You can add your app-specific url handling code here if needed
    return wasHandled;
}

-(void) loginToLinkedIn:(NSString *)urlLink {
    
    NSArray *stringArray = [urlLink componentsSeparatedByString:@"code="];
    
    NSString *state= [stringArray objectAtIndex:1];
    
    NSLog(@"%@", state);
    
    NSArray *codeArray = [state componentsSeparatedByString:@"mercury"];
    
    NSString *code = [codeArray objectAtIndex:0];
    
    NSString *redirect_uri = [@"http://mercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *client_id = @"78imindwbpf3mg";
    
    NSString *client_secret = @"G5Wl3zAe4ZcoHqGW";
    
    linkedInConnection = [WebServiceConnection connectionManager];
    
    NSDictionary *urlParam = @{@"grant_type": @"authorization_code", @"code": code, @"redirect_uri": redirect_uri, @"client_id": client_id, @"client_secret": client_secret};
    
    NSLog(@"Access Token Param- %@", urlParam);
    
    [linkedInConnection startLinkedInConnectionWithString:[NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData) {
        
        if ([linkedInConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            NSString *access_token = [receivedData valueForKey:@"access_token"];
            
            [[NSUserDefaults standardUserDefaults] setValue:access_token forKey:@"linkedInToken"];
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"linkinShare"] isEqualToString:@"0"]) {
                
                [self getUserInfo];
                
            } else {
                
                [self shareData:[[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInToken"]];
            }
        }
    }];
}

-(void)getUserInfo {
    
    userInfoConnection = [WebServiceConnection connectionManager];
    
    NSDictionary *urlParam1 = @{};
    
    [userInfoConnection startLinkedInConnectionWithString:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address)?format=json"] HttpMethodType:Get_type HttpBodyType:urlParam1 Output:^(NSDictionary *receivedData){
        
        if ([userInfoConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            NSArray *errorCode = [receivedData copy];
            
            if ([errorCode count] == 5) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"There is some problem. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            } else {
                
                [self loginFromLinekedIn:receivedData];
            }
        }
    }];
}

-(void)loginFromLinekedIn:(NSDictionary *)userData {
    
    linkedInLoginConn = [WebServiceConnection connectionManager];
    
    NSDictionary *paramURL = @{@"linkedin_id" : [userData valueForKey:@"id"], @"first_name" : [userData valueForKey:@"firstName"], @"last_name" : [userData valueForKey:@"lastName"], @"email_id" : [userData valueForKey:@"emailAddress"]};
    
    [linkedInLoginConn startConnectionWithString:[NSString stringWithFormat:@"linkedid_login"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        if([linkedInLoginConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            NSDictionary *login = @{@"login" : @"1", @"ecaHubLogin" : @"0"};
            
            [[NSUserDefaults standardUserDefaults] setValue:login forKey:@"login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[receivedData valueForKey:@"info" ] forKey:@"userInfo"];
            
            TabBarViewController *tvc = (TabBarViewController *)self.window.rootViewController;
            
            [(HomeViewController*)[[(UINavigationController*)[[tvc viewControllers] objectAtIndex:0] viewControllers ] objectAtIndex:0] dismissLoginVC];
        }
    }];
}

- (void)shareData:(NSString*)token{
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"linkedInToken"];
    
    //   NSDictionary *dict = @{@"title":listing_name.text, @"description": course_dscriptionTxtView.text, @"img_url":img_url};
    
    // [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"linkedInShareData"];
    linkedInShareConn = [WebServiceConnection connectionManager];
    
    NSString *img_url = [[[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInShareData"] valueForKey:@"img_url"];
    
    NSString *title = [[[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInShareData"] valueForKey:@"title"];
    
    NSString *caption = [[[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInShareData"] valueForKey:@"description"];
    
    NSDictionary *urlParam = @{
                               @"comment": @"www.ecaHub.com",
                               @"content": @{
                                       @"title": title,
                                       @"description": caption,
                                       @"submitted-url": @"http://mercury.promaticstechnologies.com/ecaHub",
                                       @"submitted-image-url":img_url
                                       },
                               @"visibility": @{
                                       @"code": @"anyone"
                                       }
                               };
    NSLog(@"%@",urlParam);
    
    [linkedInShareConn startLinkedInShareConnectionWithString:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/shares?format=json"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData) {
        
        if([linkedInShareConn responseCode]==1) {
            
            // [self.navigationController popViewControllerAnimated:YES];
            
            TabBarViewController *tvc = (TabBarViewController *)self.window.rootViewController;
            
            [(HomeViewController*)[[(UINavigationController*)[[tvc viewControllers] objectAtIndex:0] viewControllers ] objectAtIndex:0] dismissLoginVC];
            
            NSString *msg;
            
            NSLog(@"%@", receivedData);
            
            if([[receivedData valueForKey:@"errorCode"] integerValue] == 0) {
                
                msg = @"There is some problem. Please try again.";
                
            } else {
                
                msg = @"Successfully share";
            }
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];            
        }
    }];
}



@end



