//
//  LessonEnrollmentViewController.m
//  ecaHUB
//
//  Created by promatics on 4/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "LessonEnrollmentViewController.h"
#import "DateConversion.h"
#import "Term_CondtionTable.h"
#import "Constant.h"
#import "ConfirmLessonEnrollViewController.h"

@interface LessonEnrollmentViewController () {
    
    DateConversion *dateConversion;
    
    NSMutableArray *terms_condArray;
    
    Term_CondtionTable *term_condView;
    
    BOOL tapFee1, tapFee2, tapFee3, tapAgree;
    
    NSMutableArray *timeSlotArray;
    
    NSString *lesson_timing_id;
    
    BOOL isSessionSlct;
    
    NSMutableArray *selectedDatesArray;
    
    NSMutableArray *datesArray;
    
    BOOL isotherFees, isbookFees, issecurityFees;
    
    CGRect blwSesnOptnFrame;
    
    BOOL isEnrlmnt1, isEnrlmnt2;
    
    NSInteger slectedSesnIndex;
    
    BOOL isStartDt;
    
    NSInteger isSlctSesn, isSlctDt, isCheckEnrlmnt;
    
    NSString *slctdTime;
    
    CGFloat valuelblwidth;
    
    NSInteger isCont;
    
}
@end

@implementation LessonEnrollmentViewController

