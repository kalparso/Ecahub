//
//  AddFamilyViewController.h
//  ecaHUB
//
//  Created by promatics on 3/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface AddFamilyViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, listDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *f_name;
@property (weak, nonatomic) IBOutlet UITextField *family_name;
@property (weak, nonatomic) IBOutlet UITextField *dob;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UIButton *interestedInBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseImg;
@property (weak, nonatomic) IBOutlet UIImageView *member_img;
@property (weak, nonatomic) IBOutlet UILabel *no_imgLbl;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, weak) UIImage *profile_Image;
@property (strong, nonatomic) IBOutlet UIView *savecancel;
@property (weak, nonatomic) IBOutlet UITextField *interest_text;

- (IBAction)tappedInterestBtn:(id)sender;
- (IBAction)tappedSaveBtn:(id)sender;
- (IBAction)tappedCancelBtn:(id)sender;
- (IBAction)tappedChooseImg:(id)sender;


@end
