
//  SessionDetailViewController.m
//  ecaHUB
//
//  Created by promatics on 3/30/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "SessionDetailViewController.h"
#import "SendMessageView.h"
#import "DateConversion.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "EditSessionViewController.h"

@interface SessionDetailViewController () {
    
    NSDictionary *sessionData;
    SendMessageView *senMsgView;
    DateConversion *dateConversion;
    WebServiceConnection *delConn, *getCourseConn;
    Indicator *indicator;
}

@end

@implementation SessionDetailViewController

@synthesize scrollView,session_name,main_lang,support_lang,day_time,age_group,age_groupValue,gender_lable,gender_value,max_sizeLbl,max_size_value,available_places, available_places_value,course_fees_lable,course_fees_value, requestToEnrollBtn, enquireBtn,venue_lbl,venueSt_lbl,noOfLessons_LbL,noOfLessons_Value,editBtn,deletebtn,isEdit,isPrevAddAvail,date_time_lbl,instruction_lang_lbl,support_lang_lbl;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Session Option";
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    delConn = [WebServiceConnection connectionManager];
    
    getCourseConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    UIStoryboard *storyboard;
    
    if (isEdit) {
        
        self.navigationItem.rightBarButtonItems = @[deletebtn,editBtn];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 750);
    }
    
    dateConversion = [DateConversion dateConversionManager];
    
    [self setSessionDetail];
}


