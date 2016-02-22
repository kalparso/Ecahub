//
//  SearchViewController.m
//  ecaHUB
//
//  Created by promatics on 4/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "SearchViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "SearchTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface SearchViewController () {
    
    WebServiceConnection *searchConnection, *pinTOFavConnection,*mysearchprefVC;
    
    Indicator *indicator;
    
    SearchTableViewCell *cell;
    
    NSArray *listingArray;
    
    NSArray *categoryArray, *subcategoryArray;
    
    DateConversion *dateConversion;
    
    NSString *listing, *type_name, *type, *keyword,*member_id,*fav;
    
    BOOL search, isNewSearch, mySearch;
    
    NSMutableArray *FAVarray;
    
    CGFloat tbl_height;
    
    CGFloat heightcell;
    
    UIRefreshControl *refreshcontrol;
}
@end

@implementation SearchViewController

@synthesize searchTable, search_bar, select_typeBtn, advanceFilterView, advanceFilterBtn, mySeachPrefBtn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"Search";
    
    searchConnection = [WebServiceConnection connectionManager];
    
    mysearchprefVC = [WebServiceConnection connectionManager];
    
    pinTOFavConnection = [WebServiceConnection connectionManager];
    
    indicator= [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    FAVarray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    mySeachPrefBtn.layer.cornerRadius = 5.0f;
    
    advanceFilterBtn.layer.cornerRadius = 5.0f;
    
    advanceFilterView.hidden = YES;
    
    select_typeBtn.hidden = YES;
    
    tbl_height = searchTable.frame.size.height;
    
    type = @"4"; // For All By Default
    isNewSearch = YES;
    
    refreshcontrol = [[UIRefreshControl alloc]init];
    
    refreshcontrol.attributedTitle = [[NSAttributedString alloc]initWithString:@"Please wait..."];
    
    [refreshcontrol addTarget:self action:@selector(tap_refresh:) forControlEvents:UIControlEventValueChanged];
    
    [searchTable addSubview:refreshcontrol];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGRect frame = search_bar.frame;
        
        frame.size.height = 45.0f;
        
        search_bar.frame = frame;
        
        select_typeBtn.layer.cornerRadius = 22.5f;
        
        search_bar.layer.masksToBounds = YES;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        select_typeBtn.layer.cornerRadius = 16.0f;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(advanceSearchFilter:) name:@"AdvanceSearchFilter" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapcategoryBtn:) name:@"tapcategoryBtn" object:nil];
    
    keyword = @"keyword";
    
    [self searchCat];
    
    self.tabBarController.delegate = self;
    
}

//-(void)viewWillAppear:(BOOL)animated{
//
//    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"refresh"]isEqualToString:@"1"]) {
//
//        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"refresh"];
//
//        self.navigationItem.title = @"Search";
//
//        searchConnection = [WebServiceConnection connectionManager];
//
//        mysearchprefVC = [WebServiceConnection connectionManager];
//
//        pinTOFavConnection = [WebServiceConnection connectionManager];
//
//        indicator= [[Indicator alloc] initWithFrame:self.view.frame];
//
//        dateConversion = [DateConversion dateConversionManager];
//
//        FAVarray = [[NSMutableArray alloc]init];
//
//        self.view.backgroundColor = [UIColor whiteColor];
//
//        mySeachPrefBtn.layer.cornerRadius = 5.0f;
//
//        advanceFilterBtn.layer.cornerRadius = 5.0f;
//
//        advanceFilterView.hidden = YES;
//
//        select_typeBtn.hidden = YES;
//
//        tbl_height = searchTable.frame.size.height;
//
//        type = @"4"; // For All By Default
//        isNewSearch = YES;
//
//
//        UIStoryboard *storyboard;
//
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//
//            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
//
//            CGRect frame = search_bar.frame;
//
//            frame.size.height = 45.0f;
//
//            search_bar.frame = frame;
//
//            select_typeBtn.layer.cornerRadius = 22.5f;
//
//            search_bar.layer.masksToBounds = YES;
//
//        } else {
//
//            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
//
//            select_typeBtn.layer.cornerRadius = 16.0f;
//        }
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(advanceSearchFilter:) name:@"AdvanceSearchFilter" object:nil];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapcategoryBtn:) name:@"tapcategoryBtn" object:nil];
//
//        keyword = @"keyword";
//
//        [self searchCat];
//
//        self.tabBarController.delegate = self;
//    }
//
//    NSLog(@"it is view");
//
//}

