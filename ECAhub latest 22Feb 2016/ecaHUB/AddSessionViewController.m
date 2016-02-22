
//  Created by promatics on 3/23/15.
//  Copyright (c) 2015 promatics. All rights reserved.


#import "AddSessionViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "addWhatsOnViewController.h"
#import "DateConversion.h"
#import "Validation.h"
#import "MyListingViewController.h"


@interface AddSessionViewController () {
    
    WebServiceConnection *addSessionConnection, *addConn, *getCourseConn;
    
    WebServiceConnection *locationConnection, *languageConn;
    
    WebServiceConnection *saveAndPostConn;
    
    Indicator *indicator;
    
    UIDatePicker *datePicker;
    
    UIToolbar *toolBar;
    
    UIPickerView *pickerView;
    
    BOOL tapDate_session;
    
    UIBarButtonItem *cancelBarButton;
    
    UIBarButtonItem *doneBarButton;
    
    UIButton *selectedBtn;
    
    DateConversion *dateConversion;
    
    BOOL tapDate;
    
    id activeField;
    
    NSMutableArray *starTime_btn_array;
    
    NSMutableArray *finishTime_btn_array;
    
    NSMutableArray *date_btn_array, *lesson_labelNoArray;
    
    NSArray *ageArray;
    
    NSArray  *suitableArray;
    
    NSString *age_id;
    
    NSString *suitable_id;
    
    BOOL isTapAge;
    
    NSArray *pickerArray;
    
    NSString *currencyId;
    
    BOOL isTapCurrency;
    
    BOOL save_view;
    
    BOOL isCheckTap;
    
    BOOL isLesson_startBtn;
    
    BOOL isCountry;
    
    BOOL isState;
    
    BOOL isCity;
    
    NSString *city_id,*startdate,*finishdate;
    
    NSString *country_id;
    
    NSString *state_id;
    
    NSArray *countryArray;
    
    NSArray *locationArray;
    
    NSArray *stateArray;
    
    CGFloat lable_width;
    
    BOOL isTapView;
    
    NSMutableArray *languageArray;
    
    BOOL isInstructionLg, isSupportingLg;
    
    NSString *pickerValue;
    
    NSString *data_id;
    
    BOOL saveAndPost;
    
    NSString *course_id ;
    
    NSMutableArray *timeArr;
    
    NSString *startTime;
    
    NSString *endTime;
    
    NSInteger startTimeIndex;
    
    BOOL tapStartTime,tapEndTime;
    
    NSMutableArray *timeIndexArr;
    
    NSMutableArray *stTimeArr;
    
    Validation *validationobj;
    
    NSMutableArray *dateArr;
    
    BOOL isavilprevAdd;
    
    NSInteger istapCheck;
    
    NSMutableArray *prevAddressArray;
    
    BOOL isselectPrevAdd;
    
    NSArray *addArray;
    
    float lessonViewHeight;
    
}

@end

@implementation AddSessionViewController

@synthesize scrollView, session_name, startDateBtn, finishDateBtn, no_of_lessions, checkBoxBtn, lession_dateBtn, lession_start_time, lession_finish_time, lession_view, lession_subView, unit_txtField, building_name, number_street, district, town, city, age_groupBtn, main_view, suitable_forBtn, instruction_lang, support_lang, max_student, available_places, currencyBtn, course_fee, save_addAnotherBtn, save_view_sessionBtn, cancelBtn, countryBtn, stateBtn, cityBtn,instructionLgBtn,infoBtn,supportingLgBtn,saveAndPost_btn,isEdit,venur_lbl_view,add_btn,add_btn_view,add_check_view,check_btn,time_check_view,isPrevAddress;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self commonmethod];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    // [self commonmethod];
}