@synthesize scrollView,continueBtn,studentHeading,name_lbl,dob_lbl,dob_value,name_value,GenderStd_lbl,genderStd_value,lessonDetailsHeading,lessonName_lbl,lessonName_value,educator_lbl,educator_value,session_lbl,session_value,referenceId_lbl,referenceId_value,lessonDuration_lbl,teachingMethod_lbl,teachingMethod_value,language_lbl,language_value,gender_lbl,gender_value,ageGroup_lbl,ageGroup_value,selectedTimeSlot_value,selectedTimeSlot_lbl,location_lbl,location_value,lessonFee_lbl,lessonFee_value,lessonFeeHeading,otherFees,otherFees_value,otherFeesHeading,educatorTermsHeading,paymentDeadline_lbl,paymentdeadline_value,changesEnroll_lbl,changesEnroll_value,cancellation_lbl,cancellation_value,makeupEvant_value,makeupEvent_lbl,severeWeather_lbl,severeWeather_value,refund_lbl,refund_value,security_lbl,security_value,securityBtn,selectSsnoptnBtn,sessionOptionsHeading,book_lbl,bookBtn,bookMaterial_value,if_subLbl,location_txtfld,enrollment_lbl,enrollment_value,minimumPayment_lbl,minimumpymnt_value,deposite_lbl,deposite_value,lessonDuration_value,preferedLocationHeading,otherFeesBtn,preferred_startDateview,enrlmntOptn2,enrlmtOptn1,enrollmentOptn_view,startDtBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    self.title =@"Enrollment";
    
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 16750);
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1070);
    }
    
    terms_condArray = [[NSMutableArray alloc] init];
    
    dateConversion = [DateConversion dateConversionManager];
    
    selectedDatesArray = [[NSMutableArray alloc]init];
    
    changesEnroll_lbl.hidden = YES;
    
    changesEnroll_value.hidden = YES;
    
    preferred_startDateview.hidden = YES;
    
    enrollmentOptn_view.hidden = YES;
    
    isotherFees = NO;
    
    issecurityFees = NO;
    
    isbookFees = NO;
    
    isSlctDt = 0;
    
    isSlctSesn = 0;
    
    isCheckEnrlmnt = 0;
    
    valuelblwidth = selectedTimeSlot_value.frame.size.width;
    
    timeSlotArray = [[NSMutableArray alloc] init];
    
    bookBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    bookBtn.layer.borderWidth = 1.f;
    
    bookBtn.layer.cornerRadius = 5;
    
    securityBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    securityBtn.layer.borderWidth = 1.f;
    
    securityBtn.layer.cornerRadius = 5;
    
    otherFeesBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    otherFeesBtn.layer.borderWidth = 1.f;
    
    otherFeesBtn.layer.cornerRadius = 5;
    
    continueBtn.layer.cornerRadius = 5;
    
    selectSsnoptnBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    selectSsnoptnBtn.layer.borderWidth = 1.f;
    
    selectSsnoptnBtn.layer.cornerRadius = 5;
    
    [selectSsnoptnBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    enrlmtOptn1.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    enrlmtOptn1.layer.borderWidth = 1.f;
    
    enrlmtOptn1.layer.cornerRadius = 5;
    
    enrlmntOptn2.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    enrlmntOptn2.layer.borderWidth = 1.f;
    
    enrlmntOptn2.layer.cornerRadius = 5;
    
    startDtBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    startDtBtn.layer.borderWidth = 1.f;
    
    startDtBtn.layer.cornerRadius = 5;
    
    [startDtBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
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
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]);
    
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
        
        city = [city stringByAppendingString:blankSpace];
    }
    
    if([[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"]valueForKey:@"LessonListing"] valueForKey:@"type"]isEqualToString:@"1"]){
        
        location_value.text = [@"Online, "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"]valueForKey:@"City"]valueForKey:@"city_name"]];
    }
    else{
        
        location_value.text = [[[[streetno stringByAppendingString:district]stringByAppendingString:city]stringByAppendingString:state]stringByAppendingString:country];
        
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
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]);
    
    NSString *course_fees = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"LessonSession"] valueForKey:@"fee_quantity"];
    
    NSString *currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"course_session"] valueForKey:@"Currency"] valueForKey:@"name"];
    
    course_fees = [currency stringByAppendingString:[NSString stringWithFormat:@" %@",course_fees]];
    
    lessonFee_value.text = course_fees;
       
    NSString *str1 = @"";
    
    NSString *str2 = @" (Tick if a first time enrollment)";
    //SGD $50 (Tick if a first time enrollment)
    
    NSString *bookfeeStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_books_materials"];
    
    NSString *currencyStr;
    
    if (![bookfeeStr isEqualToString:@""]&& ![bookfeeStr isEqualToString:@"0.00"]) {
        
        
        currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"b_m_currency"] valueForKey:@"name"];
        
        str1 = [str1 stringByAppendingString:currencyStr];
        
        str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %@",bookfeeStr]];
        
        str1 = [str1 stringByAppendingString:str2];
        
        bookMaterial_value.text = str1;
        
    }
    
    
    
    str1 = @"";
    
    NSString *securityFees = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_security"];
    
    if (![securityFees isEqualToString:@""] && ![securityFees isEqualToString:@"0.00"]) {
        
        currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"security_currency"] valueForKey:@"name"];
        
        str1 = [str1 stringByAppendingString:currencyStr];
        
        str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %@",securityFees]];
        
        str1 = [str1 stringByAppendingString:str2];
        
        security_value.text= str1;
        
    }
    
    str1 = @"";
    
    NSString *otherFeesStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges"];
    
    if (![otherFeesStr isEqualToString:@""] && ![otherFeesStr isEqualToString:@"0.00"]) {
        
        currencyStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]   valueForKey:@"lesson_info"] valueForKey:@"other_currency"] valueForKey:@"name"];
        
        str1 = [str1 stringByAppendingString:currencyStr];
        
        str1 = [str1 stringByAppendingString:[NSString stringWithFormat:@" %@",otherFeesStr]];
        
        str1 = [str1 stringByAppendingString:str2];
        
        otherFees_value.text = str1;
        
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
    
    selectedTimeSlot_value.text = [selectedDatesArray componentsJoinedByString:@"\n"];
    
    [name_lbl sizeToFit];
    
    CGRect frame = name_value.frame;
    
    frame.origin.y = name_lbl.frame.origin.y;
    
    name_value.frame = frame;
    
    [name_value sizeToFit];
    
    if (ageyears<=18) {
        
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
        
        dob_lbl.hidden = YES;
        
        dob_value.hidden = YES;
        
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
    
    frame = lessonFeeHeading.frame;
    
    if (location_value.frame.size.height <location_lbl.frame.size.height) {
        
        frame.origin.y = location_lbl.frame.origin.y + location_lbl.frame.size.height +10;
    }
    else{
        
        frame.origin.y = location_value.frame.origin.y + location_value.frame.size.height +10;
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
    
    frame = sessionOptionsHeading.frame;
    
    if (lessonFee_value.frame.size.height <lessonFee_lbl.frame.size.height) {
        
        frame.origin.y = lessonFee_lbl.frame.origin.y + lessonFee_lbl.frame.size.height +5;
    }
    else{
        
        frame.origin.y = lessonFee_value.frame.origin.y + lessonFee_value.frame.size.height +5;
    }
    
    sessionOptionsHeading.frame = frame;
    
    frame = selectSsnoptnBtn.frame;
    
    frame.origin.y = sessionOptionsHeading.frame.origin.y + sessionOptionsHeading.frame.size.height + 5;
    
    selectSsnoptnBtn.frame = frame;
    
    blwSesnOptnFrame = frame;
    
    [self belowSesnOptionSetFrame];
    
    
}

-(void)belowSesnOptionSetFrame{
    
    NSString *bookfeeStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_books_materials"];
    
    NSString *otherFeesStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges"];
    
    NSString *securityFees = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_security"];
    
    
    CGRect frame = selectedTimeSlot_lbl.frame;
    
    frame.origin.y = blwSesnOptnFrame.origin.y + blwSesnOptnFrame.size.height + 5;
    
    selectedTimeSlot_lbl.frame = frame;
    
    [selectedTimeSlot_lbl sizeToFit];
    
    selectedTimeSlot_lbl.text = @"Selected Lesson Dates";
    
    frame = selectedTimeSlot_value.frame;
    
    frame.size.width = valuelblwidth;
    
    frame.origin.y = blwSesnOptnFrame.origin.y + blwSesnOptnFrame.size.height + 5;
    
    selectedTimeSlot_value.frame = frame;
    
    [selectedTimeSlot_value sizeToFit];
    
    frame = preferedLocationHeading.frame;
    
    if (selectedTimeSlot_value.frame.size.height <selectedTimeSlot_lbl.frame.size.height) {
        
        frame.origin.y = selectedTimeSlot_lbl.frame.origin.y + selectedTimeSlot_lbl.frame.size.height +10;
    }
    else{
        
        frame.origin.y = selectedTimeSlot_value.frame.origin.y + selectedTimeSlot_value.frame.size.height +10;
    }
    
    preferedLocationHeading.frame = frame;
    
    [preferedLocationHeading sizeToFit];
    
    frame = location_txtfld.frame;
    
    frame.origin.y = preferedLocationHeading.frame.origin.y + preferedLocationHeading.frame.size.height + 5;
    
    location_txtfld.frame = frame;
    
    frame = if_subLbl.frame;
    
    frame.origin.y = location_txtfld.frame.origin.y + location_txtfld.frame.size.height + 5;
    
    if_subLbl.frame = frame;
    
    if ((![otherFeesStr isEqualToString:@""] && ![otherFeesStr isEqualToString:@"0.00"]) || (![bookfeeStr isEqualToString:@""] && ![bookfeeStr isEqualToString:@"0.00"]) || (![securityFees isEqualToString:@""] && ![securityFees isEqualToString:@"0.00"])) {
        
        frame = otherFeesHeading.frame;
        
        frame.origin.y = if_subLbl.frame.origin.y + if_subLbl.frame.size.height +10;
       
        otherFeesHeading.frame = frame;
    }
    
    else{
        
        otherFeesHeading.frame = if_subLbl.frame;
        
        otherFeesHeading.hidden = YES;
        
    }
    
    if (![bookfeeStr isEqualToString:@""] && ![bookfeeStr isEqualToString:@"0.00"]) {
        
        frame = book_lbl.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height + 5;
        
        book_lbl.frame = frame;
        
        [book_lbl sizeToFit];
        
        frame = bookBtn.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height + 5;
        
        bookBtn.frame = frame;
        
        frame = bookMaterial_value.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y + otherFeesHeading.frame.size.height + 5;
        
        bookMaterial_value.frame = frame;
        
        [bookMaterial_value sizeToFit];
        
        
    }
    else{
        
        frame = book_lbl.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y ;
        
        book_lbl.frame = frame;
        
        [book_lbl sizeToFit];
        
        frame = bookBtn.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y ;
        
        bookBtn.frame = frame;
        
        frame = bookMaterial_value.frame;
        
        frame.origin.y = otherFeesHeading.frame.origin.y ;
        
        bookMaterial_value.frame = frame;
        
        [bookMaterial_value sizeToFit];
        
        bookBtn.hidden = YES;
        
        bookMaterial_value.hidden = YES;
        
        book_lbl.hidden = YES;
        
    }
    
    if (![securityFees isEqualToString:@""] && ![securityFees isEqualToString:@"0.00"]) {
        
        frame = securityBtn.frame;
        
        if (bookMaterial_value.frame.size.height <book_lbl.frame.size.height) {
            
            frame.origin.y = book_lbl.frame.origin.y + book_lbl.frame.size.height +5;
        }
        else{
            
            frame.origin.y = bookMaterial_value.frame.origin.y + bookMaterial_value.frame.size.height +5;
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
        
        frame.origin.y = security_lbl.frame.origin.y ;
        
        security_value.frame = frame;
        
        [security_value sizeToFit];
        
    }
    
    else{
        
        frame = securityBtn.frame;
                    
        frame.origin.y = book_lbl.frame.origin.y ;
            
        securityBtn.frame = frame;
        
//        frame = security_lbl.frame;
//        
//        if (bookMaterial_value.frame.size.height <book_lbl.frame.size.height) {
//            
//            frame.origin.y = book_lbl.frame.origin.y ;
//            
//            frame.size.height = book_lbl.frame.size.height;
//        }
//        else{
//            
//            frame.origin.y = bookMaterial_value.frame.origin.y ;
//            
//            frame.size.height = bookMaterial_value.frame.size.height;
//        }
        
        security_lbl.frame = book_lbl.frame;
        
        [security_lbl sizeToFit];
        
//        frame = security_value.frame;
//        
//        frame.origin.y = security_lbl.frame.origin.y ;
        
        security_value.frame = bookMaterial_value.frame;
        
        [security_value sizeToFit];
        
        securityBtn.hidden = YES;
        
        security_value.hidden = YES;
        
        security_lbl.hidden =YES;
        
    }
    
    if (![otherFeesStr isEqualToString:@""] && ![otherFeesStr isEqualToString:@"0.00"]) {
        
        frame = otherFeesBtn.frame;
        
        if (security_value.frame.size.height <security_lbl.frame.size.height) {
            
            frame.origin.y = security_lbl.frame.origin.y + security_lbl.frame.size.height +5;
        }
        else{
            
            frame.origin.y = security_value.frame.origin.y + security_value.frame.size.height +5;
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
        
        frame.origin.y = otherFees.frame.origin.y ;
        
        otherFees_value.frame = frame;
        
        [otherFees_value sizeToFit];
        
    }
    
    else{
        
        frame = otherFeesBtn.frame;
        
        frame.origin.y = security_lbl.frame.origin.y ;
       
        otherFeesBtn.frame = frame;
        
//        frame = otherFees.frame;
//        
//        if (security_value.frame.size.height <security_lbl.frame.size.height) {
//            
//            frame.origin.y = security_lbl.frame.origin.y ;
//            
//            frame.size.height = security_lbl.frame.size.height;
//        }
//        else{
//            
//            frame.origin.y = security_value.frame.origin.y ;
//            
//            frame.size.height = security_value.frame.size.height;
//        }
        
        otherFees.frame = security_lbl.frame;
        
        [otherFees sizeToFit];
        
//        frame = otherFees_value.frame;
        
//        if (security_value.frame.size.height <security_lbl.frame.size.height) {
//            
//            frame.origin.y = security_lbl.frame.origin.y ;
//            
//            frame.size.height = security_lbl.frame.size.height;
//        }
//        else{
//            
//            frame.origin.y = security_value.frame.origin.y ;
//            
//            frame.size.height = security_value.frame.size.height;
//        }
        
        otherFees_value.frame = security_value.frame;
        
        [otherFees_value sizeToFit];
        
        otherFees.hidden = YES;
        
        otherFees_value.hidden = YES;
        
        otherFeesBtn.hidden =YES;
        
    }
    
    frame = educatorTermsHeading.frame;
    
    if (otherFees_value.frame.size.height <otherFees.frame.size.height) {
        
        frame.origin.y = otherFees.frame.origin.y + otherFees.frame.size.height +15;
    }
    else{
        
        frame.origin.y = otherFees_value.frame.origin.y + otherFees_value.frame.size.height +15;
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
    
    frame = continueBtn.frame;
    
    if (severeWeather_value.frame.size.height <severeWeather_lbl.frame.size.height) {
        
        frame.origin.y = severeWeather_lbl.frame.origin.y + severeWeather_lbl.frame.size.height +50;
    }
    else{
        
        frame.origin.y = severeWeather_value.frame.origin.y + severeWeather_value.frame.size.height +50;
    }
    
    continueBtn.frame = frame;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, continueBtn.frame.origin.y + continueBtn.frame.size.height + 50);
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqual:@"viewEnrollDetailLesson"]) {
        
        ConfirmLessonEnrollViewController *confirmCE = [segue destinationViewController];
        
        confirmCE.selectedDatesArray = [selectedDatesArray mutableCopy];
        
        confirmCE.isbook = isbookFees;
        
        confirmCE.issecurity = issecurityFees;
        
        confirmCE.isother = isotherFees;
        
        confirmCE.slctdTimeSlot = slctdTime;
        
        confirmCE.isconticase = isCont;
        
        
    }
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (isSessionSlct) {
        
        slectedSesnIndex = index;
        
        [selectSsnoptnBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        isSlctSesn = 1;
        
        [self setData];
        
        NSString *name = [[timeSlotArray objectAtIndex:index] valueForKey:@"name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [selectSsnoptnBtn setTitle:name forState:UIControlStateNormal];
        
        slctdTime = name;
        
        NSString *stDate = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"] valueForKey:@"start_date"];
        
        //NSString *fiDate = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"] valueForKey:@"finish_date"];
        
        NSString *fiDate = @"";
        
        NSString *enrollment_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"Enrollment"] valueForKey:@"id"];
        
        if (([fiDate isEqualToString:@""] || fiDate==nil) && [enrollment_id isEqual:@"4"]) {
            
            enrollmentOptn_view.hidden = YES;
            
            preferred_startDateview.hidden = NO;
            
            CGRect frame = preferred_startDateview.frame;
            
            frame.origin.y = selectSsnoptnBtn.frame.origin.y + selectSsnoptnBtn.frame.size.height + 5;
            
            preferred_startDateview.frame = frame;
            
            blwSesnOptnFrame = frame;
            
            [self belowSesnOptionSetFrame];
            
        }
        else if (([fiDate isEqualToString:@""] || fiDate==nil) && ![enrollment_id isEqual:@"4"]){
            
            enrollmentOptn_view.hidden = NO;
            
            preferred_startDateview.hidden = YES;
            
            CGRect frame = enrollmentOptn_view.frame;
            
            frame.origin.y = selectedTimeSlot_lbl.frame.origin.y ;
            
            enrollmentOptn_view.frame = frame;
            
            blwSesnOptnFrame = frame;
            
            [self belowSesnOptionSetFrame];
            
            
            
        }
        else{
            
            if ([enrollment_id isEqual:@"4"]) {
                
                preferred_startDateview.hidden = NO;
                
                CGRect frame = preferred_startDateview.frame;
                
                frame.origin.y = selectSsnoptnBtn.frame.origin.y + selectSsnoptnBtn.frame.size.height + 5;
                
                frame = preferred_startDateview.frame;
                
                blwSesnOptnFrame = frame;
                
                [self belowSesnOptionSetFrame];
                
                
            }
            else{
                
                
                preferred_startDateview.hidden = YES;
                
                enrollmentOptn_view.hidden = YES;
                
                [self belowSesnOptionSetFrame];
                
                [self show_avilLesson_dates:index :NO];
                
                
            }
                        
        }
        
        // NSString *selectedDay = [name componentsSeparatedByString:@"("];
        
    }
    
    else{
        
        isSlctDt = 1;
        
        isCont = 1;
        
        [startDtBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        NSString *name = [datesArray objectAtIndex:index];
        
        [startDtBtn setTitle:name forState:UIControlStateNormal];
        
        for(int i =0; i<datesArray.count;i++){
            
            if([name isEqualToString:[datesArray objectAtIndex:i]]){
                
                selectedDatesArray = [[NSMutableArray alloc]init];
                
                [self dataafterStartDate:i];
                
                break;
                
                
            }
            
        }
        
        
    }
    
}

-(void)dataafterStartDate:(NSInteger)index{
    
    for(int i =index; i<datesArray.count;i++){
        
        [selectedDatesArray addObject:[datesArray objectAtIndex:i]];
        
        selectedTimeSlot_value.text = [selectedDatesArray componentsJoinedByString:@"\n"];
        
    }
    
    [self belowSesnOptionSetFrame];
    
    
}

-(void)show_avilLesson_dates:(NSInteger)index :(BOOL)isStartDate{
    
    NSString *name = [[timeSlotArray objectAtIndex:index] valueForKey:@"name"];
    name = [@"  " stringByAppendingString:name];
    
    NSString *selectedDay = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSRange range = [selectedDay rangeOfString:@" "];
    
    selectedDay = [selectedDay substringToIndex:range.location];
    
    NSArray *dayArray;
    
    if ([selectedDay isEqualToString:@"Saturday"]) {
        
        dayArray = @[@"1"];
    }
    else if ([selectedDay isEqualToString:@"Sunday"]){
        
        dayArray = @[@"2"];
    }
    else if ([selectedDay isEqualToString:@"Monday"]){
        
        dayArray = @[@"3"];
    }
    else if ([selectedDay isEqualToString:@"Tuesday"]){
        
        dayArray = @[@"4"];
    }
    else if ([selectedDay isEqualToString:@"Wednesday"]){
        
        dayArray = @[@"5"];
    }
    else if ([selectedDay isEqualToString:@"Thursday"]){
        
        dayArray = @[@"6"];
    }
    else if ([selectedDay isEqualToString:@"Friday"]){
        
        dayArray = @[@"7"];
    }
    
    lesson_timing_id = [[timeSlotArray objectAtIndex:index] valueForKey:@"id"];
    
    NSDictionary *dict = @{@"id":lesson_timing_id, @"name":name};
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"TimeSlot"];
    
    dayArray = [self specificdaysInCalendar:dayArray];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    datesArray = [[NSMutableArray alloc]init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (int i=0; i<dayArray.count; i++) {
        
        NSString *datestr = [inputFormatter stringFromDate:[dayArray objectAtIndex:i]];
        
        datestr = [dateConversion convertDate:datestr];
        
        [datesArray addObject:datestr];
    }
    
    isSessionSlct = NO;
    
    if (!isStartDate) {
        
        [self showListData:datesArray allowMultipleSelection:YES selectedData:[selectedDay componentsSeparatedByString:@", "] title:@"Available Lesson Dates"];
        
    }
    else{
        
        [self showListData:datesArray allowMultipleSelection:NO selectedData:[selectedDay componentsSeparatedByString:@", "] title:@"Select Start Date"];
    }
    
    
    
}

-(void)didSaveItems:(NSArray*)items indexs:(NSArray *)indexs{
    
    isCont = 0;
    
    selectedDatesArray = [[NSMutableArray alloc]init];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (NSIndexPath *indexPath in indexs) {
        
        NSLog(@"IndexPath:%ld",(long)indexPath.row);
        
        if (indexs.count > datesArray.count) {
            
            if (indexPath.row < datesArray.count) {
                
                [selectedDatesArray addObject:datesArray[indexPath.row]];
                
            }
            
        } else {
            
            NSLog(@"%ld",(long)indexPath.row);
            
            [selectedDatesArray addObject:datesArray[indexPath.row-1]];
            
            
        }
        
    }
    
    selectedTimeSlot_value.text = [selectedDatesArray componentsJoinedByString:@"\n"];
    
    [self belowSesnOptionSetFrame];
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


-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
//
//
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


-(NSArray*)specificdaysInCalendar:(NSArray*)holidays   {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    //NSDate *start = [inputFormatter dateFromString:@"2015-09-05"];
    
    // NSDate *end = [NSDate date];
    
    NSString *stDate = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"] valueForKey:@"start_date"];
    
    NSString *fiDate = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"] valueForKey:@"finish_date"];
    
    NSDate *newDate1;
    
    if ([fiDate isEqualToString:@""]) {
        
        NSDate *now = [inputFormatter dateFromString:stDate];
        
        int daysToAdd = 91;
        
        newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    }
    
    //if you want saturdays, thn you have to pass 7 in the holidays array
    NSDate *startdate = [inputFormatter dateFromString:stDate];
    
    NSDate *endDate ;
    
    if ([fiDate isEqualToString:@""]) {
        
        endDate  = newDate1;
        
    }
    else{
        
        endDate = [inputFormatter dateFromString:fiDate];
        
    }
    
    NSDateComponents *dayDifference = [[NSDateComponents alloc] init];
    
    NSMutableArray *dates = [[NSMutableArray alloc] init] ;
    
    NSUInteger dayOffset = 1;
    
    NSDate *nextDate = startdate;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    
    do {
        NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:nextDate];
        int weekday = [comps weekday];
        //NSLog(@"%i,%@",weekday,nextDate);
        if ([holidays containsObject:[NSString stringWithFormat:@"%i",weekday]]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            
            dateFormatter.dateFormat = @"dd/MM/yyyy";
            
            NSString *dateString = [dateFormatter stringFromDate:nextDate];
            NSDate *outDate = [dateFormatter dateFromString:dateString];
            //NSLog(@"%@,%@,%@",nextDate,dateString,outDate);
            [dates addObject:outDate];
        }
        
        
        [dayDifference setDay:dayOffset++];
        NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:dayDifference toDate:startdate options:0];
        
        nextDate = d;
    } while([nextDate compare:endDate] == NSOrderedAscending);
    
    return dates;
    
}


- (IBAction)tapContinueBtn:(id)sender {
    
    NSString *message;
    
    if (selectSsnoptnBtn.hidden == NO) {
        
        if (isSlctSesn ==0) {
            
            message = @"Please select session option.";
        }
    }
    
    
     if (message == nil && preferred_startDateview.hidden == NO){
        
        if (isSlctDt ==0) {
            
            message = @"Please select start date.";
        }
        
    }
    
    if (message == nil && enrollmentOptn_view.hidden == NO){
        
        if (isCheckEnrlmnt ==0) {
            
            message = @"Please select enrollment option.";
        }
        
    }
    
    if ([message length]>0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
    else{
        
        NSInteger totalAvilLesson = datesArray.count;
        
        NSInteger selectedLesson = selectedDatesArray.count;
        
        NSString *enrollment_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"Enrollment"] valueForKey:@"id"];
        
        NSInteger minLesson;
        
        minLesson = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"Enrollment"] valueForKey:@"id"] integerValue] + 1;
        
        if (totalAvilLesson >= minLesson &&  selectedLesson < minLesson && isCont == 0) {
            
            message = [[@"The educator has specified a minimum number of"stringByAppendingString:[NSString stringWithFormat:@" %d ",minLesson]]stringByAppendingString:@"lessons. Please check that you have selected accordingly."];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
        else{
        
        if ([enrollment_id integerValue]<=4 && isCont == 0) {
            
            if(minLesson > totalAvilLesson){
                
                message = [[@"The minimum number of lessons enrollment is "stringByAppendingString:[NSString stringWithFormat:@" %d lessons however there are less than",minLesson]]stringByAppendingString:[NSString stringWithFormat:@" %d lessons left. You can still request to enroll in the remaining lessons, and wait for the educator to accept your enrollment request.",minLesson]];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
               
            }
            
        }
            
                        
           [self performSegueWithIdentifier:@"viewEnrollDetailLesson" sender:self];
            
        }
        
    }
   
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