-(void)tap_refresh:(UIButton *)sender{
    
    [refreshcontrol endRefreshing];
    
    FAVarray = [[NSMutableArray alloc]init];
    
    NSString *searchKey = [[NSUserDefaults standardUserDefaults]valueForKey:@"searchkey"];
    
    [search_bar setText:searchKey];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cat_ids"]);
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"cat_ids"]) {
        
        [self searchMyListing:[[NSUserDefaults standardUserDefaults] valueForKey:@"cat_ids"]];
        
        search_bar.text =@"";
        
    }
    else{
    
    [self searchMyListing:searchKey];
        
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    int tabitem = (int)tabBarController.selectedIndex;
    
    [[tabBarController.viewControllers objectAtIndex:tabitem] popToRootViewControllerAnimated:NO];
    
    search_bar.hidden = NO;
    select_typeBtn.hidden = YES;
    advanceFilterView.hidden = NO;
    
    CGRect frame = select_typeBtn.frame;
    frame.origin.y = search_bar.frame.origin.y + search_bar.frame.size.height+5;
    select_typeBtn.frame = frame;
    
    frame = advanceFilterView.frame;
    frame.origin.y = select_typeBtn.frame.origin.y ;
    advanceFilterView.frame = frame;
    
    frame = searchTable.frame;
    frame.origin.y = advanceFilterView.frame.origin.y + advanceFilterView.frame.size.height+15;
    frame.size.height = tbl_height;
    searchTable.frame = frame;
    isNewSearch = YES;
    //    if (isNewSearch) {
    //
    //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"category_id"];
    //
    //        listingArray = @[];
    //        categoryArray = @[];
    //        [searchTable reloadData];
    //    }
    //    if(tabitem==2){
    //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"category_id"];
    //    }
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapcategoryBtn:) name:@"tapcategoryBtn" object:nil];
}

-(void)searchCat {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"home"];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"category_id"]);
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"category_id"]) {
        
        [[NSUserDefaults standardUserDefaults]setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"category_id"] forKey:@"cat_ids"];
        
        //type = @"";
        
        keyword = @"category_id";
        //
        type = @"4";
        
        // keyword = @"";
        
        [self searchMyListing:[[NSUserDefaults standardUserDefaults] valueForKey:@"category_id"]];
    }
    
}

