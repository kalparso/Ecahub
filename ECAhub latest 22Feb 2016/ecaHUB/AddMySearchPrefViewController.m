//
//  AddMySearchPrefViewController.m
//  ecaHUB
//
//  Created by promatics on 5/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AddMySearchPrefViewController.h"
#import "PopUpView.h"
#import "TabBarViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "searchprefrnce.h"
#import "AddFriends.h"

@interface AddMySearchPrefViewController () {
    
    WebServiceConnection *locationConn;
    
    WebServiceConnection *getCategoryConn;
    
    Indicator *indicator;
    
    WebServiceConnection *addSearchConn;
    
    AddFriends *addFrndVC;
    
    PopUpView *pop_view;
    
    UIStoryboard *storyboard;
    
    UIPickerView *pickerView;
    
    UIToolbar *toolBar;
    
    UIBarButtonItem *cancelButton;
    
    UIBarButtonItem *doneButton;
    
    BOOL isCountry;
    
    BOOL isState;
    
    BOOL isCity;
    
    NSString *city_id;
    
    NSString *country_id;
    
    NSString *state_id;
    
    NSMutableArray *countryArray;
    
    NSMutableArray *locationArray;
    
    NSMutableArray *stateArray;
    
    NSArray *array_interest;
    
    NSString *catIDs;
    
    NSString *sub_catIds, *selecteddata;
    
    NSMutableArray *list_dataArray;
    
    NSMutableArray *cat_subCat_arr;
}
@end

@implementation AddMySearchPrefViewController

@synthesize countryBtn, stateBtn, cityBtn, categoryBtn, saveBtn;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     //self.navigationController.navigationBar.topItem.title = @"";
    
    countryArray = [[NSMutableArray alloc] init];
    
    stateArray = [[NSMutableArray alloc] init];
    
    locationArray = [[NSMutableArray alloc] init];
    
    list_dataArray = [[NSMutableArray alloc] init];
    
    cat_subCat_arr = [[NSMutableArray alloc] init];
    
    addSearchConn = [WebServiceConnection connectionManager];
    
    locationConn = [WebServiceConnection connectionManager];
    
    getCategoryConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapLater:) name:@"tapLaterSearchFriends" object:nil];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
        
        pop_view = [[[NSBundle mainBundle] loadNibNamed:@"popup" owner:self options:nil] objectAtIndex:0];
        
        pop_view.frame = self.view.frame;
        
        pop_view.VC = @"3";
        
        pop_view.message.text = @"Find what you want quickly by saving your preferred categories. Once you have set your preferences here, you can filter “What’s On!” and other search results using ‘My Search Preferences’.";
        
        [self.view addSubview:pop_view];
    }
    
    isCountry = NO;
    
    isState = NO;
    
    isCity = NO;
    
    countryBtn.layer.borderWidth = 1.0f;
    
    countryBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    countryBtn.layer.cornerRadius = 5.0f;
    
    stateBtn.layer.borderWidth = 1.0f;
    
    stateBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    stateBtn.layer.cornerRadius = 5.0f;
    
    cityBtn.layer.borderWidth = 1.0f;
    
    cityBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    cityBtn.layer.cornerRadius = 5.0f;
    
    categoryBtn.layer.borderWidth = 1.0f;
    
    categoryBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    categoryBtn.layer.cornerRadius = 5.0f;
    
    saveBtn.layer.cornerRadius = 5.0f;
    
   // categoryBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self fetchRequiredData];
    
    [self setDetails];
}


-(void)setDetails {
    
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"code"] integerValue] == 1) {
        
        NSString *location = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"search_info"] valueForKey:@"Country"] valueForKey:@"country_name"];
        
        country_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"search_info"] valueForKey:@"Country"] valueForKey:@"id"];
        
        [countryBtn setTitle:[NSString stringWithFormat:@"  %@",location] forState:UIControlStateNormal];
        
        location = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"search_info"] valueForKey:@"State"] valueForKey:@"state_name"];
        
        state_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"search_info"] valueForKey:@"State"] valueForKey:@"id"];
        
        [stateBtn setTitle:[NSString stringWithFormat:@"  %@",location] forState:UIControlStateNormal];
        
        location = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"search_info"] valueForKey:@"City"] valueForKey:@"city_name"];
        
        city_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"search_info"] valueForKey:@"City"] valueForKey:@"id"];
        
        [cityBtn setTitle:[NSString stringWithFormat:@"  %@",location] forState:UIControlStateNormal];
        
         NSArray *sub_array = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"subcat_names"] objectAtIndex:0];
        
        NSMutableArray *subCatAyyay = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < sub_array.count; i++) {
            
            [subCatAyyay addObject:[[[sub_array objectAtIndex:i] valueForKey:@"Subcategory"] valueForKey:@"subcategory_name"]];
        }
        
        NSString *cat = [subCatAyyay componentsJoinedByString:@", "];
        
        selecteddata = [subCatAyyay componentsJoinedByString:@", "];
        
        cat = [@"  " stringByAppendingString:cat];
        
        [categoryBtn setTitle:cat forState:UIControlStateNormal];
        
        catIDs = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"search_info"] valueForKey:@"SearchPreference"] valueForKey:@"category_id"];
        
        sub_catIds = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"search_info"] valueForKey:@"SearchPreference"] valueForKey:@"subcategory_id"];
    }
}

