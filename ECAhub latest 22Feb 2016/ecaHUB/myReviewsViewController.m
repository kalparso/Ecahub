//
//  myReviewsViewController.m
//  ecaHUB
//
//  Created by promatics on 4/15/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "myReviewsViewController.h"
#import "MyReviewsTableViewCell.h"
#import "TextReviewTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "giveReview.h"
#import "CourseDetailViewController.h"
#import "EventViewController.h"
#import "LessionDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface myReviewsViewController () {
    
    WebServiceConnection *myListingConn ,*giveReviewConn,*praiseConn;
    
    Indicator *indicator;
    
    MyReviewsTableViewCell *cell;
    
    TextReviewTableViewCell *textReviewCell;
    
    CourseDetailViewController *courseView;
    
    LessionDetailViewController *lessonView;
    
    EventViewController *EventView;
    
    NSArray *listingArray;
    
    NSArray *reviewArray;
    
    DateConversion *dateConversion;
    
    NSString *listing, *type_name ,*reviewText;
    
    giveReview *give_Review;
}
@end

@implementation myReviewsViewController

@synthesize tble_view,emptyreview_lbl;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//
//    return self;
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    myListingConn = [WebServiceConnection connectionManager];
    
    praiseConn = [WebServiceConnection connectionManager];
    
    giveReviewConn = [WebServiceConnection connectionManager];
    
    indicator= [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchMyListing) name:@"ReviewNotification" object:nil];
    
    emptyreview_lbl.hidden = YES;
    
    //[self fetchMyListing];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self fetchMyListing];
}

-(void) fetchMyListing {
    
    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [self.view addSubview:indicator];
    
    [myListingConn startConnectionWithString:[NSString stringWithFormat:@"review_given_on"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([myListingConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 0) {
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"You have not yet posted any Reviews. Once you have made a purchase from an Educator, you will be invited to submit a Review." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                tble_view.hidden = YES;
                emptyreview_lbl.hidden = NO;
                
                               
              //  [alert show];
                
            } else {
                
                listingArray = [receivedData valueForKey:@"array_final"];
                
                reviewArray = [receivedData valueForKey:@"All reviews"];
                
                [tble_view reloadData];
            }
        }
    }];
}

#pragma mark- Height Calculate

-(CGFloat)heightCalculate:(NSString *)calculateText{
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(self.tble_view.frame.size.width - (1.0f * 2), FLT_MAX);
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    [calculateText_lbl setFrame:CGRectMake(10, 74, 300 ,size.height+5)];
    
    [calculateText_lbl sizeToFit];
    
    CGFloat height_lbl = size.height;
    
    NSLog(@"%f",height_lbl +10);
    
    return (height_lbl);
}

