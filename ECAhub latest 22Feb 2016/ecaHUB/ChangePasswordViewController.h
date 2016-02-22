//
//  ChangePasswordViewController.h
//  ecaHUB
//
//  Created by promatics on 3/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *current_password;
@property (weak, nonatomic) IBOutlet UITextField *confirm_password;
@property (weak, nonatomic) IBOutlet UITextField *password_new;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)tappedSaveBtn:(id)sender;
- (IBAction)tappedCancelBtn:(id)sender;


@end
