//
//  MessageViewController.m
//  ecaHUB
//
//  Created by promatics on 4/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "SendMessageView.h"
#import "MsgConversationViewController.h"

@interface MessageViewController () {
    
    MessageTableViewCell *cell;
    
    WebServiceConnection *messageConn;
    
    WebServiceConnection *deleteMsgConn,*reportAbuseConn;
    
    DateConversion *dateConversion;
    
    Indicator *indicator;
    
    NSArray *messagesArray, *allMessageArray;
    
    NSString *member_id;
    
    SendMessageView *sendMsgView;
    
    UIRefreshControl *refreshControl;
    
    BOOL isRefresh, tapUserMsg, tapNotification;
    
    NSMutableArray *delete_array, *userMsgArray, *noticationArray;
}
@end

@implementation MessageViewController

@synthesize table_View, unreadMsgBtn, unreadMsg, chatBtn, numer_chat, user_btn, send_msgBtn, business_btn,reportAbuse_btn;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    messageConn = [WebServiceConnection connectionManager];
    
    deleteMsgConn = [WebServiceConnection connectionManager];
    
    reportAbuse_btn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    delete_array = [[NSMutableArray alloc] init];
    
    userMsgArray = [[NSMutableArray alloc] init];
    
    noticationArray = [[NSMutableArray alloc] init];
    
//    [self fetchMessages];
    
    refreshControl = [[UIRefreshControl alloc] init];
        
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [table_View addSubview:refreshControl];
    
    isRefresh = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchMessages) name:@"FetchMessages" object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    isRefresh = NO;
    
    [self fetchMessages];
}

#pragma mark - RefreshController

-(void)refreshTable {
    
    isRefresh = YES;
    
    [self fetchMessages];
}

-(void)fetchMessages {
    
    if (!isRefresh) {
        
        [self.view addSubview:indicator];
    }
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    NSDictionary *paramURL = @{@"member_id" : member_id};
    
    [messageConn startConnectionWithString:@"message" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [refreshControl endRefreshing];
        
        if (!isRefresh) {
            
            [indicator removeFromSuperview];
            
            isRefresh = NO;
        }
        
        if ([messageConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                messagesArray = [receivedData valueForKey:@"info"];
                
                allMessageArray = [receivedData valueForKey:@"info"];
                
                unreadMsg.text = [NSString stringWithFormat:@"(%@)",[receivedData valueForKey:@"unread"]];
                
                table_View.hidden = NO;
                
                [table_View reloadData];
                
                [self filterMsg];
                
            } else {
                
                table_View.hidden = YES;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No message found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
    
}

-(void)filterMsg {
    
    for (int i = 0; i < allMessageArray.count; i++) {
        
        if ([[[[allMessageArray objectAtIndex:i] valueForKey:@"Message"] valueForKey:@"message_type"] isEqualToString:@"1"]) {
            
            [userMsgArray addObject:[allMessageArray objectAtIndex:i]];
            
        } else {
            
            [noticationArray addObject:[allMessageArray objectAtIndex:i]];
        }
    }
}



#pragma mark - UITableview Delegates & Datasourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return messagesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
   
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect frame = cell.main_view.frame;
    frame.size.width = table_View.frame.size.width-20;
    frame.origin.x = 10;
    cell.main_view.frame = frame;
    
    NSString *name = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"first_name"];
    
    if ([name isEqualToString:@""]) {
        
        name = @"ECAhub";
    }
    
    NSString *mem_name = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Member2"] valueForKey:@"first_name"];
    
    if ([mem_name isEqualToString:@""]) {
        
        name = @"ECAhub";
    }
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@",%@",mem_name]];
    
    cell.user_name.text = name;
    
    cell.subject.text = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"subject"];
    
    NSString *message_content = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"message_content"];
    
    message_content = [message_content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    cell.message.text = message_content;
    
    //[cell.message sizeToFit];
    
    NSString *timeStr = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"date_time"];
    
    cell.time_lbl.text = [dateConversion getDateFromString:timeStr];
    
    frame = cell.time_lbl.frame;
    
    frame.origin.x = cell.main_view.frame.size.width - frame.size.width - 5;
    
    cell.time_lbl.frame = frame;
 
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];

        cell.user_img.layer.cornerRadius = 40.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        cell.user_img.layer.cornerRadius = 30.0f;
    }

    
    cell.user_img.layer.masksToBounds = YES;
    
    NSString *img_url = profilePicURL;
    
    //NSLog(@"%@",img_url);
    
    img_url = [img_url stringByAppendingString:[[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"picture"]];
    
    NSString *Imgurl =[[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"picture"];
    
    if ([Imgurl isEqualToString:@""]) {
       
        cell.user_img.image = [UIImage imageNamed:@"user_img"];
    
    } else{
    
   // NSLog(@"%@",img_url);
    
    [self downloadImageWithString:img_url indexPath:indexPath];
    }
    //[self downloadImageWithString:img_url indexPath:indexPath];
    
    frame = cell.rating_view.frame;
    
    frame.origin.x = 5.0f;
    
    cell.rating_view.frame = frame;
    
    cell.rate_no = 4.0f;
    
    [cell setRating];
    
    if ([member_id isEqualToString:[[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"sender_id"]]) {
        
        cell.msg_type_img.image = [UIImage imageNamed:@"right_arrow_gray"];
    
    } else {
        
        cell.msg_type_img.image = [UIImage imageNamed:@"left_arrow_gray"];
    }
    
    if ([[[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"message_type"] isEqualToString:@"1"]) {
        
        [cell.userImgIcon_bttn setBackgroundImage:[UIImage imageNamed:@"user_gray"] forState:UIControlStateNormal];
        
    } else {
        
        [cell.userImgIcon_bttn setBackgroundImage:[UIImage imageNamed:@"suitcase_gray"] forState:UIControlStateNormal];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle==UITableViewCellEditingStyleDelete) {
        
      
        NSLog(@"Tap Delete");
        
        NSString *msgId;
        
        if ([member_id isEqualToString:[[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"sender_id"]]) {
            
            msgId = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"id"];
            
            msgId = [msgId stringByAppendingString:@":sender"];
            
        } else {
            
            cell.msg_type_img.image = [UIImage imageNamed:@"left_arrow_gray"];
            
            msgId = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"id"];
            
            msgId = [msgId stringByAppendingString:@":receiver"];
        }
        
        [self.view addSubview:indicator];
        
        NSDictionary *paramURL = @{@"delete[0]":msgId};
        
        [deleteMsgConn startConnectionWithString:@"trash_to_messages" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([deleteMsgConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                [self fetchMessages];
            }
        }];
        
        //trash_to_messages
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.isEditing) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        NSString *msg_id = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"id"];
        
        NSString *type = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"id"];
        
        if ([type isEqualToString:member_id]) {
            
            msg_id = [msg_id stringByAppendingString:@":sender"];
            
        } else {
            
            msg_id = [msg_id stringByAppendingString:@":receiver"];
        }
        
        [delete_array addObject:msg_id];
        
    } else {
    
        NSString *message_id = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"id"];
    
        [[NSUserDefaults standardUserDefaults] setValue:message_id forKey:@"MsgConvID"];
    
        [self performSegueWithIdentifier:@"messageViewSegue" sender:self];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.isEditing) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
     
        NSString *msg_id = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Message"] valueForKey:@"id"];
    
        NSString *type = [[[messagesArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"id"];
    
        if ([type isEqualToString:member_id]) {
        
            msg_id = [msg_id stringByAppendingString:@":sender"];
        
        } else {
        
            msg_id = [msg_id stringByAppendingString:@":receiver"];
        }
    
        [delete_array removeObject:msg_id];
    }

}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString indexPath:(NSIndexPath *)indexPath {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            cell = (MessageTableViewCell *)[self.table_View cellForRowAtIndexPath:indexPath];
            
            cell.user_img.image = image;
        }
    }];
}

- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];
}

- (IBAction)tapdelete_bttn:(id)sender {
    
    
    if (table_View.isEditing) {
        
        [table_View setEditing:NO animated:YES];
        
        [self deleteMultipleMsg];
        
    } else {
        
        [table_View setEditing:YES animated:YES];
    }

}

- (IBAction)tapBusinessBtn:(id)sender {
    
 [noticationArray removeAllObjects];

tapNotification = YES;

tapUserMsg = NO;

[self filterMsg];

messagesArray = [noticationArray copy];

[table_View reloadData];
}

- (IBAction)tapUserBtn:(id)sender {
    
    [userMsgArray removeAllObjects];
    
    tapUserMsg = YES;
    
    tapNotification = NO;
    
    [self filterMsg];
    
    messagesArray = [userMsgArray copy];
    
    [table_View reloadData];
}

- (IBAction)tapSeachBtn:(id)sender {
    
}

- (IBAction)tapNewMsgBtn:(id)sender {
    
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
    
    sendMsgView.frame = self.view.frame;
    
    sendMsgView.view_frame = self.view.frame;
    
    sendMsgView.subject.layer.borderWidth = 1.0f;
    
    sendMsgView.subject.layer.borderColor = [UIColor lightGrayColor].CGColor;

    [self.view addSubview:sendMsgView];
}

- (IBAction)tapUnreadBtn:(id)sender {
}

- (IBAction)tapChatBtn:(id)sender {
}

- (IBAction)tapDeleteBtn:(id)sender {
    
  }

-(void)deleteMultipleMsg {
    
    [self.view addSubview:indicator];
    
    if ([delete_array count] > 0) {
        
        NSMutableDictionary *paramURL = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *keys = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < delete_array.count; i++) {
            
            [keys addObject:[NSString stringWithFormat:@"delete[%d]",i]];
        }
       
        paramURL = [NSMutableDictionary dictionaryWithObjects:delete_array forKeys:keys];
    
        [deleteMsgConn startConnectionWithString:@"trash_to_messages" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
            [indicator removeFromSuperview];
        
            if ([deleteMsgConn responseCode] == 1) {
            
                NSLog(@"%@", receivedData);
            
                [self fetchMessages];
            }
        }];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please select atleast one message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (IBAction)tapAbuse_btn:(id)sender {
    
    [self.view addSubview:indicator];
    
    NSDictionary *dict = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"sender_id":[[messagesArray valueForKey:@"Message"] valueForKey:@"sender_id"],@"receiver_id":[[messagesArray valueForKey:@"Message"] valueForKey:@"receiver_id"],@"main_message_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"MsgConvID"],@"message":[[messagesArray valueForKey:@"Message"] valueForKey:@"message_content"],@"message_date":[[messagesArray valueForKey:@"Message"] valueForKey:@"date_time"]};
    
    [reportAbuseConn startConnectionWithString:@"report_abuse_message" HttpMethodType:Post_Type HttpBodyType:dict Output:^(NSDictionary * receivedData){
        
        [indicator removeFromSuperview];
        
        if ([reportAbuseConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Your request has been sent successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }];
    
  
    
   
    
}
@end
