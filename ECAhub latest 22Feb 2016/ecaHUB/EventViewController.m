//
//  EventViewController.m
//  ecaHUB
//
//  Created by promatics on 4/7/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EventViewController.h"
#import "SessionTableViewCell.h"
#import "ReviewsTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SendMessageView.h"
#import "AllEventSessionViewController.h"
#import "EventSessionViewController.h"
#import "EventT_CViewController.h"
#import "EventEducatorViewController.h"

@interface EventViewController () {
    
    ReviewsTableViewCell *reviewCell;
    
    SessionTableViewCell *sessionCell;
    
    WebServiceConnection *getCourseConn,*praiseConn,*reportAbuseConn;
    
    WebServiceConnection *pinTOFavConnection;
    
    WebServiceConnection *postConnection;
    
    WebServiceConnection *memberDetailConn;
    
    Indicator *indicator;
    
    AllEventSessionViewController *allSessionVC;
    
    NSArray *eventDetailArray, *reviewArray;
    
    NSArray *sessionArray;
    
    DateConversion *dateConversion;
    
    NSMutableArray *img_array;
    
    NSMutableArray *course_image;
    id img;
    
    CGFloat review_cellHieght;
    
    CGFloat session_cellHieght;
    
    UIImageView *imageView;
    
    SendMessageView *sendMsgView;
    
    NSString *fav, *member_id;
    
    NSMutableArray *FAVarray;
}
@end

@implementation EventViewController

@synthesize scrollView, img_scrollView, listing_name,educator_name,course_tech,courses,main_lang,total_praises,total_reviews,total_purchased,lession_dscriptionTxtView,lession_category,lession_duration,location,lession_all_lang,pin_favBtn,report_abuseBtn,session_table,review_view,review_table, logo_img, postBtn,share_btn,pinToFav_btn,message_btn,reportAbuse_btn,term_view, requestToEnrol_btn,language_lbl,type_lbl,subView,aboutEducatorBtn,detailView,locationLbl,categoryLbl,teachingMethodLbl,referenceIDLbl,eventDurationLbl,eventDetailsLbl,flagimg_view,listing_view,eventDiscrp_lbl;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.rightBarButtonItems = @[share_btn, reportAbuse_btn, message_btn];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        review_cellHieght = 190.0f;
        
        session_cellHieght = 95.0f;
        
        scrollView.frame = self.view.frame;
        
          CGRect frame = scrollView.frame;
        
       //frame.origin.y = 65;
        
         frame.size.height = self.view.frame.size.height;
        
         scrollView.frame = frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 3500);
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        review_cellHieght = 130.0f;
        
        session_cellHieght = 65.0f;
        
//        scrollView.frame = self.view.frame;
//        
//          CGRect frame = scrollView.frame;
//        
//       // frame.origin.y = 67;
//        
//         frame.size.height = self.view.frame.size.height;
//        
//         scrollView.frame = frame;
        
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 2500)];
    }
    
    scrollView.hidden = YES;
    
    img_scrollView.tag = 1;
    
    img_array = [[NSMutableArray alloc] init];
    
    FAVarray = [[NSMutableArray alloc] init];
    
    course_image = [[NSMutableArray alloc] init];
    
    fav = @"0";
    //scrollView.userInteractionEnabled = NO;
    
    img_scrollView.autoresizingMask=UIViewAutoresizingNone;
    
    getCourseConn = [WebServiceConnection connectionManager];
    
    praiseConn = [WebServiceConnection connectionManager];
    
    postConnection = [WebServiceConnection connectionManager];
    
    pinTOFavConnection = [WebServiceConnection connectionManager];
    
    reportAbuseConn = [WebServiceConnection connectionManager];
    
    memberDetailConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    [aboutEducatorBtn addTarget:self action:@selector(tap_aboutEducator:) forControlEvents:UIControlEventTouchUpInside];
    
    [self fetchCourseDetail];
    
    [self praiseWebData];
    
    [self setDesign];
}

//-(void)viewDidAppear:(BOOL)animated {
//
//    UIStoryboard *storyboard;
//
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//
//        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
//
//        review_cellHieght = 190.0f;
//
//        session_cellHieght = 95.0f;
//
//        scrollView.frame = self.view.frame;
//
//        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 3500);
//
//    } else {
//
//        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
//
//        review_cellHieght = 130.0f;
//
//        session_cellHieght = 65.0f;
//
//        scrollView.frame = self.view.frame;
//
//        //  CGRect frame = scrollView.frame;
//
//        //frame.origin.y = 67;
//
//        // frame.size.height = self.view.frame.size.height-67;
//
//        // scrollView.frame = frame;
//
//        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 2500)];
//    }
//
//    [self fetchCourseDetail];
//
//    [self setDesign];
//
//    [self praiseWebData];
//}

-(void)viewWillAppear:(BOOL)animated{
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    [super viewWillDisappear:animated];
    
}

-(void)setDesign{
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        self.aboutEducatorBtn.layer.cornerRadius = 7;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        self.aboutEducatorBtn.layer.cornerRadius = 5;
    }
}

-(void) fetchCourseDetail {
    
    [self.view addSubview:indicator];
    
    NSLog(@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"], [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]);
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    NSDictionary *paramURL = @{@"event_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"]};
    
    [getCourseConn startConnectionWithString:[NSString stringWithFormat:@"event_view"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([getCourseConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            eventDetailArray = [receivedData copy];
            
            [[NSUserDefaults standardUserDefaults] setObject:eventDetailArray forKey:@"eventDetail"];
            
            
            [FAVarray removeAllObjects];
            
            NSArray *favoriteArray = [[eventDetailArray valueForKey:@"event_info"]  valueForKey:@"Favorite"];
            
            for (int i = 0; i< favoriteArray.count; i++) {
                
                if ([member_id isEqualToString:[[favoriteArray objectAtIndex:i] valueForKey:@"member_id"]]) {
                    
                     [pinToFav_btn setImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                    
                    fav = @"1";
                }
            }
            
            scrollView.hidden = NO;
            
            
            [self setLessionDetails];
        }
    }];
}

-(CGFloat)heightCalculate:(NSString *)calculateText{
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(lession_dscriptionTxtView.frame.size.width - (1.0f * 2), FLT_MAX);
    
    UIStoryboard *storyboard;
    
    UIFont *font;
    
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
    
    return (height_lbl + 10);
}


-(CGFloat)heightCalculate2:(NSString *)calculateText :(UILabel *)lbl {
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(lbl.frame.size.width - (1.0f * 2), FLT_MAX);
    
    UIStoryboard *storyboard;
    
    UIFont *font;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        if ([lbl isEqual:listing_name] || [lbl isEqual:educator_name]) {
            
            font = [UIFont systemFontOfSize:20];
            
        }
        
        else{
            
            font = [UIFont systemFontOfSize:19];
            
        }
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        if ([lbl isEqual:listing_name] || [lbl isEqual:educator_name]) {
            
            font = [UIFont systemFontOfSize:18];
            
        }
        
        else{
            
            font = [UIFont systemFontOfSize:17];
            
        }
    }
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font} context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    [calculateText_lbl setFrame:CGRectMake(10, 74, 300 ,size.height+5)];
    
    [calculateText_lbl sizeToFit];
    
    CGFloat height_lbl = size.height;
    
    return (height_lbl);
}


