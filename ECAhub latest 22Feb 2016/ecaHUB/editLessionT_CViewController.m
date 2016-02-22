//
//  editLessionT_CViewController.m
//  ecaHUB
//
//  Created by promatics on 4/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "editLessionT_CViewController.h"
#import "Validation.h"
#import "Constant.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "editLessionFeeChargesViewController.h"

@interface editLessionT_CViewController () {
    
    UIPickerView *pickerView;
    
    UIToolbar *toolBar;
    
    UIBarButtonItem *cancelButton;
    
    UIBarButtonItem *doneButton;
    
    NSArray *pickerArray;
    
    NSString *list_index;
    
    NSString *deposit_ids;
    
    NSString *servere_ids;
    
    NSString *paymentDead_id;
    
    NSString *changes_enrol_id;
    
    NSString *cancellation_id;
    
    NSString *refund_id;
    
    NSString *make_up_id;
    
    NSString *books_material_id;
    
    NSString *security_deposite_id;
    
    NSString *otherCharge_id,*currencyAcpt_id;
    
    Validation *validationObj;
    id activeField;
    
    NSString *enrollment_id, *minimum_payment_id;
    
    Indicator *indicator;
    
    WebServiceConnection *getConn;
    
    NSString *pickerValue, *pickData;
    
    NSString *data_id, *pickId;
}
@end

@implementation editLessionT_CViewController

@synthesize scrollView, paymentDeadLineBtn, depositeBtn, changeEnrollmentBtn, cancellationBtn, refundBtn, make_upLessionBtn, servere_weatherBtn, books_materialBtn, securityDepositBtn, books_materialPrice, securityPriceTxtField, saveBtn, cancelBtn, enrollmentBtn, minimumPaymentBtn, otherCharge_bttn, otherCharge_textfield,size_view,cancellation_textfield,currencyAcpt_btn,lessonData,feesCharges_btn,payment_stlbl,paymentddln_stlbl,enrolment_stlbl,refund_stlbl,severweather_stlbl,makeup_stlbl,deposit_stlbl,cancellation_stlbl,payment_textview;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //EditTerm_CondotionLession
    //editLessionFeeSegue
    
    getConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    books_materialBtn.userInteractionEnabled = NO;
    otherCharge_bttn.userInteractionEnabled = NO;
    securityDepositBtn.userInteractionEnabled = NO;
    
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    [self prepareInterface];
    
    validationObj = [Validation validationManager];
}

-(void)setframe{
    
    CGRect frame = paymentDeadLineBtn.frame;
    
    frame.origin.y = paymentddln_stlbl.frame.origin.y + paymentddln_stlbl.frame.size.height + 8;
    
    paymentDeadLineBtn.frame = frame;
    
    frame = deposit_stlbl.frame;
    
    frame.origin.y = paymentDeadLineBtn.frame.origin.y + paymentDeadLineBtn.frame.size.height + 8;
    
    deposit_stlbl.frame = frame;
    
    frame = depositeBtn.frame;
    
    frame.origin.y = deposit_stlbl.frame.origin.y + deposit_stlbl.frame.size.height + 8;
    
    depositeBtn.frame = frame;
    
    frame = cancellation_stlbl.frame;
    
    frame.origin.y = depositeBtn.frame.origin.y + depositeBtn.frame.size.height + 8;
    
    cancellation_stlbl.frame = frame;
    
    frame = cancellationBtn.frame;
    
    frame.origin.y = cancellation_stlbl.frame.origin.y + cancellation_stlbl.frame.size.height + 8;
    
    cancellationBtn.frame = frame;
    
    frame = refund_stlbl.frame;
    
    frame.origin.y = cancellationBtn.frame.origin.y + cancellationBtn.frame.size.height + 8;
    
    refund_stlbl.frame = frame;
    
    frame = refundBtn.frame;
    
    frame.origin.y = refund_stlbl.frame.origin.y + refund_stlbl.frame.size.height + 8;
    
    refundBtn.frame = frame;
    
    frame = makeup_stlbl.frame;
    
    frame.origin.y = refundBtn.frame.origin.y + refundBtn.frame.size.height + 8;
    
    makeup_stlbl.frame = frame;
    
    frame = make_upLessionBtn.frame;
    
    frame.origin.y = makeup_stlbl.frame.origin.y + makeup_stlbl.frame.size.height + 8;
    
    make_upLessionBtn.frame = frame;
    
    frame = severweather_stlbl.frame;
    
    frame.origin.y = make_upLessionBtn.frame.origin.y + make_upLessionBtn.frame.size.height + 8;
    
    severweather_stlbl.frame = frame;
    
    frame =servere_weatherBtn.frame;
    
    frame.origin.y = severweather_stlbl.frame.origin.y + severweather_stlbl.frame.size.height + 8;
    
    servere_weatherBtn.frame = frame;
    
    frame =feesCharges_btn.frame;
    
    frame.origin.y = servere_weatherBtn.frame.origin.y + servere_weatherBtn.frame.size.height + 20;
    
    feesCharges_btn.frame = frame;
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.feesCharges_btn.frame.origin.y + self.feesCharges_btn.frame.size.height+50 )];//1500
    
    
}

-(void) prepareInterface {
    
    CGRect frame = enrollmentBtn.frame;
    
    frame.origin.y = enrolment_stlbl.frame.origin.y + enrolment_stlbl.frame.size.height + 8;
    
    enrollmentBtn.frame = frame;
    
    payment_stlbl.hidden = YES;
    
    payment_textview.hidden = YES;
    
    frame = paymentddln_stlbl.frame;
    
    frame.origin.y = enrollmentBtn.frame.origin.y + enrollmentBtn.frame.size.height + 8;
    
    paymentddln_stlbl.frame = frame;
    
    [self setframe];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.feesCharges_btn.frame.origin.y + self.feesCharges_btn.frame.size.height+50)];
        
        CGRect frame = books_materialPrice.frame;
        
        frame.size.height = 45.0f;
        
        books_materialPrice.frame = frame;
        
        frame = securityPriceTxtField.frame;
        
        frame.size.height = 45.0f;
        
        securityPriceTxtField.frame = frame;
        
        frame = otherCharge_textfield.frame;
        
        frame.size.height = 45.0f;
        
        otherCharge_textfield.frame = frame;
        
        frame = cancellation_textfield.frame;
        
        frame.size.height = 45.0f;
        
        cancellation_textfield.frame = frame;
        
        feesCharges_btn.layer.cornerRadius = 7;
        
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width,self.feesCharges_btn.frame.origin.y + self.feesCharges_btn.frame.size.height+50 )];
        
        feesCharges_btn.layer.cornerRadius = 5;
    }
    
    //[self registerForKeyboardNotifications];
    
