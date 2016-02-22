//
//  MyEnroll_BookingViewController.m
//  ecaHUB
//  Created by promatics on 4/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.

#import "MyEnroll_BookingViewController.h"
#import "myEnroll_bookingTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "SendMessageView.h"
#import "Cancel_ChangeEnrollView.h"
#import "Validation.h"
#import "viewMyEnrollView.h"

#define kPayPalEnvironment PayPalEnvironmentNoNetwork

@interface MyEnroll_BookingViewController () {
    
    myEnroll_bookingTableViewCell *cell;
    
    WebServiceConnection *myEnrollConn, *cancelConn, *changeEnrollConn, *deleteConn;
    
    WebServiceConnection *sendPaymentConn;
    
    WebServiceConnection *cancelPayentConn, *getSessionConn, *selectDayConn;
    
    viewMyEnrollView *viewEnrollView;
    
    Validation *validationObj;
    
    Cancel_ChangeEnrollView *cancel_ChangeEnrollView;
    
    SendMessageView * sendMsgView;
    
    Indicator *indicator;
    
    DateConversion *dateConversion;
    
    NSArray *sessionsArray;
    
    NSMutableArray *lesson_timeArray, *myEnrollArray;
    
    NSString *seller_id, *enroll_id, *amount, *currency;
    
    PayPalPayment *payment;
    
    BOOL isSession, tapSession;
    
    NSString *subscriber_id, *list_session, *changeSession_id, *lesson_timeId;
    
    UIView *actionView;
    
    NSMutableArray *popupArary;
    
    NSMutableDictionary *popupDict;
    
    UIButton *selectfilterBtn, *subfilterButton, *resetBtn, *filterBtn;
    
    UITextField *filterTextField;
    
    NSString *filter_type, *filter_val;
    
    BOOL isfilter;
    
    CGFloat lblwidth, valueWidth;
    
    UIBarButtonItem *filterBarButton, *resetBarButton;
    
    UIView *mainfilterview;
    
    NSInteger ageyears, page_no, totalPage;
    
    NSString *enrollment_id;
    
    CGFloat lastContentOffset;
    
    BOOL isScrollUp, isNextPage,isLodin;
    
}
@end

@implementation MyEnroll_BookingViewController

@synthesize myEnroolTable, environment, payPalConfig, resultText, acceptCreditCards,enrolBook_lbl;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isSession = NO;
    
    tapSession = NO;
    
    isfilter = NO;
    
//   self.navigationController.navigationBar.topItem.title = @"";
    
    myEnrollConn = [WebServiceConnection connectionManager];
    
    selectDayConn = [WebServiceConnection connectionManager];
    
    sendPaymentConn = [WebServiceConnection connectionManager];
    
    getSessionConn = [WebServiceConnection connectionManager];
    
    cancelPayentConn = [WebServiceConnection connectionManager];
    
    changeEnrollConn = [WebServiceConnection connectionManager];
    
    cancelConn = [WebServiceConnection connectionManager];
    
    deleteConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    popupArary = [[NSMutableArray alloc]init];
    
    myEnrollArray = [[NSMutableArray alloc]init];
    
    popupDict = [[NSMutableDictionary alloc]init];
    
    CGRect frame = myEnroolTable.frame;
    
    frame.origin.y = 67;
    
    frame.size.height = self.view.frame.size.height - 115;
    
    myEnroolTable.frame = frame;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        lblwidth = 196;
        
        valueWidth = 450;
        
    } else {
        
        lblwidth =112;
        
        valueWidth = 182;
    }
    
    enrolBook_lbl.hidden = YES;
    
    page_no = 1;
    
    [self filterview];
    
    [self fetchMyEnrolls:page_no];
    
    [self Method_Paypal];
    
}

-(void)filterview{
    
    UIButton *barbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [barbtn addTarget:self action:@selector(tap_selectFiletrBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [barbtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    
    filterBarButton =[[UIBarButtonItem alloc]initWithCustomView:barbtn];
    
//filterBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(tap_selectFiletrBtn:)];
    
    UIButton *barresetbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [barresetbtn addTarget:self action:@selector(tap_resetBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [barresetbtn setImage:[UIImage imageNamed:@"reset_icon"] forState:UIControlStateNormal];
    
    resetBarButton =[[UIBarButtonItem alloc]initWithCustomView:barresetbtn];
    
    
//        resetBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reset_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(tap_resetBtn:)];

        self.navigationItem.rightBarButtonItem = filterBarButton;
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
            mainfilterview = [[UIView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width,45)];
        
        } else {
        
            mainfilterview = [[UIView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width,30)];
        }
    
        mainfilterview.backgroundColor = [UIColor whiteColor];
    
        mainfilterview.hidden = YES;
    
        [self.view addSubview:mainfilterview];
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
            subfilterButton  = [[UIButton alloc]initWithFrame:CGRectMake(5, 0,self.view.frame.size.width-10,45)];
            
            [subfilterButton setFont:[UIFont systemFontOfSize:19.0f]];
        
        } else {
        
            subfilterButton  = [[UIButton alloc]initWithFrame:CGRectMake(5, 0,self.view.frame.size.width-10,30)];
            
            [subfilterButton setFont:[UIFont systemFontOfSize:17.0f]];
        }
    
        subfilterButton.backgroundColor = [UIColor whiteColor];
    
        [subfilterButton setTitle:@"Select" forState:UIControlStateNormal];
    
        [subfilterButton setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
        subfilterButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
        subfilterButton.layer.borderWidth = 1.0f;
    
        subfilterButton.layer.cornerRadius = 5.0f;
    
        [mainfilterview addSubview:subfilterButton];
    
        [subfilterButton addTarget:self action:@selector(tap_subfilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    
        subfilterButton.hidden = YES;
    
        UIView *paddingView;
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
            filterTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0,self.view.frame.size.width-10,45)];
            
            [filterTextField setFont:[UIFont systemFontOfSize:19.0f]];
            
             paddingView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 45)];
        
        } else {
        
            filterTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0,self.view.frame.size.width-10,30)];
            
            [filterTextField setFont:[UIFont systemFontOfSize:17.0f]];
            
            paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
        }
    
        self->filterTextField.delegate = self;
    
        filterTextField.backgroundColor = [UIColor whiteColor];
    
        filterTextField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
        filterTextField.layer.borderWidth = 1.0f;
    
        filterTextField.layer.cornerRadius = 5.0f;
    
        [filterTextField setReturnKeyType:UIReturnKeySearch];
    
        [mainfilterview addSubview:filterTextField];
    
        filterTextField.leftView = paddingView;
    
        filterTextField.leftViewMode = UITextFieldViewModeAlways;
    
        filterTextField.hidden = YES;

}

-(void)tap_selectFiletrBtn:(UIButton *)sender{
    
    UIActionSheet *filetr_actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Course/Event/Lesson",@"Status",@"Student",@"Enrollment Reference", nil];
    
    filetr_actionsheet.tag = 1;
    
    [filetr_actionsheet showFromBarButtonItem:filterBarButton animated:YES];
}

-(void)tap_subfilterBtn:(UIButton *)sender{
    
    UIActionSheet *subfiltersheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Waiting",@"Accepted / Please Pay",@"Confirmed",@"Requested to Cancel",@"Cancelled by educator", nil];
    
    subfiltersheet.tag = 2;
    
    [subfiltersheet showInView:self.view];
  
}

-(void)tap_resetBtn:(UIButton *)sender{
    
    [filterTextField resignFirstResponder];
    
    CGRect frame = myEnroolTable.frame;
    
    frame.origin.y = 67;
    
    frame.size.height = self.view.frame.size.height - 115;
    
    myEnroolTable.frame = frame;
    
    isfilter = NO;
    
    myEnroolTable.hidden = NO;
    
    [subfilterButton setTitle:@"Select" forState:UIControlStateNormal];
    
    [subfilterButton setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    mainfilterview.hidden = YES;
    
    subfilterButton.hidden = YES;
    
    filterTextField.hidden = YES;
    
    filterTextField.text = @"";
    
    filter_type = @"";
    
    filter_val = @"";
    
    [self fetchMyEnrolls:1];
    
}

#pragma mark - UIActionsheet Delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag ==1) {
        
        if (buttonIndex == 0) {
            
            filter_type = @"1";
            
            subfilterButton.hidden = YES;
            
            filterTextField.hidden = NO;
            
            mainfilterview.hidden = NO;
            
            filterTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Course/Event/Lesson Name" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
            
            CGRect frame = myEnroolTable.frame;
            
            frame.origin.y = mainfilterview.frame.origin.y + mainfilterview.frame.size.height +10;
            
            frame.size.height = self.view.frame.size.height -  (mainfilterview.frame.origin.y + mainfilterview.frame.size.height +50);
            
            myEnroolTable.frame = frame;
            
        }
        else if (buttonIndex == 1){
            
            filter_type = @"2";
            
            subfilterButton.hidden = NO;
            
            filterTextField.hidden = YES;
            
            mainfilterview.hidden = NO;
            
            [subfilterButton setTitle:@"Select Status" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
            
            CGRect frame = myEnroolTable.frame;
            
            frame.origin.y = mainfilterview.frame.origin.y + mainfilterview.frame.size.height +10;
            
            frame.size.height = self.view.frame.size.height -  (mainfilterview.frame.origin.y + mainfilterview.frame.size.height +50);;
            
            myEnroolTable.frame = frame;
            
            
        }
        else if (buttonIndex ==2){
            
            filter_type = @"3";
            
            subfilterButton.hidden = YES;
            
            filterTextField.hidden = NO;
            
            mainfilterview.hidden = NO;
            
            filterTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Student Name" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
            
            CGRect frame = myEnroolTable.frame;
            
            frame.origin.y = mainfilterview.frame.origin.y + mainfilterview.frame.size.height +10;
            
            frame.size.height = self.view.frame.size.height -  (mainfilterview.frame.origin.y + mainfilterview.frame.size.height +50);
            
            myEnroolTable.frame = frame;
            
            
        }
        else if (buttonIndex ==3){
            
            filter_type = @"4";
            
            subfilterButton.hidden = YES;
            
            filterTextField.hidden = NO;
            
            mainfilterview.hidden = NO;
            
            filterTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Enrollment Reference" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
            
            CGRect frame = myEnroolTable.frame;
            
            frame.origin.y = mainfilterview.frame.origin.y + mainfilterview.frame.size.height +10;
            
            frame.size.height = self.view.frame.size.height -  (mainfilterview.frame.origin.y + mainfilterview.frame.size.height +50);;
            
            myEnroolTable.frame = frame;
            
            
        }
    }
    
    //"Waiting",@"Accepted / Please Pay",@"Confirmed",@"Requested to Cancel",@"Cancelled by educator", nil];
    else if (actionSheet.tag ==2){
        
        if (buttonIndex ==0) {
            
            filter_val = @"1";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Waiting" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchMyEnrolls:1];
            
            
        }
        else if (buttonIndex ==1){
            
            filter_val = @"2";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Accepted / Please Pay" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchMyEnrolls:1];
            
        }
        else if (buttonIndex ==2){
            
            filter_val = @"3";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Confirmed" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchMyEnrolls:1];
            
            
            
        }
        else if (buttonIndex ==3){
            
            filter_val = @"8";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Requested to Cancel" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchMyEnrolls:1];
            
            
            
            
        }
        else if (buttonIndex==4){
            
            filter_val = @"7";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Cancelled by educator" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchMyEnrolls:1];
            
            
        }
    }
    
}

#pragma UITextfieldDeligates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if (![filter_type isEqualToString:@"2"]) {
        
        filter_val = filterTextField.text;
    }
    
    isfilter = YES;
    
    [self fetchMyEnrolls:1];
    
    return true;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    if (isSession) {
        
    } else {
    
    [self fetchMyEnrolls:1];
    }
    [self Method_Paypal];
    
    // Preconnect to PayPal early
    
    [self setPayPalEnvironment:self.environment];
}