-(void)praiseWebData{
    
    NSDictionary *dict = @{@"listing_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"],@"listing_type":@"2"};
    
    [praiseConn startConnectionWithString:@"get_prize_data" HttpMethodType:Post_Type HttpBodyType:dict Output:^(NSDictionary * receiveddata){
        
        if ([praiseConn responseCode] == 1) {
            
            NSLog(@"%@",receiveddata);
            
            total_praises.text = [NSString stringWithFormat:@"%@\n Praise",[receiveddata valueForKey:@"count"]];
            
            //listing_id,listing_type (1=>course,2 =>event, 3=> Lesson), member_id. (If you want all prize on a particular then no need to send the member id)
            
            //@{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"], @"type":@"1"};
        }
    }];
}

-(void)setLessionDetails {
    
    NSString *couser_memId = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"member_id"];
    
    if (![couser_memId isEqualToString:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]]) {
        
        // self.navigationItem.rightBarButtonItem = nil;
        
        postBtn.hidden = YES;
        
    } else {
        
        self.navigationItem.rightBarButtonItems = @[share_btn];
        
        requestToEnrol_btn.hidden = YES;
        
        CGRect frame = scrollView.frame;
        frame.size.height = frame.size.height + requestToEnrol_btn.frame.size.height;
        scrollView.frame = frame;
    }
    
    total_purchased.text = [NSString stringWithFormat:@"%@\n Purchased",[eventDetailArray valueForKey:@"purchase"]];
    
    NSString *imge_url = [[[[eventDetailArray valueForKey:@"event_info"]valueForKey:@"BusinessProfile"
                            ]valueForKey:@"author_country"]valueForKey:@"flag"];
    if ([imge_url length] > 1) {
        
        imge_url = [FlagImageURL stringByAppendingString:imge_url];
        
        [self downloadImageWithString1:imge_url];
        
    } else {
        
        flagimg_view.image = [UIImage imageNamed:@"Listing_Image"];
    }
    
    
    pin_favBtn.layer.cornerRadius = 5.0f;
    
    report_abuseBtn.layer.cornerRadius = 5.0f;
    
    postBtn.layer.cornerRadius = 5.0f;
    
    self.title = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_name"];
    
    listing_name.text = [[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    educator_name.text = [[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    lession_dscriptionTxtView.text = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_description"];
    
    // lession_category.text = [eventDetailArray valueForKey:@"result_string"];
    
    NSString *categoryName =[eventDetailArray valueForKey:@"result_string"];
    
    NSString *subcategoryName =[eventDetailArray valueForKey:@"subcategory_name"];
    
    if ([subcategoryName isEqualToString:@""]) {
        
        subcategoryName = @"";
        
    }
    
    else{
        
        subcategoryName = [@", " stringByAppendingString:subcategoryName];
    }
    
    lession_category.text = [[categoryName stringByAppendingString:subcategoryName]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    NSString *type = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"reference_id"];
    
    // '1'=>'Online','2'=>'Offline'
    
    //    if ([type isEqualToString:@"1"]) {
    //
    //        type = @"Online";
    //
    //    } else {
    //
    //        type = @"Offline";
    //    }
    //
    type_lbl.text = type;
    
    //    type = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"type"];
    //
    //    // '1'=>'Online','2'=>'Offline','3'=>'Open Day,'4'=>'Exhibition,'5'=>'Performance','6'=>'Workshop Day,'7'=>'Promotion,'8'=>'Seminar'
    //
    //    if ([type isEqualToString:@"1"]) {
    //
    //        type = @"Online";
    //
    //    } else if ([type isEqualToString:@"2"])  {
    //
    //        type = @"Offline";
    //
    //    } else if ([type isEqualToString:@"3"])  {
    //
    //        type = @"Open Day";
    //
    //    }else if ([type isEqualToString:@"4"])  {
    //
    //        type = @"Exhibition";
    //
    //    }else if ([type isEqualToString:@"5"])  {
    //
    //        type = @"Performance";
    //
    //    }else if ([type isEqualToString:@"6"])  {
    //
    //        type = @"Workshop Day";
    //
    //    }else if ([type isEqualToString:@"7"])  {
    //
    //        type = @"Promotion";
    //
    //    } else {
    //        type = @"Seminar";
    //    }
    // type_lbl.text = type;
    
    NSString *hrs = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_duration_hours"];
    
    if (![hrs isEqualToString:@""]) {
        
        hrs = [hrs stringByAppendingString:@" Hours "];
    }
    
    NSString *mints = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_duration_minutes"];
    
    if (![mints isEqualToString:@""]) {
        
        mints = [mints stringByAppendingString:@" Minutes"];
        
    }
    
    lession_duration.text = [hrs stringByAppendingString:mints];
    
    NSString *methodType = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"type"];
    
    if ([methodType  isEqual:@"1"]) {
        
        language_lbl.text = @"Online";
    }
    else if ([methodType isEqual:@"2"]){
        
        language_lbl.text = @"Offline";
    }
    
    else if ([methodType isEqual:@"3"]){
        
        language_lbl.text = @"Open Day";
    }
    
    else if ([methodType isEqual:@"4"]){
        
        language_lbl.text = @"Exhibition";
    }
    
    else if ([methodType isEqual:@"5"]){
        
        language_lbl.text = @"Performance";
    }
    
    else if ([methodType isEqual:@"6"]){
        
        language_lbl.text = @"Workshop Day";
    }
    
    else if ([methodType isEqual:@"7"]){
        
        language_lbl.text = @"Promotion";
    }
    
    else if ([methodType isEqual:@"8"]){
        
        language_lbl.text = @"Seminar";
    }
    
    else if ([methodType isEqual:@"9"]){
        
        language_lbl.text = @"Competition";
    }
    
    else{
        
        language_lbl.text =@"";
    }
    
    
    location.text = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"BusinessProfile"] valueForKey:@"author_venu_district"];
    
    if ([[eventDetailArray valueForKey:@"event_sessions"] count] > 0) {
        
        NSString *lang = [[[[eventDetailArray valueForKey:@"event_sessions"] objectAtIndex:0] valueForKey:@"EventSession"] valueForKey:@"main_language"];
        lang = [lang stringByAppendingString:@" (Main), "];
        
        NSString *sup_lang = [[[[eventDetailArray valueForKey:@"event_sessions"] objectAtIndex:0]  valueForKey:@"EventSession"] valueForKey:@"supported_language"];
        
        lang = [lang stringByAppendingString:sup_lang];
        
        lang = [lang stringByAppendingString:@" (Support)"];
        
        //language_lbl.text = lang;
        
        sessionArray = [[eventDetailArray valueForKey:@"event_sessions"] valueForKey:@"EventSession"];
        
        NSLog(@"%@", sessionArray);
    }
    
    if ([[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"Review"] count] > 0) {
        
        reviewArray = [[eventDetailArray valueForKey:@"event_info"] valueForKey:@"Review"];
        
        NSLog(@"%@", reviewArray);
        
    }
    
    
    NSString *logo = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"logo"];
    
    if ([logo length] > 1) {
        
        NSString *url = EventLogoURL;
        
        url = [url stringByAppendingString:logo];
        
        [self downloadImageWithString:url];
        
    } else {
        
        logo_img.image = [UIImage imageNamed:@"Listing_Image"];
    }
    
    //sessionArray = [[eventDetailArray valueForKey:@"event_info"] valueForKey:@"Sessions"];
    
    // NSLog(@"%@", sessionArray);
    
    NSString *img_url = EventImageURL;
    
    NSString *img_name = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture0"];
    
    if ([img_name length] > 1) {
        
        [img_array addObject:[img_url stringByAppendingString:[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture0"]]];
    }
    
    img_name = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture1"];
    
    if ([img_name length] > 1) {
        
        [img_array addObject:[img_url stringByAppendingString:[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture1"]] ];
    }
    
    img_name = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture2"];
    
    if ([img_name length] > 1) {
        
        [img_array addObject:[img_url stringByAppendingString:[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture2"]] ];
    }
    
    img_name = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture3"];
    
    if ([img_name length] > 1) {
        
        [img_array addObject:[img_url stringByAppendingString:[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture3"]] ];
    }
    
    img_name = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture4"];
    
    if ([img_name length] > 1) {
        
        [img_array addObject:[img_url stringByAppendingString:[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture4"]] ];
    }
    
    NSString *status = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_status"];
    
    if ([status isEqualToString:@"1"]) {
        
        [postBtn setTitle:@"Unpost" forState:UIControlStateNormal];
        
    } else if ([status isEqualToString:@"0"]) {
        
        [postBtn setTitle:@"Post" forState:UIControlStateNormal];
    }
    
    long session_no = [sessionArray count];
    
    if (session_no == 0) {
        
        session_no = 1;
        
        UILabel *labl = [[UILabel alloc] initWithFrame:CGRectMake(session_table.frame.origin.x, session_table.frame.origin.y, session_table.frame.size.width, session_cellHieght)];
        
        labl.text = @"No Session Added";
        
        labl.textAlignment = NSTextAlignmentCenter;
        
        [labl setFont:[UIFont fontWithName:@"Helvetica Neue" size:19.0f]];
        
        [labl setTextColor:[UIColor darkGrayColor]];
        
        [labl setBackgroundColor:[UIColor whiteColor]];
        
        [subView addSubview:labl];
        
        session_table.hidden = YES;
        
        requestToEnrol_btn.hidden = YES;
        
        CGRect frame = scrollView.frame;
        frame.size.height = frame.size.height + requestToEnrol_btn.frame.size.height+50;
        scrollView.frame = frame;
    }
    
    long reviews_no = [reviewArray count];
    
    total_reviews.text = [NSString stringWithFormat:@"%lu\n Reviews",reviews_no];
    
    if (reviews_no == 0) {
        
        reviews_no = 1;
        
        UILabel *labl = [[UILabel alloc] initWithFrame:CGRectMake(0, review_table.frame.origin.y, review_table.frame.size.width, session_cellHieght)];
        
        labl.text = @"No Review Exits";
        
        labl.textAlignment = NSTextAlignmentCenter;
        
        [labl setFont:[UIFont fontWithName:@"Helvetica Neue" size:19.0f]];
        
        [labl setTextColor:[UIColor darkGrayColor]];
        
        [labl setBackgroundColor:[UIColor whiteColor]];
        
        //[review_view addSubview:labl];
        
        review_table.hidden = YES;
        
        CGRect frame = review_view.frame;
        
        frame.size.height = review_table.frame.origin.y+10;
        
        review_view.frame = frame;
        
        //review_view.backgroundColor = [UIColor redColor];
        
    }
    
    CGRect frame1 = listing_name.frame;
    
    frame1.size.height = [self heightCalculate2:listing_name.text :listing_name];
    
    listing_name.frame = frame1;
    
    frame1 = educator_name.frame;
    
    frame1.origin.y = listing_name.frame.origin.y + listing_name.frame.size.height + 5;
    
    frame1.size.height = [self heightCalculate2:educator_name.text :educator_name];
    
    educator_name.frame = frame1;
    
    frame1 = listing_view.frame;
    
    if ((educator_name.frame.origin.y + educator_name.frame.size.height +5) > (logo_img.frame.origin.y + logo_img.frame.size.height +10)) {
        
        frame1.size.height = educator_name.frame.origin.y + educator_name.frame.size.height +5;
        
    }
    
    listing_view.frame = frame1;
    
    if ((educator_name.frame.origin.y + educator_name.frame.size.height +5) > (logo_img.frame.origin.y + logo_img.frame.size.height +10)) {
        
        frame1 = logo_img.frame;
        
        frame1.origin.y = (listing_view.frame.size.height - logo_img.frame.size.height)/2;
        
        logo_img.frame = frame1;
        
    }
    
    frame1 = eventDiscrp_lbl.frame;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        frame1.origin.y = listing_view.frame.origin.y + listing_view.frame.size.height + 10;
        
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        frame1.origin.y = listing_view.frame.origin.y + listing_view.frame.size.height + 5;
    }
    
    eventDiscrp_lbl.frame = frame1;
    
    frame1 = lession_dscriptionTxtView.frame;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        frame1.origin.y = eventDiscrp_lbl.frame.origin.y + eventDiscrp_lbl.frame.size.height +10;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        frame1.origin.y = eventDiscrp_lbl.frame.origin.y + eventDiscrp_lbl.frame.size.height +5;
        
    }
    
    CGFloat txtheight = [self heightCalculate:lession_dscriptionTxtView.text]+10;
    
    frame1.size.height = txtheight;
    
    //frame1.origin.y = courseDescriptionLbl.frame.origin.y + courseDescriptionLbl.frame.size.height +5;
    
    lession_dscriptionTxtView.frame = frame1;
    
    frame1 = eventDetailsLbl.frame;
    
    frame1.origin.y = lession_dscriptionTxtView.frame.origin.y + lession_dscriptionTxtView.frame.size.height +10;
    
    eventDetailsLbl.frame = frame1;
    
    frame1 = detailView.frame;
    
    frame1.origin.y = eventDetailsLbl.frame.origin.y + eventDetailsLbl.frame.size.height +10;
    
    CGRect Frame3 = lession_category.frame;
    
    Frame3.size.height = [self heightCalculate2:lession_category.text :lession_category];
    
    lession_category.frame = Frame3;
    
    Frame3 = lession_duration.frame;
    
    Frame3.origin.y = lession_category.frame.origin.y+lession_category.frame.size.height+5;
    
    Frame3.size.height = [self heightCalculate2:lession_duration.text :lession_duration];
    
    lession_duration.frame = Frame3;
    
    Frame3 = eventDurationLbl.frame;
    
    Frame3.origin.y = lession_category.frame.origin.y+lession_category.frame.size.height+5;
    
    eventDurationLbl.frame = Frame3;
    
    Frame3 = teachingMethodLbl.frame;
    
    Frame3.origin.y = lession_duration.frame.origin.y+lession_duration.frame.size.height+5;
    
    teachingMethodLbl.frame = Frame3;
    
    Frame3 = language_lbl.frame;
    
    Frame3.origin.y = lession_duration.frame.origin.y+lession_duration.frame.size.height+5;
    
    Frame3.size.height = [ self heightCalculate2:language_lbl.text :language_lbl];
    
    language_lbl.frame = Frame3;
    
    Frame3 = referenceIDLbl.frame;
    
    Frame3.origin.y = language_lbl.frame.origin.y + language_lbl.frame.size.height+5;
    
    referenceIDLbl.frame = Frame3;
    
    Frame3 = type_lbl.frame;
    
    Frame3.origin.y = language_lbl.frame.origin.y + language_lbl.frame.size.height+5;
    
    Frame3.size.height = [self heightCalculate2:type_lbl.text :type_lbl];
    
    type_lbl.frame = Frame3;
    
    Frame3 = locationLbl.frame;
    
    Frame3.origin.y = type_lbl.frame.origin.y + type_lbl.frame.size.height + 5;
    
    locationLbl.frame = Frame3;
    
    Frame3 = location.frame;
    
    Frame3.origin.y = type_lbl.frame.origin.y + type_lbl.frame.size.height + 5;
    
    Frame3.size.height = [self heightCalculate2:location.text :location];
    
    location.frame = Frame3;
    
    [categoryLbl sizeToFit];
    
    [lession_category sizeToFit];
    
    [eventDurationLbl sizeToFit];
    
    [lession_duration sizeToFit];
    
    [teachingMethodLbl sizeToFit];
    
    [language_lbl sizeToFit];
    
    [referenceIDLbl sizeToFit];
    
    [type_lbl sizeToFit];
    
    [locationLbl sizeToFit];
    
    [location sizeToFit];
    
    frame1.size.height = location.frame.origin.y + location.frame.size.height +5;
    
    detailView.frame = frame1;
    
    //    CGRect frame2 = courseDetailLbl.frame;
    //
    //    frame2.origin.y = ((frame1.origin.y)+(frame1.size.height)+5);
    //
    //    courseDetailLbl.frame = frame2;
    //
    //    frame2 = detailview.frame;
    //
    //    frame2.origin.y = courseDetailLbl.frame.origin.y+ courseDetailLbl.frame.size.height+5;
    //    detailview.frame = frame2;
    //
    //    frame2 = sessionOptionLbl.frame;
    //
    //    frame2.origin.y = detailview.frame.origin.y+detailview.frame.size.height+5;
    //
    //    sessionOptionLbl.frame = frame2;
    //
    //    frame2 = session_table.frame;
    //
    //    frame2.origin.y = sessionOptionLbl.frame.origin.y+sessionOptionLbl.frame.size.height+5;
    //
    //    session_table.frame = frame2;
    //
    //    frame2 = termsView.frame;
    //
    //    frame2.origin.y = session_table.frame.origin.y+session_table.frame.size.height+5;
    //
    //    termsView.frame = frame2;
    //
    //    frame2 = reviews_view.frame;
    //
    //    frame2.origin.y = termsView.frame.origin.y+termsView.frame.size.height+5;
    //
    //    reviews_view.frame = frame2;
    //
    //   frame2 = frame1;
    //
    //    if (review_table.hidden != YES) {
    //
    //        CGRect frame = about_EducatorBtn.frame;
    //
    //        frame.origin.y = frame2.origin.y+frame2.size.height+5;
    //
    //        about_EducatorBtn.frame = frame;
    //
    //    }
    
    
    CGRect frame = session_table.frame;
    
    if (session_no <1) {
        
        frame.size.height = session_cellHieght;
    }
    else{
    
    frame.size.height = session_no * session_cellHieght;
        
    }
    
    session_table.frame = frame;
    
    frame = term_view.frame;
    
    frame.origin.y = session_table.frame.size.height + session_table.frame.origin.y + 10;
    
    term_view.frame = frame;
    
    frame = review_view.frame;
    
    frame.origin.y = term_view.frame.size.height + term_view.frame.origin.y + 10;
    
    review_view.frame = frame;
    
    frame = aboutEducatorBtn.frame;
    
    frame.origin.y = review_view.frame.origin.y+review_view.frame.size.height+15;
    
    aboutEducatorBtn.frame = frame;
    
    NSLog(@"%f",(frame.origin.y + review_table.frame.size.height + 20));
    
    frame1 = subView.frame;
    
    frame1.origin.y = detailView.frame.origin.y+detailView.frame.size.height+5;
    
    frame1.size.height = aboutEducatorBtn.frame.origin.y + aboutEducatorBtn.frame.size.height +20;
    
    subView.frame = frame1;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        if (sessionArray.count==0) {
            
            if (requestToEnrol_btn.hidden == YES){
                
                [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, (subView.frame.origin.y + subView.frame.size.height+130))];
            }
            else{
                
                [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, (subView.frame.origin.y + subView.frame.size.height+80))];
                
            }
            
            
        }
        
        else{
        
        if (requestToEnrol_btn.hidden == YES){
            
            [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, (subView.frame.origin.y + subView.frame.size.height+80))];
        }
        else{
            
            [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, (subView.frame.origin.y + subView.frame.size.height+30))];
            
        }
        }
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        if (sessionArray.count==0) {
            
            if (requestToEnrol_btn.hidden == YES){
                
                [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, (subView.frame.origin.y + subView.frame.size.height+100))];
            }
            else{
                
                [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, (subView.frame.origin.y + subView.frame.size.height+50))];
                
            }
            
            
        }
        else{
        
        if (requestToEnrol_btn.hidden == YES){
            
            [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, (subView.frame.origin.y + subView.frame.size.height+50))];
        }
        else{
            
            [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, (subView.frame.origin.y + subView.frame.size.height))];
            
        }
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:eventDetailArray forKey:@"lessionDetails"];
    
    [self downloadImageWithString];
    
    [session_table reloadData];
    
    [review_table reloadData];
    //}
}
//
//#pragma  mark- Load Image To Cell
//
//-(void)downloadImageWithString {
//
//    for(int i = 0; i < img_array.count; i++) {
//
//        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:
//                                                  [NSURL URLWithString:[img_array objectAtIndex:i]]] queue:[NSOperationQueue mainQueue]
//                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//
//                                   if([data length] > 0) {
//
//                                       UIImage *images = [UIImage imageWithData:data];
//
//                                       NSLog(@"%@", images);
//
//                                       img = images;
//
//                                       [self setImage];
//
//                                   }
//                               }];
//    }
//}
//
//-(void)setImage {
//
//    [course_image addObject:img];
//
//    NSLog(@"%lu",(unsigned long)img_array.count);
//
//    self.img_scrollView.contentSize = CGSizeMake(self.img_scrollView.frame.size.width * img_array.count, self.img_scrollView.frame.size.height);
//
//    NSLog(@"%lu",(unsigned long)img_array.count);
//
//    NSLog(@"%@",img_array);
//
//    for (int i = 0; i < course_image.count; i++) {
//
//        CGRect frame;
//
//        frame.origin.x = self.img_scrollView.frame.size.width * i;
//
//        frame.origin.y = 0;
//
//        frame.size = self.img_scrollView.frame.size;
//
//        UIImageView *image_View = [[UIImageView alloc] initWithFrame:frame];
//
//        image_View.image = [course_image objectAtIndex:i];
//
//        [image_View  setContentMode:UIViewContentModeScaleAspectFill];
//
//        [img_scrollView addSubview:image_View];
//
//    }
//}

-(void)downloadImageWithString1:(NSString *)urlString {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            flagimg_view.image = image;
        }
    }];
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString {
    
    for(int i = 0; i < img_array.count; i++) {
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:
                                                  [NSURL URLWithString:[img_array objectAtIndex:i]]] queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   if([data length] > 0) {
                                       
                                       UIImage *images = [UIImage imageWithData:data];
                                       
                                       NSLog(@"%@", images);
                                       
                                       img = images;
                                       
                                       [course_image addObject:img];
                                       
                                       if (img_array.count == course_image.count) {
                                           
                                           [self setImage];
                                           
                                       }
                                       
                                   }
                               }];
    }
    
    // [self setImage];
    
}

