//
//  HomeViewController.m
//  ecaHUB
//
//  Created by promatics on 2/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "HomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "HomeFavoritesTableCell.h"
#import "HomeMyListingTableCell.h"
#import "SuggestionTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "CourseDetailViewController.h"
#import "LessionDetailViewController.h"
#import "EventViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MyfavoritesViewController.h"
#import "editLessionSessionViewController.h"
#import "editSessionOptionsListingViewController.h"

@interface HomeViewController () {
    
    LoginViewController *lvc;
    
    DateConversion *dateConversion;
    
    NSArray *favArray;
    
    NSArray *mylistingArray;
    
    NSArray *suggesionArray;
    
    NSString *dataStr;
    
    HomeFavoritesTableCell *favCell;
    
    HomeMyListingTableCell *MyListingCell;
    
    SuggestionTableViewCell *suggesionCell;
    
    WebServiceConnection *webConnection,*pinTOFavConnection,*messageConn;
    
    UITapGestureRecognizer *tapGesture;
    
    Indicator *indicator;
    
    NSString *member_id;
    
    NSString *listing, *type_name;
    
    NSArray *categoryArray, *fav_catArray, *subcategoryArray, *fav_subcatArray;
    
    float x;
    
    NSArray *catIdArray;
    
    NSMutableArray *FAVarray;
    
    BOOL isSugg;
}
@end

@implementation HomeViewController

@synthesize msgtable_view;

-(void)viewWillAppear:(BOOL)animated {
    
    [self checkLogin];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"refresh"];
