//
//  MyListingViewController.m
//  ecaHUB
//  Created by promatics on 3/16/15.
//  Copyright (c) 2015 promatics. All rights reserved.


#import "MyListingViewController.h"
#import "MyListingTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "EditEventViewController.h"
#import "editLessionViewController.h"
#import "EditCourseViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SendMessageView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "addWhatsOnViewController.h"
#import "recievedReviewViewController.h"

@interface MyListingViewController () {
    
    WebServiceConnection *myListingConn;
    
    WebServiceConnection *getCourseConn, *postConnection, *deleteConn;
    
    EditCourseViewController *editCourse;
    
    EditEventViewController *editEvent;
    
    editLessionViewController *editLession;
    
    SendMessageView *sendMsgView;
    
    addWhatsOnViewController *addWhatson;
    
    NSMutableArray *courseArray,*lessonArray,*eventArray,*courseCatArray,*lessonCatArray,*eventCatArray;
    
    Indicator *indicator;
    
    MyListingTableViewCell *cell;
    
    NSArray  *cousreDetailArray;
    
    NSArray *categoryArray;
    
    DateConversion *dateConversion;
    
    NSString *listing, *type_name;
    
    NSString *status_type;
    
    NSString *urll;
    
    NSString *comment, *imgUrl, *urlString, *name, *discription;
    
    NSDictionary *paramDict;
    NSString *URLStr;
    
    int indexNumber;
    
    UIButton *selectedButton;
    
    NSArray *currentArray;
    
    NSInteger tapTag;
    
    BOOL isScrollUp;
    
    BOOL isServiceCall,isNextPage,isLodin;
    
    BOOL nameSelected;
    
    CGFloat lastContentOffset;
    
    int page_no;
    
    NSMutableArray *listingArray;
    
    NSDictionary *postDict;
    
    int totalPage;
    
    BOOL tapAction;
    
    BOOL postStatus;
    
    NSArray *subCatArr;
    
    BOOL tap_filter;
    
    NSDictionary *delParam;
    
    NSString *filter_type;
    
    NSInteger filter_tag;
    
    NSMutableArray *listNameArr;
    
    NSMutableArray *postListArr;
    
    NSMutableArray *unPostListArr;
    
    NSMutableArray *expiredListArr;
    
    NSMutableArray *postCatArr;
    
    NSMutableArray *unPostCatArr;
    
    NSMutableArray *expCatArr;
    
    NSMutableArray *postSubCatArr;
    
    NSMutableArray *unPostSubCatArr;
    
    NSMutableArray *expSubCatArr;
    
    NSMutableArray *courseSubCatArr;
    
    NSMutableArray *lessonSubCatArr;
    
    NSMutableArray *eventSubCatArr;
    
    NSMutableArray *mainArr;
    
    NSArray *maimCatArr;
    
    NSArray *mainSubArr;
    
    float tblOrigion;
    
}
@end

@implementation MyListingViewController

@synthesize listing_table,addBtn,filter_btn,reset_btn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    tapTag = 0;
    
    isLodin = YES;
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    self.title = @"My Listings";
    
    listingArray = [[NSMutableArray alloc]init];
    
    mainSubArr = [[NSMutableArray alloc] init];
    
    self.navigationItem.rightBarButtonItems = @[addBtn,filter_btn];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Hotmail"];
    
    myListingConn = [WebServiceConnection connectionManager];
    
    getCourseConn = [WebServiceConnection connectionManager];
    
    postConnection= [WebServiceConnection connectionManager];
    
    deleteConn = [WebServiceConnection connectionManager];
    
    indicator= [[Indicator alloc] initWithFrame:self.view.frame];
    
    [cell.listing_name setTextAlignment:NSTextAlignmentLeft];
    
    dateConversion = [DateConversion dateConversionManager];
    
    page_no = 1;
    
    tapAction = NO;
    
    reset_btn.hidden = YES;
    
    nameSelected = NO;
    
    tblOrigion = listing_table.frame.origin.y;
    
    [self fetchMyListing:page_no];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Gmail"];
    
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"reload"];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"reload"] isEqualToString:@"1"]){
        
        tapAction = YES;
    }
    
    if(tapAction){
        
        page_no = 1;
        
        [self fetchMyListing:page_no];
    }
}

