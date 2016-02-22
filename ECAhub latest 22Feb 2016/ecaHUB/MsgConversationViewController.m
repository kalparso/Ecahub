//
//  MsgConversationViewController.m
//  ecaHUB
//
//  Created by promatics on 4/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "MsgConversationViewController.h"
#import "WebServiceConnection.h"
#import "myMsgTableViewCell.h"
#import "OtherMsgTableViewCell.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "SendMessageView.h"
#import "Validation.h"

@interface MsgConversationViewController () {
    
    WebServiceConnection *msgConvresConn,*reportAbuseConn;
    
    WebServiceConnection *sendMsgConn;
    
    WebServiceConnection *deleteConn;
    
    WebServiceConnection *forwordConn;
    
    Validation *validObj;
    
    myMsgTableViewCell *myMsgCell;
    
    SendMessageView *sendmsgView;
    
    OtherMsgTableViewCell *otherMsgCell;
    
    Indicator *indicator;
    
    DateConversion *dateConversion;
    
    UIRefreshControl *refreshControl;
    
    BOOL isRefresh;
    
    NSArray *msgArray;
    
    NSString *member_id, *msgId ;
    
    NSMutableArray *forwordMsg;
    
    RatingView *back_StarView;
    
    CGFloat star_width, height1, y;
    
    NSMutableArray *delete_array;
}
@end

@implementation MsgConversationViewController

@synthesize msg_table, msg_textView, user_img, user_name, rating_view, listing_name, shareBtn, forwordBtn, replyBtn, rate_no, star_ratingView,reportabuse_btn,delete_btn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.rightBarButtonItems = @[reportabuse_btn,delete_btn];
    
    
    self.title = @"Conversation";
    
    //CGFloat redius;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        star_width = 20.0f;
        
        //redius = 10.0f;
        
        height1 = 60;
        
        y = 280;
        
        user_img.layer.cornerRadius = 35.0f;
        
        user_img.layer.masksToBounds = YES;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        star_width = 14.0f;
        
        //redius = 5.0f;
        
        height1 = 40;
        
        y = 230;
        
        user_img.layer.cornerRadius = 25.0f;
        
        user_img.layer.masksToBounds = YES;
    }
    
    shareBtn.layer.cornerRadius = 5.0;
    
    forwordBtn.layer.cornerRadius = 5.0;
    
    replyBtn.layer.cornerRadius = 5.0;
    
    back_StarView = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, rating_view.frame.size.width, rating_view.frame.size.height) numberOfStar:0 starWidth:star_width];
    
    back_StarView.userInteractionEnabled = NO;
    
    back_StarView.delegate =self;
    
    [rating_view addSubview:back_StarView];
    
    msgConvresConn = [WebServiceConnection connectionManager];
    
    reportAbuseConn = [WebServiceConnection connectionManager];
    
    sendMsgConn = [WebServiceConnection connectionManager];
    
    deleteConn = [WebServiceConnection connectionManager];
    
    forwordConn = [WebServiceConnection connectionManager];
    
    validObj = [Validation validationManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    forwordMsg = [[NSMutableArray alloc]init];
    
    [msg_table addSubview:refreshControl];
    
    isRefresh = NO;
    
    //  msg_table.editing = YES;
    
    delete_array = [[NSMutableArray alloc] init];
    
    [msg_table setAllowsMultipleSelection:YES];
    
    [self fetchMsgConversation];
}

#pragma mark - RefreshController

-(void)refreshTable {
    
    isRefresh = YES;
    
    [self fetchMsgConversation];
}

#pragma mark- Delete Message

