//
//  EditEventEduViewController.m
//  ecaHUB
//
//  Created by promatics on 4/7/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EditEventEduViewController.h"
#import "Validation.h"
#import "WebServiceConnection.h"
#import "Indicator.h"

@interface EditEventEduViewController () {
    
    UIPickerView *pickerView;
    
    UIImagePickerController * imagePicker;
    
    NSMutableArray *images;
    
    UIToolbar *toolBar;
    
    UIBarButtonItem *cancelButton;
    
    UIBarButtonItem *doneButton;
    
    NSArray *businessTypeArray;
    
    id activeField;
    
    NSString *business_typeId;
    
    NSString *offersId;
    
    NSArray *offersArray;
    
    Validation *validationObj;
    
    BOOL isCountry;
    
    BOOL isState;
    
    BOOL isCity;
    
    NSString *city_id;
    
    NSString *country_id;
    
    NSString *state_id,*isdelete;
    
    NSArray *countryArray;
    
    NSArray *locationArray;
    
    NSArray *stateArray;
    
    WebServiceConnection *locationConnection;
    
    Indicator *indicator;
}
@end

@implementation EditEventEduViewController

@synthesize scrollView, descriptionTxtView, char_limitLbl, educator_name, business_type, choose_imgBtn, img_selectLbl, address, district, town, city, established_year, offerTxtField, saveBtn, publishBtn, cancelBtn, offersBtn, countryBtn, stateBtn, cityBtn, building_name, number_street;