-(void) fetchMyListing:(int)current_page {
    
    NSDictionary *paramURL;
    
    if(!nameSelected){
        
        if(tap_filter){
            
            paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"filter_list":filter_type};
            
        } else {
            
            paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
        }
        
        filter_btn.enabled = NO;
        
        [self.view addSubview:indicator];
        
        NSString *service =[@"listing/page:" stringByAppendingString:[NSString stringWithFormat:@"%d",current_page]];
        	
        
        [myListingConn startConnectionWithString:service HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            filter_btn.enabled = YES;
            
            if ([myListingConn responseCode] == 1) {
                
                if(tapAction){
                    
                    listingArray = [[NSMutableArray alloc] init];
                    
                    tapAction = NO;
                    
                }
                
                if(tap_filter){
                    
                    
                    [self setTblFrame];
                    
                    if(current_page == 1){
                        
                        listingArray = [[NSMutableArray alloc] init];
                    }
                    
                    reset_btn.hidden = NO;
                    
                } else if (current_page == 1){
                    
                    listingArray = [[NSMutableArray alloc] init];
                    
                }
                
                NSLog(@"%@", receivedData);
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 0) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"You can create and post Listings for free. A Listing can be an individual Course, a type of Lesson or an upcoming Event. The opportunities are endless. Click the '+' to create one now." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    isLodin = YES;
                    
                } else {
                    
                    isLodin = YES;
                    
                    totalPage = [[receivedData valueForKey:@"total_page"] integerValue];
                    
                    subCatArr = [receivedData valueForKey:@"subcategory_names"];
                    
                    NSArray *dataArray;
                    
                    dataArray = [receivedData valueForKey:@"posted_courses"];
                    
                    [listingArray addObjectsFromArray:dataArray];
                    
                    // NSArray *array = [[receivedData valueForKey:@"posted_courses"]valueForKey:@"CourseListing"];
                    
                    categoryArray = [receivedData valueForKey:@"category_names"];
                    
                    mainArr = listingArray;
                    
                    maimCatArr = categoryArray;
                    
                    mainSubArr = subCatArr;
                    
                    [self filterMyListing];
                    
                    [listing_table reloadData];
                    
                    
                }
            }
            
            else{
                
                page_no = page_no - 1;
            }
            
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated {
//
//
//    listingArray = [[NSMutableArray alloc]init];
//
//    [listing_table reloadData];
//
//    isLodin = YES;
//    page_no = 1;
//
//    [self fetchMyListing:page_no];
//}

#pragma mark - UITable View Delegates & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return listingArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return cell.main_view.frame.size.height+10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"MyListingCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil){
        
        cell = [[MyListingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyListingCell"];
    }
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        cell.check_Btn.layer.cornerRadius = 15.0f;
        
        //
        //        CGRect frame1 = cell.button_view.frame;
        //        frame1.origin.x = (cell.main_view.frame.size.width- frame1.size.width)/2;
        //        frame1.origin.y =  cell.frame.size.height - cell.button_view.frame.size.height - 15;
        //        cell.button_view.frame =frame1;
        
        CGRect frame1 = cell.main_view.frame;
        
        frame1.origin.x = 20;
        
        frame1.size.width = cell.frame.size.width - 40;
        
        cell.main_view.frame = frame1;
        
        frame1 = cell.image_view.frame;
        
        frame1.size.width = cell.main_view.frame.size.width;
        
        frame1.size.height = 302;
        
        cell.image_view.frame = frame1;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        cell.check_Btn.layer.cornerRadius = 13.0f;
        
        cell.image_view.frame = CGRectMake(0, 0, cell.main_view.frame.size.width, 170);
        
        // cell.button_view.frame = CGRectMake(10, cell.main_view.frame.size.height - cell.button_view.frame.size.height - 15, cell.main_view.frame.size.width-20, 35);
        
        CGRect frame1 = cell.main_view.frame;
        
        frame1.origin.x = 15;
        
        frame1.size.width = cell.frame.size.width - 30;
        
        cell.main_view.frame = frame1;
        
        
        frame1 = cell.image_view.frame;
        
        frame1.size.width = cell.main_view.frame.size.width;
        
        cell.image_view.frame = frame1;
    }
    
//    CGRect frame = cell.listing_name.frame;
//    
//    frame.size.width = cell.main_view.frame.size.width - ((frame.origin.x) *2);
//    
//    cell.listing_name.frame = frame;
//    
//    frame = cell.business_name.frame;
//    
//    frame.size.width = cell.main_view.frame.size.width - ((frame.origin.x) *2);
//    
//    cell.business_name.frame = frame;
//    
//    frame = cell.cat_name.frame;
//    
//    frame.origin.y = cell.catname_stlbl.frame.origin.y;
//    
//    frame.size.width = cell.main_view.frame.size.width - ((frame.origin.x) *2);
//    
//    cell.cat_name.frame = frame;
//    
//    frame = cell.business_name.frame;
//    frame.size.width = cell.main_view.frame.size.width - ((frame.origin.x) *2);
//    
//    cell.business_name.frame = frame;
//    
//    frame = cell.listing_name.frame;
//    
//    frame.size.width = cell.main_view.frame.size.width - ((frame.origin.x) *2);
//    
//    cell.listing_name.frame = frame;
    
    NSString *type, *location;
    
    listing = [[listingArray objectAtIndex:indexPath.row] valueForKey:@"model"] ;
    
    NSString *totalSession = [[listingArray objectAtIndex:indexPath.row] valueForKey:@"total_session"] ;
    
    //cell.expired.text = @"Pending - Incomplete";
    
    
    NSLog(@"%@",listing);
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        type_name = @"course_name";
        status_type = @"course_status";
        urll = CourseImageURL;
        location = @"course_city";
        type = @"Course" ;
        
    } else if ([listing isEqualToString:@"LessonListing"]) {
        
        listing = @"LessonListing";
        type_name = @"lesson_name";
        status_type = @"lesson_status";
        urll = LessonImageURL;
        location = @"lesson_city";
        type = @"Lesson";
    } else if ([listing isEqualToString:@"EventListing"]) {
        
        listing = @"EventListing";
        type_name = @"event_name";
        status_type = @"event_status";
        urll = EventImageURL;
        location = @"event_city";
        type = @"Event";
    }
    
    CGRect frame1 = cell.delete_btn.frame;
    frame1.origin.x = cell.main_view.frame.size.width - frame1.size.width - 15;
    cell.delete_btn.frame = frame1;
    
    frame1 = cell.check_Btn.frame;
    frame1.origin.x = cell.main_view.frame.size.width - frame1.size.width - 25;
    cell.check_Btn.frame = frame1;
    
    frame1 = cell.check_Btn.frame;
    frame1.origin.y = cell.image_view.frame.size.height - frame1.size.height/2;
    cell.check_Btn.frame = frame1;
    
    cell.listing_name.text = [[[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:type_name]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [cell.listing_name setTextAlignment:NSTextAlignmentLeft];
    
    NSString *new_category_status = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"new_category_status"];
    
    cell.business_name.text = [[[[listingArray objectAtIndex:indexPath.row] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    cell.button_view.layer.borderWidth = 1.0f;
    
    cell.button_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    cell.button_view.layer.masksToBounds = YES;
    
    //NSString *categoriesStr = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"category_id"];
    
    // NSArray *cat_id = [categoriesStr componentsSeparatedByString:@","];
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    NSArray *countArray = [categoryArray objectAtIndex:indexPath.row];
    
    for (int i =0 ; i< countArray.count; i++) {
        
        //  [categories addObject:[[categoryArray objectAtIndex:indexPath.row] valueForKey:[cat_id objectAtIndex:i]]];
        
        [categories addObject:[[[[categoryArray objectAtIndex:indexPath.row] objectAtIndex:i] valueForKey:@"Category"] valueForKey:@"category_name"]];
    }
    
    NSArray *subCat_Arr;
    
    NSString *subCat;
    
    subCat = @" ";
    
    
    if([[subCatArr objectAtIndex:indexPath.row] count]> 0){
        
        subCat_Arr = [subCatArr objectAtIndex:indexPath.row];
        
        subCat = @", ";
        
        int i=0;
        
        
        while(i< subCat_Arr.count){
            
            if(i>0){
                
                subCat = [subCat stringByAppendingString:@", "];
            }
            
            subCat = [subCat stringByAppendingString:[[[subCat_Arr objectAtIndex:i] valueForKey:@"Subcategory"] valueForKey:@"subcategory_name"]];
            
            
            i++;
            
        }
        
    }
    
    if ([new_category_status isEqualToString:@"1"]) {
        
        cell.cat_name.text = [[categories componentsJoinedByString:@", "]stringByAppendingString:@" (Pending)"];
        
    }
    else {
        
        cell.cat_name.text = [categories componentsJoinedByString:@", "];
        
    }
    
    NSLog(@"cataogory    =  %@",cell.cat_name.text);
    
    NSString *date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"post_date"];
    
    if([date isEqualToString:@""] || !date){
        
        // cell.expired.text = @"Indefinite";
        
    } else {
        
        cell.post_date.text = [dateConversion convertDate:date];
        
    }
    
    NSString *typeCity = [type stringByAppendingString:@" | "];
    
    cell.type_city_lbl.text = [typeCity stringByAppendingString:[NSString stringWithFormat:@"%@",[[[listingArray objectAtIndex:indexPath.row] valueForKey:location] valueForKey:@"city_name"]]];
    
    NSString *imageURL = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"picture0"];
    
    for (int i = 1; i<4; i++) {
        
        NSString *pic = [NSString stringWithFormat:@"picture%d",i];
        
        if ([imageURL length] < 1) {
            
            imageURL = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:pic];
        }
    }
    
    imageURL = [imageURL stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceCharacterSet]];
    
    cell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
    
    [cell.view_bttn addTarget:self action:@selector(tapViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.edit_bttn addTarget:self action:@selector(tapEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.share_btnn addTarget:self action:@selector(tapShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.review_bttn addTarget:self action:@selector(tapReviewBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.post_bttn addTarget:self action:@selector(tapPostBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.delete_btn addTarget:self action:@selector(tapDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.view_bttn.tag = indexPath.row;
    cell.edit_bttn.tag = indexPath.row;
    cell.share_btnn.tag = indexPath.row;
    cell.review_bttn.tag = indexPath.row;
    cell.post_bttn.tag = indexPath.row;
    cell.delete_btn.tag = indexPath.row;
    
    selectedButton = cell.post_bttn;
    
    if ([imageURL length] < 1) {
        
        //Listing_Image
        cell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
        
    } else {
        
        imageURL = [urll stringByAppendingString:imageURL];
        
        [cell.image_view sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Listing_Image"]];
    }
    
    NSString *status = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:status_type];
    
    if ([status isEqualToString:@"0"]) {
        
        [cell.post_bttn setUserInteractionEnabled:YES];
        
        [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        
        [cell.post_bttn setBackgroundImage:[UIImage imageNamed:@"upload_gray"] forState:UIControlStateNormal];
        
        cell.postDate_lbl.text = @"Create Date:";
        
        NSString *date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"created_at"];
        
        if([date isEqualToString:@""] || !date){
            
            // cell.expired.text = @"Indefinite";
            
        } else {
            
            cell.post_date.text = [dateConversion convertDate:date];
            
        }
        
        //cell.expired.hidden =  YES;
        
        //cell.expiry_lbl.hidden = YES;
        
    }else if ([status isEqualToString:@"1"]){
        
        [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"Check_Mark"] forState:UIControlStateNormal];
        
        [cell.post_bttn setBackgroundImage:[UIImage imageNamed:@"post_gray"] forState:UIControlStateNormal];
        
        cell.expired.hidden = NO;
        
        [cell.post_bttn setUserInteractionEnabled:YES];
        
        cell.expiry_lbl.hidden = NO;
        
        cell.postDate_lbl.text = @"Post Date :";
        
        NSString *date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"post_date"];
        
        if([date isEqualToString:@""] || !date){
            
            // cell.expired.text = @"Indefinite";
            
        } else {
            
            cell.post_date.text = [dateConversion convertDate:date];
            
        }
        
        date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"expiry_date"];
        
        if([date isEqualToString:@""] || !date){
            
            // cell.expired.text = @"Indefinite";
            
        } else {
            
            cell.expired.text = [dateConversion convertDate:date];
            
        }
        
    } else if ([status isEqualToString:@"2"]){
        
        NSString *date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"created_at"];
        
        if([date isEqualToString:@""] || !date){
            
            // cell.expired.text = @"Indefinite";
            
        } else {
            
            cell.post_date.text = [dateConversion convertDate:date];
            
        }
        
        NSDate *nowDate = [NSDate date];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *expirydate = [dateFormat dateFromString:date];
        
        NSLog(@"%@",expirydate);
        
        if ([expirydate compare:nowDate] != NSOrderedAscending) {
            
            [cell.post_bttn setUserInteractionEnabled:YES];
            
        } else{
            
            [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"expiry_icon"] forState:UIControlStateNormal];
            
            [cell.post_bttn setUserInteractionEnabled: NO];
        }
        
    }else {
        
        [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        
        [cell.post_bttn setBackgroundImage:[UIImage imageNamed:@"post_gray"] forState:UIControlStateNormal];
        
        //cell.post_bttn.userInteractionEnabled = NO;
        
        cell.expired.hidden = NO;
        
        [cell.post_bttn setUserInteractionEnabled:YES];
        
        cell.expiry_lbl.hidden = NO;
        
        cell.postDate_lbl.text = @"Post Date  :";
        
        NSString *date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"post_date"];
        
        if([date isEqualToString:@""] || !date){
            
            // cell.expired.text = @"Indefinite";
            
        } else {
            
            cell.post_date.text = [dateConversion convertDate:date];
            
        }
        
        date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"expiry_date"];
        
        if([date isEqualToString:@""] || !date) {
            
            //   date = @"0000-00-00 00:00";
        }
    }
    
    if([totalSession integerValue] == 0){
        
        cell.expired.text = @"Pending - Incomplete";
        
    } else {
        
        date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"expiry_date"];
        
        if([date isEqualToString:@""] || !date){
            
            // cell.expired.text = @"Indefinite";
            
        } else {
            
            cell.expired.text = [dateConversion convertDate:date];
            
        }
        
    }
    
    [cell.check_Btn addTarget:self action:@selector(tapCheck_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.check_Btn.tag = indexPath.row;
    
    [cell.listing_name setTextAlignment:NSTextAlignmentLeft];
    
    CGRect frame = cell.listing_name.frame;
    
    frame.size.width = cell.main_view.frame.size.width - ((frame.origin.x) *2);
    
    cell.listing_name.frame = frame;
    
    [cell.listing_name sizeToFit];
    
    frame = cell.business_name.frame;
        
    frame.size.width = cell.main_view.frame.size.width - ((frame.origin.x) *2);
    
    frame.origin.y = cell.listing_name.frame.origin.y + cell.listing_name.frame.size.height +10;
    
    cell.business_name.frame = frame;
    
    [cell.business_name sizeToFit];
    
    frame = cell.cat_name.frame;
    
    frame.origin.y = frame.origin.y = cell.business_name.frame.origin.y + cell.business_name.frame.size.height +10;
    
    //frame.size.width = cell.post_date.frame.size.width;
    
    frame.size.width = cell.main_view.frame.size.width - frame.origin.x -10;
    
    cell.cat_name.frame = frame;
    
    cell.cat_name.text = [cell.cat_name.text stringByAppendingString:subCat];
    
    NSLog(@"cataogory    =  %@",cell.cat_name.text);
    
    [cell.cat_name sizeToFit];
    
    frame = cell.catname_stlbl.frame;
    
    frame.origin.y = cell.cat_name.frame.origin.y;
    
    cell.catname_stlbl.frame = frame;
    
    [cell.catname_stlbl sizeToFit];
    
    NSLog(@"hieght = %f width = %f",cell.cat_name.frame.size.height,cell.cat_name.frame.size.width);
    
    frame = cell.postDate_lbl.frame;
    
    frame.origin.y = cell.cat_name.frame.origin.y+cell.cat_name.frame.size.height+10;
    
    cell.postDate_lbl.frame = frame;
    
    frame = cell.post_date.frame;
    
    frame.origin.y = cell.cat_name.frame.origin.y+cell.cat_name.frame.size.height+10;
    
    frame.size.width = cell.main_view.frame.size.width - frame.origin.x -10;
    
    cell.post_date.frame = frame;
    
    frame = cell.typeCity_static_lbl.frame;
    
    frame.origin.y = cell.post_date.frame.origin.y+cell.post_date.frame.size.height+10;
    
    cell.typeCity_static_lbl.frame = frame;
    
    [cell.typeCity_static_lbl sizeToFit];
    
    frame = cell.type_city_lbl.frame;
    
    frame.origin.y = cell.post_date.frame.origin.y+cell.post_date.frame.size.height+10;
    
    frame.size.width = cell.main_view.frame.size.width - frame.origin.x -10;
    
    cell.type_city_lbl.frame = frame;
    
    [cell.type_city_lbl sizeToFit];
    
    frame = cell.expiry_lbl.frame;
    
    frame.origin.y = cell.type_city_lbl.frame.origin.y+cell.type_city_lbl.frame.size.height+10;
    
    cell.expiry_lbl.frame = frame;
    
    [cell.expiry_lbl sizeToFit];
    
    frame = cell.expired.frame;
    
    frame.origin.y = cell.type_city_lbl.frame.origin.y+cell.type_city_lbl.frame.size.height+10;
    
    frame.size.width = cell.main_view.frame.size.width - frame.origin.x -10;
    
    cell.expired.frame = frame;
    
    [cell.expired sizeToFit];
    
    frame = cell.sub_View.frame;
    
    frame.size.height = cell.expired.frame.origin.y+cell.expired.frame.size.height;
    
    cell.sub_View.frame = frame;
    
    frame = cell.button_view.frame ;
    
    frame.origin.y =cell.sub_View.frame.origin.y + cell.sub_View.frame.size.height+10;
    
    cell.button_view.frame = frame;
    
    frame = cell.main_view.frame;
    
    frame.size.height = cell.button_view.frame.origin.y+cell.button_view.frame.size.height+10;
    
    cell.main_view.frame = frame;
    
//    cell.listing_name.backgroundColor = [UIColor blackColor];
//    
//    cell.business_name.backgroundColor = [UIColor darkGrayColor];
//    
//    cell.catname_stlbl.backgroundColor = [UIColor cyanColor];
//    
//    cell.cat_name.backgroundColor = [UIColor cyanColor];
//    
//    cell.post_date.backgroundColor = [UIColor redColor];
//    
//    cell.postDate_lbl.backgroundColor =[UIColor redColor];
    
    return cell;
}

-(void)tapCheck_btn: (UIButton *)sender {
    
    NSString *status = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:status_type];
    
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


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *listId,*type;
    
    listing = [[listingArray objectAtIndex:indexPath.row] valueForKey:@"model"];
    
    NSLog(@"%@",listing);
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        
        type_name = @"course_name";
        
        status_type = @"course_status";
        
        urll = CourseImageURL;
        
        type = @"1";
        
    } else if ([listing isEqualToString:@"LessonListing"]) {
        
        listing = @"LessonListing";
        
        type_name = @"lesson_name";
        
        status_type = @"lession_status";
        
        urll = LessonImageURL;
        
        type = @"3";
        
    } else if ([listing isEqualToString:@"EventListing"]) {
        
        listing = @"EventListing";
        
        type_name = @"event_name";
        
        status_type = @"event_status";
        
        urll = EventImageURL;
        
        type = @"2";
    }
    
    listId = [[[listingArray objectAtIndex:indexPath.row]valueForKey:listing]valueForKey:@"id"];
    
    cell.listing_name.text = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:type_name];
    
    cell.business_name.text = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"name_educator"];
    
    if(editingStyle==UITableViewCellEditingStyleDelete) {
        
        
        delParam = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"listing_id":listId,@"listing_type":type};
        
        NSString *msg = @"Are you sure you want to delete\n {";
        
        msg = [msg stringByAppendingString:name];
        
        msg = [msg stringByAppendingString:@"}?"];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes Delete", nil];
        
        alert.tag = 10;
        
        [alert show];
        
        
        
        //       //member_id,listing_id,listing_type (1=>course,2 =>event, 3=> Lesson)
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    listing = [[listingArray objectAtIndex:indexPath.row] valueForKey:@"model"];
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        type_name = @"course_name";
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        listing = @"LessonListing";
        type_name = @"lession_name";
        
    }  else if ([listing isEqualToString:@"EventListing"]){
        
        listing = @"EventListing";
        type_name = @"event_name";
    }
    
    NSString *course_id = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"id"];
    
    NSLog(@"Course Tap Id%@", course_id);
    
    [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        [self performSegueWithIdentifier:@"courseDetailSegue" sender:self];
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        [self performSegueWithIdentifier:@"lession_view" sender:self];
        
    }  else if ([listing isEqualToString:@"EventListing"]){
        
        [self performSegueWithIdentifier:@"event_view_segue" sender:self];
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // if(isServiceCall){
    
    if( (indexPath.row >= (int)(listingArray.count - 5)) && (isScrollUp)){
        
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
    
    [self fetchMyListing:page_no];
    
    isLodin = NO;
    
    isNextPage = NO;
    
}

-(void)tapDeleteBtn:(UIButton *)sender{
    
    NSString *listId,*type;
    
    listing = [[listingArray objectAtIndex:sender.tag] valueForKey:@"model"] ;
    
    NSLog(@"%@",listing);
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        
        type_name = @"course_name";
        
        status_type = @"course_status";
        
        urll = CourseImageURL;
        
        type = @"1";
        
    } else if ([listing isEqualToString:@"LessonListing"]) {
        
        listing = @"LessonListing";
        
        type_name = @"lesson_name";
        
        status_type = @"lession_status";
        
        urll = LessonImageURL;
        
        type = @"3";
        
    } else if ([listing isEqualToString:@"EventListing"]) {
        
        listing = @"EventListing";
        
        type_name = @"event_name";
        
        status_type = @"event_status";
        
        urll = EventImageURL;
        
        type = @"2";
        
    }
    
    listId = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing]valueForKey:@"id"];
    
    cell.listing_name.text = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:type_name];
    
    name = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:type_name];
    
    cell.business_name.text = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"name_educator"];
    
    delParam = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"listing_id":listId,@"listing_type":type};
    
    
    NSString *msg = @"Are you sure you want to delete\n {";
    
    msg = [msg stringByAppendingString:name];
    
    
    msg = [msg stringByAppendingString:@"}?"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes Delete", nil];
    
    alert.tag = 10;
    
    [alert show];
    
    
    //member_id,listing_id,listing_type (1=>course,2 =>event, 3=> Lesson)
    
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString1 indexPath:(NSIndexPath *)indexPath {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            cell = (MyListingTableViewCell *)[self.listing_table cellForRowAtIndexPath:indexPath];
            
            cell.image_view.image = image;
        }
    }];
}
-(void)tapViewBtn:(UIButton *)sender{
    
    listing = [[listingArray objectAtIndex:sender.tag] valueForKey:@"model"] ;
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        type_name = @"course_name";
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        listing = @"LessonListing";
        type_name = @"lession_name";
        
    }  else if ([listing isEqualToString:@"EventListing"]){
        
        listing = @"EventListing";
        type_name = @"event_name";
    }
    
    NSString *course_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"id"];
    
    NSLog(@"Course Tap Id%@", course_id);
    
    [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        [self performSegueWithIdentifier:@"courseDetailSegue" sender:self];
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        [self performSegueWithIdentifier:@"lession_view" sender:self];
        
    }  else if ([listing isEqualToString:@"EventListing"]){
        
        [self performSegueWithIdentifier:@"event_view_segue" sender:self];
    }
}