-(void) tapLater :(NSNotification *) notification {
    
//    storyboard = self.storyboard;
//    
//    TabBarViewController *tabbar = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
//    
//    [self presentViewController:tabbar animated:YES completion:nil];
//    
//    NSString *message = @"Welcome to ECAhub! Before you get started, please check your email inbox and junk mail folder for the verification email sent to you.";
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
    
    //[self performSegueWithIdentifier:@"friendsSague" sender:self];
    UIStoryboard *storyBoard = self.storyboard;
    
    addFrndVC = [storyBoard instantiateViewControllerWithIdentifier:@"addFriend"];
    
    [self.navigationController pushViewController:addFrndVC animated:YES];
}

- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];
}

- (IBAction)tapCountryBtn:(id)sender {
    
    isCity = NO;
    isState = NO;
    isCountry = YES;
    [stateBtn setTitle:@"  Select" forState:UIControlStateNormal];
    
    [cityBtn setTitle:@"  Select" forState:UIControlStateNormal];
    
    [self fetchLocation:@"country"];
}

- (IBAction)tapStateBtn:(id)sender {
    
    if ([country_id length] > 0) {
        
        isCity = NO;
        isState = YES;
        isCountry = NO;
        
        [self fetchLocation:@"state"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please select country first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    [cityBtn setTitle:@"  Select" forState:UIControlStateNormal];
}

- (IBAction)tapCityBtn:(id)sender {
    
    if ([state_id length] > 0) {
        
        isCity = YES;
        isState = NO;
        isCountry = NO;
        
        [self fetchLocation:@"city"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please select state first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

-(void)fetchLocation:(NSString *)url {
    
    NSDictionary *paramURL;
    
    if (isCountry) {
        
        paramURL = @{};
        
    } else if (isState){
        
        paramURL = @{@"country_id" : country_id};
        
    } else if (isCity) {
        
        paramURL = @{@"state_id" : state_id};
    }
    
    [self.view addSubview:indicator];
    
    [locationConn startConnectionWithString:url HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([locationConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if (isCountry) {
                
                countryArray = [[receivedData valueForKey:@"country"] mutableCopy];
                
                NSDictionary *dict = @{@"Country":@{@"country_name":@"Select", @"id":@""}};
                
                [countryArray insertObject:dict atIndex:0];
                
                [self showPicker];
                
            } else if (isState){
                
                stateArray = [[receivedData valueForKey:@"state"] mutableCopy];
                
                NSDictionary *dict = @{@"State":@{@"state_name":@"Select", @"id":@""}};
                
                [stateArray insertObject:dict atIndex:0];
                
                [self showPicker];
                
            } else if (isCity) {
                
                locationArray = [[receivedData valueForKey:@"city"] mutableCopy];
                
                NSDictionary *dict = @{@"City":@{@"city_name":@"Select", @"id":@""}};
                
                [locationArray insertObject:dict atIndex:0];
                
                [self showPicker];
            }
        }
    }];
}

#pragma  mark - get Interest List

-(void)fetchRequiredData {
    
    NSDictionary *paramUrl = @{ };
    
    [getCategoryConn startConnectionWithString:[NSString stringWithFormat:@"interested_list"] HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary *recievdData) {
        
        NSLog(@"%@",recievdData);
        
        if ([getCategoryConn responseCode] == 1) {
            
            array_interest = (NSArray *)recievdData;
            
            [self setListData];
        }
    }];
}

-(void) setListData {
    
    list_dataArray = [[NSMutableArray alloc] init];
    
    cat_subCat_arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < array_interest.count; i++) {
        
        [list_dataArray addObject:@{@"type" : @"Category", @"categoryIndex" : [NSNumber numberWithInt:i], @"subCatIndex" : @"0"}];
        
        for (int j=0; j < [[[array_interest objectAtIndex:i] valueForKey:@"Subcategory"] count]; j++) {
            
            [list_dataArray addObject:@{@"type" : @"SubCategory", @"categoryIndex" : [NSNumber numberWithInt:i], @"subCatIndex" : [NSNumber numberWithInt:j]}];
        }
    }
    
    for (int i = 0; i<list_dataArray.count; i++) {
        
        if ([[[list_dataArray objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"Category"]) {
            
            NSNumber *cat_index = [[list_dataArray objectAtIndex:i] valueForKey:@"categoryIndex"];
            
            [cat_subCat_arr addObject:[[array_interest objectAtIndex:[cat_index integerValue]] valueForKey:@"Category"]];
            
        } else {
            
            NSNumber *cat_index = [[list_dataArray objectAtIndex:i] valueForKey:@"categoryIndex"];
            
            NSNumber *sub_catIndex = [[list_dataArray objectAtIndex:i] valueForKey:@"subCatIndex"];
            
            [cat_subCat_arr addObject:[[[array_interest objectAtIndex:[cat_index integerValue]] valueForKey:@"Subcategory"] objectAtIndex:[sub_catIndex integerValue]]];
        }
    }
    NSLog(@"%@", cat_subCat_arr);
}

- (IBAction)tapIntrestBtn:(id)sender {
    
    [self fetchRequiredData];
    
    if (array_interest == nil || array_interest.count < 1 ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Interest List" message:@"Please wait while interest list is loading" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        
        return;
    }
    
    NSString *cat = categoryBtn.titleLabel.text;
    
    cat = [cat stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self showListData:list_dataArray allowMultipleSelection:YES selectedData:[cat componentsSeparatedByString:@", "] title:@"Interests"];

}

-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title {
    
    ListViewController *listViewController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"ListView"];
        
    } else {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil] instantiateViewControllerWithIdentifier:@"ListView"];
    }
    
    listViewController.isMultipleSelected = allowMultipleSelection;
    
    listViewController.array_data = [array_interest mutableCopy];
    
    listViewController.data_typeArray = items;
    
    listViewController.selectedData = selectedData;
    
    listViewController.delegate = self;
    
    listViewController.title = title;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - list delegate

-(void)didSaveItems:(NSArray*)items indexs:(NSArray*)indexs {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *array_selectedInterest = [NSMutableArray array];
    
    NSMutableArray *array_catIds = [NSMutableArray array];
    
    NSMutableArray *array_subCatIds = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in indexs) {
        
        id name = [cat_subCat_arr[indexPath.row] valueForKey:@"subcategory_name"];
        
        if (name) {
            
            [array_selectedInterest addObject:[cat_subCat_arr[indexPath.row] valueForKey:@"subcategory_name"]];
            
            [array_subCatIds addObject:[cat_subCat_arr[indexPath.row] valueForKey:@"id"]];
            
            [array_catIds addObject:[cat_subCat_arr[indexPath.row] valueForKey:@"category_id"]];
            
        } else {
            
            [array_catIds addObject:[cat_subCat_arr[indexPath.row] valueForKey:@"id"]];
        }
    }
    
    [array_catIds setArray:[[NSSet setWithArray:array_catIds] allObjects]];
    
    NSString *cat_interest = [array_selectedInterest componentsJoinedByString:@", "];
    
    cat_interest = [@"  " stringByAppendingString:cat_interest];
    
    [categoryBtn setTitle:cat_interest forState:UIControlStateNormal];
    
    [categoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    catIDs = [array_catIds componentsJoinedByString:@","];
    
    sub_catIds = [array_subCatIds componentsJoinedByString:@","];
    
    NSLog(@"%@\n%@", catIDs,sub_catIds);
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapSaveBtn:(id)sender {
    
    NSString *message ;
    
    if ([countryBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please Select Country";
    
    } else if ([stateBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please Select Select";
    
    } else if ([cityBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please Select City";
    
    } else if ([categoryBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please Select Interests Category";
    }
    
    if ([message length] > 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
   
    } else {

        //member_id, category_id, subcategory_id, country_id, state_id, city_id
        [self.view addSubview:indicator];
        
        NSDictionary *paramURL;
        
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"code"] integerValue] == 1) {
             
             NSString *search_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"MySearchPrefData"] valueForKey:@"search_info"] valueForKey:@"SearchPreference"] valueForKey:@"id"];
             
             paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"category_id":catIDs, @"subcategory_id":sub_catIds, @"country_id":country_id, @"state_id":state_id, @"city_id":city_id,@"id":search_id};
         
         } else {
             
             paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"category_id":catIDs, @"subcategory_id":sub_catIds, @"country_id":country_id, @"state_id":state_id, @"city_id":city_id};
         }
        
        NSLog(@"%@", paramURL);
        
        [addSearchConn startConnectionWithString:@"add_search_preference" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
            
            [indicator removeFromSuperview];
            
            if ([addSearchConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
                    
                    NSString *message = @"Welcome to ECAhub! Before you get started, please check your email inbox and junk mail folder for the verification email sent to you.";
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    storyboard = self.storyboard;
                    
                    TabBarViewController *tabbar = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
                    
                    [self presentViewController:tabbar animated:YES completion:nil];

                } else {
                    
                    if ([[receivedData valueForKey:@"code"]integerValue]==1) {
                     
                         //[self.navigationController popToRootViewControllerAnimated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }else{
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"There is some problem.please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alert show];
                        
                    }
                }
            }
            
        }];
    }
}

