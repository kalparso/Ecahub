//  MyWhatsOnListing.m
//  ecaHUB
//  Created by promatics on 5/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.


#import "MyWhatsOnListing.h"
#import "MyWhtsOnListingTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "whatsOnTableViewCell.h"
#import "DateConversion.h"
#import "CourseDetailViewController.h"
#import "LessionDetailViewController.h"
#import "EventViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SendMessageView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "addWhatsOnViewController.h"

@interface MyWhatsOnListing (){
    
    MyWhtsOnListingTableViewCell *cell;
    
    WebServiceConnection *whatsOnConn,*getListConn,*getFriendsConn;
    WebServiceConnection *deleteConn;
    WebServiceConnection *postConn;
    addWhatsOnViewController *addWhatson;
    WebServiceConnection *whatson_priceConn;
    WebServiceConnection *sendPaymentConn;
    PayPalPayment *payment;
    NSString *amount, *currency;
    DateConversion *dateConversion;
    
    CourseDetailViewController *courseView;
    
    LessionDetailViewController *lessonView;
    
    EventViewController *EventView;
    
    SendMessageView *sendMsgView;
    
    NSString *type, *memId, *whtsId,*selectedData;
    
    Indicator *indicator;
    
    NSArray *whatsOnArray ,*friendsArray;
    
    NSString *comment, *imgUrl, *urlString, *name, *discription, *whatson_id;
    
    NSDictionary *paramDict;
    
    float more_btn;
    
    NSString *price;
    
    NSString *freePost;
    
    NSInteger WhatOnCount;
    
    NSInteger index;
    
    NSString *freeWhats_on ;
    
}

@end

@implementation MyWhatsOnListing

@synthesize tapAddBtn,tble_view,postLbl_btn, environment, payPalConfig, resultText, acceptCreditCards,post_lbl,info_btn,sub_view;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"My \"What's On!\" Posts";
    
    whatsOnConn = [WebServiceConnection connectionManager];
    
    getListConn = [WebServiceConnection connectionManager];
    
    deleteConn = [WebServiceConnection connectionManager];
    
    postConn = [WebServiceConnection connectionManager];
    
    getFriendsConn =[WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    paramDict = [[NSDictionary alloc] init];
    
    sendPaymentConn = [WebServiceConnection connectionManager];
    
    whatson_priceConn = [WebServiceConnection connectionManager];
    
    more_btn = postLbl_btn.frame.origin.x;
    
    //Manoj, you just completed your payment.
    
    // Your transaction ID for this payment is: 63D35961U5438680U.
    // We'll send a confirmation email to promatics.manojsaini@gmail.com.
    
    //self.navigationItem.rightBarButtonItem = info_btn;
    
    self.navigationItem.rightBarButtonItems = @[info_btn,tapAddBtn];
    
    [self prepareInterFace];
    // Do any additional setup after loading the view.
    
    [self Method_Paypal];
}

-(void)prepareInterFace {
    
    CGRect frame;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        frame = postLbl_btn.frame;
        
        frame.origin.y = 10.0f;
        
        frame.origin.x = 20.0f;
        
        frame.size.height = 30.0f;
        
        frame.size.width = 30.0f;
        
        post_lbl.hidden = YES;
        
        frame = tble_view.frame;
        
        frame.origin.y = 67.0f;
        
        frame.size.height = self.view.frame.size.height - 115;
        
        tble_view.frame = frame;
        
        
    } else {
        
        
        frame = postLbl_btn.frame;
        
        frame.origin.y = 10.0f;
        
        frame.origin.x = 20.0f;
        
        frame.size.height = 21.0f;
        
        frame.size.width = 21.0f;
        
        postLbl_btn.frame = frame;
        
        post_lbl.hidden = YES;
        
        frame = tble_view.frame;
        
        frame.origin.y = 67.0f;
        
        frame.size.height = self.view.frame.size.height - 115;
        
        tble_view.frame = frame;
        
    }
    
    postLbl_btn.hidden = YES;
    
    post_lbl.hidden = YES;
    
    sub_view.hidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self fetchWhatsOnPosts];
    
    [self Method_Paypal];
    
    // Preconnect to PayPal early
    
    [self setPayPalEnvironment:self.environment];
}

