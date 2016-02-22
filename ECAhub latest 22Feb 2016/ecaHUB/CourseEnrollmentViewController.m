//
//  CourseEnrollmentViewController.m
//  ecaHUB
//
//  Created by promatics on 4/9/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "CourseEnrollmentViewController.h"
#import "DateConversion.h"
#import "Term_CondtionTable.h"
#import "Constant.h"
#import "ConfirmCourseEnrollViewController.h"

@interface CourseEnrollmentViewController () {
    
    DateConversion *dateConversion;
    
    NSMutableArray *terms_condArray;
    
    Term_CondtionTable *term_condView;
    
    BOOL istapbook, istapsecurity, istapother;
    
    NSString *fees_str_book, *fees_str_security, *fees_str_other;
    
    NSInteger ageyears;
}
@end

@implementation CourseEnrollmentViewController

@synthesize scrollView,studentHeading,name_value,name_lbl,gender_value,genderStd_value,GenderStd_lbl,gender_lbl,dob_value,dob_lbl,courseDetailsHeading,courseName_lbl,courseName_value,educator_value,educator_lbl,session_value,session_lbl,referenceId_lbl,referenceId_value,courseDuration_lbl,courseDuration_value,teachingMethod_lbl,teachingMethod_value,language_value,language_lbl,otherFees_value,ageGroup_lbl,ageGroup_value,dateandtimes_lbl,datesandTimes_value,location_lbl,location_value,courseFee_lbl,continueBtn,courseFee_value,courseFeeHeading,bookMaterial_value,bookBtn,book_lbl,security_value,severeWeather_value,security_lbl,securityBtn,severeWeather_lbl,otherFees,otherFeesBtn,otherFeesHeading,educatorTermsHeading,paymentdeadline_value,paymentDeadline_lbl,deposite_lbl,deposite_value,cancellation_value,changesEnroll_value,changesEnroll_lbl,cancellation_lbl,makeupEvant_value,makeupEvent_lbl,refund_value,refund_lbl,nooflessons_lbl,nooflessons_value;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Enrollment";
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1350);
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 970);
    }
    
    terms_condArray = [[NSMutableArray alloc] init];
    
    dateConversion = [DateConversion dateConversionManager];
        
    bookBtn.layer.borderWidth = 1.0f;
    bookBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    bookBtn.layer.cornerRadius = 5.0f;
   
    securityBtn.layer.borderWidth = 1.0f;
    securityBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    securityBtn.layer.cornerRadius = 5.0f;
    
    otherFeesBtn.layer.borderWidth = 1.0f;
    otherFeesBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    otherFeesBtn.layer.cornerRadius = 5.0f;
 
    continueBtn.layer.cornerRadius = 5.0f;
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"]);
    
    [self setData];
    
    [self setFrame];
}

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

