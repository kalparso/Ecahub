
//
//  ConfirmLessonEnrollViewController.m
//  ecaHUB
//
//  Created by promatics on 4/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "ConfirmLessonEnrollViewController.h"
#import "DateConversion.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "MyEnroll_BookingViewController.h"

@interface ConfirmLessonEnrollViewController () {
    
    DateConversion *dateConversion;
    
    NSMutableArray *terms_condArray;
    
    WebServiceConnection *confiemCourseEnrollConn;
    
    Indicator *indicator;
    
    CGFloat totalFees;
    
    NSString *lesson_timing_id;
    
    BOOL isContinues;
}
@end

@implementation ConfirmLessonEnrollViewController

@synthesize scrollView,continueBtn,studentHeading,name_lbl,dob_lbl,dob_value,name_value,GenderStd_lbl,genderStd_value,lessonDetailsHeading,lessonName_lbl,lessonName_value,educator_lbl,educator_value,session_lbl,session_value,referenceId_lbl,referenceId_value,lessonDuration_lbl,teachingMethod_lbl,teachingMethod_value,language_lbl,language_value,gender_lbl,gender_value,ageGroup_lbl,ageGroup_value,selectedTimeSlot_value,selectedTimeSlot_lbl,location_lbl,location_value,lessonFee_lbl,lessonFee_value,lessonFeeHeading,otherFees,otherFees_value,educatorTermsHeading,paymentDeadline_lbl,paymentdeadline_value,changesEnroll_lbl,changesEnroll_value,cancellation_lbl,cancellation_value,makeupEvant_value,makeupEvent_lbl,severeWeather_lbl,severeWeather_value,refund_lbl,refund_value,security_lbl,security_value,book_lbl,bookMaterial_value,enrollment_lbl,enrollment_value,minimumPayment_lbl,minimumpymnt_value,deposite_lbl,deposite_value,lessonDuration_value,isbook,isother,issecurity,totalPayable_lbl,totalPayable_value,codeOfConduct_value,codeofConductHeading,selectedDatesArray,weekly_lbl,weekly_value,slctdTimeSlot,isconticase;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    self.title =@"Enrollment";
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1750);
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1300);
    }
    
    confiemCourseEnrollConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    terms_condArray = [[NSMutableArray alloc] init];
    
    dateConversion = [DateConversion dateConversionManager];
    
    continueBtn.layer.cornerRadius = 5.0f;
    
    changesEnroll_lbl.hidden = YES;
    
    changesEnroll_value.hidden = YES;
    
    NSLog(@"%@\n %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"], [[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"]);
    
    NSString *enrollment_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"Enrollment"] valueForKey:@"id"];
    
    if ([enrollment_id isEqualToString:@"4"]|| isconticase == 1) {
        
        isContinues = YES;
    }
        
    NSLog(@"%@",slctdTimeSlot);
    
    [self setData];
    
    
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
    
    NSInteger ageyears;
    
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
        
        genderStd_value.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Family"] valueForKey:@"gender"];
        
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
    
    lessonName_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"lesson_name"];
    
    educator_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
    
    session_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"LessonSession"]valueForKey:@"session_name"];
    
    referenceId_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"LessonListing"] valueForKey:@"reference_id"];
    
    NSString *hours_str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"lesson_duration_hours"];
    
    if ([hours_str isEqualToString:@""]) {
        
        hours_str = @"";
    }
    else{
        
        hours_str = [hours_str stringByAppendingString:@" Hours"];
    }
    
    NSString *mint_str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"lesson_duration_minutes"];
    
    if ([mint_str isEqualToString:@""]) {
        
        mint_str = @"";
    }
    else{
        
        mint_str = [mint_str stringByAppendingString:@" Minutes"];
        
    }
    
    lessonDuration_value.text = [[hours_str stringByAppendingString:@" "]stringByAppendingString:mint_str];
    
    NSString *typeEvent = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"LessonListing"] valueForKey:@"lesson_type"];
    
    if ([typeEvent isEqual:@"1"]) {
        
        teachingMethod_value.text = @"Private Tutorial Lesson";
    }
    
    else if ([typeEvent isEqual:@"2"]){
        
        teachingMethod_value.text = @"Group Lesson";
        
    }
    else if ([typeEvent isEqual:@"3"]){
        
        teachingMethod_value.text = @"Online Private Tutorial Lesson";
        
    }
    else if ([typeEvent isEqual:@"4"]){
        
        teachingMethod_value.text = @"Online Group Lesson";
        
    }
    
    NSString *mainlanguage =[[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"main_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]stringByAppendingString:@" (Main)"];
    
    NSString *supported_language =[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"supported_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (![supported_language isEqualToString:@""]) {
        
        mainlanguage = [[[mainlanguage stringByAppendingString:@", "]stringByAppendingString:supported_language]stringByAppendingString:@" (Supporting)"];
        
    }
    
    language_value.text = [mainlanguage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *age_group =[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"age_group"];
    
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
    
    NSString *blankSpace = @", ";
    
//    NSString *houseno = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"LessonSession"]valueForKey:@"venu_building_name"];
//    
//    if([houseno isEqualToString:@""]){
//        
//        houseno = @"";
//    }
//    else{
//        
//        houseno = [houseno stringByAppendingString:blankSpace];
//    }
    
    NSString *streetno =[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"LessonSession"]valueForKey:@"venu_street"];
    
    if([streetno isEqualToString:@""]){
        
        streetno = @"";
    }
    else{
        
        streetno = [streetno stringByAppendingString:blankSpace];
    }
    
    NSString *district = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"LessonSession"]valueForKey:@"venu_district"];
    
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
    
    if([[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"LessonListing"] valueForKey:@"type"]isEqualToString:@"1"]){
        
        location_value.text = [@"Online, "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"]valueForKey:@"City"]valueForKey:@"city_name"]];
    }
    else{
        
        location_value.text = [[streetno stringByAppendingString:district]stringByAppendingString:city];
        
    }
    
    NSString *depositstr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"deposit"];
    
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
    
    //-----------------------------//
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]);
    
    continueBtn.layer.cornerRadius = 5;
    
    slctdTimeSlot = [slctdTimeSlot stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    slctdTimeSlot = [[[slctdTimeSlot componentsSeparatedByString:@"y"]objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *date_and_time_ary = [[NSMutableArray alloc]init];
    
    for (int i=0; i<selectedDatesArray.count; i++) {
        
        [date_and_time_ary addObject:[[[selectedDatesArray objectAtIndex:i]stringByAppendingString:@" "]stringByAppendingString:slctdTimeSlot]];
    }
    
    selectedTimeSlot_value.text = [date_and_time_ary componentsJoinedByString:@"\n"];
    
    lesson_timing_id = [[[NSUserDefaults standardUserDefaults] valueForKey:@"TimeSlot"] valueForKey:@"id"];
    
    codeOfConduct_value.text = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.\n\nBy clicking 'Submit Booking Request' you hereby agree to the above Educator Terms & Conditions and will abide by the Code of Conduct while using the ECAhub service.";
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]);
    
    NSString *course_fees = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"fee_quantity"];
    
    NSString *currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"Currency"] valueForKey:@"name"];
    
    CGFloat lessonfees = [course_fees floatValue];
    
    totalFees = lessonfees * selectedDatesArray.count;
    
    NSString *course_fe = [currency stringByAppendingString:[NSString stringWithFormat:@" %0.2f ",totalFees]];
    
    lessonFee_value.text = [[[[course_fe stringByAppendingString:@" (Total No of Lesson=" ]stringByAppendingString:[NSString stringWithFormat:@"%d *",selectedDatesArray.count]]stringByAppendingString:course_fees]stringByAppendingString:@" Lesson Fee)"];
    
    NSString *str1 = @"";
    
    NSString *str2 = @"";
    //SGD $50 (Tick if a first time enrollment)
    
    NSString *bookfeeStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_books_materials"];
    
    NSString *currencyStr;
    
    if (![bookfeeStr isEqualToString:@""] && ![bookfeeStr isEqualToString:@"0.00"]) {
        
        if (isbook) {
            
            totalFees = totalFees + [bookfeeStr floatValue];
        }
        
        currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"b_m_currency"] valueForKey:@"name"];
        
        str1 = [currencyStr stringByAppendingString:str1];
        
        str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %@",bookfeeStr]];
        
        str1 = [str1 stringByAppendingString:str2];
        
        bookMaterial_value.text = str1;
        
    }
    
    
    
    str1 = @"";
    
    NSString *securityFees = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_security"];
    
    if (![securityFees isEqualToString:@""] && ![securityFees isEqualToString:@"0.00"]) {
        
        if (issecurity) {
            
            totalFees = totalFees+ [securityFees floatValue];
        }
        
        currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"security_currency"] valueForKey:@"name"];
        
        str1 = [currencyStr stringByAppendingString:str1];
        
        str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %@",securityFees]];
        
        str1 = [str1 stringByAppendingString:str2];
        
        security_value.text= str1;
        
    }
    
    str1 = @"";
    
    NSString *otherFeesStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges"];
    
    if (![otherFeesStr isEqualToString:@""] && ![otherFeesStr isEqualToString:@"0.00"]) {
        
        if (isother) {
            
            totalFees = totalFees + [otherFeesStr floatValue];
        }
        
        currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]   valueForKey:@"lesson_info"] valueForKey:@"other_currency"] valueForKey:@"name"];
        
        str1 = [currencyStr stringByAppendingString:str1];
        
        str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %@",otherFeesStr]];
        
        str1 = [str1 stringByAppendingString:str2];
        
        otherFees_value.text = str1;
        
    }
    
    if (isContinues) {
        
        
        totalPayable_lbl.text = @"First Payment";
        
        weekly_value.text =[[currency stringByAppendingString:[NSString stringWithFormat:@" %0.2f ",lessonfees]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        lessonFee_value.text = weekly_value.text;
        
        totalPayable_value.text = [[[currency stringByAppendingString:@" "]stringByAppendingString:[NSString stringWithFormat:@"%0.2f",(totalFees-(lessonfees * selectedDatesArray.count))+lessonfees]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else{
    
    totalPayable_value.text = [[[currency stringByAppendingString:@" "]stringByAppendingString:[NSString stringWithFormat:@"%0.2f",totalFees]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    }
    
    enrollment_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"Enrollment"] valueForKey:@"title"];
    
    NSString *enrollment_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"Enrollment"] valueForKey:@"id"];
    
    if ([enrollment_id isEqual:@"0"]||[enrollment_id isEqual:@"1"]||[enrollment_id isEqual:@"2"]||[enrollment_id isEqual:@"3"]) {
        
        minimumpymnt_value.text = @"For enrolments of a set number of lessons only, OR enrolments of four (4) lessons or less: Payment of all lesson fees plus other charges such as books, materials, deposit and others (if applicable) is required in advance in one payment transaction. For continuous and infinite enrolments without a set end-date: Payment of ONE lesson fee plus other fees such as books, materials, deposit and others (if applicable) is required in the 1st payment, and the 2nd payment onwards will be charged automatically, weekly and in advance using the same payment method used on the 1st payment, and will only include one lesson fee at a time.";
        
    }
    else{
        
        minimumpymnt_value.text = @"For continuous enrolments of more than four (4) lessons, the 1st payment will include ONE lesson fee plus other fees such as books, materials, deposit and others (if applicable). The 2nd payment onwards will be charged automatically, weekly and in advance using the same payment method used on the 1st payment, and will only include one lesson fee at a time. For four (4) lessons or less of continuous enrolment, payment of all lesson fees plus other fees such as books, materials, deposit and others (if applicable) is required in advance in one payment transaction.";
        
    }
       
    paymentdeadline_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"TermsPayment"] valueForKey:@"title"];
    
    cancellation_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"TermsCancellation"] valueForKey:@"title"];
    
    refund_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"TermsRefund"] valueForKey:@"title"];
    
    makeupEvant_value.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"TermsMakeUpLesson"] valueForKey:@"title"];
    
    //    te = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"TermsChange"] valueForKey:@"title"];
    
    NSLog(@"%@",[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"severe_names"] objectAtIndex:0]);
    
    NSArray *severe_array = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"severe_names"]  objectAtIndex:0];
    
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
    
    [name_lbl sizeToFit];
    
    CGRect frame = name_value.frame;
    
    frame.origin.y = name_lbl.frame.origin.y;
    
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
    
    frame = lessonDetailsHeading.frame;
    
    if (genderStd_value.frame.size.height <GenderStd_lbl.frame.size.height) {
        
        frame.origin.y = GenderStd_lbl.frame.origin.y + GenderStd_lbl.frame.size.height +10;
    }
    else{
        
        frame.origin.y = genderStd_value.frame.origin.y + genderStd_value.frame.size.height +10;
    }
    
    lessonDetailsHeading.frame = frame;
    
    [lessonDetailsHeading sizeToFit];
    
    frame = lessonName_lbl.frame;
    
    frame.origin.y = lessonDetailsHeading.frame.origin.y + lessonDetailsHeading.frame.size.height + 5;
    
    lessonName_lbl.frame = frame;
    
    [lessonName_lbl sizeToFit];
    
    frame = lessonName_value.frame;
    
    frame.origin.y = lessonDetailsHeading.frame.origin.y + lessonDetailsHeading.frame.size.height + 5;
    
    lessonName_value.frame = frame;
    
    [lessonName_value sizeToFit];
    
    frame = educator_lbl.frame;
    
    if (lessonName_value.frame.size.height <lessonName_lbl.frame.size.height) {
        
        frame.origin.y = lessonName_lbl.frame.origin.y + lessonName_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = lessonName_value.frame.origin.y + lessonName_value.frame.size.height +5;
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
    
    frame = lessonDuration_lbl.frame;
    
    if (referenceId_value.frame.size.height <referenceId_lbl.frame.size.height) {
        
        frame.origin.y = referenceId_lbl.frame.origin.y + referenceId_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = referenceId_value.frame.origin.y + referenceId_value.frame.size.height +5;
    }
    
    lessonDuration_lbl.frame = frame;
    
    [lessonDuration_lbl sizeToFit];
    
    frame = lessonDuration_value.frame;
    
    frame.origin.y = lessonDuration_lbl.frame.origin.y;
    
    lessonDuration_value.frame = frame;
    
    [lessonDuration_value sizeToFit];
    
    frame = teachingMethod_lbl.frame;
    
    if (lessonDuration_value.frame.size.height <lessonDuration_lbl.frame.size.height) {
        
        frame.origin.y = lessonDuration_lbl.frame.origin.y + lessonDuration_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = lessonDuration_value.frame.origin.y + lessonDuration_value.frame.size.height +5;
    }
    
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
    
    frame = location_lbl.frame;
    
    if (ageGroup_value.frame.size.height <ageGroup_lbl.frame.size.height) {
        
        frame.origin.y = ageGroup_lbl.frame.origin.y + ageGroup_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = ageGroup_value.frame.origin.y + ageGroup_value.frame.size.height +5;
    }
    
    location_lbl.frame = frame;
    
    [location_lbl sizeToFit];
    
    frame = location_value.frame;
    
    frame.origin.y = location_lbl.frame.origin.y;
    
    location_value.frame = frame;
    
    [location_value sizeToFit];
    
    frame = selectedTimeSlot_lbl.frame;
    
    if (location_value.frame.size.height <location_lbl.frame.size.height) {
        
        frame.origin.y = location_lbl.frame.origin.y + location_lbl.frame.size.height +10;
    }
    else{
        
        frame.origin.y = location_value.frame.origin.y + location_value.frame.size.height +10;
    }
    
    selectedTimeSlot_lbl.frame = frame;
    
    [selectedTimeSlot_lbl sizeToFit];
    
    frame = selectedTimeSlot_value.frame;
    
    frame.origin.y = selectedTimeSlot_lbl.frame.origin.y;
    
    selectedTimeSlot_value.frame = frame;
    
    [selectedTimeSlot_value sizeToFit];
    
    frame = lessonFeeHeading.frame;
    
    if (selectedTimeSlot_value.frame.size.height <selectedTimeSlot_lbl.frame.size.height) {
        
        frame.origin.y = selectedTimeSlot_lbl.frame.origin.y + selectedTimeSlot_lbl.frame.size.height +10;
    }
    else{
        
        frame.origin.y = selectedTimeSlot_value.frame.origin.y + selectedTimeSlot_value.frame.size.height +10;
    }
    
    lessonFeeHeading.frame = frame;
    
    [lessonFeeHeading sizeToFit];
    
    frame = lessonFee_lbl.frame;
    
    frame.origin.y = lessonFeeHeading.frame.origin.y + lessonFeeHeading.frame.size.height + 5;
    
    lessonFee_lbl.frame = frame;
    
    [lessonFee_lbl sizeToFit];
    
    frame = lessonFee_value.frame;
    
    frame.origin.y = lessonFeeHeading.frame.origin.y + lessonFeeHeading.frame.size.height + 5;
    
    lessonFee_value.frame = frame;
    
    [lessonFee_value sizeToFit];
    
    if (isbook) {
        
        frame = book_lbl.frame;
        
        frame.origin.y = lessonFee_value.frame.origin.y + lessonFee_value.frame.size.height + 5;
        
        book_lbl.frame = frame;
        
        frame = bookMaterial_value.frame;
        
        frame.origin.y = lessonFee_value.frame.origin.y + lessonFee_value.frame.size.height + 5;
        
        frame.size.height = [self heightCalculate:bookMaterial_value.text :bookMaterial_value];
        
        bookMaterial_value.frame = frame;
        
        
    }
    else{
        
        frame = book_lbl.frame;
        
        frame.origin.y = lessonFee_value.frame.origin.y ;
        
        book_lbl.frame = frame;
        
        frame = bookMaterial_value.frame;
        
        frame.origin.y = lessonFee_value.frame.origin.y ;
        
        frame.size.height = lessonFee_value.frame.size.height;
        
        bookMaterial_value.frame = frame;
        
        bookMaterial_value.hidden = YES;
        
        book_lbl.hidden = YES;
        
    }
    
    if (issecurity) {
        
        frame = security_lbl.frame;
        
        frame.origin.y = bookMaterial_value.frame.origin.y + bookMaterial_value.frame.size.height + 5;
        
        security_lbl.frame = frame;
        
        frame = security_value.frame;
        
        frame.origin.y = bookMaterial_value.frame.origin.y + bookMaterial_value.frame.size.height + 5;
        
        frame.size.height = [self heightCalculate:security_value.text :security_value];
        
        security_value.frame = frame;
        
        
    }
    
    else{
        
        frame = security_lbl.frame;
        
        frame.origin.y = bookMaterial_value.frame.origin.y ;
        
        security_lbl.frame = frame;
        
        frame = security_value.frame;
        
        frame.origin.y = bookMaterial_value.frame.origin.y ;
        
        frame.size.height = bookMaterial_value.frame.size.height;
        
        security_value.frame = frame;
        
        security_value.hidden = YES;
        
        security_lbl.hidden =YES;
        
    }
    
    if (isother) {
        
        frame = otherFees.frame;
        
        frame.origin.y = security_value.frame.origin.y + security_value.frame.size.height + 5;
        
        otherFees.frame = frame;
        
        frame = otherFees_value.frame;
        
        frame.origin.y = security_value.frame.origin.y + security_value.frame.size.height + 5;
        
        frame.size.height = [self heightCalculate:otherFees_value.text :otherFees_value];
        
        otherFees_value.frame = frame;
        
    }
    
    else{
        
        frame = otherFees.frame;
        
        frame.origin.y = security_value.frame.origin.y ;
        
        otherFees.frame = frame;
        
        frame = otherFees_value.frame;
        
        frame.origin.y = security_value.frame.origin.y ;
        
        frame.size.height = security_value.frame.size.height;
        
        otherFees_value.frame = frame;
        
        otherFees.hidden = YES;
        
        otherFees_value.hidden = YES;
        
    }
    
    frame = totalPayable_lbl.frame;
    
    frame.origin.y = otherFees_value.frame.origin.y + otherFees_value.frame.size.height + 5;
    
    totalPayable_lbl.frame = frame;
    
    frame = totalPayable_value.frame;
    
    frame.origin.y = otherFees_value.frame.origin.y + otherFees_value.frame.size.height + 5;
    
    frame.size.height = [self heightCalculate:totalPayable_value.text :totalPayable_value];
    
    totalPayable_value.frame = frame;
    
    if (isContinues) {
        
        frame = weekly_lbl.frame;
        
        if (totalPayable_value.frame.size.height <totalPayable_lbl.frame.size.height) {
            
            frame.origin.y = totalPayable_lbl.frame.origin.y + totalPayable_lbl.frame.size.height +5;
        }
        else{
            
            frame.origin.y = totalPayable_value.frame.origin.y + totalPayable_value.frame.size.height +5;
        }
        
        weekly_lbl.frame = frame;
        
        [weekly_lbl sizeToFit];
        
        frame = weekly_value.frame;
        
        frame.origin.y = weekly_lbl.frame.origin.y;
        
        weekly_value.frame = frame;
        
        [weekly_value sizeToFit];
        
        
    }
    
    else{
        
        
        weekly_value.hidden = YES;
        
        weekly_lbl.hidden = YES;
        
        weekly_lbl.frame = totalPayable_lbl.frame;
        
        weekly_value.frame = totalPayable_value.frame;
    }
    
    frame = educatorTermsHeading.frame;
    
    if (weekly_value.frame.size.height <weekly_lbl.frame.size.height) {
        
        frame.origin.y = weekly_lbl.frame.origin.y + weekly_lbl.frame.size.height +15;
    }
    else{
        
        frame.origin.y = weekly_value.frame.origin.y + weekly_value.frame.size.height +15;
    }
    
    educatorTermsHeading.frame = frame;
    
    frame = enrollment_lbl.frame;
    
    frame.origin.y = educatorTermsHeading.frame.origin.y + educatorTermsHeading.frame.size.height + 5;
    
    enrollment_lbl.frame = frame;
    
    [enrollment_lbl sizeToFit];
    
    frame = enrollment_value.frame;
    
    frame.origin.y = educatorTermsHeading.frame.origin.y + educatorTermsHeading.frame.size.height + 5;
    
    enrollment_value.frame = frame;
    
    [enrollment_value sizeToFit];
    
    frame = minimumPayment_lbl.frame;
    
    if (enrollment_value.frame.size.height <enrollment_lbl.frame.size.height) {
        
        frame.origin.y = enrollment_lbl.frame.origin.y + enrollment_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = enrollment_value.frame.origin.y + enrollment_value.frame.size.height +5;
    }
    
    minimumPayment_lbl.frame = frame;
    
    [minimumPayment_lbl sizeToFit];
    
    frame = minimumpymnt_value.frame;
    
    frame.origin.y = minimumPayment_lbl.frame.origin.y;
    
    minimumpymnt_value.frame = frame;
    
    [minimumpymnt_value sizeToFit];
    
    frame = paymentDeadline_lbl.frame;
    
    if (minimumpymnt_value.frame.size.height <minimumPayment_lbl.frame.size.height) {
        
        frame.origin.y = minimumPayment_lbl.frame.origin.y + minimumPayment_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = minimumpymnt_value.frame.origin.y + minimumpymnt_value.frame.size.height +5;
    }
    
    paymentDeadline_lbl.frame = frame;
    
    [paymentDeadline_lbl sizeToFit];
    
    frame = paymentdeadline_value.frame;
    
    frame.origin.y = paymentDeadline_lbl.frame.origin.y;
    
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
    
    frame.origin.y = deposite_lbl.frame.origin.y ;
    
    deposite_value.frame = frame;
    
    [deposite_value sizeToFit];
    
    frame = cancellation_lbl.frame;
    
    if (deposite_value.frame.size.height <deposite_lbl.frame.size.height) {
        
        frame.origin.y = deposite_lbl.frame.origin.y + deposite_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = deposite_value.frame.origin.y + deposite_value.frame.size.height +5;
    }
    
    cancellation_lbl.frame = frame;
    
    [cancellation_lbl sizeToFit];
    
    frame = cancellation_value.frame;
    
    frame.origin.y = cancellation_lbl.frame.origin.y ;
    
    cancellation_value.frame = frame;
    
    [cancellation_value sizeToFit];
    
    frame = refund_lbl.frame;
    
    if (cancellation_value.frame.size.height <cancellation_lbl.frame.size.height) {
        
        frame.origin.y = cancellation_lbl.frame.origin.y + cancellation_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = cancellation_value.frame.origin.y + cancellation_value.frame.size.height +5;
    }
    
    refund_lbl.frame = frame;
    
    [refund_lbl sizeToFit];
    
    frame = refund_value.frame;
    
    frame.origin.y = refund_lbl.frame.origin.y;
    
    refund_value.frame = frame;
    
    [refund_value sizeToFit];
    
    frame = makeupEvent_lbl.frame;
    
    if (refund_value.frame.size.height <refund_lbl.frame.size.height) {
        
        frame.origin.y = refund_lbl.frame.origin.y + refund_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = refund_value.frame.origin.y + refund_value.frame.size.height +5;
    }
    
    makeupEvent_lbl.frame = frame;
    
    [makeupEvent_lbl sizeToFit];
    
    frame = makeupEvant_value.frame;
    
    frame.origin.y = makeupEvent_lbl.frame.origin.y ;
    
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
    
    frame = codeofConductHeading.frame;
    
    if (severeWeather_value.frame.size.height <severeWeather_lbl.frame.size.height) {
        
        frame.origin.y = severeWeather_lbl.frame.origin.y + severeWeather_lbl.frame.size.height +10;
    }
    else{
        
        frame.origin.y = severeWeather_value.frame.origin.y + severeWeather_value.frame.size.height +10;
    }
    
    codeofConductHeading.frame = frame;
    
    frame = codeOfConduct_value.frame;
    
    frame.origin.y = codeofConductHeading.frame.origin.y + codeofConductHeading.frame.size.height + 5;
    
    frame.size.height = [self heightCalculate:codeOfConduct_value.text :codeOfConduct_value];
    
    codeOfConduct_value.frame = frame;
    
    frame = continueBtn.frame;
    
    frame.origin.y = codeOfConduct_value.frame.origin.y + codeOfConduct_value.frame.size.height + 50;
    
    continueBtn.frame = frame;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, continueBtn.frame.origin.y + continueBtn.frame.size.height + 50);
    
    
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