-(void)fetchWhatsOnPosts {
    
    [self.view addSubview:indicator];
    
    info_btn.enabled = NO;
    
    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [whatsOnConn startConnectionWithString:@"whatson" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        info_btn.enabled = YES;
        
        if ([whatsOnConn responseCode] == 1) {
            
            postLbl_btn.hidden = NO;
            
            NSLog(@"%@", receivedData);
            
            price = [[[receivedData valueForKey:@"currency_price"] valueForKey:@"WhatsonPrice"] valueForKey:@"price"];
            
            NSLog(@"price %@",price);
            
            price = [price stringByAppendingString:@" "];
            
            price = [price stringByAppendingString:[[[receivedData valueForKey:@"currency_price"] valueForKey:@"WhatsonPrice"] valueForKey:@"currency"]];
            
            currency = [[[receivedData valueForKey:@"currency_price"] valueForKey:@"WhatsonPrice"] valueForKey:@"currency"];
            
            currency =[currency uppercaseString];
            
            NSLog(@"%@,currency",currency);
            
            freePost =  [[[receivedData valueForKey:@"free_post"] valueForKey:@"WhatsonFreePost"] valueForKey:@"free_post"];
            
            NSString *post_text = @"Post in \"What's On!\" to boost your Listing exposure. You get ";
            
            post_text = [post_text stringByAppendingString:[[[receivedData valueForKey:@"free_post"] valueForKey:@"WhatsonFreePost"] valueForKey:@"free_post"]];
            
            post_text = [post_text stringByAppendingString:@" FREE “What’s On!” posts per 30 day period, and you currently have "];
            
            
            WhatOnCount = (9 - [[receivedData valueForKey:@"whatson_count"] integerValue]);
            
            
            post_text = [post_text stringByAppendingString:[NSString stringWithFormat:@"%d left.",WhatOnCount]];
            
            post_lbl.text = post_text;
            
            
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                whatsOnArray = [receivedData valueForKey:@"posted_whatson"];
                
                tble_view.hidden = NO;
                
                [tble_view reloadData];
                
            } else {
                
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"No Record Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                tble_view.hidden = YES;
                
                [alert show];
            }
        }
    }];
}

