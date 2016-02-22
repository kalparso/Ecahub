//
//  RecommendationViewController.m
//  ecaHUB
//
//  Created by promatics on 4/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "RecommendationViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "SendMessageView.h"

@interface RecommendationViewController () {
    
    WebServiceConnection *sendReqConn,*updtemailconn;
    
    Indicator *indicator;
    
    DateConversion *dateConversion;
    
    NSDictionary *recommDetailDict;
    
    SendMessageView *sendMsgView;
    
    NSInteger tagValue;
    
    UITextField *alertViewText;
    
    RecommendationViewController *recVC;
}

@end

@implementation RecommendationViewController

@synthesize scrollView, date_join, date_submit, educator, city, district, email, status, send_requestBtn,emailId,recDict,firstName,lastNAme;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    tagValue =0;
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    scrollView.frame = self.view.frame;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+20);
    
    send_requestBtn.layer.cornerRadius = 5.0f;
    
    CGRect frame = send_requestBtn.frame;
    
    frame.origin.x = (self.view.frame.size.width - frame.size.width)/2;
    
    send_requestBtn.frame = frame;
    
    sendReqConn = [WebServiceConnection connectionManager];
    
    dateConversion = [DateConversion dateConversionManager];
    
    updtemailconn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    //RecommendationDetail
    
    recommDetailDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"RecommendationDetail"];
    
    [self setDetails];
}

-(void)setDetails {
    
    NSString *date = [recommDetailDict valueForKey:@"created_date"];
    
    date = [dateConversion convertDate:date];
    
    date_submit.text = date;
    
    educator.text = [recommDetailDict valueForKey:@"name"];
    
    city.text = [recommDetailDict valueForKey:@"city"];
    
    district.text = [recommDetailDict valueForKey:@"district"];
    
    firstName.text = [recommDetailDict valueForKey:@"first_name"];
    
    lastNAme.text = [recommDetailDict valueForKey:@"last_name"];
    
    email.text = [recommDetailDict valueForKey:@"rec_email"];
    
    NSString *statusStr = [recommDetailDict valueForKey:@"status"];
    
    if ([statusStr isEqualToString:@"0"]) {
        
        statusStr = @"Waiting";
        
    } else if ([statusStr isEqualToString:@"1"]) {
        
        statusStr = @"Joined";
        
        [send_requestBtn setTitle:@"Send Message" forState:UIControlStateNormal];
        
        [send_requestBtn addTarget:self action:@selector(tapSendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        tagValue=1;
        
        
    }  else if ([statusStr isEqualToString:@"2"]) {
        
        statusStr = @"Error";
        
        [send_requestBtn setTitle:@"Update Email Address" forState:UIControlStateNormal];
        
       // [send_requestBtn addTarget:self action:@selector(tapUpdateEmailId: ) forControlEvents:UIControlEventTouchUpInside];
        
        tagValue=1;
    }
    
    status.text = statusStr;
    
    date = [recommDetailDict valueForKey:@"joined_date"];
    
    if ([date length] > 1) {
        
        date = [dateConversion convertDate:date];
        
    } else if ([date isEqualToString:@""]){
        
        date = @"Pending";
    }
    date_join.text = date;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)addBtn:(id)sender {
    
    
}

- (IBAction)tapSendRequestBtn:(id)sender {
    
    if (tagValue !=1){
   
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Upon clicking OK the educator will be reminded of your invitation." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    alertViewText = [alertView textFieldAtIndex:0];
  
    alertViewText.text = emailId;
    
    [alertView show];
   }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    
  
      if (buttonIndex == 1) {
        
        [self.view addSubview:indicator];
        
        NSDictionary *paramURL = @{@"recommended_id":[recommDetailDict valueForKey:@"id"], @"sender_first_name":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"],@"rec_email":alertViewText.text};
        
        [sendReqConn startConnectionWithString:@"send_recommendation_again" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([sendReqConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Invitation has been sent successfully! Thank you for your efforts." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }];
        
          email.text = alertViewText.text;
        
       }
    
}





//-(void)tapUpdateEmailId:(UIButton *)button{
//
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Update Email ID" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//
//    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//
//    alertViewText = [alertView textFieldAtIndex:0];
//
//    alertViewText.text = emailId;
//
//    [alertView show];
//
//}

-(void)tapSendMessage:(UIButton *)button{
    
    sendMsgView = [[SendMessageView alloc] init];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPad" owner:self options:nil] objectAtIndex:0];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPhone" owner:self options:nil] objectAtIndex:0];
    }
    
    sendMsgView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+60);
    
    sendMsgView.to_textField.text = emailId;
    
    sendMsgView.frame = self.view.frame;
    
    sendMsgView.view_frame = self.view.frame;
    
    [self.view addSubview:sendMsgView];
    
    
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//  //  NSString *str = alertViewText.text;
//
//    if (buttonIndex == 1) {
//
//
//        NSDictionary *paramURL = @{@"recommended_id":[recommDetailDict valueForKey:@"id"], @"sender_first_name":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"],@"email":alertViewText.text};
//
//        [self.view addSubview:indicator];
//
//        [updtemailconn startConnectionWithString:@"send_recommendation_again" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
//
//            [indicator removeFromSuperview];
//
//            if([updtemailconn responseCode] == 1)
//
//            {
//                NSLog(@"%@",receivedData);
//
//                UIAlertView *alertView = [[UIAlertView alloc
//                                          ]initWithTitle:Alert_title message:@" Email Successfully Updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//
//
//                [alertView show];
//            }
//
//        }];
//
//        [self setDetails];
//    }
//}
@end

