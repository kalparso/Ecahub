//
//  AddEventViewController.h
//  ecaHUB
//
//  Created by promatics on 4/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "ListingViewController.h"

@interface AddEventViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, listDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, listingDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *cource_name;
@property (weak, nonatomic) IBOutlet UIImageView *course_img1;
@property (weak, nonatomic) IBOutlet UIImageView *course_img2;
@property (weak, nonatomic) IBOutlet UIImageView *course_img3;
@property (weak, nonatomic) IBOutlet UIImageView *course_img4;
@property (weak, nonatomic) IBOutlet UIImageView *course_img5;
@property (weak, nonatomic) IBOutlet UIImageView *identity_img;
@property (weak, nonatomic) IBOutlet UITextView *description_textView;
@property (weak, nonatomic) IBOutlet UILabel *limit_chars;
@property (weak, nonatomic) IBOutlet UIButton *categoriesBtn;
@property (weak, nonatomic) IBOutlet UITextField *hours;
@property (weak, nonatomic) IBOutlet UITextField *mints;
@property (weak, nonatomic) IBOutlet UIButton *addSession;
@property (weak, nonatomic) IBOutlet UILabel *noOfSession;
@property (weak, nonatomic) IBOutlet UIButton *T_CBtn;
@property (weak, nonatomic) IBOutlet UIButton *aboutEducator;
@property (weak, nonatomic) IBOutlet UIButton *cancel_btn;
@property (weak, nonatomic) IBOutlet UIButton *save_btn;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;
@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (strong, nonatomic) IBOutlet UIButton *type_btn;
- (IBAction)tapType_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *newcategories_textfield;
@property (strong, nonatomic) IBOutlet UIButton *check_btn;
- (IBAction)tap_check_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *state_btn;
- (IBAction)tapState_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *city_btn;

- (IBAction)tapcity_btn:(id)sender;

- (IBAction)tapCountry:(id)sender;
- (IBAction)tappedCancelBtn:(id)sender;
- (IBAction)tappedSaveBtn:(id)sender;
- (IBAction)tappedCatBtn:(id)sender;
- (IBAction)tap_AddTermAndCondBtn:(id)sender;

- (IBAction)info_nameBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *limit36char_lbl;
- (IBAction)tap_infocategory_btn:(id)sender;

@end