- (void)viewDidLoad {
    [super viewDidLoad];
    
     //self.navigationController.navigationBar.topItem.title = @"";
    
        validationObj = [Validation validationManager];
    
    locationConnection = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    isCountry = NO;
    
    isState = NO;
    
    isCity = NO;
    
    
    
    country_id = [[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"country_id"];
    state_id = [[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"state_id"];
    city_id = [[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"city_id"];
    
    NSString *strValue = [[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"city_name"];
    
    strValue = [@" " stringByAppendingString:strValue];
    
    [cityBtn setTitle:strValue forState:UIControlStateNormal];
    
    strValue = [[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"state_name"] ;
    
    strValue = [@" " stringByAppendingString:strValue];
    
    [stateBtn setTitle:strValue forState:UIControlStateNormal];
    
    strValue = [[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"country_name"] ;
    
    strValue = [@" " stringByAppendingString:strValue];
    
    [countryBtn setTitle:strValue forState:UIControlStateNormal];

    
//    [countryBtn setTitle:[[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"country_name"] forState:UIControlStateNormal];
//    [stateBtn setTitle:[[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"state_name"] forState:UIControlStateNormal];
//    
//    [cityBtn setTitle:[[[NSUserDefaults standardUserDefaults] valueForKey:@"location_data"] valueForKey:@"city_name"] forState:UIControlStateNormal];
    
    [self prepareInterface];
    countryBtn.userInteractionEnabled = NO;
    stateBtn.userInteractionEnabled = NO;
    cityBtn.userInteractionEnabled = NO;
    educator_name.userInteractionEnabled = NO;
}

-(void) prepareInterface {
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1800);
        
        CGRect frame = educator_name.frame;
        
        frame.size.height = 45.0f;
        
        educator_name.frame = frame;
        
        frame = business_type.frame;
        
        frame.size.height = 45.0f;
        
        business_type.frame = frame;
        
        frame = address.frame;
        
        frame.size.height = 45.0f;
        
        address.frame = frame;
        
        frame = city.frame;
        
        frame.size.height = 45.0f;
        
        city.frame = frame;
        
        frame = district.frame;
        
        frame.size.height = 45.0f;
        
        district.frame = frame;
        
        frame = town.frame;
        
        frame.size.height = 45.0f;
        
        town.frame = frame;
        
        frame = established_year.frame;
        
        frame.size.height = 45.0f;
        
        established_year.frame = frame;
        
        frame = offerTxtField.frame;
        
        frame.size.height = 45.0f;
        
        offerTxtField.frame = frame;
        
        frame = building_name.frame;
        
        frame.size.height = 45.0f;
        
        building_name.frame = frame;
        
        frame = number_street.frame;
        
        frame.size.height = 45.0f;
        
        number_street.frame = frame;
        
        choose_imgBtn.layer.cornerRadius = 10.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1500);
        
        choose_imgBtn.layer.cornerRadius = 15.0f;
    }
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    [scrollView addGestureRecognizer:tapScroll];
    
    countryBtn.layer.borderWidth = 1.0f;
    
    countryBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    countryBtn.layer.cornerRadius = 5.0f;
    
    stateBtn.layer.borderWidth = 1.0f;
    
    stateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    stateBtn.layer.cornerRadius = 5.0f;
    
    cityBtn.layer.borderWidth = 1.0f;
    
    cityBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    cityBtn.layer.cornerRadius = 5.0f;
    
    choose_imgBtn.layer.borderWidth = 1.0f;
    
    choose_imgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    offersBtn.layer.borderWidth = 1.0f;
    
    offersBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    offersBtn.layer.cornerRadius = 5.0f;
    
    saveBtn.layer.cornerRadius = 5.0f;
    
    publishBtn.layer.cornerRadius = 5.0f;
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    descriptionTxtView.layer.borderWidth = 1.0f;
    
    descriptionTxtView.layer.borderColor = [UIColor blackColor].CGColor;
    
    descriptionTxtView.layer.cornerRadius = 5.0f;
    
    educator_name.layer.borderWidth = 1.0f;
    
    educator_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    educator_name.layer.cornerRadius = 5.0f;
    
    business_type.layer.borderWidth = 1.0f;
    
    business_type.layer.borderColor = [UIColor blackColor].CGColor;
    
    business_type.layer.cornerRadius = 5.0f;
    
    address.layer.borderWidth = 1.0f;
    
    address.layer.borderColor = [UIColor blackColor].CGColor;
    
    address.layer.cornerRadius = 5.0f;
    
    building_name.layer.borderWidth = 1.0f;
    
    building_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    building_name.layer.cornerRadius = 5.0f;
    
    number_street.layer.borderWidth = 1.0f;
    
    number_street.layer.borderColor = [UIColor blackColor].CGColor;
    
    number_street.layer.cornerRadius = 5.0f;
    
    city.layer.borderWidth = 1.0f;
    
    city.layer.borderColor = [UIColor blackColor].CGColor;
    
    city.layer.cornerRadius = 5.0f;
    
    district.layer.borderWidth = 1.0f;
    
    district.layer.borderColor = [UIColor blackColor].CGColor;
    
    district.layer.cornerRadius = 5.0f;
    
    town.layer.borderWidth = 1.0f;
    
    town.layer.borderColor = [UIColor blackColor].CGColor;
    
    town.layer.cornerRadius = 5.0f;
    
    established_year.layer.borderWidth = 1.0f;
    
    established_year.layer.borderColor = [UIColor blackColor].CGColor;
    
    established_year.layer.cornerRadius = 5.0f;
    
    offerTxtField.layer.borderWidth = 1.0f;
    
    offerTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    offerTxtField.layer.cornerRadius = 5.0f;
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    business_type.inputView = pickerView;
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePickerView)];
    
    tapgest.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapgest];
    
    businessTypeArray = @[@{@"id":@"0",@"name":@"Select"}, @{@"id":@"0",@"name":@"Private Person"}, @{@"id":@"1",@"name":@"Sole Proprietor"}, @{@"id":@"2",@"name":@"Partnership"}, @{@"id":@"3",@"name":@"Private Company"}, @{@"id":@"4",@"name":@"Non-Profit"}];
    
    //[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"]valueForKey:@"TermsRefund"] valueForKey:@"title"]]
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]);
    
    descriptionTxtView.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"description_educator"];
    
    if ([[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"post_status"] isEqualToString:@"1"]) {
        
        educator_name.userInteractionEnabled = NO;
        
    } else {
        
        educator_name.userInteractionEnabled = YES;
    }
    
    educator_name.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"name_educator"];
    
    business_type.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"BusinessType"] valueForKey:@"title"];
    
    address.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_venu_unit"];
    
    building_name.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_venu_building_name"];
    
    number_street.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_venu_street"];
    
    district.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_venu_district"];
    
    NSString *strValue;// = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"author_city"] valueForKey:@"city_name"];
    
//    strValue = [@"  " stringByAppendingString:strValue];
//    
//    [cityBtn setTitle:strValue forState:UIControlStateNormal];
//    
//    strValue = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"author_state"] valueForKey:@"state_name"];
//    
//    strValue = [@"  " stringByAppendingString:strValue];
//    
//    [stateBtn setTitle:strValue forState:UIControlStateNormal];
//    
//    strValue = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"author_country"] valueForKey:@"country_name"] ;
//    
//    strValue = [@"  " stringByAppendingString:strValue];
//    
//    [countryBtn setTitle:strValue forState:UIControlStateNormal];
    
    established_year.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"year"];
    
    strValue = [[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"offer_names"];
    
    strValue = [@"  " stringByAppendingString:strValue];
    
    [offersBtn setTitle:strValue forState:UIControlStateNormal];
    
    [self setData];
}