-(void)setData {
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]);
    
    //NSArray *ageGrpArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"]valueForKey:@"age_title"];
    
    NSString *age_group =[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"age_group"];
    
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
    
    NSString *depositstr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"deposit"];
    
    NSArray *depositArray = [depositstr componentsSeparatedByString:@","];
    
    depositstr = @"";
    
    for (int i=0; i<depositArray.count; i++) {
   
    if ([[depositArray objectAtIndex:0] integerValue]==0) {
        
        depositstr = [depositstr stringByAppendingString:@"Deposits are not required.\n"];
    }
    
    else if ([[depositArray objectAtIndex:0] integerValue]==1){
        
        depositstr = [depositstr stringByAppendingString:@"A deposit is required to secure enrollment.\n"];
        
    }
    else if ([[depositArray objectAtIndex:0] integerValue]==2){
        
        depositstr = [depositstr stringByAppendingString:@"Deposit amounts are refunded when the student commences lessons."];
      
    }
    }
    
    deposite_value.text = [depositstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    courseName_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"course_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *day_timeArray = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]valueForKey:@"course_session"] valueForKey:@"LessonTiming"];
    
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
    
    datesandTimes_value.text = dateTimes;
    
    nooflessons_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"lessions_no"];
    
    educator_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    session_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"session_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *mainlanguage =[[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"main_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]stringByAppendingString:@" (Main)"];
    
    NSString *supported_language =[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"supported_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (![supported_language isEqualToString:@""]) {
        
        mainlanguage = [[[mainlanguage stringByAppendingString:@", "]stringByAppendingString:supported_language]stringByAppendingString:@" (Supporting)"];
        
    }
    
    language_value.text = [mainlanguage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    referenceId_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"reference_id"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *method =[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"type"];
    
    if ([method isEqual:@"2"]) {
        
       teachingMethod_value.text = @"Conducted in person, either face-to-face individually or in a group";
        
    }
    else if ([method isEqual:@"1"]){
        
       teachingMethod_value.text = @"An online or automated course, via Skype or other online medium";
    }
    
    NSString *blankSpace = @", ";
    
    NSString *streetno =[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"CourseSession"]valueForKey:@"venu_street"];
    
    if([streetno isEqualToString:@""]){
        
        streetno = @"";
    }
    else{
        
        streetno = [streetno stringByAppendingString:blankSpace];
    }
    
    NSString *district = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"CourseSession"]valueForKey:@"venu_district"];
    
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
        
        country =[country stringByAppendingString:@"."];
    }
    
    NSString *city = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"City"]valueForKey:@"city_name"];
    
    if([city isEqualToString:@""]){
        
        city = @"";
    }
    else{
        
        city = [city stringByAppendingString:blankSpace];
    }
    
    if([[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"CourseListing"] valueForKey:@"type"]isEqualToString:@"1"]){
        
        location_value.text = [@"Online, "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"]valueForKey:@"City"]valueForKey:@"city_name"]];
    }
    else{
        
        location_value.text = [[[[streetno stringByAppendingString:district]stringByAppendingString:city]stringByAppendingString:state]stringByAppendingString:country];
        
    }
    
    
    NSString *hours_str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"course_duration_hours"];
    
    if ([hours_str isEqual:@""]) {
        
        hours_str = @"";
    }
    else{
        
        hours_str = [hours_str stringByAppendingString:@" Hours"];
        
    }
    
    NSString *mint_str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"course_duration_minutes"];
    
    if ([mint_str isEqual:@""]) {
        
        mint_str = @"";
    }
    else{
    
    mint_str = [mint_str stringByAppendingString:@" Minutes"];
        
    }
    
    courseDuration_value.text = [[[ hours_str stringByAppendingString:@" "]stringByAppendingString:mint_str]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *course_fees = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"CourseSession"] valueForKey:@"fee_quantity"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([course_fees isEqualToString:@""]) {
        
        course_fees = @"0";
    }
    
    NSString *currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"Currency"] valueForKey:@"name"];
    
    course_fees = [currency stringByAppendingString:[NSString stringWithFormat:@" %0.2f",[course_fees floatValue]]];
    
    courseFee_value.text = [course_fees stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isMyself"]isEqual:@"1"]) {
        
        NSString *f_name = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"];
        
        f_name = [f_name stringByAppendingString:@" "];
        
        f_name = [f_name stringByAppendingString:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"last_name"]];
        
        name_value.text = [f_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        genderStd_value.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"gender"];
        
        NSString *birth = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"birth_date"]componentsSeparatedByString:@" "]objectAtIndex:0];
        
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
        
        genderStd_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Family"] valueForKey:@"gender"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *birth = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Family"] valueForKey:@"birth_date"];
        
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
    
    
    //NSString *str1 = @"Books & Materials ";
    
    NSString *str1 = @"";
    
    NSString *str2 = @" (Tick if a first time enrollment)";
    //SGD $50 (Tick if a first time enrollment)
    
    fees_str_book = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"quantity_books_materials"];
    
    if ([fees_str_book isEqualToString:@""]) {
        
        fees_str_book = @"0.00";
    }
    
    NSString *currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    str1 = [str1 stringByAppendingString:currencyStr];
    
    str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %0.2f",[fees_str_book floatValue]]];
    
    str1 = [str1 stringByAppendingString:str2];
    
    bookMaterial_value.text = [str1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //str1 = @"Security Deposit ";
    
    str1 = @"";
    
     fees_str_security = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"quantity_security"];
    
    if ([fees_str_security isEqualToString:@""]) {
        
        fees_str_security = @"0.00";
    }
  
    currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"security_currency"] valueForKey:@"name"];
    
    str1 = [str1 stringByAppendingString:currencyStr];
    
    str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %0.2f",[fees_str_security floatValue]]];
    
    str1 = [str1 stringByAppendingString:str2];
    
    security_value.text = [str1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //str1 = @"Other Fees ";
    
    str1 = @"";
    
     fees_str_other = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"other_charges"];
    
    if ([fees_str_other isEqualToString:@""]) {
        
        fees_str_other = @"0.00";
    }
    
    currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"]   valueForKey:@"course_info"] valueForKey:@"other_currency"] valueForKey:@"name"];
    
    str1 = [str1 stringByAppendingString:currencyStr];
    
    str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %0.2f",[fees_str_other floatValue]]];
    
    str1 = [str1 stringByAppendingString:str2];
    
    otherFees_value.text = [str1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    paymentdeadline_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"TermsPayment"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    NSString *depositeStr = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"deposit_name"];