- (IBAction)tapAbuse_btn:(id)sender {
    
    [self.view addSubview:indicator];
    
    NSDictionary *dict = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"sender_id":[[msgArray valueForKey:@"Message"] valueForKey:@"sender_id"],@"receiver_id":[[msgArray valueForKey:@"Message"] valueForKey:@"receiver_id"],@"main_message_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"MsgConvID"],@"message":[[msgArray valueForKey:@"Message"] valueForKey:@"message_content"],@"message_date":[[msgArray valueForKey:@"Message"] valueForKey:@"date_time"]};
    
    [reportAbuseConn startConnectionWithString:@"report_abuse_message" HttpMethodType:Post_Type HttpBodyType:dict Output:^(NSDictionary * receivedData){
        
        [indicator removeFromSuperview];
        
        if ([reportAbuseConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Your request has been sent successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }];
    
    
}

- (IBAction)tapDeleteBtn:(id)sender {
    
    //trash_to_messages
    //delete[0]={ConversationId:sender}  or {MessageId:receiver}, for=Reply    EXP: delete[0] = 1:sender, for=Reply
    [self.view addSubview:indicator];
    
    if ([delete_array count] > 0) {
        
        NSMutableDictionary *paramURL = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *keys = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < delete_array.count; i++) {
            
            [keys addObject:[NSString stringWithFormat:@"delete[%d]",i]];
        }
        
        [keys addObject:@"for"];
        
        [delete_array addObject:@"Reply"];
        
        paramURL = [NSMutableDictionary dictionaryWithObjects:delete_array forKeys:keys];
        
        NSLog(@"%@", paramURL);
        
        [deleteConn startConnectionWithString:@"trash_to_messages" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
            
            [indicator removeFromSuperview];
            
            if ([deleteConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                [delete_array removeAllObjects];
                
                [self fetchMsgConversation];
            }
        }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Do You want to delete all conversation ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"NO", nil];
        
        alert.tag = 1;
        
        [alert show];
        
    }}
//        NSString *msg_Id = [[NSUserDefaults standardUserDefaults] valueForKey:@"MsgConvID"];
//
//        msg_Id = [msg_Id stringByAppendingString:@":receiver"];
//
//        NSDictionary *paramURL = @{@"delete[0]":msg_Id};
//
//        [deleteConn startConnectionWithString:@"trash_to_messages" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
//
//            [indicator removeFromSuperview];
//
//            if ([deleteConn responseCode] == 1) {
//
//                NSLog(@"%@", receivedData);
//
//                [delete_array removeAllObjects];
//
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }];
//    }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if (alertView.tag == 1) {
            
            [self.view addSubview:indicator];
            
            NSString *msg_Id = [[NSUserDefaults standardUserDefaults] valueForKey:@"MsgConvID"];
            
            msg_Id = [msg_Id stringByAppendingString:@":receiver"];
            
            NSDictionary *paramURL = @{@"delete[0]":msg_Id};
            
            [deleteConn startConnectionWithString:@"trash_to_messages" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
                
                [indicator removeFromSuperview];
                
                if ([deleteConn responseCode] == 1) {
                    
                    NSLog(@"%@", receivedData);
                    
                    [delete_array removeAllObjects];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            
        }else if (alertView.tag == 2){
            
            NSString *emailText = [alertView textFieldAtIndex:0].text;
            
            NSLog(@"%@",emailText);
            
            if ([validObj validateEmail:emailText]) {
                
                [self forwordWeb:emailText];
                
            } else {
                
                UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Please enter valid email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alrt show];
            }
        }
    }
}

-(void)setRating {
    
    [star_ratingView removeFromSuperview];
    
    star_ratingView = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, ((star_width +1.3) * rate_no) - rate_no, rating_view.frame.size.height) numberOfStar:rate_no starWidth:star_width];
    
    star_ratingView.userInteractionEnabled = NO;
    
    star_ratingView.delegate =self;
    
    [rating_view addSubview:star_ratingView];
}

-(void)fetchMsgConversation {
    
    if (!isRefresh) {
        
        [self.view addSubview:indicator];
    }
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    msgId = [[NSUserDefaults standardUserDefaults] valueForKey:@"MsgConvID"];
    
    NSDictionary *paramURL = @{@"message_id":msgId, @"member_id":member_id};
    
    [msgConvresConn startConnectionWithString:@"message_conversation" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [refreshControl endRefreshing];
        
        if (!isRefresh) {
            
            [indicator removeFromSuperview];
            
            isRefresh = NO;
        }
        
        if ([msgConvresConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                msgArray = [receivedData valueForKey:@"conversation_info"];
                
                rate_no = 4.0;
                
                [self setRating];
                
                NSString *type = [[[msgArray objectAtIndex:0] valueForKey:@"Member"] valueForKey:@"id"];
                
                NSString *name, *img;
                
                if ([type isEqualToString:member_id]) {
                    
                    name = [[[msgArray objectAtIndex:0] valueForKey:@"Member2"] valueForKey:@"first_name"];
                    
                    img = [[[msgArray objectAtIndex:0] valueForKey:@"Member2"] valueForKey:@"picture"];
                    
                } else {
                    
                    name = [[[msgArray objectAtIndex:0] valueForKey:@"Member"] valueForKey:@"first_name"];
                    
                    img = [[[msgArray objectAtIndex:0] valueForKey:@"Member"] valueForKey:@"picture"];
                }
                
                user_name.text = name;
                
                listing_name.text = [[[msgArray objectAtIndex:0] valueForKey:@"Reply"] valueForKey:@"msg_subject"];
                
                NSString *img_url = profilePicURL;
                
                img_url = [img_url stringByAppendingString:img];
                
                NSString *Imgurl = img;
                
                if ([Imgurl isEqualToString:@""]) {
                    
                    user_img.image = [UIImage imageNamed:@"user_img"];
                    
                } else{
                    
                    NSLog(@"%@",img_url);
                    
                    [self downloadImageWithString:img_url];
                }
                
                
                // [self downloadImageWithString:img_url];
                
                [msg_table reloadData];
            }
        }
    }];
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            user_img.image = image;
        }
    }];
}

