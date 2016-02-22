//
//  EventSessionViewController.m
//  ecaHUB
//
//  Created by promatics on 4/7/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EventSessionViewController.h"
#import "SendMessageView.h"
#import "DateConversion.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "editSessionOptionsListingViewController.h"

@interface EventSessionViewController () {
    
    NSDictionary *sessionData;
    
    SendMessageView *sendMsgview;
    
    DateConversion *dateConversion;
    
    NSString *currentDate;
    
    WebServiceConnection *delConn, *getCourseConn;
    
    Indicator *indicator;
}
@end

@implementation EventSessionViewController

@synthesize scrollView,session_name,main_lang,support_lang,day_time,age_group,age_groupValue,gender_lable,gender_value,max_sizeLbl,max_size_value,available_places, available_places_value,course_fees_lable,course_fees_value, requestToEnrollBtn, enquireBtn,venue_lbl,venue_value,otherCharges_lbl,otherChargesValue,date_time_lbl,_lang_medium_lbl,support_lang_lbl,add_barBtn,cancel_barbutton,isView,isEdit;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Session Option";
    
    dateConversion = [DateConversion dateConversionManager];
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    if(isEdit){
        
       self.navigationItem.rightBarButtonItems = @[cancel_barbutton,add_barBtn];
        
     }
    
    delConn = [WebServiceConnection connectionManager];
    
    getCourseConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
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
    
    [self setSessionDetail];
}

-(void) setSessionDetail {
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]);
    
    sessionData = [[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"];
    
    NSString *couser_memId = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventListing"] valueForKey:@"member_id"];
    
    if (![couser_memId isEqualToString:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]]) {
        
        // [self.editBtn setWidth:0];
        
       // self.navigationItem.rightBarButtonItem = nil;
    }
    
    NSString *memberID = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"member_id"];
    
    
//    if ([memberID isEqualToString:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]] || ![[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventListing"] valueForKey:@"whatson_status"] isEqualToString:@"1"]) {
    
    NSString *startDate =[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"start_date"];
    
    NSString *postStatus = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventListing"] valueForKey:@"event_status"];
    
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
    
