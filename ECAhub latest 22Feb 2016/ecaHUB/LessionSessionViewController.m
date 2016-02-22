//
//  LessionSessionViewController.m
//  ecaHUB
//
//  Created by promatics on 4/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "LessionSessionViewController.h"
#import "SendMessageView.h"
#import "DateConversion.h"
#import "editLessionSessionViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"

@interface LessionSessionViewController () {
    
    NSDictionary *sessionData;
    
    SendMessageView *sendMsgView;
    
    BOOL tapDate_session;
    
    NSString *startdate,*finishdate;
    
    DateConversion *dateConversion;
    
    WebServiceConnection *delConn;
    
    WebServiceConnection *getLessConn;
    
    Indicator *indicator;
}
@end

@implementation LessionSessionViewController

@synthesize scrollView,session_name,main_lang,support_lang,day_time,age_group,age_groupValue,gender_lable,gender_value,max_sizeLbl,max_size_value,available_places, available_places_value,course_fees_lable,course_fees_value, requestToEnrollBtn, enquireBtn,venue_lbl,venue_value,main_lang_lbl,support_lang_lbl,delete_btn,isView,edit_btn,isEdit,seats_remainiglbl,seats_remaining_value,maxStudent_lbl,maxStudent_value;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Session Option";
    
    dateConversion = [DateConversion dateConversionManager];
    
    delConn = [WebServiceConnection connectionManager];
    
    getLessConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 750);
    }
    
    if(isEdit) {
        
    self.navigationItem.rightBarButtonItems = @[delete_btn,edit_btn];

    }
    
    [self setSessionDetail];
    
    tapDate_session = NO;
}