//    
//    NSArray *deposit_array = [depositeStr componentsSeparatedByString:@", "];
//    
//    for (int i = 0; i< deposit_array.count; i++) {
//        
//        deposite_value.text = [deposit_array objectAtIndex:i];
//    }
    
    cancellation_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"TermsCancellation"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    refund_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"TermsRefund"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
    makeupEvant_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"TermsMakeUpLesson"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    changesEnroll_value.text = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"TermsChange"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"%@",[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"severe_names"] objectAtIndex:0]);
    
    NSArray *severe_array = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"severe_names"]  objectAtIndex:0];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"viewEnrollDetail"]) {
       
        ConfirmCourseEnrollViewController *confirmVC = [segue destinationViewController];
        
        confirmVC.isbookfee = istapbook;
        
        confirmVC.issecurityfee = istapsecurity;
        
        confirmVC.isotherfee = istapother;
        
        
    }
    
}


- (IBAction)tapContinueBtn:(id)sender {
    
//    NSString *message;
//    
//    if (!tapFee1 || !tapFee2 || !tapFee3 ) {
//        
//        message = @"Please Select All Check Boxes.";
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//    
//    } else {
    
        [self performSegueWithIdentifier:@"viewEnrollDetail" sender:self];
//    }
    
}

-(void)setFrame{
    
    CGRect frame = name_lbl.frame;
    
    frame.origin.y = studentHeading.frame.origin.y + studentHeading.frame.size.height +5;
    
    name_lbl.frame = frame;
    
    [name_lbl sizeToFit];
    
    frame = name_value.frame;
    
    frame.origin.y = studentHeading.frame.origin.y + studentHeading.frame.size.height +5;
    
    name_value.frame = frame;
    
    [name_value sizeToFit];
    
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
    
    frame.origin.y = dob_lbl.frame.origin.y ;
    
    dob_value.frame = frame;
    
    [dob_value sizeToFit];
    
    frame = GenderStd_lbl.frame;
    
    if (dob_value.frame.size.height <dob_lbl.frame.size.height) {
        
        frame.origin.y = dob_lbl.frame.origin.y + dob_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = dob_value.frame.origin.y + dob_value.frame.size.height +5;
    }
    
    GenderStd_lbl.frame = frame;
    
    [GenderStd_lbl sizeToFit];
    
    frame = genderStd_value.frame;
    
    frame.origin.y = GenderStd_lbl.frame.origin.y;
    
    genderStd_value.frame = frame;
    
    [genderStd_value sizeToFit];
    
    frame = courseDetailsHeading.frame;
    
    if (genderStd_value.frame.size.height <GenderStd_lbl.frame.size.height) {
        
        frame.origin.y = GenderStd_lbl.frame.origin.y + GenderStd_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = genderStd_value.frame.origin.y + genderStd_value.frame.size.height +5;
    }
    
    courseDetailsHeading.frame = frame;
    
    frame = courseName_lbl.frame;
    
    frame.origin.y = courseDetailsHeading.frame.origin.y + courseDetailsHeading.frame.size.height +5;
    
    courseName_lbl.frame = frame;
    
    [courseName_lbl sizeToFit];
    
    frame = courseName_value.frame;
    
    frame.origin.y = courseDetailsHeading.frame.origin.y + courseDetailsHeading.frame.size.height +5;
    
    courseName_value.frame = frame;
    
    [courseName_value sizeToFit];
    
    frame = educator_lbl.frame;
    
    if (courseName_value.frame.size.height <courseName_lbl.frame.size.height) {
        
        frame.origin.y = courseName_lbl.frame.origin.y + courseName_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = courseName_value.frame.origin.y + courseName_value.frame.size.height +5;
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
    
    frame = courseDuration_lbl.frame;
    
    if (referenceId_value.frame.size.height <referenceId_lbl.frame.size.height) {
        
        frame.origin.y = referenceId_lbl.frame.origin.y + referenceId_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = referenceId_value.frame.origin.y + referenceId_value.frame.size.height +5;
    }
    
    courseDuration_lbl.frame = frame;
    
    [courseDuration_lbl sizeToFit];
    
    frame = courseDuration_value.frame;
    
    frame.origin.y = courseDuration_lbl.frame.origin.y;
    
    courseDuration_value.frame = frame;
    
    [courseDuration_value sizeToFit];
    
    frame = teachingMethod_lbl.frame;
    
    frame.origin.y = courseDuration_value.frame.origin.y + courseDuration_value.frame.size.height +5;
    
    teachingMethod_lbl.frame = frame;
    
    [teachingMethod_lbl sizeToFit];
    
    frame = teachingMethod_value.frame;
    
    frame.origin.y = teachingMethod_lbl.frame.origin.y;
    
    teachingMethod_value.frame = frame;
    
    [teachingMethod_value sizeToFit];
    
    frame = language_lbl.frame;
    
    if (teachingMethod_value.frame.size.height <teachingMethod_lbl.frame.size.height) {
        
        frame.origin.y = teachingMethod_lbl.frame.origin.y + teachingMethod_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = teachingMethod_value.frame.origin.y + teachingMethod_value.frame.size.height +5;
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
    }
    
    ageGroup_lbl.frame = frame;
    
    [ageGroup_lbl sizeToFit];
    
    frame = ageGroup_value.frame;
    
    frame.origin.y = ageGroup_lbl.frame.origin.y;
    
    ageGroup_value.frame = frame;
    
    [ageGroup_value sizeToFit];
    
    frame = nooflessons_lbl.frame;
    
    if (ageGroup_value.frame.size.height <ageGroup_lbl.frame.size.height) {
        
        frame.origin.y = ageGroup_lbl.frame.origin.y + ageGroup_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = ageGroup_value.frame.origin.y + ageGroup_value.frame.size.height +5;
    }
    
    nooflessons_lbl.frame = frame;
    
    [nooflessons_lbl sizeToFit];
    
    frame = nooflessons_value.frame;
    
    frame.origin.y = nooflessons_lbl.frame.origin.y;
    
    nooflessons_value.frame = frame;
    
    [nooflessons_value sizeToFit];
    
    frame = dateandtimes_lbl.frame;
    
    if (nooflessons_value.frame.size.height <nooflessons_lbl.frame.size.height) {
        
        frame.origin.y = nooflessons_lbl.frame.origin.y + nooflessons_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = nooflessons_value.frame.origin.y + nooflessons_value.frame.size.height +5;
    }
    
    dateandtimes_lbl.frame = frame;
    
    [dateandtimes_lbl sizeToFit];
    
    frame = datesandTimes_value.frame;
    
    frame.origin.y = dateandtimes_lbl.frame.origin.y;
    
    datesandTimes_value.frame = frame;
    
    [datesandTimes_value sizeToFit];
    
    frame = location_lbl.frame;
    
    if (datesandTimes_value.frame.size.height <dateandtimes_lbl.frame.size.height) {
        
        frame.origin.y = dateandtimes_lbl.frame.origin.y + dateandtimes_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = datesandTimes_value.frame.origin.y + datesandTimes_value.frame.size.height +5;
    }
    
    location_lbl.frame = frame;
    
    [location_lbl sizeToFit];
    
    frame = location_value.frame;
    
    frame.origin.y = location_lbl.frame.origin.y;
    
    location_value.frame = frame;
    
    [location_value sizeToFit];
    
    frame = courseFeeHeading.frame;
    
    if (location_value.frame.size.height <location_lbl.frame.size.height) {
        
        frame.origin.y = location_lbl.frame.origin.y + location_lbl.frame.size.height +10;
    }
    else{
        
        frame.origin.y = location_value.frame.origin.y + location_value.frame.size.height +10;
    }
    
    courseFeeHeading.frame = frame;
    
    frame = courseFee_lbl.frame;
    
    frame.origin.y = courseFeeHeading.frame.origin.y + courseFeeHeading.frame.size.height +5;
    
    courseFee_lbl.frame = frame;
    
    [courseFee_lbl sizeToFit];
    
    frame = courseFee_value.frame;
    
    frame.origin.y = courseFeeHeading.frame.origin.y + courseFeeHeading.frame.size.height +5;
    
    courseFee_value.frame = frame;
    
    [courseFee_value sizeToFit];
    
    if (![fees_str_book isEqualToString:@"0.00"] && ![fees_str_security isEqualToString:@"0.00"] && ![fees_str_other isEqualToString:@"0.00"]) {
        
        frame = otherFeesHeading.frame;
        
        if (courseFee_value.frame.size.height <courseFee_lbl.frame.size.height) {
            
            frame.origin.y = courseFee_lbl.frame.origin.y + courseFee_lbl.frame.size.height +10;
        }
        else{
            
            frame.origin.y = courseFee_value.frame.origin.y + courseFee_value.frame.size.height +10;
        }
        
        otherFeesHeading.frame = frame;
        
    }
    
    else{
    
        otherFeesHeading.hidden = YES;
        
        frame = otherFeesHeading.frame;
        
        if (courseFee_value.frame.size.height <courseFee_lbl.frame.size.height) {
            
            frame.origin.y = courseFee_lbl.frame.origin.y;
            
            frame.size.height = courseFee_lbl.frame.size.height;
            
        }
        else{
            
            frame.origin.y = courseFee_value.frame.origin.y;
            
            frame.size.height = courseFee_value.frame.size.height;
        }
        
        otherFeesHeading.frame = frame;
    }
    
    if (![fees_str_book isEqualToString:@"0.00"] ) {
        
        frame = bookBtn.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height +5 +((book_lbl.frame.size.height-self.bookBtn.frame.size.height)/2);
        
        bookBtn.frame = frame;
        
        frame = book_lbl.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height +5;
        
        book_lbl.frame = frame;
        
        [book_lbl sizeToFit];
        
        frame = bookMaterial_value.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height +5;
        
        bookMaterial_value.frame = frame;
        
        [bookMaterial_value sizeToFit];
    }
    else{
        
        book_lbl.hidden = YES;
        
        bookBtn.hidden = YES;
        
        bookMaterial_value.hidden =YES;
        
        frame = book_lbl.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y;
        
        frame.size.height = courseFee_lbl.frame.size.height;
        
        book_lbl.frame = frame;
        
        frame = bookMaterial_value.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y;
        
        frame.size.height = courseFee_lbl.frame.size.height;
        
        bookMaterial_value.frame = frame;
    }
    
    if (![fees_str_security isEqualToString:@"0.00"] ) {
        
        frame = securityBtn.frame;
        
        if (bookMaterial_value.frame.size.height <book_lbl.frame.size.height) {
            
            frame.origin.y = book_lbl.frame.origin.y + book_lbl.frame.size.height +5 +((security_lbl.frame.size.height-self.securityBtn.frame.size.height)/2);
        }
        else{
            
            frame.origin.y = bookMaterial_value.frame.origin.y + bookMaterial_value.frame.size.height +5 +((security_lbl.frame.size.height-self.securityBtn.frame.size.height)/2);
        }
        
        securityBtn.frame = frame;
        
        frame = security_lbl.frame;
        
        if (bookMaterial_value.frame.size.height <book_lbl.frame.size.height) {
            
            frame.origin.y = book_lbl.frame.origin.y + book_lbl.frame.size.height +5;
        }
        else{
            
            frame.origin.y = bookMaterial_value.frame.origin.y + bookMaterial_value.frame.size.height +5;
        }
        
        security_lbl.frame = frame;
        
        [security_lbl sizeToFit];
        
        frame = security_value.frame;
        
        frame.origin.y = security_lbl.frame.origin.y;
        
        security_value.frame = frame;
        
        [security_value sizeToFit];
        
        
    }
    
    else{
        
        security_lbl.hidden = YES;
        
        security_value.hidden =YES;
        
        securityBtn.hidden = YES;
        
        security_lbl.frame = book_lbl.frame;
        
        security_value.frame = bookMaterial_value.frame;
        
    }
    
    if (![fees_str_other isEqualToString:@"0.00"]) {
        
        frame = otherFeesBtn.frame;
        
        if (security_value.frame.size.height <security_lbl.frame.size.height) {
            
            frame.origin.y = security_lbl.frame.origin.y + security_lbl.frame.size.height +5 +((otherFees.frame.size.height-self.otherFeesBtn.frame.size.height)/2);
        }
        else{
            
            frame.origin.y = security_value.frame.origin.y + security_value.frame.size.height +5 +((otherFees.frame.size.height-self.otherFeesBtn.frame.size.height)/2);
        }
        
        otherFeesBtn.frame = frame;
        
        frame = otherFees.frame;
        
        if (security_value.frame.size.height <security_lbl.frame.size.height) {
            
            frame.origin.y = security_lbl.frame.origin.y + security_lbl.frame.size.height +5;
        }
        else{
            
            frame.origin.y = security_value.frame.origin.y + security_value.frame.size.height +5;
        }
        
        otherFees.frame = frame;
        
        [otherFees sizeToFit];
        
        frame = otherFees_value.frame;
        
        frame.origin.y = otherFees.frame.origin.y;
        
        otherFees_value.frame = frame;
        
        [otherFees_value sizeToFit];
    }
    
    else{
        
        otherFees.hidden = YES;
        
        otherFees_value.hidden =YES;
        
        otherFeesBtn.hidden = YES;
        
        otherFees.frame = security_lbl.frame;
        
        otherFees_value.frame = security_value.frame;
        
        
    }
    
//    frame = bookBtn.frame;
//    
//    frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height +5 +((book_lbl.frame.size.height-self.bookBtn.frame.size.height)/2);
//    
//    bookBtn.frame = frame;
//    
//    frame = book_lbl.frame;
//    
//    frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height +5;
//    
//    book_lbl.frame = frame;
//    
//    frame = bookMaterial_value.frame;
//    
//    frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height +5;
//    
//    frame.size.height = [self heightCalculate:bookMaterial_value.text :bookMaterial_value];
//    
//    bookMaterial_value.frame = frame;
//    
//    frame = securityBtn.frame;
//    
//    frame.origin.y = bookMaterial_value.frame.origin.y + bookMaterial_value.frame.size.height +5 +((security_lbl.frame.size.height-self.securityBtn.frame.size.height)/2);
//    
//    securityBtn.frame = frame;
//    
//    frame = security_lbl.frame;
//    
//    frame.origin.y = bookMaterial_value.frame.origin.y + bookMaterial_value.frame.size.height +5;
//    
//    security_lbl.frame = frame;
//    
//    frame = security_value.frame;
//    
//    frame.origin.y = bookMaterial_value.frame.origin.y + bookMaterial_value.frame.size.height +5;
//    
//    frame.size.height = [self heightCalculate:security_value.text :security_value];
//    
//    security_value.frame = frame;
//    
//    frame = otherFeesBtn.frame;
//    
//    frame.origin.y = security_value.frame.origin.y + security_value.frame.size.height +5 +((otherFees.frame.size.height-self.otherFeesBtn.frame.size.height)/2);
//    
//    otherFeesBtn.frame = frame;
//    
//    frame = otherFees.frame;
//    
//    frame.origin.y = security_value.frame.origin.y + security_value.frame.size.height +5;
//    
//    otherFees.frame = frame;
//    
//    frame = otherFees_value.frame;
//    
//    frame.origin.y = security_value.frame.origin.y + security_value.frame.size.height +5;
//    
//    frame.size.height = [self heightCalculate:otherFees_value.text :otherFees_value];
//    
//    otherFees_value.frame = frame;
    
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
    
    frame = deposite_lbl.frame;
    
    if (paymentdeadline_value.frame.size.height <paymentDeadline_lbl.frame.size.height) {
        
        frame.origin.y = paymentDeadline_lbl.frame.origin.y + paymentDeadline_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = paymentdeadline_value.frame.origin.y + paymentdeadline_value.frame.size.height +5;
    }
    
    deposite_lbl.frame = frame;
    
    [deposite_lbl sizeToFit];
    
    frame = deposite_value.frame;
    
    frame.origin.y = deposite_lbl.frame.origin.y;
    
    deposite_value.frame = frame;
    
    [deposite_value sizeToFit];
    
    frame = changesEnroll_lbl.frame;
    
    if (deposite_value.frame.size.height <deposite_lbl.frame.size.height) {
        
        frame.origin.y = deposite_lbl.frame.origin.y + deposite_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = deposite_value.frame.origin.y + deposite_value.frame.size.height +5;
    }
    
    changesEnroll_lbl.frame = frame;
    
    [changesEnroll_lbl sizeToFit];
    
    frame = changesEnroll_value.frame;
    
    frame.origin.y = changesEnroll_lbl.frame.origin.y;
    
    changesEnroll_value.frame = frame;
    
    [changesEnroll_value sizeToFit];
    
    frame = cancellation_lbl.frame;
    
    if (changesEnroll_value.frame.size.height <changesEnroll_lbl.frame.size.height) {
        
        frame.origin.y = changesEnroll_lbl.frame.origin.y + changesEnroll_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = changesEnroll_value.frame.origin.y + changesEnroll_value.frame.size.height +5;
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


- (IBAction)tapT_CBtn:(id)sender {
    
    term_condView = [[[NSBundle mainBundle] loadNibNamed:@"Term_ConditionTable" owner:self options:nil] objectAtIndex:0];
    
    term_condView.frame = self.view.frame;
    
    term_condView.data_array = terms_condArray;
    
    [self.view addSubview:term_condView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

- (IBAction)tap_bookBtn:(id)sender{
    
    if (!istapbook) {
        
        [bookBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        [bookBtn setContentMode:UIViewContentModeScaleAspectFill];
        
        istapbook = YES;
        
    } else {
        
        [bookBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        istapbook = NO;
    }
    
    
}

- (IBAction)tap_securityBtn:(id)sender{
    
    if (!istapsecurity) {
        
        [securityBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        [securityBtn setContentMode:UIViewContentModeScaleAspectFill];
        
        istapsecurity = YES;
        
    } else {
        
        [securityBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        istapsecurity = NO;
    }
    
    
}
- (IBAction)tap_otherFeesBtn:(id)sender{
    
    if (!istapother) {
        
        [otherFeesBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        [otherFeesBtn setContentMode:UIViewContentModeScaleAspectFill];
        
        istapother = YES;
        
    } else {
        
        [otherFeesBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        istapother = NO;
    }
    
    
}

@end


