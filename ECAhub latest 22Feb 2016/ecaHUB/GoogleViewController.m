//
//  GoogleViewController.m
//  ecaHUB
//
//  Created by promatics on 4/22/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "GoogleViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface GoogleViewController ()

@end

@implementation GoogleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
   
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
  
    static NSString * const kClientId = @"740767417844-6mmqbi01k81s9a2um3d6eslrv1046san.apps.googleusercontent.com";
   
    // You previously set kClientId in the "Initialize the Google+ client" step
   
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    
    NSLog(@"Received error %@ and auth object %@",error, auth);
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication:(NSString *)sourceApplication annotation: (id)annotation {
    
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)didReceiveMemoryWarning {
  
    [super didReceiveMemoryWarning];
}

@end