-(void)tapEditBtn:(UIButton *)sender {
    
    listing = [[listingArray objectAtIndex:sender.tag] valueForKey:@"model"] ;
    
    UIStoryboard *storyboard;
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        type_name = @"course_name";
        URLStr = @"course_view";
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        listing = @"LessonListing";
        type_name = @"lession_name";
        URLStr = @"lesson_view";
        
    }  else if ([listing isEqualToString:@"EventListing"]){
        
        listing = @"EventListing";
        type_name = @"event_name";
        URLStr = @"event_view";
        
    }
    
    NSString *course_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"id"];
    
    NSLog(@"Course Tap Id%@", course_id);
    
    [[NSUserDefaults standardUserDefaults] setObject:course_id forKey:@"course_id"];
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        storyboard = self.storyboard;
        
        editCourse = [storyboard instantiateViewControllerWithIdentifier:@"editCourse"];
        
        [self.navigationController pushViewController:editCourse animated:YES];
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        storyboard = self.storyboard;
        
        editLession = [storyboard instantiateViewControllerWithIdentifier:@"editLession"];
        
        [self.navigationController pushViewController:editLession animated:YES];
        
    }  else if ([listing isEqualToString:@"EventListing"]){
        
        storyboard = self.storyboard;
        
        editEvent = [storyboard instantiateViewControllerWithIdentifier:@"editEvent"];
        
        [self.navigationController pushViewController:editEvent animated:YES];
    }
    
    //
    //    [self.view addSubview:indicator];
    //
    //    NSLog(@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"], [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]);
    //
    //    //@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
    //
    //    NSDictionary *paramURL = @{ @"course_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"course_id"]};
    //
    //    [getCourseConn startConnectionWithString:[NSString stringWithFormat:URLStr] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
    //
    //        [indicator removeFromSuperview];
    //
    //        if ([getCourseConn responseCode] == 1) {
    //
    //            NSLog(@"%@", receivedData);
    //
    //            cousreDetailArray = [receivedData copy];
    //
    //            [[NSUserDefaults standardUserDefaults] setObject:cousreDetailArray forKey:@"CourseDetail"];
    //                    }
    //
    //    }];
    
    
}
-(void)tapShareBtn:(UIButton *)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"Twitter",@"Linkedin",@"Email",@"Message", nil];
    
    actionSheet.tag = 2;
    
    indexNumber = (int)sender.tag;
    [actionSheet showInView:self.view];
    
}