-(void)searchMyListing:(NSString *)keyword11 {
    
    [[NSUserDefaults standardUserDefaults]setValue:search_bar.text forKey:@"searchkey"];
    
    //keyword, label  (type for label course=1, event=2, lesson=3 , All=4)
    
    //    if (search) {
    //
    //        NSLog(@"%@",keyword);
    //
    //    } else {
    //
    //        keyword = [[NSUserDefaults standardUserDefaults] valueForKey:@"category_id"];
    //    }
    
    mySearch = NO;
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    // NSDictionary *paramURL = @{@"label" : type, keyword:keyword11};
    
    NSDictionary *paramURL;
    
    paramURL = @{@"label" : type, @"keyword":search_bar.text};
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"category_id"]) {
        
        paramURL = @{@"category_id" : [[NSUserDefaults standardUserDefaults] valueForKey:@"category_id"]};
    }
    
   // if ([[NSUserDefaults standardUserDefaults] valueForKey:@"cat_ids"]) {
    
    else if([search_bar.text isEqual:@""]){
        
        paramURL = @{@"category_id" : [[NSUserDefaults standardUserDefaults] valueForKey:@"cat_ids"]};
        
        //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cat_ids"];
    }
    
    NSLog(@"%@ %@",keyword11, type);
    
    [self.view addSubview:indicator];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cat_ids"]);
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"category_id"];
    
    advanceFilterView.hidden = NO;
    
    [searchConnection startConnectionWithString:[NSString stringWithFormat:@"search"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([searchConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[[receivedData valueForKey:@"info"] valueForKey:@"array_final"] count] < 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"This category needs Listings! Are you an educator? Be the first to post your Listing here. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                listingArray = @[];
                
                categoryArray = @[];
                
                subcategoryArray = @[];
                
                [searchTable reloadData];
                
                [self.view endEditing:YES];
                
                [alert show];
                
            } else {
                
                
                listingArray = [[receivedData valueForKey:@"info"] valueForKey:@"array_final"];
                
                categoryArray = [[receivedData valueForKey:@"info"]valueForKey:@"cat_names"];
                
                subcategoryArray = [[receivedData valueForKey:@"info"]valueForKey:@"sub_cat"];
                
                BOOL isfav = NO;
                
                [FAVarray removeAllObjects];
                
                listing = @"CourseListing";
                
                for (int j = 0; j< listingArray.count; j++) {
                    
                    NSString *course_id = [[[listingArray objectAtIndex:j] valueForKey: @"CourseListing"] valueForKey:@"id"];
                    
                    //  NSLog(@"Course Tap Id %@", course_id);
                    
                    if ([course_id isEqualToString:@""] && [[[[listingArray objectAtIndex:j] valueForKey: @"EventListing"] valueForKey:@"id"] isEqualToString:@""]) {
                        
                        course_id = [[[listingArray objectAtIndex:j] valueForKey: @"LessonListing"] valueForKey:@"id"];
                        
                        listing = @"LessonListing";
                        
                    }else if([course_id isEqualToString:@""] && [[[[listingArray objectAtIndex:j] valueForKey: @"LessonListing"] valueForKey:@"id"] isEqualToString:@""]) {
                        
                        course_id = [[[listingArray objectAtIndex:j] valueForKey: @"EventListing"] valueForKey:@"id"];
                        
                        listing = @"EventListing";
                        
                    }
                    
                    NSArray *favoriteArray = [[listingArray objectAtIndex:j]  valueForKey:@"Favorite"];
                    
                    isfav = NO;
                    
                    for (int i = 0; i< favoriteArray.count; i++) {
                        
                        if ([member_id isEqualToString:[[favoriteArray objectAtIndex:i] valueForKey:@"member_id"]]) {
                            
                            [cell.fave_pin_btn setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                            
                            isfav = YES;
                            
                            fav = @"1";
                            
                            break;
                            
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
                if (listingArray.count <= 10) {
                    
                    advanceFilterView.hidden = YES;
                    select_typeBtn.hidden = YES;
                    
                    CGRect frame = select_typeBtn.frame;
                    frame.origin.y = search_bar.frame.origin.y- frame.size.height;
                    select_typeBtn.frame = frame;
                    
                    frame = advanceFilterView.frame;
                    
                    frame.origin.y = select_typeBtn.frame.origin.y;
                    
                    advanceFilterView.frame = frame;
                    
                    frame = searchTable.frame;
                    
                    frame.origin.y = 65;
                    
                    frame.size.height = tbl_height + search_bar.frame.size.height+ advanceFilterView.frame.size.height + 20;
                    
                    searchTable.frame = frame;
                    
                } else {
                    
                    advanceFilterView.hidden = NO;
                    
                    //                    CGRect frame = select_typeBtn.frame;
                    //                    frame.origin.y = search_bar.frame.origin.y- frame.size.height;
                    //                    select_typeBtn.frame = frame;
                    
                    CGRect frame = advanceFilterView.frame;
                    
                    frame.origin.y = search_bar.frame.origin.y +5;
                    advanceFilterView.frame = frame;
                    
                    frame = searchTable.frame;
                    
                    frame.origin.y = advanceFilterView.frame.origin.y + advanceFilterView.frame.size.height+5;
                    
                    frame.size.height = tbl_height + search_bar.frame.size.height+15;
                    
                    searchTable.frame = frame;
                }
                
                search_bar.hidden = YES;
                select_typeBtn.hidden = YES;
                
                //                CGRect frame = select_typeBtn.frame;
                //                frame.origin.y = search_bar.frame.origin.y- frame.size.height;
                //                select_typeBtn.frame = frame;
                //
                //                frame = advanceFilterView.frame;
                //                frame.origin.y = select_typeBtn.frame.origin.y + select_typeBtn.frame.size.height+5;
                //                advanceFilterView.frame = frame;
                //                frame = searchTable.frame;
                //                frame.origin.y = advanceFilterView.frame.origin.y + advanceFilterView.frame.size.height+5;
                //                // frame.size.height = frame.size.height + search_bar.frame.size.height-5;
                //                frame.size.height = self.view.frame.size.height - advanceFilterView.frame.origin.y - advanceFilterView.frame.size.height - 5;
                //                searchTable.frame = frame;
                
                [searchTable reloadData];
                
                [self.view endEditing:YES];
            }
        }
    }];
}

#pragma mark - SearchBar Delegate

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    search = YES;
    
    keyword = @"keyword";
    
    [self searchMyListing:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    search = YES;
    
    keyword = @"keyword";
    
    [self searchMyListing:searchBar.text];
    
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}


#pragma mark - UITable View Delegates & Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return heightcell +20;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return listingArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil){
        
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    }
    
    if (FAVarray.count ==0 || listingArray==0 || categoryArray.count ==0 ||subcategoryArray.count ==0) {
        
        return cell;
    }
    else{
    
    UIStoryboard *storyboard;
    CGFloat x;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        cell.check_Btn.layer.cornerRadius = 15.0f;
        
        // cell.image_view.frame = CGRectMake(10, 5, cell.main_view.frame.size.width - 20, 235);
        
        x = 20;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        cell.check_Btn.layer.cornerRadius = 13.0f;
        
        //  cell.image_view.frame = CGRectMake(10, 5, self.searchTable.frame.size.width - 20, 135);
        
        x = 15;
    }
    
    
    
    CGRect frame = cell.main_view.frame;
    frame.origin.x = x;
    frame.size.width = searchTable.frame.size.width - (2*x);
    cell.main_view.frame = frame;
    
    //    cell.main_view.backgroundColor = [UIColor whiteColor];
    // cell.main_view.backgroundColor = [UIColor redColor];
    // cell.backgroundColor = [UIColor lightGrayColor];
    
    frame = cell.image_view.frame;
    frame.size.width = cell.main_view.frame.size.width;
    frame.origin.x = 0.0f;
    cell.image_view.frame = frame;
    
    frame = cell.listing_view.frame;
    frame.size.width = cell.main_view.frame.size.width;
    frame.origin.x = 0.0f;
    cell.listing_view.frame = frame;
    
    listing = [[listingArray objectAtIndex:indexPath.row] valueForKey:@"model"] ;
    
    NSString *status_type,*type1;
    
    NSString *url,*location;
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        type_name = @"course_name";
        status_type = @"course_status";
        url = CourseImageURL;
        location = @"course_city";
        type1 = @"Course";
        
        
    } else if ([listing isEqualToString:@"LessonListing"]) {
        
        listing = @"LessonListing";
        type_name = @"lesson_name";
        status_type = @"lession_status";
        url = LessonImageURL;
        location = @"lesson_city";
        type1 = @"Lesson";
        
    } else if ([listing isEqualToString:@"EventListing"]) {
        
        listing = @"EventListing";
        type_name = @"event_name";
        status_type = @"event_status";
        url = EventImageURL;
        location = @"event_city";
        type1 = @"Event";
    }
    
    CGRect frame1 = cell.check_Btn.frame;
    frame1.origin.x = cell.main_view.frame.size.width - frame1.size.width - 25;
    cell.check_Btn.frame = frame1;
    
    frame1 = cell.check_Btn.frame;
    frame1.origin.y = cell.image_view.frame.size.height - frame1.size.height + 15;
    cell.check_Btn.frame = frame1;
    
    cell.category_lbl.hidden = YES;
    cell.post_lbl.hidden = YES;
    cell.post_date.hidden = YES;
    cell.expired.hidden = YES;
    cell.expiry_lbl.hidden = YES;
    cell.check_Btn.hidden = YES;
    
    [cell.fave_pin_btn addTarget:self action:@selector(tapFavBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.fave_pin_btn.tag = indexPath.row;
    
    cell.listing_name.text = [[[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:type_name]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    cell.business_name.text = [[[[listingArray objectAtIndex:indexPath.row] valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    NSMutableArray *subcategories = [[NSMutableArray alloc] init];
    
    for (int i =0 ; i<[[categoryArray objectAtIndex:indexPath.row] count]; i++) {
        
        //[categories addObject:[[categoryArray objectAtIndex:indexPath.row] valueForKey:[cat_id objectAtIndex:i]]];
        
        [categories addObject:[[[[categoryArray objectAtIndex:indexPath.row]objectAtIndex:i] valueForKey:@"Category"]valueForKey:@"category_name"]];
        
        // [categories addObject:[[[[categoryArray objectAtIndex:indexPath.row] objectAtIndex:i] valueForKey:@"Category"] valueForKey:@"category_name"]];
    }
    
    for (int i =0 ; i<[[subcategoryArray objectAtIndex:indexPath.row] count]; i++) {
        
        //[categories addObject:[[categoryArray objectAtIndex:indexPath.row] valueForKey:[cat_id objectAtIndex:i]]];
        
        [subcategories addObject:[[[[subcategoryArray objectAtIndex:indexPath.row]objectAtIndex:i] valueForKey:@"Subcategory"]valueForKey:@"subcategory_name"]];
        
        // [categories addObject:[[[[categoryArray objectAtIndex:indexPath.row] objectAtIndex:i] valueForKey:@"Category"] valueForKey:@"category_name"]];
    }
    
    cell.cat_name.text = [[[categories componentsJoinedByString:@", "]stringByAppendingString:@", "]stringByAppendingString:[subcategories componentsJoinedByString:@", "]];
    //    NSString *date =  [[[listingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"created_at"];
    //
    //    cell.post_date.text = [dateConversion convertDate:date];
    
    NSString *typeCity = [type1 stringByAppendingString:@" / "];
    
    cell.type_city_lbl.text = [typeCity stringByAppendingString:[NSString stringWithFormat:@"%@",[[[listingArray objectAtIndex:indexPath.row] valueForKey:location] valueForKey:@"city_name"]]];
    
    NSLog(@"%@",[typeCity stringByAppendingString:[NSString stringWithFormat:@"%@",[[[listingArray objectAtIndex:indexPath.row] valueForKey:location] valueForKey:@"city_name"]]]);
    
    if ([@"YES" isEqualToString:[FAVarray objectAtIndex:indexPath.row]]) {
        
        [cell.fave_pin_btn setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
    } else {
        
        [cell.fave_pin_btn setBackgroundImage:[UIImage imageNamed:@"favPin_gray"] forState:UIControlStateNormal];
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
    
    CGFloat width_lbl ;
    
    width_lbl = cell.listing_view.frame.size.width-cell.listing_name.frame.origin.x*2-2;
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        
//        
//        width_lbl = cell.listing_view.frame.size.width-cell.listing_name.frame.origin.x*2;
//        
//    } else {
//        
//        width_lbl = 275;
//    }
    
    CGRect frame2 = cell.listing_name.frame;
    
    frame2.size.width = width_lbl;
    
    // frame2.size.height = [self heightCalculate:cell.listing_name.text :cell.listing_name];
    
    cell.listing_name.frame = frame2;
    
    [cell.listing_name sizeToFit];
    
    frame2 = cell.business_name.frame;
    
    frame2.origin.y = cell.listing_name.frame.origin.y + cell.listing_name.frame.size.height +5;
    
    frame2.size.width = width_lbl;
    
    cell.business_name.frame = frame2;
    
    [cell.business_name sizeToFit];
    
    frame2 = cell.cat_name.frame;
    
    frame2.origin.y = cell.business_name.frame.origin.y + cell.business_name.frame.size.height +5;
    
    //frame2.size.height = [self heightCalculate:cell.cat_name.text :cell.cat_name];
    
    frame2.size.width = width_lbl;
    
    cell.cat_name.frame = frame2;
    
    [cell.cat_name sizeToFit];
    
    frame2 = cell.type_city_lbl.frame;
    
    frame2.origin.y = cell.cat_name.frame.origin.y + cell.cat_name.frame.size.height +5;
    
    // frame2.size.height = [self heightCalculate:cell.type_city_lbl.text :cell.type_city_lbl];
    
    frame2.size.width = width_lbl - cell.praise_btn.frame.size.width - 10;
    
    cell.type_city_lbl.frame = frame2;
    
    [cell.type_city_lbl sizeToFit];
    
    frame2 = cell.praise_btn.frame;
    
    frame2.origin.y = cell.cat_name.frame.origin.y + cell.cat_name.frame.size.height +5;
    
    cell.praise_btn.frame = frame2;
    
    frame2 = cell.reviewrecord_lbl.frame;
    
    frame2.origin.y = cell.cat_name.frame.origin.y + cell.cat_name.frame.size.height +5;
    
    cell.reviewrecord_lbl.frame = frame2;
    
    frame2 = cell.listing_view.frame;
    
    frame2.size.height = cell.type_city_lbl.frame.origin.y + cell.type_city_lbl.frame.size.height +5;
    
    cell.listing_view.frame = frame2;
    
    frame2 = cell.main_view.frame;
    
    frame2.size.height = cell.listing_view.frame.origin.y + cell.listing_view.frame.size.height +5;
    
    cell.main_view.frame = frame2;
    
    heightcell = frame2.size.height;
    
    return cell;
    }
}


-(CGFloat)heightCalculate:(NSString *)calculateText:(UILabel *)lbl{
    
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
    
    if (height_lbl> lbl.frame.size.height) {
        
        return (height_lbl);
        
    }
    
    else{
        
        return lbl.frame.size.height;
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
        
        [self performSegueWithIdentifier:@"search_course" sender:self];
        
    } else if ([listing isEqualToString:@"LessonListing"]){
        
        [self performSegueWithIdentifier:@"search_lesson" sender:self];
        
    }  else if ([listing isEqualToString:@"EventListing"]){
        
        [self performSegueWithIdentifier:@"search_event" sender:self];
    }
    
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString indexPath:(NSIndexPath *)indexPath {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            cell = (SearchTableViewCell *)[self.searchTable cellForRowAtIndexPath:indexPath];
            
            cell.image_view.image = image;
        }
    }];
}

-(void)tapFavBtn:(UIButton *)sender{
    
    [self.view addSubview:indicator];
    
    NSString *course_id,*type_str;
    
    listing = [[listingArray objectAtIndex:sender.tag] valueForKey: @"model"];
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        listing = @"CourseListing";
        
        course_id = [[[listingArray objectAtIndex:sender.tag] valueForKey: @"CourseListing"] valueForKey:@"id"];
        
        type_str = @"1";
        
        
    } else if ([listing isEqualToString:@"LessonListing"]) {
        
        
        course_id = [[[listingArray objectAtIndex:sender.tag] valueForKey: @"LessonListing"] valueForKey:@"id"];
        
        listing = @"LessonListing";
        
        type_str = @"3";
        
        
    } else if ([listing isEqualToString:@"EventListing"]) {
        
        course_id = [[[listingArray objectAtIndex:sender.tag] valueForKey: @"EventListing"] valueForKey:@"id"];
        
        listing = @"EventListing";
        
        type_str = @"2";
        
    }
    
    NSDictionary *paramURL;
    
    NSString *msg;
    
    if ([[FAVarray objectAtIndex:sender.tag] isEqualToString:@"YES"]) {
        
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":course_id, @"type":type_str, @"un_fav":@"1"};
        
        msg = @"You have successfully unpinned this listing from your Favorites.";
        
    } else {
        
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":course_id, @"type":type_str};
        
        msg = @"You have successfully pinned this listing to your Favorites.";
    }
    
    [pinTOFavConnection startConnectionWithString:@"add_favorite" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if([pinTOFavConnection responseCode] == 1) {
            
            NSLog(@"%@",receivedData);
            
            if([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                [sender setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                
                if (mySearch) {
                    
                    [self tapUseMySearchPrefBtn:nil];
                } else {
                    
                    [self searchMyListing:search_bar.text];
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }
    }];
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

- (IBAction)tapTypeBtn:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"All",@"Course", @"Lesson", @"Event", nil];
    
    [actionSheet showInView:self.view];
}

- (IBAction)tapAdvanceFilterBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"advanceSearchSegue" sender:self];
}

- (IBAction)tapUseMySearchPrefBtn:(id)sender {
    
    mySearch = YES;
    
    [self.view addSubview:indicator];
    
    NSDictionary *ParamURl = @{@"member_id": [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [mysearchprefVC startConnectionWithString:@"dashboard" HttpMethodType:Post_Type HttpBodyType:ParamURl Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([mysearchprefVC responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"array_final_suggested"] count] < 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This category needs Listings! Are you an educator? Be the first to post your Listing here." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                listingArray = @[];
                
                categoryArray = @[];
                
                [searchTable reloadData];
                
                [self.view endEditing:YES];
                
                [alert show];
                
            } else {
                
                listingArray = [receivedData valueForKey:@"array_final_suggested"];
                
                categoryArray = [receivedData valueForKey:@"cat_name_suggested"];
                
                BOOL isfav = NO;
                
                [FAVarray removeAllObjects];
                
                listing = @"CourseListing";
                
                for (int j = 0; j< listingArray.count; j++) {
                    
                    NSString *course_id = [[[listingArray objectAtIndex:j] valueForKey: @"CourseListing"] valueForKey:@"id"];
                    
                    //  NSLog(@"Course Tap Id %@", course_id);
                    
                    if ([course_id isEqualToString:@""] && [[[[listingArray objectAtIndex:j] valueForKey: @"EventListing"] valueForKey:@"id"] isEqualToString:@""]) {
                        
                        course_id = [[[listingArray objectAtIndex:j] valueForKey: @"LessonListing"] valueForKey:@"id"];
                        
                        listing = @"LessonListing";
                        
                    }else if([course_id isEqualToString:@""] && [[[[listingArray objectAtIndex:j] valueForKey: @"LessonListing"] valueForKey:@"id"] isEqualToString:@""]) {
                        
                        course_id = [[[listingArray objectAtIndex:j] valueForKey: @"EventListing"] valueForKey:@"id"];
                        
                        listing = @"EventListing";
                    }
                    
                    NSArray *favoriteArray = [[listingArray objectAtIndex:j]  valueForKey:@"Favorite"];
                    
                    isfav = NO;
                    
                    for (int i = 0; i< favoriteArray.count; i++) {
                        
                        if ([member_id isEqualToString:[[favoriteArray objectAtIndex:i] valueForKey:@"member_id"]]) {
                            
                            [cell.fave_pin_btn setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                            
                            isfav = YES;
                            
                            fav = @"1";
                            
                            break;
                            
                        } else {
                            
                            isfav = NO;
                        }
                    }
                    if (isfav) {
                        
                        [FAVarray addObject:@"YES"];
                        
                    } else{
                        
                        [FAVarray addObject:@"NO"];
                    }
                }
                if (listingArray.count <= 10) {
                    
                    advanceFilterView.hidden = YES;
                    select_typeBtn.hidden = YES;
                    
                    CGRect frame = select_typeBtn.frame;
                    frame.origin.y = search_bar.frame.origin.y- frame.size.height;
                    select_typeBtn.frame = frame;
                    
                    frame = advanceFilterView.frame;
                    
                    frame.origin.y = select_typeBtn.frame.origin.y;
                    
                    advanceFilterView.frame = frame;
                    
                    frame = searchTable.frame;
                    
                    frame.origin.y = 65;
                    
                    frame.size.height = tbl_height + search_bar.frame.size.height+ advanceFilterView.frame.size.height + 20;
                    
                    searchTable.frame = frame;
                    
                } else {
                    
                    advanceFilterView.hidden = NO;
                    
                    CGRect frame = advanceFilterView.frame;
                    
                    frame.origin.y = search_bar.frame.origin.y +5;
                    advanceFilterView.frame = frame;
                    
                    frame = searchTable.frame;
                    
                    frame.origin.y = advanceFilterView.frame.origin.y + advanceFilterView.frame.size.height+5;
                    
                    frame.size.height = tbl_height + search_bar.frame.size.height+15;
                    
                    searchTable.frame = frame;
                }
                
                search_bar.hidden = YES;
                select_typeBtn.hidden = YES;
                
                //                CGRect frame = select_typeBtn.frame;
                //                frame.origin.y = search_bar.frame.origin.y- frame.size.height;
                //                select_typeBtn.frame = frame;
                //
                //                frame = advanceFilterView.frame;
                //                frame.origin.y = select_typeBtn.frame.origin.y + select_typeBtn.frame.size.height+5;
                //                advanceFilterView.frame = frame;
                //                frame = searchTable.frame;
                //                frame.origin.y = advanceFilterView.frame.origin.y + advanceFilterView.frame.size.height+5;
                //                // frame.size.height = frame.size.height + search_bar.frame.size.height-5;
                //                frame.size.height = self.view.frame.size.height - advanceFilterView.frame.origin.y - advanceFilterView.frame.size.height - 5;
                //                searchTable.frame = frame;
                
                [searchTable reloadData];
                
                [self.view endEditing:YES];
            }
        }
        
    }];
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *keyword1 = search_bar.text;
    
    if (buttonIndex == 0) {
        
        [select_typeBtn setTitle:@"All" forState:UIControlStateNormal];
        
        type = @"4";
        
        [self searchMyListing:keyword1];
        
        
    } else if (buttonIndex == 1) {
        
        [select_typeBtn setTitle:@"Course" forState:UIControlStateNormal];
        
        type = @"1";
        
        [self searchMyListing:keyword1];
        
        
    } else if (buttonIndex == 2) {
        
        [select_typeBtn setTitle:@"Lesson" forState:UIControlStateNormal];
        
        type = @"3";
        
        
        [self searchMyListing:keyword1];
        
    }  else if (buttonIndex == 3) {
        
        [select_typeBtn setTitle:@"Event" forState:UIControlStateNormal];
        
        type = @"2";
        
        [self searchMyListing:keyword1];
        
    }
    
    
}
-(void)tapcategoryBtn:(NSNotification *)notification{
    
    isNewSearch = NO;
    
    [self searchCat];
    
}

#pragma mark - Advance Search

-(void)advanceSearchFilter:(NSNotification *)notification {
    
    NSDictionary *dict = [notification object];
    
    NSLog(@"%@",dict);
    
    [self.view addSubview:indicator];
    
    [searchConnection startConnectionWithString:[NSString stringWithFormat:@"search_ad"] HttpMethodType:Post_Type HttpBodyType:dict Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([searchConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"array_final"] count] < 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No record exits." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
                listingArray = @[];
                
                categoryArray = @[];
                
                [searchTable reloadData];
                
            } else {
                
                listingArray = [receivedData valueForKey:@"array_final"];
                
                categoryArray = [receivedData valueForKey:@"cat_names"];
                
                subcategoryArray = [receivedData valueForKey:@"sub_cat"];
                
                [searchTable reloadData];
            }
        }
    }];
    
}

@end