-(void) setSessionDetail {
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]);
    
    sessionData = [[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"];
    
    NSString *lesson_type = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonListing"] valueForKey:@"lesson_type"];
    
     if ([lesson_type isEqual:@"2"]|| [lesson_type isEqual:@"4"]) {
        
         maxStudent_value.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"total_students"];
         
         seats_remaining_value.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"availability"];
    }
    
    NSString *couser_memId = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonListing"] valueForKey:@"member_id"];
    
    if (![couser_memId isEqualToString:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]]) {
        
        // [self.editBtn setWidth:0];
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    
    NSString *memberID = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"member_id"];
    
    
    NSString *startDate =[[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"start_date"];
    
    NSString *postStatus = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonListing"] valueForKey:@"course_status"];
    
    NSDate *currentdate = [NSDate date];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    NSDate *newDate = [dateFormatter dateFromString:startDate];
    
    NSComparisonResult result;
    
    result = [currentdate compare:newDate]; // comparing two dates
    
    if(result==NSOrderedAscending && [postStatus isEqual:@"1"]){
        
        //    if ([memberID isEqualToString:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]] || ![[[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseListing"] valueForKey:@"whatson_status"] isEqualToString:@"1"]) {
        
        requestToEnrollBtn.hidden = YES;
        
        enquireBtn.hidden = YES;
        
    } else {
        
        requestToEnrollBtn.hidden = NO;
        enquireBtn.hidden = NO;
    }
    
    session_name.text =[[[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"session_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    CGRect main_langFrame = main_lang.frame;
    
    main_langFrame.size.width = self.view.frame.size.width - 30;
    
    main_lang.frame = main_langFrame;
    
    main_lang.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"main_language"];
    NSString *blankSpace = @", ";
    
    NSString *houseno = [[sessionData valueForKey:@"sesion"]valueForKey:@"venu_building_name"];
    
    if ([houseno isEqualToString:@""]) {
        
        houseno = @"";
    }
    else{
        
        houseno = [houseno stringByAppendingString:blankSpace];
    }
    
    NSString *streetno =[[sessionData valueForKey:@"sesion"]valueForKey:@"venu_street"];
    
    if ([streetno isEqualToString:@""]) {
        
        streetno = @"";
    }
    else{
        
        streetno = [streetno stringByAppendingString:blankSpace];
    }
    
    NSString *district = [[sessionData valueForKey:@"sesion"]valueForKey:@"venu_district"];
    
    if ([district isEqualToString:@""]) {
        
        district = @"";
    }
    else{
        
        district = [district stringByAppendingString:blankSpace];
    }
    
    NSString *state = [[[sessionData valueForKey:@"course_session"]valueForKey:@"State"]valueForKey:@"state_name"];
    
    if ([state isEqualToString:@""]) {
        
        state = @"";
    }
    else{
        
        state = [state stringByAppendingString:blankSpace];
    }
    
    NSString *country = [[[sessionData valueForKey:@"course_session"]valueForKey:@"Country"]valueForKey:@"country_name"];
    
    if ([country isEqualToString:@""]) {
        
        country = @"";
    }
    else{
        
        country = [country stringByAppendingString:@"."];
    }
    
    NSString *city = [[[sessionData valueForKey:@"course_session"]valueForKey:@"City"]valueForKey:@"city_name"];
    
    if ([city isEqualToString:@""]) {
        
        city = @"";
    }
    else{
        
        city = [city stringByAppendingString:@""];
    }
    
    venue_lbl.text = [[streetno stringByAppendingString:district]stringByAppendingString:city];
    
    
    NSString *sup_lang = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"supported_language"];
    
    if ([sup_lang isEqualToString:@""]) {
        
        sup_lang = @"N/A";
    }
    
    support_lang.text = [sup_lang stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *start_date = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"start_date"];
    
    if ([start_date isEqualToString:@""] || start_date == nil) {
        
        start_date = @"";
    }
    else{
        
        max_size_value.text = [dateConversion convertDate:start_date];
        
    }
    
    NSString *finish_date = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"finish_date"];
    
    if ([finish_date isEqualToString:@""] || finish_date == nil) {
        
        available_places_value.text = @"Indefinite";
    }
    else{
        
        available_places_value.text = [dateConversion convertDate:finish_date];
        
    }
    
    NSString *currency = [[[sessionData valueForKey:@"course_session"]valueForKey:@"Currency"] valueForKey:@"name"];
    
    NSString *name = [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"]valueForKey:@"fee_quantity"];
    
    course_fees_value.text = [currency stringByAppendingString:[NSString stringWithFormat:@" %0.2f", [name floatValue]]];
    
    NSArray *day_timeArray = [[sessionData valueForKey:@"course_session"] valueForKey:@"LessonTiming"];
    
    
    CGRect frame = day_time.frame;
    
    //day_time.hidden = YES;
    
    // frame.origin.y = frame.origin.y+10;
    
    NSString *date_time = @"";
    
    for (int i= 0; i < day_timeArray.count; i++) {
        
        NSString *date = [[day_timeArray objectAtIndex:i] valueForKey:@"day_select"];
        
        date = [date stringByAppendingString:@" ( "];
        
        date = [date stringByAppendingString:[[day_timeArray objectAtIndex:i] valueForKey:@"start_time"]];
        
        date = [date stringByAppendingString:@" - "];
        
        date = [date stringByAppendingString:[[day_timeArray objectAtIndex:i] valueForKey:@"finish_time"]];
        
        date = [date stringByAppendingString: @" )"];
        
        if (i == 0) {
            
            frame.origin.y = frame.origin.y;
            
            
        } else {
            
            frame.origin.y = frame.origin.y + frame.size.height;
            
            date_time = [date_time stringByAppendingString:@"\n"];
        }
        
        date_time = [date_time stringByAppendingString:date];
        
        //        UILabel *lable = [[UILabel alloc] initWithFrame:frame];
        //
        //        lable.text = date;
        //
        //        lable.textColor = [UIColor darkGrayColor];
        
        //[scrollView addSubview:lable];
    }
    
    day_time.text = date_time;
    
    
    //    frame.origin.y = frame.origin.y + frame.size.height + 10;
    //
    //    frame.size.width = self.view.frame.size.width;
    //
    //    frame.origin.x = 0;
    //
    //    max_sizeLbl.frame = frame;
    //
    //    frame = max_sizeLbl.frame;
    //
    //    frame.origin.y = frame.origin.y + frame.size.height;
    //
    //    frame.origin.x = main_lang.frame.origin.x;
    //
    //    frame.size.width = main_lang.frame.size.width;
    //
    //    max_size_value.frame = frame;
    //
    //    frame = max_size_value.frame;
    //
    //    frame.origin.y = frame.origin.y + frame.size.height + 10;
    //
    //    frame.size.width = self.view.frame.size.width;
    //
    //    frame.origin.x = 0;
    //
    //    available_places.frame = frame;
    //
    //    frame = available_places.frame;
    //
    //    frame.origin.y = frame.origin.y + frame.size.height;
    //
    //    frame.origin.x = main_lang.frame.origin.x;
    //
    //    frame.size.width = main_lang.frame.size.width;
    //
    //    available_places_value.frame = frame;
    //
    //    frame = available_places_value.frame;
    //
    //    frame.origin.y = frame.origin.y + frame.size.height + 10;
    //
    //    frame.size.width = self.view.frame.size.width;
    //
    //    frame.origin.x = 0;
    //
    //    age_group.frame = frame;
    //
    //    frame.origin.y = frame.origin.y + frame.size.height + 10;
    //
    //    frame.origin.x = main_lang.frame.origin.x;
    //
    //    frame.size.width = main_lang.frame.size.width;
    //
    //    age_groupValue.frame = frame;
    
    // age_groupValue.hidden = YES;
    
    NSArray *age_array = [sessionData valueForKey:@"age_group"];
    
    frame = age_groupValue.frame;
    
    NSString *age_g = @"";
    
    for (int i= 0; i < age_array.count; i++) {
        
        NSString *age = [[[[age_array objectAtIndex:i] valueForKey:@"AgeGroup"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (i == 0) {
            
            frame.origin.y = frame.origin.y;
            
        } else {
            
            frame.origin.y = frame.origin.y + frame.size.height;
            
            age_g = [[age_g stringByAppendingString:@"\n"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        age_g = [[age_g stringByAppendingString:age]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //[scrollView addSubview:lable];
    }
    
    age_groupValue.text = [age_g stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    
    //    frame.origin.y = frame.origin.y + frame.size.height + 10;
    //
    //    frame.size.width = self.view.frame.size.width;
    //
    //    frame.origin.x = 0;
    //
    //    gender_lable.frame = frame;
    //
    //    frame.origin.y = frame.origin.y + frame.size.height + 10;
    //
    //    frame.origin.x = main_lang.frame.origin.x;
    //
    //    frame.size.width = main_lang.frame.size.width;
    //
    //    gender_value.frame = frame;
    
    NSArray *genderArray = [sessionData valueForKey:@"suitable"];
    
    NSMutableArray *suitable_array = [[NSMutableArray alloc] init];
    
    for (int i =0; i < genderArray.count; i++) {
        
        [suitable_array addObject:[[[genderArray objectAtIndex:i] valueForKey:@"Suitable"] valueForKey:@"title"]];
    }
    
    NSLog(@"%@", suitable_array);
    
    NSString *gender_str = [suitable_array componentsJoinedByString:@", "];
    
    gender_value.text = [gender_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //    frame.origin.y = frame.origin.y + frame.size.height + 10;
    //
    //    frame.size.width = self.view.frame.size.width;
    //
    //    frame.origin.x = 0;
    //
    //    venue_value.frame = frame;
    //
    //    frame = venue_value.frame;
    //
    //    frame.origin.y = frame.origin.y + frame.size.height;
    //
    //    frame.origin.x = main_lang.frame.origin.x;
    //
    //    frame.size.width = main_lang.frame.size.width;
    //
    //    venue_lbl.frame = frame;
    //
    //    frame = venue_lbl.frame;
    //
    //    frame.origin.y = frame.origin.y + frame.size.height + 10;
    //
    //    frame.size.width = self.view.frame.size.width;
    //
    //    frame.origin.x = 0;
    //
    //    course_fees_lable.frame = frame;
    //
    //    frame = course_fees_lable.frame;
    //
    //    frame.origin.y = frame.origin.y + frame.size.height;
    //
    //    frame.origin.x = main_lang.frame.origin.x;
    //
    //    frame.size.width = main_lang.frame.size.width;
    //
    //    course_fees_value.frame = frame;
    //
    //    frame = course_fees_value.frame;
    
    CGFloat row_hieght;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        row_hieght = 45;
        
    } else {
        
        row_hieght = 30;
    }
    
    frame = max_sizeLbl.frame;
    
    frame.origin.y = session_name.frame.origin.y + session_name.frame.size.height+10;
    
    max_sizeLbl.frame = frame;
    
    frame = max_size_value.frame;
    
    frame.origin.y = max_sizeLbl.frame.origin.y + max_sizeLbl.frame.size.height+10;
    
    max_size_value.frame = frame;
    
    frame = available_places.frame;
    
    frame.origin.y = max_size_value.frame.origin.y + max_size_value.frame.size.height+10;
    
    available_places.frame = frame;
    
    frame = available_places_value.frame;
    
    frame.origin.y = available_places.frame.origin.y + available_places.frame.size.height+10;
    
    available_places_value.frame = frame;
    
    frame = _date_time_lbl.frame;
    
    frame.origin.y = available_places_value.frame.origin.y + available_places_value.frame.size.height+10;
    
    _date_time_lbl.frame = frame;
    
    frame = day_time.frame;
    
    frame.origin.y = _date_time_lbl.frame.origin.y + _date_time_lbl.frame.size.height+10;
    
    day_time.frame = frame;
    
    day_time.numberOfLines =0;
    
    day_time.lineBreakMode = NSLineBreakByWordWrapping;
    
    [day_time sizeToFit];
    
    if(day_time.frame.size.height<row_hieght){
        
        frame.size.height = row_hieght;
        
        day_time.frame = frame;
        
    }
    
    frame = venue_value.frame;
    
    frame.origin.y = day_time.frame.origin.y + day_time.frame.size.height+10;
    
    venue_value.frame = frame;
    
    frame = venue_lbl.frame;
    
    frame.origin.y = venue_value.frame.origin.y + venue_value.frame.size.height+10;
    
    venue_lbl.frame = frame;
    
    frame = age_group.frame;
    
    frame.origin.y = venue_lbl.frame.origin.y + venue_lbl.frame.size.height+10;
    
    age_group.frame = frame;
    
    frame = age_groupValue.frame;
    
    frame.origin.y = age_group.frame.origin.y + age_group.frame.size.height+10;
    
    age_groupValue.frame = frame;
    
    age_groupValue.numberOfLines = 0;
    
    age_groupValue.lineBreakMode = NSLineBreakByWordWrapping;
    
    [age_groupValue sizeToFit];
    
    if(age_groupValue.frame.size.height<row_hieght){
        
        frame.size.height = row_hieght;
        
        age_groupValue.frame = frame;
        
    }
    
    frame = gender_lable.frame;
    
    frame.origin.y = age_groupValue.frame.origin.y + age_groupValue.frame.size.height+10;
    
    gender_lable.frame = frame;
    
    frame = gender_value.frame;
    
    frame.origin.y = gender_lable.frame.origin.y + gender_lable.frame.size.height+10;
    
    gender_value.frame = frame;
    
    frame = main_lang_lbl.frame;
    
    frame.origin.y = gender_value.frame.origin.y + gender_value.frame.size.height+10;
    
    main_lang_lbl.frame = frame;
    
    frame = main_lang.frame;
    
    frame.origin.y = main_lang_lbl.frame.origin.y + main_lang_lbl.frame.size.height+10;
    
    main_lang.frame = frame;
    
    frame = support_lang_lbl.frame;
    
    frame.origin.y = main_lang.frame.origin.y + main_lang.frame.size.height+10;
    
    support_lang_lbl.frame = frame;
    
    frame = support_lang.frame;
    
    frame.origin.y = support_lang_lbl.frame.origin.y + support_lang_lbl.frame.size.height+10;
    
    support_lang.frame = frame;
    
    if ([lesson_type isEqual:@"2"]|| [lesson_type isEqual:@"4"]) {
        
        
        frame = maxStudent_lbl.frame;
        
        frame.origin.y = support_lang.frame.origin.y + support_lang.frame.size.height+10;
        
        maxStudent_lbl.frame = frame;
        
        frame = maxStudent_value.frame;
        
        frame.origin.y = maxStudent_lbl.frame.origin.y + maxStudent_lbl.frame.size.height+10;
        
        maxStudent_value.frame = frame;
        
        frame = seats_remainiglbl.frame;
        
        frame.origin.y = maxStudent_value.frame.origin.y + maxStudent_value.frame.size.height+10;
        
        seats_remainiglbl.frame = frame;
        
        frame = seats_remaining_value.frame;
        
        frame.origin.y = seats_remainiglbl.frame.origin.y + seats_remainiglbl.frame.size.height+10;
        
        seats_remaining_value.frame = frame;
    }
    else{
        
        maxStudent_lbl.hidden = YES;
        
        maxStudent_value.hidden = YES;
        
        seats_remaining_value.hidden = YES;
        
        seats_remainiglbl.hidden = YES;
        
        seats_remaining_value.frame = support_lang.frame;
        
    }
    
    frame = course_fees_lable.frame;
    
    frame.origin.y = seats_remaining_value.frame.origin.y + seats_remaining_value.frame.size.height+10;
    
    course_fees_lable.frame = frame;
    
    
    frame = course_fees_value.frame;
    
    frame.origin.y = course_fees_lable.frame.origin.y + course_fees_lable.frame.size.height+10;
    
    course_fees_value.frame = frame;
    
    
    // max_sizeLbl,max_size_value,available_places,available_places_value,date_time_lbl,day_time,venue_lbl,venue_value,age_group,age_groupValue,gender_lable,gender_value,main_lang_lbl,main_lang,main_lang,support_lang_lbl,support_lang,course_fees_lable,course_fees_value
    
    // frame.origin.y = frame.origin.y + frame.size.height + 20;
    
    CGRect btnFrame = requestToEnrollBtn.frame;
    
    btnFrame.origin.y = course_fees_value.frame.origin.y + course_fees_value.frame.size.height + 20;
    
    requestToEnrollBtn.frame = btnFrame;
    
    btnFrame = enquireBtn.frame;
    
    btnFrame.origin.y = requestToEnrollBtn.frame.origin.y;
    
    enquireBtn.frame = btnFrame;
    
    frame.origin.y = btnFrame.origin.y;
    
    frame.size.height = btnFrame.size.height;
    
    requestToEnrollBtn.layer.cornerRadius = 5.0f;
    
    enquireBtn.layer.cornerRadius = 5.0f;
    
    CGFloat height = frame.origin.y + frame.size.height + 30;
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, height)];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)viewWillAppear:(BOOL)animated{
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    [super viewWillDisappear:animated];
    
}

- (IBAction)tapRequestToBtn:(id)sender {
    
    NSDictionary *dict= @{@"type" : @"Lesson", @"id":[[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"lesson_id"], @"session_id" : [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"id"]};
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"enrollmentData"];
    
}

- (IBAction)tapEnduireBtn:(id)sender {
    
    sendMsgView = [[SendMessageView alloc] init];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPad" owner:self options:nil] objectAtIndex:0];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPhone" owner:self options:nil] objectAtIndex:0];
    }
    
    sendMsgView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+80);
    // [[NSUserDefaults standardUserDefaults] setObject:cousreDetailArray forKey:@"CourseDetail"];
    NSString *listing_name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"lesson_name"];
    
    listing_name = [@"[Enquiry] " stringByAppendingString:listing_name];
    
    NSString *educator_name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"name_educator"];
    
    NSString *name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]valueForKey:@"lesson_info"]  valueForKey:@"Member"]valueForKey:@"first_name"];
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@", %@", educator_name]];
    
    sendMsgView.to_textField.text = name;
    
    [[NSUserDefaults standardUserDefaults] setValue:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]valueForKey:@"lesson_info"]  valueForKey:@"Member"]valueForKey:@"email"] forKey:@"enquir_to"];
    
    sendMsgView.subject.text = listing_name;
    
    sendMsgView.frame = self.view.frame;
    
    sendMsgView.view_frame = self.view.frame;
    
    [self.view addSubview:sendMsgView];
    
    
}