-(void) setData {
    
    NSString *descriptionStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"description_educator"];
    
    NSString *educator_nameStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"name_educator"];
    
    business_typeId = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"BusinessType"] valueForKey:@"id"];
    
    NSString *addressStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_venu_unit"];
    
    NSString *building_nameStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_venu_building_name"];
    
    NSString *number_streetStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_venu_street"];
    
    NSString *districtStr = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_venu_district"];
    
//    country_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_country_id"];
//    
//    state_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_state_id"];
//    
//    city_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"author_city_id"];
    
    NSString *year = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"year"];
    
    offersId = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"offer"];
    
    NSDictionary *educatorData = @{@"description_educator":descriptionStr, @"name_educator":educator_nameStr, @"business_type":business_typeId, @"author_venu_unit":addressStr,@"author_venu_building_name" : building_nameStr,  @"author_venu_street" : number_streetStr, @"author_venu_district":districtStr, @"author_country_id":country_id, @"author_state_id" : state_id, @"author_city_id":city_id, @"year":year, @"offer":offersId, @"identity":@""};
    
    NSLog(@"%@", educatorData);
    
    [[NSUserDefaults standardUserDefaults] setValue:educatorData forKey:@"educator_data"];
}

#pragma mark - Hide Picker View

-(void)hidePickerView {
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
}

-(void)cancelKeyboard:(UIBarButtonItem *)sender {
    
    business_type.text = @"Select Type";
    
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
    
    return businessTypeArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [[businessTypeArray objectAtIndex:row] valueForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [business_type setText:[[businessTypeArray objectAtIndex:row] valueForKey: @"name"]];
    
    business_typeId = [[businessTypeArray objectAtIndex:row] valueForKey: @"id"];
}

#pragma mark - TextField Delegates & Datasource

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 450)];
    
    [textField resignFirstResponder];
    
    if (textField == established_year) {
        
        if ((![validationObj validateNumber:established_year.text]) || ([established_year.text length] > 4)) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please enter valid year" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
    
    return TRUE;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [toolBar removeFromSuperview];
    
    if (textField == business_type) {
        
        cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
        
        [cancelButton setWidth:20];
        
        doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
        
        [cancelButton setWidth:50];
        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- pickerView.frame.size.height) - 44, self.view.frame.size.width, 44)];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        toolBar.items = @[cancelButton,flexibleItem, doneButton];
        
        [self.view addSubview:toolBar];
        
        pickerView = [[UIPickerView alloc] init];
        
        pickerView.delegate = self;
        
        pickerView.dataSource = self;
        
        textField.inputView = pickerView;
    }
    
    return TRUE;
}

#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    
    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"Description"]) {
        
        textView.text = @"";
    }
    
    textView.textColor = [UIColor darkGrayColor];
    
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //    NSLog(@"txtview %@  txt %@",textView.text,text);
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return FALSE;
    }
    
    NSString *newText = [ textView.text stringByReplacingCharactersInRange: range withString: text ];
    
    long len = 1000 - [newText length];
    
    if(len < 0) {
        
        len = 0;
    }
    
    NSString *leftChar = [NSString stringWithFormat:@"%lu", len];
    
    leftChar = [leftChar stringByAppendingString:@" characters left"];
    
    char_limitLbl.text = leftChar;
    
    if ([newText length] <= 1000) {
        
        return YES;
    }
    
    // case where text length > MAX_LENGTH
    
    textView.text = [ newText substringToIndex: 999 ];
    
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length == 0 ) {
        
        textView.text = @"Description";
    }
    
    if (textView.text.length < 100) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Minimum 100 characters required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

#pragma mark County

- (IBAction)tapCountryBtn:(id)sender {
    
    isCity = NO;
    isState = NO;
    isCountry = YES;
    
    [self fetchLocation:@"country"];
}