//    NSDateFormatter *format= [[NSDateFormatter alloc] init];
//    
//    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
//    
//    currentDate = [dateConversion convertDate:[format stringFromDate:[NSDate date]]];
//    
//    NSString *eventStart_dt = [[[sessionData valueForKey:@"course_session"]valueForKey:@"EventSession"]valueForKey:@"start_date"];
//    
//    eventStart_dt = [dateConversion convertDate:eventStart_dt];
//    
//    NSComparisonResult startCompare = [currentDate compare: eventStart_dt];
//    
//    
//    if ([[[[sessionData valueForKey:@"sesion"]valueForKey:@"EventListing"]valueForKey:@"event_status"]isEqual:@"1"]&& ![@"NSOrderedAscending" isEqualToString:[NSString stringWithFormat:@"%ld",(long)startCompare]]) {
//   
//        requestToEnrollBtn.hidden = NO;
//        enquireBtn.hidden = NO;
//        
//    } else {
//        
//        requestToEnrollBtn.hidden = YES;
//        enquireBtn.hidden = YES;
//    }
  
    session_name.text =[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"session_name"];
    
    CGRect main_langFrame = main_lang.frame;
    
    main_langFrame.size.width = self.view.frame.size.width - 30;
    
    main_lang.frame = main_langFrame;
    
    main_lang.text = [[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"main_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    NSString *sup_lang = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"supported_language"];
    
    if ([sup_lang isEqualToString:@""]) {
        
        sup_lang = @"N/A";
    }
    
    support_lang.text = [sup_lang stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    
    max_size_value.text = [[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"total_students"]stringByAppendingString:@" Attendees"];
    
    NSString *blankSpace = @", ";
    
    NSString *houseno =[[[sessionData valueForKey:@"course_session"]valueForKey:@"EventSession"] valueForKey:@"venu_building_name"];
    
    if ([houseno isEqualToString:@""]) {
        
        houseno = @"";
    }
    else{
        
        houseno = [houseno stringByAppendingString:blankSpace];
    }
    
    NSString *streetno =[[[sessionData valueForKey:@"course_session"]valueForKey:@"EventSession"]valueForKey:@"venu_street"];
    
    if ([streetno isEqualToString:@""]) {
        
        streetno = @"";
    }
    else{
        
        streetno = [streetno stringByAppendingString:blankSpace];
    }
    
    NSString *district = [[[sessionData valueForKey:@"course_session"]valueForKey:@"EventSession"]valueForKey:@"venu_district"];
    
    if ([district isEqualToString:@""]) {
        
        district = @"";
    }
    else{
        
        district = [district stringByAppendingString:blankSpace];
    }
    
    NSString *state =[[[sessionData valueForKey:@"course_session"]valueForKey:@"State"]valueForKey:@"state_name"];
    
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
    
    NSString *city =[[[sessionData valueForKey:@"course_session"]valueForKey:@"City"]valueForKey:@"city_name"];
    
    if ([city isEqualToString:@""]) {
        
        city = @"";
    }
    else{
        
        city = [city stringByAppendingString:@""];
    }
    
    venue_lbl.text = [[streetno stringByAppendingString:district]stringByAppendingString:city];
    
    NSString *currency = [[[sessionData valueForKey:@"course_session"]valueForKey:@"Currency"] valueForKey:@"name"];
    
    NSString *otherCharges = [[sessionData valueForKey:@"sesion"]valueForKey:@"other_charges"];
    
    if ([otherCharges isEqualToString:@""] || otherCharges == nil) {
        
        otherCharges = @"0";
    }
    
    otherChargesValue.text =[currency stringByAppendingString:[NSString stringWithFormat:@" %0.2f", [otherCharges floatValue]]];
    
    NSString *name = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"]valueForKey:@"fee_quantity"];
    
    currency = [[currency stringByAppendingString:@" " ]stringByAppendingString:[NSString stringWithFormat:@"%0.2f",[name floatValue]]];
    
    course_fees_value.text = currency;
    
    available_places_value.text = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"places"];
    
    // NSArray *day_timeArray = [[sessionData valueForKey:@"course_session"] valueForKey:@"LessonTiming"];
    
    //CGRect frame = day_time.frame;
    
    day_time.hidden = YES;
    
    // frame.origin.y = frame.origin.y+10;
    
    // for (int i= 0; i < day_timeArray.count; i++) {
    
    
    
    NSString *date = [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"start_date"];
    if ([date isEqualToString:@""]) {
        
        date = @"";
    }
    else{
        
        date = [dateConversion convertDate:date];
     
    }
    date = [date stringByAppendingString:@" ( "];
    
    date = [date stringByAppendingString:[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"start_time"]];
    
    date = [date stringByAppendingString:@" - "];
    
    date = [date stringByAppendingString:[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"finish_time"]];
    
    date = [date stringByAppendingString: @" )"];
    
    //        if (i == 0) {
    //
    //            frame.origin.y = frame.origin.y;
    //
    //        } else {
    //
    //            frame.origin.y = frame.origin.y + frame.size.height;
    //        }
    
    //        UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    //
    //        lable.text = date;
    //
    //        lable.textColor = [UIColor darkGrayColor];
    //
    //        [scrollView addSubview:lable];
    // }
    
    day_time.hidden = NO;
    
    day_time.text = date;
    
    //    frame.origin.y = frame.origin.y + frame.size.height + 10;
    //
    //    frame.size.width = self.view.frame.size.width;
    //
    //    frame.origin.x = 0;
    
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
    
    NSString *age;
    
    for (int i=0; i<age_array.count; i++) {
        
        if (i ==0) {
            
            age = [[[[age_array objectAtIndex:i] valueForKey:@"AgeGroup"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
        }
        else{
            
            age = [[age stringByAppendingString:@"\n"]stringByAppendingString:[[[[age_array objectAtIndex:i] valueForKey:@"AgeGroup"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
        }
        
    }
    
    age_groupValue.text = age;
    
    age_groupValue.numberOfLines = 0;
    
    age_groupValue.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    
    
//    frame.origin.y = frame.origin.y + frame.size.height + 10;
//    
//    frame.size.width = self.view.frame.size.width;
//    
//    frame.size.height = age_group.frame.size.height;
//    
//    frame.origin.x = 0;
//    
//    gender_lable.frame = frame;
//    
//    frame = gender_lable.frame;
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
// 
//    frame.origin.y = frame.origin.y + frame.size.height + 10;
//    
//    frame.size.width = self.view.frame.size.width;
//    
//    frame.origin.x = 0;
//    
//    otherCharges_lbl.frame = frame;
//    
//    frame = otherCharges_lbl.frame;
//    
//    frame.origin.y = frame.origin.y + frame.size.height;
//    
//    frame.origin.x = main_lang.frame.origin.x;
//    
//    frame.size.width = main_lang.frame.size.width;
//    
//    otherChargesValue.frame = frame;
//    
//    
    //date_time_lbl,day_time,venue_lbl,venue_value,age_group,age_groupValue
    

    //frame =
    
    
    CGRect frame = date_time_lbl.frame;
    
    frame.origin.y = session_name.frame.origin.y+session_name.frame.size.height+10;
    
    date_time_lbl.frame = frame;
    
    frame = day_time.frame;
    
    frame.origin.y = date_time_lbl.frame.origin.y+date_time_lbl.frame.size.height+10;
    
    day_time.frame = frame;
    
    day_time.numberOfLines = 0;
    
    day_time.lineBreakMode = NSLineBreakByWordWrapping;
    
    [day_time sizeToFit];
    
    frame = venue_value.frame;
    
    frame.origin.y = day_time.frame.origin.y+day_time.frame.size.height+10;
    
    venue_value.frame = frame;
    
    frame = venue_lbl.frame;
    
    frame.origin.y = venue_value.frame.origin.y+venue_value.frame.size.height+10;
    
    venue_lbl.frame = frame;
    
    venue_lbl.numberOfLines = 0;
    
    venue_lbl.lineBreakMode = NSLineBreakByWordWrapping;
    
    [venue_lbl sizeToFit];
    
    frame = age_group.frame;
    
    frame.origin.y = venue_lbl.frame.origin.y+venue_lbl.frame.size.height+10;
    
    age_group.frame = frame;
    
    frame = age_groupValue.frame;
    
    frame.origin.y = age_group.frame.origin.y+age_group.frame.size.height+10;
    
    age_groupValue.frame = frame;
    
    [age_groupValue sizeToFit];

    frame = gender_lable.frame;
    
    frame.origin.y = age_groupValue.frame.origin.y+age_groupValue.frame.size.height+10;
    
    gender_lable.frame = frame;
    
    frame = gender_value.frame;
    
    frame.origin.y = gender_lable.frame.origin.y+gender_lable.frame.size.height+10;
    
    gender_value.frame = frame;
    
    gender_value.numberOfLines = 0;
    
    gender_value.lineBreakMode = NSLineBreakByWordWrapping;
    
    [gender_value sizeToFit];
    
    frame = _lang_medium_lbl.frame;
    
    frame.origin.y = gender_value.frame.origin.y+gender_value.frame.size.height+10;
    
    _lang_medium_lbl.frame = frame;
    
    frame = main_lang.frame;
    
    frame.origin.y = _lang_medium_lbl.frame.origin.y+_lang_medium_lbl.frame.size.height+10;
    
    main_lang.frame = frame;
    
    main_lang.numberOfLines = 0;
    
    main_lang.lineBreakMode = NSLineBreakByWordWrapping;
    
    [main_lang sizeToFit];
    
    frame = support_lang_lbl.frame;
    
    frame.origin.y = main_lang.frame.origin.y+main_lang.frame.size.height+10;
    
    support_lang_lbl.frame = frame;
    
    frame = support_lang.frame;
    
    frame.origin.y = support_lang_lbl.frame.origin.y+support_lang_lbl.frame.size.height+10;
    
    support_lang.frame = frame;
    
    support_lang.numberOfLines = 0;
    
    support_lang.lineBreakMode = NSLineBreakByWordWrapping;
    
    [support_lang sizeToFit];

    
    //gender_lable,gender_value,_lang_medium_lbl,main_lang,support_lang_lbl,support_lang
    
    max_sizeLbl.frame = frame;
    
    frame.origin.y = support_lang.frame.origin.y+support_lang.frame.size.height+10;
    
    frame.origin.x = 0;
    
    frame.size.width = self.view.frame.size.width;
    
    max_sizeLbl.frame = frame;
    
    max_size_value.frame = frame;
    
    frame.origin.y = max_sizeLbl.frame.origin.y+max_sizeLbl.frame.size.height+10;
    
    frame.origin.x = gender_value.frame.origin.x;
    
    max_size_value.frame = frame;
    
    max_size_value.numberOfLines = 0;
    
    max_size_value.lineBreakMode = NSLineBreakByWordWrapping;
    
    [max_size_value sizeToFit];
    
    available_places.frame = frame;
    
    frame.origin.y = max_size_value.frame.origin.y+max_size_value.frame.size.height+10;
    
    frame.origin.x = 0;
    
    frame.size.width = self.view.frame.size.width;
    
    available_places.frame = frame;

    available_places_value.frame = frame;
    
    frame.origin.y = available_places.frame.origin.y+available_places.frame.size.height+10;
    
    frame.origin.x = gender_value.frame.origin.x;

    
    available_places_value.frame = frame;
    
    available_places_value.numberOfLines = 0;
    
    available_places_value.lineBreakMode = NSLineBreakByWordWrapping;
    
    [available_places_value sizeToFit];
    
    
    course_fees_lable.frame = frame;
    
    frame.origin.y = available_places_value.frame.origin.y+available_places_value.frame.size.height+10;
    
    frame.origin.x = 0;
    
    frame.size.width = self.view.frame.size.width;
    
    course_fees_lable.frame = frame;

    
    course_fees_value.frame = frame;
    
    frame.origin.y = course_fees_lable.frame.origin.y+course_fees_lable.frame.size.height+10;
    
    frame.origin.x = gender_value.frame.origin.x;

    
    course_fees_value.frame = frame;
    
    course_fees_value.numberOfLines = 0;
    
    course_fees_value.lineBreakMode = NSLineBreakByWordWrapping;
    
    [course_fees_value sizeToFit];
    
    otherCharges_lbl.frame = frame;
    
    frame.origin.y = course_fees_value.frame.origin.y+course_fees_value.frame.size.height+10;
    
    frame.origin.x = 0;
    
    frame.size.width = self.view.frame.size.width;
    
    otherCharges_lbl.frame = frame;
    
    otherChargesValue.frame = frame;
    
    frame.origin.y = otherCharges_lbl.frame.origin.y+otherCharges_lbl.frame.size.height+10;
    
    frame.origin.x = gender_value.frame.origin.x;

    
    otherChargesValue.frame = frame;
    
    otherChargesValue.numberOfLines = 0;
    
    otherChargesValue.lineBreakMode = NSLineBreakByWordWrapping;
    
    [otherChargesValue sizeToFit];


//max_sizeLbl,max_size_value,available_places,available_places_value,course_fees_value,otherCharges_lbl,otherChargesValue
    
    ///frame = otherChargesValue.frame;
    
   // frame.origin.y = frame.origin.y + frame.size.height + 20;
    
    CGRect btnFrame = requestToEnrollBtn.frame;
    
    btnFrame.origin.y = otherChargesValue.frame.origin.y+otherChargesValue.frame.size.height+20;
 
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

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    
}

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
    
    NSDictionary *dict= @{@"type" : @"Event", @"id":[[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"event_id"], @"session_id" : [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"id"]};
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"enrollmentData"];
    
    [self performSegueWithIdentifier:@"lesson_enrollment" sender:self];
}

- (IBAction)tapEnduireBtn:(id)sender {
    
    sendMsgview = [[SendMessageView alloc] init];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        sendMsgview = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPad" owner:self options:nil] objectAtIndex:0];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        sendMsgview = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPhone" owner:self options:nil] objectAtIndex:0];
    }
    
    sendMsgview.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+80);    // [[NSUserDefaults standardUserDefaults] setObject:cousreDetailArray forKey:@"CourseDetail"];
    //NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"CourseDetail"]);
    
    NSString *listing_name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_name"];
    
    listing_name = [@"[Enquiry] " stringByAppendingString:listing_name];
    
    NSString *educator_name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"name_educator"];
    
    NSString *name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]valueForKey:@"event_info"]  valueForKey:@"Member"]valueForKey:@"first_name"];
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@", %@", educator_name]];
    
    sendMsgview.to_textField.text = name;
    
    [[NSUserDefaults standardUserDefaults] setValue:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]valueForKey:@"event_info"]  valueForKey:@"Member"]valueForKey:@"email"] forKey:@"enquir_to"];
    
    sendMsgview.subject.text = listing_name;
    
    sendMsgview.frame = self.view.frame;
    
    sendMsgview.view_frame = self.view.frame;
    
    [self.view addSubview:sendMsgview];
}

