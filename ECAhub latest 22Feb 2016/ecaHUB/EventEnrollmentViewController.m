//
//  EventEnrollmentViewController.m
//  ecaHUB
//
//  Created by promatics on 4/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EventEnrollmentViewController.h"
#import "DateConversion.h"
#import "Term_CondtionTable.h"
#import "Constant.h"
#import "ConfirmEventEnrollViewController.h"

@interface EventEnrollmentViewController () {
    
    DateConversion *dateConversion;
    
    NSMutableArray *terms_condArray;
    
    int tapstatus;
    
    NSInteger ageyears;
}
@end

@implementation EventEnrollmentViewController

@synthesize changesBooking_lbl,changesBooking_value,checkBtn,scrollView,session_lbl,session_name,session_value,severeWeather_lbl,severeWeather_value,name_lbl,name_value,makeupEvant_value,makeupEvent_lbl,dob_lbl,dob_value,datesTimes_lbl,datesTimes_value,otherFees,otherFees_value,otherFeesHeading,educator_lbl,educator_value,educatorTermsHeading,evantName_value,eventDetailsHeading,eventDuration_lbl,eventDuration_value,eventEntryFee_lbl,eventEntryFee_value,eventEntryFeeHeading,eventName_lbl,referenceId_lbl,referenceId_value,refund_lbl,refund_value,gender,location,noOfattendees_lbl,gender_lbl,gender_value,noOfattendees_value,language_lbl,language_value,location_lbl,location_value,cancellation_lbl,cancellation_value,continueBtn,course_name,typeOfEvent_lbl,typeOfEvent_value,forHeading,paymentDeadline_lbl,paymentdeadline_value,ageGroup_lbl,ageGroup_value,infoBtn,attendiesDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    self.title = @"Request to Book";
    
    tapstatus = 0;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
     scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.continueBtn.frame.origin.y + self.continueBtn.frame.size.height +50);
        
        self.continueBtn.layer.cornerRadius = 7;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
     scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.continueBtn.frame.origin.y + self.continueBtn.frame.size.height +50);
        
         self.continueBtn.layer.cornerRadius = 5;
    }
    
    checkBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    checkBtn.layer.borderWidth = 1.0f;
    
    checkBtn.layer.cornerRadius = 5.0f;
    
    terms_condArray = [[NSMutableArray alloc] init];
    
    dateConversion = [DateConversion dateConversionManager];

    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]);
    
    [self setData];
    
    [self setFrame];
}