#pragma mark - UITableViewDelegates & DataSourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [whatsOnArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (cell.mainView.frame.size.height+10);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"whstaOnCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil){
        
        cell = [[MyWhtsOnListingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"whstaOnCell"];
    }
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGRect frame1 = cell.mainView.frame;
        
        frame1.origin.x = 20;
        
        frame1.size.width = cell.frame.size.width - 40;
        
        cell.mainView.frame = frame1;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        CGRect frame1 = cell.mainView.frame;
        
        frame1.origin.x = 15;
        
        frame1.size.width = cell.frame.size.width - 30;
        
        cell.mainView.frame = frame1;
    }
    
    CGRect frame = cell.main_view.frame;
    
    frame.size.width = tble_view.frame.size.width - 20;
    
    cell.main_view.frame = frame;
    
    frame = cell.action_view.frame;
    
    // frame.origin.x = (cell.main_view.frame.size.width - frame.size.width)/2;
    
    frame.origin.x = 0;
    
    cell.action_view.frame = frame;
    
    frame = cell.image_view.frame;
    
    frame.size.width = tble_view.frame.size.width;
    
    frame.origin.y = 0;
    
    cell.image_view.frame = frame;
    
    //    frame = cell.check_Btn.frame;
    //
    //    frame.origin.x = cell.image_view.frame.size.width -cell.image_view.frame.origin.x -30;
    //
    //    cell.check_Btn.frame = frame;
    
    frame = cell.check_Btn.frame;
    
    frame.origin.x = cell.main_view.frame.size.width - frame.size.width - 35;
    
    cell.check_Btn.frame = frame;
    
    cell.listing_name.text = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"name"];
    
    NSString *date = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"created_at"];
    
    if ([date isEqualToString:@""]) {
        
        //date = @"0000-00-00 00:00";
        
        cell.post_date.text =  @"Pending";
        
    } else {
        
        cell.post_date.text = [dateConversion convertDate:date];
        
    }
    
    NSString *date1 = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"expiry_date"];
    
    cell.post_date_label.text = @"Create Date :";
    
    if ([date1 isEqualToString:@""]) {
        
        //date1 = @"0000-00-00 00:00";
        
        cell.expirydate_lbl.text = @"Pending";
        
    } else {
        
        cell.expirydate_lbl.text = [dateConversion convertDate:date1];
        
    }
    
    //cell.expiry_lbl.text = [dateConversion convertDate:date1];
    
    //    NSDate *nowDate = [NSDate date];
    //
    //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    //
    //    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //
    //    NSDate *expirydate = [dateFormat dateFromString:date1];
    //
    //    NSLog(@"%@",expirydate);
    //
    //    if ([expirydate compare:nowDate] != NSOrderedAscending) {
    //
    //        [cell.postBtn setUserInteractionEnabled:YES];
    //
    //    } else{
    //
    //        [cell.postBtn setUserInteractionEnabled: NO];
    //    }
    //
    
    NSString *list_type = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"listing_type"];
    
    NSString *desc = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"description"];
    
    //
    //    if([list_type isEqualToString:@"1"]){
    //
    //        desc = [desc stringByAppendingString:@" [course | "];
    //
    //
    //    } else if([list_type isEqualToString:@"2"]){
    //
    //        desc = [desc stringByAppendingString:@" [event | "];
    //
    //
    //    }else if([list_type isEqualToString:@"3"]){
    //
    //        desc = [desc stringByAppendingString:@" [lesson | "];
    //
    //    }
    
    NSString *city;
    
    city =[[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"city_name"];
    
    city = [city stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //city = [city stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    city = [city stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    city = [city capitalizedString];
    
    
    desc = [desc stringByAppendingString:city];
    
    desc = [desc stringByAppendingString:@" "];
    
    
    //desc = [desc stringByAppendingString:@" ] "];
    
    //cell.description_lbl.text = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"description"];
    
    cell.description_lbl.text = desc;
    
    //[cell.description_lbl sizeToFit];
    
    frame = cell.description_lbl.frame;
    
    frame.size.height = [self heightCalculate:cell.description_lbl.text:cell.description_lbl];
    
    frame.origin.y = cell.expirydate_lbl.frame.origin.y+cell.expirydate_lbl.frame.size.height + 10;
    
    cell.description_lbl.frame = frame;
    
    frame = cell.main_view.frame;
    
    frame.size.height = cell.description_lbl.frame.origin.y+cell.description_lbl.frame.size.height+7;
    
    cell.main_view.frame = frame;
    
    frame = cell.action_view.frame;
    
    frame.origin.y = cell.main_view.frame.origin.y+cell.main_view.frame.size.height;
    
    cell.action_view.frame = frame;
    
    frame = cell.mainView.frame;
    
    frame.size.height = cell.action_view.frame.origin.y+cell.action_view.frame.size.height+7;
    
    cell.mainView.frame = frame;
    
    
    NSString *course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
    
    //cell.educator_lbl.text = [[[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"CourseListing"] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
    
    cell.educator_lbl.text = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
    
    
    NSLog(@"Course Tap Id %@", course_id);
    
    if ([course_id isEqualToString:@""] && [[[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"] isEqualToString:@""]) {
        
        // course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"];
        
        //listing = @"LessonListing";
        
        // cell.educator_lbl.text = [[[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"LessonListing"] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
        
        
    }else if([course_id isEqualToString:@""] && [[[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"] isEqualToString:@""]) {
        
        //   course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"];
        
        //cell.educator_lbl.text = [[[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"EventListing"] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
        
        // listing = @"EventListing";
        
    }
    
    
    NSString *imageURL = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"picture"];
    
    if ([imageURL length] < 1) {
        
        cell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
        
    } else {
        
        cell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
        
        imageURL = [@"http://mercury.promaticstechnologies.com/ecaHub//img/whatson_images/" stringByAppendingString:imageURL];
        
        [cell.image_view sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Listing_Image"]];
        
    }
    
    cell.image_view.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [cell.editBtn addTarget:self action:@selector(tapEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.shareBtn addTarget:self action:@selector(tapShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.deleteBtn addTarget:self action:@selector(tapDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.postBtn addTarget:self action:@selector(tapPostBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.pay_btn addTarget:self action:@selector(tapPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.editBtn.tag = indexPath.row;
    
    cell.shareBtn.tag = indexPath.row;
    
    cell.postBtn.tag = indexPath.row;
    
    cell.deleteBtn.tag = indexPath.row;
    
    cell.pay_btn.tag = indexPath.row;
    
    NSString *payment_status = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"payment_status"];
    
    if ([payment_status isEqualToString:@"1"]) {
        
        cell.pay_btn.hidden = YES;
        
        cell.postBtn.hidden = NO;
        
    } else {
        
        cell.pay_btn.hidden = NO;
        
        cell.postBtn.hidden = YES;
    }
    
    cell.postBtn.hidden = NO;
    
    cell.pay_btn.hidden = YES;
    
    NSString *status = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"status"];
    
    if ([status isEqualToString:@"0"]) {
        
        [cell.postBtn setUserInteractionEnabled:YES];
        
        [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        
        [cell.postBtn setBackgroundImage:[UIImage imageNamed:@"upload_gray"] forState:UIControlStateNormal];
        
        cell.post_date_label.text = @"Create Date :";
        
        cell.expirydate_lbl.text = @"Pending";
        
        cell.post_lbl.text = @"Post";
        
    }
    else if([status isEqualToString:@"1"]){
        
        [cell.postBtn setUserInteractionEnabled:YES];
        
        [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"Check_Mark"] forState:UIControlStateNormal];
        
        [cell.postBtn setBackgroundImage:[UIImage imageNamed:@"post_gray"] forState:UIControlStateNormal];
        
        cell.post_date_label.text = @"Post Date :";
        
        date = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"post_date"];
        
        if ([date isEqualToString:@""]) {
            
            //date = @"0000-00-00 00:00";
            
            cell.post_date.text =  @"Pending";
            
        } else {
            
            cell.post_date.text = [dateConversion convertDate:date];
            
        }
        
        cell.post_lbl.text = @"Unpost";
        
        
    } else if ([status isEqualToString:@"2"]){
        
        NSDate *nowDate = [NSDate date];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *expirydate = [dateFormat dateFromString:date1];
        
        NSLog(@"%@",expirydate);
        
        if ([expirydate compare:nowDate] != NSOrderedAscending) {
            
            [cell.postBtn setUserInteractionEnabled:YES];
            
        } else{
            
            [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"expiry_icon"] forState:UIControlStateNormal];
            
            [cell.postBtn setUserInteractionEnabled: NO];
        }
    }
    
    [cell.check_Btn addTarget:self action:@selector(tapCheck_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.check_Btn.tag = indexPath.row;
    
    return cell;
}

-(void)tapCheck_btn: (UIButton *)sender {
    
    NSString *status = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey:@"WhatsonPost"] valueForKey:@"status"];
    
    NSString *message;
    
    if([ status isEqualToString:@"0"]){
        
        message = @"Unposted";
        
    } else if ([ status isEqualToString:@"1"]){
        
        message = @"Posted";
        
    } else if ([ status isEqualToString:@"2"]){
        
        message = @"Expired";
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
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
    
    CGFloat staticHieght;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        font = [UIFont systemFontOfSize:20];
        
        staticHieght = 30.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        font = [UIFont systemFontOfSize:17];
        
        staticHieght = 21.0f;
        
        
    }
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font} context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    [calculateText_lbl setFrame:CGRectMake(10, 74, 300 ,size.height+5)];
    
    [calculateText_lbl sizeToFit];
    
    CGFloat height_lbl = size.height;
    
    if (height_lbl > 30.0f) {
        
        return (height_lbl);
    }
    
    else{
        
        return staticHieght;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // listing_type
    
    NSString *listing = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"listing_type"];
    
    NSString *course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
    
    NSLog(@"Course Tap Id%@", course_id);
    
    if ([listing isEqualToString:@"1"]) {
        
        course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
        
        listing = @"CourseListing";
        
    } else if([listing isEqualToString:@"3"]){
        
        course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"];
        
        listing = @"LessonListing";
        
        
    } else if([listing isEqualToString:@"2"]||[course_id isEqualToString:@""]){
        
        course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"];
        
        listing = @"EventListing";
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        UIStoryboard *storyboard = self.storyboard;
        
        courseView = [storyboard instantiateViewControllerWithIdentifier:@"courseDetail"];
        
        [self.navigationController pushViewController:courseView animated:YES];
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        UIStoryboard *storyboard = self.storyboard;
        
        lessonView = [storyboard instantiateViewControllerWithIdentifier:@"lessionDetail"];
        
        [self.navigationController pushViewController:lessonView animated:YES];
        
    }else if ([listing isEqualToString:@"EventListing"]){
        
        UIStoryboard *storyboard = self.storyboard;
        
        EventView = [storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
        
        [self.navigationController pushViewController:EventView animated:YES];
        
    }
}

-(void)tapPayBtn {
    
    
    NSString *message = @"You have already used up your Free Posts for the month. To post this \"What's On!\" now you will be charged ";
    
    
    // Do you wish to continue?
    
    message = [message stringByAppendingString:price];
    
    message = [message stringByAppendingString:@".\nDo you wish to continue?"];
    
    
    float Price_post = [price floatValue];
    
    amount = [NSString stringWithFormat:@"%.2f",Price_post];
    
    
    UIAlertView *alert =[ [UIAlertView alloc]initWithTitle:Alert_title message:message delegate:self cancelButtonTitle:@"Proceed to Payment" otherButtonTitles:@"Cancel", nil];
    
    alert.tag = 10;
    
    [alert show];
    
}



-(void)tapPayBtn:(UIButton *)sender{
    
    //NSLog(@"dfgd");  HKD
    
    whatson_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey:@"WhatsonPost"] valueForKey:@"id"];
    
    [self.view addSubview:indicator];
    
    [whatson_priceConn startConnectionWithString:@"whatson_price" HttpMethodType:Post_Type HttpBodyType:@{} Output:^(NSDictionary *receivedData){
        
        if ([whatson_priceConn responseCode] == 1) {
            
            NSLog(@"%@",receivedData);
            
            // currency = @"HKD";
            
            // amount = [receivedData valueForKey:@"cost"];
            
            [self Method_Paypal];
            
            [self singlePayment];
        }
    }];
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
    
    // NSDecimalNumber *price_event = [[NSDecimalNumber alloc] initWithString:amount];
    
    NSDecimalNumber *price_event = [[NSDecimalNumber alloc] initWithString:price];
    
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
    //payment_status = approved, txn_id, whatson_id, amount,'member_id'
    
    NSDictionary *paramURL = @{@"payment_status":@"approved", @"txn_id":[[paymentData valueForKey:@"response"] valueForKey:@"id"], @"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"whatson_id":whatson_id, @"amount":amount};
    
    
    NSLog(@"%@",paramURL);
    
    [self.view addSubview:indicator];
    
    [sendPaymentConn startConnectionWithString:@"whatson_pay" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([sendPaymentConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:[receivedData valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            // Once the payment has been processed you will receive a payment confirmation to your registered email address. Do check your Inbox or Junk Mail (just in case). Your "What's On!" will be posted in a few minutes.
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Your ''What's On!'' post is now viewable by all members!" delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
            
            
            [alert show];
            
            [self fetchWhatsOnPosts];
        }
    }];
}

-(void)tapPostBtn:(UIButton *)sender{
    
    NSString *status, *whatsId;
    
    
    whatsId = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey:@"WhatsonPost"] valueForKey:@"id"];
    
    status = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey:@"WhatsonPost"] valueForKey:@"status"];
    
    type = @"1";
    
    NSString *course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
    
    NSLog(@"Course Tap Id %@", course_id);
    
    if ([course_id isEqualToString:@""] && [[[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"] isEqualToString:@""]) {
        
        course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"];
        
        type = @"3";
        
    }else if([course_id isEqualToString:@""] && [[[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"] isEqualToString:@""]) {
        
        course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"];
        
        type = @"2";
        
    }
    if ([status isEqualToString:@"0"]||[status isEqualToString:@""]) {
        
        //member_id, list_id, type=1, status('0'=>'un post','1'=>'Post','2'=>'expire')
        
        whatson_id = whatsId;
        
        status = @"1";
        
    }else if ([status isEqualToString:@"1"]){
        
        status = @"0";
        
        
    }
    
    if([status isEqualToString:@"1"] && WhatOnCount <= 0) {
        
        index = sender.tag;
        
        
        [self tapPayBtn];
        
    } else {
        
        
        [self.view addSubview:indicator];
        
        
        NSDictionary *paramUrl = @{@"whatson_id":whatsId,@"status":status};
        
        [postConn startConnectionWithString:@"whatson_post_unpost" HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary * receivedData){
            
            [indicator removeFromSuperview];
            
            if ([postConn responseCode] == 1) {
                
                NSLog(@"%@",receivedData);
                
                [self fetchWhatsOnPosts];
                
                if ([status isEqualToString:@"1"]) {
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Your ''What's On!'' post is now viewable by all members!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You have successfully unposted this \"What's On!\". It is no longer viewable by others." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    WhatOnCount = WhatOnCount -1;
                    
                    [alert show];
                    
                }
                
            }
            
        }];
    }
    
}
-(void)tapDeleteBtn:(UIButton *)sender {
    
    //[self.view addSubview:indicator];
    
    type = @"1";
    
    NSString *course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
    
    NSLog(@"Course Tap Id %@", course_id);
    
    if ([course_id isEqualToString:@""] && [[[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"] isEqualToString:@""]) {
        
        course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"];
        
        type = @"3";
        
    }else if([course_id isEqualToString:@""] && [[[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"] isEqualToString:@""]) {
        
        course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"];
        
        type = @"2";
        
    }
    //else {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Are you sure? By deleting this \"What's On!\" post it will no longer be viewable by you or others." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"NO", nil];
    
    alert.tag = sender.tag;
    
    [alert show];
    
    // }
    //[indicator removeFromSuperview];
    
    memId = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey:@"WhatsonPost"] valueForKey:@"member_id"];
    
    whtsId = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey:@"WhatsonPost"] valueForKey:@"id"];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 10){
        
        if(buttonIndex == 0){
            
            
            whatson_id = [[[whatsOnArray objectAtIndex:index] valueForKey:@"WhatsonPost"] valueForKey:@"id"];
            
            //            [self.view addSubview:indicator];
            //
            //            [whatson_priceConn startConnectionWithString:@"whatson_price" HttpMethodType:Post_Type HttpBodyType:@{} Output:^(NSDictionary *receivedData){
            //
            //                [indicator removeFromSuperview];
            //
            //                if ([whatson_priceConn responseCode] == 1) {
            //
            //                    NSLog(@"%@",receivedData);
            //
            //                    currency = @"HKD";
            //
            //                   // amount = [receivedData valueForKey:@"cost"];
            //
            //                    [self Method_Paypal];
            //
            //                    [self singlePayment];
            //                }
            //            }];
            
            
            [self Method_Paypal];
            
            [self singlePayment];
        }
        
    } else {
        
        if (buttonIndex == 0) {
            
            [self.view addSubview:indicator];
            
            paramDict = @{@"member_id":memId,@"whats_on_id":whtsId,@"type":type};
            
            //member_id, whats_on_id, type (1 for course, 2 for event, 3 for lesson)
            
            [deleteConn startConnectionWithString:@"delete_whaton_listing" HttpMethodType:Post_Type HttpBodyType:paramDict Output:^(NSDictionary *receivedData) {
                
                
                [indicator removeFromSuperview];
                
                if ([deleteConn responseCode] == 1) {
                    
                    NSLog(@"%@", receivedData);
                    
                    
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                    
                    [self fetchWhatsOnPosts];
                }
            }];
        }
        
    }
}



-(void)tapShareBtn:(UIButton *)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter",@"Linkedin",@"Email",@"Message", nil];
    
    actionSheet.tag = sender.tag;
    
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //  NSString *listing = @"CourseListing";
    
    NSString *course_id = [[[whatsOnArray objectAtIndex:actionSheet.tag] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
    
    NSLog(@"Course Tap Id %@", course_id);
    
    name = [[[whatsOnArray objectAtIndex:actionSheet.tag] valueForKey:@"WhatsonPost"] valueForKey:@"name"];
    
    discription =[[[whatsOnArray objectAtIndex:actionSheet.tag] valueForKey:@"WhatsonPost"] valueForKey:@"description"];
    
    imgUrl = [WhatsOnImgURL stringByAppendingString:[[[whatsOnArray objectAtIndex:actionSheet.tag] valueForKey:@"WhatsonPost"] valueForKey:@"picture"]];
    
    NSLog(@"image %@",imgUrl);
    
    comment =[name stringByAppendingString:@"\n"];
    
    comment = [comment stringByAppendingString:discription];
    
    comment = [comment stringByAppendingString:@" "];
    
    
    if (buttonIndex == 0) {
        
        paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                     @"I just posted a post on ECAhub", @"name",
                     comment, @"caption",
                     @"", @"description",
                     @"http://mercury.promaticstechnologies.com/ecaHub/", @"link",
                     imgUrl, @"picture",
                     nil];
        NSLog(@"%@", paramDict);
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:paramDict
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      
                                                      if (error) {
                                                          
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                          
                                                      } else {
                                                          
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              
                                                              NSLog(@"User cancelled.");
                                                              
                                                          } else {
                                                              
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  
                                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Shared successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                  
                                                                  [alert show];
                                                                  
                                                                  NSLog(@"result %@", result);
                                                                  
                                                              }
                                                          }
                                                      }
                                                  }];
    }
    else if (buttonIndex == 1){
        
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            //   NewsFeedsCustomCell *cell = (NewsFeedsCustomCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexNo inSection:0]];
            
            //  urlString = [urlString stringByAppendingString:[[arrayNewsFeeds[indexNo] valueForKey:@"Post"] valueForKey:@"website"]];
            
            [tweetSheet setInitialText:comment];
            
            [tweetSheet addURL:[NSURL URLWithString:@"http:/http://mercury.promaticstechnologies.com/ecaHub/"]];
            
            // [tweetSheet addImage:imageView.image];
            
            [tweetSheet addImage:[UIImage imageNamed:@"logo"]];
            
            [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                        
                    case SLComposeViewControllerResultCancelled:
                        
                        NSLog(@"Post Canceled");
                        break;
                        
                    case SLComposeViewControllerResultDone:
                    {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Shared successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alert show];
                        
                        NSLog(@"Post Sucessful");
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Twitter Accounts" message:@"There are no Twitter accounts configured.You can add or create a Twitter  account in Settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
        
        
    }
    else if (buttonIndex == 2){
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"linkinShare"];
        
        NSString *launchUrl = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=78imindwbpf3mg&redirect_uri=http%3A%2F%2Fmercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect&state=ecaHub987654321&scope=r_fullprofile%20r_emailaddress%20w_share";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:launchUrl]];
        
        NSDictionary *dict = @{@"title":name, @"description": discription, @"img_url":imgUrl};
        
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"linkedInShareData"];
        
    }
    
    
    else if (buttonIndex == 3){
        
        NSData *Imgdata =  UIImageJPEGRepresentation(cell.image_view.image, 7);
        
        MFMailComposeViewController * mail = [[MFMailComposeViewController alloc] init];
        
        [mail addAttachmentData:Imgdata mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"photo.jpg"]];
        
        NSString *msgBody = comment;
        
        mail.mailComposeDelegate = self;
        
        NSString *link = @"www.ECAhub.com";
        
        link = [@"\n\n" stringByAppendingString:link];
        
        msgBody = [msgBody stringByAppendingString:link];
        
        NSLog(@"%@",msgBody);
        
        [mail setMessageBody:msgBody isHTML:YES];
        
        //        NSArray *to_recipient = [NSArray arrayWithObject:[[[whatsOnArray objectAtIndex:actionSheet.tag]valueForKey:@"Member"] valueForKey:@"email"]];
        //
        //        NSLog(@"%@",to_recipient);
        //
        //        [mail setToRecipients:to_recipient];
        
        
        [mail setSubject:[NSString stringWithFormat:@"%@ posted on ECAhub",name]];
        
        [self presentViewController:mail animated:YES completion:nil];
        
    }
    else if (buttonIndex == 4){
        
        sendMsgView = [[SendMessageView alloc] init];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"MessageSharingView" owner:self options:nil] objectAtIndex:0];
        
        sendMsgView.frame = self.view.frame;
        
        sendMsgView.view_frame = self.view.frame;
        
        //[sendMsgView.send_btn setTitle:@"Send" forState:UIControlStateNormal];
        
        // sendMsgView.cancelBtn.hidden = NO;;
        
        
        //        sendMsgView.to_textField.text = [[[whatsOnArray objectAtIndex:actionSheet.tag] valueForKey:@"Member"]valueForKey:@"email"];
        
        [sendMsgView.toMsg_btn addTarget:self action:@selector(tapTo_btn:) forControlEvents:UIControlEventTouchUpInside];
        
        sendMsgView.message_textview.text = discription;
        
        [self.view addSubview:sendMsgView];
        
    }
    
}
-(void)tapTo_btn:(UIButton *)sender{
    
    NSDictionary *dict = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [getFriendsConn startConnectionWithString:@"invited_friends" HttpMethodType:Post_Type HttpBodyType:dict Output:^(NSDictionary * receivedData){
        
        [indicator removeFromSuperview];
        
        if ([getFriendsConn responseCode] == 1) {
            
            NSLog(@"%@",receivedData);
            
            friendsArray = [receivedData valueForKey:@"joined"];
            
            if ([friendsArray count]<1) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"you have no friends in your friend list" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            } else{
                
                [self showListData:friendsArray allowMultipleSelection:YES selectedData:[selectedData componentsSeparatedByString:@", "] title:@"My Friends"];
                
            }
            
        }
        
    }];
    
}

-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectData title:(NSString *)title {
    
    ListingViewController *listViewController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"listingVC"];
        
    } else {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil] instantiateViewControllerWithIdentifier:@"listingVC"];
    }
    
    listViewController.isMultipleSelected = allowMultipleSelection;
    
    listViewController.array_data = [items mutableCopy];
    
    listViewController.selectedData = [selectData mutableCopy];
    
    listViewController.delegate = self;
    
    listViewController.title = title;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - list delegate