//    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
//    
//    tapScroll.cancelsTouchesInView = NO;
//    
//    [scrollView addGestureRecognizer:tapScroll];
    
    cancellation_textfield.hidden = YES;
    
    enrollmentBtn.layer.borderWidth = 1.0f;
    
    enrollmentBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    enrollmentBtn.layer.cornerRadius = 5.0f;
    
    [enrollmentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    payment_textview.layer.borderWidth = 1.0f;
    
    payment_textview.layer.borderColor = [UIColor blackColor].CGColor;
    
    payment_textview.layer.cornerRadius = 5.0f;
    
    [minimumPaymentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    paymentDeadLineBtn.layer.borderWidth = 1.0f;
    
    paymentDeadLineBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    paymentDeadLineBtn.layer.cornerRadius = 5.0f;
    
    [paymentDeadLineBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    depositeBtn.layer.borderWidth = 1.0f;
    
    depositeBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    depositeBtn.layer.cornerRadius = 5.0f;
    
    [depositeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    changeEnrollmentBtn.layer.borderWidth = 1.0f;
    
    changeEnrollmentBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    changeEnrollmentBtn.layer.cornerRadius = 5.0f;
    
    [changeEnrollmentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    cancellationBtn.layer.borderWidth = 1.0f;
    
    cancellationBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    cancellationBtn.layer.cornerRadius = 5.0f;
    
    [cancellationBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    refundBtn.layer.borderWidth = 1.0f;
    
    refundBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    refundBtn.layer.cornerRadius = 5.0f;
            
    [refundBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    make_upLessionBtn.layer.borderWidth = 1.0f;
    
    make_upLessionBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    make_upLessionBtn.layer.cornerRadius = 5.0f;
        
    [make_upLessionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    servere_weatherBtn.layer.borderWidth = 1.0f;
    
    servere_weatherBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    servere_weatherBtn.layer.cornerRadius = 5.0f;
    
    [servere_weatherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
     
    books_materialBtn.layer.borderWidth = 1.0f;
    
    books_materialBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    books_materialBtn.layer.cornerRadius = 5.0f;
    
    currencyAcpt_btn.layer.borderWidth = 1.0f;
    
    currencyAcpt_btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    currencyAcpt_btn.layer.cornerRadius = 5.0f;
    
    securityDepositBtn.layer.borderWidth = 1.0f;
    
    securityDepositBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    securityDepositBtn.layer.cornerRadius = 5.0f;
    
    otherCharge_bttn.layer.borderWidth = 1.0f;
    
    otherCharge_bttn.layer.borderColor = [UIColor blackColor].CGColor;
    
    otherCharge_bttn.layer.cornerRadius = 5.0f;
    
    books_materialPrice.layer.borderWidth = 1.0f;
    
    books_materialPrice.layer.borderColor = [UIColor blackColor].CGColor;
    
    books_materialPrice.layer.cornerRadius = 5.0f;
    
    securityPriceTxtField.layer.borderWidth = 1.0f;
    
    securityPriceTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    securityPriceTxtField.layer.cornerRadius = 5.0f;
    
    cancellation_textfield.layer.borderWidth = 1.0f;
    
    cancellation_textfield.layer.borderColor = [UIColor blackColor].CGColor;
    
    cancellation_textfield.layer.cornerRadius = 5.0f;
    
    otherCharge_textfield.layer.borderWidth = 1.0f;
    
    otherCharge_textfield.layer.borderColor = [UIColor blackColor].CGColor;
    
    otherCharge_textfield.layer.cornerRadius = 5.0f;
    
    saveBtn.layer.cornerRadius = 5.0f;
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;

//    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePickerView)];
//    
//    tapgest.cancelsTouchesInView = NO;
//    
//    [self.view addGestureRecognizer:tapgest];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]);
    
    [paymentDeadLineBtn setTitle:[@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"TermsPayment"] valueForKey:@"title"]] forState:UIControlStateNormal];
    
    [depositeBtn setTitle:[@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"TermsDeposit"] valueForKey:@"title"]] forState:UIControlStateNormal];
    
    [changeEnrollmentBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]
                                                                    valueForKey:@"TermsChange"] valueForKey:@"title"]] forState:UIControlStateNormal];
    
    [cancellationBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"TermsCancellation"] valueForKey:@"title"]] forState:UIControlStateNormal];
    
    [refundBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"TermsRefund"] valueForKey:@"title"]] forState:UIControlStateNormal];
    
    [make_upLessionBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"TermsMakeUpLesson"] valueForKey:@"title"]] forState:UIControlStateNormal];
    
    NSLog(@"%@",[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"severe_names"] valueForKey:@"TermsSevereWeather"] valueForKey:@"title"]);
    
    NSArray *severeArray = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"severe_names"] objectAtIndex:0];
    
    NSMutableArray *severe_array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < severeArray.count; i++) {
        
        [severe_array addObject:[[[severeArray objectAtIndex:i] valueForKey:@"TermsSevereWeather"] valueForKey:@"title"]];
    }
    
    NSLog(@"%@",severe_array);
    
    NSString *serverStr;
    
    if (severe_array.count == 0) {
        
        serverStr = @"";
        
    } else{
        
        serverStr = [severe_array componentsJoinedByString:@", "];
    }
    
    serverStr = [@"  " stringByAppendingString:serverStr];
    
    [servere_weatherBtn setTitle: serverStr forState:UIControlStateNormal];
    
    [currencyAcpt_btn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];

    
    [books_materialBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    NSLog(@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]);
    
    if (![[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"Enrollment"] valueForKey:@"title"]) {
        
        [enrollmentBtn setTitle: @"" forState:UIControlStateNormal];
        
    } else {
        
        [enrollmentBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"Enrollment"] valueForKey:@"title"]] forState:UIControlStateNormal];
    }
    [minimumPaymentBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"MinimumPayment"] valueForKey:@"title"]] forState:UIControlStateNormal];
    
    [securityDepositBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"security_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    [otherCharge_bttn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"other_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    
    books_materialPrice.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_books_materials"];
    
    securityPriceTxtField.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_security"];
    
    otherCharge_textfield.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges"];
    
    [self setData];
    
}