-(void)payPal:(UIButton *)button {
    
    [actionView removeFromSuperview];
    
    currency = [[[myEnrollArray objectAtIndex:button.tag] valueForKey:@"Currency"] valueForKey:@"name"];
    
    amount = [[[myEnrollArray objectAtIndex:button.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"total_charges"];
    
    NSArray *amtArray = [amount componentsSeparatedByString:@"$ "];
    
    if ([amtArray count] > 1) {
        
        amount = [amtArray objectAtIndex:1];
        
    } else {
        
        amount = [amtArray objectAtIndex:0];
    }
    
    NSString *typeStr = [[[myEnrollArray objectAtIndex:button.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_type = @"Lesson";
    }
    
    seller_id = [[[myEnrollArray objectAtIndex:button.tag] valueForKey:listing] valueForKey:@"member_id"];
    
    enroll_id = [[[myEnrollArray objectAtIndex:button.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Single Paymant",@"Future Payment", nil];
    //
    //    [alert show];
    
    [self Method_Paypal];
    
    
    if ([list_type isEqualToString:@"Lesson"]) {
        
        [self futurePayment];
        
    } else {
        
        [self singlePayment];
    }
    
    
    
}

#pragma mark - UIAlertView Delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [self singlePayment];
        
    } else if (buttonIndex == 2) {
        
        [self futurePayment];
    }
}

-(void)singlePayment {
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"PayPal"];
    
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

- (void)setPayPalEnvironment:(NSString *)environment1
{
    self.environment = environment1;
    
    [PayPalMobile preconnectWithEnvironment:environment];
}

-(void)Method_Paypal
{
    
    payment = [[PayPalPayment alloc] init];
    
    NSDecimalNumber *price_event = [[NSDecimalNumber alloc] initWithString:amount];
    
    payment.amount =price_event;
    
    // payment.amount = total;
    
    payment.currencyCode = currency;
    
    payment.shortDescription = @"PAYPAL";
    
    payment.items = nil;
    
    payment.paymentDetails = nil;
    
    self.environment = PayPalEnvironmentSandbox;
    
    payPalConfig.acceptCreditCards = acceptCreditCards;
    
    payPalConfig = [[PayPalConfiguration alloc] init];
    
    payPalConfig.acceptCreditCards = YES;
    
    payPalConfig.merchantName = @"ECAhub, Inc.";
    
    payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    
    payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    self.environment = PayPalEnvironmentSandbox;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
}


#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success!");
    
    self.resultText = [completedPayment description];
    
    [self sendCompletedPaymentToServer:completedPayment];
    
    // Payment was processed successfully; send to server for verification and fulfillment
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    
    NSLog(@"PayPal Payment Canceled");
    
    self.resultText = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)futurePayment {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"PayPal"];
    
    NSString *member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    NSString *payPalRecurringPayment = PayPalRecurringPayment;
    
    //http://mercury.promaticstechnologies.com/ecaHub/Homes/payment_vendors?member_id=1&enrollment_id=7&master_id=20&currency_name=HKD&total_price=1200
    
    //member_id=1&enrollment_id=7&master_id=20&currency_name=HKD&total_price=1200
    
    payPalRecurringPayment = [payPalRecurringPayment stringByAppendingString:[NSString stringWithFormat:@"member_id=%@&enrollment_id=%@&master_id=%@&currency_name=%@&total_price=%@",member_id,enroll_id,seller_id,currency,amount]];
    
    NSLog(@"%@",payPalRecurringPayment);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:payPalRecurringPayment]];
    
    //@"seller_id":seller_id, @"enrollment_id":enroll_id, @"amount":amount
    
    //        PayPalFuturePaymentViewController *fpViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:payPalConfig delegate:self];
    //
    //        // Present the PayPalFuturePaymentViewController
    //        [self presentViewController:fpViewController animated:YES completion:nil];
    
    
    
}

#pragma mark - PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    // User cancelled login. Dismiss the PayPalLoginViewController, breathe deeply.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    // The user has successfully logged into PayPal, and has consented to future payments.
    
    // Your code must now send the authorization response to your server.
    [self sendAuthorizationToServer:futurePaymentAuthorization];
    
    // Be sure to dismiss the PayPalLoginViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendAuthorizationToServer:(NSDictionary *)authorization {
    // Send the entire authorization reponse
    
    NSData *consentJSONData = [NSJSONSerialization dataWithJSONObject:authorization
                                                              options:0
                                                                error:nil];
    NSDictionary *receivedData=[NSJSONSerialization JSONObjectWithData:consentJSONData options:kNilOptions error:nil];
    
    NSLog(@"%@\n %@", authorization, receivedData);
    
    // (Your network code here!)
    //
    // Send the authorization response to your server, where it can exchange the authorization code
    // for OAuth access and refresh tokens.
    //
    // Your server must then store these tokens, so that your server code can execute payments
    // for this user in the future.
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment
{
    // TODO: Send completedPayment.confirmation to server
    
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    id result=completedPayment.confirmation;
    
    NSLog(@"%@\n %@", result, completedPayment);
    
    //[self sendAuthorizationToServer:result];
    
    if([[result valueForKey:@"response_type"]isEqualToString:@"payment"])
    {
        
        NSString *transaction_Id=[[result valueForKey:@"response"] valueForKey:@"id"];
        
        NSLog(@"%@", transaction_Id);
        // [self callWebserviceFor_Payment];
    }
    
    NSString *metadataID = [PayPalMobile clientMetadataID];
    
    NSLog(@"%@", metadataID);
    
    [self sendPaymentDetails:result];
}

-(void)sendPaymentDetails:(NSDictionary *)paymentData {
    
    NSLog(@"%@", paymentData);
    
    //enrollment_payment
    //payment_status = approved, txn_id, member_id, seller_id, enrollment_id, amount
    
    NSDictionary *paramURL = @{@"payment_status":@"approved", @"txn_id":[[paymentData valueForKey:@"response"] valueForKey:@"id"], @"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"seller_id":seller_id, @"enrollment_id":enroll_id, @"amount":amount};
    
    NSLog(@"%@",paramURL);
    
    [self.view addSubview:indicator];
    
    [sendPaymentConn startConnectionWithString:@"enrollment_payment" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([sendPaymentConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:[receivedData valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
            [self fetchMyEnrolls:page_no];
        }
    }];
}

-(void)fetchMyEnrolls:(int)current_page {
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL;
    
    if (isfilter) {
        
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"filter_type":filter_type,@"filter_val":filter_val};
        
        [filterTextField resignFirstResponder];
    }
    else{
    
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
        
    }
    
    NSString *service = [@"my_enrollments/page:"stringByAppendingString:[NSString stringWithFormat:@"%d",current_page]];
    
    [myEnrollConn startConnectionWithString:service HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([myEnrollConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                isLodin = YES;
                
                totalPage = [[receivedData valueForKey:@"total_page_no"] integerValue];
                
                if (current_page == 1) {
                    
                  myEnrollArray = [[NSMutableArray alloc]init];
                }
                
                popupArary = [[NSMutableArray alloc]init];
                
                [myEnrollArray addObjectsFromArray:[receivedData valueForKey:@"enrollment_data"]];
                
                for (int i =0; i<myEnrollArray.count; i++) {
                    
                    [popupArary addObject:[[[myEnrollArray objectAtIndex:i] valueForKey:@"CreateEnrollment"] valueForKey:@"status"]];
                }
                if (isfilter) {
                    
                    self.navigationItem.rightBarButtonItems = @[resetBarButton,filterBarButton];
                }
                else{
                    
                    self.navigationItem.rightBarButtonItems = nil;
                    
                    self.navigationItem.rightBarButtonItem = filterBarButton;
                }
                
                myEnroolTable.hidden = NO;
                
                enrolBook_lbl.hidden = YES;
                
                [myEnroolTable reloadData];
                
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"You don't have any enrollments or bookings as yet. Enrollments and bookings can be made from any listing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
                if (isfilter) {
                    
                    self.navigationItem.rightBarButtonItems = @[resetBarButton,filterBarButton];
                }
                
                myEnroolTable.hidden = YES;
                
                enrolBook_lbl.hidden = NO;
                
            }
        }
    }];
}

#pragma mark - UITableView Deleates & Datasourse

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return cell.main_View.frame.origin.y + cell.main_View.frame.size.height + 10;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [myEnrollArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int count = 4;
    
    cell = (myEnroll_bookingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"myEnrollCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"%@", [myEnrollArray objectAtIndex:indexPath.row]);
    
    NSString *typeStr = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    [cell.detail_btn setUserInteractionEnabled:NO];
    
    cell.status_Value.textColor = [UIColor redColor];
    
    NSString *listing, *list_type, *type_listing ,*type_name, *type;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        list_type = @"Course";
        
        type_listing = @"CourseListing";
        
        type_name = @"course_name";
        
        type = [[[myEnrollArray objectAtIndex:indexPath.row]valueForKey:type_listing]valueForKey:@"type"];
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        list_type = @"Event";
        
        type_listing = @"EventListing";
        
        type_name = @"event_name";
        
        type = [[[myEnrollArray objectAtIndex:indexPath.row]valueForKey:type_listing]valueForKey:@"type"];
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_type = @"Lesson";
        
        type_listing = @"LessonListing";
        
        type_name = @"lesson_name";
        
        type = [[[myEnrollArray objectAtIndex:indexPath.row]valueForKey:type_listing]valueForKey:@"lesson_type"];
    }
    
    cell.detail_btn.hidden = YES;
    
    cell.detailTextLabel.hidden = YES;
    
    cell.detailLbl.hidden = YES;
    
    cell.type_label.text = [[NSString stringWithFormat:@"[%@] ",list_type]stringByAppendingString:[[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:type_listing] valueForKey:type_name]];
    
    cell.type_name.text = [@"[Session] "stringByAppendingString:[[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"session_name"]];
    
    NSString *name = [[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"student_name"];
    
    cell.action_imgview.image = [UIImage imageNamed:@"red_circle"];
    
    cell.for_name.text = name;
    
    [cell.detail_btn setTitle:[[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:type_listing] valueForKey:type_name] forState:UIControlStateNormal];
    
    if (![typeStr isEqualToString:@"3"]) {
        
    NSString *start_date = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"start_date"];
    
    if ([start_date isEqualToString:@""]) {
        
        start_date = @"";
    }
    else{
    
    start_date = [dateConversion convertDate:start_date];
        
    }
    
    cell.from_date.text = start_date;
    
    NSString *finish_date = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"finish_date"];
        
    if ([finish_date isEqualToString:@""]) {
            
        finish_date = @"";
    }
   
    else{
    
    finish_date = [dateConversion convertDate:finish_date];
        
    }
    cell.to_date.text = finish_date;
        
    }
    else{
        
        NSString *date_starting = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"select_date"] valueForKey:@"date_starting"];
        
        if ([date_starting isEqualToString:@""]) {
            
            date_starting = @"";
        }
        
        cell.from_date.text = date_starting;
        
        NSString *date_finished = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"select_date"] valueForKey:@"date_finished"];
        
        if ([date_finished isEqualToString:@""]) {
            
            date_finished = @"";
        }
        else if ([date_finished isEqualToString:@"Infinite"]) {
            
            date_finished = @"Infinite";
        }
        
        cell.to_date.text = date_finished;
        
        
    }
    
    NSString *venu_street = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"venu_street"];
    
    if ([venu_street isEqualToString:@""]) {
        
        venu_street =@"";
    }
    
    else{
        
        venu_street = [venu_street stringByAppendingString:@", "];
    }
    
    NSString *venu_district =[[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"venu_district"];
    
    if ([venu_district isEqualToString:@""]) {
        
        venu_district =@"";
    }
    
    else{
        
        venu_district = [venu_district stringByAppendingString:@", "];
    }
    
    NSString *city_name =[[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"terms"] valueForKey:@"city_name"];
    
    if ([city_name isEqualToString:@""]) {
        
        city_name =@"";
    }
    
    else{
        
        city_name = [city_name stringByAppendingString:@", "];
    }
    
    NSString *state_name =[[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"terms"] valueForKey:@"state_name"];
    
    if ([state_name isEqualToString:@""]) {
        
        state_name =@"";
    }
    
    else{
        
        state_name = [state_name stringByAppendingString:@", "];
    }
    
    NSString *country_name =[[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"terms"] valueForKey:@"country_name"];
    
    if ([country_name isEqualToString:@""]) {
        
        country_name =@"";
    }
    
    else{
        
        country_name = [country_name stringByAppendingString:@"."];
    }
    
    if ([type isEqual:@"1"] || [type isEqual:@"3"] || [type isEqual:@"4"]) {
        
        cell.address.text = [@"Online | "stringByAppendingString:[[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"terms"] valueForKey:@"city_name"]];
       
    }
    else{
    
    cell.address.text =[[[[venu_street stringByAppendingString:venu_district]stringByAppendingString:city_name]stringByAppendingString:state_name]stringByAppendingString:country_name];
        
    }
    
    cell.listingReference.text = [[[myEnrollArray objectAtIndex:indexPath.row]valueForKey:type_listing]valueForKey:@"reference_id"];
    
    cell.send_msgBtn.layer.cornerRadius = 5.0f;
    
    cell.pay_nowBtn.layer.cornerRadius = 5.0f;
    
    [cell.pay_nowBtn addTarget:self action:@selector(payPal:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.send_msgBtn addTarget:self action:@selector(tapMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.actionBtn addTarget:self action:@selector(tap_actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.infoActionBtn addTarget:self action:@selector(tap_infotoolBtn:) forControlEvents:UIControlEventTouchUpInside];
     
    cell.actionBtn.tag = indexPath.row;
    
    cell.pay_nowBtn.tag = indexPath.row;
    
    cell.send_msgBtn.tag = indexPath.row;
    
    NSString *dateStr = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"booking_date"];
    
    if ([dateStr isEqualToString:@""]) {
        
        dateStr = @"";
    }
    else{
    
    dateStr = [dateConversion convertDate:dateStr];
        
    }
    
    cell.enroll_date.text = dateStr;
    
    NSString *currency_name = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"Currency"] valueForKey:@"name"];
    
    cell.cost.text = [[currency_name stringByAppendingString:@" "] stringByAppendingString:[[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"total_charges"]];
    
    cell.reference_no.text = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"reference_code"];
    
    NSString *status = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"status"];
    
    cell.pay_nowBtn.hidden = NO;
        
    cell.pay_nowBtn.hidden = YES;
    
    if ([status isEqualToString:@"1"]) {
        
        cell.status_Value.text =@"Waiting";
        
    } else if ([status isEqualToString:@"2"]) {
        
        cell.status_Value.text =@"Accepted/Please Pay";
        
        cell.pay_nowBtn.hidden = NO; 
        
        count = count +1;
        
    } else if ([status isEqualToString:@"3"]) {
        
        cell.status_Value.text =@"Confirmed";
        
        cell.pay_nowBtn.hidden = YES;
        
        //count = count +1;
        
    } else if ([status isEqualToString:@"4"]) {
        
        cell.status_Value.text =@"Recurring payment cancel by user";
        
    } else if ([status isEqualToString:@"5"]) {
        
        cell.status_Value.text =@"Recuring payment cancel by paypal business account holder";
        
    } else if ([status isEqualToString:@"7"]) {
        
        cell.status_Value.text =@"Requested to Cancel";
        
        cell.cancelEnrollBtn.hidden = YES;
        cell.changeEnrollBtn.hidden = YES;
        
        count = count - 2;
        
    } else if ([status isEqualToString:@"6"]) {
        
        cell.status_Value.text =@"Can't Confirm";
        
        cell.cancelEnrollBtn.hidden = YES;
        cell.changeEnrollBtn.hidden = YES;
        
        count = count - 2;
        
    } else if ([status isEqualToString:@"8"]) {
        
        cell.status_Value.text =@"Cancelled";
        
        cell.cancelEnrollBtn.hidden = YES;
        cell.changeEnrollBtn.hidden = YES;
        
        count = count - 2;
        
    } else {
        
        cell.status_mage.image = [UIImage imageNamed:@"mah_face"];
    }
    
    NSString *payment_status = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"payment_status"];
    
    if ([payment_status isEqualToString:@"1"] && ![status isEqualToString:@"1"]) {
        
        cell.payment_status.text = @"Paid";
        
        cell.pay_nowBtn.hidden = YES;
        
       // count = count - 1;
        
    } else {
        
        cell.payment_status.text = @"Pending";
        
        // cell.pay_nowBtn.hidden = NO;
    }
    
    subscriber_id = [[[myEnrollArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"subscriber_id"];
    
    if ([listing isEqualToString:@"LessonSession"] && [payment_status isEqualToString:@"1"] && [subscriber_id length] > 1) {
        
        cell.cancelPayment.hidden = NO;
        
        count = count +1;
        
    } else {
        
        cell.cancelPayment.hidden = YES;
    }
    
    int total_width = cell.main_View.frame.size.width;
    
    int btn_width = cell.viewDetailBtn.frame.size.width;
    
    int x_btn = (total_width - (count * btn_width))/(count+1);
    
    CGRect frame_btn = cell.viewDetailBtn.frame;
    frame_btn.origin.x = x_btn;
    //cell.viewDetailBtn.frame = frame_btn;
    
    [cell.viewDetailBtn setFrame:frame_btn];
    
    frame_btn = cell.send_msgBtn.frame;
    frame_btn.origin.x = cell.viewDetailBtn.frame.origin.x + btn_width + x_btn;
    [cell.send_msgBtn setFrame:frame_btn];
    
    if ([status isEqualToString:@"3"]) {
        
        cell.changeEnrollBtn.hidden = NO;
        cell.cancelEnrollBtn.hidden = NO;
        
        CGRect frame_btn = cell.changeEnrollBtn.frame;
        frame_btn.origin.x = cell.send_msgBtn.frame.origin.x + btn_width + x_btn;
        [cell.changeEnrollBtn setFrame:frame_btn];
        
        frame_btn = cell.cancelEnrollBtn.frame;
        frame_btn.origin.x = cell.changeEnrollBtn.frame.origin.x + btn_width + x_btn;
        [cell.cancelEnrollBtn setFrame:frame_btn];
    }
    
    if ([status isEqualToString:@"2"]) {
        
        CGRect frame_btn = cell.pay_nowBtn.frame;
        frame_btn.origin.x = cell.cancelEnrollBtn.frame.origin.x + btn_width + x_btn;
        [cell.pay_nowBtn setFrame:frame_btn];
        
        cell.pay_nowBtn.hidden = NO;
    }
    
    if ([listing isEqualToString:@"LessonSession"] && [payment_status isEqualToString:@"1"] && [subscriber_id length] > 1) {
        
        cell.cancelPayment.hidden = NO;
        
        CGRect frame_btn = cell.cancelPayment.frame;
        frame_btn.origin.x = cell.cancelEnrollBtn.frame.origin.x + btn_width + x_btn;
        [cell.cancelPayment setFrame:frame_btn];
    }
    
    cell.cancelPayment.tag = indexPath.row;
    cell.viewDetailBtn.tag = indexPath.row;
    cell.changeEnrollBtn.tag = indexPath.row;
    cell.cancelEnrollBtn.tag = indexPath.row;
    cell.cancelPayment.tag = indexPath.row;
    cell.detail_btn.tag = indexPath.row;
    
    [cell.cancelPayment addTarget:self action:@selector(cancelPayment:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.cancelEnrollBtn addTarget:self action:@selector(tapCancelEnrollBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.changeEnrollBtn addTarget:self action:@selector(tapChangeEnrollBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.viewDetailBtn addTarget:self action:@selector(tapViewDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.detail_btn addTarget:self action:@selector(tap_detailBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame1 = cell.type_label.frame;
    
    frame1.origin.y = 5;
    
    frame1.size.width = self.view.frame.size.width-20;
    
    cell.type_label.frame = frame1;
    
    [cell.type_label sizeToFit];
    
    frame1 = cell.type_name.frame;
    
    frame1.origin.y = cell.type_label.frame.origin.y + cell.type_label.frame.size.height +5;
    
    frame1.size.width = self.view.frame.size.width-20;
    
    cell.type_name.frame = frame1;
    
    [cell.type_name sizeToFit];
    
    frame1 = cell.fromLbl.frame;
    
    frame1.origin.y = cell.type_name.frame.origin.y + cell.type_name.frame.size.height + 5;
    
    frame1.size.width = lblwidth;
    
    cell.fromLbl.frame = frame1;
    
    [cell.fromLbl sizeToFit];
    
    frame1 = cell.from_date.frame;
    
    frame1.origin.y = cell.type_name.frame.origin.y + cell.type_name.frame.size.height + 5;
    
    frame1.size.width = valueWidth;
    
    cell.from_date.frame = frame1;
    
    [cell.from_date sizeToFit];
    
    frame1 = cell.tolbl.frame;
    
    if (cell.fromLbl.frame.size.height>cell.from_date.frame.size.height) {
        
        frame1.origin.y = cell.fromLbl.frame.origin.y + cell.fromLbl.frame.size.height + 5;
    }
    else{
        
        frame1.origin.y = cell.from_date.frame.origin.y + cell.from_date.frame.size.height + 5;
        
    }
    
    frame1.size.width = lblwidth;
    
    cell.tolbl.frame = frame1;
    
    [cell.tolbl sizeToFit];
    
    frame1 = cell.to_date.frame;
    
    frame1.origin.y = cell.tolbl.frame.origin.y;
    
    frame1.size.width = valueWidth;
    
    cell.to_date.frame = frame1;
    
    [cell.to_date sizeToFit];
    
    frame1 = cell.listingrfrncLbl.frame;
    
    if (cell.tolbl.frame.size.height>cell.to_date.frame.size.height) {
        
        frame1.origin.y = cell.tolbl.frame.origin.y + cell.tolbl.frame.size.height + 5;
    }
    else{
        
        frame1.origin.y = cell.to_date.frame.origin.y + cell.to_date.frame.size.height + 5;
        
    }
    
    frame1.size.width = lblwidth;
    
    cell.listingrfrncLbl.frame = frame1;
    
    [cell.listingrfrncLbl sizeToFit];
    
    frame1 = cell.listingReference.frame;
    
    frame1.origin.y = cell.listingrfrncLbl.frame.origin.y;
    
    frame1.size.width = valueWidth;
    
    cell.listingReference.frame = frame1;
    
    [cell.listingReference sizeToFit];
    
    frame1 = cell.venueLbl.frame;
    
    if (cell.listingrfrncLbl.frame.size.height>cell.listingReference.frame.size.height) {
        
        frame1.origin.y = cell.listingrfrncLbl.frame.origin.y + cell.listingrfrncLbl.frame.size.height + 5;
    }
    else{
        
        frame1.origin.y = cell.listingReference.frame.origin.y + cell.listingReference.frame.size.height + 5;
        
    }
    
    frame1.size.width = lblwidth;
    
    cell.venueLbl.frame = frame1;
    
    [cell.venueLbl sizeToFit];
    
    frame1 = cell.address.frame;
    
    frame1.origin.y = cell.venueLbl.frame.origin.y;
    
    frame1.size.width = valueWidth;
    
    cell.address.frame = frame1;
    
    [cell.address sizeToFit];
    
    frame1 = cell.forLbl.frame;
    
    if (cell.venueLbl.frame.size.height>cell.address.frame.size.height) {
        
        frame1.origin.y = cell.venueLbl.frame.origin.y + cell.venueLbl.frame.size.height + 5;
    }
    else{
        
        frame1.origin.y = cell.address.frame.origin.y + cell.address.frame.size.height + 5;
        
    }
    
    frame1.size.width = lblwidth;
    
    cell.forLbl.frame = frame1;
    
    [cell.forLbl sizeToFit];
    
    frame1 = cell.for_name.frame;
    
    frame1.origin.y = cell.forLbl.frame.origin.y;
    
    frame1.size.width = valueWidth;
    
    cell.for_name.frame = frame1;
    
    [cell.for_name sizeToFit];
    
    frame1 = cell.enrolmentDateLbl.frame;
    
    if (cell.forLbl.frame.size.height>cell.for_name.frame.size.height) {
        
        frame1.origin.y = cell.forLbl.frame.origin.y + cell.forLbl.frame.size.height + 5;
    }
    else{
        
        frame1.origin.y = cell.for_name.frame.origin.y + cell.for_name.frame.size.height + 5;
        
    }
    
    frame1.size.width = lblwidth;
    
    cell.enrolmentDateLbl.frame = frame1;
    
    [cell.enrolmentDateLbl sizeToFit];
    
    frame1 = cell.enroll_date.frame;
    
    frame1.origin.y = cell.enrolmentDateLbl.frame.origin.y;
    
    frame1.size.width = valueWidth;
    
    cell.enroll_date.frame = frame1;
    
    [cell.enroll_date sizeToFit];
    
    frame1 = cell.amountLbl.frame;
    
    if (cell.enrolmentDateLbl.frame.size.height>cell.enroll_date.frame.size.height) {
        
        frame1.origin.y = cell.enrolmentDateLbl.frame.origin.y + cell.enrolmentDateLbl.frame.size.height + 5;
    }
    else{
        
        frame1.origin.y = cell.enroll_date.frame.origin.y + cell.enroll_date.frame.size.height + 5;
        
    }
    
    frame1.size.width = lblwidth;
    
    cell.amountLbl.frame = frame1;
    
    [cell.amountLbl sizeToFit];
    
    frame1 = cell.cost.frame;
    
    frame1.origin.y = cell.amountLbl.frame.origin.y;
    
    frame1.size.width = valueWidth;
    
    cell.cost.frame = frame1;
    
    [cell.cost sizeToFit];
    
    frame1 = cell.enrolmentRfrnclbl.frame;
    
    if (cell.amountLbl.frame.size.height>cell.cost.frame.size.height) {
        
        frame1.origin.y = cell.amountLbl.frame.origin.y + cell.amountLbl.frame.size.height + 5;
    }
    else{
        
        frame1.origin.y = cell.cost.frame.origin.y + cell.cost.frame.size.height + 5;
        
    }
    
    frame1.size.width = lblwidth;
    
    cell.enrolmentRfrnclbl.frame = frame1;
    
    [cell.enrolmentRfrnclbl sizeToFit];
    
    frame1 = cell.reference_no.frame;
    
    frame1.origin.y = cell.enrolmentRfrnclbl.frame.origin.y ;
    
    frame1.size.width = valueWidth;
    
    cell.reference_no.frame = frame1;
    
    [cell.reference_no sizeToFit];
    
    frame1 = cell.statuslbl.frame;
    
    if (cell.enrolmentRfrnclbl.frame.size.height>cell.reference_no.frame.size.height) {
        
        frame1.origin.y = cell.enrolmentRfrnclbl.frame.origin.y + cell.enrolmentRfrnclbl.frame.size.height + 5;
    }
    else{
        
        frame1.origin.y = cell.reference_no.frame.origin.y + cell.reference_no.frame.size.height + 5;
        
    }
    
    frame1.size.width = lblwidth;
    
    cell.statuslbl.frame = frame1;
    
    [cell.statuslbl sizeToFit];
    
    frame1 = cell.status_Value.frame;
    
    frame1.origin.y = cell.statuslbl.frame.origin.y;
    
    frame1.size.width = valueWidth-50;
    
    cell.status_Value.frame = frame1;
    
    [cell.status_Value sizeToFit];
    
    frame1 = cell.status_mage.frame;
    
    frame1.origin.y = cell.statuslbl.frame.origin.y;
    
    cell.status_mage.frame = frame1;
    
    frame1 = cell.infoBtn.frame;
    
    frame1.origin.y = cell.statuslbl.frame.origin.y+1.5;
    
    cell.infoBtn.frame = frame1;
    
    frame1 = cell.infoActionBtn.frame;
    
    frame1.origin.y = cell.statuslbl.frame.origin.y;
    
    cell.infoActionBtn.frame = frame1;
    
    frame1 = cell.actionBtn.frame;
    
    frame1.origin.y = 10;
    
    cell.actionBtn.frame = frame1;
   
    frame1 = cell.main_View.frame;
    
    if (cell.statuslbl.frame.size.height>cell.status_Value.frame.size.height) {
        
        frame1.size.height = cell.statuslbl.frame.origin.y + cell.statuslbl.frame.size.height + 10;
    }
    else{
        
        frame1.size.height = cell.status_Value.frame.origin.y + cell.status_Value.frame.size.height + 10;
        
    }
    
    cell.main_View.frame = frame1;
    
    return cell;
}

-(void)tap_infotoolBtn:(UIButton *)sender {
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Status' shows the stage of the enrollment or booking process. There are 4 statuses that may be shown. 'Waiting' means you are waiting for the educator to accept your enrollment or booking request. 'Accepted / Please Pay' means the educator has accepted your enrollment or booking request, therefore you should pay ASAP to confirm your enrollment / booking. 'Confirmed' is when your payment has been processed, and therefore your enrollment or booking is confirmed. 'Cancelled' is when the educator has cancelled the enrollment or booking." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertview show];
}

-(void)tapChangeEnrollBtn:(UIButton *)sender {
    
    [actionView removeFromSuperview];
    
    NSString *typeStr = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }
    
    NSString *dateStart = [[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing] valueForKey:@"start_date"];
    
    dateStart = [dateConversion convertDate:dateStart];
    
    NSString *finish_date = [[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"finish_date"];
    
    finish_date = [dateConversion convertDate:finish_date];
    
    dateStart = [@"[Date] - " stringByAppendingString:dateStart];
    
    dateStart = [dateStart stringByAppendingString:@" to "];
    dateStart = [dateStart stringByAppendingString:finish_date];
    
    NSString *listName = [[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing_name]valueForKey:list_name];
    
    list_type = [@"[" stringByAppendingString:[NSString stringWithFormat:@"%@] - ",list_type]];
    
    listName = [list_type stringByAppendingString:listName];
    
    NSString *session_name = [[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"session_name"];
    
    session_name = [@"[Session Name] - " stringByAppendingString:session_name];
    
    NSString *name = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Member"]valueForKey:@"first_name"];
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@" %@",[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"last_name"]]];
    
    NSString *s_name = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Family"]valueForKey:@"first_name"];
    
    s_name = [s_name stringByAppendingString:[NSString stringWithFormat:@" %@",[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"student_name"]]];
    
    UIStoryboard *storyboard;
        
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
        cancel_ChangeEnrollView = [[Cancel_ChangeEnrollView alloc] init];
            
        cancel_ChangeEnrollView = [[[NSBundle mainBundle] loadNibNamed:@"Cancel_changeEnrollIPad" owner:self options:nil] objectAtIndex:0];
            
        cancel_ChangeEnrollView.frame = self.view.frame;
            
    } else {
            
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
        cancel_ChangeEnrollView = [[Cancel_ChangeEnrollView alloc] init];
            
        cancel_ChangeEnrollView = [[[NSBundle mainBundle] loadNibNamed:@"Cancel_ChangeEnrollView" owner:self options:nil] objectAtIndex:0];
            
        cancel_ChangeEnrollView.frame = self.view.frame;
    }
        
        cancel_ChangeEnrollView.title.text = @"Change Enrollment";
        cancel_ChangeEnrollView.member.text = name;
        cancel_ChangeEnrollView.student.text = s_name;
        cancel_ChangeEnrollView.list_name.text = listName;
        cancel_ChangeEnrollView.session_name.text = session_name;
        cancel_ChangeEnrollView.date.text = dateStart;
        cancel_ChangeEnrollView.amount_lbl.hidden = YES;
        cancel_ChangeEnrollView.amount_txtField.hidden = YES;
        [cancel_ChangeEnrollView.confirm_Btn addTarget:self action:@selector(tapCangeEnrollmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        cancel_ChangeEnrollView.confirm_Btn.tag = sender.tag;
    
        [cancel_ChangeEnrollView.session_btn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
        [cancel_ChangeEnrollView.session_btn addTarget:self action:@selector(tapSessionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancel_ChangeEnrollView.confirm_Btn setTitle:@"Update" forState:UIControlStateNormal];
        cancel_ChangeEnrollView.session_btn.tag = sender.tag;
    if ([typeStr isEqualToString:@"3"]) {
        
        cancel_ChangeEnrollView.selctDay_btn.hidden = NO;
        cancel_ChangeEnrollView.selctDay_lbl.hidden = NO;
        
    }else{
        
        cancel_ChangeEnrollView.selctDay_btn.hidden = YES;
        cancel_ChangeEnrollView.selctDay_lbl.hidden = YES;
        
    }
    
    if ([typeStr isEqualToString:@"3"]) {
        
        cancel_ChangeEnrollView.selctDay_btn.hidden = NO;
        cancel_ChangeEnrollView.selctDay_lbl.hidden = NO;
        
        [cancel_ChangeEnrollView.selctDay_btn addTarget:self action:@selector(tapSelectDayBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cancel_ChangeEnrollView.selctDay_btn.tag = sender.tag;
        
    }else{
        
        cancel_ChangeEnrollView.selctDay_btn.hidden = YES;
        cancel_ChangeEnrollView.selctDay_lbl.hidden = YES;
        
        CGRect frame = cancel_ChangeEnrollView.MainView.frame;
        
        frame.origin.y = cancel_ChangeEnrollView.selctDay_lbl.frame.origin.y;
        
        cancel_ChangeEnrollView.MainView.frame = frame;
        
        frame = cancel_ChangeEnrollView.main_view.frame;
        
        frame.size.height = cancel_ChangeEnrollView.MainView.frame.size.height+cancel_ChangeEnrollView.MainView.frame.origin.y+20;
        
        cancel_ChangeEnrollView.main_view.frame = frame;
        
    }

    
    NSString *status = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"payment_status"];
    
    if ([status isEqualToString:@"0"]) {
        
        cancel_ChangeEnrollView.message.hidden = YES;
        cancel_ChangeEnrollView.msg_lbl.hidden = YES;
       
        CGRect frame = cancel_ChangeEnrollView.confirm_Btn.frame;
        frame.origin.y = cancel_ChangeEnrollView.message.frame.origin.y;
        cancel_ChangeEnrollView.confirm_Btn.frame = frame;
        
        frame = cancel_ChangeEnrollView.close_btn.frame;
        frame.origin.y = cancel_ChangeEnrollView.confirm_Btn.frame.origin.y + cancel_ChangeEnrollView.confirm_Btn.frame.size.height + 15;
        cancel_ChangeEnrollView.close_btn.frame = frame;
        
        frame = cancel_ChangeEnrollView.MainView.frame;
        frame.size.height = cancel_ChangeEnrollView.close_btn.frame.origin.y + cancel_ChangeEnrollView.close_btn.frame.size.height + 20;
        cancel_ChangeEnrollView.MainView.frame = frame;
        
        frame = cancel_ChangeEnrollView.main_view.frame;
        frame.size.height = cancel_ChangeEnrollView.MainView.frame.origin.y + cancel_ChangeEnrollView.MainView.frame.size.height + 10;
        cancel_ChangeEnrollView.main_view.frame = frame;
        
       // cancel_ChangeEnrollView.MainView.backgroundColor = [UIColor redColor];
        
      //  [cancel_ChangeEnrollView.confirm_Btn sizeToFit];
    }
    
    cancel_ChangeEnrollView.scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, cancel_ChangeEnrollView.main_view.frame.origin.y+cancel_ChangeEnrollView.main_view.frame.size.height +60);
    
    [self.view addSubview:cancel_ChangeEnrollView];
}

-(void)tapSelectDayBtn:(UIButton *)sender{
    
    tapSession = NO;
    
    if (!changeSession_id) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please select session first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
    NSString *typeStr = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }
    
    NSString *session_id = [[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"id"];
    
    NSDictionary *paramUrl = @{@"selected_session_id":session_id};
    
    [self.view addSubview:indicator];
    
    [selectDayConn startConnectionWithString:@"select_lesson_timing" HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary *ReceivedData){
        
        [indicator removeFromSuperview];
        
        if ([selectDayConn responseCode]==1) {
            
            NSLog(@"%@",ReceivedData);
            
            NSArray *lesson_array = [ReceivedData valueForKey:@"Timings"];
            
            lesson_timeArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < lesson_array.count; i++) {
                
                NSString *day = [[[lesson_array objectAtIndex:i] valueForKey:@"LessonTiming"] valueForKey:@"day_select"];
                
                day = [day stringByAppendingString:[NSString stringWithFormat:@" ( %@ - %@ )",[[[lesson_array objectAtIndex:i] valueForKey:@"LessonTiming"] valueForKey:@"start_time"], [[[lesson_array objectAtIndex:i] valueForKey:@"LessonTiming"] valueForKey:@"finish_time"]]];
                
                NSString *lesson_id = [[[lesson_array objectAtIndex:i] valueForKey:@"LessonTiming"] valueForKey:@"id"];
                
                NSDictionary *dict = @{@"id": lesson_id, @"name":day};
                
                [lesson_timeArray addObject:dict];
            }
            
            [self showListData:[lesson_timeArray valueForKey:@"name"] allowMultipleSelection:NO selectedData:[cancel_ChangeEnrollView.selctDay_btn.titleLabel.text componentsSeparatedByString:@", "] title:@"Select Lesson Day"];
        }
    }];
   }
}

-(void)tapSessionBtn:(UIButton *)sender {
    
    isSession = YES;
    
    tapSession = YES;
    
    [self.view addSubview:indicator];
    
    // enrollment_id, payment_status (1 if payment done, 0 is payment not done), current_session_id
    
    NSString *typeStr = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }
    
    NSDictionary *paramURL;
    
    NSString *enroll_id1 = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
    
// session_id (For which enrollment will be changed), enrollment_id, role (1 for student, 2 for educator), lesson_timing_id(if lesson)session_info
        
    paramURL = @{ @"enrollment_id":enroll_id1, @"role":@"1", @"session_id":[[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"id"], @"lesson_timing_id":[[[[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"session_info"]objectAtIndex:0]valueForKey:@"LessonTiming"]objectAtIndex:0]valueForKey:@"id"] };
    
    [getSessionConn startConnectionWithString:@"get_all_sessions" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([getSessionConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            sessionsArray = [receivedData valueForKey:@"Sessions"];
            
            list_session = listing;
            
            [self showListData:[[sessionsArray valueForKey:listing] valueForKey:@"session_name"] allowMultipleSelection:NO selectedData:[cancel_ChangeEnrollView.session_btn.titleLabel.text componentsSeparatedByString:@","] title:@"Select Session"];
        }
    }];
}


-(void)tap_detailBtn:(UIButton *)sender{
    
    NSString *typeStr = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type, *type_listing, *type_id;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        list_type = @"Course";
        
        type_listing = @"CourseListing";
        
        type_id = @"course_id";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        list_type = @"Event";
        
        type_listing = @"EventListing";
        
        type_id = @"event_id";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_type = @"Lesson";
        
        type_listing = @"LessonListing";
        
        type_id = @"lesson_id";
    }


    NSString *course_id = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:type_id];
    
    NSLog(@"Course Tap Id%@", course_id);
    
    [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
    
    if ([type_listing isEqualToString:@"CourseListing"]) {
        
        [self performSegueWithIdentifier:@"courseDetailSegue" sender:self];
        
    } else if ([type_listing isEqualToString:@"LessonListing"]){
        
        [self performSegueWithIdentifier:@"lession_view" sender:self];
        
    }  else if ([type_listing isEqualToString:@"EventListing"]){
        
        [self performSegueWithIdentifier:@"event_view_segue" sender:self];
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
    
    if (!tapSession) {
        
        [cancel_ChangeEnrollView.selctDay_btn setTitle:[@"  " stringByAppendingString:[[lesson_timeArray objectAtIndex:index] valueForKey:@"name"]] forState:UIControlStateNormal];
        
        lesson_timeId = [[lesson_timeArray objectAtIndex:index] valueForKey:@"id"];
        
    } else {
        
        [cancel_ChangeEnrollView.session_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
        [cancel_ChangeEnrollView.session_btn setTitle:[@"  " stringByAppendingString:[[[sessionsArray objectAtIndex:index] valueForKey:list_session] valueForKey:@"session_name"]] forState:UIControlStateNormal];
    
        changeSession_id = [[[sessionsArray objectAtIndex:index] valueForKey:list_session] valueForKey:@"id"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSaveItems:(NSArray*)items indexs:(NSArray *)indexs{
    
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)tapCangeEnrollmentBtn:(UIButton *)sender {

    NSString *typeStr = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *enroll_id1 = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }

    NSString *message;
    
    NSString *status = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"payment_status"];
    
    if ([status isEqualToString:@"1"]) {
    
    if ([cancel_ChangeEnrollView.message.text isEqualToString:@"Enter Message"]) {
        
        message = @"Please enter message";
        
    } else if (![validationObj validateNumberDigits:cancel_ChangeEnrollView.amount_txtField.text]) {
        
        message = @"Please enter valid refund amount";
    }
    } else {
        
        if ([cancel_ChangeEnrollView.session_btn.titleLabel.text isEqualToString:@"  Select"]) {
            
            message = @"Please Select Session";
        }
        
        if ([typeStr isEqualToString:@"Lesson"]) {
            
            if (!lesson_timeId) {
                
                message = @"Please Select Day";
            }
        }
    }
    if (message.length > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        NSString *status = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"payment_status"];
        
        if ([status isEqualToString:@"0"]) {
            
            // session_id (For which enrollment will be changed), enrollment_id, role (1 for student, 2 for educator), lesson_timing_id(if lesson)
            
            NSDictionary *paramURL;
            
            if ([list_type isEqualToString:@"Lesson"]) {
                
                paramURL = @{@"enrollment_id":enroll_id1, @"role":@"1", @"session_id":changeSession_id, @"lesson_timing_id":lesson_timeId};
                
            } else {
                
                paramURL = @{@"enrollment_id":enroll_id1, @"role":@"1", @"session_id":changeSession_id};
            }
            
            [self.view addSubview:indicator];
            
            [changeEnrollConn startConnectionWithString:@"change_enrollment_before_paid_student" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
                
                [indicator removeFromSuperview];
                
                if ([changeEnrollConn responseCode] == 1) {
                    
                    NSLog(@"%@", receivedData);
                    
                    [cancel_ChangeEnrollView removeFromSuperview];
                    
                    [self fetchMyEnrolls:1];
                }
            }];
            
        } else {
        
       // NSString *educator_id = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"EnrollmentOwner"] valueForKey:@"id"];
        
        // enrollment_id, message_content, payment_status = 1
        [self.view addSubview:indicator];
        
  
            NSDictionary *paramURL;
            
            //session_id (For which enrollment will be changed), enrollment_id, message_content,  lesson_timing_id(if lesson)
            
        if ([list_type isEqualToString:@"Lesson"]) {
                
            paramURL = @{@"enrollment_id":enroll_id1, @"role":@"1", @"session_id":changeSession_id, @"lesson_timing_id":lesson_timeId, @"message_content":cancel_ChangeEnrollView.message.text};
                
        } else {
                
            paramURL = @{@"enrollment_id":enroll_id1, @"role":@"1", @"session_id":[[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"id"], @"message_content":cancel_ChangeEnrollView.message.text};
        }
    
    [changeEnrollConn startConnectionWithString:@"cancel_enrollment_request_student" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([changeEnrollConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            [cancel_ChangeEnrollView removeFromSuperview];
            
            [self fetchMyEnrolls:1];
        }
    }];
  }
    }
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

-(void)tapViewDetail:(UIButton *)sender {
    
    [actionView removeFromSuperview];
    
    viewEnrollView = [[viewMyEnrollView alloc] init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        viewEnrollView = [[[NSBundle mainBundle] loadNibNamed:@"viewEnrollDetailIpad" owner:self options:nil] objectAtIndex:0];
        
    } else {
        
        viewEnrollView = [[[NSBundle mainBundle] loadNibNamed:@"viewMyEnrollView" owner:self options:nil] objectAtIndex:0];
    }
    
    viewEnrollView.frame = self.view.frame;
    
    viewEnrollView.scroll_view.frame = self.view.frame;
    
    NSString *typeStr = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *name = [[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"student_name"];
    
    viewEnrollView.forValue.text = name;
    
    NSString *listing, *list_type, *list_name, *list ,*list_duration_hours, *list_duration_minutes, *method_type;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        list_duration_hours = @"course_duration_hours";
        
        list_duration_minutes = @"course_duration_minutes";
        
        listing = @"CourseSession";
        
        list_type = @"Course";
        
        list_name = @"course_name";
        
        list = @"CourseListing";
        
        method_type =@"type";
        
        NSString *course_id = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CourseSession"] valueForKey:@"id"];
        
        NSArray *sessioninfo = [[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"session_info"];
        
        NSInteger lsnindex;
        
        for (int i= 0; i<sessioninfo.count; i++) {
            
            if ([course_id isEqualToString:[[[sessioninfo objectAtIndex:i]valueForKey:@"CourseSession"]valueForKey:@"id"]]) {
                
                lsnindex = i;
                
                break;
                
            }
        }
        
        NSArray *lessontimingarray = [[sessioninfo objectAtIndex:lsnindex]valueForKey:@"LessonTiming"];
        
        //date_selected
        //start_time
        //finish_time
        
        NSString *courseDateTime;
        
        for (int i = 0; i<lessontimingarray.count; i++) {
            
            if (i == 0) {
                
            NSString *date_selected = [[lessontimingarray objectAtIndex:i]valueForKey:@"date_selected"];
                
                if (![date_selected isEqualToString:@""]) {
                    
                    date_selected = [dateConversion convertDate:date_selected];
                }
                else{
                    
                    date_selected = @"";
                }
                
            courseDateTime = [[[[[date_selected stringByAppendingString:@" ("]stringByAppendingString:[[lessontimingarray objectAtIndex:i]valueForKey:@"start_time"]]stringByAppendingString:@" - "]stringByAppendingString:[[lessontimingarray objectAtIndex:i]valueForKey:@"finish_time"]]stringByAppendingString:@")"];
            }
            else{
                NSString *date_selected = [[lessontimingarray objectAtIndex:i]valueForKey:@"date_selected"];
                
                if (![date_selected isEqualToString:@""]) {
                    
                    date_selected = [dateConversion convertDate:date_selected];
                }
                else{
                    
                    date_selected = @"";
                }
                
                courseDateTime = [[courseDateTime stringByAppendingString:@"\n"]stringByAppendingString:[[[[[date_selected stringByAppendingString:@" ("]stringByAppendingString:[[lessontimingarray objectAtIndex:i]valueForKey:@"start_time"]]stringByAppendingString:@"-"]stringByAppendingString:[[lessontimingarray objectAtIndex:i]valueForKey:@"finish_time"]]stringByAppendingString:@")"]];
            }
            
        }
        
        viewEnrollView.datetimeValue.text = courseDateTime;
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        NSString *st_date = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"EventSession"] valueForKey:@"start_date"];
        
        if (![st_date isEqualToString:@""]) {
            
            st_date = [dateConversion convertDate:st_date];
        }
        
        NSString *fi_date = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"EventSession"] valueForKey:@"finish_date"];
        
        if (![fi_date isEqualToString:@""]) {
            
            fi_date = [dateConversion convertDate:fi_date];
        }
        
        if (![st_date isEqual:@""] && ![fi_date isEqual:@""] ) {
            
            st_date = [[st_date stringByAppendingString:@"-"]stringByAppendingString:fi_date];
        }
        else if ([st_date isEqual:@""]){
            
            st_date = fi_date;
            
        }
        
        st_date = [st_date stringByAppendingString:@" ( "];
        
        st_date = [st_date stringByAppendingString:[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"EventSession"] valueForKey:@"start_time"]];
        
        st_date = [st_date stringByAppendingString:@" - "];
        
        st_date = [st_date stringByAppendingString:[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"EventSession"] valueForKey:@"finish_time"]];
        
        st_date = [st_date stringByAppendingString: @" )"];
        
        viewEnrollView.datetimeValue.text = st_date;
        
        NSString *adult =[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"]valueForKey:@"adult"];
        
        NSString *child =[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"]valueForKey:@"child"];
        
        viewEnrollView.forValue.text = [[[name stringByAppendingString:@" ("]stringByAppendingString:[NSString stringWithFormat:@"Adult %@, ",adult]]stringByAppendingString:[NSString stringWithFormat:@"Child %@)",child]];
        
        viewEnrollView.teachingMethodLbl.text = @"Type of Event";
        
        viewEnrollView.courseDurationLbl.text = @"Event Duration";
        
        viewEnrollView.courseLbl.text = @"Event Entry Fees";
        
        list_duration_hours = @"event_duration_hours";
        
        list_duration_minutes = @"event_duration_minutes";
        
        listing = @"EventSession";
        
        list_type = @"Event";
        
        list_name = @"event_name";
        
        list = @"EventListing";
        
        method_type =@"type";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        viewEnrollView.courseDurationLbl.text = @"Lesson Duration";
        
        viewEnrollView.courseLbl.text = @"Lesson Fees";
        
        list_duration_hours = @"lesson_duration_hours";
        
        list_duration_minutes = @"lesson_duration_minutes";
        
        listing = @"LessonSession";
        
        list_type = @"Lesson";
        
        list_name = @"lesson_name";
        
        list = @"LessonListing";
        
        method_type =@"lesson_type";
        
        enrollment_id = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:list] valueForKey:@"enrollment"];
        
        if ([enrollment_id isEqual:@"4"]) {
            
           viewEnrollView.paymentTerm_Value.text = @"For continuous enrolments of more than four (4) lessons, the 1st payment will include ONE lesson fee plus other fees such as books, materials, deposit and others (if applicable). The 2nd payment onwards will be charged automatically, weekly and in advance using the same payment method used on the 1st payment, and will only include one lesson fee at a time. For four (4) lessons or less of continuous enrolment, payment of all lesson fees plus other fees such as books, materials, deposit and others (if applicable) is required in advance in one payment transaction.";
          
            
        }
        else{
            
           viewEnrollView.paymentTerm_Value.text = @"For enrolments of a set number of lessons only, OR enrolments of four (4) lessons or less: Payment of all lesson fees plus other charges such as books, materials, deposit and others (if applicable) is required in advance in one payment transaction. For continuous and infinite enrolments without a set end-date: Payment of ONE lesson fee plus other fees such as books, materials, deposit and others (if applicable) is required in the 1st payment, and the 2nd payment onwards will be charged automatically, weekly and in advance using the same payment method used on the 1st payment, and will only include one lesson fee at a time.";
            
        }
        
        NSString *st_date = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"select_date"]valueForKey:@"date_starting"];
        
        NSString *fi_date = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"select_date"]valueForKey:@"date_finished"];
        
        if (![st_date isEqual:@""] && ![fi_date isEqual:@""] ) {
            
            st_date = [[st_date stringByAppendingString:@"-"]stringByAppendingString:fi_date];
        }
        else if ([st_date isEqual:@""]){
            
            st_date = fi_date;
            
        }
        
        st_date = [st_date stringByAppendingString:@" ( "];
        
        st_date = [st_date stringByAppendingString:[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"]valueForKey:@"lesson_stime"]];
        
        st_date = [st_date stringByAppendingString:@" - "];
        
        st_date = [st_date stringByAppendingString:[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"]valueForKey:@"lesson_ftime"]];
        
        st_date = [st_date stringByAppendingString: @" )"];
        
        viewEnrollView.datetimeValue.text = st_date;
        
        NSString *slctdday = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"select_date"]valueForKey:@"day"];
        
        if ([slctdday isEqualToString:@"Mon"]) {
            
            slctdday = @"Monday";
        }
        else if ([slctdday isEqualToString:@"Tue"]){
            
            slctdday = @"Tuesday";
            
        }
        else if ([slctdday isEqualToString:@"Wed"]){
            
            slctdday = @"Wednesday";
        }
        else if ([slctdday isEqualToString:@"Thu"]){
            
            slctdday = @"Thursday";
        }
        else if ([slctdday isEqualToString:@"Fri"]){
            
            slctdday = @"Friday";
        }
        else if ([slctdday isEqualToString:@"Sat"]){
            
            slctdday = @"Saturday";
        }
        else if ([slctdday isEqualToString:@"Sun"]){
            
            slctdday = @"Sunday";
        }
        else{
            
            slctdday = @"";
        }
        
        slctdday = [slctdday stringByAppendingString:@" ( "];
        
        slctdday = [slctdday stringByAppendingString:[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"]valueForKey:@"lesson_stime"]];
        
        slctdday = [slctdday stringByAppendingString:@" - "];
        
        slctdday = [slctdday stringByAppendingString:[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"]valueForKey:@"lesson_ftime"]];
        
        slctdday = [slctdday stringByAppendingString: @" )"];
        
        viewEnrollView.sessionOptnValue.text = slctdday;

    }
    
    viewEnrollView.totalChargeslbl.text = @"Date of Birth";
    
    viewEnrollView.detailValue.text =[[NSString stringWithFormat:@"[%@] ",list_type]stringByAppendingString:[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:list] valueForKey:list_name]];
    
    viewEnrollView.educatorValue.text = [[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"]valueForKey:@"educator_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    viewEnrollView.sessionValue.text = [[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"session_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    viewEnrollView.referenceValue.text = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"reference_code"];
    
    NSString *hours_str = [[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:list] valueForKey:list_duration_hours]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([hours_str isEqual:@""]) {
        
        hours_str = @"";
    }
    
    else{
        
        hours_str = [hours_str stringByAppendingString:@" Hours "];
    }
    
    NSString *mint_str = [[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:list] valueForKey:list_duration_minutes]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([mint_str isEqual:@""]) {
        
        mint_str =@"";
    }
    else{
        
        mint_str = [mint_str stringByAppendingString:@" Minutes"];
    }
    
    viewEnrollView.coursedurationValue.text = [hours_str stringByAppendingString:mint_str];
    
    NSString *methodType = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:list] valueForKey:method_type];
    
    if ([typeStr isEqual:@"2"]) {
        
        if ([methodType isEqual:@"3"]){
            
            viewEnrollView.teachingMethodValue.text = @"Open Day";
        }
        
        else if ([methodType isEqual:@"4"]){
            
            viewEnrollView.teachingMethodValue.text = @"Exhibition";
        }
        
        else if ([methodType isEqual:@"5"]){
            
            viewEnrollView.teachingMethodValue.text = @"Performance";
        }
        
        else if ([methodType isEqual:@"6"]){
            
            viewEnrollView.teachingMethodValue.text = @"Workshop Day";
        }
        
        else if ([methodType isEqual:@"7"]){
            
            viewEnrollView.teachingMethodValue.text = @"Promotion";
        }
        
        else if ([methodType isEqual:@"8"]){
            
            viewEnrollView.teachingMethodValue.text = @"Seminar";
        }
        
        else if ([methodType isEqual:@"9"]){
            
            viewEnrollView.teachingMethodValue.text = @"Competition";
        }
        
        else{
            
            viewEnrollView.teachingMethodValue.text =@"";
        }

        
        
    }
    
    else if ([typeStr isEqual:@"3"]){
        
        if ([methodType  isEqual:@"1"]) {
            
            viewEnrollView.teachingMethodValue.text = @"Private Tutorial Lesson.";
        }
        
        else if ([methodType isEqual:@"2"]){
            
            viewEnrollView.teachingMethodValue.text = @"Group Lesson";
        }
        else if ([methodType  isEqual:@"3"]) {
            
            viewEnrollView.teachingMethodValue.text = @"Online Private Tutorial Lesson.";
        }
        
        else if ([methodType isEqual:@"4"]){
            
            viewEnrollView.teachingMethodValue.text = @"Online Group Lesson.";
        }
        
        
    }
    
    else{
        
        if ([methodType  isEqual:@"2"]) {
            
            viewEnrollView.teachingMethodValue.text = @"Conducted in person, either face-to-face individually or in a group.";
        }
        
        else if ([methodType isEqual:@"1"]){
            
            viewEnrollView.teachingMethodValue.text = @"An online or automated course, via Skype or other online medium.";
        }
    }
    
    NSString *mainlanguage =[[[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"main_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]stringByAppendingString:@" (Main)"];
    
    NSString *supported_language =[[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"supported_language"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (![supported_language isEqualToString:@""]) {
        
        mainlanguage = [[[mainlanguage stringByAppendingString:@", "]stringByAppendingString:supported_language]stringByAppendingString:@" (Supporting)"];
        
    }
    
    viewEnrollView.languageMediumValue.text = [mainlanguage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    viewEnrollView.codeofconductValue.text = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.";
    
    viewEnrollView.paymentddlneValue.text = [[[[myEnrollArray objectAtIndex:sender.tag]valueForKey:@"terms"]valueForKey:@"payment_deadline_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    viewEnrollView.makeuplessonsValue.text = [[[[myEnrollArray objectAtIndex:sender.tag]valueForKey:@"terms"]valueForKey:@"make_up_lessons_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    viewEnrollView.refundValue.text = [[[[myEnrollArray objectAtIndex:sender.tag]valueForKey:@"terms"]valueForKey:@"refund_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    viewEnrollView.depositValue.text = [[[[myEnrollArray objectAtIndex:sender.tag]valueForKey:@"terms"]valueForKey:@"deposit_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    viewEnrollView.cancelationValue.text = [[[[myEnrollArray objectAtIndex:sender.tag]valueForKey:@"terms"]valueForKey:@"cancellation_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    viewEnrollView.changesenrlmntValue.text = [[[[myEnrollArray objectAtIndex:sender.tag]valueForKey:@"terms"]valueForKey:@"change_enrollment_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
//    if ([typeStr isEqual:@"1"]) {
//        
//        NSString *start_date = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"start_date"];
//        
//        if ([start_date isEqualToString:@""]) {
//            
//            start_date = @"";
//        }
//        else{
//            
//            start_date = [dateConversion convertDate:start_date];
//            
//        }
//        
//        NSString *finish_date = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"finish_date"];
//        
//        if ([finish_date isEqualToString:@""]) {
//            
//            finish_date = @"";
//        }
//        else{
//            
//            finish_date = [dateConversion convertDate:finish_date];
//            
//        }
//        
//        viewEnrollView.datetimeValue.text = [[start_date stringByAppendingString:@" - "]stringByAppendingString:finish_date];
//    }
    
    NSString *type = [[[myEnrollArray objectAtIndex:sender.tag]valueForKey:list]valueForKey:method_type];
    
    NSString *venu_street = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"venu_street"];
    
    if ([venu_street isEqualToString:@""]) {
        
        venu_street =@"";
    }
    
    else{
        
        venu_street = [venu_street stringByAppendingString:@", "];
    }
    
    NSString *venu_district =[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"venu_district"];
    
    if ([venu_district isEqualToString:@""]) {
        
        venu_district =@"";
    }
    
    else{
        
        venu_district = [venu_district stringByAppendingString:@", "];
    }
    
    NSString *city_name =[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"] valueForKey:@"city_name"];
    
    if ([city_name isEqualToString:@""]) {
        
        city_name =@"";
    }
    
    else{
        
        city_name = [city_name stringByAppendingString:@", "];
    }
    
    NSString *state_name =[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"] valueForKey:@"state_name"];
    
    if ([state_name isEqualToString:@""]) {
        
        state_name =@"";
    }
    
    else{
        
        state_name = [state_name stringByAppendingString:@", "];
    }
    
    NSString *country_name =[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"] valueForKey:@"country_name"];
    
    if ([country_name isEqualToString:@""]) {
        
        country_name =@"";
    }
    
    else{
        
        country_name = [country_name stringByAppendingString:@"."];
    }
    
    
    
    
    if ([type isEqual:@"1"] || [type isEqual:@"3"] || [type isEqual:@"4"]) {
        
        viewEnrollView.venueValue.text = [@"Online | "stringByAppendingString:[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"] valueForKey:@"city_name"]];
        
    }
    else{
        
        viewEnrollView.venueValue.text =[[[[venu_street stringByAppendingString:venu_district]stringByAppendingString:city_name]stringByAppendingString:state_name]stringByAppendingString:country_name];
        
    }
    
    NSString *booking_date = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"booking_date"];
    
    if ([booking_date isEqualToString:@""]) {
        
        booking_date = @"";
    }
    else{
    
        booking_date = [dateConversion convertDate:booking_date];
        
    }
    
    viewEnrollView.enrollmentdateValue.text = booking_date;
    
//    viewEnrollView.totalChargesValue.text = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"total_charges"];
    
    viewEnrollView.genderValue.text = [[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"] valueForKey:@"gender_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
//    NSString *severeString =[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:list] valueForKey:@"severe_weather"];
//    
//    NSArray *severeArray = [severeString componentsSeparatedByString:@","];
//    
//    severeString = @"";
//    
//    for (int i = 0; i< severeArray.count; i++) {
//        
//        if ([[severeArray objectAtIndex:i]integerValue] == 0) {
//            
//            severeString =[severeString stringByAppendingString:@"Lessons are not held during severe weather warnings such as Typhoon 8 and Black Rain Storm Warnings.\n"];
//            
//        }
//        
//        else if ([[severeArray objectAtIndex:i]integerValue] == 1){
//            
//            severeString = [severeString stringByAppendingString:@"Make-up lessons can be arranged due to forced closures under certain circumstances.\n"];
//        }
//        
//        else if ([[severeArray objectAtIndex:i]integerValue] == 2){
//            
//            severeString = [severeString stringByAppendingString:@"Make-up classes cannot be arranged due to forced closures.\n"];
//        }
//        
//        else if ([[severeArray objectAtIndex:i]integerValue] == 3){
//            
//            severeString = [severeString stringByAppendingString:@"The event is not held during severe weather warnings such as Typhoon 8 and Black Rain Storm Warnings.\n"];
//        }
//        
//        else if ([[severeArray objectAtIndex:i]integerValue] == 4){
//            
//            severeString = [severeString stringByAppendingString:@"Make-up sessions can be arranged due to forced cancellation under certail circumstances.\n"];
//        }
//        
//        else if ([[severeArray objectAtIndex:i]integerValue] == 5){
//            
//            severeString = [severeString stringByAppendingString:@"Make-up sessions cannot be arranged due to forced cancellations.\n"];
//        }
//        
//        else if([[severeArray objectAtIndex:i]integerValue] == 6){
//            
//            severeString = [severeString stringByAppendingString:@"Course will still continue.\n"];
//        }
//                 
//        else if([[severeArray objectAtIndex:i]integerValue] == 7){
//                     
//        severeString = [severeString stringByAppendingString:@"Lesson will still continue.\n"];
//            
//                 }
//    }
    
//    NSString *age_group =[[[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:list] valueForKey:@"Sessions"]valueForKey:@"age_group"]objectAtIndex:0];
//    
//    NSArray *age_groupArray = [age_group componentsSeparatedByString:@","];
//    
//    age_group = @"";
//    
//    for (int i = 0; i< age_groupArray.count; i++) {
//        
//        if ([[age_groupArray objectAtIndex:i]integerValue] == 1) {
//            
//            age_group =[age_group stringByAppendingString:@"Babies (0 - 1 yrs.)\n"];
//            
//        }
//        
//        else if ([[age_groupArray objectAtIndex:i]integerValue] == 2){
//            
//            age_group = [age_group stringByAppendingString:@"Toddlers (1 - 2 yrs.)\n"];
//        }
//        
//        else if ([[age_groupArray objectAtIndex:i]integerValue] == 3){
//            
//            age_group = [age_group stringByAppendingString:@"Pre-School Children (2 - 5 yrs.)\n"];
//        }
//        
//        else if ([[age_groupArray objectAtIndex:i]integerValue] == 4){
//            
//            age_group = [age_group stringByAppendingString:@"Early Primary Students (5 - 7 yrs.)\n"];
//        }
//        
//        else if ([[age_groupArray objectAtIndex:i]integerValue] == 5){
//            
//            age_group = [age_group stringByAppendingString:@"Primary Students (7 - 12 yrs.)\n"];
//        }
//        
//        else if ([[age_groupArray objectAtIndex:i]integerValue] == 6){
//            
//            age_group = [age_group stringByAppendingString:@"Early Secondary Students (12 - 14 yrs.\n"];
//        }
//        
//        else if([[age_groupArray objectAtIndex:i]integerValue] == 7){
//            
//            age_group = [age_group stringByAppendingString:@"Secondary Students (15 - 18 yrs.).\n"];
//        }
//        
//        else if([[age_groupArray objectAtIndex:i]integerValue] == 8){
//            
//            age_group = [age_group stringByAppendingString:@"Tertiary Students (18 yrs. +)\n"];
//            
//        }
//        
//        else if([[age_groupArray objectAtIndex:i]integerValue] == 9){
//            
//            age_group = [age_group stringByAppendingString:@"Professional Students (18 yrs. +)\n"];
//        }
//        
//        else if([[age_groupArray objectAtIndex:i]integerValue] == 10){
//            
//            age_group = [age_group stringByAppendingString:@"Adult Students (18 yrs. +)\n"];
//            
//        }
//    }
    viewEnrollView.enrollment_value.text = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"] valueForKey:@"enrollment_data"];
    
    viewEnrollView.ageGroupValue.text = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"] valueForKey:@"age_name"];

    viewEnrollView.severeWeatherValue.text = [[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"] valueForKey:@"severe_weather_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    viewEnrollView.referenceValue.text = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"reference_code"];
    
    NSString *status = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"status"];
    
    NSString *birth =[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Family"] valueForKey:@"birth_date"];
    
    if ([birth isEqual:@""] || birth == nil) {
        
        birth =[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"birth_date"];
        
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    ageyears = [self calculateYears:[formatter dateFromString:birth]];
    
    viewEnrollView.totalChargesValue.text = [[dateConversion convertDate:birth]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //   1'=>'Waiting for acceptance',  '2'=>'Accept Enrollment/Booking  Request','3'=>'Confirmed(Automatically after  payment)', '4'=>'Recurring payment cancel by user, '5'=>'Recuring  payment cancel by paypal business account holder','6'=>'Do not accept  Enrollment/Booking Request','7'=>Cancel By educator,'8'=>cancel  by student
    ///Smily
    
    if ([status isEqualToString:@"1"]) {
        
        status = @"Waiting";
        
    } else if ([status isEqualToString:@"2"]) {
        
        status = @"Accepted/Please Pay";
        
    } else if ([status isEqualToString:@"3"]) {
        
        status = @"Confirmed";
        
    } else if ([status isEqualToString:@"4"]) {
        
        status = @"Recurring payment cancel by user";
        
    } else if ([status isEqualToString:@"5"]) {
        
        status = @"Recuring  payment cancel by paypal business account holder";
        
    } else if ([status isEqualToString:@"6"]) {
        
        status = @"Can't Confirm";
        
    } else if ([status isEqualToString:@"7"]) {
        
        status = @"Requested to Cancel";
        
    } else if ([status isEqualToString:@"8"]) {
        
        status = @"Cancelled";
    }
    
    viewEnrollView.statusValue.text = status;
    
    NSString *payment_status = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"payment_status"];
    
    if ([payment_status isEqualToString:@"0"]) {
        
        payment_status = @"Payment Pending";
        
    } else if ([payment_status isEqualToString:@"1"]) {
        
        payment_status = @"Paid";
        
    }
    
   // viewEnrollView.paymentddlneValue.text = payment_status;
    
    NSString *currencyStr = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"currency_other"];
    
    currencyStr = [currencyStr stringByAppendingString:@" "];
    
    NSString *price = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"book_materials_charges"];
    
    if ([price isEqualToString:@""]) {
        
        price = @"0";
    }
    
    price = [currencyStr stringByAppendingString:price];
    
    viewEnrollView.books_matPrice.text = price;
    
    price = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"security_charges"];
    
    if ([price isEqualToString:@""]) {
        
        price = @"0";
    }
    
    price = [currencyStr stringByAppendingString:price];
    
    viewEnrollView.security.text = price;
    
    price = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"other_charges"];
    
    if ([price isEqualToString:@""]) {
        
        price = @"0";
    }
    
    
    
    NSString *currency_name= [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Currency"] valueForKey:@"name"];
    
    price = [[price stringByAppendingString:@" "] stringByAppendingString:currency_name];
    
//    viewEnrollView.totalChargesValue.text = price;
    
    price = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"fee_quantity"];
    
    if ([price isEqualToString:@""]) {
        
        price = @"0";
    }
    
    price = [currency_name stringByAppendingString:[@" " stringByAppendingString:price]];
    
    viewEnrollView.courseValue.text = price;
    
    CGRect Frame = viewEnrollView.ForLbl.frame;
    
    Frame.origin.y = 5;
    
    viewEnrollView.ForLbl.frame = Frame;
    
    [viewEnrollView.ForLbl sizeToFit];
    
    Frame = viewEnrollView.forValue.frame;
    
    Frame.origin.y = viewEnrollView.ForLbl.frame.origin.y;
    
    viewEnrollView.forValue.frame = Frame;
    
    [viewEnrollView.forValue sizeToFit];
    
    if (ageyears <=18) {
        
        Frame = viewEnrollView.totalChargeslbl.frame;
        
        if (viewEnrollView.ForLbl.frame.size.height > viewEnrollView.forValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.ForLbl.frame.origin.y + viewEnrollView.ForLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.forValue.frame.origin.y + viewEnrollView.forValue.frame.size.height +5;
        }
        
        viewEnrollView.totalChargeslbl.frame = Frame;
        
        [viewEnrollView.totalChargeslbl sizeToFit];
        
        Frame = viewEnrollView.totalChargesValue.frame;
        
        Frame.origin.y = viewEnrollView.totalChargeslbl.frame.origin.y;
        
        viewEnrollView.totalChargesValue.frame = Frame;
        
        [viewEnrollView.totalChargesValue sizeToFit];
        
    }
    
    else{
        
        viewEnrollView.totalChargeslbl.hidden = YES;
        
        viewEnrollView.totalChargesValue.hidden = YES;
        
        viewEnrollView.totalChargeslbl.frame = viewEnrollView.ForLbl.frame;
        
        viewEnrollView.totalChargesValue.frame = viewEnrollView.forValue.frame;
    }
    
    Frame = viewEnrollView.detailLbl.frame;
    
    if (viewEnrollView.totalChargeslbl.frame.size.height > viewEnrollView.forValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.totalChargeslbl.frame.origin.y + viewEnrollView.totalChargeslbl.frame.size.height +5;
    }
    else{
    
    Frame.origin.y = viewEnrollView.totalChargesValue.frame.origin.y + viewEnrollView.totalChargesValue.frame.size.height +5;
    }
    
    viewEnrollView.detailLbl.frame = Frame;
    
    [viewEnrollView.detailLbl sizeToFit];
    
    Frame = viewEnrollView.detailValue.frame;
    
    Frame.origin.y = viewEnrollView.detailLbl.frame.origin.y ;
    
    viewEnrollView.detailValue.frame = Frame;
    
    [viewEnrollView.detailValue sizeToFit];
    
    Frame = viewEnrollView.educatorLbl.frame;
    
    if (viewEnrollView.detailLbl.frame.size.height > viewEnrollView.detailValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.detailLbl.frame.origin.y + viewEnrollView.detailLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.detailValue.frame.origin.y + viewEnrollView.detailValue.frame.size.height +5;
    }
    
    viewEnrollView.educatorLbl.frame = Frame;
    
    [viewEnrollView.educatorLbl sizeToFit];
    
    Frame = viewEnrollView.educatorValue.frame;
    
    Frame.origin.y = viewEnrollView.educatorLbl.frame.origin.y ;
    
    viewEnrollView.educatorValue.frame = Frame;
    
    [viewEnrollView.educatorValue sizeToFit];
    
    Frame = viewEnrollView.sessionLbl.frame;
    
    if (viewEnrollView.educatorLbl.frame.size.height > viewEnrollView.educatorValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.educatorLbl.frame.origin.y + viewEnrollView.educatorLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.educatorValue.frame.origin.y + viewEnrollView.educatorValue.frame.size.height +5;
    }
    
    viewEnrollView.sessionLbl.frame = Frame;
    
    [viewEnrollView.sessionLbl sizeToFit];
    
    Frame = viewEnrollView.sessionValue.frame;
    
    Frame.origin.y = viewEnrollView.sessionLbl.frame.origin.y ;
    
    viewEnrollView.sessionValue.frame = Frame;
    
    [viewEnrollView.sessionValue sizeToFit];
    
    Frame = viewEnrollView.referenceIdLbl.frame;
    
    if (viewEnrollView.sessionLbl.frame.size.height > viewEnrollView.sessionValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.sessionLbl.frame.origin.y + viewEnrollView.sessionLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.sessionValue.frame.origin.y + viewEnrollView.sessionValue.frame.size.height +5;
    }
    
    viewEnrollView.referenceIdLbl.frame = Frame;
    
    [viewEnrollView.referenceIdLbl sizeToFit];
    
    Frame = viewEnrollView.referenceValue.frame;
    
    Frame.origin.y = viewEnrollView.referenceIdLbl.frame.origin.y ;
    
    viewEnrollView.referenceValue.frame = Frame;
    
    [viewEnrollView.referenceValue sizeToFit];
    
    Frame = viewEnrollView.courseDurationLbl.frame;
    
    if (viewEnrollView.referenceIdLbl.frame.size.height > viewEnrollView.referenceValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.referenceIdLbl.frame.origin.y + viewEnrollView.referenceIdLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.referenceValue.frame.origin.y + viewEnrollView.referenceValue.frame.size.height +5;
    }
    
    viewEnrollView.courseDurationLbl.frame = Frame;
    
    [viewEnrollView.courseDurationLbl sizeToFit];
    
    Frame = viewEnrollView.coursedurationValue.frame;
    
    Frame.origin.y = viewEnrollView.courseDurationLbl.frame.origin.y ;
    
    viewEnrollView.coursedurationValue.frame = Frame;
    
    [viewEnrollView.coursedurationValue sizeToFit];
    
    Frame = viewEnrollView.teachingMethodLbl.frame;
    
    if (viewEnrollView.courseDurationLbl.frame.size.height > viewEnrollView.coursedurationValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.courseDurationLbl.frame.origin.y + viewEnrollView.courseDurationLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.coursedurationValue.frame.origin.y + viewEnrollView.coursedurationValue.frame.size.height +5;
    }
    
    viewEnrollView.teachingMethodLbl.frame = Frame;
    
    [viewEnrollView.teachingMethodLbl sizeToFit];
    
    Frame = viewEnrollView.teachingMethodValue.frame;
    
    Frame.origin.y = viewEnrollView.teachingMethodLbl.frame.origin.y;
    
    viewEnrollView.teachingMethodValue.frame = Frame;
    
    [viewEnrollView.teachingMethodValue sizeToFit];
    
    Frame = viewEnrollView.languagemediumLbl.frame;
    
    if (viewEnrollView.teachingMethodLbl.frame.size.height > viewEnrollView.teachingMethodValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.teachingMethodLbl.frame.origin.y + viewEnrollView.teachingMethodLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.teachingMethodValue.frame.origin.y + viewEnrollView.teachingMethodValue.frame.size.height +5;
    }
    
    viewEnrollView.languagemediumLbl.frame = Frame;
    
    [viewEnrollView.languagemediumLbl sizeToFit];
    
    Frame = viewEnrollView.languageMediumValue.frame;
    
    Frame.origin.y = viewEnrollView.languagemediumLbl.frame.origin.y ;
    
    viewEnrollView.languageMediumValue.frame = Frame;
    
    [viewEnrollView.languageMediumValue sizeToFit];
    
    Frame = viewEnrollView.genderLbl.frame;
    
    if (viewEnrollView.languagemediumLbl.frame.size.height > viewEnrollView.languageMediumValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.languagemediumLbl.frame.origin.y + viewEnrollView.languagemediumLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.languageMediumValue.frame.origin.y + viewEnrollView.languageMediumValue.frame.size.height +5;
    }
    
    viewEnrollView.genderLbl.frame = Frame;
    
    [viewEnrollView.genderLbl sizeToFit];
    
    Frame = viewEnrollView.genderValue.frame;
    
    Frame.origin.y = viewEnrollView.genderLbl.frame.origin.y;
    
    viewEnrollView.genderValue.frame = Frame;
    
    [viewEnrollView.genderValue sizeToFit];
    
    Frame = viewEnrollView.agegroupLbl.frame;
    
    if (viewEnrollView.genderLbl.frame.size.height > viewEnrollView.genderValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.genderLbl.frame.origin.y + viewEnrollView.genderLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.genderValue.frame.origin.y + viewEnrollView.genderValue.frame.size.height +5;
    }
    
    viewEnrollView.agegroupLbl.frame = Frame;
    
    [viewEnrollView.agegroupLbl sizeToFit];
    
    Frame = viewEnrollView.ageGroupValue.frame;
    
    Frame.origin.y = viewEnrollView.agegroupLbl.frame.origin.y ;
    
    viewEnrollView.ageGroupValue.frame = Frame;
    
    [viewEnrollView.ageGroupValue sizeToFit];
    
    if ([typeStr isEqualToString:@"3"]) {
        
        Frame = viewEnrollView.sessionOptnLbl.frame;
        
        if (viewEnrollView.agegroupLbl.frame.size.height > viewEnrollView.ageGroupValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.agegroupLbl.frame.origin.y + viewEnrollView.agegroupLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.ageGroupValue.frame.origin.y + viewEnrollView.ageGroupValue.frame.size.height +5;
        }
        
        viewEnrollView.sessionOptnLbl.frame = Frame;
        
        [viewEnrollView.sessionOptnLbl sizeToFit];
        
        Frame = viewEnrollView.sessionOptnValue.frame;
        
        Frame.origin.y = viewEnrollView.sessionOptnLbl.frame.origin.y ;
        
        viewEnrollView.sessionOptnValue.frame = Frame;
        
        [viewEnrollView.sessionOptnValue sizeToFit];

    }
    else{
        
        viewEnrollView.sessionOptnValue.hidden = YES;
        
        viewEnrollView.sessionOptnLbl.hidden = YES;
        
        viewEnrollView.sessionOptnValue.frame =viewEnrollView.ageGroupValue.frame;
        
        viewEnrollView.sessionOptnLbl.frame =viewEnrollView.agegroupLbl.frame;
    }
    
    NSString *fi_date = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"select_date"]valueForKey:@"date_finished"];
    
    if ([typeStr isEqualToString:@"3"] && [fi_date isEqualToString:@"Infinite"]) {
        
        viewEnrollView.dateTimeLbl.hidden = YES;
        
        viewEnrollView.datetimeValue.hidden = YES;
        
        viewEnrollView.datetimeValue.frame =viewEnrollView.sessionOptnLbl.frame;
        
        viewEnrollView.dateTimeLbl.frame =viewEnrollView.sessionOptnValue.frame;
        
        
    }
    else{
    
    Frame = viewEnrollView.dateTimeLbl.frame;
    
    if (viewEnrollView.sessionOptnLbl.frame.size.height > viewEnrollView.sessionOptnValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.sessionOptnLbl.frame.origin.y + viewEnrollView.sessionOptnLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.sessionOptnValue.frame.origin.y + viewEnrollView.sessionOptnValue.frame.size.height +5;
    }
    
    viewEnrollView.dateTimeLbl.frame = Frame;
    
    [viewEnrollView.dateTimeLbl sizeToFit];
    
    Frame = viewEnrollView.datetimeValue.frame;
    
    Frame.origin.y = viewEnrollView.dateTimeLbl.frame.origin.y ;
    
    viewEnrollView.datetimeValue.frame = Frame;
    
    [viewEnrollView.datetimeValue sizeToFit];
        
    }
    
    Frame = viewEnrollView.venueLbl.frame;
    
    if (viewEnrollView.dateTimeLbl.frame.size.height > viewEnrollView.datetimeValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.dateTimeLbl.frame.origin.y + viewEnrollView.dateTimeLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.datetimeValue.frame.origin.y + viewEnrollView.datetimeValue.frame.size.height +5;
    }
    
    viewEnrollView.venueLbl.frame = Frame;
    
    [viewEnrollView.venueLbl sizeToFit];
    
    Frame = viewEnrollView.venueValue.frame;
    
    Frame.origin.y = viewEnrollView.venueLbl.frame.origin.y ;
    
    viewEnrollView.venueValue.frame = Frame;
    
    [viewEnrollView.venueValue sizeToFit];
    
    Frame = viewEnrollView.enrollmentdateLbl.frame;
    
    if (viewEnrollView.venueLbl.frame.size.height > viewEnrollView.venueValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.venueLbl.frame.origin.y + viewEnrollView.venueLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.venueValue.frame.origin.y + viewEnrollView.venueValue.frame.size.height +5;
    }
    
    viewEnrollView.enrollmentdateLbl.frame = Frame;
    
    [viewEnrollView.enrollmentdateLbl sizeToFit];
    
    Frame = viewEnrollView.enrollmentdateValue.frame;
    
    Frame.origin.y = viewEnrollView.enrollmentdateLbl.frame.origin.y ;
    
    viewEnrollView.enrollmentdateValue.frame = Frame;
    
    [viewEnrollView.enrollmentdateValue sizeToFit];
    
    Frame = viewEnrollView.statusLbl.frame;
    
    if (viewEnrollView.enrollmentdateLbl.frame.size.height > viewEnrollView.enrollmentdateValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.enrollmentdateLbl.frame.origin.y + viewEnrollView.enrollmentdateLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.enrollmentdateValue.frame.origin.y + viewEnrollView.enrollmentdateValue.frame.size.height +5;
    }
    
    viewEnrollView.statusLbl.frame = Frame;
    
    [viewEnrollView.statusLbl sizeToFit];
    
    Frame = viewEnrollView.statusValue.frame;
    
    Frame.origin.y = viewEnrollView.statusLbl.frame.origin.y ;
    
    viewEnrollView.statusValue.frame = Frame;
    
    [viewEnrollView.statusValue sizeToFit];
    
    Frame = viewEnrollView.courseLbl.frame;
    
    if (viewEnrollView.statusLbl.frame.size.height > viewEnrollView.statusValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.statusLbl.frame.origin.y + viewEnrollView.statusLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.statusValue.frame.origin.y + viewEnrollView.statusValue.frame.size.height +5;
    }
    
    viewEnrollView.courseLbl.frame = Frame;
    
    [viewEnrollView.courseLbl sizeToFit];
    
    Frame = viewEnrollView.courseValue.frame;
    
    Frame.origin.y = viewEnrollView.courseLbl.frame.origin.y ;
    
    viewEnrollView.courseValue.frame = Frame;
    
    [viewEnrollView.courseValue sizeToFit];
    
    Frame = viewEnrollView.educatorTandClbl.frame;
    
    if (viewEnrollView.courseLbl.frame.size.height > viewEnrollView.courseValue.frame.size.height) {
        
        Frame.origin.y = viewEnrollView.courseLbl.frame.origin.y + viewEnrollView.courseLbl.frame.size.height +5;
    }
    else{
        
        Frame.origin.y = viewEnrollView.courseValue.frame.origin.y + viewEnrollView.courseValue.frame.size.height +5;
    }
    
    viewEnrollView.educatorTandClbl.frame = Frame;
    
    [viewEnrollView.educatorTandClbl sizeToFit];
    
    if ([typeStr isEqualToString:@"3"]) {
        
        viewEnrollView.changesenrolmntLbl.hidden = YES;
        
        viewEnrollView.changesenrlmntValue.hidden = YES;
        
        Frame = viewEnrollView.enrollment_lbl.frame;
        
        Frame.origin.y = viewEnrollView.educatorTandClbl.frame.origin.y + viewEnrollView.educatorTandClbl.frame.size.height +5;
        
        viewEnrollView.enrollment_lbl.frame = Frame;
        
        [viewEnrollView.enrollment_lbl sizeToFit];
        
        Frame = viewEnrollView.enrollment_value.frame;
        
        Frame.origin.y = viewEnrollView.educatorTandClbl.frame.origin.y + viewEnrollView.educatorTandClbl.frame.size.height +5;
        
        viewEnrollView.enrollment_value.frame = Frame;
        
        [viewEnrollView.enrollment_value sizeToFit];
        
        Frame = viewEnrollView.paymentTerm_lbl.frame;
        
        if (viewEnrollView.enrollment_lbl.frame.size.height > viewEnrollView.enrollment_value.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.enrollment_lbl.frame.origin.y + viewEnrollView.enrollment_lbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.enrollment_value.frame.origin.y + viewEnrollView.enrollment_value.frame.size.height +5;
        }
        
        viewEnrollView.paymentTerm_lbl.frame = Frame;
        
        [viewEnrollView.paymentTerm_lbl sizeToFit];
        
        Frame = viewEnrollView.paymentTerm_Value.frame;
        
        Frame.origin.y = viewEnrollView.paymentTerm_lbl.frame.origin.y;
        
        viewEnrollView.paymentTerm_Value.frame = Frame;
        
        [viewEnrollView.paymentTerm_Value sizeToFit];
        
        Frame = viewEnrollView.paymentddlneLbl.frame;
        
        if (viewEnrollView.paymentTerm_lbl.frame.size.height > viewEnrollView.paymentTerm_Value.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.paymentTerm_lbl.frame.origin.y + viewEnrollView.paymentTerm_lbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.paymentTerm_Value.frame.origin.y + viewEnrollView.paymentTerm_Value.frame.size.height +5;
        }
        
        viewEnrollView.paymentddlneLbl.frame = Frame;
        
        [viewEnrollView.paymentddlneLbl sizeToFit];
        
        Frame = viewEnrollView.paymentddlneValue.frame;
        
        Frame.origin.y = viewEnrollView.paymentddlneLbl.frame.origin.y;
        
        viewEnrollView.paymentddlneValue.frame = Frame;
        
        [viewEnrollView.paymentddlneValue sizeToFit];
        
        Frame = viewEnrollView.depositLbl.frame;
        
        if (viewEnrollView.paymentddlneLbl.frame.size.height > viewEnrollView.paymentddlneLbl.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.paymentddlneLbl.frame.origin.y + viewEnrollView.paymentddlneLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.paymentddlneValue.frame.origin.y + viewEnrollView.paymentddlneValue.frame.size.height +5;
        }
        
        viewEnrollView.depositLbl.frame = Frame;
        
        [viewEnrollView.depositLbl sizeToFit];
        
        Frame = viewEnrollView.depositValue.frame;
        
        Frame.origin.y = viewEnrollView.depositLbl.frame.origin.y;
        
        viewEnrollView.depositValue.frame = Frame;
        
        [viewEnrollView.depositValue sizeToFit];
        
        Frame = viewEnrollView.cancellationLbl.frame;
        
        if (viewEnrollView.depositLbl.frame.size.height > viewEnrollView.depositValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.depositLbl.frame.origin.y + viewEnrollView.depositLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.depositValue.frame.origin.y + viewEnrollView.depositValue.frame.size.height +5;
        }
        
        viewEnrollView.cancellationLbl.frame = Frame;
        
        [viewEnrollView.cancellationLbl sizeToFit];
        
        Frame = viewEnrollView.cancelationValue.frame;
        
        Frame.origin.y = viewEnrollView.cancellationLbl.frame.origin.y;
        
        viewEnrollView.cancelationValue.frame = Frame;
        
        [viewEnrollView.cancelationValue sizeToFit];
        
        Frame = viewEnrollView.makeUpLessonsLbl.frame;
        
        if (viewEnrollView.cancellationLbl.frame.size.height > viewEnrollView.cancelationValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.cancellationLbl.frame.origin.y + viewEnrollView.cancellationLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.cancelationValue.frame.origin.y + viewEnrollView.cancelationValue.frame.size.height +5;
        }
        
        viewEnrollView.makeUpLessonsLbl.frame = Frame;
        
        [viewEnrollView.makeUpLessonsLbl sizeToFit];
        
        Frame = viewEnrollView.makeuplessonsValue.frame;
        
        Frame.origin.y = viewEnrollView.makeUpLessonsLbl.frame.origin.y;
        
        viewEnrollView.makeuplessonsValue.frame = Frame;
        
        [viewEnrollView.makeuplessonsValue sizeToFit];
        
        Frame = viewEnrollView.severeWeatherLbl.frame;
        
        if (viewEnrollView.makeUpLessonsLbl.frame.size.height > viewEnrollView.makeuplessonsValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.makeUpLessonsLbl.frame.origin.y + viewEnrollView.makeUpLessonsLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.makeuplessonsValue.frame.origin.y + viewEnrollView.makeuplessonsValue.frame.size.height +5;
        }
        
        viewEnrollView.severeWeatherLbl.frame = Frame;
        
        [viewEnrollView.severeWeatherLbl sizeToFit];
        
        Frame = viewEnrollView.severeWeatherValue.frame;
        
        Frame.origin.y = viewEnrollView.severeWeatherLbl.frame.origin.y;
        
        viewEnrollView.severeWeatherValue.frame = Frame;
        
        [viewEnrollView.severeWeatherValue sizeToFit];
        
        Frame = viewEnrollView.refundLbl.frame;
        
        if (viewEnrollView.severeWeatherLbl.frame.size.height > viewEnrollView.severeWeatherValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.severeWeatherLbl.frame.origin.y + viewEnrollView.severeWeatherLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.severeWeatherValue.frame.origin.y + viewEnrollView.severeWeatherValue.frame.size.height +5;
        }
        
        viewEnrollView.refundLbl.frame = Frame;
        
        [viewEnrollView.refundLbl sizeToFit];
        
        Frame = viewEnrollView.refundValue.frame;
        
        Frame.origin.y = viewEnrollView.refundLbl.frame.origin.y;
        
        viewEnrollView.refundValue.frame = Frame;
        
        [viewEnrollView.refundValue sizeToFit];
    }
    else if([typeStr isEqualToString:@"1"]){
        
        viewEnrollView.enrollment_value.hidden = YES;
        
        viewEnrollView.enrollment_lbl.hidden = YES;
        
        viewEnrollView.paymentTerm_Value.hidden = YES;
        
        viewEnrollView.paymentTerm_lbl.hidden = YES;
        
        Frame = viewEnrollView.paymentddlneLbl.frame;
        
        Frame.origin.y = viewEnrollView.educatorTandClbl.frame.origin.y + viewEnrollView.educatorTandClbl.frame.size.height +5;
        
        viewEnrollView.paymentddlneLbl.frame = Frame;
        
        [viewEnrollView.paymentddlneLbl sizeToFit];
        
        Frame = viewEnrollView.paymentddlneValue.frame;
        
        Frame.origin.y = viewEnrollView.paymentddlneLbl.frame.origin.y;
        
        viewEnrollView.paymentddlneValue.frame = Frame;
        
        [viewEnrollView.paymentddlneValue sizeToFit];
        
        Frame = viewEnrollView.depositLbl.frame;
        
        if (viewEnrollView.paymentddlneLbl.frame.size.height > viewEnrollView.paymentddlneLbl.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.paymentddlneLbl.frame.origin.y + viewEnrollView.paymentddlneLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.paymentddlneValue.frame.origin.y + viewEnrollView.paymentddlneValue.frame.size.height +5;
        }
        
        viewEnrollView.depositLbl.frame = Frame;
        
        [viewEnrollView.depositLbl sizeToFit];
        
        Frame = viewEnrollView.depositValue.frame;
        
        Frame.origin.y = viewEnrollView.depositLbl.frame.origin.y;
        
        viewEnrollView.depositValue.frame = Frame;
        
        [viewEnrollView.depositValue sizeToFit];
        
        Frame = viewEnrollView.changesenrolmntLbl.frame;
        
        if (viewEnrollView.depositLbl.frame.size.height > viewEnrollView.depositValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.depositLbl.frame.origin.y + viewEnrollView.depositLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.depositValue.frame.origin.y + viewEnrollView.depositValue.frame.size.height +5;
        }
        
        viewEnrollView.changesenrolmntLbl.frame = Frame;
        
        [viewEnrollView.changesenrolmntLbl sizeToFit];
        
        Frame = viewEnrollView.changesenrlmntValue.frame;
        
        Frame.origin.y = viewEnrollView.changesenrolmntLbl.frame.origin.y;
        
        viewEnrollView.changesenrlmntValue.frame = Frame;
        
        [viewEnrollView.changesenrlmntValue sizeToFit];
        
        Frame = viewEnrollView.cancellationLbl.frame;
        
        if (viewEnrollView.changesenrolmntLbl.frame.size.height > viewEnrollView.changesenrlmntValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.changesenrolmntLbl.frame.origin.y + viewEnrollView.changesenrolmntLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.changesenrlmntValue.frame.origin.y + viewEnrollView.changesenrlmntValue.frame.size.height +5;
        }
        
        viewEnrollView.cancellationLbl.frame = Frame;
        
        [viewEnrollView.cancellationLbl sizeToFit];
        
        Frame = viewEnrollView.cancelationValue.frame;
        
        Frame.origin.y = viewEnrollView.cancellationLbl.frame.origin.y;
        
        viewEnrollView.cancelationValue.frame = Frame;
        
        [viewEnrollView.cancelationValue sizeToFit];
        
        Frame = viewEnrollView.makeUpLessonsLbl.frame;
        
        if (viewEnrollView.cancellationLbl.frame.size.height > viewEnrollView.cancelationValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.cancellationLbl.frame.origin.y + viewEnrollView.cancellationLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.cancelationValue.frame.origin.y + viewEnrollView.cancelationValue.frame.size.height +5;
        }
        
        viewEnrollView.makeUpLessonsLbl.frame = Frame;
        
        [viewEnrollView.makeUpLessonsLbl sizeToFit];
        
        Frame = viewEnrollView.makeuplessonsValue.frame;
        
        Frame.origin.y = viewEnrollView.makeUpLessonsLbl.frame.origin.y;
        
        viewEnrollView.makeuplessonsValue.frame = Frame;
        
        [viewEnrollView.makeuplessonsValue sizeToFit];
        
        Frame = viewEnrollView.severeWeatherLbl.frame;
        
        if (viewEnrollView.makeUpLessonsLbl.frame.size.height > viewEnrollView.makeuplessonsValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.makeUpLessonsLbl.frame.origin.y + viewEnrollView.makeUpLessonsLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.makeuplessonsValue.frame.origin.y + viewEnrollView.makeuplessonsValue.frame.size.height +5;
        }
        
        viewEnrollView.severeWeatherLbl.frame = Frame;
        
        [viewEnrollView.severeWeatherLbl sizeToFit];
        
        Frame = viewEnrollView.severeWeatherValue.frame;
        
        Frame.origin.y = viewEnrollView.severeWeatherLbl.frame.origin.y;
        
        viewEnrollView.severeWeatherValue.frame = Frame;
        
        [viewEnrollView.severeWeatherValue sizeToFit];
        
        Frame = viewEnrollView.refundLbl.frame;
        
        if (viewEnrollView.severeWeatherLbl.frame.size.height > viewEnrollView.severeWeatherValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.severeWeatherLbl.frame.origin.y + viewEnrollView.severeWeatherLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.severeWeatherValue.frame.origin.y + viewEnrollView.severeWeatherValue.frame.size.height +5;
        }
        
        viewEnrollView.refundLbl.frame = Frame;
        
        [viewEnrollView.refundLbl sizeToFit];
        
        Frame = viewEnrollView.refundValue.frame;
        
        Frame.origin.y = viewEnrollView.refundLbl.frame.origin.y;
        
        viewEnrollView.refundValue.frame = Frame;
        
        [viewEnrollView.refundValue sizeToFit];
        
        
    }
    
    else{
    
        viewEnrollView.enrollment_lbl.hidden = YES;
        
        viewEnrollView.enrollment_value.hidden = YES;
        
        viewEnrollView.paymentTerm_lbl.hidden = YES;
        
        viewEnrollView.paymentTerm_Value.hidden = YES;
        
        viewEnrollView.depositLbl.hidden = YES;
        
        viewEnrollView.depositValue.hidden = YES;
        
        Frame = viewEnrollView.paymentddlneLbl.frame;
        
        Frame.origin.y = viewEnrollView.educatorTandClbl.frame.origin.y + viewEnrollView.educatorTandClbl.frame.size.height +5;
        
        viewEnrollView.paymentddlneLbl.frame = Frame;
        
        [viewEnrollView.paymentddlneLbl sizeToFit];
        
        Frame = viewEnrollView.paymentddlneValue.frame;
        
        Frame.origin.y = viewEnrollView.paymentddlneLbl.frame.origin.y;
        
        viewEnrollView.paymentddlneValue.frame = Frame;
        
        [viewEnrollView.paymentddlneValue sizeToFit];
        
        Frame = viewEnrollView.changesenrolmntLbl.frame;
        
        if (viewEnrollView.paymentddlneLbl.frame.size.height > viewEnrollView.paymentddlneValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.paymentddlneLbl.frame.origin.y + viewEnrollView.paymentddlneLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.paymentddlneValue.frame.origin.y + viewEnrollView.paymentddlneValue.frame.size.height +5;
        }
        
        viewEnrollView.changesenrolmntLbl.frame = Frame;
        
        [viewEnrollView.changesenrolmntLbl sizeToFit];
        
        Frame = viewEnrollView.changesenrlmntValue.frame;
        
        Frame.origin.y = viewEnrollView.changesenrolmntLbl.frame.origin.y;
        
        viewEnrollView.changesenrlmntValue.frame = Frame;
        
        [viewEnrollView.changesenrlmntValue sizeToFit];
        
        Frame = viewEnrollView.cancellationLbl.frame;
        
        if (viewEnrollView.changesenrolmntLbl.frame.size.height > viewEnrollView.changesenrlmntValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.changesenrolmntLbl.frame.origin.y + viewEnrollView.changesenrolmntLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.changesenrlmntValue.frame.origin.y + viewEnrollView.changesenrlmntValue.frame.size.height +5;
        }
        
        viewEnrollView.cancellationLbl.frame = Frame;
        
        [viewEnrollView.cancellationLbl sizeToFit];
        
        Frame = viewEnrollView.cancelationValue.frame;
        
        Frame.origin.y = viewEnrollView.cancellationLbl.frame.origin.y;
        
        viewEnrollView.cancelationValue.frame = Frame;
        
        [viewEnrollView.cancelationValue sizeToFit];
        
        Frame = viewEnrollView.makeUpLessonsLbl.frame;
        
        if (viewEnrollView.cancellationLbl.frame.size.height > viewEnrollView.cancelationValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.cancellationLbl.frame.origin.y + viewEnrollView.cancellationLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.cancelationValue.frame.origin.y + viewEnrollView.cancelationValue.frame.size.height +5;
        }
        
        viewEnrollView.makeUpLessonsLbl.frame = Frame;
        
        [viewEnrollView.makeUpLessonsLbl sizeToFit];
        
        Frame = viewEnrollView.makeuplessonsValue.frame;
        
        Frame.origin.y = viewEnrollView.makeUpLessonsLbl.frame.origin.y;
        
        viewEnrollView.makeuplessonsValue.frame = Frame;
        
        [viewEnrollView.makeuplessonsValue sizeToFit];
        
        Frame = viewEnrollView.severeWeatherLbl.frame;
        
        if (viewEnrollView.makeUpLessonsLbl.frame.size.height > viewEnrollView.makeuplessonsValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.makeUpLessonsLbl.frame.origin.y + viewEnrollView.makeUpLessonsLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.makeuplessonsValue.frame.origin.y + viewEnrollView.makeuplessonsValue.frame.size.height +5;
        }
        
        viewEnrollView.severeWeatherLbl.frame = Frame;
        
        [viewEnrollView.severeWeatherLbl sizeToFit];
        
        Frame = viewEnrollView.severeWeatherValue.frame;
        
        Frame.origin.y = viewEnrollView.severeWeatherLbl.frame.origin.y;
        
        viewEnrollView.severeWeatherValue.frame = Frame;
        
        [viewEnrollView.severeWeatherValue sizeToFit];
        
        Frame = viewEnrollView.refundLbl.frame;
        
        if (viewEnrollView.severeWeatherLbl.frame.size.height > viewEnrollView.severeWeatherValue.frame.size.height) {
            
            Frame.origin.y = viewEnrollView.severeWeatherLbl.frame.origin.y + viewEnrollView.severeWeatherLbl.frame.size.height +5;
        }
        else{
            
            Frame.origin.y = viewEnrollView.severeWeatherValue.frame.origin.y + viewEnrollView.severeWeatherValue.frame.size.height +5;
        }
        
        viewEnrollView.refundLbl.frame = Frame;
        
        [viewEnrollView.refundLbl sizeToFit];
        
        Frame = viewEnrollView.refundValue.frame;
        
        Frame.origin.y = viewEnrollView.refundLbl.frame.origin.y;
        
        viewEnrollView.refundValue.frame = Frame;
        
        [viewEnrollView.refundValue sizeToFit];
       
    }
    
    Frame = viewEnrollView.codeofconductLbl.frame;
    
    Frame.origin.y = viewEnrollView.refundValue.frame.origin.y + viewEnrollView.refundValue.frame.size.height +10;
    
    viewEnrollView.codeofconductLbl.frame = Frame;
    
    Frame = viewEnrollView.codeofconductValue.frame;
    
    Frame.origin.y = viewEnrollView.codeofconductLbl.frame.origin.y + viewEnrollView.codeofconductLbl.frame.size.height +5;
    
    Frame.size.height = [self heightCalculate:viewEnrollView.codeofconductValue.text :viewEnrollView.codeofconductValue];
    
    viewEnrollView.codeofconductValue.frame = Frame;
    
    Frame = viewEnrollView.subView.frame;
    
    Frame.size.height = viewEnrollView.codeofconductValue.frame.origin.y + viewEnrollView.codeofconductValue.frame.size.height +5;
    
    viewEnrollView.subView.frame = Frame;
    
    Frame = viewEnrollView.footerView.frame;
    
    Frame.origin.y = viewEnrollView.subView.frame.origin.y + viewEnrollView.subView.frame.size.height +5;
    
    viewEnrollView.footerView.frame = Frame;
    
    Frame = viewEnrollView.closeBtn.frame;
    
    Frame.origin.y = viewEnrollView.footerView.frame.origin.y + viewEnrollView.footerView.frame.size.height +5;
    
    viewEnrollView.closeBtn.frame = Frame;
    
    Frame = viewEnrollView.main_view.frame;
    
    Frame.size.height = viewEnrollView.closeBtn.frame.origin.y + viewEnrollView.closeBtn.frame.size.height +5;
    
    viewEnrollView.main_view.frame = Frame;
    
    viewEnrollView.scroll_view.contentSize = CGSizeMake(self.view.frame.size.width,viewEnrollView.main_view.frame.size.height+viewEnrollView.main_view.frame.origin.y+50);
    
   // [viewEnrollView.address sizeToFit];
    
  //  [viewEnrollView.list_name sizeToFit];
    
    [self.view addSubview:viewEnrollView];
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
    
    if (height_lbl < lbl.frame.size.height) {
        
        return lbl.frame.size.height;
    }
    
    else{
    
    return (height_lbl);
        
    }
}


-(void)tapCancelEnrollBtn:(UIButton *)sender {
    
    [actionView removeFromSuperview];
    
    NSString *typeStr = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }
    
    NSString *dateStart = [[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing] valueForKey:@"start_date"];
    
    dateStart = [dateConversion convertDate:dateStart];
    
    NSString *finish_date = [[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"finish_date"];
    
    finish_date = [dateConversion convertDate:finish_date];
    
    dateStart = [@"[Date] - " stringByAppendingString:dateStart];
    
    dateStart = [dateStart stringByAppendingString:@" to "];
    dateStart = [dateStart stringByAppendingString:finish_date];
    
    NSString *listName = [[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing_name]valueForKey:list_name];
    
    list_type = [@"[" stringByAppendingString:[NSString stringWithFormat:@"%@] - ",list_type]];
    
    listName = [list_type stringByAppendingString:listName];
    
    NSString *session_name = [[[myEnrollArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"session_name"];
    
    session_name = [@"[Session Name] - " stringByAppendingString:session_name];
    
    NSString *name = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Member"]valueForKey:@"first_name"];
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@" %@",[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"last_name"]]];
    
    NSString *s_name = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Family"]valueForKey:@"first_name"];
    
    s_name = [s_name stringByAppendingString:[NSString stringWithFormat:@" %@",[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Family"] valueForKey:@"family_name"]]];
    
    NSDictionary *paramURL;
    
    NSString *webservice_url;
    
    NSString *enroll_id1 = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
    
    NSString *status = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"payment_status"];
    
    if ([status isEqualToString:@"0"]) {
        
        webservice_url = @"cancel_enrollment";
        
        //enrollment_id, status (7 if educator cancel, 8 if student cancel), payment_status = 0
        
        paramURL = @{@"enrollment_id":enroll_id1,@"status":@"7",@"payment_status":@"0"};
        
        [self.view addSubview:indicator];
        
        [cancelConn startConnectionWithString:webservice_url HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
            
            [indicator removeFromSuperview];
            
            if ([cancelConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                [self fetchMyEnrolls:1];
            }
        }];
        
    } else {
        
        UIStoryboard *storyboard;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            cancel_ChangeEnrollView = [[Cancel_ChangeEnrollView alloc] init];
            
            cancel_ChangeEnrollView = [[[NSBundle mainBundle] loadNibNamed:@"Cancel_changeEnrollIPad" owner:self options:nil] objectAtIndex:0];
            
            cancel_ChangeEnrollView.frame = self.view.frame;
            
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            cancel_ChangeEnrollView = [[Cancel_ChangeEnrollView alloc] init];
            
            cancel_ChangeEnrollView = [[[NSBundle mainBundle] loadNibNamed:@"Cancel_ChangeEnrollView" owner:self options:nil] objectAtIndex:0];
            
            cancel_ChangeEnrollView.frame = self.view.frame;
        }
        
        cancel_ChangeEnrollView.title.text = @"Enrollment/ Booking Cancellation";
        cancel_ChangeEnrollView.member.text = name;
        cancel_ChangeEnrollView.student.text = s_name;
        cancel_ChangeEnrollView.list_name.text = listName;
        cancel_ChangeEnrollView.session_name.text = session_name;
        cancel_ChangeEnrollView.date.text = dateStart;
        cancel_ChangeEnrollView.session_btn.hidden = YES;
        cancel_ChangeEnrollView.select_session_lbl.hidden = YES;
        cancel_ChangeEnrollView.amount_lbl.hidden = YES;
        cancel_ChangeEnrollView.amount_txtField.hidden = YES;
        cancel_ChangeEnrollView.selctDay_lbl.hidden = YES;
        cancel_ChangeEnrollView.selctDay_btn.hidden = YES;
        
        CGRect frame = cancel_ChangeEnrollView.MainView.frame;
        
        frame.origin.y = cancel_ChangeEnrollView.select_session_lbl.frame.origin.y;
        
        cancel_ChangeEnrollView.MainView.frame = frame;
        
        frame = cancel_ChangeEnrollView.main_view.frame;
        
        frame.size.height = cancel_ChangeEnrollView.MainView.frame.size.height +cancel_ChangeEnrollView.MainView.frame.origin.y+30;
        
        cancel_ChangeEnrollView.main_view.frame = frame;
        
        cancel_ChangeEnrollView.scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, cancel_ChangeEnrollView.main_view.frame.origin.y+cancel_ChangeEnrollView.main_view.frame.size.height +60);
        
        [cancel_ChangeEnrollView.confirm_Btn addTarget:self action:@selector(tapCanclEnroll:) forControlEvents:UIControlEventTouchUpInside];
        cancel_ChangeEnrollView.confirm_Btn.tag = sender.tag;
        [self.view addSubview:cancel_ChangeEnrollView];
    }
}

-(void)tapDeleteBtn:(UIButton *)sender{
    
     NSString *enroll_id1 = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
    
    NSDictionary *paramURL = @{@"enrollment_id":enroll_id1};
    
    [self.view addSubview:indicator];
    
    [deleteConn startConnectionWithString:@"delete_list_enrollment" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([deleteConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            [cancel_ChangeEnrollView removeFromSuperview];
            
            [self fetchMyEnrolls:1];
        }
    }];

}

-(void)tapCanclEnroll:(UIButton *)sender {
    //cancel_enrollment_refund
    //enrollment_id, educator_id, amount, message_content
    
    NSString *message;
    
    if ([cancel_ChangeEnrollView.message.text isEqualToString:@"Enter Message"]) {
        
        message = @"Please enter message";
        
    } else if (![validationObj validateNumberDigits:cancel_ChangeEnrollView.amount_txtField.text]) {
        
        message = @"Please enter valid refund amount";
    }
    
    if (message.length > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        NSString *enroll_id1 = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
        
        NSString *educator_id = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"EnrollmentOwner"] valueForKey:@"id"];
        
        // enrollment_id, message_content, payment_status = 1
        
        NSDictionary *paramURL = @{@"enrollment_id":enroll_id1, @"educator_id":educator_id, @"payment_status":@"1", @"message_content":cancel_ChangeEnrollView.message.text};
        
        [self.view addSubview:indicator];
        
        [cancelConn startConnectionWithString:@"cancel_enrollment_request" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
            
            [indicator removeFromSuperview];
            
            if ([cancelConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                [cancel_ChangeEnrollView removeFromSuperview];
                
                [self fetchMyEnrolls:1];
            }
        }];
    }
    
}


-(void)cancelPayment:(UIButton *)sender {
    
    [actionView removeFromSuperview];
    
    //cancelPayments  subscriber_id
    
    [self.view addSubview:indicator];
    
    NSDictionary*paramURL = @{@"subscriber_id":subscriber_id};
    
    [cancelPayentConn startConnectionWithString:@"cancelPayments" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([cancelPayentConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Your payment has been Successfully cancel" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }
    }];
}

-(void)tapMessageBtn:(UIButton *)sender{
    
    [actionView removeFromSuperview];
    
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
    
    sendMsgView.toMsg_btn.layer.borderWidth = 1.0f;
    
    sendMsgView.toMsg_btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.toMsg_btn.layer.cornerRadius = 5.0f;
    
    sendMsgView.toMsg_btn.userInteractionEnabled = NO;
    
    [sendMsgView.toMsg_btn setTitle:[[[[[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"first_name"]stringByAppendingString:@" "]stringByAppendingString:[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"last_name"]]stringByAppendingString:@", "]stringByAppendingString:[[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"terms"] valueForKey:@"educator_name"]] forState:UIControlStateNormal];
    
    sendMsgView.to_textField.text = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"email"];
    
    sendMsgView.to_textField.hidden = YES;
    
    sendMsgView.subject.layer.borderWidth = 1.0f;
    
    sendMsgView.subject.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.subject.layer.cornerRadius = 5.0f;
    
    sendMsgView.message.layer.borderWidth = 1.0f;
    
    sendMsgView.message.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.message.layer.cornerRadius = 5.0f;
    
    sendMsgView.message.backgroundColor = [UIColor whiteColor];
    
    sendMsgView.frame = self.view.frame;
    
    sendMsgView.view_frame = self.view.frame;
    
    [self.view addSubview:sendMsgView];
}


-(void)popup:(BOOL)isbtn1:(BOOL)isbtn2:(BOOL)isbtn3:(BOOL)isbtn4:(BOOL)isbtn5:(BOOL)isbtn6:(BOOL)isbtn7:(NSInteger)indexrow{
    
    [actionView removeFromSuperview];
    
    actionView = [[UIView alloc]initWithFrame:CGRectMake(20, 200, 250, 400)];
    
    actionView.backgroundColor = [UIColor darkGrayColor];
    
    actionView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    actionView.layer.borderWidth = 1.0f;
    
    actionView.layer.cornerRadius = 5;
    
    //[actionView bounds];
    
    CGRect frame = actionView.frame;
    
    frame.origin.x = (self.view.frame.size.width-actionView.frame.size.width)/2;
    
    actionView.frame = frame;
    
    [actionView sizeToFit];
    
    [self.view addSubview:actionView];
    
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 35)];
    
    subView.backgroundColor = UIColorFromRGB(teal_text_color_hexcode);
    
    subView.layer.cornerRadius = 5;
    
    [actionView addSubview:subView];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(25, 2.5, 200, 30)];
    
    lbl.backgroundColor = [UIColor clearColor];
    
    [lbl setFont:[UIFont boldSystemFontOfSize:20]];
    
    lbl.textColor = [UIColor whiteColor];
    
    lbl.text = @"Action";
    
    lbl.textAlignment = NSTextAlignmentCenter;
    
    [subView addSubview:lbl];
    
    UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 51, 250, 30)];
    
    subView1.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView1];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn1.backgroundColor = [UIColor clearColor];
    
    [btn1 setTitle:@"View" forState:UIControlStateNormal];
    
    //[btn1.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
     btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    //btn1.layer.cornerRadius = 5;
    
    [btn1 addTarget:self action:@selector(tapViewDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    btn1.tag = indexrow;
    
    [subView1 addSubview:btn1];
    
    UIImageView *imgview1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview1.image = [UIImage imageNamed:@"eye_blue"];
    
    //imgview1.layer.cornerRadius = 5;
    
    //imgview1.layer.masksToBounds = YES;
    
    [subView1 addSubview:imgview1];
    
    
    UIView *subView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 82, 250, 30)];
    
    subView2.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView2];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn2.backgroundColor = [UIColor clearColor];
    
    [btn2 setTitle:@"Message" forState:UIControlStateNormal];
    
   // [btn2.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
     btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn2 addTarget:self action:@selector(tapMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn2.tag = indexrow;
    
    [subView2 addSubview:btn2];
    
    UIImageView *imgview2 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview2.image = [UIImage imageNamed:@"message"];
    
    [subView2 addSubview:imgview2];
    
    UIView *subView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 113, 250, 30)];
    
    subView3.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView3];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn3.backgroundColor = [UIColor clearColor];
    
    [btn3 setTitle:@"Payment" forState:UIControlStateNormal];
    
    //[btn3.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
     btn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn3 addTarget:self action:@selector(payPal:) forControlEvents:UIControlEventTouchUpInside];
    
    btn3.tag = indexrow;
    
    [subView3 addSubview:btn3];
    
    UIImageView *imgview3 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview3.image = [UIImage imageNamed:@"Payment_blue"];
    
    [subView3 addSubview:imgview3];
    
    UIView *subView4 = [[UIView alloc]initWithFrame:CGRectMake(0, 144, 250, 30)];
    
    subView4.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView4];
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn4.backgroundColor = [UIColor clearColor];
    
    [btn4 setTitle:@"Stop Payment" forState:UIControlStateNormal];
    
   // [btn4.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    btn4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn4 addTarget:self action:@selector(cancelPayment:) forControlEvents:UIControlEventTouchUpInside];
    
    btn4.tag = indexrow;
    
    [subView4 addSubview:btn4];
    
    UIImageView *imgview4 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview4.image = [UIImage imageNamed:@"stop_payment"];
    
    [subView4 addSubview:imgview4];
    
    UIView *subView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 175, 250, 30)];
    
    subView5.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView5];
    
    UIButton *btn5 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn5.backgroundColor = [UIColor clearColor];
    
    [btn5 setTitle:@"Change Enrollment" forState:UIControlStateNormal];
    
    //[btn5.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    btn5.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn5 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn5 addTarget:self action:@selector(tapChangeEnrollBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn5.tag = indexrow;
    
    [subView5 addSubview:btn5];
    
    UIImageView *imgview5 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview5.image = [UIImage imageNamed:@"adjust"];
    
    [subView5 addSubview:imgview5];
    
    UIView *subView6 = [[UIView alloc]initWithFrame:CGRectMake(0, 261, 250, 30)];
    
    subView6.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView6];
    
    UIButton *btn6 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn6.backgroundColor = [UIColor clearColor];
    
    [btn6 setTitle:@"Cancel Enrollment" forState:UIControlStateNormal];
    
    //[btn6.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    btn6.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn6 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn6 addTarget:self action:@selector(tapCancelEnrollBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn6.tag = indexrow;
    
    [subView6 addSubview:btn6];
    
    UIImageView *imgview6 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview6.image = [UIImage imageNamed:@"minus"];
    
    [subView6 addSubview:imgview6];
    
    ///////////
    
    UIView *subView7 = [[UIView alloc]initWithFrame:CGRectMake(0, 292, 250, 30)];
    
    subView7.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView7];
    
    UIButton *btn7 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn7.backgroundColor = [UIColor clearColor];
    
    [btn7 setTitle:@"Delete" forState:UIControlStateNormal];
    
    //[btn6.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    btn7.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn7 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn7 addTarget:self action:@selector(tapDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn7.tag = indexrow;
    
    [subView7 addSubview:btn7];
    
    UIImageView *imgview7 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview7.image = [UIImage imageNamed:@"delete_teal"];
    
    [subView7 addSubview:imgview7];

    
    ///////////
    
    UIView *cancelView = [[UIView alloc]initWithFrame:CGRectMake(0, 261, 250, 30)];
    
    cancelView.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:cancelView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
    
    btn.backgroundColor = [UIColor clearColor];
    
    [btn setTitle:@"Close" forState:UIControlStateNormal];
    
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(tap_cancelpopup:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelView addSubview:btn];
    
    
    
    CGRect frame1;
    
    if (isbtn1) {
        
        frame1 = subView1.frame;
        
        frame1.origin.y = subView.frame.origin.y + subView.frame.size.height+1;
        
        subView1.frame = frame1;
        
    }
    else{
        
        frame1 = subView1.frame;
        
        frame1.origin.y = 20;
        
        subView1.frame = frame1;
        
        subView1.hidden = YES;
        
    }
    
    if (isbtn2) {
        
        frame1 = subView2.frame;
        
        frame1.origin.y = subView1.frame.origin.y + subView1.frame.size.height+1;
        
        subView2.frame = frame1;
    }
    else{
        
        subView2.frame = subView1.frame;
        
        subView2.hidden = YES;
        
    }
    
    if (isbtn3) {
        
        frame1 = subView3.frame;
        
        frame1.origin.y = subView2.frame.origin.y + subView2.frame.size.height+1;
        
        subView3.frame = frame1;
    }
    else{
        
        subView3.frame = subView2.frame;
        
        subView3.hidden = YES;
        
    }
    
    if (isbtn4) {
        
        frame1 = subView4.frame;
        
        frame1.origin.y = subView3.frame.origin.y + subView3.frame.size.height+1;
        
        subView4.frame = frame1;
    }
    else{
        
        subView4.frame = subView3.frame;
        
        subView4.hidden = YES;
        
    }
    
    if (isbtn5) {
        
        frame1 = subView5.frame;
        
        frame1.origin.y = subView4.frame.origin.y + subView4.frame.size.height+1;
        
        subView5.frame = frame1;
    }
    else{
        
        subView5.frame = subView4.frame;
        
        subView5.hidden = YES;
        
    }
    
    if (isbtn6) {
        
        frame1 = subView6.frame;
        
        frame1.origin.y = subView5.frame.origin.y + subView5.frame.size.height+1;
        
        subView6.frame = frame1;
    }
    else{
        
        subView6.frame = subView5.frame;
        
        subView6.hidden = YES;
        
    }
    if (isbtn7) {
        
        frame1 = subView7.frame;
        
        frame1.origin.y = subView6.frame.origin.y + subView6.frame.size.height+1;
        
        subView7.frame = frame1;
    }
    else{
        
        subView7.frame = subView6.frame;
        
        subView7.hidden = YES;
        
    }
    
    frame1 = cancelView.frame;
    
    frame1.origin.y = subView7.frame.origin.y + subView7.frame.size.height+1;
    
    cancelView.frame = frame1;
    
    
    
    frame1 = actionView.frame;
    
    frame1.size.height = cancelView.frame.origin.y + cancelView.frame.size.height+1;
    
    frame1.origin.y = (self.view.frame.size.height-frame1.size.height)/2;
    
    actionView.frame = frame1;
 
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // if(isServiceCall){
    
    if( (indexPath.row >= (int)(myEnrollArray.count - 10)) && (isScrollUp)){
        
        isNextPage = YES;
        
    }else{
        
        isNextPage = NO;
    }
    
    if(isNextPage && isLodin){
        
        if (page_no < totalPage) {
            
            [self loadNextPage];
        }
        
    }
    
    //}
}