-(void)didSelectListItem:(id)item index:(NSInteger)index {
    
    
}


-(void)didSaveItems:(NSArray*)items indexs:(NSArray *)indexs{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *array_selectedInterest = [NSMutableArray array];
    
    //   NSMutableArray *array_Ids = [NSMutableArray array];
    
    NSArray *listDataArray = friendsArray;
    
    
    for (NSIndexPath *indexPath in indexs) {
        
        NSLog(@"IndexPath:%ld",(long)indexPath.row);
        
        if (indexs.count > listDataArray.count) {
            
            if (indexPath.row < listDataArray.count) {
                
                [array_selectedInterest addObject:listDataArray[indexPath.row]];
                
            }
            
        } else {
            
            [array_selectedInterest addObject:listDataArray[indexPath.row-1] ];
            
        }
    }
    
    [array_selectedInterest setArray:[[NSSet setWithArray:array_selectedInterest] allObjects]];
    
    NSString *cat_interest = [array_selectedInterest componentsJoinedByString:@", "];
    
    //cat_interest = [@"  " stringByAppendingString:cat_interest];
    
    sendMsgView.toTextField.text = cat_interest;
    
    //[sendMsgView.to_btn setTitle:cat_interest forState:UIControlStateNormal];
    
    //[sendMsgView.to_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    
    NSString *str = [array_selectedInterest  componentsJoinedByString:@", "];
    
    str = [@"  " stringByAppendingString:str];
    
    selectedData = [array_selectedInterest  componentsJoinedByString:@", "];
    
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Here goes the code to handle the links
                                      // Use the links to show a relevant view of your app to the user
                                  }];
    
    return urlWasHandled;
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    for (NSString *pair in pairs) {
        
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        params[kv[0]] = val;
        
    }
    return params;
}