- (IBAction)tap_bookBtn:(id)sender {
    
    if (!isbookFees) {
        
        [bookBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        [bookBtn setContentMode:UIViewContentModeScaleAspectFill];
        
        isbookFees = YES;
        
    } else {
        
        [bookBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        isbookFees = NO;
    }
    
    
}

- (IBAction)tap_securityBtn:(id)sender {
    
    if (!issecurityFees) {
        
        [securityBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        [securityBtn setContentMode:UIViewContentModeScaleAspectFill];
        
        issecurityFees = YES;
        
    } else {
        
        [securityBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        issecurityFees = NO;
    }
    
}

- (IBAction)tap_otherFeesBtn:(id)sender {
    
    if (!isotherFees) {
        
        [otherFeesBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        [otherFeesBtn setContentMode:UIViewContentModeScaleAspectFill];
        
        isotherFees = YES;
        
    } else {
        
        [otherFeesBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        isotherFees = NO;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return true;
}

- (IBAction)tap_selectSlotBtn:(id)sender {
    
    isSessionSlct = YES;
    
    NSArray *sessionTime = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"] valueForKey:@"LessonTiming"];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"]);
    
    timeSlotArray = [[NSMutableArray alloc] init];
    
    for (int i =0; i<sessionTime.count; i++) {
        
        NSString *day = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"] valueForKey:@"LessonTiming"] objectAtIndex:i] valueForKey:@"day_select"];
        
        NSString *startTime = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"] valueForKey:@"LessonTiming"] objectAtIndex:i] valueForKey:@"start_time"];
        
        NSString *finishTime = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"] valueForKey:@"LessonTiming"] objectAtIndex:i] valueForKey:@"finish_time"];
        
        day = [day stringByAppendingString:@" ("];
        day = [day stringByAppendingString:startTime];
        day = [day stringByAppendingString:@"-"];
        day = [day stringByAppendingString:finishTime];
        day = [day stringByAppendingString:@")"];
        
        NSDictionary *dict = @{@"id":[[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionDetail"] valueForKey:@"sesion"] valueForKey:@"LessonTiming"] objectAtIndex:i] valueForKey:@"id"], @"name":day};
        
        [timeSlotArray addObject:dict];
    }
    
    NSString *str = selectSsnoptnBtn.titleLabel.text;
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self showListData:[timeSlotArray valueForKey:@"name"] allowMultipleSelection:NO selectedData:[str componentsSeparatedByString:@", "] title:@"Select Time Slot"];
}
- (IBAction)tap_prefddtTooltip:(id)sender {
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Select any number of lessons you would like attend. We recommend lessons are taken consecutively. Please check the ‘Enrollment’ term under the Educator	Terms & Conditions below for any minimum lesson enrollment requirements. If the available lesson date options are less than the minimum number of lessons required, please select the remaining lesson dates, and the educator will decide if lessons can still be taken." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
        [alertview show];
    
                    
}

- (IBAction)tap_EnrlmntOpnsTooltip:(id)sender {
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:Alert_title message:@"If you select Option 1, you will be enrolled continuously in future lessons automatically from the start date you select. And if you select Option 2, you will be provided with available lesson date options to select, and you will only be enrolled in these specific lessons. For this option it's recommended you select consecutive lesson dates." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertview show];
}

- (IBAction)tap_startDtBtn:(id)sender {
    
    [self show_avilLesson_dates:slectedSesnIndex :YES];
    
    
}
- (IBAction)tap_EnrlmtOptn1:(id)sender {
    
    isCheckEnrlmnt = 1;
    
    isCont = 1;
    
    isEnrlmnt1 = YES;
    
    isEnrlmnt2 = NO;
    
    [enrlmtOptn1 setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    [enrlmntOptn2 setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    preferred_startDateview.hidden = NO;
    
    CGRect frame = preferred_startDateview.frame;
    
    frame.origin.y = enrollmentOptn_view.frame.origin.y + enrollmentOptn_view.frame.size.height + 5;
    
    preferred_startDateview.frame = frame;
    
    blwSesnOptnFrame = frame;
    
    [self belowSesnOptionSetFrame];
    
    
}
- (IBAction)tap_EnrlmntOptn2:(id)sender {
    
    isCheckEnrlmnt = 1;
    
    isCont = 0;
    
    isEnrlmnt2 = YES;
    
    isEnrlmnt1 = NO;
    
    [enrlmntOptn2 setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    [enrlmtOptn1 setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    preferred_startDateview.hidden = YES;
    
    blwSesnOptnFrame = enrollmentOptn_view.frame;
    
    [self belowSesnOptionSetFrame];
    
    [self show_avilLesson_dates:slectedSesnIndex :NO];
    
    
}
@end