-(void)tapReviewBtn:(UIButton *)sender{
    
    NSString *status, *listId ,*type,*listName,*url;
    
    listing = [[listingArray objectAtIndex:sender.tag] valueForKey:@"model"] ;
    
    NSString *imageURL = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"picture0"];
    
    for (int i = 1; i<4; i++) {
        
        NSString *pic = [NSString stringWithFormat:@"picture%d",i];
        
        if ([imageURL length] < 1) {
            
            imageURL = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:pic];
        }
    }
    
    
    if ([listing isEqualToString:@"CourseListing"]){
        
        listId = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"id"] ;
        
        status =  [[[listingArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:status_type];
        
        
        
        listName = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"course_name"] ;
        
        type = @"1";
        
        url = CourseImageURL;
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        listId = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"id"] ;
        
        listName = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"lesson_name"] ;
        
        status =  [[[listingArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:status_type];
        
        
        type = @"3";
        
        url =  LessonImageURL;
        
    } else if ([listing isEqualToString:@"EventListing"]){
        
        listId = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"id"] ;
        
        
        listName = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"event_name"] ;
        
        status =  [[[listingArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:status_type];
        
        type = @"2";
        
        url = EventImageURL;
        
    }
    
    imageURL = [imageURL stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceCharacterSet]];
    
    imageURL = [urll stringByAppendingString:imageURL];
    
    // [cell.image_view sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Listing_Image"]];
    
    recievedReviewViewController *reviewVc = [self.storyboard instantiateViewControllerWithIdentifier:@"recievedReviewVC"];
    
    reviewVc.list_type = type;
    
    reviewVc.list_id = listId;
    
    reviewVc.listName = listName;
    
    reviewVc.url = imageURL;
    
    reviewVc.status = status;
    
    [self.navigationController pushViewController:reviewVc animated:YES];
    
}