#pragma mark - MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Shared successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            break;
        }
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tapEditBtn:(UIButton *)sender {
    
    NSDictionary *dict = [[whatsOnArray objectAtIndex:sender.tag] valueForKey:@"WhatsonPost"];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"whatsOnPost"];
    
    [self performSegueWithIdentifier:@"editWhatsonSegue" sender:self];
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString indexPath:(NSIndexPath *)indexPath {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            cell = (MyWhtsOnListingTableViewCell *)[tble_view cellForRowAtIndexPath:indexPath];
            
            cell.image_view.image = image;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapAdd_btn:(id)sender {
    
    //    UIStoryboard *storyboard = self.storyboard;
    //
    //    addWhatson = [storyboard instantiateViewControllerWithIdentifier:@"addWhatsOnVC"];
    //
    //    [self.navigationController pushViewController:addWhatson animated:YES];
    
    NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [getListConn startConnectionWithString:@"select_whatson" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([getListConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 0) {
                
                NSArray *listArray = [receivedData valueForKey:@"merged_array"];
                
                if (listArray.count < 1) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"To post in \"What's On!\" you need to first have an active posted Listing. Go to \'My Listings\' in your Dashboard, create and post a Listing and you will be prompted to post in \"What's On!\"." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                } else {
                    
                    UIStoryboard *storyboard = self.storyboard;
                    
                    addWhatson = [storyboard instantiateViewControllerWithIdentifier:@"addWhatsOnVC"];
                    
                    addWhatson.tapWhatsOn_list = YES;
                    
                    [self.navigationController pushViewController:addWhatson animated:YES];
                    
                    
                }
            }
        }
    }];
}

