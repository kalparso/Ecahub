//
//  MyfavoritesViewController.m
//  ecaHUB
//
//  Created by promatics on 4/10/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "MyfavoritesViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "myFavTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MyfavoritesViewController () {
    
    WebServiceConnection *myFavConnection,*pinTOFavConnection, *suggConn;
    
    Indicator *indicator;
    
    myFavTableViewCell *myFavCell;
    
    NSMutableArray *myFavArray, *cat_namesArray, *subcat_namesArray;
    
    NSMutableArray *FAVarray;
    
    NSString *type_name, *listing,*fav,*member_id,*list_id,*type_str;
    
    NSMutableArray *courseArray, *lessonArray, *eventArray ,*courseCatArray, *lessionCatArray, *eventCatArray;
    
    UIActionSheet *filterSheet;
    
    CGFloat lastContentOffset;
    
    BOOL isScrollUp;
    
    BOOL isServiceCall,isNextPage,isLodin;
    
    BOOL tapSuggFabPin;
    
    int page_no, tapTag;
    
    int totalPage;
    
    UIRefreshControl *refreshcontrol;
}
@end

@implementation MyfavoritesViewController

@synthesize myFavTable, no_record,fav_lbl,filterBtn,isSuggestion,infoView,info_speech_batBtn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    fav_lbl.hidden = YES;
    
    tapTag = 0;
    
    isLodin = YES;
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    refreshcontrol = [[UIRefreshControl alloc]init];
    
    refreshcontrol.attributedTitle = [[NSAttributedString alloc]initWithString:@"please wait"];
    
    [refreshcontrol addTarget:self action:@selector(tap_refresh:) forControlEvents:UIControlEventValueChanged];
    
    [myFavTable addSubview:refreshcontrol];
    
    self.navigationItem.rightBarButtonItem = filterBtn;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    myFavTable.backgroundColor = [UIColor clearColor];
    
    myFavConnection = [WebServiceConnection connectionManager];
    
    pinTOFavConnection = [WebServiceConnection connectionManager];
    
    suggConn = [WebServiceConnection connectionManager];
    
    FAVarray = [[NSMutableArray alloc]init];
    
    myFavArray= [[NSMutableArray alloc]init];
    
    cat_namesArray = [[NSMutableArray alloc]init];
    
    subcat_namesArray = [[NSMutableArray alloc]init];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    no_record.hidden = YES;
    
    page_no = 1;
    
    if (isSuggestion == YES) {
        
        self.title = @"Suggestions";
        
        [self fetchMySugg:page_no];
    }
    
    else{
        
        self.title = @"My Favorites";
        
        self.navigationItem.rightBarButtonItems = @[filterBtn,info_speech_batBtn];
        
        [self fetchMyFavs:page_no];
    }
    
    
    
}

-(void)tap_refresh:(UIButton *)sender{
    
    [refreshcontrol endRefreshing];
    
    //myFavTable.userInteractionEnabled = NO;
    
    FAVarray = [[NSMutableArray alloc]init];
    
    myFavArray= [[NSMutableArray alloc]init];
    
    cat_namesArray = [[NSMutableArray alloc]init];
    
    subcat_namesArray = [[NSMutableArray alloc]init];

    [self fetchMyFavs:1];
    
    
  
}

