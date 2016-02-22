//
//  WhatsOnPostViewController.m
//  ecaHUB
//
//  Created by promatics on 4/16/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "WhatsOnPostViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "whatsOnTableViewCell.h"
#import "DateConversion.h"
#import "SendMessageView.h"
#import "CourseDetailViewController.h"
#import "LessionDetailViewController.h"
#import "EventViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SDWebImage/UIImageView+WebCache.h"

@interface WhatsOnPostViewController () {
    
    whatsOnTableViewCell *cell;
    
    WebServiceConnection *whatsOnConn,*pinTOFavConnection,*getFriendsConn;
    
    DateConversion *dateConversion;
    
    CourseDetailViewController *courseView;
    
    EventViewController *EventView;
    
    LessionDetailViewController *LessonView;
    
    Indicator *indicator;
    
    NSArray *whatsOnArray,*friendsArray;
    
    SendMessageView *sendMsgView;
    
    NSString *comment, *imgUrl, *urlString, *name, *discription,*fav,*member_id,*selectedData;
    
    NSDictionary *paramDict;
    
    NSMutableArray *FAVarray;
    
    NSString *list_id,*type_str, *listing;
    
    BOOL tapFiletr;
    
    NSInteger type;
    
}
@end

@implementation WhatsOnPostViewController

@synthesize text_label, tble_view,filter_btn;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"\"What's On! Posts\"";
    
    whatsOnConn = [WebServiceConnection connectionManager];
    
    getFriendsConn =[WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    pinTOFavConnection = [WebServiceConnection connectionManager];
    
    paramDict = [[NSDictionary alloc] init];
    
    FAVarray = [[NSMutableArray alloc]init];
    
    fav = @"0";
    
    type = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = filter_btn;
    
    self.tabBarController.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self fetchWhatsOnPosts];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    int tabitem = (int)tabBarController.selectedIndex;
    
    [[tabBarController.viewControllers objectAtIndex:tabitem] popToRootViewControllerAnimated:NO];
    
    [self fetchWhatsOnPosts];
}