-(void) setSessionDetail {
    
    //  NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]);
    
    
    sessionData = [[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"];//
    
    NSString *couser_memId = [[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseListing"] valueForKey:@"member_id"];
    
    if (![couser_memId isEqualToString:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]]) {
        
        // [self.editBtn setWidth:0];
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    
    NSString *memberID = [[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"member_id"];
    
    NSString *startDate =[[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"start_date"];
    
    NSString *postStatus = [[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseListing"] valueForKey:@"course_status"];
    
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
    
    session_name.text =[[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"session_name"];
    
    CGRect main_langFrame = main_lang.frame;
    
    main_langFrame.size.width = self.view.frame.size.width - 30;
    
    main_lang.frame = main_langFrame;
    
    main_lang.text = [[[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"main_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    noOfLessons_Value.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"lessions_no"];
    
    NSLog(@"%@",[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"]);
    
    NSString *blankSpace = @", ";
    
    NSString *houseno = [[[sessionData valueForKey:@"course_session"]valueForKey:@"CourseSession"]valueForKey:@"venu_building_name"];
    
    if([houseno isEqualToString:@""]){
        
        houseno = @"";
    }
    else{
        
        houseno = [houseno stringByAppendingString:blankSpace];
    }
    
    NSString *streetno =[[[sessionData valueForKey:@"course_session"]valueForKey:@"CourseSession"]valueForKey:@"venu_street"];
    
    if([streetno isEqualToString:@""]){
        
        streetno = @"";
    }
    else{
        
        streetno = [streetno stringByAppendingString:blankSpace];
    }
    
    NSString *district = [[[sessionData valueForKey:@"course_session"]valueForKey:@"CourseSession"]valueForKey:@"venu_district"];
    
    if([district isEqualToString:@""]){
        
        district = @"";
    }
    else{
        
        district =[district stringByAppendingString:blankSpace];
    }
    
    NSString *state = [[[sessionData valueForKey:@"course_session"]valueForKey:@"State"]valueForKey:@"state_name"];
    
    if([state isEqualToString:@""]){
        
        state = @"";
    }
    else{
        
        state= [state stringByAppendingString:blankSpace];
    }
    
    NSString *country = [[[sessionData valueForKey:@"course_session"]valueForKey:@"Country"]valueForKey:@"country_name"];
    
    if([country isEqualToString:@""]){
        
        country = @"";
    }
    else{
        
        country =[country stringByAppendingString:@"."];
    }
    
    NSString *city = [[[sessionData valueForKey:@"course_session"]valueForKey:@"City"]valueForKey:@"city_name"];
    
    if([city isEqualToString:@""]){
        
        city = @"";
    }
    else{
        
        city = [city stringByAppendingString:blankSpace];
    }
    
    if([[[[sessionData valueForKey:@"course_session"]valueForKey:@"CourseListing"] valueForKey:@"type"]isEqualToString:@"1"]){
        
        venue_lbl.text = [@"Online, "stringByAppendingString:[[[sessionData valueForKey:@"sesion"]valueForKey:@"City"]valueForKey:@"city_name"]];
    }
    else{
        venue_lbl.text = [[[[streetno stringByAppendingString:district]stringByAppendingString:city]stringByAppendingString:state]stringByAppendingString:country];
        
    }
    
    NSString *sup_lang = [[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"supported_language"];
    
    if ([sup_lang isEqualToString:@""]) {
        
        sup_lang = @"N/A";
    }
    
    support_lang.text = [sup_lang stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // support_lang.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"supported_language"];
    
    max_size_value.text = [[[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"total_students"]stringByAppendingString:@" Students"];
    
    available_places_value.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"places"];
    
    NSString *currency = [[[sessionData valueForKey:@"course_session"]valueForKey:@"Currency"] valueForKey:@"name"];
    
    NSString *name = [[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"]valueForKey:@"fee_quantity"];
    
    CGFloat currencyvalue = [name floatValue];
    
    name = [@" " stringByAppendingString:[NSString stringWithFormat:@"%0.2f",currencyvalue]];
    
    currency = [currency stringByAppendingString:name];
    
    course_fees_value.text = currency;
    
    NSArray *day_timeArray = [[sessionData valueForKey:@"course_session"] valueForKey:@"LessonTiming"];
    
    CGRect frame;
    
   // day_time.hidden = YES;
    
    // frame.origin.y = frame.origin.y+10;
    
    NSString *dateTimes;
    
    for (int i= 0; i < day_timeArray.count; i++) {
        
        NSString *date = [[day_timeArray objectAtIndex:i] valueForKey:@"date_selected"];
        
        if([date isEqualToString:@""]){
            
            date = @"";
        }
        else{
            
            date = [dateConversion convertDate:date];
            
        }
        
        date = [date stringByAppendingString:@" ( "];
        
        date = [date stringByAppendingString:[[day_timeArray objectAtIndex:i] valueForKey:@"start_time"]];
        
        date = [date stringByAppendingString:@" - "];
        
        date = [date stringByAppendingString:[[day_timeArray objectAtIndex:i] valueForKey:@"finish_time"]];
        
        date = [date stringByAppendingString: @" )"];
        
        if (i == 0) {
            
            dateTimes = date;
            
        } else {
            
            dateTimes = [[dateTimes stringByAppendingString:@"\n"]stringByAppendingString:date];
        }
   
    }
    
    day_time.text = dateTimes;
    
//    frame.origin.y = frame.origin.y + frame.size.height + 10;
//    
//    frame.size.width = self.view.frame.size.width;
//    
//    frame.origin.x = 0;
//    
//    noOfLessons_LbL.frame = frame;
//    
//    frame.origin.y = frame.origin.y + frame.size.height + 10;
//    
//    frame.origin.x = main_lang.frame.origin.x;
//    
//    frame.size.width = main_lang.frame.size.width;
//    
//    noOfLessons_Value.frame = frame;
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
    
  //  frame = age_groupValue.frame;
    
    NSString *age;
    
    for (int i=0; i<age_array.count; i++) {
        
        if (i ==0) {
           
            age = [[[age_array objectAtIndex:i] valueForKey:@"AgeGroup"] valueForKey:@"title"];
            
        }
        else{
        
        age = [[age stringByAppendingString:@"\n"]stringByAppendingString:[[[age_array objectAtIndex:i] valueForKey:@"AgeGroup"] valueForKey:@"title"]];
            
        }
    
    }
    
    age_groupValue.text = age;
    
//    for (int i= 0; i < age_array.count; i++) {
//        
//        NSString *age = [[[age_array objectAtIndex:i] valueForKey:@"AgeGroup"] valueForKey:@"title"];
//        
//        if (i == 0) {
//            
//            frame.origin.y = frame.origin.y;
//            
//        } else {
//            
//            frame.origin.y = frame.origin.y + frame.size.height;
//        }
//        
//        UILabel *lable = [[UILabel alloc] initWithFrame:frame];
//        
//        lable.text = age;
//        
//        lable.textColor = [UIColor darkGrayColor];
//        
//        //[scrollView addSubview:lable];
//    }
    
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
    
        gender_value.text = gender_str;
    
//    
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
//    venueSt_lbl.frame = frame;
//    
//    frame = venueSt_lbl.frame;
//    
//    frame.origin.y = frame.origin.y + frame.size.height;
//    
//    frame.origin.x = main_lang.frame.origin.x;
//    
//    frame.size.width = main_lang.frame.size.width;
//    
//    frame.size.height = [self heightCalculate1:venue_lbl.text]+5;
//    
//    venue_lbl.frame = frame;
//    
//    frame = venue_lbl.frame;
//    
//    frame.origin.y = frame.origin.y + frame.size.height + 10;
//    
//    frame.size.height = available_places_value.frame.size.height;
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
//    
    //  frame.origin.y = frame.origin.y + frame.size.height + 20;
    
    //frame.origin.y = frame.origin.y + frame.size.height + 20;
    
    float height_lbl;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        height_lbl = 45;
        
    } else {
        
        height_lbl = 30;
    }
    
    frame = date_time_lbl.frame;
    
    frame.origin.y = session_name.frame.origin.y + session_name.frame.size.height+10;
    
    date_time_lbl.frame = frame;
    
    frame = day_time.frame;
    
    frame.origin.y = date_time_lbl.frame.origin.y+date_time_lbl.frame.size.height+10;
    
    day_time.numberOfLines = 0;
    
    day_time.lineBreakMode = NSLineBreakByWordWrapping;
    
    day_time.frame = frame;
        
    [day_time sizeToFit];
    
    frame = noOfLessons_LbL.frame;
    
    frame.origin.y = day_time.frame.origin.y +day_time.frame.size.height + 10;
    
    frame.size.width = self.view.frame.size.width;
    
    frame.origin.x = 0;
    
    noOfLessons_LbL.frame = frame;
    
    frame = noOfLessons_Value.frame;
    
    frame.origin.y = noOfLessons_LbL.frame.origin.y + noOfLessons_LbL.frame.size.height +10;
    
    noOfLessons_Value.frame = frame;
    
    frame = venueSt_lbl.frame;
    
    frame.origin.y = noOfLessons_Value.frame.origin.y+noOfLessons_Value.frame.size.height+10;
    
    frame.size.width = self.view.frame.size.width;
    
    venueSt_lbl.frame = frame;
    
    frame = venue_lbl.frame;
    
    frame.origin.y = venueSt_lbl.frame.origin.y+venueSt_lbl.frame.size.height+10;
    
    venue_lbl.frame = frame;
    
    [venue_lbl sizeToFit];
    
    if(venue_lbl.frame.size.height<height_lbl){
        
        frame = venue_lbl.frame;
        
        frame.size.height = height_lbl;
        
        
        venue_lbl.frame = frame;
    }
    
    frame = age_group.frame;
    
    frame.origin.y = venue_lbl.frame.origin.y+venue_lbl.frame.size.height+10;
    
    age_group.frame = frame;
    
    frame = age_groupValue.frame;
    
    frame.origin.y = age_group.frame.origin.y+age_group.frame.size.height+10;
    
    frame.size.width = self.view.frame.size.width-40;;
    
    age_groupValue.numberOfLines = 0;
    
    age_groupValue.lineBreakMode = NSLineBreakByWordWrapping;
    
    age_groupValue.frame = frame;
    
    [age_groupValue sizeToFit];
    
    if(age_groupValue.frame.size.height<height_lbl){
        
        
        frame = age_groupValue.frame;
        
        frame.size.height = height_lbl;
        
        age_groupValue.frame = frame;
    }
    
    
    frame = gender_lable.frame;
    
    frame.origin.y = age_groupValue.frame.origin.y+age_groupValue.frame.size.height+10;
    
    frame.size.height = height_lbl;
   
    gender_lable.frame = frame;
    
    frame = gender_value.frame;
    
    frame.origin.y = gender_lable.frame.origin.y + gender_lable.frame.size.height +10;
    
    gender_value.frame = frame;
    
    frame = instruction_lang_lbl.frame;
    
    frame.origin.y = gender_value.frame.origin.y + gender_value.frame.size.height +10;
    
    instruction_lang_lbl.frame = frame;
    
    frame = main_lang.frame;
    
    frame.origin.y = instruction_lang_lbl.frame.origin.y + instruction_lang_lbl.frame.size.height +10;
    
    main_lang.frame = frame;
    
    
    frame = support_lang_lbl.frame;
    
    frame.origin.y = main_lang.frame.origin.y + main_lang.frame.size.height +10;
    
    support_lang_lbl.frame = frame;
    
    
    frame = support_lang.frame;
    
    frame.origin.y = support_lang_lbl.frame.origin.y + support_lang_lbl.frame.size.height +10;
    
    support_lang.frame = frame;
    
    frame = max_sizeLbl.frame;
    
    frame.origin.y = support_lang.frame.origin.y + support_lang.frame.size.height +10;
    
    max_sizeLbl.frame = frame;
    
    frame = max_size_value.frame;
    
    frame.origin.y = max_sizeLbl.frame.origin.y + max_sizeLbl.frame.size.height +10;
    
    max_size_value.frame = frame;
    
    frame = available_places.frame;
    
    frame.origin.y = max_size_value.frame.origin.y + max_size_value.frame.size.height +10;
    
    available_places.frame = frame;
    
    frame = available_places_value.frame;
    
    frame.origin.y = available_places.frame.origin.y + available_places.frame.size.height +10;
    
    available_places_value.frame = frame;
    
    
    frame = course_fees_lable.frame;
    
    frame.origin.y = available_places_value.frame.origin.y + available_places_value.frame.size.height +10;
    
    course_fees_lable.frame = frame;
    
    frame = course_fees_value.frame;
    
    frame.origin.y = course_fees_lable.frame.origin.y + course_fees_lable.frame.size.height +10;
    
    course_fees_value.frame = frame;
    
    CGRect btnFrame = requestToEnrollBtn.frame;
    
    btnFrame.origin.y =course_fees_value.frame.origin.y+course_fees_value.frame.size.height+10;
    
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

-(CGFloat)heightCalculate1:(NSString *)calculateText{
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(venue_lbl.frame.size.width - (1.0f * 2), FLT_MAX);
    
    UIFont *font;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        font = [UIFont systemFontOfSize:20];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        font = [UIFont systemFontOfSize:17];
        
    }
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font} context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    [calculateText_lbl setFrame:CGRectMake(10, 74, 300 ,size.height+5)];
    
    [calculateText_lbl sizeToFit];
    
    CGFloat height_lbl = size.height;
    
    return (height_lbl + 10);
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
    
    [self setSessionDetail];
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    [super viewWillDisappear:animated];
    
}

- (IBAction)tapRequestToBtn:(id)sender {
    
    NSDictionary *dict= @{@"type" : @"Course", @"id":[[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"course_id"], @"session_id" : [[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"id"]};
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"enrollmentData"];
}

- (IBAction)tapEnduireBtn:(id)sender {
    
    senMsgView = [[SendMessageView alloc] init];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        senMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPad" owner:self options:nil] objectAtIndex:0];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        senMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPhone" owner:self options:nil] objectAtIndex:0];
    }
    
    senMsgView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+80);
    // [[NSUserDefaults standardUserDefaults] setObject:cousreDetailArray forKey:@"CourseDetail"];
    //   NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"CourseDetail"]);
    
    NSString *listing_name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"course_name"];
    
    listing_name = [@"[Enquiry] " stringByAppendingString:listing_name];
    
    NSString *educator_name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"name_educator"];
    
    NSString *name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"]valueForKey:@"course_info"]  valueForKey:@"Member"]valueForKey:@"first_name"];
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@", %@", educator_name]];
    
    senMsgView.to_textField.text = name;
    
    [[NSUserDefaults standardUserDefaults] setValue:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"]valueForKey:@"course_info"]  valueForKey:@"Member"]valueForKey:@"email"] forKey:@"enquir_to"];
    
    senMsgView.subject.text = listing_name;
    
    senMsgView.frame = self.view.frame;
    
    senMsgView.view_frame = self.view.frame;
    
    [self.view addSubview:senMsgView];
    
}

- (IBAction)tapEditBtn:(id)sender {
    
    NSLog(@"Tap Edit");
}

- (IBAction)tap_editBtn:(id)sender {
    
    if (isEdit) {
        
        EditSessionViewController *editSessionVc;
        
        editSessionVc.isPrevAddAvil = isPrevAddAvail;
        
    }
}
- (IBAction)tap_deletebtn:(id)sender {
    
    NSString *session_id= [[[sessionData valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"id"];
    
    NSDictionary *urlParam = @{@"session_id":session_id,@"type":@"1"};
    
    [self.view addSubview:indicator];
    
    [delConn startConnectionWithString:@"delete_session" HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([delConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            NSDictionary *paramURL = @{ @"course_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"]};
            
            NSLog(@"%@",paramURL);
            
            [self.view addSubview:indicator];
            
            [getCourseConn startConnectionWithString:[NSString stringWithFormat:@"course_view"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
                
                [indicator removeFromSuperview];
                
                if ([getCourseConn responseCode] == 1) {
                    
                    NSLog(@"%@", receivedData);
                    
                    NSDictionary *cousreDetailArray = [receivedData copy];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:cousreDetailArray forKey:@"CourseDetail"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }];
            
        }
    }];
    
}
@end