-(void)tapPostBtn:(UIButton *)sender{
    
    
    NSString *status, *listId ,*type;
    
    listing = [[listingArray objectAtIndex:sender.tag] valueForKey:@"model"] ;
    
    NSString *city_name,*member_id,*listName,*expDate,*listing_id;
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        
        type_name = @"course_name";
        
        URLStr = @"course_view";
        
        status = @"course_status";
        
        listId = @"id";
        
        type = @"1";
        
        city_name = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"course_city"] valueForKey:@"city_name"] ;
        
        listName = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"course_name"] ;
        
        listing_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"id"] ;
        
        expDate = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"expiry_date"] ;
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        listing = @"LessonListing";
        
        type_name = @"lession_name";
        
        URLStr = @"lesson_view";
        
        status = @"lesson_status";
        
        type = @"3";
        
        city_name = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"lesson_city"] valueForKey:@"city_name"] ;
        
        listName = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"lesson_name"] ;
        
        listing_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"id"] ;
        
        expDate = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"expiry_date"] ;
        
    }  else if ([listing isEqualToString:@"EventListing"]){
        
        listing = @"EventListing";
        
        type_name = @"event_name";
        
        URLStr = @"event_view";
        
        status = @"event_status";
        
        type = @"2";
        
        city_name = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"event_city"] valueForKey:@"city_name"] ;
        
        listName = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"event_name"] ;
        
        listing_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"id"] ;
        
        expDate = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"expiry_date"];
        
    }
    NSString *statuss = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:status];
    
    listId = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"id"];
    
    NSString *message;
    
    if ([statuss isEqualToString:@"1"]) {
        
        statuss = @"0";
        
        message = @"Your Listing has been successfully unpost";
        
        postStatus = YES;
        
    } else if ([statuss isEqualToString:@"0"]) {
        
        postStatus = YES;
        
        NSString *listing1 = [[listingArray objectAtIndex:sender.tag] valueForKey:@"model"] ;
        
        NSString *total_Session = [[listingArray objectAtIndex:sender.tag] valueForKey:@"total_session"];
        
        NSString *new_category_status = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing1] valueForKey:@"new_category_status"];
        
        if ([total_Session integerValue] == 0) {
            
            postStatus = NO;
            
            //You need to complete Step 2 before you can post your Listing. Click 'Edit' and continue to Session Options page.
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You need to complete Step 2 before you can post your Listing. Click 'Edit' and continue to Session Options page." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
            
            [alert show];
            
        } else if ([new_category_status isEqualToString:@"1"]){
            
            postStatus = NO;
            
            //Your suggested category has been submitted, and once approved, your Listing will be posted.
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Thank you for suggesting a new category! Once the category has been approved you will be notified by email by the next business day. Your Listing will be posted under the exact category wording you submitted or under something similar." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        statuss = @"1";
        
        message = @"Your Listing has been posted successfully. You should now post in \"What's On!\" to boost your Listing exposure. You have a certain number of FREE posts per month. Check it out.";
    }
    
    if(postStatus) {
        
        [self.view addSubview:indicator];
        
        NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":listId,@"type":type,@"status":statuss};
        
        [postConnection startConnectionWithString:@"post_list" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([postConnection responseCode] ==1) {
                
                tapAction = YES;
                
                NSLog(@"%@", receivedData);
                
                postDict = @{@"expiry_date":expDate,@"listing_id":listing_id,@"type":type,@"name":listName,@"list_id":[receivedData valueForKey:@"listing_id"],@"city_name":city_name};
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                    
                    
                    NSString *statuss = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:status];
                    
                    
                    if ([statuss isEqualToString:@"1"]) {
                        
                        statuss = @"0";
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [selectedButton setBackgroundImage:[UIImage imageNamed:@"upload_gray"] forState:UIControlStateNormal];
                        
                        page_no = 1;
                        
                        [self fetchMyListing:page_no];
                        
                        [alert show];
                        
                        // message = @"Your Listing has been successfully unpost";
                        
                    } else if ([statuss isEqualToString:@"0"]) {
                        
                        statuss = @"1";
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        //[self fetchMyListing:page_no];
                        
                        [alert show];
                        
                        [selectedButton setBackgroundImage:[UIImage imageNamed:@"post_gray"] forState:UIControlStateNormal];
                        
                        
                        //  message = @"Your Listing has been successfully post";
                    }
                    
                    
                }        }
        }];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //[self fetchMyListing:page_no];
    
    if(alertView.tag == 10){
        
        if(buttonIndex==1){
            
            
            [deleteConn startConnectionWithString:@"delete_listing" HttpMethodType:Post_Type HttpBodyType:delParam Output:^(NSDictionary *receivedData){
                
                if ([deleteConn responseCode] == 1) {
                    
                    NSLog(@"%@",receivedData);
                    
                    tapAction = YES;
                    
                    page_no = 1;
                    
                    [self fetchMyListing:page_no];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Your listing has been deleted successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
            }];
            
        }
        
    } else {
        
        if (buttonIndex == 0) {
            
            UIStoryboard *storyboard = self.storyboard;
            
            addWhatson = [storyboard instantiateViewControllerWithIdentifier:@"addWhatsOnVC"];
            
            addWhatson.post_Dict = postDict;
            
            addWhatson.listPost = YES;
            
            [self.navigationController pushViewController:addWhatson animated:YES];
            
        }
    }
    
}