-(void) setData {
    
    paymentDead_id = [@"  "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"payment_deadline"]];
    
    deposit_ids = [@"  "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"deposit"]];
    
    changes_enrol_id = [@"  "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"change_enrollment"]];
    
    cancellation_id = [@"  "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"cancellation"]];
    
    refund_id = [@"  "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"refund"]];
    
    make_up_id = [@"  "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"make_up_lessons"]];
    
    servere_ids = [@"  "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"severe_weather"]];
    
    enrollment_id = [@"  "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"enrollment"]];
    
    if ([enrollment_id isEqual:@"0"]||[enrollment_id isEqual:@"1"]||[enrollment_id isEqual:@"2"]||[enrollment_id isEqual:@"3"]) {
        
        payment_textview.text = @"Enrolments of four (4) lessons or less will require payment of all lesson fees plus other charges such as books, materials, deposit and others is required in advance in one payment transaction. Continuous enrolment of five (5) or more lessons will require the 1st payment of ONE lesson fee plus other fees such as books, materials, deposit and others (if applicable), and the 2nd payment onwards will be charged automatically, weekly and in advance using the same payment method used on the 1st payment, and will only include one lesson fee at a time.";
        
        minimum_payment_id = @"4";
    }
    else{
        
        payment_textview.text = @"For continuous enrolments of more than four (4) lessons, the 1st payment will include ONE lesson fee plus other fees such as books, materials, deposit and others (if applicable). The 2nd payment onwards will be charged automatically, weekly and in advance using the same payment method used on the 1st payment, and will only include one lesson fee at a time. For four (4) lessons or less of continuous enrolment, payment of all lesson fees plus other fees such as books, materials, deposit and others (if applicable) is required in advance in one payment transaction.";
        
        minimum_payment_id = @"5";
        
    }
    
    // [self drawTextInRect:payment_textview.frame];
    
    payment_stlbl.hidden= NO;
    
    payment_textview.hidden = NO;
    
    payment_textview.textAlignment = NSTextAlignmentJustified;
    
    CGRect frame1 = payment_stlbl.frame;
    
    frame1.origin.y = enrollmentBtn.frame.origin.y + enrollmentBtn.frame.size.height + 8;
    
    payment_stlbl.frame = frame1;
    
    frame1 = payment_textview.frame;
    
    frame1.origin.y = payment_stlbl.frame.origin.y + payment_stlbl.frame.size.height + 8;
    
    payment_textview.frame = frame1;
    
    [payment_textview sizeToFit];
    
    frame1 = paymentddln_stlbl.frame;
    
    frame1.origin.y = payment_textview.frame.origin.y + payment_textview.frame.size.height + 8;
    
    paymentddln_stlbl.frame = frame1;
    
    frame1 = paymentDeadLineBtn.frame;
    
    frame1.origin.y = paymentddln_stlbl.frame.origin.y + paymentddln_stlbl.frame.size.height + 8;
    
    paymentDeadLineBtn.frame = frame1;
    
    [self setframe];
    
    minimum_payment_id = [@"  "stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"minimum_payment"]];
    
    currencyAcpt_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"currency"];

    
    books_material_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"currency"];
    
    security_deposite_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"currency_security"];
    
    otherCharge_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges_currency"];
    
    NSString *quantity_books_materials = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_books_materials"];
    
    //    NSString *currency_security = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"currency_security"];
    
    NSString *quantity_security = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_security"];
    
    NSDictionary *term_conData = @{@"enrollment":enrollment_id, @"minimum_payment":minimum_payment_id, @"payment_deadline":paymentDead_id, @"deposit":deposit_ids, @"change_enrollment":changes_enrol_id,@"cancellation":cancellation_id, @"refund":refund_id, @"make_up_lessons":make_up_id, @"severe_weather":servere_ids, @"currency":books_material_id, @"quantity_books_materials":quantity_books_materials, @"currency_security":security_deposite_id,@"quantity_security":quantity_security};
    
    NSLog(@"%@", term_conData);
    
    [[NSUserDefaults standardUserDefaults] setValue:term_conData forKey:@"Term_CondData"];
    
}

#pragma mark - Hide Picker View

-(void)hidePickerView {
    
    [toolBar removeFromSuperview];
    [pickerView removeFromSuperview];
}

-(void)cancelKeyboard:(UIBarButtonItem *)sender {
    
    [toolBar removeFromSuperview];
    [pickerView removeFromSuperview];
}