-(void)setImage {
    
    //[course_image addObject:img];
    
    NSLog(@"%lu",(unsigned long)img_array.count);
    
    self.img_scrollView.contentSize = CGSizeMake(self.img_scrollView.frame.size.width * img_array.count, self.img_scrollView.frame.size.height);
    
    NSLog(@"%lu",(unsigned long)img_array.count);
    
    NSLog(@"%@",img_array);
    
    img_scrollView.tag = 1;
    
    img_scrollView.userInteractionEnabled = YES;
    
    img_scrollView.autoresizingMask=UIViewAutoresizingNone;
    
    //  [self setupScrollView:img_scrollView];
    
    //  UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, img_scrollView.frame.origin.y+self.img_scrollView.frame.size.height-30, self.img_scrollView.frame.size.width, 30)];
    
    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 30,self.scrollView.frame.size.width,50)];
    
    //  UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:img_scrollView.frame];
    
    [pgCtr setTag:12];
    
    [pgCtr setTintColor:[UIColor blackColor]];
    
    pgCtr.numberOfPages=img_array.count;
    
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    
    [self.scrollView addSubview:pgCtr];
    
    for (int i = 0; i < course_image.count; i++) {
        
        CGRect frame;
        
        frame.origin.x = self.img_scrollView.frame.size.width * i;
        
        frame.origin.y = 0;
        
        frame.size = self.img_scrollView.frame.size;
        
        imageView = [[UIImageView alloc] initWithFrame:frame];
        
        imageView.image = [course_image objectAtIndex:i];
        
        [imageView  setContentMode:UIViewContentModeScaleAspectFill];
        
        //imageView.tag=i+1;
        
        [img_scrollView addSubview:imageView];
        
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
    }
    
    [scrollView addSubview:pinToFav_btn];
}