- (IBAction)tapStateBtn:(id)sender {
    
    if ([country_id length] > 0) {
        
        isCity = NO;
        isState = YES;
        isCountry = NO;
        
        [self fetchLocation:@"state"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please select country first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (IBAction)tapCityBtn:(id)sender {
    
    if ([state_id length] > 0) {
        
        isCity = YES;
        isState = NO;
        isCountry = NO;
        
        [self fetchLocation:@"city"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please select state first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
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
    
    [locationConnection startConnectionWithString:url HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([locationConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if (isCountry) {
                
                countryArray = [receivedData valueForKey:@"country"];
                
                [self showListData:[[countryArray valueForKey:@"Country"] valueForKey:@"country_name"] allowMultipleSelection:NO selectedData:[countryBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Country"];
                
            } else if (isState){
                
                stateArray = [receivedData valueForKey:@"state"];
                
                [self showListData:[[stateArray valueForKey:@"State"] valueForKey:@"state_name"] allowMultipleSelection:NO selectedData:[stateBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"State"];
                
            } else if (isCity) {
                
                locationArray = [receivedData valueForKey:@"city"];
                
                [self showListData:[[locationArray valueForKey:@"City"] valueForKey:@"city_name"] allowMultipleSelection:NO selectedData:[cityBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"City"];
            }
        }
    }];
}

// Called when the UIKeyboardDidShowNotification is sent.

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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
    //[scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+ 450)];
    
    scrollView.contentInset = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbHeight;
    
    UIView *activeView = activeField;
    
    if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
        
        [scrollView scrollRectToVisible: activeView.frame  animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scrollView.contentInset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Add Image

- (IBAction)tappChooseImg:(id)sender {
    
    UIActionSheet * actionSheetForImage = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
              {
        actionSheetForImage = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Use Gallery", nil];
        [actionSheetForImage setTag:1];
              }
    else {
        
        actionSheetForImage = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery", nil];
        
        [actionSheetForImage setTag:2];
    }
    
    [actionSheetForImage showInView:self.view];
}

- (IBAction)tappedSaveBtn:(id)sender {
    
    /* member_id,course_name,picture,logo,identity,course_description,category_id, subcategory_id,course_type,course_duration_hours,course_duration_minutes,
     payment_deadline,deposit,change_enrollment,    cancellation,refund,make_up_lessons,severe_weather,
     currency,quantity_books_materials,currency_security,
     quantity_security,
     
     description_educator,name_educator,
     business_type,official_district,district,town,city,year,offer
     */
    
    NSString *message;
    
    if ([descriptionTxtView.text isEqualToString:@"Description"] ||[descriptionTxtView.text isEqualToString:@""]) {
        
        message = @"Please describe your business";
        
    } else if ([descriptionTxtView.text length] < 100){
        
        message = @"Please enter minimum 100 characters about business";
        
    } else if ([educator_name.text isEqualToString:@""]){
        
        message = @"Please enter business name";
        
    } else if ([business_type.text isEqualToString:@""] || [business_type.text isEqualToString:@"Select"]){
        
        message = @"Please select a business type";
        
    } else if ([img_selectLbl.text isEqualToString:@"No Image selected"]){
        
        message = @"Please add your identity";
        
    } else if ([district.text isEqualToString:@""]){
        
        message = @"Please enter your district";
        
    } else if ([number_street.text isEqualToString:@""]){
        
        message = @"Please enter Number and street";
        
    } else if ([countryBtn.titleLabel.text isEqualToString:@"  Country"]){
        
        message = @"Please enter your city";
        
    } else if ([stateBtn.titleLabel.text isEqualToString:@"  State"]){
        
        message = @"Please enter your city";
        
    } else if ([cityBtn.titleLabel.text isEqualToString:@"  City"]){
        
        message = @"Please enter your city";
        
    } else if (![validationObj validateNumberDigits:established_year.text] || (![established_year.text length] == 4)){
        
        message = @"Please enter year of establishment";
        
    } else if ([offersBtn.titleLabel.text isEqualToString:@"  Select"]){
        
        message = @"Please select the offer option";
    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        if ([images count] < 1) {
            
            images = [@[] mutableCopy];
        }
        
        NSDictionary *educatorData = @{@"description_educator":descriptionTxtView.text, @"name_educator":educator_name.text, @"business_type":business_typeId, @"author_venu_unit":address.text,@"author_venu_building_name" : building_name.text,  @"author_venu_street" : number_street.text, @"author_venu_district":district.text, @"author_country_id":country_id, @"author_state_id" : state_id, @"author_city_id":city_id, @"year":established_year.text, @"offer":offersId, @"identity":images};
        
        NSLog(@"%@", educatorData);
        
        [[NSUserDefaults standardUserDefaults] setValue:educatorData forKey:@"educator_data"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)tappedCancelBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Image Picker

#pragma mark - UIPickerView For Camera

-(void)openPictureViewWithCamera:(BOOL)camera {
    
    imagePicker =[[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if (camera) {
        
        //imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        [self performSelector: @selector(showPhotoGallery) withObject: nil afterDelay: 0];
    }
    else {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //imagePicker.allowsEditing = YES;
        
        [self performSelector: @selector(showPhotoGallery) withObject: nil afterDelay: 0];
    }
}

- (void) showPhotoGallery {
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"%@", info);
    
    if (![[UIApplication sharedApplication] isStatusBarHidden])
              {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
              }
    UIImage *imagePickedFromLib;
    
    NSURL *mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    if (mediaUrl == nil) {
        
        imagePickedFromLib = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        
        if (imagePickedFromLib == nil) {
            
            imagePickedFromLib = (UIImage *)[info valueForKey:
                                             UIImagePickerControllerOriginalImage];
            
            //set image to image view
        } else {
            
            //set image to image view
        }
        
        img_selectLbl.text = @"Image Attached";
    }
    
    NSData *imgData = UIImageJPEGRepresentation(imagePickedFromLib, 0.7);
    NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imgData length]);
    
    long size = [imgData length];
    
    if (size < 71680 || size > 307200) {  //70 kb - 300 kb
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please ensure your images are between 70kb to 300kb." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        img_selectLbl.text = @"Image Attached";
        
        images = [[NSMutableArray alloc] init];
        
        NSString *imagen = @"identity";
        
        [images addObject:@{@"fieldName" : imagen, @"fileName" : imagen, @"imageData" : UIImageJPEGRepresentation(imagePickedFromLib, 0.7) }];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 1)           //Camera
              {
        if (buttonIndex == 0)
                  {
            [self openPictureViewWithCamera:YES];
                  }
        else if(buttonIndex == 1)
                  {
            [self openPictureViewWithCamera:NO];
                  }
              }
    else if (actionSheet.tag == 2)      //without camera
              {
        if (buttonIndex == 0) {
            
            [self openPictureViewWithCamera:NO];
        }
              }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)tapOffersBtn:(id)sender {
    
    offersArray = @[@{@"id":@"0",@"name":@" Courses"}, @{@"id":@"1",@"name":@" Private Lessons"}, @{@"id":@"2",@"name":@" Group Lessons"}, @{@"id":@"3",@"name":@" Open Days"}, @{@"id":@"4",@"name":@" Workshops"},@{@"id":@"5",@"name":@"  Holiday Programs"}];
    
    [self showListData:[offersArray valueForKey:@"name"] allowMultipleSelection:YES selectedData:[offersBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Interests"];
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

-(void)didSelectListItem:(id)item index:(NSInteger)index{
    
    
    if (isCountry) {
        
        NSString *name = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"country_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [countryBtn setTitle:name forState:UIControlStateNormal];
        
        country_id = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"id"];
        
    } else if (isState){
        
        NSString *name = [[[stateArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"state_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [stateBtn setTitle:name forState:UIControlStateNormal];
        
        state_id = [[[stateArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"id"];
        
    } else if (isCity) {
        
        NSString *name = [[[locationArray objectAtIndex:index] valueForKey:@"City"] valueForKey:@"city_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [cityBtn setTitle:name forState:UIControlStateNormal];
        
        city_id = [[[locationArray objectAtIndex:index] valueForKey:@"City"] valueForKey:@"id"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSaveItems:(NSArray*)items indexs:(NSArray *)indexs{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *array_selectedInterest = [NSMutableArray array];
    
    NSMutableArray *array_Ids = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in indexs) {
        
        NSLog(@"IndexPath:%ld",(long)indexPath.row);
        
        if (indexs.count > offersArray.count) {
            
            if (indexPath.row < offersArray.count) {
                
                [array_selectedInterest addObject:[offersArray[indexPath.row] valueForKey :@"name"]];
                
                [array_Ids addObject:[offersArray[indexPath.row] valueForKey :@"id" ]];
            }
            
        } else {
            
            [array_selectedInterest addObject:[offersArray[indexPath.row-1] valueForKey:@"name"]];
            
            [array_Ids addObject:[offersArray[indexPath.row-1] valueForKey :@"id" ]];
        }
    }
    
    NSString *str = [array_selectedInterest  componentsJoinedByString:@", "];
    
    str = [@"  " stringByAppendingString:str];
    
    NSString *str_ids = [array_Ids  componentsJoinedByString:@","];
    
    [offersBtn setTitle:str forState:UIControlStateNormal];
    
    offersId = str_ids;
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