#pragma mark - UITableView Delegates & Datasourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return terms_condArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell_identifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor lightTextColor];
    
    [cell.textLabel setNumberOfLines:4];
    
    cell.textLabel.text = [terms_condArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapContinue:(id)sender {
    
    //confirm_enrollment
    //type = 1, member_id, person_id, session_id, book_materials_charges, currency_book_materials, security_charges, currency_security, other_charges, currency_other, total_charges
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"dd MMM yyyy"];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSMutableArray *dateArray = [[NSMutableArray alloc]init];
    
    for (int i =0; i<selectedDatesArray.count; i++ ) {
        
       NSDate * date = [formatter dateFromString:[selectedDatesArray objectAtIndex:i]];
        
        NSString *datestr = [NSString stringWithFormat:@"%@",date];
        
        NSString *datesubstring = [[datestr componentsSeparatedByString:@" "]objectAtIndex:0];
        
        [dateArray addObject:datesubstring];
        
        
    }
    
    
    [self.view addSubview:indicator];
    
    NSString *feesStr = [[totalPayable_value.text componentsSeparatedByString:@" "]objectAtIndex:1];
    
    feesStr = [feesStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"$ "]];
    
    NSMutableDictionary *paramURL = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *key = [[NSMutableArray alloc]init];
    
    NSMutableArray *valueAray = [[NSMutableArray alloc]init];
    
    if (isContinues) {
        
        NSString *pick_value = [dateArray objectAtIndex:0];
        
        [dateArray removeObjectAtIndex:0];
        
        for (int i = 0; i<dateArray.count; i++) {
            
            [key addObject:[NSString stringWithFormat:@"lesson_dates[%d]",i]];
            
        }
        
        [valueAray addObjectsFromArray:dateArray];
        
        [key addObject:@"type"];
        
        [key addObject:@"member_id"];
        
        [key addObject:@"person_id"];
        
        [key addObject:@"session_id"];
        
        [key addObject:@"book_materials_charges"];
        
        [key addObject:@"currency_book_materials"];
        
        [key addObject:@"security_charges"];
        
        [key addObject:@"currency_security"];
        
        [key addObject:@"other_charges"];
        
        [key addObject:@"currency_other"];
        
        [key addObject:@"total_charges"];
        
        [key addObject:@"master_id"];
        
        [key addObject:@"lesson_id"];
        
        [key addObject:@"lesson_timing_id"];
        
        [key addObject:@"pick_value"];
        
        [key addObject:@"prefer_location"];
        
        [key addObject:@"enrollment_id"];
        
        [valueAray addObject:@"3"];
        
        [valueAray addObject:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]];
        
        [valueAray addObject:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Family"] valueForKey:@"id"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"id"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_books_materials"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"b_m_currency"] valueForKey:@"id"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_security"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"security_currency"] valueForKey:@"id"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]   valueForKey:@"lesson_info"] valueForKey:@"other_currency"] valueForKey:@"name"]];
        
        [valueAray addObject:feesStr];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"member_id"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"id"]];
        
        [valueAray addObject:lesson_timing_id];
        
        [valueAray addObject:pick_value];
        
        [valueAray addObject:@""];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"Enrollment"] valueForKey:@"id"]];
        
        
        paramURL = [NSMutableDictionary dictionaryWithObjects:valueAray forKeys:key];
        
