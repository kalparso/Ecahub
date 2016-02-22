//
//  AddBusinessProfileViewController.m
//  ecaHUB
//
//  Created by promatics on 7/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AddBusinessProfileViewController.h"
#import "Validation.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface AddBusinessProfileViewController () {
    
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
    
    BOOL isCity, isTapCheck;
    
    NSString *city_id;
    
    NSString *country_id;
    
    NSString *state_id;
    
    NSArray *countryArray;
    
    NSArray *locationArray;
    
    NSArray *stateArray;
    
    WebServiceConnection *locationConnection, *addBusinessConn;
    
    Indicator *indicator;
}
@end

@implementation AddBusinessProfileViewController

@synthesize scrollView, descriptionTxtView, char_limitLbl, educator_name, business_type, choose_imgBtn, img_selectLbl, address, district, town, city, established_year, offerTxtField, saveBtn, publishBtn, cancelBtn, offersBtn, countryBtn, stateBtn, cityBtn, building_name, number_street, img_view, checkBtn, business_id, isEdit, businessDict, offers,term_Cond_lbl,term_cond_btn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    // self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = @"Add Business Profile";
    
    educator_name.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    validationObj = [Validation validationManager];
    
    locationConnection = [WebServiceConnection connectionManager];
    
    addBusinessConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    isCountry = NO;
    
    isState = NO;
    
    isCity = NO;
    
    isTapCheck = NO;
    
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    checkBtn.layer.borderWidth = 1.0f;
    checkBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    checkBtn.layer.cornerRadius = 3.0f;
    
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    [scrollView addGestureRecognizer:tapScroll];
    
    [self registerForKeyboardNotifications];
    
    [self prepareInterface];
    
    
    // scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"By clicking Confirm you agree to abide by the Terms & Conditions of selling your education services on ECAhub."];
    
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(teal_text_color_hexcode) range:NSMakeRange(45,19)];
    
    [term_cond_btn setTitle:@"" forState:UIControlStateNormal];
    
    term_Cond_lbl.attributedText = string;

    
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    isTapCheck = NO;
    
    if (isEdit) {
        
        self.title = @"Edit Business Profile";
        
        [self setData];
    }
}

-(void)setData {
    
    offers = [@"  " stringByAppendingString:offers];
    
    [offersBtn setTitle:offers forState:UIControlStateNormal];
    
    [offersBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    NSLog(@"%@",businessDict);
    
    educator_name.text = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
    
    descriptionTxtView.text = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"description_educator"];
    
    descriptionTxtView.textColor = [UIColor darkGrayColor];
    
    business_type.text = [[businessDict valueForKey:@"BusinessType"] valueForKey:@"title"];
    
    address.text = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"author_venu_unit"];
    
    building_name.text = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"author_venu_building_name"];
    
    number_street.text = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"author_venu_street"];
    
    district.text = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"author_venu_district"];
    
    established_year.text = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"year"];
    
    NSString *country = [[businessDict valueForKey:@"author_country"] valueForKey:@"country_name"];
    
    country = [@"  " stringByAppendingString:country];
    
    [countryBtn setTitle:country forState:UIControlStateNormal];
    
    [countryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    country = [[businessDict valueForKey:@"author_state"] valueForKey:@"state_name"];
    
    country = [@"  " stringByAppendingString:country];
    
    [stateBtn setTitle:country forState:UIControlStateNormal];
    
    
    [stateBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    country = [[businessDict valueForKey:@"author_city"]valueForKey:@"city_name"];
    
    country = [@"  " stringByAppendingString:country];
    
    [cityBtn setTitle:country forState:UIControlStateNormal];
    
    [cityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    NSString *img_url = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"identity"];
    
    img_url = [BusinessProfileImgURL stringByAppendingString:img_url];
    
    [img_view sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"user_img"]];
    
    if ([img_url isEqualToString:@""]) {
        
        img_selectLbl.text = @"No Image selected";
    }else{
        
        img_selectLbl.text = @"Image selected";
    }
    
    business_typeId = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"business_type"];
    
    country_id = [[businessDict valueForKey:@"author_country"] valueForKey:@"id"];
    
    city_id = [[businessDict valueForKey:@"author_city"]valueForKey:@"id"];
    
    state_id = [[businessDict valueForKey:@"author_state"] valueForKey:@"id"];
    
    offersId = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"offer"];
    
    //[checkBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    char_limitLbl.text = @"Maximum characters left";
    
    // isTapCheck = YES;
}

