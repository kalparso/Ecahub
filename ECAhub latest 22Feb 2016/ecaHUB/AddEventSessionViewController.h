//
//  AddEventSessionViewController.h
//  ecaHUB
//
//  Created by promatics on 4/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface AddEventSessionViewController : UIViewController <UITextFieldDelegate, listingDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *session_name;
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishDateBtn;
@property (weak, nonatomic) IBOutlet UITextField *no_of_lessions;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (weak, nonatomic) IBOutlet UIButton *lession_dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *event_start_time;
@property (weak, nonatomic) IBOutlet UIButton *event_finish_time;
@property (weak, nonatomic) IBOutlet UIView *lession_view;
@property (weak, nonatomic) IBOutlet UIView *lession_subView;
@property (weak, nonatomic) IBOutlet UITextField *unit_txtField;
@property (weak, nonatomic) IBOutlet UITextField *building_name;
@property (weak, nonatomic) IBOutlet UITextField *number_street;
@property (weak, nonatomic) IBOutlet UITextField *district;
@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UITextField *town;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UIButton *age_groupBtn;
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIButton *suitable_forBtn;
@property (weak, nonatomic) IBOutlet UITextField *instruction_lang;
@property (weak, nonatomic) IBOutlet UITextField *support_lang;
@property (weak, nonatomic) IBOutlet UITextField *max_student;
@property (weak, nonatomic) IBOutlet UITextField *available_places;
@property (weak, nonatomic) IBOutlet UIButton *currencyBtn;
@property (weak, nonatomic) IBOutlet UITextField *course_fee;
@property (weak, nonatomic) IBOutlet UIButton *freeEventBtn;
@property (weak, nonatomic) IBOutlet UIView *eventView;

@property (weak, nonatomic) IBOutlet UIButton *save_addAnotherBtn;
@property (weak, nonatomic) IBOutlet UIButton *save_view_sessionBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)tapFreeEventBtn:(id)sender;

- (IBAction)tapSave_addAnother:(id)sender;
- (IBAction)tap_save_view:(id)sender;
- (IBAction)tap_cancel:(id)sender;
- (IBAction)tap_checkBtn:(id)sender;
- (IBAction)tap_startDate:(id)sender;
- (IBAction)tap_finishDate:(id)sender;
- (IBAction)tap_age_group:(id)sender;
- (IBAction)tap_suitable_for:(id)sender;
- (IBAction)tap_currency:(id)sender;
- (IBAction)tapCountryBtn:(id)sender;
- (IBAction)tapStateBtn:(id)sender;
- (IBAction)tapCityBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
- (IBAction)tap_infoBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *main_LgBtn;
- (IBAction)tap_main_LgBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *supporting_LgBtn;
- (IBAction)tap_supporting_LgBtn:(id)sender;

- (IBAction)tapFeeInfo_btn:(id)sender;

- (IBAction)tapEventDateInfo_btn:(id)sender;
- (IBAction)tapVanuInfo_btn:(id)sender;
- (IBAction)tapAgegroupInfo_btn:(id)sender;
- (IBAction)tapLangMediumInfo_btn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *saveAndPost_btn;

- (IBAction)tapSaveAndPost:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *venur_lbl_view;
@property (weak, nonatomic) IBOutlet UIView *add_check_view;
@property (weak, nonatomic) IBOutlet UIButton *check_btn;
- (IBAction)tap_check_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *add_btn_view;
@property (weak, nonatomic) IBOutlet UIButton *add_btn;

- (IBAction)tap_add_btn:(id)sender;

@property BOOL isPrevAddress;

@property BOOL isEdit;
@end