#pragma mark - UITable View Delegates & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return listingArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height, comnt_view;
    
    listing = [[listingArray objectAtIndex:indexPath.row] valueForKey:@"model"];
    
   // NSLog(@"%@",listing);
    
    NSString *status_type;
    
    NSString *url;
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        type_name = @"course_name";
        status_type = @"course_status";
        url = @"http://mercury.promaticstechnologies.com/ecaHub//img/courses_images/";
        
    } else if ([listing isEqualToString:@"LessonListing"]) {
        
        listing = @"LessonListing";
        type_name = @"lesson_name";
        status_type = @"lession_status";
        url = @"http://mercury.promaticstechnologies.com/ecaHub/img/lessons_images/";
        
    } else if ([listing isEqualToString:@"EventListing"]) {
        
        listing = @"EventListing";
        type_name = @"event_name";
        status_type = @"event_status";
        url = @"http://mercury.promaticstechnologies.com/ecaHub/img/events_images/";
    }
    
    NSArray *review = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"Review"];
    
  //  NSLog(@"%lu", review.count);
    
    if (review.count > 0) {
        
        NSString *review_text = [[[[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"Review"] objectAtIndex:0] valueForKey:@"content"];
        
        CGFloat height1 = [self heightCalculate:review_text];
        
        UIStoryboard *storyboard;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            height = height1 + 80 + 370;
            
            comnt_view = 134;
            
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            height = height1 + 60 + 270;
            comnt_view = 117;
        }
    }
    else{
        
        UIStoryboard *storyboard;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            height = 510;
            
            comnt_view = 134;
            
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            height = 321;
            
            comnt_view = 117;
            
        }
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *review;
    
    listing = [[listingArray objectAtIndex:indexPath.row] valueForKey:@"model"];
    
    NSLog(@"%@",listing);
    
    cell.shareBtn.hidden = YES;
    cell.shareIt_Img.hidden = YES;
    
    NSString *status_type;
    
    NSString *url;
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        type_name = @"course_name";
        status_type = @"course_status";
        url = @"http://mercury.promaticstechnologies.com/ecaHub//img/courses_images/";
        
    } else if ([listing isEqualToString:@"LessonListing"]) {
        
        listing = @"LessonListing";
        type_name = @"lesson_name";
        status_type = @"lession_status";
        url = @"http://mercury.promaticstechnologies.com/ecaHub/img/lessons_images/";
        
    } else if ([listing isEqualToString:@"EventListing"]) {
        
        listing = @"EventListing";
        type_name = @"event_name";
        status_type = @"event_status";
        url = @"http://mercury.promaticstechnologies.com/ecaHub/img/events_images/";
    }
    
    review = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"Review"];
    
    //  NSLog(@"%@", review);
    
    if (review.count > 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyReviewCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (cell == nil) {
            
            cell = [[MyReviewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyReviewCell"];
        }
        
        UIStoryboard *storyboard;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            cell.check_Btn.layer.cornerRadius = 15.0f;
            
            cell.image_view.frame = CGRectMake(0, 5, cell.list_view.frame.size.width, 158);
            
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            cell.check_Btn.layer.cornerRadius = 13.0f;
            
            cell.image_view.frame = CGRectMake(0, 5, cell.list_view.frame.size.width, 100);
        }
        
        CGRect frame = cell.cat_name.frame;
        
        frame.size.width = cell.list_view.frame.size.width - frame.origin.x - 20;
        
        cell.cat_name.frame = frame;
        
        cell.comment_view.hidden = NO;
        
        frame = cell.list_view.frame;
        
        frame.origin.y = cell.comment_view.frame.origin.y + cell.comment_view.frame.size.height +5;
        
        cell.list_view.frame = frame;
        
        cell.listing_name.text = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:type_name];
        
        cell.business_name.text = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"name_educator"];
        
        NSString *date =  [[[[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"Review"] objectAtIndex:0] valueForKey:@"created_at"];
        
        if ([date isEqualToString:@""]) {
            
            date = @"0000-000-00";
        }
        
        // NSLog(@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] );
        
        cell.comment_date.text = [dateConversion convertDate:date];
        
        CGFloat h = [self heightCalculate:[[[[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"Review"] objectAtIndex:0] valueForKey:@"content"]];
        
        CGRect frame1 = cell.comment.frame;
        frame1.size.height = h;
        cell.comment.frame = frame1;
        
        frame1 = cell.comment_view.frame;
        frame1.size.height = h +60;
        cell.comment_view.frame = frame1;
        
        frame1 = cell.list_view.frame;
        frame1.origin.y = cell.comment_view.frame.size.height + cell.comment_view.frame.origin.y +20;
        cell.list_view.frame = frame1;
        
        [cell.comment setLineBreakMode:NSLineBreakByClipping];
        
        [cell.comment setNumberOfLines:0];
        
        [cell.comment setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        cell.comment.text = [[[[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"Review"] objectAtIndex:0] valueForKey:@"content"];
        //54
        cell.user_name.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"];
        
        NSString *img_user = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"picture"];
        
        cell.user_img.layer.cornerRadius = cell.user_img.frame.size.width/2;
        
        cell.user_img.layer.masksToBounds = YES;
        
        if ([img_user isEqualToString:@""]) {
            
            cell.user_img.image = [UIImage imageNamed:@"user_img"];
            
        } else {
            
            img_user = [profilePicURL stringByAppendingString:img_user];
            
            [cell.user_img sd_setImageWithURL:[NSURL URLWithString:img_user] placeholderImage:[UIImage imageNamed:@"user_img"]];
        }
        
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
        
        if ([imageURL length] < 1) {
            
            //Listing_Image
            cell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
            
        } else {
            
            imageURL = [url stringByAppendingString:imageURL];
            
            [cell.image_view sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Listing_Image"]];
        }
        
        NSString *status = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:status_type];
        
        if ([status isEqualToString:@"0"]) {
            
            [cell.check_Btn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        }
        
        cell.giveReviewBtn.layer.cornerRadius = 5.0f;
        
        cell.shareBtn.hidden = YES;
        cell.shareIt_Img.hidden = YES;
        
        cell.praiseItBtn.layer.cornerRadius = 5.0f;
        
        cell.shareBtn.layer.cornerRadius = 5.0f;
        
        [cell.giveReviewBtn addTarget:self action:@selector(giveReview:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.giveReviewBtn.tag = indexPath.row;
        
        //        for (int i =0; i < review.count; i++) {
        //
        //            if ([mem_id isEqualToString:[review  valueForKey:@"member_id"]]) {
        //
        //
        //
        //                cell.comment.text = [review valueForKey:@"content"];
        //
        //                cell.comment_date.text = @"16 April 2015";
        //
        //                isReview = YES;
        //
        //                break;
        //            }
        //        }
        //*/
        
        
        [cell.praiseItBtn addTarget:self action:@selector(tapPraiseit:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.praiseItBtn.tag = indexPath.row;
        
        
        [cell.shareBtn addTarget:self action:@selector(tapShare:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.shareBtn.tag = indexPath.row;
        
        return cell;
        
    }  else {
        
        textReviewCell = [tableView dequeueReusableCellWithIdentifier:@"TextReviewCell" forIndexPath:indexPath];
        
        textReviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        textReviewCell.reviewText_view.layer.borderWidth = 1.0f;
        
        textReviewCell.reviewText_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        if (textReviewCell == nil){
            
            textReviewCell = [[TextReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextReviewCell"];
            
        }
        
        UIStoryboard *storyboard;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            textReviewCell.check_bttn.layer.cornerRadius = 15.0f;
            
            textReviewCell.ReviewImg_view.frame = CGRectMake(0, 5, textReviewCell.list_view.frame.size.width, 158);
            
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            textReviewCell.check_bttn.layer.cornerRadius = 13.0f;
            
            textReviewCell.ReviewImg_view.frame = CGRectMake(0, 5, textReviewCell.list_view.frame.size.width, 100);
        }
        
        CGRect frame = textReviewCell.category_lbl.frame;
        
        frame.size.width = textReviewCell.list_view.frame.size.width - frame.origin.x - 20;
        
        textReviewCell.category_lbl.frame = frame;
        
        //  listing = [[listingArray objectAtIndex:indexPath.row]  valueForKey:@"model"];
        
        NSString *status_type;
        
        NSString *url;
        
        if ([listing isEqualToString:@"CourseListing"]) {
            
            listing = @"CourseListing";
            type_name = @"course_name";
            status_type = @"course_status";
            url = @"http://mercury.promaticstechnologies.com/ecaHub//img/courses_images/";
            
        } else if ([listing isEqualToString:@"LessonListing"]) {
            
            listing = @"LessonListing";
            type_name = @"lesson_name";
            status_type = @"lession_status";
            url = @"http://mercury.promaticstechnologies.com/ecaHub/img/lessons_images/";
            
        } else if ([listing isEqualToString:@"EventListing"]) {
            
            listing = @"EventListing";
            type_name = @"event_name";
            status_type = @"event_status";
            url = @"http://mercury.promaticstechnologies.com/ecaHub/img/events_images/";
        }
        
        textReviewCell.listingname_lbl.text = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:type_name];
        
        //textReviewCell.listingname_lbl.text = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"name_educator"];
        
        
        cell.comment_view.hidden = NO;
        
        CGRect frame1 = cell.check_Btn.frame;
        frame1.origin.x = cell.frame.size.width - frame1.size.width - 25;
        cell.check_Btn.frame = frame1;
        
        frame1 = cell.check_Btn.frame;
        frame1.origin.y = cell.image_view.frame.size.height - frame1.size.height + 15;
        cell.check_Btn.frame = frame1;
        
        //NSString *praiseStr =
        
        [cell.praiseItBtn setTitle:@"Praise it" forState:UIControlStateNormal];

        
        //                    NSString *categoriesStr = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"category_id"];
        //
        //                    NSArray *cat_id = [categoriesStr componentsSeparatedByString:@","];
        //
        //                    NSMutableArray *categories = [[NSMutableArray alloc] init];
        
        textReviewCell.giveReview_bttn.layer.cornerRadius = 5.0f;
        
        textReviewCell.praiseIt_bttn.layer.cornerRadius = 5.0f;
        
        
        
        [textReviewCell.giveReview_bttn addTarget:self action:@selector(giveReview:) forControlEvents:UIControlEventTouchUpInside];
        
        textReviewCell.giveReview_bttn.tag = indexPath.row;
        
        
        //                    for (int i =0 ; i< cat_id.count; i++) {
        //
        //                        //  [categories addObject:[[categoryArray objectAtIndex:indexPath.row] valueForKey:[cat_id objectAtIndex:i]]];
        //
        //                        [categories addObject:[[[[reviewArray objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"Category"] valueForKey:@"category_name"]];
        //                    }
        
        // textReviewCell.category_lbl.text = [categories componentsJoinedByString:@", "];
        
        //  NSString *date =  [[[reviewArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"created_at"];
        
        //cell.post_date.text = [dateConversion convertDate:date];
        
        NSString *imageURL = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"picture0"];
        
        for (int i = 1; i<4; i++) {
            
            NSString *pic = [NSString stringWithFormat:@"picture%d",i];
            
            if ([imageURL length] < 1) {
                
                imageURL = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:pic];
            }
        }
        
        imageURL = [imageURL stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
        
        textReviewCell.ReviewImg_view.image = [UIImage imageNamed:@"Listing_Image"];
        
        if ([imageURL length] < 1) {
            
            //Listing_Image
            textReviewCell.ReviewImg_view.image = [UIImage imageNamed:@"Listing_Image"];
            
        } else {
            
            imageURL = [url stringByAppendingString:imageURL];
            
            [cell.image_view sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Listing_Image"]];
        }
        
        NSString *status = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:status_type];
        
        if ([status isEqualToString:@"0"]) {
            
            [textReviewCell.check_bttn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        }
        
        textReviewCell.giveReview_bttn.layer.cornerRadius = 5.0f;
        
        textReviewCell.praiseIt_bttn.layer.cornerRadius = 5.0f;
        
        //textReviewCell.shareBtn.layer.cornerRadius = 5.0f;
        
        [textReviewCell.giveReview_bttn addTarget:self action:@selector(giveReview:) forControlEvents:UIControlEventTouchUpInside];
        
        textReviewCell.giveReview_bttn.tag = indexPath.row;
        
        [textReviewCell.praiseIt_bttn addTarget:self action:@selector(tapPraiseit:) forControlEvents:UIControlEventTouchUpInside];
        
        textReviewCell.praiseIt_bttn.tag = indexPath.row;
        
        
        return textReviewCell;
    }
    
}


//    giveReview = [[[NSBundle mainBundle] loadNibNamed:@"giveReview" owner:self options:nil] objectAtIndex:0];
//
// give_Review.frame = self.view.frame;
//
//    CGRect frame = give_Review.reviewView.frame;
//
//    frame.origin.x = (self.view.frame.size.width - give_Review.reviewView.frame.size.width)/2;
//
//    give_Review.reviewView.frame = frame;
//
//give_Review.list_id = list_id;
//
//give_Review.type = typeStr;
//
// [self.view addSubview:give_Review];




//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(editingStyle==UITableViewCellEditingStyleDelete) {
//
//        NSLog(@"Tap Delete");
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     listing = [[listingArray objectAtIndex:indexPath.row] valueForKey:@"model"];
    
    NSString *course_id ;
    
   //
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        course_id = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"id"];
        
        [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
        
        UIStoryboard *storyboard = self.storyboard;
        
        courseView = [storyboard instantiateViewControllerWithIdentifier:@"courseDetail"];
        
        [self.navigationController pushViewController:courseView animated:YES];
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        course_id = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"id"];
        
        [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
        
        UIStoryboard *storyboard = self.storyboard;
        
        lessonView = [storyboard instantiateViewControllerWithIdentifier:@"lessionDetail"];
        
        [self.navigationController pushViewController:lessonView animated:YES];
        
    }else if ([listing isEqualToString:@"EventListing"]){
        
        course_id = [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"id"];
        
        [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
        
        UIStoryboard *storyboard = self.storyboard;
        
        EventView = [storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
        
        [self.navigationController pushViewController:EventView animated:YES];
        
    }
    
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString indexPath:(NSIndexPath *)indexPath forCell:(NSString *)tableCell forImage:(NSString *)cellImage {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            
            if ([tableCell isEqualToString:@"Review"]) {
                
                cell = (MyReviewsTableViewCell *)[self.tble_view cellForRowAtIndexPath:indexPath];
                
                if ([cellImage isEqualToString:@"User"]) {
                    
                    cell.user_img.image = image;
                    
                } else {
                    
                    cell.image_view.image = image;
                }
            } else {
                
                textReviewCell = (TextReviewTableViewCell *)[self.tble_view cellForRowAtIndexPath:indexPath];
                
                textReviewCell.ReviewImg_view.image = image;
            }
        }
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Write your Review here..."]) {
        
        textView.text = @"";
    }
    
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    reviewText = textView.text;
    
    
    reviewText = [reviewText stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if (reviewText.length == 0) {
        
        textView.text = @"Write your Review here...";
    }
    
    //reviewText = textView.text;
    
    if ([reviewText length]<70) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Please enter minimum 70 words" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}
-(void)tapPraiseit:(UIButton *)sender{
    
    NSString *typeStr = [[listingArray objectAtIndex:sender.tag] valueForKey:@"model"];
    
    NSString *list_id;
    
    if ([typeStr isEqualToString:@"CourseListing"]) {
        
        typeStr = @"1";
        
        type_name = @"course_name";
        
        list_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"id"];
        
    } else if ([typeStr isEqualToString:@"LessonListing"]) {
        
        typeStr = @"3";
        
        list_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"id"];
        
    } else if ([typeStr isEqualToString:@"EventListing"]) {
        
        typeStr = @"2";
        
        list_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"id"];
        
    }
    
    NSDictionary *dict = @{@"listing_id":list_id,@"listing_type":typeStr,@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [praiseConn startConnectionWithString:@"prize_it" HttpMethodType:Post_Type HttpBodyType:dict Output:^(NSDictionary * receiveddata){
        
        if ([praiseConn responseCode] == 1) {
            
            NSLog(@"%@",receiveddata);
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Prize successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }];
}

-(void)tapShare:(UIButton *)sender{
    
    
}

-(void)giveReview:(UIButton *)sender {
    
    NSString *typeStr = [[listingArray objectAtIndex:sender.tag] valueForKey:@"model"];
    
    NSString *list_id;
    
    [self.view endEditing:YES];
    
    if ([typeStr isEqualToString:@"CourseListing"]) {
        
        typeStr = @"1";
        
        type_name = @"course_name";
        
        list_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"id"];
        
    } else if ([typeStr isEqualToString:@"LessonListing"]) {
        
        typeStr = @"3";
        
        list_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"id"];
        
    } else if ([typeStr isEqualToString:@"EventListing"]) {
        
        typeStr = @"2";
        
        list_id = [[[listingArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"id"];
    }
    if ([reviewText length] < 70) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please enter minimum 70 words" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.view addSubview:indicator];
        
        //[tble_view reloadData];
        NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"content":reviewText, @"type":typeStr, @"list_id":list_id};
        
        [giveReviewConn startConnectionWithString:@"give_review" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
            
            [indicator removeFromSuperview];
            
            if ([giveReviewConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReviewNotification" object:nil];
                
                listingArray = @[];
                reviewArray = @[];
                
                [self fetchMyListing];
                
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
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