-(void)viewWillAppear:(BOOL)animated{
    
    fav_lbl.hidden = YES;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"refresh"]isEqualToString:@"1"]) {
        
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"refresh"];
    
        tapTag = 0;
        
        isLodin = YES;
        
        //self.navigationController.navigationBar.topItem.title = @"";
        
        self.navigationItem.rightBarButtonItem = filterBtn;
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        myFavTable.backgroundColor = [UIColor clearColor];
        
        myFavConnection = [WebServiceConnection connectionManager];
        
        pinTOFavConnection = [WebServiceConnection connectionManager];
        
        suggConn = [WebServiceConnection connectionManager];
        
        FAVarray = [[NSMutableArray alloc]init];
        
        myFavArray= [[NSMutableArray alloc]init];
        
        cat_namesArray = [[NSMutableArray alloc]init];
        
        subcat_namesArray = [[NSMutableArray alloc]init];
        
        indicator = [[Indicator alloc] initWithFrame:self.view.frame];
        
        no_record.hidden = YES;
        
        page_no = 1;
        
        if (isSuggestion == YES) {
            
            self.title = @"Suggestions";
            
            [self fetchMySugg:page_no];
        }
        
        else{
            
            self.title = @"My Favorites";
            
            [self fetchMyFavs:page_no];
        }
       
    }

}
-(void)fetchMyFavs:(int)current_page {
    
    CGRect frame = myFavTable.frame;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        frame.origin.y = 67;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        frame.origin.y = infoView.frame.origin.y;
        
    }
    
    frame.size.height = self.view.frame.size.height-100;
    
    myFavTable.frame = frame;
    
    FAVarray = [[NSMutableArray alloc]init];
    
    NSString *memberId =[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    [self.view addSubview:indicator];
    
    frame = fav_lbl.frame;
    
    frame.size.width = self.view.frame.size.width - frame.origin.x - 10;
    
    fav_lbl.frame = frame;
    
    NSDictionary *urlParam = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    NSString *service =[@"favorite/page:" stringByAppendingString:[NSString stringWithFormat:@"%d",current_page]];
    
    [myFavConnection startConnectionWithString:service HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([myFavConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                if(page_no==1){
                    
                    myFavArray= [[NSMutableArray alloc]init];
                    
                    cat_namesArray = [[NSMutableArray alloc]init];
                    
                    subcat_namesArray = [[NSMutableArray alloc]init];
                }
                
                NSArray *dataArray1 = [receivedData valueForKey:@"array_final"];
                
                [myFavArray addObjectsFromArray:dataArray1];
                
                NSArray *dataArray2 = [receivedData valueForKey:@"cat_names"];
                
                [cat_namesArray addObjectsFromArray:dataArray2];
                
                NSArray *dataArray3 = [receivedData valueForKey:@"subcat_names"];
                
                [subcat_namesArray addObjectsFromArray:dataArray3];
                
                totalPage = [[receivedData valueForKey:@"total_page"] integerValue];
                
                [self filterMyFavs];
                
                member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
                
                [myFavTable reloadData];
                
               // [myFavTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                
            } else {
                
                [self filterMyFavs];
                
                no_record.hidden = NO;
                
                fav_lbl.hidden = YES;
                
                myFavTable.hidden = YES;
                
                page_no = page_no - 1;
            }
        }
    }];
}

-(void)fetchMySugg:(int)current_page {
    
    FAVarray = [[NSMutableArray alloc]init];
    
    if(tapSuggFabPin){
        
        FAVarray = [[NSMutableArray alloc]init];
        
        myFavArray= [[NSMutableArray alloc]init];
        
        cat_namesArray = [[NSMutableArray alloc]init];
        
        subcat_namesArray = [[NSMutableArray alloc]init];
        
        indicator = [[Indicator alloc] initWithFrame:self.view.frame];
        
        page_no = 1;
        
        tapSuggFabPin = NO;
    }
    
    NSString *memberId = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    [self.view addSubview:indicator];
    
    //    CGRect frame = fav_lbl.frame;
    //
    //    frame.size.width = self.view.frame.size.width - frame.origin.x - 10;
    //
    //    fav_lbl.frame = frame;
    
    fav_lbl.hidden = YES;
    
    no_record.hidden = YES;
    
    CGRect frame = myFavTable.frame;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        frame.origin.y = 67;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        frame.origin.y = infoView.frame.origin.y;
        
    }
    
    frame.size.height = self.view.frame.size.height-100;
    
    myFavTable.frame = frame;
    
    NSDictionary *urlParam = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    NSString *service =[@"suggested_list/page:" stringByAppendingString:[NSString stringWithFormat:@"%d",current_page]];
    
    [suggConn startConnectionWithString:service HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([suggConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                NSArray *dataArray1 = [receivedData valueForKey:@"array_final_suggested"];
                
                [myFavArray addObjectsFromArray:dataArray1];
                
                NSArray *dataArray2 = [receivedData valueForKey:@"cat_name_suggested"];
                
                [cat_namesArray addObjectsFromArray:dataArray2];
                
                NSArray *dataArray3 = [receivedData valueForKey:@"subcat_name_suggested"];
                
                [subcat_namesArray addObjectsFromArray:dataArray3];
                
                // NSArray *favorite_info = [receivedData valueForKey:@"Favorite"];
                
                totalPage = [[receivedData valueForKey:@"total_pages"] integerValue];
                
                FAVarray = [[NSMutableArray alloc]init];
                
                BOOL isfav = NO;
                
                [FAVarray removeAllObjects];
                
                member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
                
                for (int j = 0; j< myFavArray.count; j++) {
                    
                    NSArray *favorite_info = [[myFavArray objectAtIndex:j] valueForKey:@"Favorite"];
                    
                    isfav = NO;
                    
                    for (int i = 0; i< favorite_info.count; i++) {
                        
                        //NSArray *favoriteArray = [[favorite_info objectAtIndex:i] valueForKey:@"Favorite"];
                        
                        //if ([memberid isEqualToString:[favoriteArray valueForKey:@"member_id"]])
                        
                        NSString *memberid = [[favorite_info objectAtIndex:i] valueForKey:@"member_id"];
                        
                        if([member_id isEqualToString:memberid]) {
                            
                            [myFavCell.pinToFav_btn setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                            
                            isfav =YES;
                            
                            break;
                            
                        } else{
                            
                            isfav = NO;
                        }
                    }
                    
                    if (isfav) {
                        
                        [FAVarray addObject:@"YES"];
                        
                    } else{
                        
                        [FAVarray addObject:@"NO"];
                    }
                    
                }
                
                NSLog(@"FAVarray %@",FAVarray);
                
                [self filterMyFavs];
                
                member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
                
                [myFavTable reloadData];
                
            } else {
                
                no_record.hidden = NO;
                
                fav_lbl.hidden = YES;
                
                myFavTable.hidden = YES;
                
                page_no = page_no - 1;
            }
        }
    }];
}