-(void)doneKeyboard:(UIBarButtonItem *)sender {
    
    pickerValue = pickData;
    
    data_id = pickId;
    
    switch ([list_index intValue]) {
            
        case 0:{
            
            [paymentDeadLineBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            if ([pickerValue isEqualToString:@"  Select"]) {
                
                [paymentDeadLineBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
            }
            else{
                
                [paymentDeadLineBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            
            paymentDead_id = data_id;
            
            break;
            
        }  case 1:{
            
            [depositeBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            if ([pickerValue isEqualToString:@"  Select"]) {
                
                [depositeBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
            }
            else{
                
                [depositeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            
            // deposit_ids = data_id;
            break;
            
        }  case 2:{
            
            [changeEnrollmentBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            if ([pickerValue isEqualToString:@"  Select"]) {
                
                [changeEnrollmentBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
            }
            else{
                
                [changeEnrollmentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            
            changes_enrol_id = data_id;
            
            
            
            break;
            
        }  case 3:{
            
            [cancellationBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            if ([pickerValue isEqualToString:@"  Select"]) {
                
                [cancellationBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
            }
            else{
                
                [cancellationBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            
            cancellation_id = data_id;
            
            if ([cancellation_id isEqualToString:@"3"]) {
                
                cancellation_textfield.hidden = NO;
                
               // [self sizeScrollView];
                
            }
            else{
                
                cancellation_textfield.hidden = YES;
            }
            
            
            break;
            
        }  case 4:{
            
            [refundBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            if ([pickerValue isEqualToString:@"  Select"]) {
                
                [refundBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
            }
            else{
                
                [refundBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            
            refund_id = data_id;
            break;
            
        }  case 5:{
            
            [make_upLessionBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            if ([pickerValue isEqualToString:@"  Select"]) {
                
                [make_upLessionBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
            }
            else{
                
                [make_upLessionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            
            make_up_id = data_id;
            break;
            
        }  case 6:{
            
            [servere_weatherBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            if ([pickerValue isEqualToString:@"  Select"]) {
                
                [servere_weatherBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
            }
            else{
                
                [servere_weatherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }
            
            //servere_ids = data_id;
            break;
            
        }  case 7:{
            
            [books_materialBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            books_material_id = data_id;
            
            [securityDepositBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            security_deposite_id = data_id;
            
            [otherCharge_bttn setTitle:pickerValue forState:UIControlStateNormal];
            
            otherCharge_id = data_id;
            
            break;
            
        }  case 8:{
            
            [securityDepositBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            security_deposite_id = data_id;
            break;
        }  case 9:{
            
            
            if ([pickerValue isEqualToString:@"  Select"]) {
                
                [enrollmentBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
                
                payment_stlbl.hidden= YES;
                
                payment_textview.hidden = YES;
                
                CGRect frame = paymentddln_stlbl.frame;
                
                frame.origin.y = enrollmentBtn.frame.origin.y + enrollmentBtn.frame.size.height + 8;
                
                paymentddln_stlbl.frame = frame;
                
                [self.enrollmentBtn setTitle:pickerValue forState:UIControlStateNormal];
                
                [self setframe];
                
                minimum_payment_id = @"";
                
            }
            else{
                
                [enrollmentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            if ([data_id isEqual:@"0"]||[data_id isEqual:@"1"]||[data_id isEqual:@"2"]||[data_id isEqual:@"3"]) {
                
                payment_textview.text = @"For enrolments of a set number of lessons only, OR enrolments of four (4) lessons or less: Payment of all lesson fees plus other charges such as books, materials, deposit and others (if applicable) is required in advance in one payment transaction. For continuous and infinite enrolments without a set end-date: Payment of ONE lesson fee plus other fees such as books, materials, deposit and others (if applicable) is required in the 1st payment, and the 2nd payment onwards will be charged automatically, weekly and in advance using the same payment method used on the 1st payment, and will only include one lesson fee at a time.";
                
                minimum_payment_id =@"4";
            }
            else{
                
                payment_textview.text = @"For continuous enrolments of more than four (4) lessons, the 1st payment will include ONE lesson fee plus other fees such as books, materials, deposit and others (if applicable). The 2nd payment onwards will be charged automatically, weekly and in advance using the same payment method used on the 1st payment, and will only include one lesson fee at a time. For four (4) lessons or less of continuous enrolment, payment of all lesson fees plus other fees such as books, materials, deposit and others (if applicable) is required in advance in one payment transaction.";
                
                minimum_payment_id = @"5";
                
            }
                
            // [self drawTextInRect:payment_textview.frame];
            
            payment_stlbl.hidden= NO;
            
            payment_textview.hidden = NO;
            
            payment_textview.textAlignment = NSTextAlignmentJustified;
            
            CGRect frame1 = payment_stlbl.frame;
            
            frame1.origin.y = enrollmentBtn.frame.origin.y + enrollmentBtn.frame.size.height + 8;
            
            payment_stlbl.frame = frame1;
            
            frame1 = payment_textview.frame;
            
            frame1.origin.y = payment_stlbl.frame.origin.y + payment_stlbl.frame.size.height + 8;
            
            payment_textview.frame = frame1;
            
            [payment_textview sizeToFit];
            
            frame1 = paymentddln_stlbl.frame;
            
            frame1.origin.y = payment_textview.frame.origin.y + payment_textview.frame.size.height + 8;
            
            paymentddln_stlbl.frame = frame1;
            
            frame1 = paymentDeadLineBtn.frame;
            
            frame1.origin.y = paymentddln_stlbl.frame.origin.y + paymentddln_stlbl.frame.size.height + 8;
            
            paymentDeadLineBtn.frame = frame1;
            
            [self setframe];
            
            [self.enrollmentBtn setTitle:pickerValue forState:UIControlStateNormal];
                
            }
            
            enrollment_id = data_id;
            break;
            
        }  case 10:{
            
            [self.minimumPaymentBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            minimum_payment_id = data_id;
            break;
        } case 11:{
            
            [otherCharge_bttn setTitle:pickerValue forState:UIControlStateNormal];
            
            otherCharge_id = data_id;
            break;
        }
//        } case 12:{
//            
//            data_id = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"]  valueForKey:@"id"];
//            
//            pickerValue = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"] valueForKey:@"name"];
//            
//            pickerValue = [@"  " stringByAppendingString:pickerValue];
//            
//            currencyAcpt_id = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"]  valueForKey:@"id"];
//            
//            
//            [currencyAcpt_btn setTitle:pickerValue forState:UIControlStateNormal];
//            
//            currencyAcpt_id = data_id;
//            
//            [books_materialBtn setTitle:pickerValue forState:UIControlStateNormal];
//            
//            books_material_id = data_id;
//            
//            [securityDepositBtn setTitle:pickerValue forState:UIControlStateNormal];
//            
//            security_deposite_id = data_id;
//            
//            [otherCharge_bttn setTitle:pickerValue forState:UIControlStateNormal];
//            
//            otherCharge_id = data_id;
//            
//            break;
//            
//        }
        default:
            break;
    }
    
    [toolBar removeFromSuperview];
    [pickerView removeFromSuperview];
}

#pragma mark - PickerView Delegates & Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    if ([list_index isEqualToString:@"12"]) {
        
        return [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"] valueForKey:@"name"];
    } else {
        
        return [[pickerArray objectAtIndex:row] valueForKey:@"name"];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *pickerlbl = (UILabel*)view;
    
    if (!pickerlbl){
        pickerlbl = [[UILabel alloc] init];
    }
    
    pickerlbl.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 30);
    
    [pickerlbl setLineBreakMode:NSLineBreakByClipping];
    
    [pickerlbl  setNumberOfLines:0];
    
    [pickerlbl  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [pickerlbl setFont:[UIFont systemFontOfSize:17]];
    
    pickerlbl.textAlignment = NSTextAlignmentCenter;
    
    NSString *text;
    
    if ([list_index isEqualToString:@"12"]) {
        
        text = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"]  valueForKey:@"name"];
        
    } else {
        
        text = [[pickerArray objectAtIndex:row] valueForKey:@"name"];
    }
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width - (1.0 * 2), FLT_MAX);
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect lable_frame = pickerlbl.frame;
    
    lable_frame.size.height = size.height + 10;
    
    [pickerlbl  setFrame:lable_frame];
    
    [pickerlbl sizeToFit];
    
    //Set text value
    pickerlbl.text = text;
    return pickerlbl;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    UILabel *pickerlbl = [[UILabel alloc] init];
    
    pickerlbl.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 30);
    
    [pickerlbl setLineBreakMode:NSLineBreakByClipping];
    
    [pickerlbl  setNumberOfLines:0];
    
    [pickerlbl  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [pickerlbl setFont:[UIFont systemFontOfSize:17]];
    
    NSString *text;
    
    if ([list_index isEqualToString:@"12"]) {
        
        text = [[[pickerArray objectAtIndex:2] valueForKey:@"Currency"]  valueForKey:@"name"];
        
    } else {
        
        text = [[pickerArray objectAtIndex:2] valueForKey:@"name"];
    }
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width - (1.0 * 2), FLT_MAX);
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect lable_frame = pickerlbl.frame;
    
    lable_frame.size.height = size.height + 10;
    
    [pickerlbl sizeToFit];
    
    CGFloat height = size.height + 10;
    
    if (height < 50.0) {
        
        height = 50.0f;
    }
    return height;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    pickData = [[pickerArray objectAtIndex:row] valueForKey:@"name"];
    
    pickId = [[pickerArray objectAtIndex:row] valueForKey:@"id"];
    
    pickData = [@"  " stringByAppendingString:pickData];
    
    
    
//    if ([list_index isEqualToString:@"12"]) {
//        
//        pickerValue = [[[pickerArray objectAtIndex:2] valueForKey:@"Currency"]  valueForKey:@"name"];
//        
//        data_id = [[[pickerArray objectAtIndex:2] valueForKey:@"Currency"]  valueForKey:@"id"];
//        
//        pickerValue = [@"  " stringByAppendingString:pickerValue];
//        
//    } else {
//        
//        pickerValue = [[pickerArray objectAtIndex:row] valueForKey:@"name"];
//        
//        data_id = [[pickerArray objectAtIndex:row] valueForKey:@"id"];
//        
//        pickerValue = [@"  " stringByAppendingString:pickerValue];
//    }
//    
//    pickerValue = [@"  " stringByAppendingString:pickerValue];
//    
    
}
//-(void)sizeScrollView{
//    
//    CGRect frame = size_view.frame;
//    
//    frame.origin.y = cancellation_textfield.frame.size.height + cancellation_textfield.frame.origin.y + 20;
//    
//    //frame.origin.x = cancellation_textfield.frame.origin.x;
//    
//    size_view.frame = frame;
//}

-(void) showPicker {
    
    pickData = @"  Select";
    
    pickId = @"";
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
    
    [cancelButton setWidth:100];
    
    doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
    
    [doneButton setWidth:100];
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    CGRect frame = pickerView.frame;
    
    frame.origin.y = self.view.frame.size.height - frame.size.height - 40;
    
    frame.size.width = self.view.frame.size.width;
    
    pickerView.frame = frame;
    
    pickerView.backgroundColor = [UIColor lightGrayColor];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- pickerView.frame.size.height) - 84, self.view.frame.size.width, 44)];
    
    toolBar.backgroundColor = [UIColor darkGrayColor];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[cancelButton,flexibleItem, doneButton];
    
    [self.view addSubview:toolBar];
    
    [self.view addSubview:pickerView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)tappaymentDeadLine:(id)sender {
    
    pickerArray = @[@{@"id":@"", @"name":@"Select"},@{@"id":@"6", @"name":@"Once the educator accepts the enrollment request, payment is required 48 hours prior to the first lesson."},@{@"id":@"7", @"name":@"Once the educator accepts the enrollment request, payment is required within 7 days or within 24 hours if the first lesson is less than 7 days away."},@{@"id":@"9", @"name":@"Once the Educator accepts the enrollment request, payment is required immediately."}];
    
    list_index = @"0";
    
    [self showPicker];
}

- (IBAction)tapDepositeBtn:(id)sender {
    
    list_index = @"1";
    
    pickerArray = @[@{@"id":@"", @"name":@"Deposits are not required."},@{@"id":@"1", @"name":@"A deposit is required to secure enrollment."},@{@"id":@"2", @"name":@"Deposit amounts are refunded when the student commences lessons."}];
    
    [self showListData:[pickerArray valueForKey:@"name"] allowMultipleSelection:YES selectedData:[depositeBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Deposit"];
}

//- (IBAction)tapChangeEnrollment:(id)sender {
//    
//    list_index = @"2";
//    
//    pickerArray = @[@{@"id":@"0", @"name":@"Select"}, @{@"id":@"0", @"name":@"Changes to enrollment can be made upon request under certain circumstances."},@{@"id":@"1", @"name":@"Changes to enrollment are not permitted."}];
//    
//    [self showPicker];
//}

- (IBAction)tapCancellationBtn:(id)sender {
    
    list_index = @"3";
    
    pickerArray = @[@{@"id":@"", @"name":@"Select"}, @{@"id":@"0", @"name":@"Once enrolment is confirmed, cancellations can be made under special circumstances by messaging the educator."},@{@"id":@"1", @"name":@"Once enrolment is confirmed, cancellations can only be made 7 days before the first lesson, and only by messaging the educator."},@{@"id":@"2", @"name":@"Once enrolment is confirmed, cancellations cannot be made."}];
    
    [self showPicker];
}

- (IBAction)tapRefundBtn:(id)sender {
    
    list_index = @"4";
    
    pickerArray = @[@{@"id":@"", @"name":@"Select"}, @{@"id":@"0", @"name":@"Once enrolment is confirmed, refunds are available by request from the educator."},@{@"id":@"1", @"name":@"Once enrolment is confirmed, refunds are only available under special circumstances by request from the educator."},@{@"id":@"2", @"name":@"Once enrolment is confirmed, refunds are not available."}];
    
    [self showPicker];
}

- (IBAction)tapmake_upLession:(id)sender {
    
    list_index = @"5";
    
    pickerArray = @[@{@"id":@"", @"name":@"Select"}, @{@"id":@"0", @"name":@"Make-up lessons are available upon request."},@{@"id":@"1", @"name":@"Make-up lessons can only be arrange due to sickness or travel."},@{@"id":@"2", @"name":@"Make-up lessons are not available."}];
    
    [self showPicker];
}

- (IBAction)tapservere_weather:(id)sender {
    
    list_index = @"6";
    
    pickerArray = @[@{@"id":@"", @"name":@"Lessons are not held during severe weather warnings such as Typhoon 8 and Black Rain Storm Warnings."},@{@"id":@"1", @"name":@"Make-up lessons can be arranged due to forced closures under certain circumstances."},@{@"id":@"2", @"name":@"Make-up classes cannot be arranged due to forced cancellations."},@{@"id":@"3", @"name":@"Lesson will still continue."}];
    
    [self showListData:[pickerArray valueForKey:@"name"] allowMultipleSelection:YES selectedData:[depositeBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Severe Weather"];
}

//- (IBAction)tapBooks_materialBtn:(id)sender {
//    
//    list_index = @"7";
//    
//    pickerArray = @[@{@"id":@"0", @"name":@"Select"},@{@"id":@"0", @"name":@"HKD"},@{@"id":@"1", @"name":@"SGD"},@{@"id":@"2", @"name":@"THB"},@{@"id":@"3", @"name":@"MYR"},@{@"id":@"4", @"name":@"PHP"},@{@"id":@"5", @"name":@"IRD"},@{@"id":@"6", @"name":@"RMB"},@{@"id":@"7", @"name":@"USD"}];
//    
//    //[self showPicker];
//}

//- (IBAction)tapSecurityDeposit:(id)sender {
//    
//    list_index = @"8";
//    
//    pickerArray = @[@{@"id":@"0", @"name":@"Select"},@{@"id":@"0", @"name":@"HKD"},@{@"id":@"1", @"name":@"SGD"},@{@"id":@"2", @"name":@"THB"},@{@"id":@"3", @"name":@"MYR"},@{@"id":@"4", @"name":@"PHP"},@{@"id":@"5", @"name":@"IRD"},@{@"id":@"6", @"name":@"RMB"},@{@"id":@"7", @"name":@"USD"}];
//    
//    //[self showPicker];
//}

- (IBAction)tapEnrollmentBtn:(id)sender {
    
    pickerArray = @[@{@"id":@"", @"name":@"Select"},@{@"id":@"0", @"name":@"Minimum enrollment 1 lesson."},@{@"id":@"1", @"name":@"Minimum enrollment 2 lesson."},@{@"id":@"2", @"name":@"Minimum enrollment 3 lesson."}, @{@"id":@"3", @"name" : @"Minimum enrollment 4 lesson."}, @{@"id":@"4", @"name" : @"Continuous enrollment is required until enrollment is cancelled by the educator at the request of the (student) member."}];
    
    list_index = @"9";
    
    [self showPicker];
}

//- (IBAction)tapothercharge_btn:(id)sender {
//    
//    list_index = @"10";
//    
//    pickerArray = @[@{@"id":@"0", @"name":@"Select"},@{@"id":@"0", @"name":@"HKD"},@{@"id":@"1", @"name":@"SGD"},@{@"id":@"2", @"name":@"THB"},@{@"id":@"3", @"name":@"MYR"},@{@"id":@"4", @"name":@"PHP"},@{@"id":@"5", @"name":@"IRD"},@{@"id":@"6", @"name":@"RMB"},@{@"id":@"7", @"name":@"USD"}];
//    
//    //[self showPicker];
//    
//    
//}

//- (IBAction)tapcurrencyAcpt_btn:(id)sender {
//    
//    NSDictionary *paramURL =@{};
//    
//    [self.view addSubview:indicator];
//    
//    [getConn startConnectionWithString:@"get_currency" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
//        
//        [indicator removeFromSuperview];
//        
//        if([getConn responseCode]==1)
//        {
//            
//            NSLog(@"%@",receivedData);
//            
//            pickerArray =[receivedData valueForKey:@"info"];
//            
//            list_index = @"12";
//            
//            [self showPicker];
//        }
//    }];
//}

//- (IBAction)tapMini_PaymentBtn:(id)sender {
//    
//    pickerArray = @[@{@"id":@"", @"name":@"Select"},@{@"id":@"0", @"name":@"Minimum advance payment for 1 lesson"},@{@"id":@"1", @"name":@"Minimum advance payment for 2 lesson"},@{@"id":@"2", @"name":@"Minimum advance payment for 3 lesson"}, @{@"id":@"3", @"name" : @"Minimum advance payment for 4 lesson."}];
//    
//    list_index = @"10";
//    
//    [self showPicker];
//}


- (IBAction)tappSaveBtn:(id)sender {
    
    NSString *message;
    
    NSLog(@"%@",paymentDeadLineBtn.titleLabel.text);
    
    if ([self.enrollmentBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select the Enrollment option";
        
    }else if ([self.minimumPaymentBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select the Minimum Payment option";
        
    }else if ([paymentDeadLineBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select the payment deadline option";
        
    } else if ([depositeBtn.titleLabel.text isEqualToString:@"  Select"] || [depositeBtn.titleLabel.text isEqualToString:@""] ) {
        
        message = @"Please select the deposit option";
        
    } else if ([changeEnrollmentBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select the change to enrollment option";
        
    }  else if ([cancellationBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select the cancellation option";
        
    } else if ([refundBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select the refund option";
        
    } else if ([make_upLessionBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select the make-up lesson option";
        
    } else if ([servere_weatherBtn.titleLabel.text isEqualToString:@"  Select"] || [depositeBtn.titleLabel.text isEqualToString:@""] ) {
        
        message = @"Please select the severe weather option";
        
    } else if ([books_materialBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select currency";
        
    } else if (![books_materialPrice.text isEqualToString:@""]) {
        
        // message = @"Please enter price for books and material";
        
        if (![validationObj validateNumber:books_materialPrice.text]) {
            
            message = @"Please enter valid price for books and material";
        }
    } else if (![securityPriceTxtField.text isEqualToString:@""]) {
        
        if (![validationObj validateNumber:securityPriceTxtField.text]) {
            
            message = @"Please enter valid price for security deposit";
            
        }
    }else if (![otherCharge_textfield.text isEqualToString:@""]) {
        
        if (![validationObj validateNumber:otherCharge_textfield.text]) {
            
            message = @"Please enter valid price for other charge deposit";
            
        }
    } else {
        
        if ([cancellation_id isEqualToString:@"3"]) {
            
            if ([cancellation_textfield.text isEqualToString:@""]) {
                
                message = @"Please add the other condition";
            }
            
        } else{
            
            if ([cancellationBtn.titleLabel.text isEqualToString:@"  Select"]) {
                
                message = @"Please select the cancellation option";
                
            }
        }
    }
    
    
    //    else if ([securityDepositBtn.titleLabel.text isEqualToString:@"  Select"]) {
    //
    //        message = @"Please select the deposit option";
    //
    //    } else if ([securityPriceTxtField.text isEqualToString:@""]) {
    //
    //        message = @"Please select the deposit option";
    //    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        /*
         
         member_id,lesson_id,lesson_name,picture1,picture2,picture3,picture4,picture5,no_img,logo,identity,lesson_description,category_id,subcategory_id,lesson_type,
         lesson_duration_hours,lesson_duration_minutes,
         payment_deadline,deposit,change_enrollment,
         cancellation,refund,make_up_lessons,severe_weather,
         currency,quantity_books_materials,currency_security,
         quantity_security,description_educator,name_educator,
         business_type,year,country_id,author_venu_unit,
         author_venu_building_name,author_venu_street,author_venu_district,
         author_country_id,author_state_id,author_city_id, offer
         @"enrollment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"enrollment"],
         @"minimum_payment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"minimum_payment"],
         */
        
        NSDictionary *term_conData = @{@"enrollment":enrollment_id, @"minimum_payment":minimum_payment_id, @"payment_deadline":paymentDead_id, @"deposit":deposit_ids, @"change_enrollment":changes_enrol_id,@"cancellation":cancellation_id, @"refund":refund_id, @"make_up_lessons":make_up_id, @"severe_weather":servere_ids, @"currency":books_material_id, @"quantity_books_materials":books_materialPrice.text, @"currency_security":security_deposite_id,@"quantity_security":securityPriceTxtField.text, @"other_charges_currency":otherCharge_id, @"other_charges":otherCharge_textfield.text,@"other_cancellation":cancellation_textfield.text};
        
        NSLog(@"%@", term_conData);
        
        [[NSUserDefaults standardUserDefaults] setValue:term_conData forKey:@"Term_CondData"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)tappCancelBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title {
    
    ListingViewController *listViewController = [[ListingViewController alloc] init];
    
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

-(void)didSelectListItem:(id)item index:(NSInteger)index{
    
        [self dismissViewControllerAnimated:YES completion:nil];
        
        NSMutableArray *array_selectedInterest = [NSMutableArray array];
        
        NSMutableArray *array_Ids = [NSMutableArray array];
        
        [array_selectedInterest addObject:[pickerArray[index] valueForKey :@"name" ]];
        
        [array_Ids addObject:[pickerArray[index] valueForKey :@"id" ]];
        
        
        NSString *str = [array_selectedInterest  componentsJoinedByString:@", "];
        
        str = [@"  " stringByAppendingString:str];
        
        NSString *str_ids = [array_Ids  componentsJoinedByString:@","];
        
        if ([list_index isEqualToString:@"1"]) {
            
            [depositeBtn setTitle:str forState:UIControlStateNormal];
            
            [depositeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            deposit_ids = str_ids;
            
        } else if ([list_index isEqualToString:@"6"]){
            
            [servere_weatherBtn setTitle:str forState:UIControlStateNormal];
            
            [servere_weatherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            servere_ids = str_ids;
        }
    }
    

-(void)didSaveItems:(NSArray*)items indexs:(NSArray *)indexs{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *array_selectedInterest = [NSMutableArray array];
    
    NSMutableArray *array_Ids = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in indexs) {
        
        NSLog(@"IndexPath:%ld",(long)indexPath.row);
        
        if (indexs.count > pickerArray.count) {
            
            if (indexPath.row < pickerArray.count) {
                
                [array_selectedInterest addObject:[pickerArray[indexPath.row] valueForKey :@"name" ]];
                
                [array_Ids addObject:[pickerArray[indexPath.row] valueForKey :@"id" ]];
            }
            
        } else {
            
            [array_selectedInterest addObject:[pickerArray[indexPath.row-1] valueForKey:@"name"]];
            
            [array_Ids addObject:[pickerArray[indexPath.row-1] valueForKey :@"id" ]];
        }
    }
    
    NSString *str = [array_selectedInterest  componentsJoinedByString:@", "];
    
    str = [@"  " stringByAppendingString:str];
    
    NSString *str_ids = [array_Ids  componentsJoinedByString:@","];
    
    if ([list_index isEqualToString:@"1"]) {
        
        [depositeBtn setTitle:str forState:UIControlStateNormal];
        
         [depositeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        deposit_ids = str_ids;
        
    } else if ([list_index isEqualToString:@"6"]){
        
        [servere_weatherBtn setTitle:str forState:UIControlStateNormal];
        
         [servere_weatherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        servere_ids = str_ids;
    }
}

-(void)didCancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//#pragma mark - TextField Delegates & Datasource
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    [textField resignFirstResponder];
//    
//    if (textField == books_materialPrice || textField == securityPriceTxtField || textField == otherCharge_textfield) {
//        
//        if (![validationObj validateNumber:textField.text]) {
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please enter valid amount" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            [alert show];
//        }
//    }
//    
//    return TRUE;
//}
//
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    
//    return TRUE;
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//
//    activeField = textField;
//    //[self animateTextField: textField up: YES];
//}
//
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    
//    activeField = nil;
//    //[self animateTextField: textField up: NO];
//}
//
//- (void)animateTextField:(UITextField*)textField up:(BOOL) up {
//    
//    const int movementDistance = -(self.view.frame.size.height - textField.frame.origin.y - 50);
//    
//    const float movementDuration = 0.3f;
//    
//    int movement = (up ? -movementDistance : movementDistance);
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    
//    [UIView setAnimationDuration: movementDuration];
//    
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    
//    [UIView commitAnimations];
//    
//}
//
//// Called when the UIKeyboardDidShowNotification is sent.
//
//- (void)registerForKeyboardNotifications
//{
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     
//                                             selector:@selector(keyboardWasShown:)
//     
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     
//                                             selector:@selector(keyboardWillBeHidden:)
//     
//                                                 name:UIKeyboardWillHideNotification object:nil];
//    
//}
//
//- (void)keyboardWasShown:(NSNotification*)aNotification {
//    
//    NSDictionary* info = [aNotification userInfo];
//    
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    float kbHeight = 0.0;
//    
//    if (kbSize.width > kbSize.height) {
//        
//        kbHeight = kbSize.height;
//        
//    } else {
//        
//        kbHeight = kbSize.width;
//    }
//    
//    NSLog(@"%f", self.view.frame.origin.x);
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
//    
//    UIStoryboard *storyboard;
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        
//        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
//        
//        // [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1600)];
//        
//    } else {
//        
//        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
//        
//        //[scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1200)];
//    }
//    
//    scrollView.contentInset = contentInsets;
//    
//    CGRect aRect = self.view.frame;
//    
//    aRect.size.height -= kbHeight;
//    
//    UIView *activeView = activeField;
//    
//    if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
//        
//        [scrollView scrollRectToVisible: activeView.frame  animated:YES];
//    }
//}
//
//// Called when the UIKeyboardWillHideNotification is sent
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    
//    scrollView.contentInset = contentInsets;
//    
//    scrollView.scrollIndicatorInsets = contentInsets;
//    
//    scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
//
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    [self.view endEditing:YES];
//    
//    [super touchesBegan:touches withEvent:event];
//}
//
//- (void)hideKeyboard {
//    
//    [self.view endEditing:YES];
//}
- (IBAction)tapInfo_btn:(id)sender {
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"Specify your enrollment terms & conditions, which govern the terms and conditions by which other members should follow when enrolling in your lesson." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertview show];
    
}
- (IBAction)tapFeesCharges_btn:(id)sender {
    
    NSString *message;
    
    if ([enrollmentBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select enrollment option.";
        
    }else if ([minimumPaymentBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select payment terms option.";
        
    }else if ([paymentDeadLineBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select payment deadline option.";
        
    } else if ([depositeBtn.titleLabel.text isEqualToString:@"  Select"] || [depositeBtn.titleLabel.text isEqualToString:@""] ) {
        
        message = @"Please select deposit option.";
        
//    } else if ([changeEnrollmentBtn.titleLabel.text isEqualToString:@"  Select"]) {
//        
//        message = @"Please select the change to enrollment option.";
        
    }  else if ([cancellationBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select cancellation option.";
        
    } else if ([refundBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select refund option.";
        
    } else if ([make_upLessionBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select make-up lesson option.";
        
    } else if ([servere_weatherBtn.titleLabel.text isEqualToString:@"  Select"] || [servere_weatherBtn.titleLabel.text isEqualToString:@""] ) {
        
        message = @"Please select severe weather option.";
        
        //    } else if ([books_materialBtn.titleLabel.text isEqualToString:@"  Select"]) {
        //
        //        message = @"Please select currency";
        //
        //    } else if (![books_materialPrice.text isEqualToString:@""]) {
        //
        //        if (![validationObj validateNumber:books_materialPrice.text]) {
        //
        //            message = @"Please enter valid price for books and material";
        //        }
        //    } else if (![securityPriceTxtField.text isEqualToString:@""]) {
        //
        //        if (![validationObj validateNumber:securityPriceTxtField.text]) {
        //
        //            message = @"Please enter valid price for security deposit";
        //        }
        //    }
        //    else if (![othercharges_textfield.text isEqualToString:@""]) {
        //
        //        if (![validationObj validateNumber:othercharges_textfield.text]) {
        //
        //            message = @"Please enter valid price for otherCharge deposit";
        //
        //        }
        
    } else {
        
        if ([cancellation_id isEqualToString:@"3"]) {
            
            if ([cancellation_textfield.text isEqualToString:@""]) {
                
                message = @"Please add the other condition.";
            }
            
        } else{
            
            if ([cancellationBtn.titleLabel.text isEqualToString:@"  Select"]) {
                
                message = @"Please select the cancellation option.";
                
            }
        }
        
        
    }
    
    //    else if ([securityDepositBtn.titleLabel.text isEqualToString:@"  Select"]) {
    //
    //        message = @"Please select the deposit option";
    //
    //    } else if ([securityPriceTxtField.text isEqualToString:@""]) {
    //
    //        message = @"Please select the deposit option";
    //    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        NSDictionary *term_conData = @{@"payment_deadline":paymentDead_id, @"deposit":deposit_ids,@"cancellation":cancellation_id, @"refund":refund_id, @"make_up_lessons":make_up_id, @"severe_weather":servere_ids,@"enrollment":enrollment_id,@"minimum_payment":minimum_payment_id};
        
        // NSString *currecy_name = currencyAccpt_btn.titleLabel.text;
        
        //  currecy_name = [currecy_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //  NSDictionary *dict = @{@"currency_id":currencyAcpt_id,@"currency_name":currecy_name};
        
        // [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"Currency"];
        
        NSLog(@"%@", term_conData);
        
        [[NSUserDefaults standardUserDefaults] setValue:term_conData forKey:@"Term_CondData"];
        
        [self performSegueWithIdentifier:@"editLessionFeeSegue" sender:self];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier]isEqualToString:@"editLessionFeeSegue"]) {
        
        editLessionFeeChargesViewController *otherFeesVC =[segue destinationViewController];
        
        otherFeesVC.lessonDict = lessonData;
    }
}
@end


