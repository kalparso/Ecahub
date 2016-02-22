//  editLessionSessionViewController.m
//  ecaHUB
//
//  Created by promatics on 4/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "editLessionSessionViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "addWhatsOnViewController.h"
#import "MyListingViewController.h"

@interface editLessionSessionViewController () {
    
    WebServiceConnection *addSessionConnection, *postConnection;
    
    WebServiceConnection *locationConnection, *languageConn, *addConn;
    
    Indicator *indicator;
    
    UIDatePicker *datePicker;
    
    UIToolbar *toolBar;
    
    UIPickerView *pickerView;
    
    UIBarButtonItem *cancelBarButton;
    
    UIBarButtonItem *doneBarButton;
    
    UIButton *selectedBtn;
    
    BOOL tapDate;
    
    id activeField;
    
    NSMutableArray *starTime_btn_array;
    
    NSMutableArray *finishTime_btn_array , *lesson_labelNoArray;
    
    NSMutableArray *date_btn_array, *languageArray,*prevAddressArray;
    
    NSArray *ageArray;
    
    NSArray  *suitableArray;
    
    NSString *age_id, *type_lesson;
    
    NSString *suitable_id, *startdate,*finishdate;
    
    BOOL isTapAge;
    
    NSArray *pickerArray;
    
    NSString *currencyId;
    
    BOOL isTapCurrency;
    
    BOOL save_view;
    
    BOOL isCheckTap;
    
    BOOL isLesson_startBtn;
    
    BOOL isCountry;
    
    BOOL tapDate_session, isTapDay;
    
    BOOL isState;
    
    BOOL isCity;
    
    BOOL isSavePost;
    
    NSString *city_id;
    
    NSString *country_id, *countdown;
    
    NSString *state_id, *session_id;
    
    NSArray *countryArray;
    
    NSArray *locationArray;
    
    NSArray *stateArray;
    
    CGFloat lable_width;
    
    BOOL isTapView, isTapTimeSlot, isSupportingLg, isMainLg, isRemoveSess;
    
    NSDictionary *sessionData;
    
    DateConversion *dateConversion;
    
    NSArray *lession_array, *addArray;
    
    NSMutableArray *lessonDataArray;
    
    CGFloat height;
    
    int lesson_noSession;
    
    NSMutableArray *timeArr;
    
    NSString *startTime;
    
    NSString *endTime;
    
    NSInteger startTimeIndex;
    
    BOOL tapStartTime,tapEndTime;
    
    NSMutableArray *timeIndexArr;
    
    NSMutableArray *stTimeArr;
    
    NSInteger lessonCounter;
    
    BOOL isselectPrevAdd;
    
    int istapCheck;
    
}
@end

@implementation editLessionSessionViewController

@synthesize scrollView, session_name, startDateBtn, finishDateBtn, no_of_lessions, checkBoxBtn, lession_dateBtn, lession_start_time, lession_finish_time, lession_view, lession_subView, unit_txtField, building_name, number_street, district, age_groupBtn, main_view, suitable_forBtn, instruction_lang, support_lang, max_student, available_places, currencyBtn, course_fee, save_addAnotherBtn, save_view_sessionBtn, cancelBtn, countryBtn, stateBtn, cityBtn, add_dayView, venue_view, sub_view, max_student_view, indefinitly_view,available_placesLbl,selectSupportingBtn,saveandpostBtn,selectMainLgBtn,removeLastOneBtn,add_Btn,addBtn_view,venuelbl_view,check_addbox_view,checkadd_Btn,isPrevAddavail;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Edit Session Option";
    
    lessonCounter = 0;
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    instruction_lang.hidden = YES;
    
    support_lang.hidden = YES;
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]);
    
    sessionData = [[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"];
    
    addSessionConnection = [WebServiceConnection connectionManager];
    
    addConn = [WebServiceConnection connectionManager];
    
    languageConn = [WebServiceConnection connectionManager];
    
    locationConnection = [WebServiceConnection connectionManager];
    
    postConnection = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    lesson_labelNoArray = [[NSMutableArray alloc] init];
    
    languageArray = [[NSMutableArray alloc]init];
    
    tapDate = YES;
    
    isTapAge = YES;
    
    isTapTimeSlot = NO;
    
    isCountry = NO;
    
    isState = NO;
    
    isCity = NO;
    
    isTapDay = NO;
    
    isTapCurrency = NO;
    
    save_view = YES;
    
    isCheckTap = NO;
    
    tapDate_session = NO;
    
    isLesson_startBtn = YES;
    
    isTapView = NO;
    
    isSupportingLg = NO;
    
    isMainLg = NO;
    
    isSavePost = NO;
    
    istapCheck = 0;
    
    dateConversion = [DateConversion dateConversionManager];
    
    [self prepareInterface];
    
    [self setscrollContent];
    
    
}

-(void)setscrollContent{
    
    CGRect frame = max_student_view.frame;
    
    frame.size.height = cancelBtn.frame.origin.y + cancelBtn.frame.size.height;
    
    max_student_view.frame = frame;
    
    frame = sub_view.frame;
    
    frame.size.height = max_student_view.frame.origin.y + max_student_view.frame.size.height;
    
    sub_view.frame = frame;
    
    frame = main_view.frame;
    
    frame.size.height = sub_view.frame.origin.y + sub_view.frame.size.height;
    
    main_view.frame = frame;
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, main_view.frame.origin.y + main_view.frame.size.height+60)];
}

