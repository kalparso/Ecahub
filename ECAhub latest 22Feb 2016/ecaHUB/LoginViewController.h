//
//  LoginViewController.h
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *orView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *linkedInBtn;
@property (strong, nonatomic) IBOutlet UIButton *FacebookBtn;

- (IBAction)tappedLoginBtn:(id)sender;
- (IBAction)tappedFacebookBtn:(id)sender;
- (IBAction)tappedLinkedInBtn:(id)sender;

@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;


@end



