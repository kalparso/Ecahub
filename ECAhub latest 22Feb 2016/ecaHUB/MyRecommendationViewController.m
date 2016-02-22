//
//  MyRecommendationViewController.m
//  ecaHUB
//
//  Created by promatics on 4/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "MyRecommendationViewController.h"
#import "myRecommTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "SendMessageView.h"
#import "RecommendationViewController.h"

@interface MyRecommendationViewController () {
    
    WebServiceConnection *myRecomConn,*updtemailconn;
    
    WebServiceConnection *sendReqConn;
    
    Indicator *indicator;
    
    myRecommTableViewCell *cell;
    
    SendMessageView *senMsgView;
    
    DateConversion *dateConversion;
    
    NSArray *myRecommArray;
    
    NSInteger tagValue0,tagValue1,tagValue2;
    
    RecommendationViewController *recommendationVC;
    
    MyRecommendationViewController *myRecommandVC;
    
    NSString *emailid;
    
    NSDictionary *recDict;
    
    UITextField *alertViewText;
    
    NSString *option_selected, *status_key;
    
    int filter, Sel_filter;
    
}
@end

@implementation MyRecommendationViewController

@synthesize main_view, recommdTable, addRecomm_btn, selectFilterBtn, resetBtn, statusBtn, filterTxtField, filterTableBtn,filter_view,search_btn,add_btn,noDataLbl;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    filter =0;
    
    Sel_filter =0 ;
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
  //  self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.recommdTable.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItems = @[add_btn,search_btn];

    myRecomConn = [WebServiceConnection connectionManager];
    
    sendReqConn = [WebServiceConnection connectionManager];
    
    updtemailconn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    main_view.hidden = YES;
    
    filter_view.hidden = YES;
    
    CGRect frame = recommdTable.frame;
    
    frame.origin.y = filter_view.frame.origin.y;
    
    frame.size.height = recommdTable.frame.size.height + filter_view.frame.size.height+64;
    
    recommdTable.frame = frame;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    filterTableBtn.layer.cornerRadius = 5.0f;
    selectFilterBtn.layer.cornerRadius = 5.0f;
    resetBtn.layer.cornerRadius = 5.0f;
    statusBtn.layer.cornerRadius = 5.0f;
    
    selectFilterBtn.layer.borderWidth = 1.0f;
    selectFilterBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    statusBtn.layer.borderWidth = 1.0f;
    statusBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGRect frame = filterTxtField.frame;
        
        frame.size.height = 45.0f;
        
        filterTxtField.frame = frame;
        
        statusBtn.frame = frame;
        
        frame = recommdTable.frame;
        
        frame.size.height =self.view.frame.size.height - 110 - resetBtn.frame.origin.y - resetBtn.frame.size.height;
        
        recommdTable.frame = frame;
        
        addRecomm_btn.layer.cornerRadius = 7;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        CGRect frame = recommdTable.frame;
        
        frame.size.height =self.view.frame.size.height - 50 - resetBtn.frame.origin.y - resetBtn.frame.size.height;
        
        recommdTable.frame = frame;
        
        addRecomm_btn.layer.cornerRadius = 5;
        
    }
    
    filterTxtField.layer.cornerRadius = 5.0f;
    
    filterTxtField.layer.borderWidth = 1.0f;
    filterTxtField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    filterTxtField.layer.masksToBounds = YES;
    
    statusBtn.hidden = YES;
    selectFilterBtn.hidden = YES;
    filterTxtField.hidden = YES;
    resetBtn.hidden = YES;
    filterTableBtn.hidden = YES;
    
    [self.view setBackgroundColor:UIColorFromRGB(dlight_gray_color_hexcode)];
    
    [filter_view setBackgroundColor:UIColorFromRGB(dlight_gray_color_hexcode)];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [filterTxtField resignFirstResponder];
    
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self fetchMyRecommendations];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"view_recommendationSegue"]){
        
        recommendationVC =segue.destinationViewController;
        
        recommendationVC.emailId =emailid;
        
        recommendationVC.recDict =[recDict copy];
    }
}

-(void)fetchMyRecommendations {
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [myRecomConn startConnectionWithString:@"recommendations" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([myRecomConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                myRecommArray = [receivedData valueForKey:@"recommendation_info"];
                
                selectFilterBtn.hidden = NO;
                filterTxtField.hidden = NO;
                resetBtn.hidden = NO;
                filterTableBtn.hidden = NO;
                recommdTable.hidden = NO;
                main_view.hidden = NO;
                [recommdTable reloadData];
                
            } else {
                
                main_view.hidden = NO;
                
                addRecomm_btn.layer.cornerRadius = 5.0f;
                
                recommdTable.hidden = YES;
            }
        }
    }];
}