-(void) prepareInterface {
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1650);
        
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
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1300);
        
        choose_imgBtn.layer.cornerRadius = 15.0f;
    }
    
    //  Select, 2000,   City,   State,   Country, Suburb/District, Number and Street, Description, e.g. Arts Limited or Sarah Smith Select, Type Unit / Suite, Building Name,
    
    
    countryBtn.layer.borderWidth = 1.0f;
    
    countryBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [countryBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    countryBtn.layer.cornerRadius = 5.0f;
    
    stateBtn.layer.borderWidth = 1.0f;
    
    stateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [stateBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    stateBtn.layer.cornerRadius = 5.0f;
    
    cityBtn.layer.borderWidth = 1.0f;
    
    cityBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [cityBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    cityBtn.layer.cornerRadius = 5.0f;
    
    choose_imgBtn.layer.borderWidth = 1.0f;
    
    choose_imgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    offersBtn.layer.borderWidth = 1.0f;
    
    offersBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    [offersBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    
    offersBtn.layer.cornerRadius = 5.0f;
    
    saveBtn.layer.cornerRadius = 5.0f;
    
    publishBtn.layer.cornerRadius = 5.0f;
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    descriptionTxtView.layer.borderWidth = 1.0f;
    
    descriptionTxtView.layer.borderColor = [UIColor blackColor].CGColor;
    
    descriptionTxtView.layer.cornerRadius = 5.0f;
    
    // Country, Suburb/District, Number and Street, Description, e.g. Arts Limited or Sarah Smith Select, Type Unit / Suite, Building Name
    
    educator_name.layer.borderWidth = 1.0f;
    
    educator_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    educator_name.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"e.g. Arts Limited or Sarah Smith" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    educator_name.layer.cornerRadius = 5.0f;
    
    business_type.layer.borderWidth = 1.0f;
    
    business_type.layer.borderColor = [UIColor blackColor].CGColor;
    
    business_type.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"  Select" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    
    business_type.layer.cornerRadius = 5.0f;
    
    address.layer.borderWidth = 1.0f;
    
    address.layer.borderColor = [UIColor blackColor].CGColor;
    
    address.layer.cornerRadius = 5.0f;
    
    building_name.layer.borderWidth = 1.0f;
    
    building_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    building_name.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Building Name" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    building_name.layer.cornerRadius = 5.0f;
    
    number_street.layer.borderWidth = 1.0f;
    
    number_street.layer.borderColor = [UIColor blackColor].CGColor;
    
    number_street.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Number and Street" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    
    number_street.layer.cornerRadius = 5.0f;
    
    city.layer.borderWidth = 1.0f;
    
    city.layer.borderColor = [UIColor blackColor].CGColor;
    
    city.layer.cornerRadius = 5.0f;
    
    district.layer.borderWidth = 1.0f;
    
    district.layer.borderColor = [UIColor blackColor].CGColor;
    
    district.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Suburb/District" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    
    district.layer.cornerRadius = 5.0f;
    
    town.layer.borderWidth = 1.0f;
    
    town.layer.borderColor = [UIColor blackColor].CGColor;
    
    town.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Unit / Suite" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    town.layer.cornerRadius = 5.0f;
    
    established_year.layer.borderWidth = 1.0f;
    
    established_year.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    established_year.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"2000" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    
    
    established_year.layer.cornerRadius = 5.0f;
    
    offerTxtField.layer.borderWidth = 1.0f;
    
    offerTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    //offerTxtField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Select" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    
    offerTxtField.layer.cornerRadius = 5.0f;
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    business_type.inputView = pickerView;
    
    img_view.layer.cornerRadius = (img_view.frame.size.width/2);
    img_view.layer.masksToBounds = YES;
    
    //UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePickerView)];
    
    //tapgest.cancelsTouchesInView = NO;
    
    //[self.view addGestureRecognizer:tapgest];
    
    businessTypeArray = @[@{@"id":@"0",@"name":@"Select"}, @{@"id":@"0",@"name":@"Private Person"}, @{@"id":@"1",@"name":@"Sole Proprietor"}, @{@"id":@"2",@"name":@"Partnership"}, @{@"id":@"3",@"name":@"Private Company"}, @{@"id":@"4",@"name":@"Non-Profit"}];
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
    
    if(row == 0){
        
        [business_type setTextColor:UIColorFromRGB(placeholder_text_color_hexcode)];
        
    } else  {
        
        [business_type setTextColor:[UIColor darkGrayColor]];
    }
    
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
    
    if(textField == educator_name){
        
        scrollView.scrollEnabled = NO;
        
    } else {
        
        scrollView.scrollEnabled = YES;
        
    }
    
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

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-50);
    
    scrollView.scrollEnabled = YES;
    
}

#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeField = textView;
    
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
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
    
    //    if ([text isEqualToString:@"\n"]) {
    //
    //        [textView resignFirstResponder];
    //
    //        return FALSE;
    //    }
    
    NSString *newText = [textView.text stringByReplacingCharactersInRange: range withString: text ];
    
    long len = 2000 - [newText length];
    
    if(len < 0) {
        
        len = 0;
    }
    
    NSString *leftChar = [NSString stringWithFormat:@"%lu", len];
    
    leftChar = [leftChar stringByAppendingString:@" characters left"];
    
    char_limitLbl.text = leftChar;
    
    if ([newText length] <= 2000) {
        
        return YES;
    }
    
    // case where text length > MAX_LENGTH
    
    textView.text = [newText substringToIndex: 1999 ];
    
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    activeField = nil;
    
    if (textView.text.length == 0 ) {
        
        textView.text = @"Description";
        
        textView.textColor = UIColorFromRGB(placeholder_text_color_hexcode);
    }
    
    if (textView.text.length < 100) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Minimum 100 characters required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    // scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+100);
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
        
        //[cityBtn setTitle:@"  City" forState:UIControlStateNormal];
        
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

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
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
    
    scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-50);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    // scrollView.frame = self.view.frame;
    
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
        
    } else {
        
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
        
    } else if ([descriptionTxtView.text length] < 100) {
        
        message = @"Please enter minimum 100 characters about Educator description";
        
    } else if ([educator_name.text isEqualToString:@""]){
        
        message = @"Please enter business name";
        
    } else if ([educator_name.text isEqualToString:@""]){
        
        message = @"Please enter business name";
        
    } else if ([business_type.text isEqualToString:@""] || [business_type.text isEqualToString:@"Select"]){
        
        message = @"Please select a business type";
        
    } else if ([img_selectLbl.text isEqualToString:@"No Image selected"]){
        
        message = @"Please add your identity";
        
    } else if ([district.text isEqualToString:@""]){
        
        message = @"Please enter your district";
        
    } else if ([number_street.text isEqualToString:@""]){
        
        message = @"Please enter Number and Street";
        
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
        
    } else if (!isTapCheck) {
        
        message = @"Please select term and conditions";
        
    }
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        /*
         description_educator,name_educator,business_type, identity(IMAGE),author_venu_unit,author_venu_building_name,author_venu_street,author_venu_district,author_country_id,author_state_id,author_city_id,year,offer,member_id,id(Only in case of edit)
         id
         */
        
        NSDictionary *educatorData;
        
        if (isEdit) {
            
            educatorData = @{@"description_educator":descriptionTxtView.text, @"name_educator":educator_name.text, @"business_type":business_typeId, @"author_venu_unit":address.text,@"author_venu_building_name" : building_name.text,  @"author_venu_street" : number_street.text, @"author_venu_district":district.text, @"author_country_id":country_id, @"author_state_id" : state_id, @"author_city_id":city_id, @"year":established_year.text, @"offer":offersId, @"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"id":[[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"id"]};
            
        } else {
            
            educatorData = @{@"description_educator":descriptionTxtView.text, @"name_educator":educator_name.text, @"business_type":business_typeId, @"author_venu_unit":address.text,@"author_venu_building_name" : building_name.text,  @"author_venu_street" : number_street.text, @"author_venu_district":district.text, @"author_country_id":country_id, @"author_state_id" : state_id, @"author_city_id":city_id, @"year":established_year.text, @"offer":offersId, @"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
        }
        
        NSLog(@"%@", educatorData);
        
        [self.view addSubview:indicator];
        
        [addBusinessConn startConnectionToUploadMultipleImagesWithString:@"edit_business_profile" images:images HttpMethodType:Post_Type HttpBodyType:educatorData Output:^(NSDictionary *receivedData) {
            
            [indicator removeFromSuperview];
            
            if ([addBusinessConn responseCode] == 1) {
                
                NSLog(@"%@",receivedData);
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
        // [[NSUserDefaults standardUserDefaults] setValue:educatorData forKey:@"educator_data"];
    }
}

- (IBAction)tappedCancelBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapCheckBtn:(id)sender {
    
    if (isTapCheck) {
        
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        isTapCheck = NO;
        
    } else {
        
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        isTapCheck = YES;
    }
}

- (IBAction)tapName_info:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The name by which your business is known by or your personal name if you are an independent educator, instructor or tutor." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (IBAction)tapType_info:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"This is private information, and is not shown on your Listing on the website." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

- (IBAction)tapIdentity_info:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Personalize with your logo if you are a business, or a picture if you are a tutor." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

- (IBAction)tapAddress_info:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You will only see the Suburb / District displayed on your Business Profile for other members to see. Your full address is private." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

- (IBAction)tapTerm_Cond_btn:(id)sender {
    
   
    //http://mercury.promaticstechnologies.com/ecaHub/Homes/terms_and_condition
    
    
    //NSString term_con;
    
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:term_Condition_Url]];
    
   }

#pragma mark - Image Picker

#pragma mark - UIPickerView For Camera

-(void)openPictureViewWithCamera:(BOOL)camera {
    
    imagePicker =[[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if (camera) {
        
        // imagePicker.allowsEditing = YES;
        
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
    
    long size;
    
    NSData *picture;
    
    if (mediaUrl == nil) {
        
        imagePickedFromLib = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        
        picture = UIImageJPEGRepresentation(imagePickedFromLib, 0.7);
        
        size = [picture length];
        
        if(size > 80680){
            
            imagePickedFromLib = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerEditedImage]];
            
        }
        
        if (imagePickedFromLib == nil) {
            
            imagePickedFromLib = (UIImage *)[info valueForKey:
                                             UIImagePickerControllerOriginalImage];
            
            picture = UIImageJPEGRepresentation(imagePickedFromLib, 0.7);
            
            size = [picture length];
            
            if(size > 80680){
                
                imagePickedFromLib = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerOriginalImage]];
                
            }
            
            //set image to image view
        } else {
            
            //set image to image view
        }
        img_selectLbl.text = @"Image Attached";
    }
    
    picture = UIImageJPEGRepresentation(imagePickedFromLib, 0.7);
    
    NSLog(@"Size of Image(bytes):%lu",(unsigned long)[picture length]);
    
    
    img_selectLbl.text = @"Image Attached";
    
    img_view.image = imagePickedFromLib;
    
    images = [[NSMutableArray alloc] init];
    
    NSString *imagen = @"identity";
    
    [images addObject:@{@"fieldName":imagen, @"fileName":imagen, @"imageData":UIImageJPEGRepresentation(imagePickedFromLib, 0.7) }];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}