-(void)filterWith{
    
    if(filter_tag == 0){
        
        UIActionSheet *filterActionSheet = [[ UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Posted",@"Unposted",@"Expired", nil];
        
        filterActionSheet.backgroundColor = [UIColor grayColor];
        
        filterActionSheet.tag = 4;
        
        [filterActionSheet showInView:self.view];
        
    } else if (filter_tag ==1) {
        
        [self showListData:listNameArr allowMultipleSelection:NO selectedData:[@"" componentsSeparatedByString:@", "] title:@"List Name"];
        
    } else if (filter_tag == 2){
        
        UIActionSheet *filterActionSheet = [[ UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Course",@"Lesson",@"Event", nil];
        
        filterActionSheet.backgroundColor = [UIColor grayColor];
        
        filterActionSheet.tag = 3;
        
        [filterActionSheet showInView:self.view];
        
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
    
    listingArray = [[NSMutableArray alloc] init];
    
    [listingArray addObject:[mainArr objectAtIndex:index]];
    
    NSMutableArray *cat = [[NSMutableArray alloc] init];
    
    [cat addObject:[maimCatArr objectAtIndex:index]];
    
    categoryArray = [cat mutableCopy];
    
    cat = [[NSMutableArray alloc] init];
    
    [cat addObject:[mainSubArr objectAtIndex:index]];
    
    subCatArr = [cat mutableCopy];
    
    nameSelected = YES;
    
    [self setTblFrame];
    
    reset_btn.hidden = NO;
    
    
    
    [listing_table reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)tap_filterBtn:(id)sender {
    
    nameSelected = NO;
    
    UIActionSheet *filterActionSheet = [[ UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Post Status",@"Listing Name",@"Type", nil];
    
    filterActionSheet.backgroundColor = [UIColor grayColor];
    
    filterActionSheet.tag = 30;
    
    [filterActionSheet showInView:self.view];
}

- (IBAction)tapAddBtn:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Course", @"Lesson", @"Event", nil];
    
    actionSheet.tag = 1;
    
    [actionSheet showInView:self.view];
}

- (IBAction)tap_resetBtn:(id)sender {
    
    nameSelected = NO;
    
    tap_filter = NO;
    
    //filter_type = @"3";
    
    CGRect frame =listing_table.frame;
    
    frame.origin.y = tblOrigion;
    
    listing_table.frame = frame;
    
    frame = listing_table.frame;
    
    frame.size.height = self.view.frame.size.height - listing_table.frame.origin.y - 54;
    
    
    listing_table.frame = frame;
    
    
    reset_btn.hidden = YES;
    
    page_no = 1;
    
    [self fetchMyListing:page_no];
    
    
}

-(void)setTblFrame{
    
    CGRect frame =listing_table.frame;
    
    frame.origin.y = tblOrigion+reset_btn.frame.size.height+20;
    
    listing_table.frame = frame;
    
    frame = listing_table.frame;
    
    frame.size.height = self.view.frame.size.height - listing_table.frame.origin.y - 54;
    
    listing_table.frame = frame;
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag==30){
        
        filter_tag = buttonIndex;
        
        [self filterWith];
        
        
    } else  if (actionSheet.tag == 3) {
        
        
        if (buttonIndex == 0) {
            
            tapTag =1;
            
            // listingArray = [courseArray mutableCopy];
            
            // categoryArray = [courseCatArray mutableCopy];
            
            // subCatArr = [courseSubCatArr mutableCopy];
            
            // [listing_table reloadData];
            
            tap_filter = YES;
            
            filter_type = @"1";
            
            page_no = 1;
            
            [self fetchMyListing:page_no];
            
        }
        else if (buttonIndex == 1) {
            
            tapTag =2;
            
            // listingArray = [lessonArray mutableCopy];
            
            // categoryArray = [lessonCatArray mutableCopy];
            
            // subCatArr = [lessonSubCatArr mutableCopy];
            
            //[listing_table reloadData];
            
            tap_filter = YES;
            
            filter_type = @"3";
            
            page_no = 1;
            
            [self fetchMyListing:page_no];
            
        }
        else if (buttonIndex == 2) {
            
            tapTag =3;
            
            // listingArray = [eventArray mutableCopy];
            
            // categoryArray = [eventCatArray mutableCopy];
            
            // subCatArr = [eventSubCatArr mutableCopy];
            
            //[listing_table reloadData];
            
            tap_filter = YES;
            
            filter_type = @"2";
            
            page_no = 1;
            
            [self fetchMyListing:page_no];
            
        }
        else if (buttonIndex == 3) {
            
            //tapTag =4;
            
            //page_no = 1;
            
            //[self fetchMyListing:page_no];
        }
    } else if(actionSheet.tag == 4){
        
        
        if (buttonIndex == 0) {
            
            [self setTblFrame];
            
            reset_btn.hidden = NO;
            
            tapTag =1;
            
            listingArray = [postListArr mutableCopy];
            
            categoryArray = [postCatArr mutableCopy];
            
            subCatArr = [postSubCatArr mutableCopy];
            
            page_no = totalPage;
            
            [listing_table reloadData];
        }
        else if (buttonIndex == 1) {
            
            [self setTblFrame];
            
            reset_btn.hidden = NO;
            
            page_no = totalPage;
            
            tapTag =2;
            
            listingArray = [unPostListArr mutableCopy];
            
            categoryArray = [unPostCatArr mutableCopy];
            
            subCatArr = [unPostSubCatArr mutableCopy];
            
            [listing_table reloadData];
        }
        else if (buttonIndex == 2) {
            
            [self setTblFrame];
            
            reset_btn.hidden = NO;
            
            page_no = totalPage;
            
            tapTag =3;
            
            listingArray = [expiredListArr mutableCopy];
            
            categoryArray = [expCatArr mutableCopy];
            
            subCatArr = [expSubCatArr mutableCopy];
            
            [listing_table reloadData];
        }
        
    }
    
    else if (actionSheet.tag == 1) {
        
        
        if (buttonIndex == 0) {
            
            [self performSegueWithIdentifier:@"editCourseSegue" sender:self];
            
        } else if (buttonIndex == 1) {
            
            [self performSegueWithIdentifier:@"addLessionSegue" sender:self];
            
        } else if (buttonIndex == 2) {
            
            [self performSegueWithIdentifier:@"addEvent" sender:self];
        }
        
    } else {
        
        if (actionSheet.tag != 3){
            
            NSString *img_url;
            
            listing = [[listingArray objectAtIndex:indexNumber] valueForKey:@"model"] ;
            
            
            if ([listing isEqualToString:@"CourseListing"]) {
                
                listing = @"CourseListing";
                
                type_name = @"course_name";
                
                URLStr = @"course_description";
                
                img_url = CourseImageURL;
                
            } else if ([listing isEqualToString:@"LessonListing"]){
                
                listing = @"LessonListing";
                
                type_name = @"lesson_name";
                
                URLStr = @"lesson_description";
                
                img_url = LessonImageURL;
                
            }  else if ([listing isEqualToString:@"EventListing"]){
                
                listing = @"EventListing";
                type_name = @"event_name";
                URLStr = @"event_description";
                img_url = EventImageURL;
                
            }
            
            NSString *course_id = [[listingArray objectAtIndex:indexNumber] valueForKey: listing] ;
            
            NSLog(@"Course Tap Id %@", course_id);
            
            name = [[[listingArray objectAtIndex:indexNumber] valueForKey:listing]valueForKey:type_name];
            
            discription =[[[listingArray objectAtIndex:indexNumber] valueForKey:listing]valueForKey:URLStr];
            
            imgUrl = [img_url stringByAppendingString:[[[listingArray objectAtIndex:indexNumber] valueForKey:listing] valueForKey:@"picture0"]];
            
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
                
                sendMsgView.subject.text = name;
                
                sendMsgView.message.text = discription;
                
                sendMsgView.to_btn.hidden = YES;
                
                //        sendMsgView.to_textField.text = [[[whatsOnArray objectAtIndex:actionSheet.tag]valueForKey:@"Member"]valueForKey:@"email"];
                
                [self.view addSubview:sendMsgView];
                
            }
        }
        
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    
    //    if(actionSheet.tag==30){
    //
    //        filter_tag = buttonIndex;
    //
    //        [self filterWith];
    //
    //
    //    } else  if (actionSheet.tag == 3) {
    //
    //
    //        if (buttonIndex == 0) {
    //
    //            tapTag =1;
    //
    //           // listingArray = [courseArray mutableCopy];
    //
    //           // categoryArray = [courseCatArray mutableCopy];
    //
    //           // subCatArr = [courseSubCatArr mutableCopy];
    //
    //           // [listing_table reloadData];
    //
    //            tap_filter = YES;
    //
    //            filter_type = @"1";
    //
    //            page_no = 1;
    //
    //            [self fetchMyListing:page_no];
    //
    //        }
    //        else if (buttonIndex == 1) {
    //
    //            tapTag =2;
    //
    //           // listingArray = [lessonArray mutableCopy];
    //
    //           // categoryArray = [lessonCatArray mutableCopy];
    //
    //           // subCatArr = [lessonSubCatArr mutableCopy];
    //
    //            //[listing_table reloadData];
    //
    //            tap_filter = YES;
    //
    //            filter_type = @"3";
    //
    //            page_no = 1;
    //
    //            [self fetchMyListing:page_no];
    //
    //        }
    //        else if (buttonIndex == 2) {
    //
    //            tapTag =3;
    //
    //           // listingArray = [eventArray mutableCopy];
    //
    //           // categoryArray = [eventCatArray mutableCopy];
    //
    //           // subCatArr = [eventSubCatArr mutableCopy];
    //
    //            //[listing_table reloadData];
    //
    //            tap_filter = YES;
    //
    //            filter_type = @"2";
    //
    //            page_no = 1;
    //
    //            [self fetchMyListing:page_no];
    //
    //        }
    //        else if (buttonIndex == 3) {
    //
    //            //tapTag =4;
    //
    //            //page_no = 1;
    //
    //            //[self fetchMyListing:page_no];
    //        }
    //    } else if(actionSheet.tag == 4){
    //
    //
    //        if (buttonIndex == 0) {
    //
    //            [self setTblFrame];
    //
    //            reset_btn.hidden = NO;
    //
    //            tapTag =1;
    //
    //            listingArray = [postListArr mutableCopy];
    //
    //            categoryArray = [postCatArr mutableCopy];
    //
    //            subCatArr = [postSubCatArr mutableCopy];
    //
    //            page_no = totalPage;
    //
    //            [listing_table reloadData];
    //        }
    //        else if (buttonIndex == 1) {
    //
    //            [self setTblFrame];
    //
    //            reset_btn.hidden = NO;
    //
    //             page_no = totalPage;
    //
    //            tapTag =2;
    //
    //            listingArray = [unPostListArr mutableCopy];
    //
    //            categoryArray = [unPostCatArr mutableCopy];
    //
    //            subCatArr = [unPostSubCatArr mutableCopy];
    //
    //            [listing_table reloadData];
    //        }
    //        else if (buttonIndex == 2) {
    //
    //            [self setTblFrame];
    //
    //            reset_btn.hidden = NO;
    //
    //             page_no = totalPage;
    //
    //            tapTag =3;
    //
    //            listingArray = [expiredListArr mutableCopy];
    //
    //            categoryArray = [expCatArr mutableCopy];
    //
    //            subCatArr = [expSubCatArr mutableCopy];
    //
    //            [listing_table reloadData];
    //        }
    //
    //    }
    //
    //    else if (actionSheet.tag == 1) {
    //
    //
    //        if (buttonIndex == 0) {
    //
    //            [self performSegueWithIdentifier:@"editCourseSegue" sender:self];
    //
    //        } else if (buttonIndex == 1) {
    //
    //            [self performSegueWithIdentifier:@"addLessionSegue" sender:self];
    //
    //        } else if (buttonIndex == 2) {
    //
    //            [self performSegueWithIdentifier:@"addEvent" sender:self];
    //        }
    //
    //    } else {
    //
    //        if (actionSheet.tag != 3){
    //
    //            NSString *img_url;
    //
    //            listing = [[listingArray objectAtIndex:indexNumber] valueForKey:@"model"] ;
    //
    //
    //            if ([listing isEqualToString:@"CourseListing"]) {
    //
    //                listing = @"CourseListing";
    //
    //                type_name = @"course_name";
    //
    //                URLStr = @"course_description";
    //
    //                img_url = CourseImageURL;
    //
    //            } else if ([listing isEqualToString:@"LessonListing"]){
    //
    //                listing = @"LessonListing";
    //
    //                type_name = @"lesson_name";
    //
    //                URLStr = @"lesson_description";
    //
    //                img_url = LessonImageURL;
    //
    //            }  else if ([listing isEqualToString:@"EventListing"]){
    //
    //                listing = @"EventListing";
    //                type_name = @"event_name";
    //                URLStr = @"event_description";
    //                img_url = EventImageURL;
    //
    //            }
    //
    //            NSString *course_id = [[listingArray objectAtIndex:indexNumber] valueForKey: listing] ;
    //
    //            NSLog(@"Course Tap Id %@", course_id);
    //
    //            name = [[[listingArray objectAtIndex:indexNumber] valueForKey:listing]valueForKey:type_name];
    //
    //            discription =[[[listingArray objectAtIndex:indexNumber] valueForKey:listing]valueForKey:URLStr];
    //
    //            imgUrl = [img_url stringByAppendingString:[[[listingArray objectAtIndex:indexNumber] valueForKey:listing] valueForKey:@"picture0"]];
    //
    //            NSLog(@"image %@",imgUrl);
    //
    //            comment =[name stringByAppendingString:@"\n"];
    //
    //            comment = [comment stringByAppendingString:discription];
    //
    //            comment = [comment stringByAppendingString:@" "];
    //
    //
    //            if (buttonIndex == 0) {
    //
    //                paramDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                             @"I just posted a post on ECAhub", @"name",
    //                             comment, @"caption",
    //                             @"", @"description",
    //                             @"http://mercury.promaticstechnologies.com/ecaHub/", @"link",
    //                             imgUrl, @"picture",
    //                             nil];
    //                NSLog(@"%@", paramDict);
    //
    //                [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:paramDict
    //                                                          handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
    //
    //                                                              if (error) {
    //
    //                                                                  NSLog(@"Error publishing story: %@", error.description);
    //
    //                                                              } else {
    //
    //                                                                  if (result == FBWebDialogResultDialogNotCompleted) {
    //
    //                                                                      NSLog(@"User cancelled.");
    //
    //                                                                  } else {
    //
    //                                                                      NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
    //
    //                                                                      if (![urlParams valueForKey:@"post_id"]) {
    //
    //                                                                          NSLog(@"User cancelled.");
    //
    //                                                                      } else {
    //
    //                                                                          NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
    //
    //                                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Shared successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //
    //                                                                          [alert show];
    //
    //                                                                          NSLog(@"result %@", result);
    //
    //                                                                      }
    //                                                                  }
    //                                                              }
    //                                                          }];
    //            }
    //            else if (buttonIndex == 1){
    //
    //
    //                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    //                {
    //                    SLComposeViewController *tweetSheet = [SLComposeViewController
    //                                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    //
    //                    //   NewsFeedsCustomCell *cell = (NewsFeedsCustomCell *)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexNo inSection:0]];
    //
    //                    //  urlString = [urlString stringByAppendingString:[[arrayNewsFeeds[indexNo] valueForKey:@"Post"] valueForKey:@"website"]];
    //
    //                    [tweetSheet setInitialText:comment];
    //
    //                    [tweetSheet addURL:[NSURL URLWithString:@"http:/http://mercury.promaticstechnologies.com/ecaHub/"]];
    //
    //                    // [tweetSheet addImage:imageView.image];
    //
    //                    [tweetSheet addImage:[UIImage imageNamed:@"logo"]];
    //
    //                    [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
    //
    //                        switch (result) {
    //
    //                            case SLComposeViewControllerResultCancelled:
    //
    //                                NSLog(@"Post Canceled");
    //                                break;
    //
    //                            case SLComposeViewControllerResultDone:
    //                            {
    //
    //                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Shared successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //
    //                                [alert show];
    //
    //                                NSLog(@"Post Sucessful");
    //
    //                            }
    //                                break;
    //
    //                            default:
    //                                break;
    //                        }
    //                    }];
    //
    //                    [self presentViewController:tweetSheet animated:YES completion:nil];
    //
    //                } else {
    //
    //                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Twitter Accounts" message:@"There are no Twitter accounts configured.You can add or create a Twitter  account in Settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //
    //                    [alert show];
    //                }
    //
    //
    //
    //            }
    //            else if (buttonIndex == 2){
    //
    //                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"linkinShare"];
    //
    //                NSString *launchUrl = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=78imindwbpf3mg&redirect_uri=http%3A%2F%2Fmercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect&state=ecaHub987654321&scope=r_fullprofile%20r_emailaddress%20w_share";
    //
    //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:launchUrl]];
    //
    //                NSDictionary *dict = @{@"title":name, @"description": discription, @"img_url":imgUrl};
    //
    //                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"linkedInShareData"];
    //
    //            }
    //
    //
    //            else if (buttonIndex == 3){
    //
    //                NSData *Imgdata =  UIImageJPEGRepresentation(cell.image_view.image, 7);
    //
    //                MFMailComposeViewController * mail = [[MFMailComposeViewController alloc] init];
    //
    //                [mail addAttachmentData:Imgdata mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"photo.jpg"]];
    //
    //                NSString *msgBody = comment;
    //
    //                mail.mailComposeDelegate = self;
    //
    //                NSString *link = @"www.ECAhub.com";
    //
    //                link = [@"\n\n" stringByAppendingString:link];
    //
    //                msgBody = [msgBody stringByAppendingString:link];
    //
    //                NSLog(@"%@",msgBody);
    //
    //                [mail setMessageBody:msgBody isHTML:YES];
    //
    //                //        NSArray *to_recipients = [NSArray arrayWithObject:[[[whatsOnArray objectAtIndex:actionSheet.tag]valueForKey:@"Member"]valueForKey:@"email"]];
    //                //
    //                //        NSLog(@"%@",to_recipients);
    //                //
    //                //        [mail setToRecipients:to_recipients];
    //
    //                [mail setSubject:@"Check out this post that I post on ECAhub"];
    //
    //                [self presentViewController:mail animated:YES completion:nil];
    //
    //
    //            }
    //            else if (buttonIndex == 4){
    //
    //                sendMsgView = [[SendMessageView alloc] init];
    //
    //                UIStoryboard *storyboard;
    //
    //                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //
    //                    storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
    //
    //                    sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPad" owner:self options:nil] objectAtIndex:0];
    //
    //                } else {
    //
    //                    storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
    //
    //                    sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPhone" owner:self options:nil] objectAtIndex:0];
    //                }
    //
    //                sendMsgView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+80);
    //
    //                sendMsgView.frame = self.view.frame;
    //
    //                sendMsgView.view_frame = self.view.frame;
    //
    //                sendMsgView.subject.text = name;
    //
    //                sendMsgView.message.text = discription;
    //
    //                sendMsgView.to_btn.hidden = YES;
    //
    //                //        sendMsgView.to_textField.text = [[[whatsOnArray objectAtIndex:actionSheet.tag]valueForKey:@"Member"]valueForKey:@"email"];
    //
    //                [self.view addSubview:sendMsgView];
    //
    //            }
    //        }
    //
    //    }
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

-(void)filterMyListing{
    
    NSInteger a = [listingArray count];
    
    courseArray = [[NSMutableArray alloc]init];
    
    lessonArray = [[NSMutableArray alloc]init];
    
    eventArray = [[NSMutableArray alloc]init];
    
    courseCatArray = [[NSMutableArray alloc]init];
    
    lessonCatArray = [[NSMutableArray alloc]init];
    
    eventCatArray = [[NSMutableArray alloc]init];
    
    courseSubCatArr = [[NSMutableArray alloc]init];
    
    lessonSubCatArr = [[NSMutableArray alloc]init];
    
    eventSubCatArr = [[NSMutableArray alloc]init];
    
    postListArr = [[NSMutableArray alloc]init];
    
    unPostListArr = [[NSMutableArray alloc]init];
    
    expiredListArr = [[NSMutableArray alloc]init];
    
    postCatArr = [[NSMutableArray alloc]init];
    
    unPostCatArr = [[NSMutableArray alloc]init];
    
    expCatArr = [[NSMutableArray alloc]init];
    
    postSubCatArr = [[NSMutableArray alloc]init];
    
    unPostSubCatArr = [[NSMutableArray alloc]init];
    
    expSubCatArr = [[NSMutableArray alloc]init];
    
    listNameArr = [[NSMutableArray alloc] init];
    
    NSString *status;
    
    for (int i=0 ; i< a; i++) {
        
        NSString *listing1 = [[listingArray objectAtIndex:i] valueForKey:@"model"] ;
        
        if ([listing1 isEqualToString:@"CourseListing"]) {
            
            [courseArray addObject:[listingArray objectAtIndex:i]];
            
            [courseCatArray addObject:[categoryArray objectAtIndex:i]];
            
            [courseSubCatArr addObject:[subCatArr objectAtIndex:i]];
            
            status = [[[listingArray objectAtIndex:i] valueForKey:@"CourseListing"] valueForKey:@"course_status"];
            
            //[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:type_name]
            
            name = [[[listingArray objectAtIndex:i] valueForKey:@"CourseListing"] valueForKey:@"course_name"];
            
            [listNameArr addObject:name];
        }
        
        else if ([listing1 isEqualToString:@"LessonListing"]) {
            
            
            [lessonArray addObject:[listingArray objectAtIndex:i]];
            
            [lessonCatArray addObject:[categoryArray objectAtIndex:i]];
            
            [lessonSubCatArr addObject:[subCatArr objectAtIndex:i]];
            
            status = [[[listingArray objectAtIndex:i] valueForKey:@"LessonListing"] valueForKey:@"lesson_status"];
            
            name = [[[listingArray objectAtIndex:i] valueForKey:@"LessonListing"] valueForKey:@"lesson_name"];
            
            [listNameArr addObject:name];
        }
        
        else if ([listing1 isEqualToString:@"EventListing"]) {
            
            [eventArray addObject:[listingArray objectAtIndex:i]];
            
            [eventCatArray addObject:[categoryArray objectAtIndex:i]];
            
            [eventSubCatArr addObject:[subCatArr objectAtIndex:i]];
            
            status = [[[listingArray objectAtIndex:i] valueForKey:@"EventListing"] valueForKey:@"event_status"];
            
            name = [[[listingArray objectAtIndex:i] valueForKey:@"EventListing"] valueForKey:@"event_name"];
            
            [listNameArr addObject:name];
        }
        
        if([status isEqualToString:@"0"]){
            
            [unPostListArr addObject:[listingArray objectAtIndex:i]];
            
            [unPostCatArr addObject:[categoryArray objectAtIndex:i]];
            
            [unPostSubCatArr addObject:[subCatArr objectAtIndex:i]];
            
        } else if ([status isEqualToString:@"1"]){
            
            [postListArr addObject:[listingArray objectAtIndex:i]];
            
            [postCatArr addObject:[categoryArray objectAtIndex:i]];
            
            [postSubCatArr addObject:[subCatArr objectAtIndex:i]];
            
            
        } else if ([status isEqualToString:@"2"]){
            
            [expiredListArr addObject:[listingArray objectAtIndex:i]];
            
            [expCatArr addObject:[categoryArray objectAtIndex:i]];
            
            [expSubCatArr addObject:[subCatArr objectAtIndex:i]];
            
        }
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(lastContentOffset > scrollView.contentOffset.y){
        
        isScrollUp = NO;
        
    }else{
        
        isScrollUp = YES;
    }
    
    lastContentOffset = scrollView.contentOffset.y;
}

@end