//    
//        UIStoryboard *st = self.storyboard;
//    
//            editSessionOptionsListingViewController *aVC = [st instantiateViewControllerWithIdentifier:@"sessionVC"];
//    
//        [self.navigationController pushViewController:aVC animated:YES];
    
       
//
//    UIActionSheet *acsheet = [[UIActionSheet alloc]initWithTitle:Alert_title delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:@"CANCEL" otherButtonTitles:@"OK", nil];
//    
//    [acsheet showInView:self.view];
    
    
    suggesionCell.descriptionLbl.hidden = YES;
    
    favCell.favDescription_textview.hidden = YES;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        x = 30.0f;//25
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        x = 5.0f;//15
    }
    
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
    webConnection = [WebServiceConnection connectionManager];
    
    pinTOFavConnection = [WebServiceConnection connectionManager];
    
    messageConn = [WebServiceConnection connectionManager];
    
    FAVarray = [[NSMutableArray alloc] init];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    //tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCategory)];
    
    UITabBarItem *barItem1 = [[self.tabBarController.tabBar items] objectAtIndex:0];
    
    barItem1.image = [[UIImage imageNamed:@"Home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *barItem2 = [[self.tabBarController.tabBar items] objectAtIndex:1];
    
    barItem2.image = [[UIImage imageNamed:@"Whats'sOn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *barItem3 = [[self.tabBarController.tabBar items] objectAtIndex:2];
    
    barItem3.image = [[UIImage imageNamed:@"Search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *barItem4 = [[self.tabBarController.tabBar items] objectAtIndex:3];
    
    barItem4.image = [[UIImage imageNamed:@"Mail"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *barItem5 = [[self.tabBarController.tabBar items] objectAtIndex:4];
    
    barItem5.image = [[UIImage imageNamed:@"Menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    catIdArray =  @[@"153",@"152",@"155",@"156",@"157",@"158",@"159",@"160",@"161",@"162",
                    @"163",@"164",@"165",@"166",@"167",@"168"];
    
    dateConversion = [DateConversion dateConversionManager];
    
    [self checkLogin];
  
}

-(void)setMessageBadges{
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    NSDictionary *paramURL = @{@"member_id" : member_id};
    
    [messageConn startConnectionWithString:@"message" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        
        if ([messageConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                NSString * msgcount = [receivedData valueForKey:@"unread"];
                
                [[[[[self tabBarController] tabBar] items]
                  objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%@",msgcount]];
                
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                
                localNotification.applicationIconBadgeNumber = [msgcount integerValue];// set here the value of badge
                
                // [localNotification release];
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = [msgcount integerValue];
                
            }
        }
    }];
    
    
    
}

-(void)fetchData {
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    NSLog(@"%@",member_id);
    
    NSDictionary *paramURL = @{@"member_id" : member_id};
    
    
    
    NSLog(@"%@",paramURL);
    
    [self.view addSubview:indicator];
    
    [webConnection startConnectionWithString:@"dashboard" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([webConnection responseCode] ==1) {
            
            NSLog(@"%@",receivedData);
            
            if ([[receivedData valueForKey:@"code"]integerValue]==1) {
                
                mylistingArray = [receivedData valueForKey:@"my_listing"];
                
                categoryArray = [receivedData valueForKey:@"cat_name_suggested"];
                
                subcategoryArray = [receivedData valueForKey:@"subcat_name_suggested"];
                
                favArray = [receivedData valueForKey:@"favorite_info"];
                
                //favArray = @[];
                
                fav_catArray = [receivedData valueForKey:@"cat_names_fav"];
                
                fav_subcatArray = [receivedData valueForKey:@"subcat_names_fav"];
                
                suggesionArray = [receivedData valueForKey:@"array_final_suggested"];
                
                NSLog(@"favArray %@",favArray);
                
                NSLog(@"suggesionArray %@",suggesionArray);
                
                BOOL isfav = NO;
                
                [FAVarray removeAllObjects];
                
                for (int j = 0; j< suggesionArray.count; j++) {
                    
                    NSArray *favoriteArray = [[suggesionArray objectAtIndex:j] valueForKey:@"Favorite"];
                    
                    isfav = NO;
                    
                    for (int i = 0; i< favoriteArray.count; i++) {
                        
                        if ([member_id isEqualToString:[[favoriteArray objectAtIndex:i] valueForKey:@"member_id"]]) {
                            
                            [suggesionCell.favPingray_bttn setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                            
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
                
                NSLog(@"%@\n%@\n%@",mylistingArray,favArray,suggesionArray);
                
                [self setMessageBadges];
                
                [msgtable_view reloadData];
            }
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
    
    CGSize constraint = CGSizeMake(suggesionCell.category_lbl.frame.size.width - (1.0f * 2), FLT_MAX);
    
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
    
    return (height_lbl + 10);
}

-(CGFloat)heightCalculate1:(NSString *)calculateText{
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(favCell.category_lbl.frame.size.width - (1.0f * 2), FLT_MAX);
    
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
    
    return (height_lbl);
}

#pragma mark - check Login

-(void) checkLogin {
    
    if ((![[[[NSUserDefaults standardUserDefaults] valueForKey:@"login"] valueForKey:@"login"] isEqualToString:@"1"]) || (![[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"])) {
        
        [self performSegueWithIdentifier:@"login" sender:self];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Signup"];
        
        [self fetchData];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    NSDictionary *login = @{@"login" : @"0", @"ecaHubLogin" : @"1"};
    
    [[NSUserDefaults standardUserDefaults] setValue:login forKey:@"login"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    
    [self performSegueWithIdentifier:@"login" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    lvc = segue.destinationViewController;
    
    if ([[segue identifier] isEqualToString:@"FavViewMoreSegue"]) {
        
        MyfavoritesViewController *myfavVC = [segue destinationViewController];
        
        myfavVC.isSuggestion = isSugg;
    }
    
}

-(void) dismissLoginVC {
    
    [lvc dismissViewControllerAnimated:YES completion:nil];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        
        return 16;
        //  return mylistingArray.count;
    }
    else if (section == 1){
        
        return favArray.count;
        
    } else {
        
        return suggesionArray.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
//
//    CGFloat height1, height2;
//
//    UIStoryboard *storyboard;
//
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//
//        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
//
//        height1 = 80.0f;
//
//        height2 = 80.0f;
//
//    } else {
//
//        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
//
//        height1 = 50.0f;
//
//        height2 = 50.0f;
//    }
//
//
//    if(section == 0){
//
//        //return height1;
//
//        return 0.0f;
//    }
//    else if (section == 1 ){
//
//        if (favArray.count > 0) {
//
//            return height2;
//
//        }else{
//            return 0;
//        }
//
//    } else {
//
//        if (suggesionArray.count > 0) {
//
//            return height2;
//
//        } else{
//            return 0;
//        }
//    }
//
//
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height1, height2;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        height1 = 80.0f;
        
        height2 = 80.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        height1 = 50.0f;
        
        height2 = 50.0f;
    }
    
    
    if(section == 0){
        
        return height1;
    }
    else if (section == 1 ){
        
        if (favArray.count > 0) {
            
            return height2;
            
        }else{
            return 0;
        }
        
    } else {
        
        if (suggesionArray.count > 0) {
            
            return height2;
            
        } else{
            return 0;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height1, height2;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        height1 = 335.0f;
        
        height2 = 535.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        height1 = 190.0f;
        
        height2 = 376.0f;
    }
    
    if (indexPath.section == 0) {
        
        return height1;
        
    }  else if (indexPath.section == 1 ){
        
        if (favArray.count > 0) {
            
            return favCell.favView.frame.origin.y + favCell.favView.frame.size.height +15;
            
        }else{
            return 0;
        }
        
    } else {
        
        if (suggesionArray.count > 0) {
            
            return suggesionCell.listing_view.frame.origin.y + suggesionCell.listing_view.frame.size.height +15;
            
        } else{
            return 0;
        }
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat height1, height2, font;
    
    CGFloat width = msgtable_view.frame.size.width ;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        height1 = 80.0f;
        
        height2 = 80.0f;
        
        font = 25.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        height1 = 50.0f;
        
        height2 = 50.0f;
        
        font = 19.0f;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, msgtable_view.frame.size.width, height1)];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height2)];
    
    [lbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:font]];
    
    [lbl setNumberOfLines:2];
    
    [lbl setTextAlignment:NSTextAlignmentCenter];
    
    lbl.textColor = [UIColor darkGrayColor];
    
    if(section == 0){
        
        view.frame = CGRectMake(0, 0, msgtable_view.frame.size.width, height1);
        
        lbl.text = @"Discover Listings by category";
        
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_grayColor"]];
        
        lbl.frame = CGRectMake((msgtable_view.frame.size.width - width)/2, 0, width, height1);
        
    } else if (section == 1){
        
        view.frame = CGRectMake(0, 0, msgtable_view.frame.size.width, height1);
        
        lbl.text = @"My Favorites";
        
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_grayColor"]];
        
        lbl.frame = CGRectMake((msgtable_view.frame.size.width - width)/2, 0, width, height1);
        
        //  [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:22]];
        
    } else {
        
        // view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_grayColor"]];
        
        view.frame = CGRectMake(0, 0, msgtable_view.frame.size.width, height1);
        
        lbl.text = @"Suggestions";
        
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_grayColor"]];
        
        lbl.frame = CGRectMake((msgtable_view.frame.size.width - width)/2, 0, width, height1);
        
        //    [lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:22]];
    }
    // lbl.textColor = [UIColor blackColor];
    [view addSubview:lbl];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        MyListingCell = [tableView dequeueReusableCellWithIdentifier:@"MyListingCell" forIndexPath:indexPath];
        
        MyListingCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (MyListingCell == nil){
            
            MyListingCell = [[HomeMyListingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyListingCell"];
        }
        
        CGRect frame = MyListingCell.listing_view.frame;
        
        frame.origin.x = x;
        
        frame.size.width = MyListingCell.frame.size.width - (2*x);
        
        MyListingCell.listing_view.frame = frame;
        
        frame = MyListingCell.mylisting_imgview.frame;
        frame.size.width = MyListingCell.listing_view.frame.size.width;
        MyListingCell.mylisting_imgview.frame = frame;
        
        frame = MyListingCell.listingname_lbl.frame;
        frame.origin.x = (MyListingCell.listing_view.frame.size.width - frame.size.width)/2;
        MyListingCell.listingname_lbl.frame = frame;
        
        // tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCategory)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCategory:)];
        
        MyListingCell.listingname_lbl.userInteractionEnabled = YES;
        
        MyListingCell.listingname_lbl.tag = indexPath.row;
        
        [tap setNumberOfTapsRequired:1];
        
        [MyListingCell.listingname_lbl addGestureRecognizer:tap];
        
        switch (indexPath.row) {
                
            case 0: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat1"];
                
                MyListingCell.listingname_lbl.text = @"Pre-School Activity";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_button"]]];
                break;
                
            } case 1: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat2"];
                
                MyListingCell.listingname_lbl.text = @"Tutorial";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_button"]]];
                break;
                
            } case 2: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat3"];
                
                MyListingCell.listingname_lbl.text = @"Language Learning";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow_button"]]];
                break;
                
            } case 3: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat4"];
                
                MyListingCell.listingname_lbl.text = @"Test Preparation";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_green_button"]]];
                break;
                
            } case 4: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat5"];
                
                MyListingCell.listingname_lbl.text = @"Performing Arts";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_button"]]];
                break;
                
            } case 5: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat6"];
                
                MyListingCell.listingname_lbl.text = @"Visual Arts";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_button"]]];
                
                break;
                
            } case 6: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat7"];
                
                MyListingCell.listingname_lbl.text = @"Craft Arts";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_green_button"]]];
                
                break;
                
            } case 7: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat8"];
                
                MyListingCell.listingname_lbl.text = @"Music";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow_button"]]];
                
                break;
                
            } case 8: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat11"];
                
                MyListingCell.listingname_lbl.text = @"Sports";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_button"]]];
                
                break;
                
            } case 9: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat12"];
                
                MyListingCell.listingname_lbl.text = @"Outdoor Activities";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_button"]]];
                
                break;
                
            } case 10: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat9"];
                
                MyListingCell.listingname_lbl.text = @"Brain Training";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow_button"]]];
                
                break;
                
            } case 11: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat10"];
                
                MyListingCell.listingname_lbl.text = @"Special Interest Clubs";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_green_button"]]];
                
                break;
                
            } case 12: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat13"];
                
                MyListingCell.listingname_lbl.text = @"Science & Technology";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_button"]]];
                
                break;
                
            } case 13: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat14"];
                
                MyListingCell.listingname_lbl.text = @"Digital & Design";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow_button"]]];
                
                
                break;
                
            } case 14: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat15"];
                
                MyListingCell.listingname_lbl.text = @"Career & Personal";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"dark_green_button"]]];
                break;
                
            } case 15: {
                
                MyListingCell.mylisting_imgview.image = [UIImage imageNamed:@"Cat16"];
                
                MyListingCell.listingname_lbl.text = @"Online Learning";
                
                [MyListingCell.listingname_lbl setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_button"]]];
                break;
                
            }
            default:
                break;
        }
        return MyListingCell;
    }
    else if (indexPath.section == 1) {
        
        favCell = [tableView dequeueReusableCellWithIdentifier:@"favCell" forIndexPath:indexPath];
        
        favCell .selectionStyle = UITableViewCellSelectionStyleNone;
        
        [favCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"light_grayColor"]]];//Fav_bg
        
        CGRect frame = favCell.favListing_lbl.frame;
        
        frame.size.width = favCell.favView.frame.size.width - frame.origin.x;
        
        favCell.favListing_lbl.frame = frame;
        
        frame = favCell.favView.frame;
        
        frame.origin.x = x;
        
        frame.size.width = self.msgtable_view.frame.size.width - frame.origin.x - (x);
        
        favCell.favView.frame = frame;
        
        //        frame = favCell.favDescription_textview.frame;
        //
        //        frame.size.width = favCell.favView.frame.size.width - frame.origin.x - (x);
        //
        //        favCell.favDescription_textview.frame = frame;
        
        frame = favCell.favPin_bttn.frame;
        frame.origin.x = 25.0;
        frame.origin.y = 20.0f;
        favCell.favPin_bttn.frame = frame;
        
        listing = [[favArray objectAtIndex:indexPath.row] valueForKey:@"model"] ;
        
        favCell.favDescription_textview.hidden = YES;
        
        
        //   NSLog(@"%@",listing);
        
        NSString *status_type, *discription;
        
        NSString *url,*type,*location;
        
        if ([listing isEqualToString:@"CourseListing"]) {
            
            listing = @"CourseListing";
            type_name = @"course_name";
            status_type = @"course_status";
            discription = @"course_description";
            url = CourseImageURL;
            type= @"Course";
            location = @"course_city";
            
        } else if ([listing isEqualToString:@"LessonListing"]) {
            
            listing = @"LessonListing";
            type_name = @"lesson_name";
            status_type = @"lession_status";
            discription = @"lesson_description";
            url = LessonImageURL;
            type = @"Lesson";
            location = @"lesson_city";
        } else if ([listing isEqualToString:@"EventListing"]) {
            
            listing = @"EventListing";
            type_name = @"event_name";
            status_type = @"event_status";
            discription = @"event_description";
            url = EventImageURL;
            type = @"Event";
            location = @"event_city";
            
        }
        
        favCell.MoreBtn_View.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_grayColor"]];
        
        if (indexPath.row == favArray.count-1 && favArray.count ==3) {
            
            favCell.MoreBtn_View.hidden = NO;
        }
        
        else{
            
            favCell.MoreBtn_View.hidden = YES;
            
        }
        
        [favCell.viewMore_Btn addTarget:self action:@selector(tap_favViewMore:) forControlEvents:UIControlEventTouchUpInside];
        
        favCell.favListing_lbl.text = [[[[favArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:type_name]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        favCell.faveBusines_lbl.text = [[[[[favArray objectAtIndex:indexPath.row] valueForKey:listing]valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        favCell.award_countLbl.text = [[[[favArray objectAtIndex:indexPath.row] valueForKey:listing]valueForKey:@"BusinessProfile"] valueForKey:@"praise_count"];
        
        
        //   NSString *tst = [[[[favArray objectAtIndex:indexPath.row] valueForKey:listing]valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
        
        favCell.favDescription_textview.text = [[[favArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:discription];
        
        [favCell.favDescription_textview sizeToFit];
        
        NSString *type_city = [type stringByAppendingString:@" | "];
        
        favCell.type_city_lbl.text = [type_city stringByAppendingString:[NSString stringWithFormat:@"%@",[[[[favArray objectAtIndex:indexPath.row] valueForKey:listing]valueForKey:location] valueForKey:@"city_name"]]];
        
        //   NSLog(@"%@", [type_city stringByAppendingString:[NSString stringWithFormat:@"%@",[[[[favArray objectAtIndex:indexPath.row] valueForKey:listing]valueForKey:location] valueForKey:@"city_name"]]]);
        
        //         NSString *categoriesStr = [[[favArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"category_id"];
        //
        //        NSArray *cat_id = [categoriesStr componentsSeparatedByString:@","];
        
        NSMutableArray *categories = [[NSMutableArray alloc] init];
        
        NSMutableArray *subcategories = [[NSMutableArray alloc] init];
        
        for (int i =0 ; i<[[fav_catArray objectAtIndex:indexPath.row] count]; i++) {
            
            //[categories addObject:[[categoryArray objectAtIndex:indexPath.row] valueForKey:[cat_id objectAtIndex:i]]];
            
            [categories addObject:[[[[fav_catArray objectAtIndex:indexPath.row]objectAtIndex:i] valueForKey:@"Category"]valueForKey:@"category_name"]];
            
            // [categories addObject:[[[[categoryArray objectAtIndex:indexPath.row] objectAtIndex:i] valueForKey:@"Category"] valueForKey:@"category_name"]];
        }
        
        for (int i =0 ; i<[[fav_subcatArray objectAtIndex:indexPath.row] count]; i++) {
            
            //[categories addObject:[[categoryArray objectAtIndex:indexPath.row] valueForKey:[cat_id objectAtIndex:i]]];
            
            [subcategories addObject:[[[[fav_subcatArray objectAtIndex:indexPath.row]objectAtIndex:i] valueForKey:@"Subcategory"]valueForKey:@"subcategory_name"]];
            
            // [categories addObject:[[[[categoryArray objectAtIndex:indexPath.row] objectAtIndex:i] valueForKey:@"Category"] valueForKey:@"category_name"]];
        }
        
        favCell.category_lbl.text = [[[categories componentsJoinedByString:@", "]stringByAppendingString:@", "]stringByAppendingString:[subcategories componentsJoinedByString:@", "]];
        
        frame = favCell.favPin_bttn.frame;
        
        frame.origin.x = favCell.imageView.frame.origin.x + 10;
        
        frame.origin.y = favCell.imageView.frame.origin.y +10;
        
        favCell.favPin_bttn.frame = frame;
        
        CGRect frame1 = favCell.category_lbl.frame;
        
        frame1.origin.y = favCell.faveBusines_lbl.frame.origin.y + favCell.faveBusines_lbl.frame.size.height +5;
        
        frame1.size.height = [self heightCalculate1:favCell.category_lbl.text];
        
        favCell.category_lbl.frame = frame1;
        
        frame1 = favCell.type_city_lbl.frame;
        
        frame1.origin.y = favCell.category_lbl.frame.origin.y + favCell.category_lbl.frame.size.height+ 5;
        
        favCell.type_city_lbl.frame = frame1;
        
        frame1 = favCell.award_countLbl.frame;
        
        frame1.origin.y = favCell.category_lbl.frame.origin.y + favCell.category_lbl.frame.size.height+ 5;
        
        frame1.origin.x = favCell.favView.frame.size.width-favCell.award_countLbl.frame.size.width-favCell.award_btn.frame.size.width-10;
        
        favCell.award_countLbl.frame = frame1;
        
        frame1 = favCell.award_btn.frame;
        
        frame1.origin.y = favCell.category_lbl.frame.origin.y + favCell.category_lbl.frame.size.height+ 5;
        
        frame1.origin.x = favCell.award_countLbl.frame.origin.x + favCell.award_countLbl.frame.size.width+5;
        
        favCell.award_btn.frame = frame1;
        
        frame1 = favCell.MoreBtn_View.frame;
        
        frame1.origin.y = favCell.type_city_lbl.frame.origin.y+ favCell.type_city_lbl.frame.size.height +10;
        
        favCell.MoreBtn_View.frame = frame1;
        
        favCell.viewMore_Btn.layer.cornerRadius = 5;
        
        if (favCell.MoreBtn_View.hidden == YES) {
            
            frame1 = favCell.favView.frame;
            
            frame1.size.height = favCell.type_city_lbl.frame.origin.y+ favCell.type_city_lbl.frame.size.height +5;
            
            favCell.favView.frame = frame1;
            
        }
        
        else{
            
            frame1 = favCell.favView.frame;
            
            frame1.size.height = favCell.MoreBtn_View.frame.origin.y+ favCell.MoreBtn_View.frame.size.height;
            
            favCell.favView.frame = frame1;
            
        }
        
        
        NSString *imageURL = [[[favArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"picture0"];
        
        for (int i = 1; i<5; i++) {
            
            NSString *pic = [NSString stringWithFormat:@"picture%d",i];
            
            if ([imageURL length] < 1) {
                
                imageURL = [[[favArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:pic];
            }
        }
        
        imageURL = [imageURL stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
        
        favCell.favImg_view.image = [UIImage imageNamed:@"Listing_Image"];
        
        if ([imageURL length] < 1) {
            
            //Listing_Image
            favCell.favImg_view.image = [UIImage imageNamed:@"Listing_Image"];
            
        } else {
            
            imageURL = [url stringByAppendingString:imageURL];
            
            //     NSLog(@"%@",imageURL);
            
            [favCell.favImg_view sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Listing_Image"]];
        }
        
        frame = favCell.favImg_view.frame;
        frame.size.width = favCell.favView.frame.size.width;
        frame.origin.x = 0.0f;
        favCell.favImg_view.frame= frame;
        
        [favCell.favPin_bttn addTarget:self action:@selector(tapToFavPin_Btn:) forControlEvents:UIControlEventTouchUpInside];
        
        favCell.favPin_bttn.tag = indexPath.row;
        
        return favCell;
        
    } else {
        
        suggesionCell = (SuggestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SuggestionCell" forIndexPath:indexPath];
        
        suggesionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (suggesionCell == nil){
            
            suggesionCell = [[SuggestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SuggestionCell"];
        }
        
        [suggesionCell.favPingray_bttn addTarget:self action:@selector(tapFavBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [suggesionCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"light_grayColor"]]];
        
        suggesionCell.favPingray_bttn.tag = indexPath.row;
        
        CGRect frame = suggesionCell.listing_view.frame;
        
        frame.origin.x = x;
        
        frame.size.width = self.msgtable_view.frame.size.width - (2*x);
        
        suggesionCell.listing_view.frame = frame;
        
        suggesionCell.descriptionLbl.hidden = YES;
        
        frame = suggesionCell.listing_name.frame;
        
        frame.size.width = suggesionCell.listing_view.frame.size.width - frame.origin.x;
        
        suggesionCell.listing_name.frame = frame;
        
        // suggesionCell.educator_name.frame = frame;
        
        frame = suggesionCell.descriptionLbl.frame;
        
        frame.size.width = suggesionCell.listing_view.frame.size.width - frame.origin.x - 5;
        
        suggesionCell.descriptionLbl.frame = frame;
        
        frame = suggesionCell.image_view.frame;
        
        frame.size.width = suggesionCell.listing_view.frame.size.width;
        frame.origin.x = 0.0f;
        suggesionCell.image_view.frame= frame;
        
        //        frame = suggesionCell.favPingray_bttn.frame;
        //        frame.origin.x = 25.0;
        //        frame.origin.y = 20.0f;
        //        suggesionCell.favPingray_bttn.frame = frame;
        
        frame = suggesionCell.favPingray_bttn.frame;
        
        frame.origin.x = suggesionCell.image_view.frame.origin.x + 10;
        
        frame.origin.y = suggesionCell.image_view.frame.origin.y +10;
        
        suggesionCell.favPingray_bttn.frame = frame;
        
        listing = [[suggesionArray objectAtIndex:indexPath.row] valueForKey:@"model"] ;
        
        // NSLog(@"%@",listing);
        
        NSString *status_type, *discription;
        
        NSString *url,*type,*location;
        
        if ([listing isEqualToString:@"CourseListing"]) {
            
            listing = @"CourseListing";
            type_name = @"course_name";
            status_type = @"course_status";
            url = CourseImageURL;
            discription = @"course_description";
            type = @"Course";
            location = @"course_city";
            
        } else if ([listing isEqualToString:@"LessonListing"]) {
            
            listing = @"LessonListing";
            type_name = @"lesson_name";
            status_type = @"lession_status";
            url = LessonImageURL;
            discription = @"lesson_description";
            type = @"Lesson";
            location= @"lesson_city";
            
        } else if ([listing isEqualToString:@"EventListing"]) {
            
            listing = @"EventListing";
            type_name = @"event_name";
            status_type = @"event_status";
            url = EventImageURL;
            discription = @"event_description";
            type = @"Event";
            location= @"event_city";
        }
        
        if ([@"YES" isEqualToString:[FAVarray objectAtIndex:indexPath.row]]) {
            
            [suggesionCell.favPingray_bttn setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
            
        } else {
            
            [suggesionCell.favPingray_bttn setBackgroundImage:[UIImage imageNamed:@"favPin_gray"] forState:UIControlStateNormal];
        }
        
        suggesionCell.moreBtn_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"light_grayColor"]];
        
        suggesionCell.ViewMore_Btn.layer.cornerRadius = 5;
        
        if (indexPath.row == subcategoryArray.count-1 && suggesionArray.count == 3) {
            
            suggesionCell.moreBtn_view.hidden = NO;
        }
        
        else{
            
            suggesionCell.moreBtn_view.hidden = YES;
            
        }
        
        [suggesionCell.ViewMore_Btn addTarget:self action:@selector(tap_SuggViewMore:) forControlEvents:UIControlEventTouchUpInside];
        
        
        suggesionCell.listing_name.text = [[[[suggesionArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:type_name]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        suggesionCell.educator_name.text = [[[[suggesionArray objectAtIndex:indexPath.row]valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        suggesionCell.award_countLbl.text = [[[suggesionArray objectAtIndex:indexPath.row]valueForKey:@"BusinessProfile"] valueForKey:@"praise_count"];
        
        //  NSString *test = [[[suggesionArray objectAtIndex:indexPath.row]valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
        
        suggesionCell.descriptionLbl.text = [[[suggesionArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:discription];
        
        [suggesionCell.descriptionLbl sizeToFit];
        
        NSString *type_city = [type stringByAppendingString:@" | "];
        
        suggesionCell.type_city_lbl.text = [type_city stringByAppendingString:[NSString stringWithFormat:@"%@",[[[suggesionArray objectAtIndex:indexPath.row] valueForKey:location] valueForKey:@"city_name"]]];
        
        //  NSLog(@"%@", [type_city stringByAppendingString:[NSString stringWithFormat:@"%@",[[[suggesionArray objectAtIndex:indexPath.row] valueForKey:location] valueForKey:@"city_name"]]]);
        
        //        NSString *categoriesStr = [[[suggesionArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"category_id"];
        //
        //        NSArray *cat_id = [categoriesStr componentsSeparatedByString:@","];
        //
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
        
        suggesionCell.category_lbl.text = [[[categories componentsJoinedByString:@", "]stringByAppendingString:@", "]stringByAppendingString:[subcategories componentsJoinedByString:@", "]];
        
        CGRect frame1 = suggesionCell.category_lbl.frame;
        
        frame1.origin.y = suggesionCell.educator_name.frame.origin.y + suggesionCell.educator_name.frame.size.height +5;
        
        frame1.size.height = [self heightCalculate:suggesionCell.category_lbl.text];
        
        suggesionCell.category_lbl.frame = frame1;
        
        frame1 = suggesionCell.type_city_lbl.frame;
        
        frame1.origin.y = suggesionCell.category_lbl.frame.origin.y + suggesionCell.category_lbl.frame.size.height+ 5;
        
        suggesionCell.type_city_lbl.frame = frame1;
        
        frame1 = suggesionCell.award_countLbl.frame;
        
        frame1.origin.y = suggesionCell.category_lbl.frame.origin.y + suggesionCell.category_lbl.frame.size.height+ 5;
        
        frame1.origin.x = suggesionCell.listing_view.frame.size.width - suggesionCell.award_countLbl.frame.size.width-suggesionCell.award_btn.frame.size.width-10;
        
        suggesionCell.award_countLbl.frame = frame1;
        
        frame1 = suggesionCell.award_btn.frame;
        
        frame1.origin.y = suggesionCell.category_lbl.frame.origin.y + suggesionCell.category_lbl.frame.size.height+ 5;
        
        frame1.origin.x = suggesionCell.award_countLbl.frame.origin.x + suggesionCell.award_countLbl.frame.size.width+5;
        
        suggesionCell.award_btn.frame = frame1;
        
        frame1 = suggesionCell.moreBtn_view.frame;
        
        frame1.origin.y = suggesionCell.type_city_lbl.frame.origin.y+ suggesionCell.type_city_lbl.frame.size.height +10;
        
        suggesionCell.moreBtn_view.frame = frame1;
        
        if (suggesionCell.moreBtn_view.hidden == YES) {
            
            frame1 = suggesionCell.listing_view.frame;
            
            frame1.size.height = suggesionCell.type_city_lbl.frame.origin.y+ suggesionCell.type_city_lbl.frame.size.height +5;
            
            suggesionCell.listing_view.frame = frame1;
            
        }
        
        else{
            
            frame1 = suggesionCell.listing_view.frame;
            
            frame1.size.height = suggesionCell.moreBtn_view.frame.origin.y+ suggesionCell.moreBtn_view.frame.size.height;
            
            suggesionCell.listing_view.frame = frame1;
            
        }
        
        NSString *imageURL = [[[suggesionArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"picture0"];
        
        for (int i = 1; i<4; i++) {
            
            NSString *pic = [NSString stringWithFormat:@"picture%d",i];
            
            if ([imageURL length] < 1) {
                
                imageURL = [[[suggesionArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:pic];
            }
        }
        
        imageURL = [imageURL stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
        
        suggesionCell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
        
        if ([imageURL length] < 1) {
            
            //Listing_Image
            suggesionCell.image_view.image = [UIImage imageNamed:@"Listing_Image"];
            
        } else {
            
            imageURL = [url stringByAppendingString:imageURL];
            
            [suggesionCell.image_view sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Listing_Image"]];
        }
        
        return suggesionCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = self.storyboard;
    
    if (indexPath.section == 0) {
        
        
        //       listing = [[mylistingArray objectAtIndex:indexPath.row] valueForKey:@"model"] ;
        //
        //        if ([listing isEqualToString:@"CourseListing"]) {
        //
        //            listing = @"CourseListing";
        //            type_name = @"course_name";
        //
        //        } else if ([listing isEqualToString:@"LessonListing"]){
        //
        //            listing = @"LessonListing";
        //            type_name = @"lession_name";
        //
        //        }  else if ([listing isEqualToString:@"EventListing"]){
        //
        //            listing = @"EventListing";
        //            type_name = @"event_name";
        //        }
        //
        //        NSString *course_id = [[[mylistingArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"id"];
        //
        //        NSLog(@"Course Tap Id%@", course_id);
        //
        //        [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
        //
        //        if ([listing isEqualToString:@"CourseListing"]) {
        //
        //            CourseDetailViewController *CourseVC = [[CourseDetailViewController alloc] init];
        //
        //            CourseVC = [storyboard instantiateViewControllerWithIdentifier:@"courseDetail"];
        //
        //            [self.navigationController pushViewController:CourseVC animated:NO];
        //
        //        } else if ([listing isEqualToString:@"LessonListing"]){
        //
        //            LessionDetailViewController *LessonVC = [[LessionDetailViewController alloc] init];
        //
        //            LessonVC = [storyboard instantiateViewControllerWithIdentifier:@"lessionDetail"];
        //
        //            [self.navigationController pushViewController:LessonVC animated:NO];
        //
        //        }  else if ([listing isEqualToString:@"EventListing"]){
        //
        //            EventViewController *EventVC = [[EventViewController alloc] init];
        //
        //            EventVC = [storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
        //
        //            [self.navigationController pushViewController:EventVC animated:NO];
        //        }
        
    }  else if (indexPath.section == 1) {
        
        listing = [[favArray objectAtIndex:indexPath.row] valueForKey:@"model"] ;
        
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
        
        NSString *course_id = [[[favArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"id"];
        
        NSLog(@"Course Tap Id%@", course_id);
        
        [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
        
        if ([listing isEqualToString:@"CourseListing"]) {
            
            CourseDetailViewController *CourseVC = [[CourseDetailViewController alloc] init];
            
            CourseVC = [storyboard instantiateViewControllerWithIdentifier:@"courseDetail"];
            
            [self.navigationController pushViewController:CourseVC animated:NO];
            
        } else if ([listing isEqualToString:@"LessonListing"]){
            
            LessionDetailViewController *LessonVC = [[LessionDetailViewController alloc] init];
            
            LessonVC = [storyboard instantiateViewControllerWithIdentifier:@"lessionDetail"];
            
            [self.navigationController pushViewController:LessonVC animated:NO];
            
        }  else if ([listing isEqualToString:@"EventListing"]){
            
            EventViewController *EventVC = [[EventViewController alloc] init];
            
            EventVC = [storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
            
            [self.navigationController pushViewController:EventVC animated:NO];
        }
        
    } else {
        
        listing = [[suggesionArray objectAtIndex:indexPath.row] valueForKey:@"model"] ;
        
        NSString *status_type, *discription;
        
        NSString *url;
        
        if ([listing isEqualToString:@"CourseListing"]) {
            
            listing = @"CourseListing";
            type_name = @"course_name";
            status_type = @"course_status";
            url = CourseImageURL;
            discription = @"course_description";
            
        } else if ([listing isEqualToString:@"LessonListing"]) {
            
            listing = @"LessonListing";
            type_name = @"lesson_name";
            status_type = @"lession_status";
            url = LessonImageURL;
            discription = @"lesson_description";
            
        } else if ([listing isEqualToString:@"EventListing"]) {
            
            listing = @"EventListing";
            type_name = @"event_name";
            status_type = @"event_status";
            url = EventImageURL;
            discription = @"event_description";
            
        }
        
        NSString *course_id = [[[suggesionArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"id"];
        
        NSLog(@"Course Tap Id%@", course_id);
        
        [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
        
        if ([listing isEqualToString:@"CourseListing"]) {
            
            CourseDetailViewController *CourseVC = [[CourseDetailViewController alloc] init];
            
            CourseVC = [storyboard instantiateViewControllerWithIdentifier:@"courseDetail"];
            
            [self.navigationController pushViewController:CourseVC animated:NO];
            
        } else if ([listing isEqualToString:@"LessonListing"]){
            
            LessionDetailViewController *LessonVC = [[LessionDetailViewController alloc] init];
            
            LessonVC = [storyboard instantiateViewControllerWithIdentifier:@"lessionDetail"];
            
            [self.navigationController pushViewController:LessonVC animated:NO];
            
        }  else if ([listing isEqualToString:@"EventListing"]){
            
            EventViewController *EventVC = [[EventViewController alloc] init];
            
            EventVC = [storyboard instantiateViewControllerWithIdentifier:@"eventDetail"];
            
            [self.navigationController pushViewController:EventVC animated:NO];
        }
        
    }
}

-(void)tapCategory:(UITapGestureRecognizer*)sender {
    
    UIView *l = sender.view;
    
    NSString *idStr = [catIdArray objectAtIndex:l.tag];
    
    [self.tabBarController setSelectedViewController:[self.tabBarController.viewControllers objectAtIndex:2]];
    
    [[NSUserDefaults standardUserDefaults] setValue:idStr forKey:@"category_id"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tapcategoryBtn" object:idStr];
    
}

-(void)tapToFavPin_Btn:(UIButton *)sender {
    
    
    NSString *type_str, *list_id;
    
    listing = [[favArray objectAtIndex:sender.tag] valueForKey:@"model"];
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        list_id = [[[favArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"id"];
        
        type_str = @"1";
        
    } else if ([listing isEqualToString:@"LessonListing"]) {
        
        list_id = [[[favArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"id"];
        
        type_str = @"3";
        
    } else if ([listing isEqualToString:@"EventListing"]) {
        
        list_id = [[[favArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"id"];
        
        type_str = @"2";
    }
    NSDictionary *paramURL;
    
    NSString *msg;
    
    paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":list_id, @"type":type_str, @"un_fav":@"1"};
    
    msg = @"successfully Unfavorite";
    
    // paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":course_id, @"type":type_str, @"un_fav":@"1"};
    
    msg = @"You have successfully unpinned this listing from your Favorites.";
    
    [pinTOFavConnection startConnectionWithString:@"add_favorite" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if([pinTOFavConnection responseCode] == 1) {
            
            NSLog(@"%@",receivedData);
            
            if([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                [sender setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                
                [self fetchData];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
        }
    }];
    
}



-(void)tapFavBtn:(UIButton *)sender {
    
    [self.view addSubview:indicator];
    
    NSString *type_str, *list_id;
    
    listing = [[suggesionArray objectAtIndex:sender.tag] valueForKey:@"model"];
    
    if ([listing isEqualToString:@"CourseListing"]) {
        
        list_id = [[[suggesionArray objectAtIndex:sender.tag] valueForKey:@"CourseListing"] valueForKey:@"id"];
        
        type_str = @"1";
        
    } else if ([listing isEqualToString:@"LessonListing"]) {
        
        list_id = [[[suggesionArray objectAtIndex:sender.tag] valueForKey:@"LessonListing"] valueForKey:@"id"];
        
        type_str = @"3";
        
    } else if ([listing isEqualToString:@"EventListing"]) {
        
        list_id = [[[suggesionArray objectAtIndex:sender.tag] valueForKey:@"EventListing"] valueForKey:@"id"];
        
        type_str = @"2";
    }
    
    NSDictionary *paramURL;
    
    NSString *msg;
    
    NSLog(@"%@",[FAVarray objectAtIndex:sender.tag]);
    
    if ([[FAVarray objectAtIndex:sender.tag] isEqualToString:@"YES"]) {
        
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":list_id, @"type":type_str, @"un_fav":@"1"};
        
        msg = @"You have successfully unpinned this listing from your Favorites.";
        
    } else {
        
        paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"list_id":list_id, @"type":type_str};
        
        msg = @"You have successfully pinned this listing to your Favorites";
    }
    
    [pinTOFavConnection startConnectionWithString:@"add_favorite" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if([pinTOFavConnection responseCode] == 1) {
            
            NSLog(@"%@",receivedData);
            
            if([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                [sender setBackgroundImage:[UIImage imageNamed:@"favPin_yellow"] forState:UIControlStateNormal];
                
                [self fetchData];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
        }
    }];
}

-(void)tap_SuggViewMore:(UIButton *)sender{
    
    isSugg = YES;
    
    [self performSegueWithIdentifier:@"FavViewMoreSegue" sender:self];
}

-(void)tap_favViewMore:(UIButton *)sender{
    
    isSugg = NO;
    
    [self performSegueWithIdentifier:@"FavViewMoreSegue" sender:self];
}

-(void)downloadImageWithString:(NSString *)urlString indexPath:(NSIndexPath *)indexPath ForCell:(NSString *)cell {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            if ([cell isEqualToString:@"ListingCell"]) {
                
                MyListingCell = (HomeMyListingTableCell *)[self.msgtable_view cellForRowAtIndexPath:indexPath];
                
                MyListingCell.mylisting_imgview.image = image;
                
            } else if ([cell isEqualToString:@"FavCell"]) {
                
                favCell = (HomeFavoritesTableCell *) [self.msgtable_view cellForRowAtIndexPath:indexPath];
                
                favCell.favImg_view.image = image;
                
            } else if ([cell isEqualToString:@"SuggesionCell"]) {
                
                suggesionCell = (SuggestionTableViewCell *) [self.msgtable_view cellForRowAtIndexPath:indexPath];
                
                suggesionCell.image_view.image = image;
            }
        }
    }];
}

@end