-(void)fetchWhatsOnPosts {
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    [self.view addSubview:indicator];
    
    //  NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    NSDictionary *paramURL;
    NSString *service;
    
    NSString *arrayname;
    
    if(type == 0){
        
        paramURL = @{};
        
        service = @"whatson";
        
        arrayname =@"posted_whatson";
        
    } else {
        
        service = @"whatson_search";
        
        arrayname =@"info_array";
        
        paramURL  = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    }
    
    [whatsOnConn startConnectionWithString:service HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([whatsOnConn responseCode] == 1) {
            
            if(type == 0) {
                
                [filter_btn setImage:[UIImage imageNamed:@"filter"]];
                
            } else {
                
                [filter_btn setImage:[UIImage imageNamed:@"reset_icon"]];
                
            }
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                whatsOnArray = [receivedData valueForKey:arrayname];
                
                BOOL isfav = NO;
                
                [FAVarray removeAllObjects];
                
                for (int j = 0; j< whatsOnArray.count; j++) {
                    
                    
                    NSString *course_id ;
                    
                    NSString *list_type = [[[whatsOnArray objectAtIndex:j] valueForKey: @"WhatsonPost"] valueForKey:@"listing_type"];
                    
                    if ([list_type isEqualToString:@"1"]) {
                        
                        course_id = [[[whatsOnArray objectAtIndex:j] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
                        
                        listing = @"CourseListing";
                        
                    } else if([list_type isEqualToString:@"3"]){
                        
                        course_id = [[[whatsOnArray objectAtIndex:j] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"];
                        
                        listing = @"LessonListing";
                        
                        
                    } else if([list_type isEqualToString:@"2"]||[course_id isEqualToString:@""]){
                        
                        course_id = [[[whatsOnArray objectAtIndex:j] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"];
                        
                        listing = @"EventListing";
                        
                    }
                    
                    
                    NSArray *favoriteArray = [[[whatsOnArray objectAtIndex:j] valueForKey:listing]  valueForKey:@"Favorite"];
                    
                    isfav = NO;
                    
                    for (int i = 0; i< favoriteArray.count; i++) {
                        
                        if ([member_id isEqualToString:[[favoriteArray objectAtIndex:i] valueForKey:@"member_id"]]) {
                            
                            //  [cell.favPin_btn setImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                            
                            isfav = YES;
                            
                            fav = @"1";
                            
                        }else{
                            
                            isfav = NO;
                        }
                    }
                    if (isfav) {
                        
                        [FAVarray addObject:@"YES"];
                        
                    } else{
                        
                        [FAVarray addObject:@"NO"];
                    }
                    
                }
                
                tble_view.hidden = NO;
                
                [tble_view reloadData];
                
            } else {
                
                tble_view.hidden = YES;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"No Record Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
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
    
    return cell.mainView.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"whstaOnCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil){
        
        cell = [[whatsOnTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"whstaOnCell"];
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
    
    frame.size.width = cell.mainView.frame.size.width;
    
    cell.main_view.frame = frame;
    
    frame = cell.action_view.frame;
    
    //frame.origin.x = cell.main_view.frame.origin.x -10;
    
    frame.size.width = cell.mainView.frame.size.width;
    
    cell.action_view.frame = frame;
    
    frame = cell.image_view.frame;
    
    frame.size.width = cell.mainView.frame.size.width;
    
    // frame.origin.y = 10;
    
    cell.image_view.frame = frame;
    
    
    // NSString *listing = @"CourseListing";
    
    NSString *course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
    
    cell.educatorname_lbl.text = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
    
    NSString *name1 = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
    
    NSLog( @"%@",name1);
    
    NSLog(@"Course Tap Id %@", course_id);
    
    //    if ([course_id isEqualToString:@""] && [[[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"] isEqualToString:@""]) {
    //
    //        // course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"];
    //
    //        //listing = @"LessonListing";
    //
    //        cell.educatorname_lbl.text = [[[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"LessonListing"] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
    //
    //
    //
    //    }else if([course_id isEqualToString:@""] && [[[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"] isEqualToString:@""]) {
    //
    //        //   course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"];
    //
    //        cell.educatorname_lbl.text = [[[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"EventListing"] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
    //
    //        // listing = @"EventListing";
    //
    //    }
    //
    
    cell.listing_name.text = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"name"];
    
    
    NSString *date = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"created_at"];
    
    if ([date isEqualToString:@""]) {
        
        date = @"0000-00-00 00:00";
    }
    
    cell.post_date.text = [dateConversion convertDate:date];
    
    cell.description_lbl.text = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"description"];
    
    //[cell.description_lbl sizeToFit];
    
    //cell.description_lbl.text = desc;
    
    //[cell.description_lbl sizeToFit];
    
    frame = cell.description_lbl.frame;
    
    frame.size.height = [self heightCalculate:cell.description_lbl.text:cell.description_lbl];
    
    cell.description_lbl.frame = frame;
    
    frame = cell.main_view.frame;
    
    frame.size.height = cell.description_lbl.frame.origin.y+cell.description_lbl.frame.size.height+10;
    
    cell.main_view.frame = frame;
    
    frame = cell.action_view.frame;
    
    frame.origin.y = cell.main_view.frame.origin.y+cell.main_view.frame.size.height;
    
    cell.action_view.frame = frame;
    
    frame = cell.mainView.frame;
    
    frame.size.height = cell.action_view.frame.origin.y+cell.action_view.frame.size.height+10;
    
    cell.mainView.frame = frame;
    
    
    NSString *date1 = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"expiry_date"];
    
    if ([date1 isEqualToString:@""]) {
        
        date1 = @"0000-00-00 00:00";
    }
    
    cell.expiry_lbl.text = [dateConversion convertDate:date1];
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *expirydate = [dateFormat dateFromString:date1];
    
    NSLog(@"%@",expirydate);
    
    
    
    if ([expirydate compare:nowDate] != NSOrderedAscending) {
        
        cell.favPin_btn.hidden = NO;
        
    } else{
        
        cell.favPin_btn.hidden = YES;
    }
    
    cell.favPin_btn.hidden = YES;
    
    
    NSString *imageURL = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"picture"];
    
    if ([imageURL length] < 1) {
        
        cell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
        
    } else {
        
        cell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
        
        imageURL = [WhatsOnImgURL stringByAppendingString:imageURL];
        
        [cell.image_view sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Listing_Image"]];
    }
    
    [cell.editBtn addTarget:self action:@selector(tapEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.Message_bttn addTarget:self action:@selector(tapMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.enroll_btnn addTarget:self action:@selector(tapEnrollBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.shareBtn addTarget:self action:@selector(tapShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.favPin_btn addTarget:self action:@selector(tapfavToPin_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    cell.editBtn.tag = indexPath.row;
    
    cell.favPin_btn.tag = indexPath.row;
    
    cell.Message_bttn.tag = indexPath.row;
    
    cell.enroll_btnn.tag = indexPath.row;
    
    cell.shareBtn.tag = indexPath.row;
    
    if ([@"YES" isEqualToString:[FAVarray objectAtIndex:indexPath.row]]) {
        
        [cell.favPin_btn setImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
        
    } else {
        
        [cell.favPin_btn setImage:[UIImage imageNamed:@"favPin_gray"] forState:UIControlStateNormal];
    }
    
    NSString *status = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey:@"WhatsonPost"] valueForKey:@"status"];
    
    if ([status isEqualToString:@"0"]) {
        
        [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        
        [cell.postBtn setBackgroundImage:[UIImage imageNamed:@"post_color"] forState:UIControlStateNormal];
        
    }
    else{
        
        [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"Check_Mark"] forState:UIControlStateNormal];
        
        [cell.postBtn setBackgroundImage:[UIImage imageNamed:@"unpost_color"] forState:UIControlStateNormal];
    }
    
    return cell;
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
    
    listing = @"CourseListing";
    
    NSString *course_id ;
    
    NSString *list_type = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"listing_type"];
    
    if ([list_type isEqualToString:@"1"]) {
        
        course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
        
        listing = @"CourseListing";
        
    } else if([list_type isEqualToString:@"3"]){
        
        course_id = [[[whatsOnArray objectAtIndex:indexPath.row] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"];
        
        listing = @"LessonListing";
        
        
    } else if([list_type isEqualToString:@"2"]||[course_id isEqualToString:@""]){
        
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
        
        LessonView = [storyboard instantiateViewControllerWithIdentifier:@"lessionDetail"];
        
        [self.navigationController pushViewController:LessonView animated:YES];
        
    }else if ([listing isEqualToString:@"EventListing"]){
        
        UIStoryboard *storyboard = self.storyboard;
        
        EventView = [storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
        
        [self.navigationController pushViewController:EventView animated:YES];
        
    }
}

-(void)tapfavToPin_btn:(UIButton *)sender{
    
    [self.view addSubview:indicator];
    
    listing = @"CourseListing";
    
    NSString *course_id ;
    
    NSString *list_type = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"listing_type"];
    
    if ([list_type isEqualToString:@"1"]) {
        
        course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
        
        listing = @"CourseListing";
        
    } else if([list_type isEqualToString:@"3"]){
        
        course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"];
        
        listing = @"LessonListing";
        
        
    } else if([list_type isEqualToString:@"2"]||[course_id isEqualToString:@""]){
        
        course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"];
        
        listing = @"EventListing";
        
    }
    
    type_str = list_type;
    
    list_id = course_id;
    
    
    NSDictionary *paramURL;
    
    NSString *msg;
    
    
    if ([[FAVarray objectAtIndex:sender.tag] isEqualToString:@"YES"]) {
        
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":list_id, @"type":type_str, @"un_fav":@"1"};
        
        NSLog(@"%@",paramURL);
        
        msg = @"You have successfully unpinned this listing from your Favorites.";
        
    } else {
        
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":list_id, @"type":type_str};
        NSLog(@"%@",paramURL);
        
        msg = @"You have successfully pinned this listing to your Favorites.";
    }
    
    [pinTOFavConnection startConnectionWithString:@"add_favorite" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if([pinTOFavConnection responseCode] == 1) {
            
            NSLog(@"%@",receivedData);
            
            if([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                [sender setImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                
                [self fetchWhatsOnPosts];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }
    }];
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
        
        //        NSArray *to_recipients = [NSArray arrayWithObject:[[[whatsOnArray objectAtIndex:actionSheet.tag]valueForKey:@"Member"]valueForKey:@"email"]];
        //
        //        NSLog(@"%@",to_recipients);
        //
        //        [mail setToRecipients:to_recipients];
        
        [mail setSubject:@"Check out this post that I post on ECAhub"];
        
        [self presentViewController:mail animated:YES completion:nil];
        
        
    }
    else if (buttonIndex == 4){
        
        sendMsgView = [[SendMessageView alloc] init];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"MessageSharingView" owner:self options:nil] objectAtIndex:0];
        
        sendMsgView.frame = self.view.frame;
        
        sendMsgView.view_frame = self.view.frame;
        
        //        sendMsgView.subject.layer.borderWidth = 1.0f;
        //
        //        sendMsgView.subject.layer.borderColor = [UIColor clearColor].CGColor;
        
        //sendMsgView.subject.text = name;
        
        sendMsgView.message_textview.text = discription;
        
        [sendMsgView.toMsg_btn addTarget:self action:@selector(tapTo_btn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //        sendMsgView.to_textField.text = [[[whatsOnArray objectAtIndex:actionSheet.tag]valueForKey:@"Member"]valueForKey:@"email"];
        
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

-(void)tapMessageBtn:(UIButton *)sender {
    
    sendMsgView = [[SendMessageView alloc] init];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPad" owner:self options:nil] objectAtIndex:0];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPhone" owner:self options:nil] objectAtIndex:0];
    }
    
    sendMsgView.to_textField.text = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"email"];
    
    sendMsgView.frame = self.view.frame;
    
    sendMsgView.view_frame = self.view.frame;
    
    sendMsgView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+80);
    
    [self.view addSubview:sendMsgView];
}

-(void)tapEnrollBtn:(UIButton *)sender{
    
    listing = @"CourseListing";
    
    NSString *course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"course_id"];
    
    NSLog(@"Course Tap Id%@", course_id);
    
    if ([course_id isEqualToString:@""] && [[[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"] isEqualToString:@""]) {
        
        course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"];
        
        listing = @"LessonListing";
        
    }else if([course_id isEqualToString:@""] && [[[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"lesson_id"] isEqualToString:@""]) {
        
        course_id = [[[whatsOnArray objectAtIndex:sender.tag] valueForKey: @"WhatsonPost"] valueForKey:@"event_id"];
        
        listing = @"EventListing";
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        UIStoryboard *storyboard = self.storyboard;
        
        courseView = [storyboard instantiateViewControllerWithIdentifier:@"courseDetail"];
        
        [self.navigationController pushViewController:courseView animated:YES];
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        UIStoryboard *storyboard = self.storyboard;
        
        LessonView = [storyboard instantiateViewControllerWithIdentifier:@"lessionDetail"];
        
        [self.navigationController pushViewController:LessonView animated:YES];
        
    }else if ([listing isEqualToString:@"EventListing"]){
        
        UIStoryboard *storyboard = self.storyboard;
        
        EventView = [storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
        
        [self.navigationController pushViewController:EventView animated:YES];
        
    }
    
}
-(void)tapEditBtn:(UIButton *)sender {
    
    NSDictionary *dict = [[whatsOnArray objectAtIndex:sender.tag] valueForKey:@"WhatsonPost"];
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"whatsOnPost"];
    
    [self performSegueWithIdentifier:@"editWhatsonSegue" sender:self];
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString1 indexPath:(NSIndexPath *)indexPath {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString1]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            cell = (whatsOnTableViewCell *)[tble_view cellForRowAtIndexPath:indexPath];
            
            cell.image_view.image = image;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)tap_filter_btn:(id)sender {
    
    if(type == 0){
        
        type = 1;
        
    } else {
        
        type = 0;
    }
    
    [self fetchWhatsOnPosts];
    
}
@end