#pragma mark - UITableView Delegates & Datasources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [myRecommArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"myRecomCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.send_recommBtn.hidden = YES;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.educator_name.text = [[[myRecommArray objectAtIndex:indexPath.row] valueForKey:@"Recommendation"] valueForKey:@"name"];
    
    NSString *date = [[[myRecommArray objectAtIndex:indexPath.row] valueForKey:@"Recommendation"] valueForKey:@"created_date"];
    
    date = [dateConversion convertDate:date];
    
    cell.date_submit.text = date;
    
    NSString *status = [[[myRecommArray objectAtIndex:indexPath.row] valueForKey:@"Recommendation"] valueForKey:@"status"];
    
    if ([status isEqualToString:@"0"]) {
        
        status = @"Waiting";
        
        cell.send_recommBtn.tag = indexPath.row;
        
        tagValue0 =cell.send_recommBtn.tag;
        
        [cell.send_recommBtn addTarget:self action:@selector(tapSendRecommBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if ([status isEqualToString:@"1"]) {
        
        status = @"Joined";
        
        [cell.send_recommBtn setTitle:@"Send Message" forState:UIControlStateNormal];
        
        cell.send_recommBtn.tag = indexPath.row;
        
        tagValue1 =cell.send_recommBtn.tag;
        
        [cell.send_recommBtn addTarget:self action:@selector(loadSendMessageXib:) forControlEvents:UIControlEventTouchUpInside];
        
    }  else if ([status isEqualToString:@"2"]) {
        
        status = @"Error";
        
        [cell.send_recommBtn setTitle:@"Update Email Address" forState:UIControlStateNormal];
        
        cell.send_recommBtn.tag = indexPath.row;
        
        tagValue2 =cell.send_recommBtn.tag;
        
        [cell.send_recommBtn addTarget:self action:@selector(tapUpdateEmail:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.send_recommBtn.tag = indexPath.row;
    
    cell.status.text = status;
    
    cell.send_recommBtn.layer.cornerRadius = 5.0f;
    
    CGRect frame = cell.send_recommBtn.frame;
    
    frame.origin.x = (recommdTable.frame.size.width - frame.size.width)/2;
    
    cell.send_recommBtn.frame = frame;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *detail = [[myRecommArray objectAtIndex:indexPath.row] valueForKey:@"Recommendation"];
    
    [[NSUserDefaults standardUserDefaults] setObject:detail forKey:@"RecommendationDetail"];
    
    emailid = [[[myRecommArray objectAtIndex:indexPath.row]valueForKey:@"Recommendation"] valueForKey:@"rec_email"];
    
    recDict = [myRecommArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"view_recommendationSegue" sender:self];
}

-(void)tapSendRecommBtn:(UIButton *)button {
    
    NSString *mailId = [[[myRecommArray objectAtIndex:button.tag]valueForKey:@"Recommendation"] valueForKey:@"rec_email"];
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"recommended_id":[[[myRecommArray objectAtIndex:button.tag] valueForKey:@"Recommendation"] valueForKey:@"id"], @"sender_first_name":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"],@"email":mailId};
    
    [sendReqConn startConnectionWithString:@"send_recommendation_again" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([sendReqConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Your recommendation has been sent successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)tapAddBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"addRecommendationSegue" sender:self];
}

- (IBAction)tapRecomBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"addRecommendationSegue" sender:self];
}

#pragma mark - UITextfield Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self tapFilterDataBtn:self];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)tapSelectFilter:(id)sender {
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"By Educator or Business name", @"By Email", @"By City", @"By Status", nil];
    
    [actionsheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    statusBtn.hidden = YES;
    filterTxtField.hidden = NO;
    filterTxtField.text = @"";
    
    if (buttonIndex == 0) {
        
        Sel_filter = 1;
        
        [selectFilterBtn setTitle:@"By Educator or Business name" forState:UIControlStateNormal];
        
        status_key = @"";
        
        option_selected = @"1";
        
        self.filterTxtField.placeholder =@"Enter Name";
        
    } else if (buttonIndex == 1) {
        
        Sel_filter = 1;
        
        [selectFilterBtn setTitle:@"By Email" forState:UIControlStateNormal];
        
        option_selected = @"2";
        
        status_key = @"";
        
        self.filterTxtField.placeholder =@"Enter Email";
        
    } else if (buttonIndex == 2) {
        
        Sel_filter = 1;
        
        [selectFilterBtn setTitle:@"By City" forState:UIControlStateNormal];
        
        option_selected = @"4";
        
        status_key = @"";
        
        self.filterTxtField.placeholder =@"Enter City";
        
    } else if (buttonIndex == 3) {
        
        Sel_filter = 1;
        
        [selectFilterBtn setTitle:@"By Status" forState:UIControlStateNormal];
        
        option_selected = @"3";
        
        filterTxtField.hidden = YES;
        filterTxtField.text = @"";
        statusBtn.hidden = NO;
    }
}

- (IBAction)tapStatusBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Waiting",@"Joined",@"Error", nil];
    
    alert.tag = 1;
    
    [alert show];
}

- (IBAction)tapRestBtn:(id)sender {
    
    Sel_filter = 0;
    
    [selectFilterBtn setTitle:@"Select Filter" forState:UIControlStateNormal];
    
    filterTxtField.text = @"";
    
    [statusBtn setTitle:@"Select" forState:UIControlStateNormal];
    
    statusBtn.hidden = YES;
    filterTxtField.hidden = NO;
    
    self.filterTxtField.placeholder =@"";
    
    [self fetchMyRecommendations];
    
}

- (IBAction)tapFilterDataBtn:(id)sender {
    
    [filterTxtField resignFirstResponder];
    
    [self.view endEditing:YES];
    
    if (Sel_filter==0) {
        
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"Oops! Please use the Select Filter option before you click the 'Filter' button." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    
    else{
    //member_id, For Filter{ option_selected=>('1'=>name,'2'=>email,'3'=>status,'4'=>city),key(value of filter) for status send ('0'=>'Waiting','1'=>'Joined','2'=>'Error')   }
    //status_key = filterTxtField.text;
    if ([status_key isEqualToString:@""]) {
        
        status_key = filterTxtField.text;
    }
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"option_selected":option_selected, @"key":status_key};
    
    [myRecomConn startConnectionWithString:@"recommendations" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([myRecomConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                myRecommArray = [receivedData valueForKey:@"recommendation_info"];
                status_key = @"";
                recommdTable.hidden = NO;
                
                filterTxtField.text = @"";
                
                [recommdTable reloadData];
                
            } else {
                
                addRecomm_btn.hidden = YES;
                
                noDataLbl.hidden = YES;
                
                recommdTable.hidden = NO;
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@" Oops! You haven't recommended any educators under that search criteria. Please try again, or recommend some now." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                
                [alertView show];
            }
        }
    }];
    }
}

-(void)loadSendMessageXib:(UIButton *)button {
    
    NSString *mailId = [[[myRecommArray objectAtIndex:button.tag] valueForKey:@"Recommendation"] valueForKey:@"rec_email"];
    
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
    
    senMsgView.to_textField.text = mailId;
    
    senMsgView.frame = self.view.frame;
    
    senMsgView.view_frame = self.view.frame;
    
    [self.view addSubview:senMsgView];
    
}

-(void)tapUpdateEmail:(UIButton *)button {
    
    NSString *mailId = [[[myRecommArray objectAtIndex:button.tag] valueForKey:@"Recommendation"] valueForKey:@"rec_email"];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Update Email Id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    alertView.alertViewStyle =UIAlertViewStylePlainTextInput;
    
    alertView.tag = 0;
    
    alertViewText = [alertView textFieldAtIndex:0];
    
    alertViewText.text = mailId;
    
    [alertView show];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //  NSString *str = alertViewText.text;
    
    if (alertView.tag == 1) {
        
        if (buttonIndex == 1) {
            
            [statusBtn setTitle:@"Waiting" forState:UIControlStateNormal];
            
            status_key = @"0";
            
        } else if (buttonIndex == 2) {
            
            [statusBtn setTitle:@"Joined" forState:UIControlStateNormal];
            
            status_key = @"1";
            
        } else if (buttonIndex == 3) {
            
            [statusBtn setTitle:@"Error" forState:UIControlStateNormal];
            
            status_key = @"2";
        }
        
    } else {
        
        if (buttonIndex == 1) {
            
            
            NSDictionary *recommDetailDict = [[NSUserDefaults standardUserDefaults] valueForKey:@"RecommendationDetail"];
            
            NSDictionary *paramURL = @{@"recommended_id":[recommDetailDict valueForKey:@"id"], @"sender_first_name":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"],@"email":alertViewText.text};
            
            [self.view addSubview:indicator];
            
            [updtemailconn startConnectionWithString:@"send_recommendation_again" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
                
                [indicator removeFromSuperview];
                
                if([updtemailconn responseCode] == 1)
                    
                {
                    NSLog(@"%@",receivedData);
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Email Successfully Updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                }
            }];
            
            [self fetchMyRecommendations];
        }
    }
}


- (IBAction)tapSearch_btn:(id)sender {
    
   // main_view.hidden = NO;
    if (filter ==0) {
        
         filter_view.hidden= NO;
        
        filter =1;
        
        CGRect frame = recommdTable.frame;
        
        frame.origin.y = filter_view.frame.origin.y+filter_view.frame.size.height+10;
        
        frame.size.height = self.view.frame.size.height - frame.origin.y - 55;
        
        recommdTable.frame = frame;
    }
    else{
    
        filter_view.hidden= YES;
        
        filter = 0;
        
        CGRect frame = recommdTable.frame;
        
        frame.origin.y = filter_view.frame.origin.y+3;
        
        frame.size.height = self.view.frame.size.height - frame.origin.y - 55;
        
        recommdTable.frame = frame;
        
    }
    
  
    
   // self.view.backgroundColor = [UIColor lightGrayColor];
   

}
@end