#pragma mark - UITableView Delegates & Datasourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [myFavArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  myFavCell.favTile_view.frame.origin.y + myFavCell.favTile_view.frame.size.height+5;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    myFavCell = [tableView dequeueReusableCellWithIdentifier:@"myFavCell" forIndexPath:indexPath];
    
    myFavCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (myFavCell == nil) {
        
        myFavCell = [[myFavTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myFavCell"];
    }
    
    if (myFavArray.count == 0 ||subcat_namesArray.count == 0 ||cat_namesArray.count == 0) {
        
        return myFavCell;
    
    }
    
    else{
    
    UIStoryboard *storyboard;
    
    CGFloat x;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        myFavCell.status_btn.layer.cornerRadius = 15.0f;
        
        // myFavCell.image_view.frame = CGRectMake(10, 5, self.myFavTable.frame.size.width - 20, 279);
        
        x= 20.0f;
        
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        myFavCell.status_btn.layer.cornerRadius = 13.0f;
        
        // myFavCell.image_view.frame = CGRectMake(10, 5, self.myFavTable.frame.size.width - 20, 161);
        
        x = 10.0f;
    }
    
    // NSString *type_city = [type stringByAppendingString:@" | "];
    
    // myFavCell.type_cityLbl.text = [type_city stringByAppendingString:[NSString stringWithFormat:@"%@",[[[[myFavArray objectAtIndex:indexPath.row] valueForKey:listing]valueForKey:location] valueForKey:@"city_name"]]];
    
    //   NSLog(@"%@", [type_city stringByAppendingString:[NSString stringWithFormat:@"%@",[[[[favArray objectAtIndex:indexPath.row] valueForKey:listing]valueForKey:location] valueForKey:@"city_name"]]]);
    
    //         NSString *categoriesStr = [[[favArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"category_id"];
    //
    //        NSArray *cat_id = [categoriesStr componentsSeparatedByString:@","];
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    NSMutableArray *subcategories = [[NSMutableArray alloc] init];
    
    for (int i =0 ; i<[[cat_namesArray objectAtIndex:indexPath.row] count]; i++) {
        
        //[categories addObject:[[categoryArray objectAtIndex:indexPath.row] valueForKey:[cat_id objectAtIndex:i]]];
        
        [categories addObject:[[[[cat_namesArray objectAtIndex:indexPath.row]objectAtIndex:i] valueForKey:@"Category"]valueForKey:@"category_name"]];
        
        // [categories addObject:[[[[categoryArray objectAtIndex:indexPath.row] objectAtIndex:i] valueForKey:@"Category"] valueForKey:@"category_name"]];
    }
    
    for (int i =0 ; i<[[subcat_namesArray objectAtIndex:indexPath.row] count]; i++) {
        
        //[categories addObject:[[categoryArray objectAtIndex:indexPath.row] valueForKey:[cat_id objectAtIndex:i]]];
        
        [subcategories addObject:[[[[subcat_namesArray objectAtIndex:indexPath.row]objectAtIndex:i] valueForKey:@"Subcategory"]valueForKey:@"subcategory_name"]];
        
        // [categories addObject:[[[[categoryArray objectAtIndex:indexPath.row] objectAtIndex:i] valueForKey:@"Category"] valueForKey:@"category_name"]];
    }
    
    myFavCell.categoryLbl.text = [[[categories componentsJoinedByString:@", "]stringByAppendingString:@", "]stringByAppendingString:[subcategories componentsJoinedByString:@", "]];
    
    myFavCell.status_btn.hidden = YES;
    
    //    CGRect frame = myFavCell.favTile_view.frame;
    //
    //    frame.origin.x = x;
    //
    //    frame.size.width = myFavCell.frame.size.width - 2*x;
    //    myFavCell.favTile_view.frame = frame;
    
    
    
    //    frame = myFavCell.description_txtView.frame;
    //
    //    frame.size.width =myFavCell.favTile_view.frame.size.width - 10;
    //
    //    myFavCell.description_txtView.frame = frame;
    
    listing = [[myFavArray objectAtIndex:indexPath.row] valueForKey:@"model"];
    
    NSString *status_type, *url, *descriptionStr, *type, *location;
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        type_name = @"course_name";
        status_type = @"course_status";
        descriptionStr = @"course_description";
        type = @"Course";
        location = @"course_city";
        url = CourseImageURL;
        
    } else if ([listing isEqualToString:@"LessonListing"]) {
        
        listing = @"LessonListing";
        type_name = @"lesson_name";
        status_type = @"lesson_status";
        descriptionStr = @"lesson_description";
        location = @"lesson_city";
        type = @"Lesson";
        url = LessonImageURL;
        
    } else if ([listing isEqualToString:@"EventListing"]) {
        
        listing = @"EventListing";
        type_name = @"event_name";
        status_type = @"event_status";
        descriptionStr = @"event_description";
        location = @"event_city";
        type = @"Event";
        url = EventImageURL;
    }
    
    if (isSuggestion == YES) {
        
        if ([@"YES" isEqualToString:[FAVarray objectAtIndex:indexPath.row]]) {
            
            [myFavCell.pinToFav_btn setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
            
        } else {
            
            [myFavCell.pinToFav_btn setBackgroundImage:[UIImage imageNamed:@"favPin_gray"] forState:UIControlStateNormal];
        }
        
    }
    
    NSString *type_city = [type stringByAppendingString:@" | "];
    
    if (isSuggestion == YES) {
        
        myFavCell.type_cityLbl.text = [type_city stringByAppendingString:[NSString stringWithFormat:@"%@",[[[myFavArray objectAtIndex:indexPath.row]valueForKey:location] valueForKey:@"city_name"]]];
        
        myFavCell.praise_count.text = [[[myFavArray objectAtIndex:indexPath.row]valueForKey:@"BusinessProfile"] valueForKey:@"praise_count"];
        
    }
    
    else{
        
        myFavCell.type_cityLbl.text = [type_city stringByAppendingString:[NSString stringWithFormat:@"%@",[[[[myFavArray objectAtIndex:indexPath.row] valueForKey:listing]valueForKey:location] valueForKey:@"city_name"]]];
        
        
        myFavCell.praise_count.text = [[[myFavArray objectAtIndex:indexPath.row] valueForKey:listing]valueForKey:@"praise_count"];
        
    }
    
    myFavCell.listing_name.text = [[[[myFavArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:type_name]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (isSuggestion == YES) {
        
        myFavCell.business_name.text = [[[[myFavArray objectAtIndex:indexPath.row]valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    }
    
    else{
        
        myFavCell.business_name.text = [[[[[myFavArray objectAtIndex:indexPath.row] valueForKey:listing]valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
    }
    
    myFavCell.description_txtView.text = [[[myFavArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:descriptionStr];
    
    myFavCell.description_txtView.textContainer.maximumNumberOfLines = 3;
    
    myFavCell.description_txtView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [myFavCell.description_txtView sizeToFit];
    
    NSString *imageURL = [[[myFavArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"picture0"];
    
    for (int i = 1; i<4; i++) {
        
        NSString *pic = [NSString stringWithFormat:@"picture%d",i];
        
        if ([imageURL length] < 1) {
            
            imageURL = [[[myFavArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:pic];
        }
    }
    
    imageURL = [imageURL stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceCharacterSet]];
    
    myFavCell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
    
    if ([imageURL length] < 1) {
        
        //Listing_Image
        myFavCell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
        
    } else {
        
        imageURL = [url stringByAppendingString:imageURL];
        
        [myFavCell.image_view sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Listing_Image"]];
    }
    
    NSString *status = [[[myFavArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:status_type];
    
    if ([status isEqualToString:@"0"]||[status isEqualToString:@""]) {
        
        [myFavCell.status_btn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
    }
    else{
        
        [myFavCell.status_btn setBackgroundImage:[UIImage imageNamed:@"Check_Mark"] forState:UIControlStateNormal];
    }
    
    CGRect frame1 = myFavCell.listing_name.frame;
    
    frame1.size.height = [self heightCalculate:myFavCell.listing_name.text :myFavCell.listing_name];
    
    myFavCell.listing_name.frame = frame1;
    
    frame1 = myFavCell.business_name.frame;
    
    frame1.origin.y = myFavCell.listing_name.frame.origin.y + myFavCell.listing_name.frame.size.height +5;
    
    frame1.size.height = [self heightCalculate:myFavCell.business_name.text :myFavCell.business_name];
    
    myFavCell.business_name.frame = frame1;
    
    frame1 = myFavCell.categoryLbl.frame;
    
    frame1.origin.y = myFavCell.business_name.frame.origin.y + myFavCell.business_name.frame.size.height +5;
    
    frame1.size.height = [self heightCalculate:myFavCell.categoryLbl.text :myFavCell.categoryLbl];
    
    myFavCell.categoryLbl.frame = frame1;
    
    frame1 = myFavCell.type_cityLbl.frame;
    
    frame1.origin.y = myFavCell.categoryLbl.frame.origin.y+ myFavCell.categoryLbl.frame.size.height+5;
    
    frame1.size.height = [self heightCalculate:myFavCell.type_cityLbl.text :myFavCell.type_cityLbl];
    
    myFavCell.type_cityLbl.frame = frame1;
    
    frame1 = myFavCell.praise_count.frame;
    
    frame1.origin.y = myFavCell.categoryLbl.frame.origin.y+ myFavCell.categoryLbl.frame.size.height+5;
    
    myFavCell.praise_count.frame = frame1;
    
    frame1 = myFavCell.praiseIconBtn.frame;
    
    frame1.origin.y = myFavCell.categoryLbl.frame.origin.y+ myFavCell.categoryLbl.frame.size.height+5;
    
    myFavCell.praiseIconBtn.frame = frame1;
    
    frame1 = myFavCell.sub_view.frame;
    
    frame1.size.height = myFavCell.type_cityLbl.frame.origin.y + myFavCell.type_cityLbl.frame.size.height+5;
    
    myFavCell.sub_view.frame = frame1;
    
    frame1 = myFavCell.favTile_view.frame;
    
    frame1.size.height = myFavCell.sub_view.frame.origin.y + myFavCell.sub_view.frame.size.height+5;
    
    frame1.origin.x = x;
    
    frame1.size.width = myFavCell.frame.size.width - 2*x;
    
    myFavCell.favTile_view.frame = frame1;
    
    CGRect frame = myFavCell.image_view.frame;
    frame.size.width = myFavCell.favTile_view.frame.size.width;
    myFavCell.image_view.frame = frame;
    
    [myFavCell.pinToFav_btn addTarget:self action:@selector(tapFavBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    myFavCell.pinToFav_btn.tag = indexPath.row;
    
    frame = myFavCell.status_btn.frame;
    
    frame.origin.x = myFavCell.image_view.frame.size.width - myFavCell.image_view.frame.origin.x-frame.size.width-20;
    frame.origin.y = myFavCell.image_view.frame.size.height -frame.size.height/2;
    
    myFavCell.status_btn.frame = frame;
    
    return myFavCell;
        
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // if(isServiceCall){
    
    if( (indexPath.row >= (int)(myFavArray.count - 5)) && (isScrollUp)){
        
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    listing = [[myFavArray objectAtIndex:indexPath.row] valueForKey:@"model"];
    
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
    
    NSString *course_id = [[[myFavArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"id"];
    
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

-(void)loadNextPage{
    
    page_no = page_no + 1;
    
    if (isSuggestion == YES) {
        
        [self fetchMySugg:page_no];
    }
    
    else{
        
        [self fetchMyFavs:page_no];
    }
    
    isLodin = NO;
    
    isNextPage = NO;
    
}

-(void)tapFavBtn:(UIButton *)sender{
    
    if (isSuggestion == YES) {
        
        [self.view addSubview:indicator];
        
        NSString *course_id;
        
        NSString *msg_no;
        
        listing = [[myFavArray objectAtIndex:sender.tag] valueForKey:@"model"] ;
        
        if ([listing isEqualToString:@"CourseListing"]) {
            
            listing = @"CourseListing";
            
            course_id = [[[myFavArray objectAtIndex:sender.tag] valueForKey: @"CourseListing"] valueForKey:@"id"];
            
            type_str = @"1";
            
            
        } else if ([listing isEqualToString:@"LessonListing"]) {
            
            
            course_id = [[[myFavArray objectAtIndex:sender.tag] valueForKey: @"LessonListing"] valueForKey:@"id"];
            
            listing = @"LessonListing";
            
            type_str = @"3";
            
            
        } else if ([listing isEqualToString:@"EventListing"]) {
            
            course_id = [[[myFavArray objectAtIndex:sender.tag] valueForKey: @"EventListing"] valueForKey:@"id"];
            
            listing = @"EventListing";
            
            type_str = @"2";
            
        }
        NSDictionary *paramURL;
        
        NSString *msg;
        
        if ([[FAVarray objectAtIndex:sender.tag] isEqualToString:@"YES"]) {
            
            paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":course_id, @"type":type_str, @"un_fav":@"1"};
            
            msg_no = @"1";
            
            msg = @"You have successfully unpinned this listing from your Favorites.";
            
            
        } else {
            
            paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":course_id, @"type":type_str};
            
            msg_no = @"2";
            
            msg = @"You have successfully pinned this listing to your Favorites.";
        }
        
        [pinTOFavConnection startConnectionWithString:@"add_favorite" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if([pinTOFavConnection responseCode] == 1) {
                
                NSLog(@"%@",receivedData);
                
                if(![[receivedData valueForKey:@"code"] integerValue] == 0) {
                    
                    if([msg_no isEqualToString:@"1"]) {
                        
                        [sender setBackgroundImage:[UIImage imageNamed:@"favPin_gray"] forState:UIControlStateNormal];
                        
                    } else {
                        
                        [sender setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                        
                        
                    }
                    
                    tapSuggFabPin = YES;
                    
                    
                    [self fetchMySugg:page_no];
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
            }
        }];
        
    }
    
    else{
        
        [self.view addSubview:indicator];
        
        listing = [[myFavArray objectAtIndex:sender.tag] valueForKey:@"model"];
        
        if ([listing isEqualToString:@"CourseListing"]) {
            
            listing = @"CourseListing";
            
            list_id = [[[myFavArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"id"];
            
            type_str = @"1";
            
            
        } else if ([listing isEqualToString:@"LessonListing"]) {
            
            
            list_id = [[[myFavArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"id"];
            
            listing = @"LessonListing";
            
            type_str = @"3";
            
            
        } else if ([listing isEqualToString:@"EventListing"]) {
            
            list_id = [[[myFavArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"id"];
            
            listing = @"EventListing";
            
            type_str = @"2";
            
        }
        NSDictionary *paramURL;
        
        NSString *msg;
        
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":list_id, @"type":type_str, @"un_fav":@"1"};
        
        msg = @"You have successfully unpinned this listing from your Favorites.";
        
        [pinTOFavConnection startConnectionWithString:@"add_favorite" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if([pinTOFavConnection responseCode] == 1) {
                
                NSLog(@"%@",receivedData);
                
                if([[receivedData valueForKey:@"code"] integerValue] == 1) {
                    
                    isLodin = YES;
                    
                    myFavArray= [[NSMutableArray alloc]init];
                    
                    cat_namesArray = [[NSMutableArray alloc]init];
                    
                    subcat_namesArray = [[NSMutableArray alloc]init];
                    
                    //[myFavCell.pinToFav_btn setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                    
                    [self fetchMyFavs:1];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
            }
        }];
    }
}


//-(void)tapFavBtn:(UIButton *)sender{
//
//    [self.view addSubview:indicator];
//
//    listing = [[myFavArray objectAtIndex:sender.tag] valueForKey:@"model"];
//
//    if ([listing isEqualToString:@"CourseListing"]) {
//
//        listing = @"CourseListing";
//
//        list_id = [[[myFavArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"id"];
//
//        type_str = @"1";
//
//
//    } else if ([listing isEqualToString:@"LessonListing"]) {
//
//
//        list_id = [[[myFavArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"id"];
//
//        listing = @"LessonListing";
//
//        type_str = @"3";
//
//
//    } else if ([listing isEqualToString:@"EventListing"]) {
//
//        list_id = [[[myFavArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"id"];
//
//        listing = @"EventListing";
//
//        type_str = @"2";
//
//    }
//
//    NSDictionary *paramURL;
//
//    NSString *msg;
//
//    paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":list_id, @"type":type_str, @"un_fav":@"1"};
//
//    msg = @"You have successfully unpinned this listing from your Favorites.";
//
//    [pinTOFavConnection startConnectionWithString:@"add_favorite" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
//
//        [indicator removeFromSuperview];
//
//        if([pinTOFavConnection responseCode] == 1) {
//
//            NSLog(@"%@",receivedData);
//
//            if([[receivedData valueForKey:@"code"] integerValue] == 1) {
//
//                isLodin = YES;
//
//               // [self fetchMyFavs:(int)];
//
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//
//                [alert show];
//            }
//        }
//    }];
//}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString indexPath:(NSIndexPath *)indexPath {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            myFavCell = (myFavTableViewCell *)[self.myFavTable cellForRowAtIndexPath:indexPath];
            
            myFavCell.image_view.image = image;
        }
    }];
}

//-(void)textViewDidChange:(UITextView *)textView
//{
//    NSUInteger maxNumberOfLines = 3;
//    NSUInteger numLines = textView.contentSize.height/textView.font.lineHeight;
//    if (numLines > maxNumberOfLines)
//    {
//        textView.text = [textView.text substringToIndex:textView.text.length - 1];
//    }
//}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)tap_FilterBtn:(id)sender {
    
    filterSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Course",@"Lesson",@"Event",@"All", nil];
    
    filterSheet.tag =1;
    
    [filterSheet showInView:self.view];
    
    
}

- (IBAction)tap_info_speech_batBtn:(id)sender {
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Listings that you have pinned are here. If there are some that are missing, it's because they are no longer valid or have expired." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertview show];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (filterSheet.tag ==1)
    {
        
        if (buttonIndex == 0)
        {
            myFavArray = [courseArray copy];
            
            [myFavTable reloadData];
            
        }
        else if (buttonIndex == 1){
            
            myFavArray = [lessonArray copy];
            [myFavTable reloadData];
            
        }
        else if (buttonIndex ==2){
            
            myFavArray = [eventArray copy];
            
            [myFavTable reloadData];
            
        }
        else if (buttonIndex ==3){
            
            if (isSuggestion == YES) {
                
                page_no = 1;
                
                [self fetchMySugg:page_no];
            }
            
            else{
                
                page_no = 1;
                
                [self fetchMyFavs:page_no];
            }
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

-(CGFloat)heightCalculate:(NSString *)calculateText :(UILabel *)lbl{
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(lbl.frame.size.width - (1.0f * 2), FLT_MAX);
    
    UIFont *font;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        font = [UIFont systemFontOfSize:20];
        
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
    
    return (height_lbl);
}


-(void)filterMyFavs{
    
    courseArray = [[NSMutableArray alloc]init];
    lessonArray = [[NSMutableArray alloc]init];
    eventArray = [[NSMutableArray alloc]init];
    courseCatArray = [[NSMutableArray alloc]init];
    lessionCatArray = [[NSMutableArray alloc]init];
    eventCatArray = [[NSMutableArray alloc]init];
    
    for (int i =0; i<[myFavArray count]; i++) {
        
        if ([[[myFavArray objectAtIndex:i]valueForKey:@"model"]isEqual:@"CourseListing"]) {
            
            [courseArray addObject:[myFavArray objectAtIndex:i]];
            
        }
        
        else if ([[[myFavArray objectAtIndex:i]valueForKey:@"model"]isEqual:@"LessonListing"]){
            
            [lessonArray addObject:[myFavArray objectAtIndex:i]];
        }
        
        else if ([[[myFavArray objectAtIndex:i]valueForKey:@"model"]isEqual:@"eventListing"]){
            
            [eventArray addObject:[myFavArray objectAtIndex:i]];
            
        }
        
        
    }
}


@end
