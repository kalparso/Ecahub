//
//  OtherListingViewController.m
//  ecaHUB
//
//  Created by promatics on 9/18/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "OtherListingViewController.h"
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


@interface OtherListingViewController () {
    
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
    
    NSArray *listingArray, *cousreDetailArray;
    
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
}
@end

@implementation OtherListingViewController

@synthesize listing_table,addBtn,filter_btn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    tapTag = 0;
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    self.title = @"My Listings";
    
   // self.navigationItem.rightBarButtonItems = @[addBtn,filter_btn];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Hotmail"];
    
    myListingConn = [WebServiceConnection connectionManager];
    
    getCourseConn = [WebServiceConnection connectionManager];
    
    postConnection= [WebServiceConnection connectionManager];
    
    deleteConn = [WebServiceConnection connectionManager];
    
    
    indicator= [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    [self fetchMyListing];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Gmail"];
    
    
}

-(void) fetchMyListing {
    
    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [self.view addSubview:indicator];
    
    [myListingConn startConnectionWithString:[NSString stringWithFormat:@"other_listing"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([myListingConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"You have not yet addedd any Listing to ECAhub. Create a Listing now by clicking the '+' sign above.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            } else {
                
                listingArray = [receivedData valueForKey:@"other_posted_listing"];
                
                // NSArray *array = [[receivedData valueForKey:@"posted_courses"]valueForKey:@"CourseListing"];
                
                categoryArray = [receivedData valueForKey:@"category_names"];
                
                [self filterMyListing];
                
                [listing_table reloadData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self fetchMyListing];
}

#pragma mark - UITable View Delegates & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return listingArray.count;
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
    
    CGRect frame = cell.cat_name.frame;
    
    frame.size.width = cell.main_view.frame.size.width - frame.origin.x - 10;
    
    cell.cat_name.frame = frame;
    
    frame = cell.business_name.frame;
    frame.size.width = cell.main_view.frame.size.width - frame.origin.x - 10;
    
    cell.business_name.frame = frame;
    
    frame = cell.listing_name.frame;
    
    frame.size.width = cell.main_view.frame.size.width - frame.origin.x - 10;
    
    cell.listing_name.frame = frame;
    
    NSString *type, *location;
    
    listing = [[listingArray objectAtIndex:indexPath.row] valueForKey:@"model"] ;
    
   // listing = @"CourseListing";
    
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
    
    cell.listing_name.text = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:type_name];
    
    cell.business_name.text = [[[listingArray objectAtIndex:indexPath.row] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
    
    cell.button_view.layer.borderWidth = 1.0f;
    
    cell.button_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    cell.button_view.layer.masksToBounds = YES;
    
    NSString *categoriesStr = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"category_id"];
    
    NSArray *cat_id = [categoriesStr componentsSeparatedByString:@","];
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    for (int i =0 ; i< cat_id.count; i++) {
        
        //  [categories addObject:[[categoryArray objectAtIndex:indexPath.row] valueForKey:[cat_id objectAtIndex:i]]];
        
      //  [categories addObject:[[[[categoryArray objectAtIndex:indexPath.row] objectAtIndex:i] valueForKey:@"Category"] valueForKey:@"category_name"]];
    }
    
    cell.cat_name.text = [categories componentsJoinedByString:@", "];
    
    NSString *date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"post_date"];
    
    cell.post_date.text = [dateConversion convertDate:date];
    
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
    
    cell.view_bttn.tag = indexPath.row;
    
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
        
        cell.postDate_lbl.text = @"Create Date  :";
        
        NSString *date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"created_at"];
        
        cell.post_date.text = [dateConversion convertDate:date];
        
        cell.expired.hidden =  YES;
        
        cell.expiry_lbl.hidden = YES;
        
    }else if ([status isEqualToString:@"1"]){
        
        [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"Check_Mark"] forState:UIControlStateNormal];
        
        [cell.post_bttn setBackgroundImage:[UIImage imageNamed:@"post_gray"] forState:UIControlStateNormal];
        
        cell.expired.hidden = NO;
        
        [cell.post_bttn setUserInteractionEnabled:YES];
        
        cell.expiry_lbl.hidden = NO;
        
        cell.postDate_lbl.text = @"Post Date  :";
        
        NSString *date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"post_date"];
        
        cell.post_date.text = [dateConversion convertDate:date];
        
        
        date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"expiry_date"];
        
        if([date isEqualToString:@""] || !date){
            
            date = @"0000-00-00 00:00";
            
        }
        
        cell.expired.text = [dateConversion convertDate:date];
        
    } else if ([status isEqualToString:@"2"]){
        
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
        
        cell.post_date.text = [dateConversion convertDate:date];
        
        date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"expiry_date"];
        
        if([date isEqualToString:@""] || !date) {
            
            date = @"0000-00-00 00:00";
        }
    }
    return cell;
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
        
        NSDictionary *paramUrl = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"listing_id":listId,@"listing_type":type};
        
        [deleteConn startConnectionWithString:@"delete_listing" HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary *receivedData){
            if ([deleteConn responseCode] == 1) {
                
                NSLog(@"%@",receivedData);
                
                [self fetchMyListing];
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Your listing has been deleted successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }];
        //member_id,listing_id,listing_type (1=>course,2 =>event, 3=> Lesson)
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    listing = [[listingArray objectAtIndex:indexPath.row] valueForKey:@"model"] ;
    
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
    
    cell.business_name.text = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"name_educator"];
    
    
    NSDictionary *paramUrl = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"listing_id":listId,@"listing_type":type};
    
    [deleteConn startConnectionWithString:@"delete_listing" HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary *receivedData){
        if ([deleteConn responseCode] == 1) {
            
            NSLog(@"%@",receivedData);
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Your listing has been deleted successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            [self fetchMyListing];
            
        }
        
    }];
    
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
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Review" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
    
}