- (IBAction)tapEditBtn:(id)sender {
    
    NSLog(@"Tap Edit");
}

- (IBAction)tapEdit_btn:(id)sender {
  
    //editLessionSession
    
    editLessionSessionViewController *editSessionVc = [self.storyboard instantiateViewControllerWithIdentifier:@"editLessionSession"];
    
    [self.navigationController pushViewController:editSessionVc animated:YES];
    
}

- (IBAction)tapDelete_btn:(id)sender {
    
    NSString *session_id= [[[sessionData valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"id"];
    
    NSDictionary *urlParam = @{@"session_id":session_id,@"type":@"3"};
    
    [self.view addSubview:indicator];
    
    [delConn startConnectionWithString:@"delete_session" HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([delConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            NSDictionary *paramURL = @{ @"lesson_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"]};
            
            NSLog(@"%@",paramURL);
            
            [self.view addSubview:indicator];
            
            [getLessConn startConnectionWithString:[NSString stringWithFormat:@"lesson_view"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
                
                [indicator removeFromSuperview];
                
                if ([getLessConn responseCode] == 1) {
                    
                    NSLog(@"%@", receivedData);
                    
                    NSDictionary *lessonDetailArray = [receivedData copy];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:lessonDetailArray forKey:@"lessonDetail"];
                    
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }];
            
        }
    }];
    
    
    
}

@end



