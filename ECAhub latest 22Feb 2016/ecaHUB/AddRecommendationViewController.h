//
//  AddRecommendationViewController.h
//  ecaHUB
//
//  Created by promatics on 4/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRecommendationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *educator_name;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *district;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *sendRecommBtn;
@property (strong, nonatomic) IBOutlet UITextField *firstname_textfield;
@property (strong, nonatomic) IBOutlet UITextField *lastname_textfield;

- (IBAction)tapRecommBtn:(id)sender;

@end