- (IBAction)tap_infocircle:(id)sender {
    
    UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Only regions where ECAhub currently operates is offered in this list. If you live somewhere else, feel free to contact us about when ECAhub will be available in your region." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [infoAlert show];
}

-(void) showPicker {
    
    [toolBar removeFromSuperview];
    
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
    
    [cancelButton setWidth:20];
    
    doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
    
    [cancelButton setWidth:50];
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    CGRect frame = pickerView.frame;
    
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    
    frame.size.width = self.view.frame.size.width;
    
    pickerView.frame = frame;
    
    pickerView.backgroundColor = [UIColor lightGrayColor];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- pickerView.frame.size.height) - 44, self.view.frame.size.width, 44)];
    
    toolBar.backgroundColor = [UIColor darkGrayColor];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[cancelButton,flexibleItem, doneButton];
    
    [self.view addSubview:toolBar];
    
    [self.view addSubview:pickerView];
}

-(void)cancelKeyboard:(UIBarButtonItem *)sender {
    
    [countryBtn setTitle:@"  Country" forState:UIControlStateNormal];
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
}

-(void)doneKeyboard:(UIBarButtonItem *)sender {
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
}

#pragma mark - PickerView Delegates & Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (isCountry) {
       
        return countryArray.count;
        
    } else if (isState){
        
        return stateArray.count;
        
    } else {
        
       return locationArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    if (isCountry) {
        
        return [[[countryArray objectAtIndex:row] valueForKey:@"Country"] valueForKey:@"country_name"];
        
    } else if (isState){
        
        return [[[stateArray objectAtIndex:row] valueForKey:@"State"] valueForKey:@"state_name"];
        
    } else {
        
        return [[[locationArray objectAtIndex:row] valueForKey:@"City"] valueForKey:@"city_name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (isCountry) {
        
        NSString *name = [[[countryArray objectAtIndex:row] valueForKey:@"Country"] valueForKey:@"country_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [countryBtn setTitle:name forState:UIControlStateNormal];
        
        country_id = [[[countryArray objectAtIndex:row] valueForKey:@"Country"] valueForKey:@"id"];
        
        
        
    } else if (isState){
        
        NSString *name = [[[stateArray objectAtIndex:row] valueForKey:@"State"] valueForKey:@"state_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [stateBtn setTitle:name forState:UIControlStateNormal];
        
        state_id = [[[stateArray objectAtIndex:row] valueForKey:@"State"] valueForKey:@"id"];
        
    } else if (isCity) {
        
        NSString *name = [[[locationArray objectAtIndex:row] valueForKey:@"City"] valueForKey:@"city_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [cityBtn setTitle:name forState:UIControlStateNormal];
                
        city_id = [[[locationArray objectAtIndex:row] valueForKey:@"City"] valueForKey:@"id"];
    }
}

//-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title {
//    
//    ListingViewController *listViewController;
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        
//        listViewController = [[UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"listingVC"];
//        
//    } else {
//        
//        listViewController = [[UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil] instantiateViewControllerWithIdentifier:@"listingVC"];
//    }
//    
//    listViewController.isMultipleSelected = allowMultipleSelection;
//    
//    listViewController.array_data = [items mutableCopy];
//    
//    listViewController.selectedData = [selectedData mutableCopy];
//    
//    listViewController.delegate = self;
//    
//    listViewController.title = title;
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listViewController];
//    
//    [self presentViewController:nav animated:YES completion:nil];
//    
//}
//
//#pragma mark - list delegate
//
//-(void)didSelectListItem:(id)item index:(NSInteger)index{
//    
//    
//    if (isCountry) {
//        
//        NSString *name = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"country_name"];
//        
//        name = [@"  " stringByAppendingString:name];
//        
//        [countryBtn setTitle:name forState:UIControlStateNormal];
//        
//        country_id = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"id"];
//        
//    } else if (isState){
//        
//        NSString *name = [[[stateArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"state_name"];
//        
//        name = [@"  " stringByAppendingString:name];
//        
//        [stateBtn setTitle:name forState:UIControlStateNormal];
//        
//        state_id = [[[stateArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"id"];
//        
//    } else if (isCity) {
//        
//        NSString *name = [[[locationArray objectAtIndex:index] valueForKey:@"City"] valueForKey:@"city_name"];
//        
//        name = [@"  " stringByAppendingString:name];
//        
//        [cityBtn setTitle:name forState:UIControlStateNormal];
//        
//        city_id = [[[locationArray objectAtIndex:index] valueForKey:@"City"] valueForKey:@"id"];
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//-(void)didCancel {
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//

@end