//        paramURL = @{@"type":@"3", @"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"person_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Family"] valueForKey:@"id"], @"session_id":[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"id"], @"book_materials_charges":[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_books_materials"], @"currency_book_materials":[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"b_m_currency"] valueForKey:@"id"], @"security_charges":[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_security"], @"currency_security":[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"security_currency"] valueForKey:@"id"], @"other_charges":[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges"], @"currency_other":[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]   valueForKey:@"lesson_info"] valueForKey:@"other_currency"] valueForKey:@"name"], @"total_charges":feesStr, @"master_id":[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"member_id"], @"lesson_id": [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"id"], @"lesson_timing_id":lesson_timing_id,@"lesson_dates":dateArray,@"pick_value":pick_value};
        
    }
    else{
        
        for (int i = 0; i<dateArray.count; i++) {
            
            [key addObject:[NSString stringWithFormat:@"lesson_dates[%d]",i]];
            
        }
        
        [valueAray addObjectsFromArray:dateArray];
        
        [key addObject:@"type"];
        
        [key addObject:@"member_id"];
        
        [key addObject:@"person_id"];
        
        [key addObject:@"session_id"];
        
        [key addObject:@"book_materials_charges"];
        
        [key addObject:@"currency_book_materials"];
        
        [key addObject:@"security_charges"];
        
        [key addObject:@"currency_security"];
        
        [key addObject:@"other_charges"];
        
        [key addObject:@"currency_other"];
        
        [key addObject:@"total_charges"];
        
        [key addObject:@"master_id"];
        
        [key addObject:@"lesson_id"];
        
        [key addObject:@"lesson_timing_id"];
        
        [key addObject:@"prefer_location"];
        
        [key addObject:@"enrollment_id"];
        
        [valueAray addObject:@"3"];
        
        [valueAray addObject:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]];
        
        [valueAray addObject:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"enroll_details"] valueForKey:@"Family"] valueForKey:@"id"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"id"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_books_materials"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"b_m_currency"] valueForKey:@"id"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_security"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"security_currency"] valueForKey:@"id"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]   valueForKey:@"lesson_info"] valueForKey:@"other_currency"] valueForKey:@"name"]];
        
        [valueAray addObject:feesStr];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"member_id"]];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"id"]];
        
        [valueAray addObject:lesson_timing_id];
        
        [valueAray addObject:@""];
        
        [valueAray addObject:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"Enrollment"] valueForKey:@"id"]];
        
        
        paramURL = [NSMutableDictionary dictionaryWithObjects:valueAray forKeys:key];
        
    }
    
    
    NSLog(@"%@", paramURL);
    
    [confiemCourseEnrollConn startConnectionWithString:@"confirm_lesson_enrollment" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([confiemCourseEnrollConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Your Enrollment Request has been sent to the Educator.\nWhat do you do now?\nWait for them to accept your enrollment. You will be notified once the enrollment is accepted. You can also check the status of your enrollment in your Dashboard. If the Course is less than 7 days away, you will need to pay the Course Fees as soon as your enrollment is accepted. Feel free to send the educator a message anytime." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                
                
                [alert show];
                
                UIStoryboard *st = self.storyboard;
                
                MyEnroll_BookingViewController *myVc = [st instantiateViewControllerWithIdentifier:@"myEnroll_booking"];
                
                [self.navigationController pushViewController:myVc animated:YES];
            }
        }
    }];
    
}



@end