- (void)setupScrollView:(UIScrollView*)scrMain {
    
    // we have 10 images here.
    // we will add all images into a scrollView & set the appropriate size.
    
    for (int i=0; i<course_image.count; i++) {
        
        // create image
        
        //  UIStoryboard *storyboard;
        
        //   image = [course_image objectAtIndex:i];
        
        
        // create imageView
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:img_scrollView.frame];
        
        // set scale to fill
        
        imgV.contentMode=UIViewContentModeScaleAspectFill;
        
        // set image
        
        [imgV setImage:[course_image objectAtIndex:i]];
        
        // apply tag to access in future
        
        imgV.tag=i+1;
        
        // add to scrollView
        
        [img_scrollView addSubview:imgV];
    }
    // set the content size to 10 image width
    [img_scrollView setContentSize:CGSizeMake(scrMain.frame.size.width*5, img_scrollView.frame.size.height)];
    // enable timer after each 2 seconds for scrolling.
    
}

- (void)scrollingTimer {
    
    // access the scroll view with the tag
    UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
    
    // same way, access pagecontroll access
    
    UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:12];
    
    [pgCtr setTintColor:[UIColor blackColor]];
    
    // get the current offset ( which page is being displayed )
    
    CGFloat contentOffset = scrMain.contentOffset.x;
    
    // calculate next page to display
    
    int nextPage = (int)(contentOffset/scrMain.frame.size.width) + 1 ;
    
    // if page is not 10, display it
    
    if( nextPage!=course_image.count )  {
        
        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        
        pgCtr.currentPage=nextPage;
        
        // else start sliding form 1 :)
        
    }
    else {
        
        [scrMain scrollRectToVisible:CGRectMake(0, 0, img_scrollView.frame.size.width, scrMain.frame.size.height) animated:YES];
        
        pgCtr.currentPage=0;
    }
}


