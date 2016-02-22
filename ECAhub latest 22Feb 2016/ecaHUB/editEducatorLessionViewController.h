//
//  editEducatorLessionViewController.h
//  ecaHUB
//
//  Created by promatics on 4/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface editEducatorLessionViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, listingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTxtView;
@property (weak, nonatomic) IBOutlet UILabel *char_limitLbl;
@property (weak, nonatomic) IBOutlet UITextField *educator_name;
@property (weak, nonatomic) IBOutlet UITextField *business_type;
@property (weak, nonatomic) IBOutlet UIButton *choose_imgBtn;
@property (weak, nonatomic) IBOutlet UILabel *img_selectLbl;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *district;
@property (weak, nonatomic) IBOutlet UITextField *town;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *established_year;
@property (weak, nonatomic) IBOutlet UITextField *offerTxtField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *offersBtn;
@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UITextField *building_name;
@property (weak, nonatomic) IBOutlet UITextField *number_street;

- (IBAction)tapCountryBtn:(id)sender;
- (IBAction)tapStateBtn:(id)sender;
- (IBAction)tapCityBtn:(id)sender;
- (IBAction)tapOffersBtn:(id)sender;
- (IBAction)tappChooseImg:(id)sender;
- (IBAction)tappedSaveBtn:(id)sender;
- (IBAction)tappedCancelBtn:(id)sender;


@end