- (IBAction)tapEditBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"editEventSessionSegue" sender:self];
    
    NSLog(@"Tap Edit");
}
- (IBAction)tap_edit_btn:(id)sender {
}

- (IBAction)tap_delete_btn:(id)sender {
    
    NSString *session_id= [[[sessionData valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"id"];
    
    NSDictionary *urlParam = @{@"session_id":session_id,@"type":@"2"};
    
    [self.view addSubview:indicator];
    
    [delConn startConnectionWithString:@"delete_session" HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([delConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            NSDictionary *paramURL = @{ @"event_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"]};
            
            NSLog(@"%@",paramURL);
            
            [self.view addSubview:indicator];
            
            [getCourseConn startConnectionWithString:[NSString stringWithFormat:@"event_view"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
                
                [indicator removeFromSuperview];
                
                if ([getCourseConn responseCode] == 1) {
                    
                    NSLog(@"%@", receivedData);
                    
                    NSDictionary *eventDetailArray = [receivedData copy];
                    
                   [[NSUserDefaults standardUserDefaults] setObject:eventDetailArray forKey:@"eventDetail"];
                    
                    editSessionOptionsListingViewController *editsessionVc;
                    
                    editsessionVc.listing_type = @"2";
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }];
            
        }
    }];
    

}
@end