-(void) prepareInterface {
    
    session_name.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"e.g. Monday Morning Sessions, Advance Group" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    available_places.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter a number e.g. 16" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    max_student.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"No. of seats remaining" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    type_lesson = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"lesson_type"];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        lable_width = 400.0f;
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2800);
        
        height = 2800;
        
        saveandpostBtn.layer.cornerRadius = 7;
        
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
        
        saveandpostBtn.layer.cornerRadius = 5;
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1350);
        
        height = 1350;
        
    }
    
    if ([type_lesson isEqualToString:@"3"] || [type_lesson isEqualToString:@"4"]) {
        
        venue_view.hidden = YES;
        
        venuelbl_view.hidden = YES;
        
        addBtn_view.hidden = YES;
        
        check_addbox_view.hidden= YES;
        
        country_id = @"";
        
        state_id = @"";
        
        city_id = @"";
        
        if ([type_lesson isEqualToString:@"3"]) {
            
            add_dayView.hidden = NO;
            
            CGRect frames = sub_view.frame;
            
            frames.origin.y = 0.0f;
            
            sub_view.frame = frames;
            
            frames = main_view.frame;
            
            frames.origin.y  = add_dayView.frame.origin.y +add_dayView.frame.size.height +8;
            
            main_view.frame = frames;
            
        }
        else{
            
            add_dayView.hidden = YES;
            
            CGRect frames = sub_view.frame;
            
            frames.origin.y = 0.0f;
            
            sub_view.frame = frames;
            
            frames = main_view.frame;
            
            frames.origin.y  = lession_view.frame.origin.y +lession_view.frame.size.height +8;
            
            main_view.frame = frames;
            
        }
        
    }
    
    if ([type_lesson isEqualToString:@"2"] || [type_lesson isEqualToString:@"1"]) {
        
        if ([type_lesson isEqualToString:@"2"]) {
            
            add_dayView.hidden = YES;
            
            if(!isPrevAddavail){
                
                CGRect frame = venuelbl_view.frame;
                
                frame.origin.y = lession_view.frame.origin.y + lession_view.frame.size.height + 20;
                
                venuelbl_view.frame = frame;
                
                frame = main_view.frame;
                
                frame.origin.y = venuelbl_view.frame.origin.y + venuelbl_view.frame.size.height + 8;
                
                main_view.frame = frame;
                
            } else {
                
                CGRect frame = venuelbl_view.frame;
                
                frame.origin.y = lession_view.frame.origin.y + lession_view.frame.size.height + 20;
                
                venuelbl_view.frame = frame;
                
                frame = check_addbox_view.frame;
                
                frame.origin.y = venuelbl_view.frame.origin.y + venuelbl_view.frame.size.height + 8;
                
                check_addbox_view.frame = frame;
                
                frame = main_view.frame;
                
                frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 8;
                
                main_view.frame = frame;
                
                addBtn_view.hidden = YES;
                
            }
            
        }
        else{
            
            add_dayView.hidden = NO;
            
            if(!isPrevAddavail){
                
                CGRect frame = venuelbl_view.frame;
                
                frame.origin.y = add_dayView.frame.origin.y + add_dayView.frame.size.height + 20;
                
                venuelbl_view.frame = frame;
                
                frame = main_view.frame;
                
                frame.origin.y = venuelbl_view.frame.origin.y + venuelbl_view.frame.size.height + 8;
                
                main_view.frame = frame;
                
            } else {
                
                CGRect frame = venuelbl_view.frame;
                
                frame.origin.y = add_dayView.frame.origin.y + add_dayView.frame.size.height + 20;
                
                venuelbl_view.frame = frame;
                
                frame = check_addbox_view.frame;
                
                frame.origin.y = venuelbl_view.frame.origin.y + venuelbl_view.frame.size.height + 8;
                
                check_addbox_view.frame = frame;
                
                frame = main_view.frame;
                
                frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 8;
                
                main_view.frame = frame;
                
                addBtn_view.hidden = YES;
                
            }
            
        }
        
        
    }
    
    if ([type_lesson isEqualToString:@"1"] || [type_lesson isEqualToString:@"3"]) {
        
        if([type_lesson isEqualToString:@"1"]) {
            
            CGRect frame = main_view.frame;
            
            frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 8;
            
            main_view.frame = frame;
            
            
        }
        
        addBtn_view.hidden = YES;
        
        CGRect frame = max_student_view.frame;
        
        frame.origin.y = support_lang.frame.origin.y + support_lang.frame.size.height + 15;
        max_student_view.frame = frame;
    }
    
    CGRect frame = lession_view.frame;
    
    frame.origin.x = (self.view.frame.size.width - frame.size.width)/2;
    
    frame.origin.y = indefinitly_view.frame.origin.y + 15;
    
    lession_view.frame = frame;
    
    //    frame = add_dayView.frame;
    //    frame.origin.y
    //
    //    frame = main_view.frame;
    //    frame.origin.y = lession_view.frame.origin.y + lession_view.frame.size.height + 15;
    //    main_view.frame = frame;
    
    selectMainLgBtn.layer.borderWidth = 1.0f;
    
    selectMainLgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    selectMainLgBtn.layer.cornerRadius = 5.0f;
    
    selectSupportingBtn.layer.borderWidth = 1.0f;
    
    selectSupportingBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    selectSupportingBtn.layer.cornerRadius = 5.0f;
    
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
    
    stateBtn.userInteractionEnabled = NO;
    
    cityBtn.layer.borderWidth = 1.0f;
    
    cityBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    cityBtn.layer.cornerRadius = 5.0f;
    
    cityBtn.userInteractionEnabled = NO;
    
    instruction_lang.layer.borderWidth = 1.0f;
    
    instruction_lang.layer.borderColor = [UIColor blackColor].CGColor;
    
    instruction_lang.layer.cornerRadius = 5.0f;
    
    support_lang.layer.borderWidth = 1.0f;
    
    support_lang.layer.borderColor = [UIColor blackColor].CGColor;
    
    support_lang.layer.cornerRadius = 5.0f;
    
    max_student.layer.borderWidth = 1.0f;
    
    max_student.layer.borderColor = [UIColor blackColor].CGColor;
    
    max_student.layer.cornerRadius = 5.0f;
    
    max_student.textColor = [UIColor darkGrayColor];
    
    available_places.layer.borderWidth = 1.0f;
    
    available_places.layer.borderColor = [UIColor blackColor].CGColor;
    
    available_places.layer.cornerRadius = 5.0f;
    
    available_places.textColor = [UIColor darkGrayColor];
    
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
    
    save_addAnotherBtn.layer.cornerRadius = 5.0f;
    
    save_view_sessionBtn.layer.cornerRadius = 5.0f;
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    checkBoxBtn.layer.borderWidth = 1.0f;
    
    checkBoxBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    checkBoxBtn.backgroundColor = [UIColor whiteColor];
    
    checkBoxBtn.layer.cornerRadius = 3.0f;
    
    checkadd_Btn.layer.borderWidth = 1.0f;
    
    checkadd_Btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    checkadd_Btn.backgroundColor = [UIColor whiteColor];
    
    checkadd_Btn.layer.cornerRadius = 3.0f;
    
    add_Btn.layer.borderWidth = 1.0f;
    
    add_Btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    add_Btn.layer.cornerRadius = 5.0f;
    
    [add_Btn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    
    //    [self addLessons:@"1"];
    
    //    lession_view.hidden = YES;
    //
    //    frame = main_view.frame;
    //
    //    frame.origin.y = main_view.frame.origin.y - 160;
    //
    //    main_view.frame = frame;
    
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
    
    //UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(donePicker:)];
    
    //  tapgest.cancelsTouchesInView = NO;
    
    // [self.view addGestureRecognizer:tapgest];
    
    [self setStartTimeArr];
    
    [self setData];
    
    
}

-(void)setData {
    
    session_name.text =[[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"session_name"];
    
    NSString *dateStr = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"start_date"];
    
    
    
    if ([dateStr isEqualToString:@""]) {
        
        dateStr = @"  Select";
        
        [startDateBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
        startdate = dateStr;
      
    }
    else{
    
    startdate = dateStr;
    
    dateStr = [dateConversion convertDate:dateStr];
    
    dateStr = [@"  " stringByAppendingString:dateStr];
        
    }
    
    [startDateBtn setTitle:dateStr forState:UIControlStateNormal];
    
    dateStr = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"finish_date"];
    
    if ([dateStr isEqualToString:@""]) {
        
        finishdate = dateStr;
        
        isCheckTap = YES;
        
        [checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        [finishDateBtn setTitle:@"  Indefinite" forState:UIControlStateNormal];
        
        countdown = @"1";
        
        finishDateBtn.userInteractionEnabled = NO;
        
    }
    else{
    
    finishdate = dateStr;
    
    dateStr = [dateConversion convertDate:dateStr];
    
    dateStr = [@"  " stringByAppendingString:dateStr];
        
    [finishDateBtn setTitle:dateStr forState:UIControlStateNormal];
        
    }
    
    long no_lesson = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonTiming"] count];
    
    no_of_lessions.text = [NSString stringWithFormat:@"%lu", no_lesson];
    
    lession_array = [[sessionData valueForKey:@"course_session"] valueForKey:@"LessonTiming"];
    
    //[[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"main_language"];
    
    lessonDataArray = [[NSMutableArray alloc] init];
    
    for (int i =0; i<lession_array.count; i++) {
        
        NSDictionary * dict =  @{@"date_selected":[@"  " stringByAppendingString:[[lession_array objectAtIndex:i] valueForKey:@"day_select"]], @"start_time":[@"  " stringByAppendingString: [[lession_array objectAtIndex:i] valueForKey:@"start_time"]], @"finish_time": [@"  " stringByAppendingString:[[lession_array objectAtIndex:i] valueForKey:@"finish_time"]]};
        
        [lessonDataArray addObject:dict];
    }
    
    lesson_noSession = (int)lession_array.count;
    
    [self addLessons:[NSString stringWithFormat:@"%lu", no_lesson]];
    
    unit_txtField.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"venu_unit"];
    
    building_name.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"venu_building_name"];
    
    number_street.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"venu_street"];
    
    district.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"venu_district"];
    
    NSString *value = [@"  " stringByAppendingString:[[[sessionData valueForKey:@"course_session"] valueForKey:@"Country"] valueForKey:@"country_name"]];
    
    [countryBtn setTitle:value forState:UIControlStateNormal];
    
    countryBtn.userInteractionEnabled = NO;
    
    value = [@"  " stringByAppendingString:[[[sessionData valueForKey:@"course_session"] valueForKey:@"State"] valueForKey:@"state_name"]];
    
    [stateBtn setTitle:value forState:UIControlStateNormal];
    
    value = [@"  " stringByAppendingString:[[[sessionData valueForKey:@"course_session"] valueForKey:@"City"] valueForKey:@"city_name"]];
    
    [cityBtn setTitle:value forState:UIControlStateNormal];
    
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
    
    NSString *mainLg = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"main_language"];
    
    instruction_lang.text = mainLg;
    
    mainLg = [@"  "stringByAppendingString:mainLg];
    
    [selectMainLgBtn setTitle:mainLg forState:UIControlStateNormal];
    
    mainLg = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"supported_language"];
    
    support_lang.text = mainLg;
    
    mainLg = [@"  "stringByAppendingString:mainLg];
    
    [selectSupportingBtn setTitle:mainLg forState:UIControlStateNormal];
    
    max_student.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"total_students"];
    
    available_places.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"places"];
    
    course_fee.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"fee_quantity"];
    
    value = [[[sessionData valueForKey:@"course_session"] valueForKey:@"Currency"] valueForKey:@"name"];
    
    value = [@"  " stringByAppendingString:value];
    
    [currencyBtn setTitle:value forState:UIControlStateNormal];
    
    session_id = [[sessionData valueForKey:@"sesion"] valueForKey:@"id"];
    
    country_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"venu_country_id"];
    
    city_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"venu_city_id"];
    
    state_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"venu_state_id"];
    
    age_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"age_group"];
    
    suitable_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"suitable_for"];
    
    currencyId = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"fee_currency"];
    
    currencyBtn.userInteractionEnabled = NO;
}

