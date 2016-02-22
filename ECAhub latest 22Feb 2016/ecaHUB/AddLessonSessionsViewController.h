//
//  AddLessonSessionsViewController.h
//  ecaHUB
//
//  Created by promatics on 6/12/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface AddLessonSessionsViewController : UIViewController <UITextFieldDelegate, listingDelegate, UIPickerViewDataSource, UIPickerViewDelegate,UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *add_dayView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *session_name;
@property (weak, nonatomic) IBOutlet UIView *venue_view;
@property (weak, nonatomic) IBOutlet UIButton *startDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishDateBtn;
@property (weak, nonatomic) IBOutlet UITextField *no_of_lessions;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (weak, nonatomic) IBOutlet UIButton *lession_dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *lession_start_time;
@property (weak, nonatomic) IBOutlet UIButton *lession_finish_time;
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

@property (weak, nonatomic) IBOutlet UIButton *save_addAnotherBtn;
@property (weak, nonatomic) IBOutlet UIButton *save_view_sessionBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *indefinitly_view;
@property (weak, nonatomic) IBOutlet UIView *sub_view;
@property (weak, nonatomic) IBOutlet UIView *max_student_view;

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
- (IBAction)tapAddTimeSlot:(id)sender;
- (IBAction)tapAddDay:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *removeLastOneBtn;
- (IBAction)tap_removeLastOneBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectMainLgBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectSupportingBtn;
- (IBAction)tap_mainLgBtn:(id)sender;
- (IBAction)tap_supportingLgBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *available_placesLbl;
@property (weak, nonatomic) IBOutlet UIButton *sessionInfoBtn;
- (IBAction)tap_sessionInfoBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fromInfoBtn;
- (IBAction)tap_fromInfoBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *untilInfoBtn;
- (IBAction)tap_untilInfoBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dayTInfoBtn;
- (IBAction)tap_dayTInfoBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *venueInfoBtn;
- (IBAction)tap_venueInfoBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *ageInfoBtn;
- (IBAction)tap_ageInfoBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *lgInfoBtn;
- (IBAction)tap_lgInfoBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *feeInfoBtn;
- (IBAction)tap_feeInfoBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveAndpost;
- (IBAction)tap_saveAndpost:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *venuelbl_view;
@property (weak, nonatomic) IBOutlet UIView *check_addbox_view;

@property (weak, nonatomic) IBOutlet UIView *addBtn_view;
@property (weak, nonatomic) IBOutlet UIButton *add_Btn;
- (IBAction)tap_addBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *checkadd_Btn;
- (IBAction)tap_checkadd_Btn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *day_timeLbl;

@property BOOL isPrevAddress;

@end


