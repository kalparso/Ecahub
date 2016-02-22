//
//  EditEventSessionViewController.m
//  ecaHUB
//
//  Created by promatics on 4/7/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EditEventSessionViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "addWhatsOnViewController.h"
#import "MyListingViewController.h"

@interface EditEventSessionViewController () {
    
    WebServiceConnection *addSessionConnection, *postConnection;
    
    WebServiceConnection *locationConnection, *languageConn,*addConn;
    
    Indicator *indicator;
    
    UIDatePicker *datePicker;
    
    UIToolbar *toolBar;
    
    UIPickerView *pickerView;
    
    UIBarButtonItem *cancelBarButton;
    
    UIBarButtonItem *doneBarButton;
    
    BOOL tapDate_session;
    
    UIButton *selectedBtn;
    
    BOOL tapDate;
    
    id activeField;
    
    NSMutableArray *starTime_btn_array;
    
    NSMutableArray *finishTime_btn_array , *lesson_labelNoArray;
    
    NSMutableArray *date_btn_array, *languageArray;
    
    NSArray *ageArray;
    
    NSArray  *suitableArray;
    
    NSString *age_id;
    
    NSString *suitable_id;
    
    BOOL isTapAge;
    
    NSArray *pickerArray;
    
    NSString *currencyId,*startdate,*finishdate;
    
    BOOL isTapCurrency;
    
    BOOL save_view, save_post;
    
    BOOL isCheckTap;
    
    BOOL isLesson_startBtn;
    
    BOOL isCountry;
    
    BOOL isState;
    
    BOOL isCity;
    
    NSString *city_id;
    
    NSString *country_id;
    
    NSString *state_id, *session_id;
    
    NSArray *countryArray;
    
    NSArray *locationArray;
    
    NSArray *stateArray;
    
    CGFloat lable_width;
    
    BOOL isTapView, isSupportingLg, isMainLg;
    
    NSDictionary *sessionData;
    
    DateConversion *dateConversion;
    
    NSArray *lession_array;
    
    CGFloat height;
    
    NSMutableArray *timeArr;
    
    NSString *startTime;
    
    NSString *endTime;
    
    NSInteger startTimeIndex;
    
    BOOL tapStartTime,tapEndTime;
    
    BOOL isavilprevAdd;
    
    NSInteger istapCheck;
    
    NSMutableArray *prevAddressArray;
    
    BOOL isselectPrevAdd;
    
    BOOL isInstructionLg;
    
    NSArray *addArray;
    
    NSString *course_id ;
    
}
@end

@implementation EditEventSessionViewController