-(void)loadNextPage{
    
    page_no = page_no + 1;
    
    [self fetchMyEnrolls:page_no];
    
    isLodin = NO;
    
    isNextPage = NO;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(lastContentOffset > scrollView.contentOffset.y){
        
        isScrollUp = NO;
        
    }else{
        
        isScrollUp = YES;
    }
    
    lastContentOffset = scrollView.contentOffset.y;
}

-(void)tap_actionBtn:(UIButton *)sender{
    
    if ([[popupArary objectAtIndex:sender.tag] isEqual:@"1"]) {
        
        [popupDict setObject:@"YES" forKey:@"btn1"];
        
        [popupDict setObject:@"YES" forKey:@"btn2"];
        
        [popupDict setObject:@"NO" forKey:@"btn3"];
        
        [popupDict setObject:@"NO" forKey:@"btn4"];
        
        [popupDict setObject:@"YES" forKey:@"btn5"];
        
        [popupDict setObject:@"YES" forKey:@"btn6"];
        
        [popupDict setObject:@"NO" forKey:@"btn7"];
        
        
    }
    else if([[popupArary objectAtIndex:sender.tag] isEqual:@"2"]){
        
        [popupDict setObject:@"YES" forKey:@"btn1"];
        
        [popupDict setObject:@"YES" forKey:@"btn2"];
        
        [popupDict setObject:@"YES" forKey:@"btn3"];
        
        [popupDict setObject:@"NO" forKey:@"btn4"];
        
        [popupDict setObject:@"NO" forKey:@"btn5"];
        
        [popupDict setObject:@"YES" forKey:@"btn6"];
        
        [popupDict setObject:@"NO" forKey:@"btn7"];
        
        
        
    }
    
    else if([[popupArary objectAtIndex:sender.tag] isEqual:@"3"]){
        
        [popupDict setObject:@"YES" forKey:@"btn1"];
        
        [popupDict setObject:@"YES" forKey:@"btn2"];
        
        [popupDict setObject:@"NO" forKey:@"btn3"];
        
        [popupDict setObject:@"NO" forKey:@"btn4"];
        
        [popupDict setObject:@"YES" forKey:@"btn5"];
        
        [popupDict setObject:@"YES" forKey:@"btn6"];
        
        [popupDict setObject:@"NO" forKey:@"btn7"];
        
        
        
    }
    
    else if([[popupArary objectAtIndex:sender.tag] isEqual:@"4"]){
        
        [popupDict setObject:@"YES" forKey:@"btn1"];
        
        [popupDict setObject:@"YES" forKey:@"btn2"];
        
        [popupDict setObject:@"NO" forKey:@"btn3"];
        
        [popupDict setObject:@"NO" forKey:@"btn4"];
        
        [popupDict setObject:@"NO" forKey:@"btn5"];
        
        [popupDict setObject:@"YES" forKey:@"btn6"];
        
        [popupDict setObject:@"NO" forKey:@"btn7"];
        
        
        
    }
    
    else if([[popupArary objectAtIndex:sender.tag] isEqual:@"5"]){
        
        [popupDict setObject:@"YES" forKey:@"btn1"];
        
        [popupDict setObject:@"YES" forKey:@"btn2"];
        
        [popupDict setObject:@"NO" forKey:@"btn3"];
        
        [popupDict setObject:@"NO" forKey:@"btn4"];
        
        [popupDict setObject:@"NO" forKey:@"btn5"];
        
        [popupDict setObject:@"YES" forKey:@"btn6"];
        
        [popupDict setObject:@"NO" forKey:@"btn7"];
        
        
        
    }
    
    else if([[popupArary objectAtIndex:sender.tag] isEqual:@"6"]){
        
        [popupDict setObject:@"YES" forKey:@"btn1"];
        
        [popupDict setObject:@"YES" forKey:@"btn2"];
        
        [popupDict setObject:@"NO" forKey:@"btn3"];
        
        [popupDict setObject:@"NO" forKey:@"btn4"];
        
        [popupDict setObject:@"NO" forKey:@"btn5"];
        
        [popupDict setObject:@"NO" forKey:@"btn6"];
        
        [popupDict setObject:@"NO" forKey:@"btn7"];
        
        
        
    }
    
    else if([[popupArary objectAtIndex:sender.tag] isEqual:@"7"]){
        
        [popupDict setObject:@"YES" forKey:@"btn1"];
        
        [popupDict setObject:@"YES" forKey:@"btn2"];
        
        [popupDict setObject:@"NO" forKey:@"btn3"];
        
        [popupDict setObject:@"NO" forKey:@"btn4"];
        
        [popupDict setObject:@"NO" forKey:@"btn5"];
        
        [popupDict setObject:@"NO" forKey:@"btn6"];
        
        [popupDict setObject:@"NO" forKey:@"btn7"];
        
        
        
    }
    
    else if([[popupArary objectAtIndex:sender.tag] isEqual:@"8"]){
        
        [popupDict setObject:@"YES" forKey:@"btn1"];
        
        [popupDict setObject:@"YES" forKey:@"btn2"];
        
        [popupDict setObject:@"NO" forKey:@"btn3"];
        
        [popupDict setObject:@"NO" forKey:@"btn4"];
        
        [popupDict setObject:@"NO" forKey:@"btn5"];
        
        [popupDict setObject:@"NO" forKey:@"btn6"];
        
        [popupDict setObject:@"YES" forKey:@"btn7"];
        
        
        
    }
    
    BOOL btn1,btn2,btn3,btn4,btn5,btn6,btn7;
    
    if ([[popupDict valueForKey:@"btn1"]isEqual:@"YES"]) {
        
        btn1 = YES;
    }
    
    else{
        
        btn1 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn2"]isEqual:@"YES"]) {
        
        btn2 = YES;
    }
    
    else{
        
        btn2 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn3"]isEqual:@"YES"]) {
        
        btn3 = YES;
    }
    
    else{
        
        btn3 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn4"]isEqual:@"YES"]) {
        
        btn4 = YES;
    }
    
    else{
        
        btn4 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn5"]isEqual:@"YES"]) {
        
        btn5 = YES;
    }
    
    else{
        
        btn5 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn6"]isEqual:@"YES"]) {
        
        btn6 = YES;
    }
    
    else{
        
        btn6 = NO;
    }
    if ([[popupDict valueForKey:@"btn7"]isEqual:@"YES"]) {
        
        btn7 = YES;
    }
    
    else{
        
        btn7 = NO;
    }
    
    
    [self popup:btn1 :btn2 :btn3 :btn4 :btn5 :btn6 :btn7 :sender.tag];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)tap_cancelpopup:(UIButton *)sender{
    
    [actionView removeFromSuperview];

}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