-(void)tapPostBtn:(UIButton *)sender{
    
    NSString *status, *listId ,*type;
    listing = [[listingArray objectAtIndex:sender.tag] valueForKey:@"model"] ;
    
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        type_name = @"course_name";
        URLStr = @"course_view";
        status = @"course_status";
        listId = @"id";
        type = @"1";
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        listing = @"LessonListing";
        type_name = @"lession_name";
        URLStr = @"lesson_view";
        status = @"lesson_status";
        type = @"3";
        
    }  else if ([listing isEqualToString:@"EventListing"]){
        
        listing = @"EventListing";
        type_name = @"event_name";
        URLStr = @"event_view";
        status = @"event_status";
        type = @"2";
        
    }
    NSString *statuss = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:status];
    
    listId = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:@"id"];
    
    NSString *message;
    
    if ([statuss isEqualToString:@"1"]) {
        
        statuss = @"0";
        
        message = @"Your Listing has been successfully unpost";
        
    } else if ([statuss isEqualToString:@"0"]) {
        
        statuss = @"1";
        
        message = @"Your Listing has just been posted successfully. You can now broadcast this Listing on “What’s On!” for FREE.";
    }
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":listId,@"type":type,@"status":statuss};
    
    [postConnection startConnectionWithString:@"post_list" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([postConnection responseCode] ==1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                
                NSString *statuss = [[[listingArray objectAtIndex:sender.tag] valueForKey:listing] valueForKey:status];
                
                if ([statuss isEqualToString:@"1"]) {
                    
                    statuss = @"0";
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [selectedButton setBackgroundImage:[UIImage imageNamed:@"upload_gray"] forState:UIControlStateNormal];
                    
                    [self fetchMyListing];
                    
                    [alert show];
                    
                    // message = @"Your Listing has been successfully unpost";
                    
                } else if ([statuss isEqualToString:@"0"]) {
                    
                    statuss = @"1";
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    [selectedButton setBackgroundImage:[UIImage imageNamed:@"post_gray"] forState:UIControlStateNormal];
                    
                    
                    //  message = @"Your Listing has been successfully post";
                }
                
                
                
            }        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self fetchMyListing];
    
    if (buttonIndex == 0) {
        
        UIStoryboard *storyboard = self.storyboard;
        
        addWhatson = [storyboard instantiateViewControllerWithIdentifier:@"addWhatsOnVC"];
        
        [self.navigationController pushViewController:addWhatson animated:YES];
        
    }
    
}

- (IBAction)tap_filterBtn:(id)sender {
    
    UIActionSheet *filterActionSheet = [[ UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Course",@"Lesson",@"Event",@"All", nil];
    
    filterActionSheet.backgroundColor = [UIColor grayColor];
    
    filterActionSheet.tag = 3;
    
    [filterActionSheet showInView:self.view];
}

- (IBAction)tapAddBtn:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Course", @"Lesson", @"Event", nil];
    
    actionSheet.tag = 1;
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 3) {
        
        if (buttonIndex == 0) {
            
            tapTag =1;
            
            listingArray = [courseArray copy];
            
            categoryArray = [courseCatArray copy];
            
            [listing_table reloadData];
        }
        else if (buttonIndex == 1) {
            
            tapTag =2;
            
            listingArray = [lessonArray copy];
            
            categoryArray = [lessonCatArray copy];
            
            [listing_table reloadData];
        }
        else if (buttonIndex == 2) {
            
            tapTag =3;
            
            listingArray = [eventArray copy];
            
            categoryArray = [eventCatArray copy];
            
            [listing_table reloadData];
        }
        else if (buttonIndex == 3) {
            
            tapTag =4;
            
            
            [self fetchMyListing];
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
    
    for (int i=0 ; i< a; i++) {
        
        NSString *listing1 = [[listingArray objectAtIndex:i] valueForKey:@"model"] ;
        
        if ([listing1 isEqualToString:@"CourseListing"]) {
            
            
            [courseArray addObject:[listingArray objectAtIndex:i]];
            
            [courseCatArray addObject:[categoryArray objectAtIndex:i]];
        }
        
        else if ([listing1 isEqualToString:@"LessonListing"]) {
            
            
            [lessonArray addObject:[listingArray objectAtIndex:i]];
            
            [lessonCatArray addObject:[categoryArray objectAtIndex:i]];
        }
        
        else if ([listing1 isEqualToString:@"EventListing"]) {
            
            [eventArray addObject:[listingArray objectAtIndex:i]];
            
            [eventCatArray addObject:[categoryArray objectAtIndex:i]];
        }
        
    }
}

- (void)registerForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    float kbHeight = 0.0;
    
    if (kbSize.width > kbSize.height) {
        
        kbHeight = kbSize.height;
        
    } else {
        
        kbHeight = kbSize.width;
    }
    
    NSLog(@"%f", self.view.frame.origin.x);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(67, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        //[scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1600)];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        //[scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1200)];
    }
    
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
}




@end