-(void)setData {
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]);
    
     NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"enrollmentData"]);
    
     NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]);
    
    
    NSInteger no_ofadults= [[attendiesDict valueForKey:@"adult"]integerValue];
    
    NSInteger no_ofchildren= [[attendiesDict valueForKey:@"child"]integerValue];
    
    NSInteger totalAttendies = no_ofadults+no_ofchildren;
    
    noOfattendees_value.text =[[[[[NSString stringWithFormat:@"%d",totalAttendies]stringByAppendingString:@" (Adults/Teens "]stringByAppendingString:[NSString stringWithFormat:@"%d",no_ofadults]]stringByAppendingString:@", Child "]stringByAppendingString:[NSString stringWithFormat:@"%d)",no_ofchildren]];
    
    evantName_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    educator_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"]valueForKey:@"BusinessProfile"]valueForKey:@"name_educator"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    referenceId_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"]valueForKey:@"EventListing"]valueForKey:@"reference_id"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    session_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"session_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *blankSpace = @", ";
    
    NSString *houseno = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"EventSession"]valueForKey:@"venu_building_name"];
    
    if([houseno isEqualToString:@""]){
        
        houseno = @"";
    }
    else{
        
        houseno = [houseno stringByAppendingString:blankSpace];
    }
    
    NSString *streetno =[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"EventSession"]valueForKey:@"venu_street"];
    
    if([streetno isEqualToString:@""]){
        
        streetno = @"";
    }
    else{
        
        streetno = [streetno stringByAppendingString:blankSpace];
    }
    
    NSString *district = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"EventSession"]valueForKey:@"venu_district"];
    
    if([district isEqualToString:@""]){
        
        district = @"";
    }
    else{
        
        district =[district stringByAppendingString:blankSpace];
    }
    
    NSString *state = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"State"]valueForKey:@"state_name"];
    
    if([state isEqualToString:@""]){
        
        state = @"";
    }
    else{
        
        state= [state stringByAppendingString:blankSpace];
    }
    
    NSString *country = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"Country"]valueForKey:@"country_name"];
    
    if([country isEqualToString:@""]){
        
        country = @"";
    }
    else{
        
        country =[country stringByAppendingString:@""];
    }
    
    NSString *city = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"City"]valueForKey:@"city_name"];
    
    if([city isEqualToString:@""]){
        
        city = @"";
    }
    else{
        
        city = [city stringByAppendingString:@""];
    }
    
    if([[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"CourseListing"] valueForKey:@"type"]isEqualToString:@"1"]){
        
        location_value.text = [@"Online, "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"]valueForKey:@"City"]valueForKey:@"city_name"]];
    }
    else{
        
        location_value.text = [[streetno stringByAppendingString:district]stringByAppendingString:city];
        
    }
    
    NSString *hours_str = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_duration_hours"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([hours_str isEqual:@""]) {
        
        hours_str = @"";
    }
    
    else{
    
        hours_str = [hours_str stringByAppendingString:@" Hours "];
    }
    
    NSString *mint_str = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_duration_minutes"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([mint_str isEqual:@""]) {
        
        mint_str =@"";
    }
    else{
    
        mint_str = [mint_str stringByAppendingString:@" Minutes"];
    }
    
    eventDuration_value.text = [hours_str stringByAppendingString:mint_str];
    
    NSString *typeEvent = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"type"];
    
    if ([typeEvent isEqual:@"3"]) {
        
        typeOfEvent_value.text = @"Open Day";
    }
    
    else if ([typeEvent isEqual:@"4"]){
        
        typeOfEvent_value.text = @"Exhibition";
        
    }
    else if ([typeEvent isEqual:@"5"]){
        
        typeOfEvent_value.text = @"Performance";
        
    }
    else if ([typeEvent isEqual:@"6"]){
        
        typeOfEvent_value.text = @"Workshop Day";
        
    }
    else if ([typeEvent isEqual:@"7"]){
        
        typeOfEvent_value.text = @"Promotion";
        
    }
    else if ([typeEvent isEqual:@"8"]){
        
        typeOfEvent_value.text = @"Seminar";
        
    }
    else if ([typeEvent isEqual:@"9"]){
        
        typeOfEvent_value.text = @"Competition";
        
    }
    
    NSString *age_group =[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"age_group"];
    
    NSArray *age_groupArray = [age_group componentsSeparatedByString:@","];
    
    age_group = @"";
    
    for (int i = 0; i< age_groupArray.count; i++) {
        
        if ([[age_groupArray objectAtIndex:i]integerValue] == 1) {
            
            age_group =[age_group stringByAppendingString:@"Babies (0 - 1 yrs.)\n"];
            
        }
        
        else if ([[age_groupArray objectAtIndex:i]integerValue] == 2){
            
            age_group = [age_group stringByAppendingString:@"Toddlers (1 - 2 yrs.)\n"];
        }
        
        else if ([[age_groupArray objectAtIndex:i]integerValue] == 3){
            
            age_group = [age_group stringByAppendingString:@"Pre-School Children (2 - 5 yrs.)\n"];
        }
        
        else if ([[age_groupArray objectAtIndex:i]integerValue] == 4){
            
            age_group = [age_group stringByAppendingString:@"Early Primary Students (5 - 7 yrs.)\n"];
        }
        
        else if ([[age_groupArray objectAtIndex:i]integerValue] == 5){
            
            age_group = [age_group stringByAppendingString:@"Primary Students (7 - 12 yrs.)\n"];
        }
        
        else if ([[age_groupArray objectAtIndex:i]integerValue] == 6){
            
            age_group = [age_group stringByAppendingString:@"Early Secondary Students (12 - 14 yrs.)\n"];
        }
        
        else if([[age_groupArray objectAtIndex:i]integerValue] == 7){
            
            age_group = [age_group stringByAppendingString:@"Secondary Students (15 - 18 yrs.)\n"];
        }
        
        else if([[age_groupArray objectAtIndex:i]integerValue] == 8){
            
            age_group = [age_group stringByAppendingString:@"Tertiary Students (18 yrs. +)\n"];
            
        }
        
        else if([[age_groupArray objectAtIndex:i]integerValue] == 9){
            
            age_group = [age_group stringByAppendingString:@"Professional Students (18 yrs. +)\n"];
        }
        
        else if([[age_groupArray objectAtIndex:i]integerValue] == 10){
            
            age_group = [age_group stringByAppendingString:@"Adult Students (18 yrs. +)\n"];
            
        }
    }
    
    ageGroup_value.text = [age_group stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
    NSString *datetime =[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"start_date"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    datetime = [dateConversion convertDate:datetime];
    
    NSString*starttime =[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"start_time"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString*finishtime =[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"finish_time"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    datesTimes_value.text = [[[[[[datetime stringByAppendingString:@" ("]stringByAppendingString:starttime]stringByAppendingString:@"-"]stringByAppendingString:finishtime]stringByAppendingString:@")"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *mainlanguage =[[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"main_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]stringByAppendingString:@" (Main)"];
    
    NSString *supported_language =[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"supported_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (![supported_language isEqualToString:@""]) {
        
        mainlanguage = [[[mainlanguage stringByAppendingString:@", "]stringByAppendingString:supported_language]stringByAppendingString:@" (Supporting)"];
        
    }
    
    language_value.text = [mainlanguage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *course_fees = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"EventSession"] valueForKey:@"fee_quantity"];
    
    if ([course_fees isEqualToString:@""] || course_fees == nil) {
        
        course_fees = @"0";
    }
    
    NSString *currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"Currency"] valueForKey:@"name"];
    
    CGFloat fees = [course_fees floatValue];
    
    course_fees = [currency stringByAppendingString:[NSString stringWithFormat:@" %0.2f",fees]];
    
    eventEntryFee_value.text = [course_fees stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isMyself"]isEqual:@"1"]) {
        
        NSString *f_name = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Member"] valueForKey:@"first_name"];
        
        f_name = [f_name stringByAppendingString:@" "];
        
        f_name = [f_name stringByAppendingString:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Member"] valueForKey:@"family_name"]];
        
        name_value.text = [f_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *birth = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Member"] valueForKey:@"birth_date"]componentsSeparatedByString:@" "]objectAtIndex:0];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        ageyears = [self calculateYears:[formatter dateFromString:birth]];
        
        dob_value.text = [[dateConversion convertDate:birth]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
    }
    else{
        
        NSString *f_name = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Family"] valueForKey:@"first_name"];
        
        f_name = [f_name stringByAppendingString:@" "];
        
        f_name = [f_name stringByAppendingString:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Family"] valueForKey:@"family_name"]];
        
        name_value.text = [f_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *birth = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Family"] valueForKey:@"birth_date"]componentsSeparatedByString:@" "]objectAtIndex:0];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        ageyears = [self calculateYears:[formatter dateFromString:birth]];
        
        dob_value.text = [[dateConversion convertDate:birth]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    }
    
    NSArray *suitableArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]valueForKey:@"suitable"];
    
    NSString *suitablestr;
    
    for (int i = 0; i<suitableArray.count; i++) {
        
        if (i==0) {
            
            suitablestr = [[[suitableArray objectAtIndex:i]valueForKey:@"Suitable"]valueForKey:@"title"];
        }
        else{
            
            suitablestr =[[suitablestr stringByAppendingString:@", "]stringByAppendingString:[[[suitableArray objectAtIndex:i]valueForKey:@"Suitable"]valueForKey:@"title"]];
            
        }
        
    }
    
    gender_value.text = [suitablestr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *str1 = @"";
    
    NSString *str2 = @" (Tick if a first time enrollment)";
//    //SGD $50 (Tick if a first time enrollment)
//    
//    NSString *fees_str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"quantity_books_materials"];
//    
//    NSString *currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"b_m_currency"] valueForKey:@"name"];
//    
//    str1 = [str1 stringByAppendingString:currencyStr];
//    
//    str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %@",fees_str]];
//    
//    str1 = [str1 stringByAppendingString:str2];
//    
//  //  .text = str1;
//    
//    str1 = @"Security Deposit ";
//    
//    fees_str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"quantity_security"];
//    
//    currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"security_currency"] valueForKey:@"name"];
//    
//    str1 = [str1 stringByAppendingString:currencyStr];
//    
//    str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %@",fees_str]];
//    
//    str1 = [str1 stringByAppendingString:str2];
//    
// //   fees_lebel2.text = str1;
//    
//    str1 = @"";
//    
    NSString *fees_str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"other_charges"];
    
    if ([fees_str isEqualToString:@""] || fees_str ==nil) {
        
        fees_str = @"0";
    }
    
    NSString *currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]   valueForKey:@"event_info"] valueForKey:@"other_currency"] valueForKey:@"name"];
    
    str1 = [str1 stringByAppendingString:currencyStr];
    
    str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %0.2f",[fees_str floatValue]]];
    
    otherFees_value.text = [str1 stringByAppendingString:str2];
    
    paymentdeadline_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]   valueForKey:@"event_info"] valueForKey:@"TermsPayment"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *depositeStr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"deposit_name"];
    
    NSArray *deposit_array = [depositeStr componentsSeparatedByString:@", "];
    
    for (int i = 0; i< deposit_array.count; i++) {
        
        [terms_condArray addObject:[deposit_array objectAtIndex:i]];
    }
    
    cancellation_value.text =[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"TermsCancellation"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
   refund_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"TermsRefund"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    makeupEvant_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"TermsMakeUpLesson"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    changesBooking_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"TermsChangesBooking"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"%@",[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"severe_names"] objectAtIndex:0]);
    
    NSArray *severe_array = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"severe_names"]  objectAtIndex:0];
    
    NSString *severe_value;
    
    for (int i = 0; i< severe_array.count; i++) {
        
        if (i==0) {
            
            severe_value = [[[[severe_array objectAtIndex:i] valueForKey:@"TermsSevereWeather"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
        }
        else{
            
            severe_value = [[severe_value stringByAppendingString:@"\n"]stringByAppendingString:[[[[severe_array objectAtIndex:i] valueForKey:@"TermsSevereWeather"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        
    }
    
    severeWeather_value.text = [severe_value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//- (IBAction)tapFee_btn1:(id)sender {
//    
//    if (!tapFee1) {
//        
//        [fees_btn1 setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
//        
//        tapFee1 = YES;
//        
//    } else {
//        
//        [fees_btn1 setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
//        
//        tapFee1 = NO;
//    }
//}
//
//- (IBAction)tapFee_btn2:(id)sender {
//    
//    if (!tapFee2) {
//        
//        [fees_btn2 setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
//        
//        tapFee2 = YES;
//        
//    } else {
//        
//        [fees_btn2 setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
//        
//        tapFee2 = NO;
//    }
//}
//
//- (IBAction)tapFee_btn3:(id)sender {
//    
//    if (!tapFee3) {
//        
//        [fees_btn3 setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
//        
//        tapFee3 = YES;
//        
//    } else {
//        
//        [fees_btn3 setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
//        
//        tapFee3 = NO;
//    }
//}
//
//- (IBAction)tapAgreeBtn:(id)sender {
//    
//    if (!tapAgree) {
//        
//        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
//        
//        tapAgree = YES;
//        
//    } else {
//        
//        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
//        
//        tapAgree = NO;
//    }
//}

-(NSInteger)calculateYears:(NSDate *)firstDate{
    
    //NSDate *earlier = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:1];
    
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    // pass as many or as little units as you like here, separated by pipes
    NSUInteger units = NSYearCalendarUnit;
    
    NSDateComponents *components = [gregorian components:units fromDate:firstDate toDate:today options:0];
    
    NSInteger years = [components year];
    
    NSLog(@"Years: %ld", (long)years);
    
    return years;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier]isEqual:@"viewEnrollDetailEvent"]) {
        
        ConfirmEventEnrollViewController *cV = [segue destinationViewController];
        
        cV.attendiesInfo = [attendiesDict copy];
        
        cV.isOtherFees = tapstatus;
    }
}

- (IBAction)tapContinueBtn:(id)sender {
    
//    NSString *message;
//    
//    if (!tapFee1 || !tapFee2 || !tapFee3 || !tapAgree) {
//        
//        message = @"Please Select All Check Boxes.";
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//        
//    } else {
    
        [self performSegueWithIdentifier:@"viewEnrollDetailEvent" sender:self];
//    }
    
}

//- (IBAction)tapT_CBtn:(id)sender {
//    
//    term_condView = [[[NSBundle mainBundle] loadNibNamed:@"Term_ConditionTable" owner:self options:nil] objectAtIndex:0];
//    
//    term_condView.frame = self.view.frame;
//    
//    term_condView.data_array = terms_condArray;
//    
//    [self.view addSubview:term_condView];
//}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(void)setFrame{
    
    CGRect frame = name_lbl.frame;
    
    frame.origin.y = forHeading.frame.origin.y + forHeading.frame.size.height +5;
    
    name_lbl.frame = frame;
    
    [name_lbl sizeToFit];
    
    frame = name_value.frame;
    
    frame.origin.y = forHeading.frame.origin.y + forHeading.frame.size.height +5;
    
    //frame.size.height = [self heightCalculate:name_value.text :name_value];
    
    name_value.frame = frame;
    
    [name_value sizeToFit];
    
    if (ageyears <=18) {
        
        frame = dob_lbl.frame;
        
        if (name_value.frame.size.height <name_lbl.frame.size.height) {
            
            frame.origin.y = name_lbl.frame.origin.y + name_lbl.frame.size.height +5;
        }
        else{
            
            frame.origin.y = name_value.frame.origin.y + name_value.frame.size.height +5;
        }
        
        dob_lbl.frame = frame;
        
        [dob_lbl sizeToFit];
        
        frame = dob_value.frame;
        
        frame.origin.y = dob_lbl.frame.origin.y;
        
        dob_value.frame = frame;
        
        [dob_value sizeToFit];
        
    }
    
    else{
        
        dob_value.hidden = YES;
        
        dob_lbl.hidden = YES;
        
        dob_lbl.frame = name_lbl.frame;
        
        dob_value.frame = name_value.frame;
    }
    
    frame = noOfattendees_lbl.frame;
    
    if (dob_value.frame.size.height <dob_lbl.frame.size.height) {
        
        frame.origin.y = dob_lbl.frame.origin.y + dob_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = dob_value.frame.origin.y + dob_value.frame.size.height +5;
    }
    
    noOfattendees_lbl.frame = frame;
    
    [noOfattendees_lbl sizeToFit];
    
    frame = noOfattendees_value.frame;
    
    frame.origin.y = noOfattendees_lbl.frame.origin.y;
    
    noOfattendees_value.frame = frame;
    
    [noOfattendees_value sizeToFit];
    
    frame = eventDetailsHeading.frame;
    
    if (noOfattendees_value.frame.size.height <noOfattendees_lbl.frame.size.height) {
        
        frame.origin.y = noOfattendees_lbl.frame.origin.y + noOfattendees_lbl.frame.size.height +10;
    }
    else{
        
        frame.origin.y = noOfattendees_value.frame.origin.y + noOfattendees_value.frame.size.height +10;
    }
    
    eventDetailsHeading.frame = frame;
    
    frame = eventName_lbl.frame;
    
    frame.origin.y = eventDetailsHeading.frame.origin.y + eventDetailsHeading.frame.size.height +5;
    
    eventName_lbl.frame = frame;
    
    [eventName_lbl sizeToFit];
    
    frame = evantName_value.frame;
    
    frame.origin.y = eventDetailsHeading.frame.origin.y + eventDetailsHeading.frame.size.height +5;
    
    evantName_value.frame = frame;
    
    [evantName_value sizeToFit];
    
    frame = educator_lbl.frame;
    
    if (evantName_value.frame.size.height <eventName_lbl.frame.size.height) {
        
        frame.origin.y = eventName_lbl.frame.origin.y + eventName_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = evantName_value.frame.origin.y + evantName_value.frame.size.height +5;
    }
    
    educator_lbl.frame = frame;
    
    [educator_lbl sizeToFit];
    
    frame = educator_value.frame;
    
    frame.origin.y = educator_lbl.frame.origin.y;
    
    educator_value.frame = frame;
    
    [educator_value sizeToFit];
    
    frame = session_lbl.frame;
    
    if (educator_value.frame.size.height <educator_lbl.frame.size.height) {
        
        frame.origin.y = educator_lbl.frame.origin.y + educator_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = educator_value.frame.origin.y + educator_value.frame.size.height +5;
    }
    
    session_lbl.frame = frame;
    
    [session_lbl sizeToFit];
    
    frame = session_value.frame;
    
    frame.origin.y = session_lbl.frame.origin.y;
    
    session_value.frame = frame;
    
    [session_value sizeToFit];
    
    frame = referenceId_lbl.frame;
    
    if (session_value.frame.size.height <session_lbl.frame.size.height) {
        
        frame.origin.y = session_lbl.frame.origin.y + session_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = session_value.frame.origin.y + session_value.frame.size.height +5;
    }
    
    referenceId_lbl.frame = frame;
    
    [referenceId_lbl sizeToFit];
    
    frame = referenceId_value.frame;
    
    frame.origin.y = referenceId_lbl.frame.origin.y;
    
    referenceId_value.frame = frame;
    
    [referenceId_value sizeToFit];
    
    frame = eventDuration_lbl.frame;
    
    if (referenceId_value.frame.size.height <referenceId_lbl.frame.size.height) {
        
        frame.origin.y = referenceId_lbl.frame.origin.y + referenceId_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = referenceId_value.frame.origin.y + referenceId_value.frame.size.height +5;
    }
    
    eventDuration_lbl.frame = frame;
    
    [eventDuration_lbl sizeToFit];
    
    frame = eventDuration_value.frame;
    
    frame.origin.y = eventDuration_lbl.frame.origin.y;
    
    eventDuration_value.frame = frame;
    
    [eventDuration_value sizeToFit];
    
    frame = typeOfEvent_lbl.frame;
    
    if (eventDuration_value.frame.size.height <eventDuration_lbl.frame.size.height) {
        
        frame.origin.y = eventDuration_lbl.frame.origin.y + eventDuration_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = eventDuration_value.frame.origin.y + eventDuration_value.frame.size.height +5;
    }
    
    typeOfEvent_lbl.frame = frame;
    
    [typeOfEvent_lbl sizeToFit];
    
    frame = typeOfEvent_value.frame;
    
    frame.origin.y = typeOfEvent_lbl.frame.origin.y;
    
    typeOfEvent_value.frame = frame;
    
    [typeOfEvent_value sizeToFit];
    
    frame = language_lbl.frame;
    
    if (typeOfEvent_value.frame.size.height <typeOfEvent_lbl.frame.size.height) {
        
        frame.origin.y = typeOfEvent_lbl.frame.origin.y + typeOfEvent_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = typeOfEvent_value.frame.origin.y + typeOfEvent_value.frame.size.height +5;
    }
    
    language_lbl.frame = frame;
    
    [language_lbl sizeToFit];
    
    frame = language_value.frame;
    
    frame.origin.y = language_lbl.frame.origin.y;
    
    language_value.frame = frame;
    
    [language_value sizeToFit];
    
    frame = gender_lbl.frame;
    
    if (language_value.frame.size.height <language_lbl.frame.size.height) {
        
        frame.origin.y = language_lbl.frame.origin.y + language_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = language_value.frame.origin.y + language_value.frame.size.height +5;
    }
    
    gender_lbl.frame = frame;
    
    [gender_lbl sizeToFit];
    
    frame = gender_value.frame;
    
    frame.origin.y = gender_lbl.frame.origin.y;
    
    gender_value.frame = frame;
    
    [gender_value sizeToFit];
    
    frame = ageGroup_lbl.frame;
    
    if (gender_value.frame.size.height <gender_lbl.frame.size.height) {
        
        frame.origin.y = gender_lbl.frame.origin.y + gender_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = gender_value.frame.origin.y + gender_value.frame.size.height +5;
    };
    
    ageGroup_lbl.frame = frame;
    
    [ageGroup_lbl sizeToFit];
    
    frame = ageGroup_value.frame;
    
    frame.origin.y = ageGroup_lbl.frame.origin.y;
    
    ageGroup_value.frame = frame;
    
    [ageGroup_value sizeToFit];
    
    frame = datesTimes_lbl.frame;
    
    if (ageGroup_value.frame.size.height <ageGroup_lbl.frame.size.height) {
        
        frame.origin.y = ageGroup_lbl.frame.origin.y + ageGroup_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = ageGroup_value.frame.origin.y + ageGroup_value.frame.size.height +5;
    }
    
    datesTimes_lbl.frame = frame;
    
    [datesTimes_lbl sizeToFit];
    
    frame = datesTimes_value.frame;
    
    frame.origin.y = datesTimes_lbl.frame.origin.y;
    
    datesTimes_value.frame = frame;
    
    [datesTimes_value sizeToFit];
    
    frame = location_lbl.frame;
    
    if (datesTimes_value.frame.size.height <datesTimes_lbl.frame.size.height) {
        
        frame.origin.y = datesTimes_lbl.frame.origin.y + datesTimes_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = datesTimes_value.frame.origin.y + datesTimes_value.frame.size.height +5;
    }
    
    location_lbl.frame = frame;
    
    [location_lbl sizeToFit];
    
    frame = location_value.frame;
    
    frame.origin.y = location_lbl.frame.origin.y;
    
    location_value.frame = frame;
    
    [location_value sizeToFit];
    
    frame = eventEntryFeeHeading.frame;
    
    if (datesTimes_value.frame.size.height <location_lbl.frame.size.height) {
        
        frame.origin.y = location_lbl.frame.origin.y + location_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = location_value.frame.origin.y + location_value.frame.size.height +5;
    }
    
    eventEntryFeeHeading.frame = frame;
    
    frame = eventEntryFee_lbl.frame;
    
    frame.origin.y = eventEntryFeeHeading.frame.origin.y + eventEntryFeeHeading.frame.size.height +5;
    
    eventEntryFee_lbl.frame = frame;
    
    [eventEntryFee_lbl sizeToFit];
    
    frame = eventEntryFee_value.frame;
    
    frame.origin.y = eventEntryFeeHeading.frame.origin.y + eventEntryFeeHeading.frame.size.height +5;
    
    eventEntryFee_value.frame = frame;
    
    [eventEntryFee_value sizeToFit];
    
    NSString *fees_str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"other_charges"];
    
    if ([fees_str isEqualToString:@""]||fees_str == nil ||[fees_str isEqual:@"0"]||[fees_str isEqual:@"0.00"]) {
        
        otherFeesHeading.hidden = YES;
        
        otherFees_value.hidden =YES;
        
        otherFees.hidden = YES;
        
        checkBtn.hidden = YES;
        
        infoBtn.hidden = YES;
        
        otherFees.frame = eventEntryFee_lbl.frame;
        
        otherFees_value.frame = eventEntryFee_value.frame;
    }
    
    else{
    
    frame = otherFeesHeading.frame;
    
    if (eventEntryFee_value.frame.size.height <eventEntryFee_lbl.frame.size.height) {
        
        frame.origin.y = eventEntryFee_lbl.frame.origin.y + eventEntryFee_lbl.frame.size.height +10;
    }
    else{
        
        frame.origin.y = eventEntryFee_value.frame.origin.y + eventEntryFee_value.frame.size.height +10;
    }
    
    otherFeesHeading.frame = frame;
    
    frame = infoBtn.frame;
    
    frame.origin.y = otherFeesHeading.frame.origin.y;
    
    infoBtn.frame = frame;
    
    frame = otherFees.frame;
    
    frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height +5;
    
    otherFees.frame = frame;
    
    [otherFees sizeToFit];
    
    frame = otherFees_value.frame;
    
    frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height +5;
    
    otherFees_value.frame = frame;
    
    [otherFees_value sizeToFit];
    
    frame = checkBtn.frame;
    
    frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height +5;
    
    checkBtn.frame = frame;
        
    }
    
    frame = educatorTermsHeading.frame;
    
    if (otherFees_value.frame.size.height <otherFees.frame.size.height) {
        
        frame.origin.y = otherFees.frame.origin.y + otherFees.frame.size.height +15;
    }
    else{
        
        frame.origin.y = otherFees_value.frame.origin.y + otherFees_value.frame.size.height +15;
    }
    
    educatorTermsHeading.frame = frame;
    
    frame = paymentDeadline_lbl.frame;
    
    frame.origin.y = educatorTermsHeading.frame.origin.y + educatorTermsHeading.frame.size.height +5;
    
    paymentDeadline_lbl.frame = frame;
    
    [paymentDeadline_lbl sizeToFit];
    
    frame = paymentdeadline_value.frame;
    
    frame.origin.y = educatorTermsHeading.frame.origin.y + educatorTermsHeading.frame.size.height +5;
    
    paymentdeadline_value.frame = frame;
    
    [paymentdeadline_value sizeToFit];
    
    frame = changesBooking_lbl.frame;
    
    if (paymentdeadline_value.frame.size.height <paymentDeadline_lbl.frame.size.height) {
        
        frame.origin.y = paymentDeadline_lbl.frame.origin.y + paymentDeadline_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = paymentdeadline_value.frame.origin.y + paymentdeadline_value.frame.size.height +5;
    }
    
    changesBooking_lbl.frame = frame;
    
    [changesBooking_lbl sizeToFit];
    
    frame = changesBooking_value.frame;
    
    frame.origin.y = changesBooking_lbl.frame.origin.y;
    
    changesBooking_value.frame = frame;
    
    [changesBooking_value sizeToFit];
    
    frame = cancellation_lbl.frame;
    
    if (changesBooking_value.frame.size.height <changesBooking_lbl.frame.size.height) {
        
        frame.origin.y = changesBooking_lbl.frame.origin.y + changesBooking_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = changesBooking_value.frame.origin.y + changesBooking_value.frame.size.height +5;
    }
    
    cancellation_lbl.frame = frame;
    
    [cancellation_lbl sizeToFit];
    
    frame = cancellation_value.frame;
    
    frame.origin.y = cancellation_lbl.frame.origin.y;
    
    cancellation_value.frame = frame;
    
    [cancellation_value sizeToFit];
    
    frame = makeupEvent_lbl.frame;
    
    if (cancellation_value.frame.size.height <cancellation_lbl.frame.size.height) {
        
        frame.origin.y = cancellation_lbl.frame.origin.y + cancellation_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = cancellation_value.frame.origin.y + cancellation_value.frame.size.height +5;
    }
    
    makeupEvent_lbl.frame = frame;
    
    [makeupEvent_lbl sizeToFit];
    
    frame = makeupEvant_value.frame;
    
    frame.origin.y = makeupEvent_lbl.frame.origin.y;
    
    makeupEvant_value.frame = frame;
    
    [makeupEvant_value sizeToFit];
    
    frame = severeWeather_lbl.frame;
    
    if (makeupEvant_value.frame.size.height <makeupEvent_lbl.frame.size.height) {
        
        frame.origin.y = makeupEvent_lbl.frame.origin.y + makeupEvent_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = makeupEvant_value.frame.origin.y + makeupEvant_value.frame.size.height +5;
    }
    
    severeWeather_lbl.frame = frame;
    
    [severeWeather_lbl sizeToFit];
    
    frame = severeWeather_value.frame;
    
    frame.origin.y = severeWeather_lbl.frame.origin.y;
    
    severeWeather_value.frame = frame;
    
    [severeWeather_value sizeToFit];
    
    frame = refund_lbl.frame;
    
    if (severeWeather_value.frame.size.height <severeWeather_lbl.frame.size.height) {
        
        frame.origin.y = severeWeather_lbl.frame.origin.y + severeWeather_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = severeWeather_value.frame.origin.y + severeWeather_value.frame.size.height +5;
    }
    
    refund_lbl.frame = frame;
    
    [refund_lbl sizeToFit];
    
    frame = refund_value.frame;
    
    frame.origin.y = refund_lbl.frame.origin.y;
    
    refund_value.frame = frame;
    
    [refund_value sizeToFit];
    
    frame = continueBtn.frame;
    
    if (refund_value.frame.size.height <refund_lbl.frame.size.height) {
        
        frame.origin.y = refund_lbl.frame.origin.y + refund_lbl.frame.size.height +30;
    }
    else{
        
        frame.origin.y = refund_value.frame.origin.y + refund_value.frame.size.height +30;
    }
    
    continueBtn.frame = frame;
    
    CGFloat height = self.continueBtn.frame.origin.y + self.continueBtn.frame.size.height +50;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
    
   
    
}

-(CGFloat)heightCalculate:(NSString *)calculateText :(UILabel *)lbl{
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(lbl.frame.size.width - (1.0f * 2), FLT_MAX);
    
    UIFont *font;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        font = [UIFont systemFontOfSize:19];
        
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
    
    if (height_lbl > lbl.frame.size.height) {
        
        return (height_lbl);
    }
    
    else{
        
        return (lbl.frame.size.height);
    }
    
}

- (IBAction)tap_infoBtn:(id)sender {
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Tick if instructed by educator in the Event Description." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertview show];
}
- (IBAction)tap_checkBtn:(id)sender {
    
    if (tapstatus ==0) {
        
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        tapstatus = 1;
        
    }
    
    else if (tapstatus ==1){
        
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"checkMark_gray"] forState:UIControlStateNormal];
        
        tapstatus = 0;
        
    }
    
    
}
@end
