//
//  EditProfileViewController.h
//  ecaHUB
//
//  Created by promatics on 3/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *fnameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *FamilyTxtField;
@property (weak, nonatomic) IBOutlet UITextField *dobTxtField;
@property (weak, nonatomic) IBOutlet UITextField *genderTxtField;
@property (weak, nonatomic) IBOutlet UITextField *cityTxtField;
@property (weak, nonatomic) IBOutlet UITextField *codeTxtField
;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxtField;
@property (weak, nonatomic) IBOutlet UITextView *aboutMe;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *no_imageLbl;
@property (weak, nonatomic) IBOutlet UIButton *chooseImgBtn;
@property (nonatomic, weak) UIImage *profile_Image;
@property (weak, nonatomic) IBOutlet UIButton *btn_save;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (strong, nonatomic) IBOutlet UIView *saveView;

- (IBAction)chooseImageBtn:(id)sender;
- (IBAction)saveBtn:(id)sender;
- (IBAction)cancelBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *email_textfiled;


@end