#pragma mark - UITableviewDelegates & Datasourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [msgArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *msg;
    
    CGFloat height;
    
    msg = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Reply"] valueForKey:@"msg"];
    
    height = [self heightCalculate:msg];
    
    height = height1 + height;
    
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *type = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"id"];
    
    if ([type isEqualToString:member_id]) {
        
        myMsgCell = [tableView dequeueReusableCellWithIdentifier:@"myMsgCell"];
        
        myMsgCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        // myMsgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if (myMsgCell == nil) {
            
            myMsgCell = [[myMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myMsgCell"];
            
        }
        
        NSString *msg;
        
        CGFloat height;
        
        msg = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Reply"] valueForKey:@"msg"];
        
        height = [self heightCalculate:msg];
        
        CGRect frame = myMsgCell.msg_view.frame;
        
        frame.size.height = height + 5;
        
        frame.size.width = msg_table.frame.size.width - 20;
        
        myMsgCell.msg_view.frame = frame;
        
        frame = myMsgCell.message.frame;
        
        frame.size.height = height;
        
        frame.size.width = myMsgCell.msg_view.frame.size.width - 15;
        
        myMsgCell.message.frame = frame;
        
        [myMsgCell.message setLineBreakMode:NSLineBreakByClipping];
        
        [myMsgCell.message setNumberOfLines:0];
        
        [myMsgCell.message setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        // [myMsgCell.message sizeToFit];
        
        myMsgCell.message.text = msg;
        
        //myMsgCell.msg_view.layer.cornerRadius = 10.0f;
        
        //myMsgCell.msg_view.layer.borderWidth = 1.0f;
        
        msg_textView.layer.borderWidth = 1.0f;
        
        msg_textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        // myMsgCell.msg_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        frame = myMsgCell.name.frame;
        
        frame.origin.x = 10.0f;
        
        myMsgCell.name.frame = frame;
        
        // myMsgCell.name.text = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"first_name"];
        
        myMsgCell.name.text = @"Me";
        
        NSString *date = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Reply"] valueForKey:@"date_added"];
        
        date = [dateConversion convertDate_Time:date];
        
        forwordBtn.tag = indexPath.row;
        
        myMsgCell.date.text = date;
        
        frame = myMsgCell.date.frame;
        
        frame.origin.x = self.msg_table.frame.size.width - frame.size.width-8;
        
        myMsgCell.date.frame = frame;
        
        myMsgCell.backgroundColor = [UIColor clearColor];
        
        
        return myMsgCell;
        
    } else {
        
        otherMsgCell = [tableView dequeueReusableCellWithIdentifier:@"otherMsgCell"];
        
        otherMsgCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        if (otherMsgCell == nil) {
            
            otherMsgCell = [[OtherMsgTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherMsgCell"];
        }
        
        NSString *msg;
        
        CGFloat height;
        
        msg = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Reply"] valueForKey:@"msg"];
        
        height = [self heightCalculate:msg];
        
        CGRect frame = otherMsgCell.msg_view.frame;
        
        frame.size.height = height + 5;
        
        frame.size.width = msg_table.frame.size.width - 20;
        
        otherMsgCell.msg_view.frame = frame;
        
        frame = otherMsgCell.message.frame;
        
        frame.size.height = height;
        
        frame.size.width = otherMsgCell.msg_view.frame.size.width - 15;
        
        otherMsgCell.message.frame = frame;
        
        //otherMsgCell.msg_view.layer.cornerRadius = 10.0f;
        
        
        [otherMsgCell.message setLineBreakMode:NSLineBreakByClipping];
        
        [otherMsgCell.message setNumberOfLines:0];
        
        [otherMsgCell.message setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        //[otherMsgCell.message sizeToFit];
        
        otherMsgCell.message.text = msg;
        
        otherMsgCell.name.text = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"first_name"];
        
        NSString *date = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Reply"] valueForKey:@"date_added"];
        
        date = [dateConversion convertDate_Time:date];
        
        otherMsgCell.date.text = date;
        
        frame = otherMsgCell.date.frame;
        
        frame.origin.x = self.msg_table.frame.size.width - frame.size.width-8;
        
        otherMsgCell.date.frame = frame;
        
        otherMsgCell.backgroundColor = [UIColor clearColor];
        
        return otherMsgCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //delete[0]={ConversationId:sender}  or {MessageId:receiver}, for=Reply    EXP: delete[0] = 1:sender, for=Reply
    
    NSString *msg_id = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Reply"] valueForKey:@"id"];
    
    NSString *type = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"id"];
    
    [forwordMsg addObject:msg_id];
    
    if ([type isEqualToString:member_id]) {
        
        msg_id = [msg_id stringByAppendingString:@":sender"];
        
        myMsgCell = (myMsgTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        myMsgCell.arrow_img.hidden=YES;
        
        
    } else {
        
        msg_id = [msg_id stringByAppendingString:@":receiver"];
        
        otherMsgCell = (OtherMsgTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        otherMsgCell.arrow_img.hidden = YES;
        
    }
    
    [delete_array addObject:msg_id];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *msg_id = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Reply"] valueForKey:@"id"];
    
    NSString *type = [[[msgArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"id"];
    
    [forwordMsg removeObject:msg_id];
    
    if ([type isEqualToString:member_id]) {
        
        msg_id = [msg_id stringByAppendingString:@":sender"];
        
        myMsgCell = (myMsgTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        myMsgCell.arrow_img.hidden=NO;
        
        
    } else {
        
        msg_id = [msg_id stringByAppendingString:@":receiver"];
        
        otherMsgCell = (OtherMsgTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        otherMsgCell.arrow_img.hidden = NO;
        
    }
    
    [delete_array removeObject:msg_id];
}

-(CGFloat)heightCalculate:(NSString *)calculateText{
    
    NSString *text = calculateText;
    
    UIFont *font = [UIFont systemFontOfSize:16];
    
    CGSize constraint = CGSizeMake(msg_table.frame.size.width - (1.0f * 2), FLT_MAX);
    
    //    CGSize size1 = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGFloat height_lbl = size.height;
    
    //  NSLog(@"%f",height_lbl);
    
    return (height_lbl+10);
}

#pragma mark - UITextView Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    return true;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = 0;
    
    self.view.frame = frame;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = -y;
    
    self.view.frame = frame;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)tapWarningBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Encouraging  members to pay for listed services using other payment methods outside of ECAhub is against the terms and conditions of listing and buying on ECAhub. The only way ECAhub can continue to provide most of its services for free or at minimal cost to sellers is by having its members abide by the these rules. If a member requests you to pay  outside of ECAhub, please REPORT ABUSE. Sellers who break the rules will have their account privileges revoked, their Listings removed, and will be blacklisted. Please help keep ECAhub working well for all." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (IBAction)tapShareBtn:(id)sender {
    
}

- (IBAction)tapForwordBtn:(id)sender {
    
    if ([forwordMsg count] < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Please select atleast 1 message." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Please enter email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        
        alert.tag = 2;
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        [alert show];
    }
}

-(void)forwordWeb :(NSString *)email{
    
    [self.view addSubview:indicator];
    
    if ([forwordMsg count] > 0) {
        
        NSMutableDictionary *paramURL = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *keys = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < forwordMsg.count; i++) {
            
            [keys addObject:[NSString stringWithFormat:@"ids[%d]",i]];
        }
        
        [keys addObject:@"member_id"];
        
        [forwordMsg addObject:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]];
        
        [keys addObject:@"email_id"];
        
        [forwordMsg addObject:email];
        
        paramURL = [NSMutableDictionary dictionaryWithObjects:forwordMsg forKeys:keys];
        
        NSLog(@"%@", paramURL);
        
        [forwordConn startConnectionWithString:@"forward_messages" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
            
            [indicator removeFromSuperview];
            
            if ([forwordConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                //[forwordMsg removeAllObjects];
                
                if([[receivedData valueForKey:@"code"]integerValue]== 0){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"email id does not matched." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                } else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Forword successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    
                }
                
            }
        }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please select atleast 1 message" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"NO", nil];
        
        
        
        [alert show];
        
    }
    
}
- (IBAction)tapReplyBtn:(id)sender {
    
    NSLog(@"%@",msg_textView.text);
    
    if ([msg_textView.text length] < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please enter the message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        
        [alert show];
        
        
    } else {
        
        [self.view addSubview:indicator];
        
        NSDictionary *paramURL = @{@"message_id":msgId, @"member_id":member_id, @"msg":msg_textView.text};
        
        [sendMsgConn startConnectionWithString:@"send_reply" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([sendMsgConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                msg_textView.text = @"";
                
                [self fetchMsgConversation];
            }
        }];
    }
    
    [msg_textView resignFirstResponder];
}

@end