- (UIImage *)scaleAndRotateImage:(UIImage *) image {
    int kMaxResolution = 512;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapOffersBtn:(id)sender {
    
    offersArray = @[@{@"id":@"0",@"name":@" Courses"}, @{@"id":@"1",@"name":@" Private Lessons"}, @{@"id":@"2",@"name":@" Group Lessons"}, @{@"id":@"3",@"name":@" Open Days"}, @{@"id":@"4",@"name":@" Workshops"},@{@"id":@"5",@"name":@"  Holiday Programs"}];
    
    NSString *ofr_str = offersBtn.titleLabel.text;
    
    ofr_str = [ofr_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self showListData:[offersArray valueForKey:@"name"] allowMultipleSelection:YES selectedData:[ofr_str componentsSeparatedByString:@", "] title:@"Offers"];
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
    
    if (isCountry) {
        
        NSString *name = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"country_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [countryBtn setTitle:name forState:UIControlStateNormal];
        
        country_id = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"id"];
        
        [countryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [stateBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
        [cityBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
        [cityBtn setTitle:@"  City" forState:UIControlStateNormal];
        
        [stateBtn setTitle:@"  State" forState:UIControlStateNormal];
        
        state_id = @"";
        
    } else if (isState){
        
        NSString *name = [[[stateArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"state_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [stateBtn setTitle:name forState:UIControlStateNormal];
        
        state_id = [[[stateArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"id"];
        
        [stateBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [cityBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
        [cityBtn setTitle:@"  City" forState:UIControlStateNormal];
        
        
    } else if (isCity) {
        
        NSString *name = [[[locationArray objectAtIndex:index] valueForKey:@"City"] valueForKey:@"city_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [cityBtn setTitle:name forState:UIControlStateNormal];
        
        city_id = [[[locationArray objectAtIndex:index] valueForKey:@"City"] valueForKey:@"id"];
        
        [cityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
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
    
    [offersBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    offersId = str_ids;
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