- (IBAction)tapPostLbl_btn:(id)sender {
    
    // “What’s On!” posts are viewable for 14 days on the website, and on the App. Choose any of your Listings to create a post. You have 9 FREE posts
    // per calendar month, which expire at the end of the month. But if you would like to post more than your free amount for any given 30 day period, you can for only 0.99 USD per post. Post now!
    
    NSString *message;
    
    message = post_lbl.text;
    
    message = [message stringByAppendingString:@"\n\n“What’s On!” posts are viewable for 14 days on the website, and on the App. Choose any of your Listings to create a post. You have "];
    
    message = [message stringByAppendingString:freePost];
    
    message = [message stringByAppendingString:@" FREE posts per calendar month, which expire at the end of the month. But if you would like to post more than your free amount for any given 30 day period, you can for only  "];
    
    message = [message stringByAppendingString:price];
    
    message = [message stringByAppendingString:@" per post. Post now!"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}
- (IBAction)tapInfo_btn:(id)sender {
    
    NSString *message;
    
    //Post in "What's On!" to boost your Listing exposure. "What's On!" posts are viewable for 14 days on the website and on the app. Choose any of your Listings to create a post. You have X FREE posts per 30 day period, and you currently have Y left. If you would like to post more than your free number for any given 30 day period, you can for only z.zz USD per post. Post now!
    
    message = @"Post in \"What's On!\" to boost your Listing exposure. \"What's On!\" posts are viewable for 14 days on the website and on the app. Choose any of your Listings to create a post. You have ";
    
    // message = post_lbl.text;
    
    message = [message stringByAppendingString:freePost];
    
    
    message = [message stringByAppendingString:@" FREE posts per 30 day period, and you currently have "];
    
    if(WhatOnCount < 0){
        
        message = [message stringByAppendingString:@"0 left. If you would like to post more than your free number for any given 30 day period, you can for only "];
        
    } else {
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%d left. If you would like to post more than your free number for any given 30 day period, you can for only ",WhatOnCount]];
    }
    
    message = [message stringByAppendingString:[price uppercaseString]];
    
    message = [message stringByAppendingString:@" per post. Post now!"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}
@end