#pragma mark - scroll View Delegates

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    // Update the page when more than 50% of the previous/next page is visible
    
    CGFloat pageWidth = self.img_scrollView.frame.size.width;
    
    int page = floor((self.img_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    NSLog(@"%d", page);
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            logo_img.image = image;
        }
    }];
}

#pragma mark - UITableView Delegates & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == review_table) {
        
        return [reviewArray count];
        
    } else {
        
        return [sessionArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == review_table) {
        
        reviewCell = [tableView dequeueReusableCellWithIdentifier:@"course_reviewCell" forIndexPath:indexPath];
        
        reviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (reviewCell == nil) {
            
            reviewCell = [[ReviewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"course_reviewCell"];
        }
        
        NSDictionary *paramURL = @{@"member_id" : [[reviewArray objectAtIndex:indexPath.row] valueForKey:@"member_id"]};
        
        [memberDetailConn startConnectionWithString:[NSString stringWithFormat:@"user_view_profile"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            if ([memberDetailConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                NSString *lastName = [[receivedData valueForKey:@"Member"] valueForKey:@"last_name"];
                
                NSString *Fullname = [lastName substringToIndex:1];
                
                Fullname = [Fullname stringByAppendingString:@"."];
                
                Fullname = [@" " stringByAppendingString:Fullname];
                
                Fullname = [[[receivedData valueForKey:@"Member"] valueForKey:@"first_name"] stringByAppendingString:Fullname];
                
                reviewCell.user_name.text = Fullname;
                
                reviewCell.user_img.layer.cornerRadius = reviewCell.user_img.frame.size.width/2;
                
                reviewCell.user_img.layer.masksToBounds = YES;
                
                NSString *profileImage = [[receivedData valueForKey:@"Member"] valueForKey:@"picture"];
                
                profileImage = [profileImage stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
                
                if ([profileImage length] > 1) {
                    
                    profileImage = [profilePicURL stringByAppendingString:profileImage];
                    
                    [self downloadImageWithString:profileImage indexPath:indexPath];
                    
                } else {
                    
                    reviewCell.user_img.image = [UIImage imageNamed:@"user_img"];
                }
            }
        }];
        
        //reviewCell.user_name.text = [[reviewArray objectAtIndex:indexPath.row] valueForKey:@""];
        
        reviewCell.user_review.text = [[reviewArray objectAtIndex:indexPath.row] valueForKey:@"content"];
        
        reviewCell.rate_no = 3.0f;
        
        [reviewCell setRating];
        
        return reviewCell;
        
    } else {
        
        sessionCell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell" forIndexPath:indexPath];
        
        sessionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (sessionCell == nil) {
            
            sessionCell = [[SessionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sessionCell"];
        }
        
        sessionCell.session_name.text = [[sessionArray objectAtIndex:indexPath.row] valueForKey:@"session_name"];
        
        NSString *start_date = [[sessionArray objectAtIndex:indexPath.row] valueForKey:@"start_date"];
        
        
        NSString *start_time = [[sessionArray objectAtIndex:indexPath.row] valueForKey:@"start_time"];
        
        NSString *finish_time = [[sessionArray objectAtIndex:indexPath.row] valueForKey:@"finish_time"];
        
        if ([start_date isEqualToString:@""]) {
            
            start_date = @"";
        }
        
        if ([finish_time isEqualToString:@""]) {
            
            finish_time = @"";
        }
        
        if ([start_time isEqualToString:@""]) {
            
            start_time = @"";
        }
        
        
        start_date = [dateConversion convertDate:start_date];
        
        // finish_date = [dateConversion convertDate:finish_date];
        
        NSString *str = @" - ";
        
        start_date = [start_date stringByAppendingString:@" ( "];
        
        start_date = [start_date stringByAppendingString:start_time];
        
        start_date = [start_date stringByAppendingString:str];
        
        start_date = [start_date stringByAppendingString:finish_time];
        
        start_date = [start_date stringByAppendingString:@" )"];
        
        // finish_date = [dateConversion convertDate:finish_date];
        
        //  NSString *str = @" - ";
        
        //start_date = [start_date stringByAppendingString:str];
        
        //start_date = [start_date stringByAppendingString:finish_date];
        
        sessionCell.session_date.text = start_date;
        
        if (indexPath.row == sessionArray.count - 1) {
            
            sessionCell.sepertaor_view.hidden = YES;
        }
        
        return sessionCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == review_table) {
        
        return review_cellHieght;
        
    } else {
        
        return session_cellHieght;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == review_table) {
        
        
    } else {
        
        NSDictionary *sesionDict =[[eventDetailArray valueForKey:@"event_info"]valueForKey:@"EventListing"];
    
        NSDictionary *age_groupDict = [[eventDetailArray valueForKey:@"age_title"] objectAtIndex:indexPath.row];
        
        NSDictionary *course_sessionDict = [[eventDetailArray valueForKey:@"event_sessions"] objectAtIndex:indexPath.row];
        
        NSDictionary *suitableDict = [[eventDetailArray valueForKey:@"suitable_for"] objectAtIndex:indexPath.row];
        
        NSMutableDictionary *sessionData_dict = [[NSMutableDictionary alloc] init];
        
        [sessionData_dict setObject:sesionDict forKey:@"sesion"];
        
        [sessionData_dict setObject:age_groupDict forKey:@"age_group"];
        
        [sessionData_dict setObject:course_sessionDict forKey:@"course_session"];
        
        [sessionData_dict setObject:suitableDict forKey:@"suitable"];
        
        NSLog(@"%@", sessionData_dict);
        
        [[NSUserDefaults standardUserDefaults] setValue:sessionData_dict forKey:@"sessionDetail"];
        
        [self performSegueWithIdentifier:@"sessionView" sender:self];
    }
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString indexPath:(NSIndexPath *)indexPath {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            reviewCell = (ReviewsTableViewCell *)[self.review_table cellForRowAtIndexPath:indexPath];
            
            reviewCell.user_img.image = image;
        }
    }];
}

- (IBAction)tapmessage_btn:(id)sender {
    
    
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
    
    sendMsgView.subject.text = [@"[Sharing] "stringByAppendingString:listing_name.text];
    
    sendMsgView.message.text = lession_dscriptionTxtView.text;
    
    sendMsgView.to_btn.hidden = YES;
    
    sendMsgView.to_textField.text = educator_name.text;
    
    sendMsgView.message.backgroundColor = [UIColor whiteColor]
    ;
    
    sendMsgView.message.layer.borderWidth = 1;
    
    sendMsgView.message.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.message.layer.cornerRadius = 5;
    
    sendMsgView.to_textField.layer.borderWidth = 1;
    
    sendMsgView.to_textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.to_textField.layer.cornerRadius = 5;
    
    sendMsgView.subject.layer.borderWidth = 1;
    
    sendMsgView.subject.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.subject.layer.cornerRadius = 5;
    
    [self.view addSubview:sendMsgView];
}

- (IBAction)tapReportabuse_btn:(id)sender {
    
    [self.view addSubview:indicator];
    
    NSDictionary *dict = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"type":@"2",@"listing_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"]};
    
    [reportAbuseConn startConnectionWithString:@"report_abuses_listing" HttpMethodType:Post_Type HttpBodyType:dict Output:^(NSDictionary * receivedData){
        
        [indicator removeFromSuperview];
        
        if ([getCourseConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Your request has been sent successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }];
}

- (IBAction)tapPinToFav_btn:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"refresh"];
    
    [self.view addSubview:indicator];
    
    
    NSString *msg;
    
    NSDictionary *paramURL;
    
    if ([fav isEqualToString:@"1"]) {
        
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"], @"type":@"2", @"un_fav":@"1"};
        
        msg = @"You have successfully unpinned this listing from your Favorites.";
        
    } else {
        
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"], @"type":@"2"};
        
        msg = @"You have successfully pinned this listing to your Favorites.";
    }
    
    //    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"], @"type":@"1"};
    
    [pinTOFavConnection startConnectionWithString:@"add_favorite" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([pinTOFavConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                if ([fav isEqualToString:@"1"]) {
                    
                    fav = @"0";
                    
                    [pinToFav_btn setImage:[UIImage imageNamed:@"favPin_gray"] forState:UIControlStateNormal];
                    
                }
                
                else{
                    
                    fav = @"1";
                    
                    [pinToFav_btn setImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                    
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                // [self.navigationController popViewControllerAnimated:YES];
                
                [alert show];
            }
        }
    }];
}

- (IBAction)tapTermBtn:(id)sender {
    
    UIStoryboard *st = self.storyboard;
    
    EventT_CViewController *evc = [st instantiateViewControllerWithIdentifier:@"eventT_C"];
    
    [self.navigationController pushViewController:evc animated:YES];
    
}

- (IBAction)tapOtherFeesBtn:(id)sender {
    
}

- (IBAction)tapEditBt:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:eventDetailArray forKey:@"eventDetail"];
    
}