@synthesize scrollView, session_name, startDateBtn, finishDateBtn, no_of_lessions, checkBoxBtn, lession_dateBtn, lession_start_time, lession_finish_time, lession_view, lession_subView, unit_txtField, building_name, number_street, district, town, city, age_groupBtn, main_view, suitable_forBtn, instruction_lang, support_lang, max_student, available_places, currencyBtn, course_fee, save_addAnotherBtn, save_view_sessionBtn, cancelBtn, countryBtn, stateBtn, cityBtn, event_finish_time, event_start_time, eventView, freeEventBtn,infoBtn,main_Lg,supporting_Lg,saveAndpost,isEdit,venur_lbl_view,add_btn,add_btn_view,add_check_view,check_btn,isPrevAddress;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //  self.navigationController.navigationBar.topItem.title = @"";
    
    self.title = @"Edit Session Option";
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]);
    
    sessionData = [[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"];
    
    saveAndpost.hidden = YES;
    
    addSessionConnection = [WebServiceConnection connectionManager];

    locationConnection = [WebServiceConnection connectionManager];

    languageConn = [WebServiceConnection connectionManager];

    postConnection = [WebServiceConnection connectionManager];
    
    addConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    [save_view_sessionBtn setTitle:@"Save" forState:UIControlStateNormal];
    
    lesson_labelNoArray = [[NSMutableArray alloc] init];
    
    languageArray = [[NSMutableArray alloc]init];
    
    instruction_lang.hidden = YES;
    
    support_lang.hidden = YES;
    
    tapDate = YES;
    
    isTapAge = YES;
    
    isCountry = NO;
    
    isState = NO;
    
    isCity = NO;
    
    tapDate_session = NO;
    
    isTapCurrency = NO;
    
    save_view = YES;
    
    save_post = NO;
    
    isCheckTap = NO;
    
    isLesson_startBtn = YES;
    
    isTapView = NO;
    
    isSupportingLg = NO;
    
    isMainLg = NO;
    
    self.navigationController.navigationBar.shadowImage = nil;
    
    dateConversion = [DateConversion dateConversionManager];
    
    CGRect frame = save_view_sessionBtn.frame;
    frame.origin.y = eventView.frame.origin.y + eventView.frame.size.height + 10;
    save_view_sessionBtn.frame = frame;
    
    frame = cancelBtn.frame;
    frame.origin.y = save_view_sessionBtn.frame.origin.y + save_view_sessionBtn.frame.size.height + 10;
    
    cancelBtn.frame = frame;
    
    [self prepareInterface];
    
    [event_start_time addTarget:self action:@selector(tapLessonStartTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [event_finish_time addTarget:self action:@selector(tapLessonFinishTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [freeEventBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
}

-(void) prepareInterface {
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        lable_width = 400.0f;
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2500);
        
        height = 2100.0f;
        
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
        
        saveAndpost.layer.cornerRadius = 5.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        lable_width = 250.0f;
        
        saveAndpost.layer.cornerRadius = 5.0f;
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1400);
        
        height = 1400.0f;
        
    }
    
    main_Lg.layer.borderWidth = 1.0f;
    
    main_Lg.layer.borderColor = [UIColor blackColor].CGColor;
    
    main_Lg.layer.cornerRadius = 5.0f;
    
    supporting_Lg.layer.borderWidth = 1.0f;
    
    supporting_Lg.layer.borderColor = [UIColor blackColor].CGColor;
    
    supporting_Lg.layer.cornerRadius = 5.0f;
    
    session_name.layer.borderWidth = 1.0f;
    
    session_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    session_name.layer.cornerRadius = 5.0f;
    
    no_of_lessions.layer.borderWidth = 1.0f;
    
    no_of_lessions.layer.borderColor = [UIColor blackColor].CGColor;
    
    no_of_lessions.layer.cornerRadius = 5.0f;
    
    unit_txtField.layer.borderWidth = 1.0f;
    
    unit_txtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    unit_txtField.layer.cornerRadius = 5.0f;
    
    building_name.layer.borderWidth = 1.0f;
    
    building_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    building_name.layer.cornerRadius = 5.0f;
    
    number_street.layer.borderWidth = 1.0f;
    
    number_street.layer.borderColor = [UIColor blackColor].CGColor;
    
    number_street.layer.cornerRadius = 5.0f;
    
    district.layer.borderWidth = 1.0f;
    
    district.layer.borderColor = [UIColor blackColor].CGColor;
    
    district.layer.cornerRadius = 5.0f;
    
    countryBtn.layer.borderWidth = 1.0f;
    
    countryBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    countryBtn.layer.cornerRadius = 5.0f;
    
    stateBtn.layer.borderWidth = 1.0f;
    
    stateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    stateBtn.layer.cornerRadius = 5.0f;
    
    cityBtn.layer.borderWidth = 1.0f;
    
    cityBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    cityBtn.layer.cornerRadius = 5.0f;
    
    town.layer.borderWidth = 1.0f;
    
    town.layer.borderColor = [UIColor blackColor].CGColor;
    
    town.layer.cornerRadius = 5.0f;
    
    city.layer.borderWidth = 1.0f;
    
    city.layer.borderColor = [UIColor blackColor].CGColor;
    
    city.layer.cornerRadius = 5.0f;
    
    check_btn.layer.borderWidth = 1.0f;
    
    check_btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    check_btn.backgroundColor = [UIColor whiteColor];
    
    check_btn.layer.cornerRadius = 3.0f;
    
    instruction_lang.layer.borderWidth = 1.0f;
    
    instruction_lang.layer.borderColor = [UIColor blackColor].CGColor;
    
    instruction_lang.layer.cornerRadius = 5.0f;
    
    support_lang.layer.borderWidth = 1.0f;
    
    support_lang.layer.borderColor = [UIColor blackColor].CGColor;
    
    support_lang.layer.cornerRadius = 5.0f;
    
    max_student.layer.borderWidth = 1.0f;
    
    max_student.layer.borderColor = [UIColor blackColor].CGColor;
    
    max_student.layer.cornerRadius = 5.0f;
    
    available_places.layer.borderWidth = 1.0f;
    
    available_places.layer.borderColor = [UIColor blackColor].CGColor;
    
    available_places.layer.cornerRadius = 5.0f;
    
    course_fee.layer.borderWidth = 1.0f;
    
    course_fee.layer.borderColor = [UIColor blackColor].CGColor;
    
    course_fee.layer.cornerRadius = 5.0f;
    
    startDateBtn.layer.borderWidth = 1.0f;
    
    startDateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    startDateBtn.layer.cornerRadius = 5.0f;
    
    finishDateBtn.layer.borderWidth = 1.0f;
    
    finishDateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    finishDateBtn.layer.cornerRadius = 5.0f;
    
    lession_start_time.layer.borderWidth = 1.0f;
    
    lession_start_time.layer.borderColor = [UIColor blackColor].CGColor;
    
    lession_start_time.layer.cornerRadius = 5.0f;
    
    lession_finish_time.layer.borderWidth = 1.0f;
    
    lession_finish_time.layer.borderColor = [UIColor blackColor].CGColor;
    
    lession_finish_time.layer.cornerRadius = 5.0f;
    
    age_groupBtn.layer.borderWidth = 1.0f;
    
    age_groupBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    age_groupBtn.layer.cornerRadius = 5.0f;
    
    suitable_forBtn.layer.borderWidth = 1.0f;
    
    suitable_forBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    suitable_forBtn.layer.cornerRadius = 5.0f;
    
    currencyBtn.layer.borderWidth = 1.0f;
    
    currencyBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    currencyBtn.layer.cornerRadius = 5.0f;
    
    event_start_time.layer.borderWidth = 1.0f;
    
    event_start_time.layer.borderColor = [UIColor blackColor].CGColor;
    
    event_start_time.layer.cornerRadius = 5.0f;
    
    event_finish_time.layer.borderWidth = 1.0f;
    
    event_finish_time.layer.borderColor = [UIColor blackColor].CGColor;
    
    event_finish_time.layer.cornerRadius = 5.0f;
    
    save_addAnotherBtn.layer.cornerRadius = 5.0f;
    
    save_view_sessionBtn.layer.cornerRadius = 5.0f;
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    freeEventBtn.layer.borderWidth = 1.0f;
    
    freeEventBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    freeEventBtn.backgroundColor = [UIColor whiteColor];
    
    freeEventBtn.layer.cornerRadius = 3.0f;
    
    add_btn.layer.borderWidth = 1.0f;
    
    add_btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    add_btn.layer.cornerRadius = 5.0f;
    
    [add_btn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    //    [self addLessons:@"1"];
    
    lession_view.hidden = YES;
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    CGRect frame = add_check_view.frame;
    
    frame.origin.y = venur_lbl_view.frame.origin.y + venur_lbl_view.frame.size.height+8;
    
    add_check_view.frame = frame;
    
    frame = main_view.frame;
    
    frame.origin.y = add_check_view.frame.origin.y + add_check_view.frame.size.height+8;
    
    main_view.frame = frame;
    
    add_btn_view.hidden = YES;
    
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    [scrollView addGestureRecognizer:tapScroll];
    
    starTime_btn_array = [[NSMutableArray alloc] init];
    
    finishTime_btn_array = [[NSMutableArray alloc] init];
    
    date_btn_array = [[NSMutableArray alloc] init];
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(donePicker:)];
    
    tapgest.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapgest];
    
    [self setData];
}

-(void)setData {
    
     course_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"event_id"];
    
    session_name.text =[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"session_name"];
    
    NSString *dateStr = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"start_date"];
    
    if ([dateStr isEqualToString:@""]) {
        
        dateStr = @"0000-00-00 00:00";
    }
    
    startdate = dateStr;
    
    dateStr = [dateConversion convertDate:dateStr];
    
    dateStr = [@"  " stringByAppendingString:dateStr];
    
    [startDateBtn setTitle:dateStr forState:UIControlStateNormal];
    
    dateStr = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"finish_date"];
    
    if ([dateStr isEqualToString:@""]) {
        
        dateStr = @"0000-00-00 00:00";
    }
    
    dateStr = [dateConversion convertDate:dateStr];
    
    dateStr = [@"  " stringByAppendingString:dateStr];
    
    [finishDateBtn setTitle:dateStr forState:UIControlStateNormal];
    
    //    long no_lesson = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonTiming"] count];
    //
    //    no_of_lessions.text = [NSString stringWithFormat:@"%lu", no_lesson];
    
    lession_array = [[sessionData valueForKey:@"course_session"] valueForKey:@"LessonTiming"];
    //[[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"main_language"];
    // [self addLessons:[NSString stringWithFormat:@"%lu", no_lesson]];
    
    unit_txtField.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"venu_unit"];
    
    building_name.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"venu_building_name"];
    
    number_street.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"venu_street"];
    
    district.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"venu_district"];
    
    NSString *value = [@"  " stringByAppendingString:[[[sessionData valueForKey:@"course_session"] valueForKey:@"Country"] valueForKey:@"country_name"]];
    
    [countryBtn setTitle:value forState:UIControlStateNormal];
    
    countryBtn.userInteractionEnabled = NO;
    
    value = [@"  " stringByAppendingString:[[[sessionData valueForKey:@"course_session"] valueForKey:@"State"] valueForKey:@"state_name"]];
    
    [stateBtn setTitle:value forState:UIControlStateNormal];
    
    stateBtn.userInteractionEnabled = NO;
    
    value = [@"  " stringByAppendingString:[[[sessionData valueForKey:@"course_session"] valueForKey:@"City"] valueForKey:@"city_name"]];
    
    [cityBtn setTitle:value forState:UIControlStateNormal];
    
    cityBtn.userInteractionEnabled = NO;
    
    NSMutableArray *age = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[sessionData valueForKey:@"age_group"] count]; i++) {
        
        [age addObject:[[[[sessionData valueForKey:@"age_group"] objectAtIndex:i] valueForKey:@"AgeGroup"] valueForKey:@"title"]];
    }
    
    value = [age componentsJoinedByString:@", "];
    
    value = [@"  " stringByAppendingString:value];
    
    [age_groupBtn setTitle:value forState:UIControlStateNormal];
    
    NSMutableArray *suitabeArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[sessionData valueForKey:@"suitable"] count]; i++) {
        
        [suitabeArray addObject:[[[[sessionData valueForKey:@"suitable"] objectAtIndex:i] valueForKey:@"Suitable"] valueForKey:@"title"]];
    }
    
    value = [suitabeArray componentsJoinedByString:@", "];
    
    value = [@"  " stringByAppendingString:value];
    
    [suitable_forBtn setTitle:value forState:UIControlStateNormal];
    
    NSString *mainlg = [[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"main_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    instruction_lang.text = mainlg;
    
    mainlg = [@"  " stringByAppendingString:mainlg];
    
    [main_Lg setTitle:mainlg forState:UIControlStateNormal];
    
    mainlg = [[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"supported_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    support_lang.text = mainlg;
    
    mainlg = [@"  " stringByAppendingString:mainlg];
    
    [supporting_Lg setTitle:mainlg forState:UIControlStateNormal];
    
    max_student.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"total_students"];
    
    available_places.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"places"];
    
    course_fee.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"fee_quantity"];
    
    startTime = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"start_time"];
    
    startTime = [startTime uppercaseString];
    
    [self setStartTimeArr];
    
    startTime = [@"  " stringByAppendingString:startTime];
    
    
    [event_start_time setTitle:startTime forState:UIControlStateNormal];
    
    NSString *finishTime = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"finish_time"];
    
    finishTime = [@"  " stringByAppendingString:finishTime];
    
    [event_finish_time setTitle:finishTime forState:UIControlStateNormal];
    
    value = [[[sessionData valueForKey:@"course_session"] valueForKey:@"Currency"] valueForKey:@"name"];
    
    value = [@"  " stringByAppendingString:value];
    
    [currencyBtn setTitle:value forState:UIControlStateNormal];
    
    session_id = [[sessionData valueForKey:@"sesion"] valueForKey:@"id"];
    
    country_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"venu_country_id"];
    
    city_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"venu_city_id"];
    
    state_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"venu_state_id"];
    
    age_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"age_group"];
    
    suitable_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"suitable_for"];
    
    currencyId = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"fee_currency"];
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
    
    frame.size.height = frame.size.height * no_lessons;
    
    lession_view.frame = frame;
    
    frame = main_view.frame;
    
    frame.origin.y = lession_view.frame.origin.y + 160 * no_lessons;
    
    main_view.frame = frame;
    
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, height + 160 * no_lessons)];
    
    int count = 0;
    
    for (UIButton *button in date_btn_array) {
        
        if (count < lession_array.count) {
            
            NSString *str = [@"  " stringByAppendingString:[[lession_array objectAtIndex:count] valueForKey:@"date_selected"]];
            
            [button setTitle:str forState:UIControlStateNormal];
            
        } else {
            
            [button setTitle:@"  Select Date" forState:UIControlStateNormal];
        }
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [button addTarget:self action:@selector(tapSessionDate:) forControlEvents:UIControlEventTouchUpInside];
        
        count = count +1;
    }
    
    count = 0;
    
    for (UIButton *button in starTime_btn_array) {
        
        if (count < lession_array.count) {
            
            NSString *str = [@"  " stringByAppendingString:[[lession_array objectAtIndex:count] valueForKey:@"start_time"]];
            
            [button setTitle:str forState:UIControlStateNormal];
            
        } else {
            
            [button setTitle:@"  Select Start Time" forState:UIControlStateNormal];
        }
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [button addTarget:self action:@selector(tapLessonStartTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        count = count +1;
    }
    
    count = 0;
    
    for (UIButton *button in finishTime_btn_array) {
        
        if (count < lession_array.count) {
            
            NSString *str = [@"  " stringByAppendingString:[[lession_array objectAtIndex:count] valueForKey:@"finish_time"]];
            
            [button setTitle:str forState:UIControlStateNormal];
            
        } else {
            
            [button setTitle:@"  Select Finish Time" forState:UIControlStateNormal];
        }
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [button addTarget:self action:@selector(tapLessonFinishTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        count = count +1;
    }
    
    count = 0;
}

-(void)setStartTimeArr{
    
    //stTimeArr = [[NSMutableArray alloc]init];
    
    int m=0,h=6;
    
    NSString *timeStr;
    
    for (int i =0;i<216;i++){
        
        timeStr = [NSString stringWithFormat:@"%d:",h];
        
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
        
        
        if([startTime isEqualToString:timeStr]){
            
            startTimeIndex = i;
            
            break;
        }
        
        //[stTimeArr addObject:timeStr];
        
        
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
    }
    
    
    //[self addPicker_toolBar];
    
    
    [self showPicker];
    
}

-(void)tapLessonFinishTimeBtn:(UIButton *)button {
    
    selectedBtn = button;
    
    tapDate = NO;
    
    isTapCurrency = NO;
    
    isLesson_startBtn = NO;
    
    tapStartTime = NO;
    
    tapEndTime = YES;
    
    // [self addPicker_toolBar];
    
    timeArr = [[NSMutableArray alloc]init];
    
    if([startTime length]>0){
        
        int m=0,h=6;
        
        NSString *timeStr;
        
        for (int i =0;i<=216;i++){
            
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
    
    datePicker = [[UIDatePicker alloc] init];
    
    if (tapDate) {
        
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        
        [datePicker setMinimumDate:[NSDate date]];
        
        if (tapDate_session ) {
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            
            [format setDateFormat:@"yyyy-MM-dd"];
            
            NSString *startDate = startDateBtn.titleLabel.text;
            
            startDate = [startDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *finishDate = finishDateBtn.titleLabel.text;
            
            finishDate = [finishDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [datePicker setMinimumDate:[format dateFromString:startDate]];
            
            [datePicker setMaximumDate:[format dateFromString:finishDate]];
            
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
    
    toolBar.items = @[cancelBarButton, flexibleItem, doneBarButton];
    
    [self.view addSubview:toolBar];
    
    [self.view addSubview:datePicker];
}

-(void)cancelPicker:(UIBarButtonItem *)sender {
    
    [toolBar removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    [pickerView removeFromSuperview];
}

-(void)donePicker:(UIBarButtonItem *)sender {
    
    NSString *date;
    
    
    if (isTapCurrency) {
        
        NSLog(@"%@", @"Done");
        
    } else {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        if (tapDate) {
            
            //  [format setDateFormat:@"dd MMM yyyy"];
            [format setDateFormat:@"yyyy-MM-dd"];
            
        } else {
            
            [format setDateFormat:@"hh:mm a"];
        }
        
        date = [format stringFromDate:[datePicker date]];
        
        if (tapDate) {
            
            [format setDateFormat:@"yyyy-MM-dd"];
            
            if (selectedBtn == startDateBtn) {
                
                //startdate = [format stringFromDate:[datePicker date]];
                
            }else{
                
                //finishdate = [format stringFromDate:[datePicker date]];
            }
        }
        
        //selectedBtn == finishDateBtn
        
        if (tapEndTime) {
            
            NSLog(@"%d",([[datePicker date] compare:[format dateFromString:startDateBtn.titleLabel.text]] == NSOrderedSame));
            
            startTime = event_start_time.titleLabel.text;
            
            startTime = [startTime stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
            
            date = [@"  " stringByAppendingString:endTime];
            
            finishdate = endTime;
            
            [selectedBtn setTitle:date forState:UIControlStateNormal];
            
            [selectedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            tapEndTime = NO;
            
            //            if (([[datePicker date] compare:[format dateFromString:startTime]] == NSOrderedDescending)) {
            //
            //                date = [@"  " stringByAppendingString:date];
            //
            //                [selectedBtn setTitle:date forState:UIControlStateNormal];
            //
            //                [selectedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            //
            //            } else {
            //
            //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Finish Date can't be less then start date" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //                [alert show];
            //
            //                [selectedBtn setTitle:@"  Select" forState:UIControlStateNormal];
            //            }
            
        } else {
            
            if(tapStartTime) {
                
                date = [@"  " stringByAppendingString:startTime];
                
                [selectedBtn setTitle:date forState:UIControlStateNormal];
                
                [selectedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
                [event_finish_time setTitle:@"  Select" forState:UIControlStateNormal];
                
                tapStartTime = NO;
                
            } else {
                
                startdate = date;
                
                date = [dateConversion convertDate:date];
                
                date = [@"  " stringByAppendingString:date];
                
                [selectedBtn setTitle:date forState:UIControlStateNormal];
                
                [selectedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
                
            }
        }
    }
    
    if (isCheckTap && !tapDate) {
        
        if (isLesson_startBtn) {
            
            for (UIButton *button in starTime_btn_array) {
                
                [button setTitle:date forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
        } else {
            
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
        
        NSString *pickerValue = [[pickerArray objectAtIndex:row] valueForKey:@"name"];
        
        NSString *data_id = [[pickerArray objectAtIndex:row] valueForKey:@"id"];
        
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
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == no_of_lessions) {
        
        [self addLessons:no_of_lessions.text];
    }
    
    activeField = nil;
}

#pragma mark - Add Session

-(void) checkDataValidation {
    
    NSString *message;
    
    if ([session_name.text isEqualToString:@""]) {
        
        message = @"Please enter session name";
        
    } else if ([startDateBtn.titleLabel.text isEqualToString:@"  Start Date"]) {
        
        message = @"Please select start date";
        
    } else if ([event_start_time.titleLabel.text isEqualToString:@"  Start time of event"]) {
        
        message = @"Please select Start time";
        
    } else if ([event_finish_time.titleLabel.text isEqualToString:@"  Finish time of event"]) {
        
        message = @"Please select Finish time";
        
    } else if ([number_street.text isEqualToString:@""]) {
        
        message = @"Please enter the street name";
        
    } else if ([district.text isEqualToString:@""]) {
        
        message = @"Please enter the district name";
        
    } else if ([countryBtn.titleLabel.text isEqualToString:@"  Select Country"]) {
        
        message = @"Please select the country";
        
    } else if ([cityBtn.titleLabel.text isEqualToString:@"  Select City"]) {
        
        message = @"Please select the city";
        
    } else if ([stateBtn.titleLabel.text isEqualToString:@"  Select State"]) {
        
        message = @"Please select the stste";
        
    } else if ([age_groupBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select age group";
        
    } else if ([suitable_forBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select suitable for";
        
    } else if ([instruction_lang.text isEqualToString:@""]) {
        
        message = @"Please enter the main language";
        
    } else if ([max_student.text isEqualToString:@""]) {
        
        message = @"Please enter number of students";
        
    } else if ([available_places.text isEqualToString:@""]) {
        
        message = @"Please enter the available places";
        
    } else if ([currencyBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select currency";
        
    } else if ([course_fee.text isEqualToString:@""]) {
        
        message = @"Please enter fee";
        
    }
    
    //    for (UIButton *button in date_btn_array) {
    //
    //        if ([button.titleLabel.text isEqualToString:@"  Select Date"]) {
    //
    //            message = @"Please enter lesson Date";
    //
    //            break;
    //        }
    //    }
    //
    //    for (UIButton *button in starTime_btn_array) {
    //
    //        if ([button.titleLabel.text isEqualToString:@"  Select Time"]) {
    //
    //            message = @"Please enter lesson Start Time";
    //
    //            break;
    //        }
    //    }
    //
    //    for (UIButton *button in finishTime_btn_array) {
    //
    //        if ([button.titleLabel.text isEqualToString:@"  Select Time"]) {
    //
    //            message = @"Please enter lesson Finish Time";
    //
    //            break;
    //        }
    //    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.view addSubview:indicator];
        
        
        NSString *startDate,*finishDate, *startTime, *finishTime;
        
        startDate = startDateBtn.titleLabel.text;
        
        startDate = [startDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        finishDate = finishDateBtn.titleLabel.text;
        
        finishDate = [finishDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        startTime = event_start_time.titleLabel.text;
        
        startTime = [startTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        finishTime = event_finish_time.titleLabel.text;
        
        finishTime = [finishTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        NSMutableDictionary *paramURL= [[NSMutableDictionary alloc] initWithDictionary: @{@"event_id":course_id,@"session_id" : session_id, @"session_name":session_name.text, @"start_date":startdate, @"venu_unit":unit_txtField.text, @"venu_building_name":building_name.text, @"venu_street":number_street.text, @"venu_district":district.text, @"venu_country_id":country_id, @"venu_state_id":state_id,@"venu_city_id" : city_id, @"age_group":age_id, @"suitable_for":suitable_id, @"main_language":instruction_lang.text, @"supported_language":support_lang.text, @"total_students":max_student.text, @"places":available_places.text, @"fee_currency":currencyId, @"fee_quantity":course_fee.text, @"url_check":@"", @"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"check_address_type": @"1", @"start_time":startTime, @"finish_time":finishTime}];
        
        if (isPrevAddress && isselectPrevAdd) {
            
            [paramURL setObject:@"1" forKey:@"address_repeat"];
        }
        
        NSLog(@"%@", paramURL);
        
        //        int i = 0;
        //
        //        for (UIButton *button in date_btn_array) {
        //
        //            NSString *lesson = [NSString stringWithFormat:@"lession_date%d", i];
        //
        //            NSString *dateStr = button.titleLabel.text;
        //
        //            dateStr = [dateStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        //
        //            [paramURL setObject:dateStr forKey:lesson];
        //
        //            i = i+1;
        //        }
        //
        //        int j = 0;
        //        for (UIButton *button in starTime_btn_array) {
        //
        //            NSString *lesson = [NSString stringWithFormat:@"start_time%d", j];
        //
        //            NSString *dateStr = button.titleLabel.text;
        //
        //            dateStr = [dateStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        //
        //            [paramURL setObject:dateStr forKey:lesson];
        //
        //            j = j+1;
        //        }
        //
        //        int k =0;
        //        for (UIButton *button in finishTime_btn_array) {
        //
        //            NSString *lesson = [NSString stringWithFormat:@"finish_time%d", k];
        //
        //            NSString *dateStr = button.titleLabel.text;
        //
        //            dateStr = [dateStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        //
        //            [paramURL setObject:dateStr forKey:lesson];
        //
        //            k= k+1;
        //        }
        //
        //        NSLog(@"%@", paramURL);
        
        
        [addSessionConnection startConnectionWithString:[NSString stringWithFormat:@"add_events_sessions"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([addSessionConnection responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                if (save_view) {
                    
                    MyListingViewController *myListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myListing"];
                    
                    [self.navigationController pushViewController:myListVC animated:YES];
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You have successfully saved the Listing. For other members to see it, please ensure to click the 'post' icon on this Listing in your My Listings." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                } else if(save_post)
                {
                    
                    save_post = NO;
                    
                    [self saveAndPost];
                }
                else {
                    
                    //                        lession_view.hidden = YES;
                    //
                    //                        CGRect frame = main_view.frame;
                    //
                    //                        frame.origin.y = no_of_lessions.frame.origin.y + 100;
                    //
                    //                        main_view.frame = frame;
                    
                    session_name.text = @"";
                    
                    [startDateBtn setTitle:@"  Select Start Date" forState:UIControlStateNormal];
                    
                    //finishDateBtn.titleLabel.text = @"  Select Finish Date";
                    [finishDateBtn setTitle:@"  Select Finish Date" forState:UIControlStateNormal];
                    
                    [main_Lg setTitle:@"  Select Main Language" forState:UIControlStateNormal];
                    
                    [supporting_Lg setTitle:@"  Select Supporting Language" forState:UIControlStateNormal];
                    
                    no_of_lessions.text = @"";
                    //unit_txtField.text = @"";
                    //building_name.text = @"";
                    ////number_street.text = @"";
                    //district.text = @"";
                    //town.text = @"";
                    //city.text = @"";
                    support_lang.text = @"";
                    [age_groupBtn setTitle:@"  Select" forState:UIControlStateNormal];
                    [suitable_forBtn setTitle:@"  Select" forState:UIControlStateNormal];
                    instruction_lang.text = @"";
                    max_student.text = @"";
                    available_places.text = @"";
                    [currencyBtn setTitle:@"  Select" forState:UIControlStateNormal];
                    course_fee.text = @"";
                    
                    if (isCheckTap) {
                        
                        isCheckTap = NO;
                        
                        [freeEventBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
                        
                        eventView.hidden = NO;
                        
                        CGRect frame = save_addAnotherBtn.frame;
                        frame.origin.y = eventView.frame.origin.y + eventView.frame.size.height +15;
                        save_addAnotherBtn.frame = frame;
                        
                        frame = save_view_sessionBtn.frame;
                        frame.origin.y = save_addAnotherBtn.frame.origin.y + save_addAnotherBtn.frame.size.height + 10;
                        save_view_sessionBtn.frame = frame;
                        
                        frame = cancelBtn.frame;
                        frame.origin.y = save_view_sessionBtn.frame.origin.y + save_view_sessionBtn.frame.size.height + 10;
                        cancelBtn.frame = frame;
                    }
                    
                    
                    //scrollView.frame = self.view.frame;
                    
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1350);
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Session has been Successfully saved." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)tapSave_addAnother:(id)sender {
    
    save_view = NO;
    
    save_post = NO;
    
    [self checkDataValidation];
}

- (IBAction)tap_save_view:(id)sender {
    
    save_view = YES;
    
    save_post = NO;
    
    [self checkDataValidation];
}

- (IBAction)tap_cancel:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You have successfully updated the Listing. For other members to see it, please ensure to click the 'post' icon once again on this Listing in your My Listings." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    MyListingViewController *myListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myListing"];
    
    [self.navigationController pushViewController:myListVC animated:YES];
    
    [alertView show];
}

-(IBAction)tapFreeEventBtn:(id)sender {
    
    UIStoryboard *storyboard;
    
    if (isCheckTap) {
        
        isCheckTap = NO;
        
        [freeEventBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        eventView.hidden = NO;
        
        CGRect frame = save_view_sessionBtn.frame;
        frame.origin.y = eventView.frame.origin.y + eventView.frame.size.height +15;
        save_view_sessionBtn.frame = frame;
        
        frame = saveAndpost.frame;
        frame.origin.y = save_view_sessionBtn.frame.origin.y + save_view_sessionBtn.frame.size.height +10;
        saveAndpost.frame = frame;
        
        frame = cancelBtn.frame;
        frame.origin.y = save_view_sessionBtn.frame.origin.y + save_view_sessionBtn.frame.size.height + 10;
        cancelBtn.frame = frame;
        
        course_fee.text = @"";
        
        [currencyBtn setTitle:@"  Select" forState:UIControlStateNormal];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2500);
           
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1400);
          
        }
        
        
    } else {
        
        isCheckTap = YES;
        
        [freeEventBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        CGRect frame = save_view_sessionBtn.frame;
        frame.origin.y = eventView.frame.origin.y;
        save_view_sessionBtn.frame = frame;
        
        frame = saveAndpost.frame;
        frame.origin.y = save_view_sessionBtn.frame.origin.y + save_view_sessionBtn.frame.size.height + 10;
        saveAndpost.frame = frame;
        
        frame = cancelBtn.frame;
        frame.origin.y = save_view_sessionBtn.frame.origin.y + save_view_sessionBtn.frame.size.height + 10;
        cancelBtn.frame = frame;
        
        course_fee.text = @"00.00";
        
        [currencyBtn setTitle:@"" forState:UIControlStateNormal];
        
        eventView.hidden = YES;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2400);
            
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1300);
            
        }
    }
}

- (IBAction)tap_checkBtn:(id)sender {
    
    if (isCheckTap) {
        
        isCheckTap = NO;
        
        [checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
    } else {
        
        isCheckTap = YES;
        
        [checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
}

- (IBAction)tap_startDate:(id)sender {
    
    isTapCurrency = NO;
    
    tapDate_session = NO;
    
    [self tapLessonDateBtn:sender];
    
}

- (IBAction)tap_finishDate:(id)sender {
    
    isTapCurrency = NO;
    
    tapDate_session = NO;
    
    [self tapLessonDateBtn:sender];
}

- (IBAction)tap_age_group:(id)sender {
    
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
    isSupportingLg = NO;
    isMainLg = NO;
    
    [self fetchLocation:@"country"];
}

- (IBAction)tapStateBtn:(id)sender {
    
    if ([country_id length] > 0) {
        
        isTapAge = NO;
        isCity = NO;
        isState = YES;
        isCountry = NO;
        isSupportingLg = NO;
        isMainLg = NO;
        
        [self fetchLocation:@"state"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please select country first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (IBAction)tapCityBtn:(id)sender {
    
    if ([state_id length] > 0) {
        
        isTapAge = NO;
        isCity = YES;
        isState = NO;
        isCountry = NO;
        isSupportingLg = NO;
        isMainLg = NO;
        
        [self fetchLocation:@"city"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please select state first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
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
    
    else if (isMainLg){
        
        NSString *name = [languageArray objectAtIndex:index];
        
        name = [@"  " stringByAppendingString:name];
        
        [main_Lg setTitle:name forState:UIControlStateNormal];
        
        instruction_lang.text = name;
        
    }
    
    else if (isSupportingLg){
        
        NSString *name = [languageArray objectAtIndex:index];
        
        name = [@"  " stringByAppendingString:name];
        
        [supporting_Lg setTitle:name forState:UIControlStateNormal];
        
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
    
    scrollView.frame = self.view.frame;
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.main_view.frame.origin.y + self.main_view.frame.size.height)];

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
        
        age_id = str_ids;
        
    } else {
        
        [suitable_forBtn setTitle:str forState:UIControlStateNormal];
        
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
        
        kbHeight = kbSize.width;
    }
    
    NSLog(@"%f", self.view.frame.origin.x);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
    //    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    scrollView.contentInset = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbHeight;
    
    UIView *activeView = activeField;
    
    if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
        
        [scrollView scrollRectToVisible: activeView.frame  animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
    scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-120);
    
    //    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
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
            
            if (isMainLg) {
                
                [self showListData:languageArray allowMultipleSelection:NO selectedData:[main_Lg.titleLabel.text componentsSeparatedByString:@", "] title:@"Instruction Languages"];
                
            }
            
            else{
                
                [self showListData:languageArray allowMultipleSelection:NO selectedData:[supporting_Lg.titleLabel.text componentsSeparatedByString:@", "] title:@"Supporting Languages"];
                
            }
            
            
        }}];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    [self.view endEditing:YES];
}

- (IBAction)tap_mainLg:(id)sender {
    
    isSupportingLg = NO;
    
    isMainLg = YES;
    
    isCity = NO;
    
    isState = NO;
    
    isCountry = NO;
    
    [self fetchlanguages];
}

- (IBAction)tap_infoBtn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"If your Event has a number of different sessions available, you can add different session options." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    
}
- (IBAction)tap_supportLg:(id)sender {
    
    isSupportingLg = YES;
    
    isMainLg = NO;
    
    isCity = NO;
    
    isState = NO;
    
    isCountry = NO;
    
    [self fetchlanguages];
}

- (IBAction)tapEventDateInfo_btn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The date of the event." delegate:self cancelButtonTitle:@"Ok Thanks." otherButtonTitles:nil, nil];
    
    [alert show];
    
}

- (IBAction)tapVanuInfo_btn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"This is where the event is held.  (1) On the Listing you and others will see the street, number and suburb or district, but members who book will see the full address in their booking confirmation.\n(2) Ensure you enter a complete address here, as this information is used on the Google map geo locator on your Listing. In most cases Google map is 100% accurate, and other times close to accurate. But at least the map provides an indicator of the event vacinity. " delegate:self cancelButtonTitle:@"Ok Thanks." otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

- (IBAction)tapAgegroupInfo_btn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"These are approximate age groups. You can select more than one age group if needed." delegate:self cancelButtonTitle:@"Ok Thanks." otherButtonTitles:nil, nil];
    
    [alert show];
    
}

- (IBAction)tapLangMediumInfo_btn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The Language used by organizers and participants." delegate:self cancelButtonTitle:@"Ok Thanks." otherButtonTitles:nil, nil];
    
    [alert show];
    
}

- (IBAction)tapFeeInfo_btn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The fee per individual entry." delegate:self cancelButtonTitle:@"Ok Thanks." otherButtonTitles:nil, nil];
    
    [alert show];
    
}

-(void)saveAndPost{
    
    NSString *event_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"event_id"];
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":event_id,@"type":@"2",@"status":@"1"};
    
    [postConnection startConnectionWithString:@"post_list" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([postConnection responseCode] ==1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Your Session has been successfully added & Your Listing has been successfully posted.Now post your Listing on \"What's On!\" to get more eye-balls on it. It's FREE." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                alert.tag = 1;
                
                [alert show];
                
                UIStoryboard *st = self.storyboard;
                
                addWhatsOnViewController *aVC = [st instantiateViewControllerWithIdentifier:@"addWhatsOnVC"];
                
                [self.navigationController pushViewController:aVC animated:YES];
                
                
            }
        }
    }];
    
}
- (IBAction)tapSaveAndPost:(id)sender {
    
    save_view = NO;
    
    save_post = YES;
    
    [self checkDataValidation];
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
        
        scrollView.frame = self.view.frame;
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.main_view.frame.origin.y + self.main_view.frame.size.height)];
        
        
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
        
        scrollView.frame = self.view.frame;
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.main_view.frame.origin.y + self.main_view.frame.size.height)];
        
    }
    
    
}
- (IBAction)tap_add_btn:(id)sender {
    
    NSDictionary *paramURL = @{@"type_id":course_id,@"type":@"2"};
    
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
