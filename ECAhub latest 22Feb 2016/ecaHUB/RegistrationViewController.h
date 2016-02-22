//
//  RegistrationViewController.h
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *fb_img;

@property (weak, nonatomic) IBOutlet UIView *fbSignUpView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *last_nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (weak, nonatomic) IBOutlet UITextField *confirm_pswdTxtField;
@property (weak, nonatomic) IBOutlet UIButton *FacebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *LinkedInBtn;
@property (weak, nonatomic) IBOutlet UIButton *creatAccountBtn;
@property (weak, nonatomic) IBOutlet UIView *orView;
@property (weak, nonatomic) IBOutlet UIButton *Term_Con_Btn;

- (IBAction)tappedCreateAccBtn:(id)sender;
- (IBAction)tappesTCBtn:(id)sender;
- (IBAction)tappedLinekInBtn:(id)sender;
- (IBAction)tappedFB_Btn:(id)sender;

@end