- (IBAction)tapPostBtn:(id)sender {
    
    NSString *status = [[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_status"];
    
    NSString *message, *name;
    
    if ([status isEqualToString:@"1"]) {
        
        status = @"0";
        name = @"Post";
        message = @"Your Lesson has been successfully unpost";
        
    } else if ([status isEqualToString:@"0"]) {
        
        status = @"1";
        name = @"Unpost";
        message = @"Your Lesson has been successfully post";
    }
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"],@"type":@"3",@"status":status};
    
    [postConnection startConnectionWithString:@"post_list" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([postConnection responseCode] ==1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [postBtn setTitle:name forState:UIControlStateNormal];
                
                [alert show];
            }
        }
    }];
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//
//    [self fetchCourseDetail];
//}

//- (IBAction)tapPinToFav:(id)sender {
//
//    [self.view addSubview:indicator];
//
//    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"], @"type":@"3"};
//
//    [pinTOFavConnection startConnectionWithString:@"add_favorite" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
//
//        [indicator removeFromSuperview];
//
//        if ([pinTOFavConnection responseCode] == 1) {
//
//            NSLog(@"%@", receivedData);
//
//            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
//
//                [pin_favBtn setTitle:@"Pined To Favorite" forState:UIControlStateNormal];
//
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"You have successfully pinned this listing to your Favorites." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//
//                [alert show];
//            }
//        }
//    }];
//}
//
//- (IBAction)tapTwitterBtn:(id)sender {
//
//
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//    {
//        SLComposeViewController *tweetSheet = [SLComposeViewController
//                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
//
//        //   NewsFeedsCustomCell *cell = (NewsFeedsCustomCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexNo inSection:0]];
//
//        NSString *urlString = listing_name.text;
//
//        urlString = [urlString stringByAppendingString:@"\n"];
//
//        urlString = [urlString stringByAppendingString:lession_dscriptionTxtView.text];
//
//        urlString = [urlString stringByAppendingString:@" "];
//
//        //  urlString = [urlString stringByAppendingString:[[arrayNewsFeeds[indexNo] valueForKey:@"Post"] valueForKey:@"website"]];
//
//        [tweetSheet setInitialText:urlString];
//
//        [tweetSheet addURL:[NSURL URLWithString:@"http:/http://mercury.promaticstechnologies.com/ecaHub/"]];
//
//        // [tweetSheet addImage:imageView.image];
//
//        [tweetSheet addImage:[UIImage imageNamed:@"logo"]];
//
//        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
//
//            switch (result) {
//
//                case SLComposeViewControllerResultCancelled:
//
//                    NSLog(@"Post Canceled");
//                    break;
//
//                case SLComposeViewControllerResultDone:
//                {
//
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Shared successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//
//                    [alert show];
//
//                    NSLog(@"Post Sucessful");
//
//                }
//                    break;
//
//                default:
//                    break;
//            }
//        }];
//
//        [self presentViewController:tweetSheet animated:YES completion:nil];
//
//    } else {
//
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Twitter Accounts" message:@"There are no Twitter accounts configured.You can add or create a Twitter  account in Settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//
//        [alert show];
//    }
//}
////
//- (IBAction)tapFbBtn:(id)sender {
//
//    NSString *comments = listing_name.text;
//
//    comments = [comments stringByAppendingString:@"\n"];
//
//    comments = [comments stringByAppendingString:lession_dscriptionTxtView.text];
//
//    NSString *img_url = EventImageURL;
//
//    img_url = [img_url stringByAppendingString:[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture0"]];
//
//    NSLog(@"%@", img_url);
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"I just posted a course on ecaHub", @"name",
//                                   comments, @"caption",
//                                   @"", @"description",
//                                   @"http://mercury.promaticstechnologies.com/ecaHub/", @"link",
//                                   img_url, @"picture",
//                                   nil];
//    NSLog(@"%@", params);
//
//    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params
//                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//
//                                                  if (error) {
//
//                                                      NSLog(@"Error publishing story: %@", error.description);
//
//                                                  } else {
//
//                                                      if (result == FBWebDialogResultDialogNotCompleted) {
//
//                                                          NSLog(@"User cancelled.");
//
//                                                      } else {
//
//                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//
//                                                          if (![urlParams valueForKey:@"post_id"]) {
//
//                                                              NSLog(@"User cancelled.");
//
//                                                          } else {
//
//                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
//
//                                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Shared successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//
//                                                              [alert show];
//
//                                                              NSLog(@"result %@", result);
//                                                          }
//                                                      }
//                                                  }
//                                              }];
//}

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

//- (IBAction)tapLinkedInBtn:(id)sender {
//
//    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"linkinShare"];
//
//    NSString* launchUrl = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=78imindwbpf3mg&redirect_uri=http%3A%2F%2Fmercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect&state=ecaHub987654321&scope=r_fullprofile%20r_emailaddress%20w_share";
//
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
//
//    NSString *img_url = EventImageURL;
//
//    img_url = [img_url stringByAppendingString:[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture0"]];
//
//    NSDictionary *dict = @{@"title":listing_name.text, @"description": lession_dscriptionTxtView.text, @"img_url":img_url};
//
//    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"linkedInShareData"];
//}
//
//- (IBAction)tapEmailBtn:(id)sender {
//
//    NSData * photoData = UIImageJPEGRepresentation(imageView.image, 1);
//
//    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
//
//    mail.mailComposeDelegate = self;
//
//    [mail addAttachmentData:photoData mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"photo.jpg"]];
//
//    NSString *comments = listing_name.text;
//
//    comments = [comments stringByAppendingString:@"\n"];
//
//    comments = [comments stringByAppendingString:lession_dscriptionTxtView.text];
//
//    NSString *msg_body = comments;
//
//    NSString *ecaHub = @"www.ecaHub.com";
//
//    ecaHub = [@"\n\n" stringByAppendingString:ecaHub];
//
//    msg_body = [msg_body stringByAppendingString:ecaHub];
//
//    NSLog(@"%@",msg_body);
//
//    [mail setMessageBody:msg_body isHTML:YES];
//
//    [mail setSubject:@"Check out this post that I Post on ecaHub"];
//
//    [self presentViewController:mail animated:YES completion:nil];
//}

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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Shared successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
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

//- (IBAction)tapMsgBtn:(id)sender {
//
//    sendMsgView = [[SendMessageView alloc] init];
//
//    sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageView" owner:self options:nil] objectAtIndex:0];
//
//    sendMsgView.frame = self.view.frame;
//
//    sendMsgView.view_frame = self.view.frame;
//
//    sendMsgView.subject.text = listing_name.text;
//
//    sendMsgView.message.text = lession_dscriptionTxtView.text;
//
//    [self.view addSubview:sendMsgView];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapShare_btn:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Facebook",@"LinkedIn", @"Twitter", @"Message", @"Email", nil];
    
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [self FBSharing];
        
    } else if (buttonIndex == 2) {
        
        [self linkedInShare];
        
    } else if (buttonIndex == 3) {
        
        [self TwitterShare];
        
    } else if (buttonIndex == 4) {
        
        [self MessageShare];
        
    } else if (buttonIndex == 5) {
        
        [self emailShare];
    }
}
-(void)FBSharing{
    
    NSString *comments = listing_name.text;
    
    comments = [comments stringByAppendingString:@"\n"];
    
    comments = [comments stringByAppendingString:lession_dscriptionTxtView.text];
    
    NSString *img_url = EventImageURL;
    
    img_url = [img_url stringByAppendingString:[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture0"]];
    
    NSLog(@"%@", img_url);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I just posted a course on ecaHub", @"name",
                                   comments, @"caption",
                                   @"", @"description",
                                   @"http://mercury.promaticstechnologies.com/ecaHub/", @"link",
                                   img_url, @"picture",
                                   nil];
    NSLog(@"%@", params);
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params
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
-(void)linkedInShare{
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"linkinShare"];
    
    NSString* launchUrl = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=78imindwbpf3mg&redirect_uri=http%3A%2F%2Fmercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect&state=ecaHub987654321&scope=r_fullprofile%20r_emailaddress%20w_share";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
    
    NSString *img_url = EventImageURL;
    
    img_url = [img_url stringByAppendingString:[[[eventDetailArray valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"picture0"]];
    
    NSDictionary *dict = @{@"title":listing_name.text, @"description": lession_dscriptionTxtView.text, @"img_url":img_url};
    
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"linkedInShareData"];
    
    
}
-(void)TwitterShare {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        //   NewsFeedsCustomCell *cell = (NewsFeedsCustomCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexNo inSection:0]];
        
        NSString *urlString = listing_name.text;
        
        urlString = [urlString stringByAppendingString:@"\n"];
        
        urlString = [urlString stringByAppendingString:lession_dscriptionTxtView.text];
        
        urlString = [urlString stringByAppendingString:@" "];
        
        //  urlString = [urlString stringByAppendingString:[[arrayNewsFeeds[indexNo] valueForKey:@"Post"] valueForKey:@"website"]];
        
        [tweetSheet setInitialText:urlString];
        
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
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Shared successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
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

-(void)MessageShare {
    
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
    
    sendMsgView.subject.text = [@"[Sharing] "stringByAppendingString:listing_name.text];
    
    sendMsgView.message.text = lession_dscriptionTxtView.text;
    
    sendMsgView.to_btn.hidden = YES;
    
    sendMsgView.to_textField.text = educator_name.text;
    
    sendMsgView.message.backgroundColor = [UIColor whiteColor]
    ;
    
    sendMsgView.message.layer.borderWidth = 1;
    
    sendMsgView.message.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.message.layer.cornerRadius = 5;
    
    sendMsgView.to_textField.layer.borderWidth = 1;
    
    sendMsgView.to_textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.to_textField.layer.cornerRadius = 5;
    
    sendMsgView.subject.layer.borderWidth = 1;
    
    sendMsgView.subject.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.subject.layer.cornerRadius = 5;
    
    [self.view addSubview:sendMsgView];
}


-(void)emailShare{
    NSData * photoData = UIImageJPEGRepresentation(imageView.image, 1);
    
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    
    mail.mailComposeDelegate = self;
    
    [mail addAttachmentData:photoData mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"photo.jpg"]];
    
    NSString *comments = listing_name.text;
    
    comments = [comments stringByAppendingString:@"\n"];
    
    comments = [comments stringByAppendingString:lession_dscriptionTxtView.text];
    
    NSString *msg_body = comments;
    
    NSString *ecaHub = @"www.ecaHub.com";
    
    ecaHub = [@"\n\n" stringByAppendingString:ecaHub];
    
    msg_body = [msg_body stringByAppendingString:ecaHub];
    
    NSLog(@"%@",msg_body);
    
    [mail setMessageBody:msg_body isHTML:YES];
    
    [mail setSubject:@"Check out this post that I Post on ecaHub"];
    
    [self presentViewController:mail animated:YES completion:nil];
    
}

- (IBAction)tapRequestToEnrol_btn:(id)sender {
    
    [self performSegueWithIdentifier:@"allSessionSegue" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"allSessionSegue"]) {
        
        allSessionVC = (AllEventSessionViewController *)[segue destinationViewController];
        
        allSessionVC.sessionArray = eventDetailArray;
        
    } else {
        
        EventSessionViewController *eventSessionVC = (EventSessionViewController *)[segue destinationViewController];
        
        eventSessionVC.isView = YES;
        
    }
}

-(void)tap_aboutEducator:(UIButton *)sender{
    
    UIStoryboard *st = self.storyboard;
    
    EventEducatorViewController *eEduVC = [st instantiateViewControllerWithIdentifier:@"EventEducatorDetail"];
    
    [self.navigationController pushViewController:eEduVC animated:YES];
}


@end