-(void)commonmethod {
    
    self.title = @"Session Option";
    
    self.navigationItem.hidesBackButton = YES;
    
    validationobj = [Validation validationManager];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    addSessionConnection = [WebServiceConnection connectionManager];
    
    locationConnection = [WebServiceConnection connectionManager];
    
    addConn = [WebServiceConnection connectionManager];
    
    languageConn = [WebServiceConnection connectionManager];
    
    saveAndPostConn = [WebServiceConnection connectionManager];
    
    dateConversion = [DateConversion dateConversionManager];
    
    getCourseConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    prevAddressArray = [[NSMutableArray alloc]init];
    
    lesson_labelNoArray = [[NSMutableArray alloc] init];
    
    languageArray = [[NSMutableArray alloc]init];
    
    saveAndPost_btn.hidden = YES;
    
    cancelBtn.frame = saveAndPost_btn.frame;
    
    lessonViewHeight = lession_view.frame.size.height;
    
    tapDate = YES;
    
    isTapAge = YES;
    
    isCountry = NO;
    
    isState = NO;
    
    isCity = NO;
    
    isTapCurrency = NO;
    
    save_view = YES;
    
    isCheckTap = NO;
    
    isLesson_startBtn = YES;
    
    isTapView = NO;
    
    tapDate_session = NO;
    
    isSupportingLg = NO;
    
    isselectPrevAdd = NO;
    
    isInstructionLg = NO;
    
    support_lang.hidden = YES;
    
    instruction_lang.hidden = YES;
    
    isavilprevAdd = isPrevAddress;
    
    istapCheck = 0;
    
    add_btn_view.hidden = YES;
    
    //NSString *course_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"];
    
    country_id = [[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"country_id"];
    state_id = [[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"state_id"];
    city_id = [[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"city_id"];
    NSString *C_name = [[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"country_name"];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"]);
    
    C_name = [C_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    C_name = [@"  " stringByAppendingString:C_name];
    
    [countryBtn setTitle:C_name forState:UIControlStateNormal];
    
    NSString *state;
    
    state = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"state_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    state = [@"  "stringByAppendingString:state];
    
    [stateBtn setTitle:state forState:UIControlStateNormal];
    
    NSString *cityName;
    
    cityName = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"city_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    cityName = [@"  "stringByAppendingString:cityName];
    
    [cityBtn setTitle:cityName forState:UIControlStateNormal];
    
    //[cityBtn setTitle:[[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"city_name"] forState:UIControlStateNormal];
    
    
    countryBtn.userInteractionEnabled = NO;
    
    currencyId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"] valueForKey:@"currency_id"];
    
    NSString *curencyStr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Currency"] valueForKey:@"currency_name"];
    
    curencyStr = [@"  " stringByAppendingString:curencyStr];
    
    [currencyBtn setTitle:curencyStr forState:UIControlStateNormal];
    
    currencyBtn.userInteractionEnabled = NO;
    
    [self prepareInterface];
}

-(void) prepareInterface {
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        lable_width = 400.0f;
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2100);
        
        CGRect frame = session_name.frame;
        
        frame.size.height = 45.0f;
        
        session_name.frame = frame;
        
        frame = no_of_lessions.frame;
        
        frame.size.height = 45.0f;
        
        no_of_lessions.frame = frame;
        
        frame = unit_txtField.frame;
        
        frame.size.height = 45.0f;
        
        unit_txtField.frame = frame;
        
        frame = building_name.frame;
        
        frame.size.height = 45.0f;
        
        building_name.frame = frame;
        
        frame = number_street.frame;
        
        frame.size.height = 45.0f;
        
        number_street.frame = frame;
        
        frame = district.frame;
        
        frame.size.height = 45.0f;
        
        district.frame = frame;
        
        frame = town.frame;
        
        frame.size.height = 45.0f;
        
        town.frame = frame;
        
        frame = city.frame;
        
        frame.size.height = 45.0f;
        
        city.frame = frame;
        
        frame = instruction_lang.frame;
        
        frame.size.height = 45.0f;
        
        instruction_lang.frame = frame;
        
        frame = support_lang.frame;
        
        frame.size.height = 45.0f;
        
        support_lang.frame = frame;
        
        frame = max_student.frame;
        
        frame.size.height = 45.0f;
        
        max_student.frame = frame;
        
        frame = available_places.frame;
        
        frame.size.height = 45.0f;
        
        available_places.frame = frame;
        
        frame = course_fee.frame;
        
        frame.size.height = 45.0f;
        
        course_fee.frame = frame;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        lable_width = 250.0f;
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1500);
    }
    
    session_name.layer.borderWidth = 1.0f;
    
    session_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    session_name.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"e.g. Monday Morning Sessions, Advance Group" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    session_name.layer.cornerRadius = 5.0f;
    
    no_of_lessions.layer.borderWidth = 1.0f;
    
    no_of_lessions.layer.borderColor = [UIColor blackColor].CGColor;
    
    no_of_lessions.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter a number" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    no_of_lessions.layer.cornerRadius = 5.0f;
    
    unit_txtField.layer.borderWidth = 1.0f;
    
    unit_txtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    unit_txtField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Unit/Suite (Optional)" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    unit_txtField.layer.cornerRadius = 5.0f;
    
    
    building_name.layer.borderWidth = 1.0f;
    
    building_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    building_name.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Building Name (Optional)" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    
    building_name.layer.cornerRadius = 5.0f;
    
    number_street.layer.borderWidth = 1.0f;
    
    number_street.layer.borderColor = [UIColor blackColor].CGColor;
    
    number_street.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Number and Street or \"Online\" " attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    
    number_street.layer.cornerRadius = 5.0f;
    
    district.layer.borderWidth = 1.0f;
    
    district.layer.borderColor = [UIColor blackColor].CGColor;
    
    district.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Suburb/District or \"Online\" "attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    district.layer.cornerRadius = 5.0f;
    
    add_btn.layer.borderWidth = 1.0f;
    
    add_btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    add_btn.layer.cornerRadius = 5.0f;
    
    [add_btn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    countryBtn.userInteractionEnabled = NO;
    
    countryBtn.layer.borderWidth = 1.0f;
    
    countryBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    countryBtn.layer.cornerRadius = 5.0f;
    
    stateBtn.userInteractionEnabled = NO;
    
    stateBtn.layer.borderWidth = 1.0f;
    
    stateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    stateBtn.layer.cornerRadius = 5.0f;
    
    cityBtn.userInteractionEnabled = NO;
    
    cityBtn.layer.borderWidth = 1.0f;
    
    cityBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    cityBtn.layer.cornerRadius = 5.0f;
    
    town.layer.borderWidth = 1.0f;
    
    town.layer.borderColor = [UIColor blackColor].CGColor;
    
    town.layer.cornerRadius = 5.0f;
    
    city.layer.borderWidth = 1.0f;
    
    city.layer.borderColor = [UIColor blackColor].CGColor;
    
    city.layer.cornerRadius = 5.0f;
    
    instruction_lang.layer.borderWidth = 1.0f;
    
    instruction_lang.layer.borderColor = [UIColor blackColor].CGColor;
    
    instruction_lang.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Select Instruction Language" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    instruction_lang.layer.cornerRadius = 5.0f;
    
    support_lang.layer.borderWidth = 1.0f;
    
    support_lang.layer.borderColor = [UIColor blackColor].CGColor;
    
    [supportingLgBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    [supportingLgBtn setTitle:@"  Select Supporting Language" forState:UIControlStateNormal];
    
    support_lang.layer.cornerRadius = 5.0f;
    
    max_student.layer.borderWidth = 1.0f;
    
    max_student.layer.borderColor = [UIColor blackColor].CGColor;
    
    max_student.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter a number e.g. 16" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    
    max_student.layer.cornerRadius = 5.0f;
    
    available_places.layer.borderWidth = 1.0f;
    
    available_places.layer.borderColor = [UIColor blackColor].CGColor;
    
    available_places.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"No. of seats remaining" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    available_places.layer.cornerRadius = 5.0f;
    
    course_fee.layer.borderWidth = 1.0f;
    
    course_fee.layer.borderColor = [UIColor blackColor].CGColor;
    
    course_fee.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"e.g. 90.00" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    
    course_fee.layer.cornerRadius = 5.0f;
    
    startDateBtn.layer.borderWidth = 1.0f;
    
    startDateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [startDateBtn setTitle:@"  Select" forState:UIControlStateNormal];
    
    [startDateBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    startDateBtn.layer.cornerRadius = 5.0f;
    
    finishDateBtn.layer.borderWidth = 1.0f;
    
    finishDateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [finishDateBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    [finishDateBtn setTitle:@"  Select" forState:UIControlStateNormal];
    
    finishDateBtn.layer.cornerRadius = 5.0f;
    
    lession_start_time.layer.borderWidth = 1.0f;
    
    lession_start_time.layer.borderColor = [UIColor blackColor].CGColor;
    
    lession_start_time.layer.cornerRadius = 5.0f;
    
    lession_finish_time.layer.borderWidth = 1.0f;
    
    lession_finish_time.layer.borderColor = [UIColor blackColor].CGColor;
    
    lession_finish_time.layer.cornerRadius = 5.0f;
    
    age_groupBtn.layer.borderWidth = 1.0f;
    
    age_groupBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [age_groupBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    age_groupBtn.layer.cornerRadius = 5.0f;
    
    suitable_forBtn.layer.borderWidth = 1.0f;
    
    suitable_forBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [suitable_forBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    suitable_forBtn.layer.cornerRadius = 5.0f;
    
    currencyBtn.layer.borderWidth = 1.0f;
    
    currencyBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    currencyBtn.layer.cornerRadius = 5.0f;
    
    save_addAnotherBtn.layer.cornerRadius = 5.0f;
    
    save_view_sessionBtn.layer.cornerRadius = 5.0f;
    
    saveAndPost_btn.layer.cornerRadius = 5.0f;
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    checkBoxBtn.layer.borderWidth = 1.0f;
    
    checkBoxBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    checkBoxBtn.backgroundColor = [UIColor whiteColor];
    
    checkBoxBtn.layer.cornerRadius = 3.0f;
    
    check_btn.layer.borderWidth = 1.0f;
    
    check_btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    check_btn.backgroundColor = [UIColor whiteColor];
    
    check_btn.layer.cornerRadius = 3.0f;
    
    instructionLgBtn.layer.borderWidth = 1.0f;
    
    instructionLgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [instructionLgBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    instructionLgBtn.layer.cornerRadius = 5.0f;
    
    supportingLgBtn.layer.borderWidth = 1.0f;
    
    supportingLgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    [supportingLgBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    supportingLgBtn.layer.cornerRadius = 5.0f;
    
    //    [self addLessons:@"1"];
    
    lession_view.hidden = YES;
    
    time_check_view.hidden = YES;
    
    
    lession_view.hidden = YES;
    
    if (!isavilprevAdd) {
        
        add_check_view.hidden = YES;
        
        add_btn_view.hidden = YES;
        
        CGRect frame = venur_lbl_view.frame;
        
        //    frame.origin.y = venur_lbl_view.frame.origin.y - 160;
        
        frame.origin.y = time_check_view.frame.origin.y;
        
        venur_lbl_view.frame = frame;
        
        frame = main_view.frame;
        
        frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
        
        main_view.frame = frame;
        
    }
    
    else{
        
        CGRect frame = venur_lbl_view.frame;
        
        frame.origin.y = time_check_view.frame.origin.y;
        
        venur_lbl_view.frame = frame;
        
        frame = add_check_view.frame;
        
        frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
        
        add_check_view.frame = frame;
        
        frame = main_view.frame;
        
        frame.origin.y = add_check_view.frame.origin.y + add_check_view.frame.size.height+8;
        
        main_view.frame = frame;
        
    }
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    [scrollView addGestureRecognizer:tapScroll];
    
    starTime_btn_array = [[NSMutableArray alloc] init];
    
    finishTime_btn_array = [[NSMutableArray alloc] init];
    
    date_btn_array = [[NSMutableArray alloc] init];
    
    //    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(donePicker:)];
    //
    //    tapgest.cancelsTouchesInView = NO;
    //
    //    [self.view addGestureRecognizer:tapgest];
}

#pragma mark - Hide Picker View

-(void)hidePickerView {
    
    [datePicker removeFromSuperview];
    [toolBar removeFromSuperview];
    [pickerView removeFromSuperview];
}


-(void) addLessons:(NSString *)no_lesson {
    
    lession_view.hidden = NO;
    
    int no_lessons = [no_lesson intValue];
    
    if (no_of_lessions == 0) {
        
        lession_view.frame = CGRectZero;
    }
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        
        for (int i =0; i < no_lessons ; i++) {
            
            
            UILabel *lesson_no = [[UILabel alloc] initWithFrame:CGRectMake(0, 220*i, lable_width, 30)];
            
            lesson_no.text = [NSString stringWithFormat:@"Lesson %d", i+1];
            
            lesson_no.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Text_colore"]];
            
            [lesson_labelNoArray addObject:lesson_no];
            
            [lession_view addSubview:lesson_no];
            
            UIButton *lesson_date = [[UIButton alloc] initWithFrame:CGRectMake(0, 220*i+45, lable_width, 45)];
            
            [date_btn_array addObject:lesson_date];
            
            lesson_date.titleLabel.textColor = [UIColor darkGrayColor];
            
            lesson_date.layer.borderWidth = 1.0f;
            
            lesson_date.layer.borderColor = [UIColor blackColor].CGColor;
            
            lesson_date.layer.cornerRadius = 5.0f;
            
            [lession_view addSubview:lesson_date];
            
            UIButton *lesson_startTime = [[UIButton alloc] initWithFrame:CGRectMake(0, 220*i+105, lable_width, 45)];
            
            lesson_startTime.layer.borderWidth = 1.0f;
            
            lesson_startTime.layer.borderColor = [UIColor blackColor].CGColor;
            
            lesson_startTime.layer.cornerRadius = 5.0f;
            
            [starTime_btn_array addObject:lesson_startTime];
            
            [lession_view addSubview:lesson_startTime];
            
            UIButton *lesson_endTime = [[UIButton alloc] initWithFrame:CGRectMake(0, 220*i+165, lable_width, 45)];
            
            lesson_endTime.titleLabel.textColor = [UIColor darkGrayColor];
            
            lesson_endTime.layer.borderWidth = 1.0f;
            
            lesson_endTime.layer.borderColor = [UIColor blackColor].CGColor;
            
            lesson_endTime.layer.cornerRadius = 5.0f;
            
            [lession_view addSubview:lesson_endTime];
            
            [finishTime_btn_array addObject:lesson_endTime];
            
            //        UIView *footer_view = [[UIView alloc] initWithFrame:CGRectMake(0, lesson_endTime.frame.origin.y + lesson_endTime.frame.size.height + 7.5 , lession_view.frame.size.width, 2)];
            //
            //        footer_view.backgroundColor = [UIColor lightGrayColor];
            //
            //        [lession_view addSubview:footer_view];
        }
        
        CGRect frame = lession_view.frame;
        
        frame.size.height = lessonViewHeight * no_lessons;
        
        lession_view.frame = frame;
        
        frame = venur_lbl_view.frame;
        
        frame.origin.y = lession_view.frame.origin.y + 220 * no_lessons;
        
        venur_lbl_view.frame = frame;
        
        if (!isavilprevAdd) {
            
            add_check_view.hidden = YES;
            
            add_btn_view.hidden = YES;
            
            frame = main_view.frame;
            
            frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
            
            main_view.frame = frame;
        }
        
        else {
            
            frame = add_check_view.frame;
            
            frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
            
            add_check_view.frame = frame;
            
            frame = main_view.frame;
            
            frame.origin.y = add_check_view.frame.origin.y + add_check_view.frame.size.height+8;
            
            main_view.frame = frame;
            
        }
        
        //scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 2100 + 220 * no_lessons)];
        
    } else {
        
        for (int i =0; i < no_lessons ; i++) {
            
            
            UILabel *lesson_no = [[UILabel alloc] initWithFrame:CGRectMake(0, 160*i, lable_width, 21)];
            
            lesson_no.text = [NSString stringWithFormat:@"Lesson %d", i+1];
            
            lesson_no.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Text_colore"]];
            
            [lesson_labelNoArray addObject:lesson_no];
            
            [lession_view addSubview:lesson_no];
            
            UIButton *lesson_date = [[UIButton alloc] initWithFrame:CGRectMake(0, 160*i+30, lable_width, 30)];
            
            [date_btn_array addObject:lesson_date];
            
            lesson_date.titleLabel.textColor = [UIColor darkGrayColor];
            
            lesson_date.layer.borderWidth = 1.0f;
            
            lesson_date.layer.borderColor = [UIColor blackColor].CGColor;
            
            lesson_date.layer.cornerRadius = 5.0f;
            
            [lession_view addSubview:lesson_date];
            
            UIButton *lesson_startTime = [[UIButton alloc] initWithFrame:CGRectMake(0, 160*i+75, lable_width, 30)];
            
            lesson_startTime.layer.borderWidth = 1.0f;
            
            lesson_startTime.layer.borderColor = [UIColor blackColor].CGColor;
            
            lesson_startTime.layer.cornerRadius = 5.0f;
            
            [starTime_btn_array addObject:lesson_startTime];
            
            [lession_view addSubview:lesson_startTime];
            
            UIButton *lesson_endTime = [[UIButton alloc] initWithFrame:CGRectMake(0, 160*i+120, lable_width, 30)];
            
            lesson_endTime.titleLabel.textColor = [UIColor darkGrayColor];
            
            lesson_endTime.layer.borderWidth = 1.0f;
            
            lesson_endTime.layer.borderColor = [UIColor blackColor].CGColor;
            
            lesson_endTime.layer.cornerRadius = 5.0f;
            
            [lession_view addSubview:lesson_endTime];
            
            [finishTime_btn_array addObject:lesson_endTime];
            
            //        UIView *footer_view = [[UIView alloc] initWithFrame:CGRectMake(0, lesson_endTime.frame.origin.y + lesson_endTime.frame.size.height + 7.5 , lession_view.frame.size.width, 2)];
            //
            //        footer_view.backgroundColor = [UIColor lightGrayColor];
            //
            //        [lession_view addSubview:footer_view];
        }
        
        CGRect frame = lession_view.frame;
        
        frame.size.height = lessonViewHeight * no_lessons;
        
        lession_view.frame = frame;
        
        frame = venur_lbl_view.frame;
        
        frame.origin.y = lession_view.frame.origin.y + 160 * no_lessons;
        
        venur_lbl_view.frame = frame;
        
        if (!isavilprevAdd) {
            
            add_check_view.hidden = YES;
            
            add_btn_view.hidden = YES;
            
            frame = main_view.frame;
            
            frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
            
            main_view.frame = frame;
        }
        
        else {
            
            frame = add_check_view.frame;
            
            frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
            
            add_check_view.frame = frame;
            
            frame = main_view.frame;
            
            frame.origin.y = add_check_view.frame.origin.y + add_check_view.frame.size.height+8;
            
            main_view.frame = frame;
            
        }
        
        scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1600 + 160 * no_lessons)];
        
    }
    
    dateArr = [[NSMutableArray alloc]init];
    
    for (UIButton *button in date_btn_array) {
        
        [dateArr addObject:@""];
        
        [button setTitle:@"  Select Date" forState:UIControlStateNormal];
        
        [button setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [button addTarget:self action:@selector(tapSessionDate:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    timeIndexArr = [[NSMutableArray alloc] init];
    
    for (UIButton *button in starTime_btn_array) {
        
        [button setTitle:@"  Select Start Time" forState:UIControlStateNormal];
        
        [button setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [button addTarget:self action:@selector(tapLessonStartTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [timeIndexArr  addObject:@"1000"];
        
    }
    
    NSInteger i=0;
    
    for (UIButton *button in finishTime_btn_array) {
        
        [button setTitle:@"  Select Finish Time" forState:UIControlStateNormal];
        
        [button setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [button addTarget:self action:@selector(tapLessonFinishTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = i;
        
        i++;
    }
    
    if(isavilprevAdd){
        
        [self tapCkeck_btn];
        
    }
    
}

-(void)tapSessionDate:(UIButton *)button {
    
    tapDate_session = YES;
    
    [self tapLessonDateBtn:button];
    
}
-(void)tapLessonDateBtn:(UIButton *)button {
    
    selectedBtn = button;
    
    isTapCurrency = NO;
    
    tapDate = YES;
    
    isLesson_startBtn = NO;
    
    [self addPicker_toolBar];
    
}

-(void)tapLessonStartTimeBtn:(UIButton *)button {
    
    selectedBtn = button;
    
    isLesson_startBtn = YES;
    
    tapDate = NO;
    
    isTapCurrency = NO;
    
    tapStartTime =YES;
    
    tapEndTime = NO;
    
    timeArr = [[NSMutableArray alloc]init];
    
    stTimeArr = [[NSMutableArray alloc]init];
    
    int m=0,h=6;
    
    NSString *timeStr;
    
    for (int i =0;i<192;i++){
        
        if(h<10){
            
            timeStr = [NSString stringWithFormat:@"0%d:",h];
            
        } else{
            
            timeStr = [NSString stringWithFormat:@"%d:",h];
            
        }
        
        if(m<10){
            
            timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"0%d ",m]];
        } else {
            
            timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%d ",m]];
        }
        
        if(i<72){
            
            timeStr = [timeStr stringByAppendingString:@"AM"];
            
        }else {
            
            timeStr = [timeStr stringByAppendingString:@"PM"];
        }
        
        m = m+5;
        
        if(m==60){
            
            m = 0;
            
            h = h+1;
            
            if(h==13){
                
                h = 1;
            }
        }
        
        [timeArr addObject:timeStr];
        
        [stTimeArr addObject:timeStr];
        
        
    }
    
    //[self addPicker_toolBar];
    
    
    [self showPicker];
    
}

-(void)tapLessonFinishTimeBtn:(UIButton *)button {
    
    int i =0;
    
    for (UIButton *bt in finishTime_btn_array) {
        
        if(bt == button){
            
            break;
        }
        
        i++;
    }
    
    selectedBtn = button;
    
    tapDate = NO;
    
    isTapCurrency = NO;
    
    isLesson_startBtn = NO;
    
    tapStartTime = NO;
    
    tapEndTime = YES;
    
    // [self addPicker_toolBar];
    
    // startTimeIndex =
    
    timeArr = [[NSMutableArray alloc]init];
    
    startTimeIndex = [[timeIndexArr objectAtIndex:i] integerValue];
    
    if(startTimeIndex != 1000){
        
        
        int m=0,h=6;
        
        NSString *timeStr;
        
        for (int i =0;i<=192;i++){
            
            if(h<10){
                
                timeStr = [NSString stringWithFormat:@"0%d:",h];
                
            } else{
                
                timeStr = [NSString stringWithFormat:@"%d:",h];
                
            }
            
            if(m<10){
                
                timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"0%d ",m]];
            } else {
                
                timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%d ",m]];
            }
            
            if(i<72 || i == 216){
                
                timeStr = [timeStr stringByAppendingString:@"AM"];
                
            }else {
                
                timeStr = [timeStr stringByAppendingString:@"PM"];
            }
            
            m = m+5;
            
            if(m==60){
                
                m = 0;
                
                h = h+1;
                
                if(h==13){
                    
                    h = 1;
                }
            }
            
            if(i > startTimeIndex) {
                
                [timeArr addObject:timeStr];
                
            }
            
            
        }
        
        [self showPicker];
    }
    // isfinishBtn = YES;
    
}

-(void)addPicker_toolBar {
    
    [toolBar removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
    
    datePicker = [[UIDatePicker alloc] init];
    
    if (tapDate) {
        
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        
        if(selectedBtn == finishDateBtn){
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            
            [format setDateFormat:@"yyyy-MM-dd"];
            
            [datePicker setMinimumDate:[format dateFromString:startdate]];
            
        } else {
            
            NSDate *now = [NSDate date];
            
            int daysToAdd = 1;
            
            NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            
            [datePicker setMinimumDate:newDate1];
            
        }        //if (tapDate_session )
        
        if(tapDate_session){
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            
            [format setDateFormat:@"yyyy-MM-dd"];
            
            //NSString *startDate = startDateBtn.titleLabel.text;
            
            startdate = [startdate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *finishDate = finishDateBtn.titleLabel.text;
            
            finishDate = [finishDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [datePicker setMinimumDate:[format dateFromString:startdate]];
            
            [datePicker setMaximumDate:[format dateFromString:finishdate]];
            
        }
        
    } else {
        
        [datePicker setDatePickerMode:UIDatePickerModeTime];
    }
    
    isTapView = YES;
    
    cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPicker:)];
    
    [cancelBarButton setWidth:50];
    
    doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(donePicker:)];
    
    [doneBarButton setWidth:50];
    
    CGRect frame = datePicker.frame;
    
    frame.origin.y = self.view.frame.size.height - datePicker.frame.size.height;
    
    frame.size.width = self.view.frame.size.width;
    
    datePicker.frame = frame;
    
    datePicker.backgroundColor = [UIColor lightGrayColor];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- datePicker.frame.size.height)-44, self.view.frame.size.width, 44)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[cancelBarButton,flexibleItem,doneBarButton];
    
    [self.view addSubview:toolBar];
    
    [self.view addSubview:datePicker];
}

-(void)cancelPicker:(UIBarButtonItem *)sender {
    
    [toolBar removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
    tapEndTime =  NO;
    
    tapStartTime  = NO;
    
    tapDate = NO;
    
    tapDate_session = NO;
    
    //[startDateBtn setTitle:@"" forState:UIControlStateNormal];
    
    // [finishDateBtn setTitle:@"" forState:UIControlStateNormal];
    
    
}

-(void)donePicker:(UIBarButtonItem *)sender {
    
    NSString *date;
    
    if (isTapCurrency) {
        
        NSLog(@"%@", @"Done");
        
    } else {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        if (tapDate) {
            
            [format setDateFormat:@"yyyy-MM-dd"];
            
            // [format setDateFormat:@"dd MMM yyyy"];
            
        } else {
            
            [format setDateFormat:@"hh:mm a"];
        }
        
        
        date = [format stringFromDate:[datePicker date]];
        
        if (tapDate) {
            
            // [format setDateFormat:@"yyyy-MM-dd"];
            
            if (selectedBtn == startDateBtn) {
                
                startdate = [format stringFromDate:[datePicker date]];
                
                
            }else if(selectedBtn == finishDateBtn){
                
                finishdate = [format stringFromDate:[datePicker date]];
                
            } else {
                
                int i = 0;
                
                for(UIButton *bt in date_btn_array){
                    
                    if(selectedBtn == bt){
                        
                        
                        [dateArr replaceObjectAtIndex:i withObject:[format stringFromDate:[datePicker date]]];
                        
                        break;
                    }
                    
                    i++;
                }
                
            }
        }
        
        
        if (selectedBtn == finishDateBtn) {
            
            if (([[datePicker date] compare:[format dateFromString:startDateBtn.titleLabel.text]] == NSOrderedSame) || ([[datePicker date] compare:[format dateFromString:startDateBtn.titleLabel.text]] == NSOrderedDescending)) {
                
                date = [dateConversion convertDate:date];
                
                date = [@"  " stringByAppendingString:date];
                
                [selectedBtn setTitle:date forState:UIControlStateNormal];
                
                [selectedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Finish Date can't be less then start date" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
                [selectedBtn setTitle:@"  Finish Date" forState:UIControlStateNormal];
            }
            
        } else {
            
            //date = [@"  " stringByAppendingString:date];
            
            if(tapStartTime){
                
                date = [@"  " stringByAppendingString:startTime];
                
                
            } else if(tapEndTime){
                
                date = [@"  " stringByAppendingString:endTime];
                
            } else {
                
                date = [dateConversion convertDate:date];
                
                date = [@"  " stringByAppendingString:date];
                
                
                if (selectedBtn == startDateBtn) {
                    
                    [finishDateBtn setTitle:@"  Select" forState:UIControlStateNormal];
                    
                    
                    [finishDateBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                }
                
            }
            
            [selectedBtn setTitle:date forState:UIControlStateNormal];
            
            [selectedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            int i = 0;
            
            if(tapStartTime){
                
                for(UIButton *statTime_btn in starTime_btn_array){
                    
                    if(selectedBtn == statTime_btn){
                        
                        [timeIndexArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",startTimeIndex]];
                        
                        break;
                        
                    }
                    i++;
                    
                }
                
                int j=0;
                
                for(UIButton *endTime_btn in finishTime_btn_array){
                    
                    if(i == j) {
                        
                        [endTime_btn setTitle:@"  Select Finish Time" forState:UIControlStateNormal];
                        
                        [endTime_btn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                        
                        break;
                    }
                    
                    j++;
                }
                
            }
        }
    }
    
    if (isCheckTap && !tapDate) {
        
        if (tapStartTime) {
            
            timeIndexArr = [[NSMutableArray alloc] init];
            
            for (UIButton *button in starTime_btn_array) {
                
                [button setTitle:date forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
                
                [timeIndexArr addObject:[NSString stringWithFormat:@"%d",startTimeIndex]];
                
                
            }
            
            for (UIButton *button in finishTime_btn_array) {
                
                [button setTitle:@"  Select Finish Time" forState:UIControlStateNormal];
                
                [button setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
            }
            
            
        } else if(tapEndTime){
            
            for (UIButton *button in finishTime_btn_array) {
                
                [button setTitle:date forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
        }
    }
    
    if (isTapView) {
        
        [toolBar removeFromSuperview];
        
        [datePicker removeFromSuperview];
        
        [pickerView removeFromSuperview];
        
        isTapView = NO;
    }
    
    
    tapEndTime =  NO;
    
    tapStartTime  = NO;
    
    tapDate = NO;
    
    tapDate_session = NO;
    
}

#pragma mark - PickerView Delegates & Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(tapStartTime||tapEndTime){
        
        return timeArr.count;
        
    } else {
        
        return pickerArray.count;
        
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    if(tapStartTime||tapEndTime){
        
        if(tapStartTime){
            
            startTime = [timeArr objectAtIndex:0];
            
            startTimeIndex = 0;
            
        } else {
            
            endTime = [timeArr objectAtIndex:0];
            
        }
        
        return [timeArr objectAtIndex:row];
        
        
    } else {
        
        return [[pickerArray objectAtIndex:row] valueForKey:@"name"];
        
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(tapStartTime||tapEndTime){
        
        if(tapStartTime) {
            
            startTimeIndex = row;
            
            startTime  = [timeArr objectAtIndex:row];
            
        } else {
            
            endTime  = [timeArr objectAtIndex:row];
            
        }
        
        
    } else {
        
        pickerValue = [[pickerArray objectAtIndex:row] valueForKey:@"name"];
        
        data_id = [[pickerArray objectAtIndex:row] valueForKey:@"id"];
        
        pickerValue = [@"  " stringByAppendingString:pickerValue];
        
        [currencyBtn setTitle:pickerValue forState:UIControlStateNormal];
        
        currencyId = data_id;
        
    }
    
    
}

-(void) showPicker {
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    isTapView = YES;
    
    cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPicker:)];
    
    [cancelBarButton setWidth:50];
    
    doneBarButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(donePicker:)];
    
    [doneBarButton setWidth:50];
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    CGRect frame = pickerView.frame;
    
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    
    frame.size.width = self.view.frame.size.width;
    
    pickerView.frame = frame;
    
    pickerView.backgroundColor = [UIColor lightGrayColor];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- pickerView.frame.size.height) - 44, self.view.frame.size.width, 44)];
    
    toolBar.backgroundColor = [UIColor darkGrayColor];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[cancelBarButton,flexibleItem, doneBarButton];
    
    [self.view addSubview:toolBar];
    
    [self.view addSubview:pickerView];
}

#pragma mark - TextField Delegates & Datasource

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    activeField = textField;
    
    // scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == no_of_lessions) {
        
        for (UIButton *button in date_btn_array) {
            
            [button removeFromSuperview];
        }
        
        for (UIButton *button in starTime_btn_array) {
            
            [button removeFromSuperview];
        }
        
        for (UILabel *label in lesson_labelNoArray) {
            
            [label removeFromSuperview];
        }
        
        for (UIButton *button in finishTime_btn_array) {
            
            [button removeFromSuperview];
        }
        
        [lesson_labelNoArray removeAllObjects];
        
        [date_btn_array removeAllObjects];
        
        [starTime_btn_array removeAllObjects];
        
        [finishTime_btn_array removeAllObjects];
    }
    
    if (textField == no_of_lessions) {
        
        [self addLessons:no_of_lessions.text];
    }
    
    if (textField == no_of_lessions && [textField.text integerValue]>1) {
        
        time_check_view.hidden= NO;
        
        CGRect frame1 = lession_view.frame;
        
        frame1.origin.y = time_check_view.frame.origin.y + time_check_view.frame.size.height+8;
        
        lession_view.frame = frame1;
        
        //[self addLessons:no_of_lessions.text];
        
        if (!isavilprevAdd) {
            
            add_check_view.hidden = YES;
            
            add_btn_view.hidden = YES;
            
            CGRect frame = venur_lbl_view.frame;
            
            frame.origin.y = lession_view.frame.origin.y +lession_view.frame.size.height+8;
            
            venur_lbl_view.frame = frame;
            
            frame = main_view.frame;
            
            frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
            
            main_view.frame = frame;
            
        }
        
        else{
            
            CGRect frame = venur_lbl_view.frame;
            
            frame.origin.y = lession_view.frame.origin.y +lession_view.frame.size.height+8;
            venur_lbl_view.frame = frame;
            
            frame = add_check_view.frame;
            
            frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
            
            add_check_view.frame = frame;
            
            frame = main_view.frame;
            
            frame.origin.y = add_check_view.frame.origin.y + add_check_view.frame.size.height+8;
            
            main_view.frame = frame;
            
        }
    } else if(textField == no_of_lessions){
        
        time_check_view.hidden= YES;
        
        CGRect frame1 = lession_view.frame;
        
        frame1.origin.y = time_check_view.frame.origin.y;
        
        lession_view.frame = frame1;
        
        // [self addLessons:no_of_lessions.text];
        
        if (!isavilprevAdd) {
            
            add_check_view.hidden = YES;
            
            add_btn_view.hidden = YES;
            
            CGRect frame = venur_lbl_view.frame;
            
            frame.origin.y = lession_view.frame.origin.y +lession_view.frame.size.height+8;
            
            venur_lbl_view.frame = frame;
            
            frame = main_view.frame;
            
            frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
            
            main_view.frame = frame;
            
        }
        else {
            
            CGRect frame = venur_lbl_view.frame;
            
            frame.origin.y = lession_view.frame.origin.y +lession_view.frame.size.height+8;
            venur_lbl_view.frame = frame;
            
            frame = add_check_view.frame;
            
            frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
            
            add_check_view.frame = frame;
            
            frame = main_view.frame;
            
            frame.origin.y = add_check_view.frame.origin.y + add_check_view.frame.size.height+8;
            
            main_view.frame = frame;
            
        }
        
    }
    
    if(textField == available_places){
        
        if(!([available_places.text integerValue] <= [max_student.text integerValue])){
            
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:Alert_title message:@"Seats remaining can not be greater than maximum number of students." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            available_places.text = @"";
            
        }
        
    }
    
    activeField = nil;
}

#pragma mark - Add Session

-(void) checkDataValidation {
    
    NSString *message;
    
    if(!([available_places.text integerValue] <= [max_student.text integerValue])){
        
        message = @"Seats remaining can not be greater than maximum number of students.";
        
        // available_places.text = @"";
        
    } else if ([session_name.text isEqualToString:@""]) {
        
        message = @"Please enter session name";
        
    } else if ([startDateBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select start date";
        
    } else if ([finishDateBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select finish date";
        
    } else {
        
        if ([no_of_lessions.text isEqualToString:@""]) {
            
            message = @"Please enter number of lessons";
        }
        
        else if(![validationobj validateNumberDigits:no_of_lessions.text]){
            
            message = @"Please enter a valid number for Number of Lessons";
            
        }
        
        
    }  if ([message length]<1) {
        
        if ([number_street.text isEqualToString:@""]) {
            
            message = @"Please enter the street name";
            
        } else if ([district.text isEqualToString:@""]) {
            
            message = @"Please enter the district name";
            
        }  else if ([age_groupBtn.titleLabel.text isEqualToString:@"  Select"]||[age_id isEqualToString:@""]) {
            
            message = @"Please select age group";
            
        } else if ([suitable_forBtn.titleLabel.text isEqualToString:@"  Select"]) {
            
            message = @"Please select suitable for";
            
        } else if ([instruction_lang.text isEqualToString:@""]) {
            
            message = @"Please select instruction language";;
            
        } else if ([max_student.text isEqualToString:@""]) {
            
            message = @"Please enter number of students";
            
        } else if ([available_places.text isEqualToString:@""]) {
            
            message = @"Please enter the remaining seats available";
            
        } else if ([currencyBtn.titleLabel.text isEqualToString:@"  Select"]) {
            
            message = @"Please select currency";
            
        } else if ([course_fee.text isEqualToString:@""]) {
            
            message = @"Please enter the Course Fee";
            
        }  else if([instructionLgBtn.titleLabel.text isEqualToString:@"  Select Instruction Language"]){
            
            message = @"Please select instruction language";
        }
    }
    
    NSMutableArray *datecheckArray = [[NSMutableArray alloc]init];
    
    for (UIButton *button in date_btn_array) {
        
        [datecheckArray addObject:button.titleLabel.text];
        
        if ([button.titleLabel.text isEqualToString:@"  Select Date"]) {
            
            message = @"Please enter lesson Date";
            
            break;
            
        }
    }
    
    for (UIButton *button in starTime_btn_array) {
        
        if ([button.titleLabel.text isEqualToString:@"  Select Start Time"]) {
            
            message = @"Please enter lesson Start Time";
            
            break;
        }
    }
    
    for (UIButton *button in finishTime_btn_array) {
        
        if ([button.titleLabel.text isEqualToString:@"  Select Finish Time"]) {
            
            message = @"Please check lesson time(s) are entered properly.";
            
            break;
        }
    }
    
    for (int i = 0; i< datecheckArray.count; i++) {
        
        if (datecheckArray.count >1 && i+1<datecheckArray.count) {
            
            if ([[datecheckArray objectAtIndex:0] isEqualToString:[datecheckArray objectAtIndex:i+1]]) {
                
                message = @"Please ensure that Lesson Dates is not same";
                
                break;
            }
        }
    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.view addSubview:indicator];
        
        course_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"];
        
        /*
         1 -> course
         2 -> Lession
         */
        
        NSString *id_type;
        
        NSString *webservice_url;
        
        NSString *type = [[NSUserDefaults standardUserDefaults] valueForKey:@"session_type"];
        
        if ([type isEqualToString:@"1"]) {
            
            id_type = @"course_id";
            
            webservice_url = @"add_courses_sessions";
            
        } else if ([type isEqualToString:@"2"]) {
            
            id_type = @"lesson_id";
            
            webservice_url = @"add_lessons_sessions";
        }
        
        // NSString *startDate,*finishDate;
        
        //        startDate = startDateBtn.titleLabel.text;
        //
        //        startDate = [startDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //
        //        finishDate = finishDateBtn.titleLabel.text;
        //
        //        finishDate = [finishDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSMutableDictionary *paramURL= [[NSMutableDictionary alloc] initWithDictionary: @{id_type:course_id,
                                                                                          @"session_name":session_name.text,
                                                                                          @"start_date":startdate,
                                                                                          @"finish_date":finishdate,
                                                                                          @"lessions_no":no_of_lessions.text,
                                                                                          @"venu_unit":unit_txtField.text,
                                                                                          @"venu_building_name":building_name.text,
                                                                                          @"venu_street":number_street.text,
                                                                                          @"venu_district":district.text,
                                                                                          @"venu_country_id":country_id,
                                                                                          @"venu_state_id":state_id,
                                                                                          @"venu_city_id" : city_id,
                                                                                          @"age_group":age_id,
                                                                                          @"suitable_for":suitable_id,
                                                                                          @"main_language":instruction_lang.text,
                                                                                          @"supported_language":support_lang.text,
                                                                                          @"total_students":max_student.text,
                                                                                          @"places":available_places.text,
                                                                                          @"fee_currency":currencyId,
                                                                                          @"fee_quantity":course_fee.text,
                                                                                          @"url_check":@"",
                                                                                          @"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
                                                                                          @"check_address_type": @"1"}];
        
        NSLog(@"%@", paramURL);
        
        if (isselectPrevAdd && isPrevAddress) {
            
            [paramURL setObject:@"1" forKey:@"address_repeat"];
        }
        
        int i = 0;
        
        for (UIButton *button in date_btn_array) {
            
            NSString *lesson = [NSString stringWithFormat:@"lession_date%d", i];
            
            NSString *dateStr = button.titleLabel.text;
            
            dateStr = [dateArr objectAtIndex:i];
            
            dateStr = [dateStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            
            [paramURL setObject:dateStr forKey:lesson];
            
            i = i+1;
        }
        
        int j = 0;
        for (UIButton *button in starTime_btn_array) {
            
            NSString *lesson = [NSString stringWithFormat:@"start_time%d", j];
            
            NSString *dateStr = button.titleLabel.text;
            
            dateStr = [dateStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            
            [paramURL setObject:dateStr forKey:lesson];
            j = j+1;
        }
        
        int k =0;
        for (UIButton *button in finishTime_btn_array) {
            
            NSString *lesson = [NSString stringWithFormat:@"finish_time%d", k];
            
            NSString *dateStr = button.titleLabel.text;
            
            dateStr = [dateStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
            
            [paramURL setObject:dateStr forKey:lesson];
            
            k= k+1;
        }
        
        NSLog(@"%@", paramURL);
        
        [addSessionConnection startConnectionWithString:webservice_url HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([addSessionConnection responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                    
                    if (isEdit) {
                        
                        NSDictionary *paramURL = @{ @"course_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"]};
                        
                        NSLog(@"%@",paramURL);
                        
                        //                    [self.view addSubview:indicator];
                        //
                        //                    [getCourseConn startConnectionWithString:[NSString stringWithFormat:@"course_view"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
                        //
                        //                        [indicator removeFromSuperview];
                        //
                        //                        if ([getCourseConn responseCode] == 1) {
                        //
                        //                            NSLog(@"%@", receivedData);
                        //
                        //                            NSDictionary *cousreDetailArray = [receivedData copy];
                        //
                        //                            [[NSUserDefaults standardUserDefaults] setObject:cousreDetailArray forKey:@"CourseDetail"];
                        //
                        //
                        //                        }
                        
                        if (save_view) {
                           
                            MyListingViewController *myListingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myListing"];
                                
                            [self.navigationController pushViewController:myListingVC animated:YES];
                                
                            
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You have successfully saved the Listing. For other members to see it, please ensure to click the 'post' icon on this Listing in your My Listings." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                            
                            [alertView show];
                            
                        }  else {
                            
                            AddSessionViewController *aVc = [self.storyboard instantiateViewControllerWithIdentifier:@"addSession"];
                            
                            aVc.isPrevAddress =YES;
                            
                            [self.navigationController pushViewController:aVc animated:YES];
                            
                            //                        session_name.text = @"";
                            //                        no_of_lessions.text = @"0";
                            //                        unit_txtField.text = @"";
                            //                        building_name.text = @"";
                            //                        number_street.text = @"";
                            //                        district.text = @"";
                            //
                            //                        support_lang.text = @"";
                            //                        course_fee.text = @"";
                            //
                            //                        [instructionLgBtn setTitle:@"  Select Instruction Language" forState:UIControlStateNormal];
                            //
                            //                        [supportingLgBtn setTitle:@"  Select Supporting Language" forState:UIControlStateNormal];
                            //
                            //                        [suitable_forBtn setTitle:@"  Select" forState:UIControlStateNormal];
                            //
                            //                        [age_groupBtn setTitle:@"  Select" forState:UIControlStateNormal];
                            //
                            //                        [startDateBtn setTitle:@"  Select" forState:UIControlStateNormal];
                            //
                            //                        [finishDateBtn setTitle:@"  Select" forState:UIControlStateNormal];
                            //
                            //                        available_places.text = @"";
                            //                        max_student.text = @"";
                            //
                            //
                            //                        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1500);
                            
                            //You have successfully saved the Listing with the session option {insert the session name}. You may now add another session option.
                            
                            //Your have successfully saved the Listing with session option {Insert Listing Name}. You may now add another session option.
                            
                            NSString *pmsg =[[@"Your have successfully saved the Listing with session option "stringByAppendingString:session_name.text]stringByAppendingString:@". You may now add another session option."];
                            
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:pmsg delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                            
                            [alertView show];
                        }
                        //                    }];
                    }
                    
                    else{
                        
                        if (save_view) {
                            
                            MyListingViewController *myListingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myListing"];
                                
                            [self.navigationController pushViewController:myListingVC animated:YES];
                            
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You have successfully saved the Listing. For other members to see it, please ensure to click the 'post' icon on this Listing in your My Listings." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                            
                            [alertView show];
                            
                        }  else {
                            
                            AddSessionViewController *aVc = [self.storyboard instantiateViewControllerWithIdentifier:@"addSession"];
                            
                            aVc.isPrevAddress =YES;
                            
                            [self.navigationController pushViewController:aVc animated:YES];
                            
                            //                        session_name.text = @"";
                            //                        no_of_lessions.text = @"0";
                            //                        unit_txtField.text = @"";
                            //                        building_name.text = @"";
                            //                        number_street.text = @"";
                            //                        district.text = @"";
                            //
                            //                        support_lang.text = @"";
                            //                        course_fee.text = @"";
                            //
                            //                        [instructionLgBtn setTitle:@"  Select Instruction Language" forState:UIControlStateNormal];
                            //
                            //                        [supportingLgBtn setTitle:@"  Select Supporting Language" forState:UIControlStateNormal];
                            //
                            //                        [suitable_forBtn setTitle:@"  Select" forState:UIControlStateNormal];
                            //
                            //                        [age_groupBtn setTitle:@"  Select" forState:UIControlStateNormal];
                            //
                            //                        [startDateBtn setTitle:@"  Select" forState:UIControlStateNormal];
                            //
                            //                        [finishDateBtn setTitle:@"  Select" forState:UIControlStateNormal];
                            //
                            //                        available_places.text = @"";
                            //                        max_student.text = @"";
                            //
                            //
                            //                        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1500);
                            
                            NSString *pmsg =[[@"Your have successfully saved the Listing with session option "stringByAppendingString:session_name.text]stringByAppendingString:@". You may now add another session option."];
                            
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:pmsg delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                            
                            [alertView show];
                        }
                        
                        
                    }
                    
                } else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please fill all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
            }
        }];
    }
}

-(void)saveAndPost{
    
    [indicator removeFromSuperview];
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":course_id,@"type":@"1",@"status":@"1"};
    
    [saveAndPostConn startConnectionWithString:@"post_list" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if([saveAndPostConn responseCode] == 1){
            
            NSLog(@"recieved data:",receivedData);
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Your Session has been successfully added & Your Listing has been successfully posted.Now post your Listing on \"What's On!\" to get more eye-balls on it. It's FREE." delegate:self cancelButtonTitle:@"ok Thanks" otherButtonTitles:nil, nil];
            
            [alert show];
            
            UIStoryboard *st = self.storyboard;
            
            addWhatsOnViewController *aVC = [st instantiateViewControllerWithIdentifier:@"addWhatsOnVC"];
            
            [self.navigationController pushViewController:aVC animated:YES];
            
        }
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)tapSave_addAnother:(id)sender {
    
    save_view = NO;
    
    [self checkDataValidation];
}

- (IBAction)tap_save_view:(id)sender {
    
    save_view = YES;
    
    [self checkDataValidation];
}

- (IBAction)tapSaveAndPost_btn:(id)sender {
    
    saveAndPost = YES;
    
    save_view = NO;
    
    [self checkDataValidation];
    
}

- (IBAction)tap_cancel:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You have successfully updated the Listing. For other members to see it, please ensure to click the 'post' icon once again on this Listing in your My Listings." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"reload"];
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
    if (isEdit) {
        
        [alertView show];
    }
 
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)tap_checkBtn:(id)sender {
    
    if (isCheckTap) {
        
        isCheckTap = NO;
        
        [checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        for (UIButton *button in starTime_btn_array){
            
            button.userInteractionEnabled = YES;
        }
        
        for (UIButton *button in finishTime_btn_array){
            
            button.userInteractionEnabled = YES;
        }
        
    } else {
        
        isCheckTap = YES;
        
        [checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        
        //if (isLesson_startBtn)
        
        {
            
            int i =0;
            
            NSString *time;
            
            for (UIButton *button in starTime_btn_array) {
                
                
                if(i == 0){
                    
                    time = button.titleLabel.text;
                    
                } else {
                    
                    [button setTitle:time forState:UIControlStateNormal];
                    
                    [timeIndexArr replaceObjectAtIndex:i withObject:[timeIndexArr objectAtIndex:0]];
                    
                    button.userInteractionEnabled = NO;
                    
                }
                
                
                i++;
                
                if([[timeIndexArr objectAtIndex:0] isEqualToString:@"1000"]){
                    
                    
                    [button setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                    
                } else {
                    
                    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
                
            }
            
            
            //   } else {
            
            i = 0;
            
            for (UIButton *button in finishTime_btn_array) {
                
                // [button setTitle:date forState:UIControlStateNormal];
                
                
                if(i == 0){
                    
                    time = button.titleLabel.text;
                    
                } else {
                    
                    [button setTitle:time forState:UIControlStateNormal];
                    
                    button.userInteractionEnabled = NO;
                }
                
                i++;
                
                if([time isEqualToString:@"  Select Finish Time"]){
                    
                    [button setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                    
                } else {
                    
                    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
                
            }
        }
        
    }
}

- (IBAction)tap_startDate:(id)sender {
    
    isTapCurrency = NO;
    
    tapDate_session = NO;
    
    tapStartTime = NO;
    
    tapEndTime = NO;
    
    [self tapLessonDateBtn:sender];
    
}

- (IBAction)tap_finishDate:(id)sender {
    
    if(startdate != nil) {
        
        isTapCurrency = NO;
        
        tapDate_session = NO;
        
        tapStartTime = NO;
        
        tapEndTime = NO;
        
        [self tapLessonDateBtn:sender];
        
    }
    
    
}

-(IBAction)tap_age_group:(id)sender {
    
    isTapAge = YES;
    
    ageArray = @[@{@"id":@"1",@"name":@"Babies (0 - 1 yrs.)"}, @{@"id":@"2",@"name":@"Toddlers (1 - 2 yrs.)"}, @{@"id":@"3",@"name":@"Pre-School Children (2 - 5 yrs.)"}, @{@"id":@"4",@"name":@"Early Primary Students (5 - 7 yrs.)"}, @{@"id":@"5",@"name":@"Primary Students (7 - 12 yrs.)"},@{@"id":@"6",@"name":@"Early Secondary Students (12 - 14 yrs.)"},@{@"id":@"7",@"name":@"Secondary Students (15 - 18 yrs.)"}, @{@"id":@"8",@"name":@"Tertiary Students (18 yrs. +)"}, @{@"id":@"9",@"name":@"Professional Students (18 yrs. +)"}, @{@"id":@"10",@"name":@"Adult Students (18 yrs. +)"}];
    
    [self showListData:[ageArray valueForKey:@"name"] allowMultipleSelection:YES selectedData:[age_groupBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Age Group"];
}

- (IBAction)tap_suitable_for:(id)sender {
    
    isTapAge = NO;
    
    suitableArray = @[@{@"id":@"3",@"name":@"Males"}, @{@"id":@"4",@"name":@"Females"}];
    
    [self showListData:[suitableArray valueForKey:@"name"] allowMultipleSelection:YES selectedData:[suitable_forBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Suitable For"];
}

- (IBAction)tap_currency:(id)sender {
    
    isTapCurrency = YES;
    
    pickerArray = @[@{@"id":@"0", @"name":@"Select"},@{@"id":@"0", @"name":@"HKD"},@{@"id":@"1", @"name":@"SGD"},@{@"id":@"2", @"name":@"THB"},@{@"id":@"3", @"name":@"MYR"},@{@"id":@"4", @"name":@"PHP"},@{@"id":@"5", @"name":@"IRD"},@{@"id":@"6", @"name":@"RMB"}, @{@"id":@"7", @"name":@"USD"}];
    
    [self showPicker];
    
}

#pragma mark County

- (IBAction)tapCountryBtn:(id)sender {
    
    isTapAge = NO;
    isCity = NO;
    isState = NO;
    isCountry = YES;
    
    [self fetchLocation:@"country"];
}

- (IBAction)tapStateBtn:(id)sender {
    
    if ([country_id length] > 0) {
        
        isTapAge = NO;
        isCity = NO;
        isState = YES;
        isCountry = NO;
        
        [self fetchLocation:@"state"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please select country first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (IBAction)tapCityBtn:(id)sender {
    
    if ([state_id length] > 0) {
        
        isTapAge = NO;
        isCity = YES;
        isState = NO;
        isCountry = NO;
        
        [self fetchLocation:@"city"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please select state first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

-(void)fetchLocation:(NSString *)url {
    
    NSDictionary *paramURL;
    
    if (isCountry) {
        
        paramURL = @{};
        
    } else if (isState){
        
        paramURL = @{@"country_id" : country_id};
        
    } else if (isCity) {
        
        paramURL = @{@"state_id" : state_id};
    }
    
    [self.view addSubview:indicator];
    
    [locationConnection startConnectionWithString:url HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([locationConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if (isCountry) {
                
                countryArray = [receivedData valueForKey:@"country"];
                
                [self showListData:[[countryArray valueForKey:@"Country"] valueForKey:@"country_name"] allowMultipleSelection:NO selectedData:[countryBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Country"];
                
            } else if (isState){
                
                stateArray = [receivedData valueForKey:@"state"];
                
                [self showListData:[[stateArray valueForKey:@"State"] valueForKey:@"state_name"] allowMultipleSelection:NO selectedData:[stateBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"State"];
                
            } else if (isCity) {
                
                locationArray = [receivedData valueForKey:@"city"];
                
                [self showListData:[[locationArray valueForKey:@"City"] valueForKey:@"city_name"] allowMultipleSelection:NO selectedData:[cityBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"City"];
            }
        }
    }];
}

-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title {
    
    ListingViewController *listViewController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"listingVC"];
        
    } else {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil] instantiateViewControllerWithIdentifier:@"listingVC"];
    }
    
    listViewController.isMultipleSelected = allowMultipleSelection;
    
    listViewController.array_data = [items mutableCopy];
    
    listViewController.selectedData = [selectedData mutableCopy];
    
    listViewController.delegate = self;
    
    listViewController.title = title;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - list delegate

-(void)didSelectListItem:(id)item index:(NSInteger)index {
    
    if (isCountry) {
        
        NSString *name = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"country_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [countryBtn setTitle:name forState:UIControlStateNormal];
        
        country_id = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"id"];
        
    } else if (isState){
        
        NSString *name = [[[stateArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"state_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [stateBtn setTitle:name forState:UIControlStateNormal];
        
        state_id = [[[stateArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"id"];
        
    } else if (isCity) {
        
        NSString *name = [[[locationArray objectAtIndex:index] valueForKey:@"City"] valueForKey:@"city_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [cityBtn setTitle:name forState:UIControlStateNormal];
        
        city_id = [[[locationArray objectAtIndex:index] valueForKey:@"City"] valueForKey:@"id"];
    }
    
    else if (isInstructionLg){
        
        NSString *name = [languageArray objectAtIndex:index];
        
        name = [@"  " stringByAppendingString:name];
        
        [instructionLgBtn setTitle:name forState:UIControlStateNormal];
        
        [instructionLgBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        instruction_lang.text = name;
        
    }
    
    else if (isSupportingLg){
        
        NSString *name = [languageArray objectAtIndex:index];
        
        name = [@"  " stringByAppendingString:name];
        
        [supportingLgBtn setTitle:name forState:UIControlStateNormal];
        
        [supportingLgBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        support_lang.text = name;
        
    }
    
    else if (isselectPrevAdd){
        
        NSString *name = [prevAddressArray objectAtIndex:index];
        
        name = [@"  " stringByAppendingString:name];
        
        [add_btn setTitle:name forState:UIControlStateNormal];
        
        [add_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        unit_txtField.text = [[addArray objectAtIndex:index]valueForKey:@"unit"];
        
        building_name.text = [[addArray objectAtIndex:index]valueForKey:@"building_name"];
        
        number_street.text = [[addArray objectAtIndex:index]valueForKey:@"venu_street"];
        
        district.text = [[addArray objectAtIndex:index]valueForKey:@"venu_district"];
        
        NSString *city_name = [[addArray objectAtIndex:index]valueForKey:@"city_name"];
        
        city_name = [@"  "stringByAppendingString:city_name];
        
        [cityBtn setTitle:city_name forState:UIControlStateNormal];
        
        NSString *state_name = [[addArray objectAtIndex:index]valueForKey:@"state_name"];
        
        state_name = [@"  "stringByAppendingString:state_name];
        
        [stateBtn setTitle:state_name forState:UIControlStateNormal];
        
        NSString *country_name = [[addArray objectAtIndex:index]valueForKey:@"country_name"];
        
        country_name = [@"  "stringByAppendingString:country_name];
        
        [countryBtn setTitle:country_name forState:UIControlStateNormal];
        
        country_id =[[addArray objectAtIndex:index]valueForKey:@"country_id"];
        
        state_id = [[addArray objectAtIndex:index]valueForKey:@"state_id"];
        
        city_id = [[addArray objectAtIndex:index]valueForKey:@"city_id"];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSaveItems:(NSArray*)items indexs:(NSArray *)indexs{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *array_selectedInterest = [NSMutableArray array];
    
    NSMutableArray *array_Ids = [NSMutableArray array];
    
    NSArray *listDataArray;
    
    if (isTapAge) {
        
        listDataArray = ageArray;
        
    } else {
        
        listDataArray = suitableArray;
    }
    
    for (NSIndexPath *indexPath in indexs) {
        
        NSLog(@"IndexPath:%ld",(long)indexPath.row);
        
        if (indexs.count > listDataArray.count) {
            
            if (indexPath.row < listDataArray.count) {
                
                [array_selectedInterest addObject:[listDataArray[indexPath.row] valueForKey :@"name"]];
                
                [array_Ids addObject:[listDataArray[indexPath.row] valueForKey :@"id" ]];
            }
            
        } else {
            
            [array_selectedInterest addObject:[listDataArray[indexPath.row-1] valueForKey:@"name"]];
            
            [array_Ids addObject:[listDataArray[indexPath.row-1] valueForKey :@"id" ]];
        }
    }
    
    NSString *str = [array_selectedInterest  componentsJoinedByString:@", "];
    
    str = [@"  " stringByAppendingString:str];
    
    NSString *str_ids = [array_Ids  componentsJoinedByString:@","];
    
    if (isTapAge) {
        
        [age_groupBtn setTitle:str forState:UIControlStateNormal];
        
        [age_groupBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        
        
        age_id = str_ids;
        
    } else {
        
        [suitable_forBtn setTitle:str forState:UIControlStateNormal];
        
        [suitable_forBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        
        
        suitable_id = str_ids;
    }
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    float kbHeight = 0.0;
    
    if (kbSize.width > kbSize.height) {
        
        kbHeight = kbSize.height;
        
    } else {
        
        // kbHeight = kbSize.width;
        
        kbHeight = kbSize.height;
    }
    
    //NSLog(@"%f", self.view.frame.origin.x);
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbHeight;
    
    //-120
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(67, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
    
    scrollView.contentInset = contentInsets;
    
    
    //    UIView *activeView = activeField;
    //
    //    if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
    //
    //        [scrollView scrollRectToVisible: activeView.frame  animated:YES];
    //    }
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
    scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-124);
    
    //    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    [self.view endEditing:YES];
}

-(void)fetchlanguages{
    
    NSDictionary *paramURL = @{};
    
    [self.view addSubview:indicator];
    
    [languageConn startConnectionWithString:@"language_list" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([languageConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            NSArray *LgArray = [receivedData valueForKey:@"language_info"];
            
            for(int i =0; i< LgArray.count; i++)
            {
                [languageArray addObject:[[[LgArray objectAtIndex:i]valueForKey:@"Language"]valueForKey:@"name"]];
                
                
            }
            
            if (isInstructionLg) {
                
                [self showListData:languageArray allowMultipleSelection:NO selectedData:[instructionLgBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Instruction Languages"];
                
            }
            
            else{
                
                [self showListData:languageArray allowMultipleSelection:NO selectedData:[supportingLgBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Supporting Languages"];
                
            }
            
            
        }}];
    
}


- (IBAction)tap_instructionLgBtn:(id)sender {
    
    isInstructionLg = YES;
    
    isSupportingLg = NO;
    
    isCity = NO;
    
    isState = NO;
    
    isCountry = NO;
    
    isselectPrevAdd = NO;
    
    [self fetchlanguages];
    
    
}

- (IBAction)tap_supportingLgBtn:(id)sender {
    
    isSupportingLg = YES;
    
    isInstructionLg = NO;
    
    isCity = NO;
    
    isState = NO;
    
    isCountry = NO;
    
    isselectPrevAdd = NO;
    
    [self fetchlanguages];
}

- (IBAction)tapStartDateInfo_btn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The first date of the course." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    
}

- (IBAction)tapFinishdateInfo_btn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The last date of the course." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    
}

- (IBAction)tapDate_TimeInfo_btn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The total number of lessons in the whole course, and the specific lesson dates and times." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    
}
- (IBAction)tapVenueInfo_btn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"This is where the course is held.\n(1) On the Listing you and others will see the street, number and suburb or district, but members who enroll will see the full address in their enrollment confirmation.\n (2) Ensure you enter a complete address here, as this information is used on the Google map geo locator on your Listing on the website. In most cases Google map is 100% accurate, and other times close to accurate. But at least the map provides an indicator of the course vacinity.\n  (3) If your course is ONLINE, simply place the word 'Online' where it is marked. " delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertView show];
    
}

- (IBAction)tapAgeInfo_btn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"These are approximate age groups. You can select more than one age group if needed." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    
}

- (IBAction)tapInstructionInfo_btn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The language used to teach the subject or content of the course." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    
}

- (IBAction)tapFeeInfo_btn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The total fee for the course from the start to the finish, not including books, materials, deposit and optional fees." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    
}
- (IBAction)tap_infoBtn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"If your Course has a number of different session options available, you can add more than one session option. Add one session option per page." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertView show];
    
}

-(void)tapCkeck_btn {
    
    if (istapCheck ==1) {
        
        CGRect frame = add_btn_view.frame;
        
        frame.origin.y = add_check_view.frame.origin.y + add_check_view.frame.size.height+8;
        
        add_btn_view.frame = frame;
        
        frame = main_view.frame;
        
        frame.origin.y = add_btn_view.frame.origin.y + add_btn_view.frame.size.height+8;
        
        main_view.frame = frame;
        
        
    } else {
        
        //CGRect frame = main_view.frame;
        
        //frame.origin.y = add_check_view.frame.origin.y + add_check_view.frame.size.height+8;
        
        // main_view.frame = frame;
        
    }
    
    
}

- (IBAction)tap_check_btn:(id)sender {
    
    if (istapCheck ==0) {
        
        istapCheck = 1;
        
        [check_btn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        add_btn_view.hidden = NO;
        
        CGRect frame = add_btn_view.frame;
        
        frame.origin.y = add_check_view.frame.origin.y + add_check_view.frame.size.height+8;
        
        add_btn_view.frame = frame;
        
        frame = main_view.frame;
        
        frame.origin.y = add_btn_view.frame.origin.y + add_btn_view.frame.size.height+8;
        
        main_view.frame = frame;
        
        unit_txtField.userInteractionEnabled = NO;
        building_name.userInteractionEnabled = NO;
        number_street.userInteractionEnabled = NO;
        district.userInteractionEnabled = NO;
        
        
    }
    else{
        
        istapCheck = 0;
        
        [check_btn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        add_btn_view.hidden = YES;
        
        CGRect frame = main_view.frame;
        
        frame.origin.y = add_check_view.frame.origin.y + add_check_view.frame.size.height+8;
        
        main_view.frame = frame;
        
        unit_txtField.userInteractionEnabled = YES;
        building_name.userInteractionEnabled = YES;
        number_street.userInteractionEnabled = YES;
        district.userInteractionEnabled = YES;
        
    }
    
    
}
- (IBAction)tap_add_btn:(id)sender {
    
    NSDictionary *paramURL = @{@"type_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"],@"type":@"1"};
    
    [self.view addSubview:indicator];
    
    [addConn startConnectionWithString:@"prev_address" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([addConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            NSArray *dataArr;
            
            dataArr = [receivedData valueForKey:@"new_address"];
            
            
            NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:dataArr];
            
            addArray = [orderedSet array];
            
            prevAddressArray = [[NSMutableArray alloc] init];
            
            for(int i =0; i< addArray.count; i++)
            {
                NSString *unit = [[addArray objectAtIndex:i]valueForKey:@"unit"];
                
                if ([unit isEqualToString:@""]) {
                    
                    unit = @"";
                }
                else{
                    
                    unit =[unit stringByAppendingString:@", "];
                }
                
                NSString *building_Name = [[addArray objectAtIndex:i]valueForKey:@"building_name"];
                
                if ([building_Name isEqualToString:@""]) {
                    
                    building_Name = @"";
                }
                else{
                    
                    building_Name =[building_Name stringByAppendingString:@", "];
                }
                
                NSString *venu_street = [[addArray objectAtIndex:i]valueForKey:@"venu_street"];
                
                if ([venu_street isEqualToString:@""]) {
                    
                    venu_street = @"";
                }
                else{
                    
                    venu_street =[venu_street stringByAppendingString:@", "];
                }
                
                NSString *venu_district = [[addArray objectAtIndex:i]valueForKey:@"venu_district"];
                
                if ([venu_district isEqualToString:@""]) {
                    
                    venu_district = @"";
                }
                else{
                    
                    venu_district =[venu_district stringByAppendingString:@", "];
                }
                
                NSString *city_name = [[addArray objectAtIndex:i]valueForKey:@"city_name"];
                
                if ([city_name isEqualToString:@""]) {
                    
                    city_name = @"";
                }
                else{
                    
                    city_name =[city_name stringByAppendingString:@", "];
                }
                
                NSString *state_name = [[addArray objectAtIndex:i]valueForKey:@"state_name"];
                
                if ([state_name isEqualToString:@""]) {
                    
                    state_name = @"";
                }
                else{
                    
                    state_name =[state_name stringByAppendingString:@", "];
                }
                
                NSString *country_name = [[addArray objectAtIndex:i]valueForKey:@"country_name"];
                
                NSString *add = [[[[[[unit stringByAppendingString:building_Name]stringByAppendingString:venu_street]stringByAppendingString:venu_district]stringByAppendingString:city_name]stringByAppendingString:state_name]stringByAppendingString:country_name];
                
                
                [prevAddressArray addObject:add];
                
            }
            isselectPrevAdd = YES;
            
            isSupportingLg = NO;
            
            isInstructionLg = NO;
            
            isCity = NO;
            
            isState = NO;
            
            isCountry = NO;
            
            [self showListData:prevAddressArray allowMultipleSelection:NO selectedData:[add_btn.titleLabel.text componentsSeparatedByString:@", "] title:@"Select Address"];
            
        }}];
    
    
}
@end