-(void)setStartTimeArr{
    
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
        
        [stTimeArr addObject:timeStr];
        
    }
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
    
    if (no_lessons == 0) {
        
        lession_view.frame = CGRectZero;
    }
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        
        for (int i =0; i < no_lessons ; i++) {
            
            UILabel *lesson_no = [[UILabel alloc] initWithFrame:CGRectMake(0,220*i, lable_width, 30)];
            
            lesson_no.hidden = YES;
            
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
            
            [lesson_date addTarget:self action:@selector(tapSessionsDate:) forControlEvents:UIControlEventTouchUpInside];
            
            lesson_date.userInteractionEnabled = YES;
            [lession_view addSubview:lesson_date];
            
            UIButton *lesson_startTime = [[UIButton alloc] initWithFrame:CGRectMake(0, 220*i+105, lable_width, 45)];
            
            lesson_startTime.layer.borderWidth = 1.0f;
            
            lesson_startTime.layer.borderColor = [UIColor blackColor].CGColor;
            
            lesson_startTime.layer.cornerRadius = 5.0f;
            
            [starTime_btn_array addObject:lesson_startTime];
            
            [lesson_startTime addTarget:self action:@selector(tapLessonsStartTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [lession_view addSubview:lesson_startTime];
            
            UIButton *lesson_endTime = [[UIButton alloc] initWithFrame:CGRectMake(0, 220*i+165, lable_width, 45)];
            
            lesson_endTime.titleLabel.textColor = [UIColor darkGrayColor];
            
            lesson_endTime.layer.borderWidth = 1.0f;
            
            lesson_endTime.layer.borderColor = [UIColor blackColor].CGColor;
            
            lesson_endTime.layer.cornerRadius = 5.0f;
            
            [lesson_endTime addTarget:self action:@selector(tapLessonsFinishTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
            [lession_view addSubview:lesson_endTime];
            
            [finishTime_btn_array addObject:lesson_endTime];
            
            //        UIView *footer_view = [[UIView alloc] initWithFrame:CGRectMake(0, lesson_endTime.frame.origin.y + lesson_endTime.frame.size.height + 7.5 , lession_view.frame.size.width, 2)];
            //
            //        footer_view.backgroundColor = [UIColor lightGrayColor];
            //
            //        [lession_view addSubview:footer_view];
        }
        
        CGRect frame = lession_view.frame;
        
        frame.size.height = 220* no_lessons;
        
        frame.origin.x = startDateBtn.frame.origin.x;
        
        frame.origin.y = indefinitly_view.frame.origin.y + indefinitly_view.frame.size.height + 15;
        
        lession_view.frame = frame;
        
        frame = add_dayView.frame;
        
        frame.origin.y = lession_view.frame.origin.y + lession_view.frame.size.height +8;
        
        add_dayView.frame = frame;
        
        if ([type_lesson isEqualToString:@"3"] || [type_lesson isEqualToString:@"4"]) {
            
            venue_view.hidden = YES;
            
            venuelbl_view.hidden = YES;
            
            addBtn_view.hidden = YES;
            
            check_addbox_view.hidden= YES;
            
            country_id = @"";
            
            state_id = @"";
            
            city_id = @"";
            
            if ([type_lesson isEqualToString:@"3"]) {
                
                add_dayView.hidden = NO;
                
                CGRect frames = sub_view.frame;
                
                frames.origin.y = 0.0f;
                
                sub_view.frame = frames;
                
                frames = main_view.frame;
                
                frames.origin.y  = add_dayView.frame.origin.y +add_dayView.frame.size.height +8;
                
                main_view.frame = frames;
                
            }
            else{
                
                add_dayView.hidden = YES;
                
                CGRect frames = sub_view.frame;
                
                frames.origin.y = 0.0f;
                
                sub_view.frame = frames;
                
                frames = main_view.frame;
                
                frames.origin.y  = lession_view.frame.origin.y +lession_view.frame.size.height +8;
                
                main_view.frame = frames;
                
            }
            
        }
        
        if ([type_lesson isEqualToString:@"2"] || [type_lesson isEqualToString:@"1"]) {
            
            if(!isPrevAddavail){
                
                CGRect frame = venuelbl_view.frame;
                
                frame.origin.y = lession_view.frame.origin.y + lession_view.frame.size.height + 20;
                
                venuelbl_view.frame = frame;
                
                frame = main_view.frame;
                
                frame.origin.y = venuelbl_view.frame.origin.y + venuelbl_view.frame.size.height + 8;
                
                main_view.frame = frame;
                
            } else {
                
                CGRect frame = venuelbl_view.frame;
                
                frame.origin.y = lession_view.frame.origin.y + lession_view.frame.size.height + 20;
                
                venuelbl_view.frame = frame;
                
                frame = check_addbox_view.frame;
                
                frame.origin.y = venuelbl_view.frame.origin.y + venuelbl_view.frame.size.height + 8;
                
                check_addbox_view.frame = frame;
                
                frame = main_view.frame;
                
                frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 8;
                
                main_view.frame = frame;
                
                addBtn_view.hidden = YES;
                
            }
            
            if ([type_lesson isEqualToString:@"2"]) {
                
                add_dayView.hidden = YES;
                
            }
            else{
                
                add_dayView.hidden = NO;
                
            }
            
            
        }
        
        if ([type_lesson isEqualToString:@"1"] || [type_lesson isEqualToString:@"3"]) {
            
            if([type_lesson isEqualToString:@"1"]) {
                
                CGRect frame = main_view.frame;
                
                frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 8;
                
                main_view.frame = frame;
                
                
            }
            
            addBtn_view.hidden = YES;
            
            CGRect frame = max_student_view.frame;
            
            frame.origin.y = support_lang.frame.origin.y + support_lang.frame.size.height + 15;
            max_student_view.frame = frame;
        }
        
        //        if ([type_lesson isEqualToString:@"2"] || [type_lesson isEqualToString:@"1"]) {
        //
        //            {
        //
        //
        //                frame = venuelbl_view.frame;
        //
        //                frame.origin.y = add_dayView.frame.origin.y + add_dayView.frame.size.height + 15;
        //
        //                venuelbl_view.frame = frame;
        //
        //                frame = check_addbox_view.frame;
        //
        //                frame.origin.y = venuelbl_view.frame.origin.y+venuelbl_view.frame.size.height+10;
        //
        //                check_addbox_view.frame = frame;
        //
        //                if(istapCheck == 1) {
        //
        //                    frame = addBtn_view.frame;
        //
        //                    frame.origin.y = check_addbox_view.frame.origin.y+check_addbox_view.frame.size.height+10;
        //
        //                    addBtn_view.frame = frame;
        //
        //                    frame = main_view.frame;
        //
        //                    frame.origin.y = addBtn_view.frame.origin.y + addBtn_view.frame.size.height + 10;
        //
        //                    main_view.frame = frame;
        //
        //                } else {
        //
        //                    frame = main_view.frame;
        //
        //                    frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 10;
        //
        //                    main_view.frame = frame;
        //
        //                }
        //
        //
        //
        //                //height = height;
        //            }
        //
        //        } else {
        //
        //            frame = venuelbl_view.frame;
        //
        //            frame.origin.y = add_dayView.frame.origin.y + add_dayView.frame.size.height + 15;
        //
        //            venuelbl_view.frame = frame;
        //
        //            frame = check_addbox_view.frame;
        //
        //            frame.origin.y = venuelbl_view.frame.origin.y+venuelbl_view.frame.size.height+10;
        //
        //            check_addbox_view.frame = frame;
        //
        //            if(istapCheck == 1) {
        //
        //            frame = addBtn_view.frame;
        //
        //            frame.origin.y = check_addbox_view.frame.origin.y+check_addbox_view.frame.size.height+10;
        //
        //            addBtn_view.frame = frame;
        //
        //            frame = main_view.frame;
        //
        //            frame.origin.y = addBtn_view.frame.origin.y + addBtn_view.frame.size.height + 10;
        //
        //            main_view.frame = frame;
        //
        //            } else {
        //
        //                frame = main_view.frame;
        //
        //                frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 10;
        //
        //                main_view.frame = frame;
        //
        //            }
        //
        //
        //
        //            //height = height;
        //        }
        
        scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, height + 220 * no_lessons)];
        
        int count = 0;
        
        for (UIButton *button in date_btn_array) {
            
            if (count < lessonDataArray.count) {
                
                NSString *str = [[lessonDataArray objectAtIndex:count] valueForKey:@"date_selected"];
                
                [button setTitle:str forState:UIControlStateNormal];
                
            } else {
                
                if (isTapTimeSlot) {
                    
                    NSString *str = [[lessonDataArray objectAtIndex:count-1] valueForKey:@"date_selected"];
                    
                    [button setTitle:str forState:UIControlStateNormal];
                    
                } else {
                    
                    [button setTitle:@"  Select Day" forState:UIControlStateNormal];
                }
            }
            
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            
            //  [button addTarget:self action:@selector(tapSessionDate:) forControlEvents:UIControlEventTouchUpInside];
            
            [button addTarget:self action:@selector(tapSessionsDate:) forControlEvents:UIControlEventTouchUpInside];
            
            count = count +1;
        }
        
        count = 0;
        
        if(lessonCounter == 0)
        {
            
            lessonCounter = lessonDataArray.count;
            
        }
        
        timeIndexArr = [[NSMutableArray alloc]init];
        
        for (UIButton *button in starTime_btn_array) {
            
            if (count < lessonDataArray.count) {
                
                NSString *str = [[lession_array objectAtIndex:count] valueForKey:@"start_time"];
                
                if([str length]<8){
                    
                    str = [@"0" stringByAppendingString:str];
                }
                
                str = [str uppercaseString];
                
                if([str length]< [[stTimeArr objectAtIndex:0] length]){
                    
                    str = [@"0" stringByAppendingString:str];
                    
                }
                
                for (int i=0; i<192; i++) {
                    
                    if([[stTimeArr objectAtIndex:i] isEqualToString:str])
                    {
                        
                        [timeIndexArr addObject:[NSString stringWithFormat:@"%d",i]];
                        
                        break;
                        
                    }
                }
                
                str = [@"  " stringByAppendingString:str];
                
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            } else {
                
                [button setTitle:@"  Select Start Time" forState:UIControlStateNormal];
                
                [button setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
                [timeIndexArr addObject:@"1000"];
            }
            
            
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            
            [button addTarget:self action:@selector(tapLessonsStartTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            count = count +1;
        }
        
        count = 0;
        
        for (UIButton *button in finishTime_btn_array) {
            
            if (count < lessonDataArray.count) {
                
                NSString *str = [[lessonDataArray objectAtIndex:count] valueForKey:@"finish_time"];
                
                [button setTitle:str forState:UIControlStateNormal];
                
            } else {
                
                [button setTitle:@"  Select Finish Time" forState:UIControlStateNormal];
            }
            
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            
            [button addTarget:self action:@selector(tapLessonsFinishTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            count = count +1;
        }
        
        count = 0;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        
        for (int i =0; i < no_lessons ; i++) {
            
            UILabel *lesson_no = [[UILabel alloc] initWithFrame:CGRectMake(0, 160*i, lable_width, 21)];
            
            lesson_no.hidden = YES;
            
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
            
            [lesson_date addTarget:self action:@selector(tapSessionsDate:) forControlEvents:UIControlEventTouchUpInside];
            
            lesson_date.userInteractionEnabled = YES;
            [lession_view addSubview:lesson_date];
            
            UIButton *lesson_startTime = [[UIButton alloc] initWithFrame:CGRectMake(0, 160*i+75, lable_width, 30)];
            
            lesson_startTime.layer.borderWidth = 1.0f;
            
            lesson_startTime.layer.borderColor = [UIColor blackColor].CGColor;
            
            lesson_startTime.layer.cornerRadius = 5.0f;
            
            [starTime_btn_array addObject:lesson_startTime];
            
            [lesson_startTime addTarget:self action:@selector(tapLessonsStartTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [lession_view addSubview:lesson_startTime];
            
            UIButton *lesson_endTime = [[UIButton alloc] initWithFrame:CGRectMake(0, 160*i+120, lable_width, 30)];
            
            lesson_endTime.titleLabel.textColor = [UIColor darkGrayColor];
            
            lesson_endTime.layer.borderWidth = 1.0f;
            
            lesson_endTime.layer.borderColor = [UIColor blackColor].CGColor;
            
            lesson_endTime.layer.cornerRadius = 5.0f;
            
            [lesson_endTime addTarget:self action:@selector(tapLessonsFinishTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [lession_view addSubview:lesson_endTime];
            
            [finishTime_btn_array addObject:lesson_endTime];
            
            //        UIView *footer_view = [[UIView alloc] initWithFrame:CGRectMake(0, lesson_endTime.frame.origin.y + lesson_endTime.frame.size.height + 7.5 , lession_view.frame.size.width, 2)];
            //
            //        footer_view.backgroundColor = [UIColor lightGrayColor];
            //
            //        [lession_view addSubview:footer_view];
        }
        
        CGRect frame = lession_view.frame;
        
        frame.size.height = 160* no_lessons;
        
        frame.origin.x = startDateBtn.frame.origin.x;
        
        frame.origin.y = indefinitly_view.frame.origin.y + indefinitly_view.frame.size.height + 15;
        
        lession_view.frame = frame;
        
        frame = add_dayView.frame;
        
        frame.origin.y = lession_view.frame.origin.y + lession_view.frame.size.height +8;
        
        add_dayView.frame = frame;
        
        if ([type_lesson isEqualToString:@"3"] || [type_lesson isEqualToString:@"4"]) {
            
            venue_view.hidden = YES;
            
            venuelbl_view.hidden = YES;
            
            addBtn_view.hidden = YES;
            
            check_addbox_view.hidden= YES;
            
            country_id = @"";
            
            state_id = @"";
            
            city_id = @"";
            
            if ([type_lesson isEqualToString:@"3"]) {
                
                add_dayView.hidden = NO;
                
                CGRect frames = sub_view.frame;
                
                frames.origin.y = 0.0f;
                
                sub_view.frame = frames;
                
                frames = main_view.frame;
                
                frames.origin.y  = add_dayView.frame.origin.y +add_dayView.frame.size.height +8;
                
                main_view.frame = frames;
                
            }
            else{
                
                add_dayView.hidden = YES;
                
                CGRect frames = sub_view.frame;
                
                frames.origin.y = 0.0f;
                
                sub_view.frame = frames;
                
                frames = main_view.frame;
                
                frames.origin.y  = lession_view.frame.origin.y +lession_view.frame.size.height +8;
                
                main_view.frame = frames;
                
            }
            
        }
        
        if ([type_lesson isEqualToString:@"2"] || [type_lesson isEqualToString:@"1"]) {
            
            if ([type_lesson isEqualToString:@"2"]) {
                
                add_dayView.hidden = YES;
                
                if(!isPrevAddavail){
                    
                    CGRect frame = venuelbl_view.frame;
                    
                    frame.origin.y = lession_view.frame.origin.y + lession_view.frame.size.height + 20;
                    
                    venuelbl_view.frame = frame;
                    
                    frame = main_view.frame;
                    
                    frame.origin.y = venuelbl_view.frame.origin.y + venuelbl_view.frame.size.height + 8;
                    
                    main_view.frame = frame;
                    
                } else {
                    
                    CGRect frame = venuelbl_view.frame;
                    
                    frame.origin.y = lession_view.frame.origin.y + lession_view.frame.size.height + 20;
                    
                    venuelbl_view.frame = frame;
                    
                    frame = check_addbox_view.frame;
                    
                    frame.origin.y = venuelbl_view.frame.origin.y + venuelbl_view.frame.size.height + 8;
                    
                    check_addbox_view.frame = frame;
                    
                    frame = main_view.frame;
                    
                    frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 8;
                    
                    main_view.frame = frame;
                    
                    addBtn_view.hidden = YES;
                    
                }
                
            }
            else{
                
                add_dayView.hidden = NO;
                
                if(!isPrevAddavail){
                    
                    CGRect frame = venuelbl_view.frame;
                    
                    frame.origin.y = add_dayView.frame.origin.y + add_dayView.frame.size.height + 20;
                    
                    venuelbl_view.frame = frame;
                    
                    frame = main_view.frame;
                    
                    frame.origin.y = venuelbl_view.frame.origin.y + venuelbl_view.frame.size.height + 8;
                    
                    main_view.frame = frame;
                    
                } else {
                    
                    CGRect frame = venuelbl_view.frame;
                    
                    frame.origin.y = add_dayView.frame.origin.y + add_dayView.frame.size.height + 20;
                    
                    venuelbl_view.frame = frame;
                    
                    frame = check_addbox_view.frame;
                    
                    frame.origin.y = venuelbl_view.frame.origin.y + venuelbl_view.frame.size.height + 8;
                    
                    check_addbox_view.frame = frame;
                    
                    frame = main_view.frame;
                    
                    frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 8;
                    
                    main_view.frame = frame;
                    
                    addBtn_view.hidden = YES;
                    
                }
                
            }
            
            
        }
        
        
        if ([type_lesson isEqualToString:@"1"] || [type_lesson isEqualToString:@"3"]) {
            
            if([type_lesson isEqualToString:@"1"]) {
                
                CGRect frame = main_view.frame;
                
                frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 8;
                
                main_view.frame = frame;
                
                
            }
            
            addBtn_view.hidden = YES;
            
            CGRect frame = max_student_view.frame;
            
            frame.origin.y = support_lang.frame.origin.y + support_lang.frame.size.height + 15;
            max_student_view.frame = frame;
        }
        
        
        //        if ([type_lesson isEqualToString:@"2"] || [type_lesson isEqualToString:@"1"]) {
        //
        //
        //            {
        //
        //                frame = venuelbl_view.frame;
        //
        //                frame.origin.y = add_dayView.frame.origin.y + add_dayView.frame.size.height + 15;
        //
        //                venuelbl_view.frame = frame;
        //
        //                frame = check_addbox_view.frame;
        //
        //                frame.origin.y = venuelbl_view.frame.origin.y+venuelbl_view.frame.size.height+10;
        //
        //                check_addbox_view.frame = frame;
        //
        //                if(istapCheck == 1) {
        //
        //                    frame = addBtn_view.frame;
        //
        //                    frame.origin.y = check_addbox_view.frame.origin.y+check_addbox_view.frame.size.height+10;
        //
        //                    addBtn_view.frame = frame;
        //
        //                    frame = main_view.frame;
        //
        //                    frame.origin.y = addBtn_view.frame.origin.y + addBtn_view.frame.size.height + 10;
        //
        //                    main_view.frame = frame;
        //
        //                } else {
        //
        //                    frame = main_view.frame;
        //
        //                    frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 10;
        //
        //                    main_view.frame = frame;
        //
        //                }
        //
        //
        //                //height = height;
        //            }
        //
        //        } else {
        //
        //
        //            frame = venuelbl_view.frame;
        //
        //            frame.origin.y = add_dayView.frame.origin.y + add_dayView.frame.size.height + 15;
        //
        //            venuelbl_view.frame = frame;
        //
        //            frame = check_addbox_view.frame;
        //
        //            frame.origin.y = venuelbl_view.frame.origin.y+venuelbl_view.frame.size.height+10;
        //
        //            check_addbox_view.frame = frame;
        //
        //            if(istapCheck == 1) {
        //
        //                frame = addBtn_view.frame;
        //
        //                frame.origin.y = check_addbox_view.frame.origin.y+check_addbox_view.frame.size.height+10;
        //
        //                addBtn_view.frame = frame;
        //
        //                frame = main_view.frame;
        //
        //                frame.origin.y = addBtn_view.frame.origin.y + addBtn_view.frame.size.height + 10;
        //
        //                main_view.frame = frame;
        //
        //            } else {
        //
        //                frame = main_view.frame;
        //
        //                frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height + 10;
        //
        //                main_view.frame = frame;
        //
        //            }
        //
        //
        //            //height = height;
        //        }
        
        scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, height + 160 * no_lessons)];
        
        int count = 0;
        
        for (UIButton *button in date_btn_array) {
            
            if (count < lessonDataArray.count) {
                
                NSString *str = [[lessonDataArray objectAtIndex:count] valueForKey:@"date_selected"];
                
                [button setTitle:str forState:UIControlStateNormal];
                
            } else {
                
                if (isTapTimeSlot) {
                    
                    NSString *str = [[lessonDataArray objectAtIndex:count-1] valueForKey:@"date_selected"];
                    
                    [button setTitle:str forState:UIControlStateNormal];
                    
                } else {
                    
                    [button setTitle:@"  Select Day" forState:UIControlStateNormal];
                }
            }
            
            if ([button.titleLabel.text isEqualToString:@"  Select Day"]) {
                
                [button setTitleColor:UIColorFromRGB (placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
            }
            
            else{
                
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            
            //  [button addTarget:self action:@selector(tapSessionDate:) forControlEvents:UIControlEventTouchUpInside];
            
            [button addTarget:self action:@selector(tapSessionsDate:) forControlEvents:UIControlEventTouchUpInside];
            
            count = count +1;
        }
        
        count = 0;
        if(lessonCounter==0){
            
            lessonCounter = lessonDataArray.count;
        }
        
        timeIndexArr = [[NSMutableArray alloc] init];
        
        for (UIButton *button in starTime_btn_array) {
            
            if (count < lessonCounter) {
                
                NSString *str = [[lession_array objectAtIndex:count] valueForKey:@"start_time"];
                
                if([str length]<8){
                    
                    str = [@"0" stringByAppendingString:str];
                }
                
                str = [str uppercaseString];
                
                for (int i=0; i<192; i++) {
                    
                    if([[stTimeArr objectAtIndex:i] isEqualToString:str])
                    {
                        
                        [timeIndexArr addObject:[NSString stringWithFormat:@"%d",i]];
                        
                        break;
                        
                    }
                }
                
                str = [@"  " stringByAppendingString:str];
                
                [button setTitle:str forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            } else {
                
                [button setTitle:@"  Select Start Time" forState:UIControlStateNormal];
                
                [timeIndexArr addObject:@"1000"];
                
                [button setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
                
            }
            
            if ([button.titleLabel.text isEqualToString:@"  Select Start Time"]) {
                
                [button setTitleColor:UIColorFromRGB (placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
                
            }
            
            else{
                
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            
            [button addTarget:self action:@selector(tapLessonsStartTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            count = count +1;
        }
        
        count = 0;
        
        for (UIButton *button in finishTime_btn_array) {
            
            if (count < lessonDataArray.count) {
                
                
                NSString *str = [[lessonDataArray objectAtIndex:count] valueForKey:@"finish_time"];
                
                [button setTitle:str forState:UIControlStateNormal];
                
            } else {
                
                [button setTitle:@"  Select Finish Time" forState:UIControlStateNormal];
            }
            
            if ([button.titleLabel.text isEqualToString:@"  Select Finish Time"]) {
                
                [button setTitleColor:UIColorFromRGB (placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
            }
            
            else{
                
                [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            
            [button addTarget:self action:@selector(tapLessonsFinishTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            count = count +1;
        }
        
        
        count = 0;
    }
    
    
    if(isRemoveSess) {
        
        lesson_noSession = lesson_noSession -1;
        
    } else {
        
        
        lesson_noSession = lesson_noSession +1 ;
        
    }
    
    [self setscrollContent];
    
}



-(void)tapSessionsDate:(UIButton *)button {
    
    tapDate_session = YES;
    
    [self tapLessonsDateBtn:button];
    
}

-(void)tapLessonsDateBtn:(UIButton *)button {
    
    selectedBtn = button;
    
    isTapCurrency = NO;
    
    tapDate = YES;
    
    isLesson_startBtn = NO;
    
    tapDate_session = YES;
    
    selectedBtn = button;
    
    isTapDay = YES;
    
    isTapCurrency = NO;
    
    tapEndTime = NO;
    
    tapStartTime = NO;
    
    pickerArray =@[@{@"id":@"0", @"name":@"Select"},@{@"id":@"0", @"name":@"SUNDAY"},@{@"id":@"1", @"name":@"MONDAY"},@{@"id":@"2", @"name":@"TUESDAY"},@{@"id":@"3", @"name":@"WEDNESDAY"},@{@"id":@"4", @"name":@"THURSDAY"},@{@"id":@"5", @"name":@"FRIDAY"},@{@"id":@"6", @"name":@"SATURDAY"}];
    
    
    
    [self showPicker];
}

-(void)tapLessonsDateTimeBtn:(UIButton *)button {
    
    selectedBtn = button;
    
    isTapCurrency = NO;
    
    tapDate = YES;
    
    isLesson_startBtn = NO;
    
    // tapDate_session = YES;
    
    selectedBtn = button;
    
    isTapDay = NO;
    
    isTapCurrency = NO;
    
    [self addPicker_toolBar];
}

-(void)tapLessonsStartTimeBtn:(UIButton *)button {
    
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

-(void)tapLessonsFinishTimeBtn:(UIButton *)button {
    
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
    
}

-(void)addPicker_toolBar {
    
    [datePicker removeFromSuperview];
    
    [toolBar removeFromSuperview];
    
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
            
        }
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
    
    if (isTapCurrency || isTapDay) {
        
        if (isTapDay) {
            
            [selectedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            isTapDay = NO;
            
        }
        
        NSLog(@"%@", @"Done");
        
    } else {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        if (tapDate) {
            
            [format setDateFormat:@"yyyy-MM-dd"];
            
            
            // [format setDateFormat:@"dd MMM yyyy"];
            
        } else {
            
            [format setDateFormat:@"hh:mm a"];
        }
        
        
        
        if (tapDate) {
            
            [format setDateFormat:@"yyyy-MM-dd"];
            
            if (selectedBtn == startDateBtn) {
                
                startdate = [format stringFromDate:[datePicker date]];
                
                date = [format stringFromDate:[datePicker date]];
                
                date = [dateConversion convertDate:date];
                
                date = [@"  " stringByAppendingString:date];
                
                if (![finishDateBtn.titleLabel.text isEqualToString:@"  Select"]) {
                    
                    [finishDateBtn setTitle:@"  Select" forState:UIControlStateNormal];
                    
                    [finishDateBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                    
                    
                }
                
                
            } else if(selectedBtn == finishDateBtn){
                
                finishdate = [format stringFromDate:[datePicker date]];
            }
        }
        
        if (selectedBtn == startDateBtn) {
            
            startdate = [format stringFromDate:[datePicker date]];
            
            date = [format stringFromDate:[datePicker date]];
            
            date = [dateConversion convertDate:date];
            
            date = [@"  " stringByAppendingString:date];
            
            [selectedBtn setTitle:date forState:UIControlStateNormal];
            
            if (![finishDateBtn.titleLabel.text isEqualToString:@"  Select"]) {
                
                [finishDateBtn setTitle:@"  Select" forState:UIControlStateNormal];
                
                [finishDateBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
                
            }
            
            
        } else if (selectedBtn == finishDateBtn) {
            
            if (([[datePicker date] compare:[format dateFromString:startDateBtn.titleLabel.text]] == NSOrderedSame) || ([[datePicker date] compare:[format dateFromString:startDateBtn.titleLabel.text]] == NSOrderedDescending)) {
                
                
                date = [format stringFromDate:[datePicker date]];
                
                date = [dateConversion convertDate:date];
                
                date = [@"  " stringByAppendingString:date];
                
                
                [selectedBtn setTitle:date forState:UIControlStateNormal];
                
                [selectedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"available until can't be less then available from." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
                [selectedBtn setTitle:@"  Available Until" forState:UIControlStateNormal];
                
                [selectedBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
            }
            
        } else {
            
            // date = [@"  " stringByAppendingString:date];
            
            if(tapStartTime){
                
                date = [@"  " stringByAppendingString:startTime];
                
                
            } else if(tapEndTime) {
                
                date = [@"  " stringByAppendingString:endTime];
                
            } else {
                
                
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
    
    tapDate = NO;
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
        
        if (isTapDay) {
            
            [selectedBtn setTitle:pickerValue forState:UIControlStateNormal];
            
        } else {
            
            [currencyBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            currencyId = data_id;
        }
    }
}


-(void)showPicker {
    
    [datePicker removeFromSuperview];
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
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

-(void)setValue {
    
    lessonDataArray = [[NSMutableArray alloc] init];
    
    NSDictionary *dict;
    
    //    for (int i =0; i<lession_array.count; i++) {
    //
    //       dict =  @{@"date_selected":[[lession_array objectAtIndex:i] valueForKey:@"day_select"], @"start_time":[[lession_array objectAtIndex:i] valueForKey:@"start_time"], @"finish_time": [[lession_array objectAtIndex:i] valueForKey:@"finish_time"]};
    //    }
    
    NSString *day, *start_time, *end_time;
    
    for (int i =0; i<date_btn_array.count ; i++) {
        
        UIButton *button = [date_btn_array objectAtIndex:i];
        
        day = button.titleLabel.text;
        
        button = [starTime_btn_array objectAtIndex:i];
        
        start_time = button.titleLabel.text;
        
        button = [finishTime_btn_array objectAtIndex:i];
        
        end_time = button.titleLabel.text;
        
        dict =  @{@"date_selected":day, @"start_time":start_time, @"finish_time":end_time};
        
        [lessonDataArray addObject:dict];
    }
    NSLog(@"%@",lessonDataArray);
}

- (IBAction)tapAddTimeSlot:(id)sender {
    
    removeLastOneBtn.userInteractionEnabled = YES;
    
    isTapTimeSlot = YES;
    
    isRemoveSess = NO;
    
    [self setValue];
    
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
    
    //isTapTimeSlot = YES;
    
    NSString *lessonStr = [NSString stringWithFormat:@"%d",lesson_noSession];
    
    //lesson_noSession = lesson_noSession;
    
    [self addLessons:lessonStr];
}

- (IBAction)tapAddDay:(id)sender {
    
    removeLastOneBtn.userInteractionEnabled = YES;
    
    isTapTimeSlot = NO;
    
    isRemoveSess = NO;
    
    [self setValue];
    
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
    
    //isTapTimeSlot = NO;
    
    NSString *lessonStr = [NSString stringWithFormat:@"%d",lesson_noSession];
    
    lesson_noSession = lesson_noSession;
    
    [self addLessons:lessonStr];
}

- (IBAction)tap_removeLastOneBtn:(id)sender {
    
    NSLog(@"%@",lessonDataArray);
    
    
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
    
    isRemoveSess = YES;
    
    NSString *lessonStr = [NSString stringWithFormat:@"%d",lesson_noSession -2];
    
    [self addLessons:lessonStr];
    
    [self setValue1];
    
    
}

-(void)setValue1 {
    
    NSDictionary *dict;
    
    NSMutableArray *ab = [[NSMutableArray alloc]init];
    
    ab = [lessonDataArray mutableCopy];
    
    if (ab.count-1 > 0) {
        
        lessonDataArray = [[NSMutableArray alloc]init];
        
        NSString *day, *start_time, *end_time;
        
        day = [[NSString alloc]init];
        
        start_time = [[NSString alloc]init];
        
        end_time = [[NSString alloc]init];
        
        for (int i =0; i<ab.count-1 ; i++) {
            
            // UIButton *button = [[ab objectAtIndex:i]valueForKey:@"date_selected"];
            
            //  day = button.titleLabel.text;
            
            day = [[ab objectAtIndex:i]valueForKey:@"date_selected"];
            
            // UIButton   *button = [[ab objectAtIndex:i]valueForKey:@"start_time"];
            
            //  start_time = button.titleLabel.text;
            
            start_time = [[ab objectAtIndex:i]valueForKey:@"start_time"];
            
            //  button = [[ab objectAtIndex:i]valueForKey:@"finish_time"];
            
            end_time = [[ab objectAtIndex:i]valueForKey:@"finish_time"];
            
            //   end_time = button.titleLabel.text;
            
            dict =  @{@"date_selected":day, @"start_time":start_time, @"finish_time":end_time};
            
            [lessonDataArray addObject:dict];
            
            
        }
        NSLog(@"%@",lessonDataArray);
        
        removeLastOneBtn.userInteractionEnabled = YES;
        
        
    }
    else if (ab.count ==1){
        
        removeLastOneBtn.userInteractionEnabled = NO;
    }
    
    
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
    
    if ([session_name.text isEqualToString:@""]) {
        
        message = @"Please enter session name.";
        
    } else if ([startDateBtn.titleLabel.text isEqualToString:@"  Start Date"]) {
        
        message = @"Please select start date.";
        
    } else if ([finishDateBtn.titleLabel.text isEqualToString:@"  Select"] && (isCheckTap)) {
        
        message = @"Please select finish date.";
        
    }  else if (![type_lesson isEqualToString:@"3"] && ![type_lesson isEqualToString:@"4"]) {
        
        if ([unit_txtField.text isEqualToString:@""]) {
            
            message = @"Please enter unit/suite.";
            
            //        } else if ([building_name.text isEqualToString:@""]) {
            //
            //            message = @"Please enter building name";
            
        } else if ([number_street.text isEqualToString:@""]) {
            
            message = @"Please enter the street name.";
            
        } else if ([district.text isEqualToString:@""]) {
            
            message = @"Please enter the district name.";
            
        } else if ([countryBtn.titleLabel.text isEqualToString:@"  Country"]) {
            
            message = @"Please select the country.";
            
        } else if ([cityBtn.titleLabel.text isEqualToString:@"  City"]) {
            
            message = @"Please select the city.";
            
        } else if ([stateBtn.titleLabel.text isEqualToString:@"  State"]) {
            
            message = @"Please select the state.";
            
        }
    }
    
    if ([message length]==0) {
        
        if ([age_groupBtn.titleLabel.text isEqualToString:@"  Select"]) {
            
            message = @"Please select age group.";
            
        } else if ([suitable_forBtn.titleLabel.text isEqualToString:@"  Select"]) {
            
            message = @"Please select suitable for.";
            
        } else if ([instruction_lang.text isEqualToString:@""]) {
            
            message = @"Please enter the main language.";
            
        }
    }
    
    if ([message length]==0) {
        
        if ([currencyBtn.titleLabel.text isEqualToString:@"  Select"]) {
            
            message = @"Please select currency.";
            
        } else if ([course_fee.text isEqualToString:@""]) {
            
            message = @"Please enter lesson fee.";
            
        }
    }
    for (UIButton *button in date_btn_array) {
        
        if ([button.titleLabel.text isEqualToString:@"  Select Date"]) {
            
            message = @"Please enter lesson Date.";
            
            break;
        }
    }
    
    for (UIButton *button in starTime_btn_array) {
        
        if ([button.titleLabel.text isEqualToString:@"  Select Start Time"]) {
            
            message = @"Please enter lesson Start Time.";
            
            break;
        }
    }
    
    for (UIButton *button in finishTime_btn_array) {
        
        if ([button.titleLabel.text isEqualToString:@"  Select Finish Time"]) {
            
            message = @"Please enter lesson Finish Time.";
            
        }
        
    }
    
    if ([message length]>0){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
    }else {
        
        [self.view addSubview:indicator];
        
        NSString *course_id = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"lesson_id"];
        
        NSString *startDate,*finishDate;
        
        startDate = startDateBtn.titleLabel.text;
        
        startDate = [startDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        finishDate = finishDateBtn.titleLabel.text;
        
        finishDate = [finishDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //   NSMutableDictionary *paramURL= [[NSMutableDictionary alloc] initWithDictionary: @{@"lesson_id":course_id,@"session_id" : session_id, @"session_name":session_name.text, @"start_date":startDate, @"finish_date":finishDate, @"lessions_no":no_of_lessions.text, @"venu_unit":unit_txtField.text, @"venu_building_name":building_name.text, @"venu_street":number_street.text, @"venu_district":district.text, @"venu_country_id":country_id, @"venu_state_id":state_id,@"venu_city_id" : city_id, @"age_group":age_id, @"suitable_for":suitable_id, @"main_language":instruction_lang.text, @"supported_language":support_lang.text, @"total_students":max_student.text, @"places":available_places.text, @"fee_currency":currencyId, @"fee_quantity":course_fee.text, @"url_check":@"", @"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"check_address_type": @"1"}];
        
        if (lesson_noSession == 1) {
            lesson_noSession = 0;
            
        } else {
            
            countdown = [NSString stringWithFormat:@"%d",date_btn_array.count-1];
        }
        
        NSMutableDictionary *paramURL= [[NSMutableDictionary alloc] initWithDictionary: @{@"lesson_id":course_id,@"session_id" : session_id, @"session_name":session_name.text, @"start_date":startdate, @"finish_date":finishdate, @"venu_unit":unit_txtField.text, @"venu_building_name":building_name.text, @"venu_street":number_street.text, @"venu_district":district.text, @"venu_country_id":country_id, @"venu_state_id":state_id,@"venu_city_id" : city_id, @"age_group":age_id, @"suitable_for":suitable_id, @"main_language":instruction_lang.text, @"supported_language":support_lang.text, @"total_students":max_student.text, @"places":available_places.text, @"fee_currency":currencyId, @"fee_quantity":course_fee.text, @"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"lesson_type":type_lesson, @"make_it_post":@"0", @"count_down":countdown, @"prev_address":@"1",@"check_address_type":@"1"}];
        
        // NSMutableDictionary *paramURL= [[NSMutableDictionary alloc] initWithDictionary: @{@"lesson_id":course_id, @"session_id" : session_id, @"session_name":session_name.text, @"start_date":startDate, @"finish_date":finishDate, @"venu_unit":unit_txtField.text, @"venu_building_name":building_name.text, @"venu_street":number_street.text, @"venu_district":district.text, @"venu_country_id":country_id, @"venu_state_id":state_id,@"venu_city_id" : city_id, @"age_group":age_id, @"suitable_for":suitable_id, @"main_language":instruction_lang.text, @"supported_language":support_lang.text, @"total_students":max_student.text, @"places":available_places.text, @"fee_currency":currencyId, @"fee_quantity":course_fee.text, @"url_check":@"", @"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"check_address_type": @"1", @"lesson_type":type_lesson}];
        
        //   NSLog(@"%@", paramURL);
        
        int i = 0;
        
        for (UIButton *button in date_btn_array) {
            
            NSString *lesson = [NSString stringWithFormat:@"day_select%d", i];
            
            NSString *dateStr = button.titleLabel.text;
            
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
        
        [addSessionConnection startConnectionWithString:[NSString stringWithFormat:@"add_lessons_sessions"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([addSessionConnection responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                if (save_view) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You have successfully updated the Listing. For other members to see it, please ensure to click the 'post' icon once again on this Listing in your My Listings." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                    MyListingViewController *myListingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myListing"];
                    
                    [self.navigationController pushViewController:myListingVC animated:YES];
                    
                } else {
                    
                    lession_view.hidden = YES;
                    
                    CGRect frame = main_view.frame;
                    
                    frame.origin.y = no_of_lessions.frame.origin.y + 100;
                    
                    main_view.frame = frame;
                    
                    session_name.text = @"";
                    [startDateBtn setTitle:@"  Select Start Date" forState:UIControlStateNormal];
                    //finishDateBtn.titleLabel.text = @"  Select Finish Date";
                    [finishDateBtn setTitle:@"  Select Finish Date" forState:UIControlStateNormal];
                    
                    no_of_lessions.text = @"";
                    unit_txtField.text = @"";
                    building_name.text = @"";
                    number_street.text = @"";
                    district.text = @"";
                    support_lang.text = @"";
                    [age_groupBtn setTitle:@"  Select" forState:UIControlStateNormal];
                    [suitable_forBtn setTitle:@"  Select" forState:UIControlStateNormal];
                    instruction_lang.text = @"";
                    max_student.text = @"";
                    available_places.text = @"";
                    [currencyBtn setTitle:@"  Select" forState:UIControlStateNormal];
                    course_fee.text = @"";
                    
                    scrollView.frame = self.view.frame;
                    
                    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 700);
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
    
    isSavePost = NO;
    
    [self checkDataValidation];
}

- (IBAction)tap_save_view:(id)sender {
    
    save_view = YES;
    
    isSavePost = NO;
    
    [self checkDataValidation];
}

- (IBAction)tap_cancel:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You have successfully updated the Listing. For other members to see it, please ensure to click the 'post' icon once again on this Listing in your My Listings." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    MyListingViewController *myListingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myListing"];
    
    [self.navigationController pushViewController:myListingVC animated:YES];
    
    [alertView show];
    
}

- (IBAction)tap_checkBtn:(id)sender {
    
    if (isCheckTap) {
        
        isCheckTap = NO;
        
        [checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        [finishDateBtn setTitle:@"  Select" forState:UIControlStateNormal];
        
        [finishDateBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
        finishDateBtn.userInteractionEnabled = YES;
        
        //availability = @"off";
        
        countdown = @"0";
        
    } else {
        
        isCheckTap = YES;
        
        [checkBoxBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        [finishDateBtn setTitle:@"  Indefinite" forState:UIControlStateNormal];
        
        [finishDateBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        //availability = @"on";
        
        countdown = @"1";
        
        finishDateBtn.userInteractionEnabled = NO;
    }
}

- (IBAction)tap_startDate:(id)sender {
    
    isTapCurrency = NO;
    
    tapDate_session = NO;
    
    [self tapLessonsDateTimeBtn:sender];
    
}

- (IBAction)tap_finishDate:(id)sender {
    
    isTapCurrency = NO;
    
    tapDate_session = NO;
    
    [self tapLessonsDateTimeBtn:sender];
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
    isTapDay = NO;
    
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
        isSupportingLg = NO;
        isMainLg = NO;
        
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
    
    else if (isMainLg){
        
        NSString *name = [languageArray objectAtIndex:index];
        
        name = [@"  " stringByAppendingString:name];
        
        [selectMainLgBtn setTitle:name forState:UIControlStateNormal];
        
        instruction_lang.text = name;
        
    }
    
    else if (isSupportingLg){
        
        NSString *name = [languageArray objectAtIndex:index];
        
        name = [@"  " stringByAppendingString:name];
        
        [selectSupportingBtn setTitle:name forState:UIControlStateNormal];
        
        support_lang.text = name;
        
    }
    else if (isselectPrevAdd){
        
        NSString *name = [prevAddressArray objectAtIndex:index];
        
        name = [@"  " stringByAppendingString:name];
        
        [add_Btn setTitle:name forState:UIControlStateNormal];
        
        [add_Btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(67, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
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
            
            if (isMainLg) {
                
                [self showListData:languageArray allowMultipleSelection:NO selectedData:[selectMainLgBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Instruction Languages"];
                
            } else {
                
                [self showListData:languageArray allowMultipleSelection:NO selectedData:[selectSupportingBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Supporting Languages"];
                
            }
            
            
        }}];
    
}

- (IBAction)tap_infoBtn:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"If your Event has a number of different sessions available, you can add different session options." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertView show];
    
}

- (IBAction)tap_mainLgBtn:(id)sender {
    
    isSupportingLg = NO;
    
    isMainLg = YES;
    
    isCity = NO;
    
    isState = NO;
    
    isCountry = NO;
    
    
    [self fetchlanguages];
}

- (IBAction)tap_supportingLgBtn:(id)sender {
    
    isSupportingLg = YES;
    
    isMainLg = NO;
    
    isCity = NO;
    
    isState = NO;
    
    isCountry = NO;
    
    [self fetchlanguages];
}
- (IBAction)tap_sessionInfoBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"If your Lesson has a number of different sessions available, you can add different session options." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}
- (IBAction)tap_fromInfoBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"This is the date your lesson is available for enrollments. If your lessons is available now, just select tomorrow's date." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}
- (IBAction)tap_untilInfoBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"If your lesson has an expiry date, you can select the date here. But if your lesson is available indefinitely, tick the Indefinite box.You can edit this later." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}
- (IBAction)tap_dayTInfoBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Select the day and time of the week this particular session is available. This is for the particular session you have added at the top of the form. If there are other sessions for different groups or age-groups then you can add more sessions after completing this session." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}
- (IBAction)tap_venueInfoBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"This is where the lesson is held.\n\n(1) On the Listing you and others will see the street, number and suburb or district, but members who enroll will see the full address in their enrollment confirmation.\n\n(2) Ensure you enter a complete address here, as this information is used on the Google map geo locator on your Listing. In most cases Google map is 100% accurate, and other times close to accurate. But at least the map provides an indicator of the lesson vacinity.\n\n(3) If you are a mobile tutor, and is willing to travel to the student, simply put \"Mobile Tutor\" where is it marked, and enter all the suburbs you are willing to travel to separated by a comma." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (IBAction)tap_ageInfoBtn:(id)sender;{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"These are approximate age groups. You can select more than one age group if needed." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

- (IBAction)tap_lgInfoBtn:(id)sender;{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The language used to teach the subject or content of the lesson." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

- (IBAction)tap_feeInfoBtn:(id)sender;{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The fee per individual lesson." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

- (IBAction)tap:(id)sender {
}
- (IBAction)tap_saveAndPostbtn:(id)sender {
    
    save_view = NO;
    
    isSavePost = YES;
    
    NSLog(@"%hhd %hhd", isSavePost,save_view);
    
    [self checkDataValidation];
    
}

#pragma alertview deelgates-----

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1) {
        
        if (buttonIndex ==0) {
            
            UIStoryboard *st = self.storyboard;
            
            addWhatsOnViewController *aVC = [st instantiateViewControllerWithIdentifier:@"addWhatsOnVC"];
            
            [self.navigationController pushViewController:aVC animated:YES];
            
        }
    }
}
- (IBAction)tap_addBtn:(id)sender {
    
    NSDictionary *paramURL = @{@"type_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"],@"type":@"3"};
    
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
            
            isMainLg = NO;
            
            isCity = NO;
            
            isState = NO;
            
            isCountry = NO;
            
            [self showListData:prevAddressArray allowMultipleSelection:NO selectedData:[add_Btn.titleLabel.text componentsSeparatedByString:@", "] title:@"Select Address"];
            
        }}];
}
- (IBAction)tap_checkadd_Btn:(id)sender {
    
    if (istapCheck ==0) {
        
        istapCheck = 1;
        
        [checkadd_Btn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        addBtn_view.hidden = NO;
        
        CGRect frame = addBtn_view.frame;
        
        frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height+8;
        
        addBtn_view.frame = frame;
        
        frame = main_view.frame;
        
        frame.origin.y = addBtn_view.frame.origin.y + addBtn_view.frame.size.height+8;
        
        main_view.frame = frame;
        
        unit_txtField.userInteractionEnabled = NO;
        
        building_name.userInteractionEnabled = NO;
        
        number_street.userInteractionEnabled = NO;
        
        district.userInteractionEnabled = NO;
        
        [self setscrollContent];
        
        
        
    }
    else{
        
        istapCheck = 0;
        
        [checkadd_Btn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        addBtn_view.hidden = YES;
        
        CGRect frame = main_view.frame;
        
        frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height+8;
        
        main_view.frame = frame;
        
        unit_txtField.userInteractionEnabled = YES;
        building_name.userInteractionEnabled = YES;
        number_street.userInteractionEnabled = YES;
        district.userInteractionEnabled = YES;
        
        [self setscrollContent];
        
    }
    
    
}

//- (IBAction)tap_check_btn:(id)sender {
//
//    if (istapCheck ==0) {
//
//        istapCheck = 1;
//
//        [checkadd_Btn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
//        
//        addBtn_view.hidden = NO;
//        
//        CGRect frame = addBtn_view.frame;
//        
//        frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height+8;
//        
//        addBtn_view.frame = frame;
//        
//        frame = main_view.frame;
//        
//        frame.origin.y = addBtn_view.frame.origin.y + addBtn_view.frame.size.height+8;
//        
//        main_view.frame = frame;
//        
//        unit_txtField.userInteractionEnabled = NO;
//        building_name.userInteractionEnabled = NO;
//        number_street.userInteractionEnabled = NO;
//        district.userInteractionEnabled = NO;
//        
//        
//    }
//    else{
//        
//        istapCheck = 0;
//        
//        [checkadd_Btn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
//        
//        addBtn_view.hidden = YES;
//        
//        CGRect frame = main_view.frame;
//        
//        frame.origin.y = check_addbox_view.frame.origin.y + check_addbox_view.frame.size.height+8;
//        
//        main_view.frame = frame;
//        
//        unit_txtField.userInteractionEnabled = YES;
//        building_name.userInteractionEnabled = YES;
//        number_street.userInteractionEnabled = YES;
//        district.userInteractionEnabled = YES;
//        
//    }
//}

@end