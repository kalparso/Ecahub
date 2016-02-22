//
//  EditProfileViewController.m
//  ecaHUB
//
//  Created by promatics on 3/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EditProfileViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "MyProfileViewController.h"
#import "DateConversion.h"
#import "AddFamilyViewController.h"

@interface EditProfileViewController () {
    
    UIPickerView *pickerView;
    
    UIDatePicker *datePicker;
    
    UIImagePickerController * imagePicker;
    
    WebServiceConnection *editProfileConnection;
    
    WebServiceConnection *cityConnection;
    
    WebServiceConnection *countryConnection;
    
    WebServiceConnection *stateConnection;
    
    Indicator *indicator;
    
    NSString *dateStr;
    
    Validation *validationObj;
    
    NSArray *countryArray;
    
    NSArray *genderArray;
    
    NSArray *codeArray;
    
    UIToolbar *toolBar;
    
    UIBarButtonItem *cancelButton;
    
    UIBarButtonItem *doneButton;
    
    id activeField;
    
    BOOL tapGender;
    
    BOOL tapCity;
    
    BOOL tapCode;
    
    BOOL tapDob;
    
    BOOL tapCountry;
    
    BOOL tapState;
    
    NSString *city_id;
    
    NSString *country_id;
    
    NSString *state_id;
    
    NSMutableArray *images;
    
    BOOL countryDataLoad;
    
    BOOL codeDataLoad;
    
    BOOL dataLoad;
    
    NSString *select_id;
    
    NSArray *locationArray;
    
    NSArray *stateArray;
    
    NSString *select;
    
    DateConversion *dateConversion;
    
    CGFloat kHeight, scrollHeight;
    
    UITextField *selectedTextfield;
}

@end

@implementation EditProfileViewController

@synthesize scrollView, fnameTxtField, FamilyTxtField, phoneTxtField, cityTxtField, codeTxtField, aboutMe, genderTxtField, dobTxtField, profileImage, no_imageLbl, chooseImgBtn, btn_cancel, btn_save, country, state, saveView,email_textfiled;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    select = @"unselect";
    
    genderArray = @[@"Female", @"Male"];
    
    countryDataLoad = NO;
    
    codeDataLoad = NO;
    
    dataLoad = NO;
    
    editProfileConnection = [WebServiceConnection connectionManager];
    
    cityConnection = [WebServiceConnection connectionManager];
    
    countryConnection = [WebServiceConnection connectionManager];
    
    stateConnection = [WebServiceConnection connectionManager];
    
    dateConversion = [DateConversion dateConversionManager];
    
    validationObj = [Validation validationManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    //aboutMe.textColor =[UIColor lightGrayColor];
    
   
    
   // aboutMe.text = @"About me...anything to tell others why you are on ECAhub. This is totally optional.";
    
   // email_textfiled.textColor = [UIColor lightGrayColor];
    
    [self prepareInterface];
}


-(void) prepareInterface {
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
        
        
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        
        self.navigationItem.title = @"Profile";
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
//        [btn_save setTitle:@"Save & Continue" forState:UIControlStateNormal];
//        
//        btn_cancel.hidden = YES;
//        
//        CGRect frame = self.saveView.frame;
//        
//        frame.origin.x = (self.view.frame.size.width - 200)/2;
//        
//        frame.size.width = 200.0f;
//        
//        self.saveView.frame = frame;
//        
//        frame.origin.x = 0.0f;
//        
//        frame.origin.y = 0.0f;
//        
//        btn_save.frame = frame;
    }
    
    //[self.navigationController.navigationItem setTitle:@"Edit Profile"];
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    [scrollView addGestureRecognizer:tapScroll];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGFloat hieght = 45.0f;
        
        kHeight = 250.0f;
        
        scrollHeight = 1150.0f;
        
        CGRect frameRect = fnameTxtField.frame;
        frameRect.size.height = hieght;
        fnameTxtField.frame = frameRect;
        
        frameRect = email_textfiled.frame;
        frameRect.size.height = hieght;
        email_textfiled.frame = frameRect;
        
        CGRect frameRect1 = FamilyTxtField.frame;
        frameRect1.size.height = hieght;
        FamilyTxtField.frame = frameRect1;
        
        CGRect frameRect2 = genderTxtField.frame;
        frameRect2.size.height = hieght;
        genderTxtField.frame = frameRect2;
        
        CGRect frameRect3 = codeTxtField.frame;
        frameRect3.size.height = hieght;
        codeTxtField.frame = frameRect3;
        
        CGRect frameRect4 = phoneTxtField.frame;
        frameRect4.size.height = hieght;
        phoneTxtField.frame = frameRect4;
        
        frameRect = dobTxtField.frame;
        frameRect.size.height = hieght;
        dobTxtField.frame = frameRect;
        
        frameRect = cityTxtField.frame;
        frameRect.size.height = hieght;
        cityTxtField.frame = frameRect;
        
        frameRect = country.frame;
        frameRect.size.height = hieght;
        country.frame = frameRect;
        
        frameRect = state.frame;
        frameRect.size.height = hieght;
        state.frame = frameRect;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        kHeight = 180.0f;
        
        scrollHeight = 800.0f;
    }
    
    scrollView.frame = self.view.frame;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollHeight);
    
    btn_save.layer.cornerRadius = 5.0f;
    
    btn_cancel.layer.cornerRadius = 5.0f;
    
    fnameTxtField.layer.cornerRadius = 5.0f;
    
    fnameTxtField.layer.borderWidth = 0.5f;
    
    fnameTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    FamilyTxtField.layer.cornerRadius = 5.0f;
    
    FamilyTxtField.layer.borderWidth = 0.5f;
    
    FamilyTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    email_textfiled.layer.cornerRadius = 5.0f;
    
    email_textfiled.layer.borderWidth = 0.5f;
    
    email_textfiled.layer.borderColor = [UIColor blackColor].CGColor;

    genderTxtField.layer.cornerRadius = 5.0f;
    
    genderTxtField.layer.borderWidth = 0.5f;
    
    genderTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    codeTxtField.layer.cornerRadius = 5.0f;
    
    codeTxtField.layer.borderWidth = 0.5f;
    
    codeTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    phoneTxtField.layer.cornerRadius = 5.0f;
    
    phoneTxtField.layer.borderWidth = 0.5f;
    
    phoneTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    dobTxtField.layer.cornerRadius = 5.0f;
    
    dobTxtField.layer.borderWidth = 0.5f;
    
    dobTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    cityTxtField.layer.cornerRadius = 5.0f;
    
    cityTxtField.layer.borderWidth = 0.5f;
    
    cityTxtField.layer.borderColor = [UIColor blackColor].CGColor;
    
    country.layer.cornerRadius = 5.0f;
    
    country.layer.borderWidth = 0.5f;
    
    country.layer.borderColor = [UIColor blackColor].CGColor;
    
    state.layer.cornerRadius = 5.0f;
    
    state.layer.borderWidth = 0.5f;
    
    state.layer.borderColor = [UIColor blackColor].CGColor;
    
    aboutMe.layer.cornerRadius = 5.0f;
    
    aboutMe.layer.borderWidth = 0.5f;
    
    aboutMe.layer.borderColor = [UIColor blackColor].CGColor;
    
    chooseImgBtn.layer.cornerRadius = 15.0f;
    
    chooseImgBtn.layer.borderWidth = 0.5f;
    
    chooseImgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    cityTxtField.inputView = pickerView;
    
    //    codeTxtField.inputView = pickerView;
    
    //    codeTxtField.userInteractionEnabled = YES;
    
    genderTxtField.inputView = pickerView;
    
    country.inputView = pickerView;
    
    state.inputView = pickerView;
    
    datePicker = [[UIDatePicker alloc] init];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [datePicker setMaximumDate:[NSDate date]];
    
    dobTxtField.inputView = datePicker;
    
    tapCity = NO;
    tapCode = NO;
    tapGender = NO;
    tapDob = NO;
    tapCountry = NO;
    tapState = NO;
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"]) ;
    
    NSString *profile_Img = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"picture"];
    
    profile_Img = [profile_Img stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceCharacterSet]];
    
    if ([profile_Img length] > 1) {
        
        profile_Img = [profilePicURL stringByAppendingString:profile_Img];
        
        [self downloadImageWithString:profile_Img];
        
        no_imageLbl.text = @"Image Attached";
        
    } else {
        
        profileImage.image = [UIImage imageNamed:@"user_img"];
    }
    
    fnameTxtField.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"];
    
    FamilyTxtField.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"last_name"];
    
   dateStr = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"birth_date"];
    
    if ([dateStr isEqualToString:@"0000-00-00"]) {
        
        dateStr = @"";
        
        dobTxtField.text = dateStr;
        
    } else{
    
    dobTxtField.text = [dateConversion convertDate:dateStr];
    }
    // dobTxtField.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"birth_date"];
    
    
    genderTxtField.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"gender"];
    
     email_textfiled.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"email"];
    
   // email_textfiled.userInteractionEnabled = NO;
    
    codeTxtField.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Country"] valueForKey:@"phone_code"];
    
    country_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Country"] valueForKey:@"id"];
    
    cityTxtField.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"City"] valueForKey:@"city_name"];
    
    NSString *abtStr = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"about_me"];
    
    if ([abtStr isEqualToString:@""]) {
        
        abtStr =  @"About me...anything to tell others why you are on ECAhub. This is totally optional.";
    }
    
    aboutMe.text = abtStr;
    
    if ([aboutMe.text isEqualToString:@"About me...anything to tell others why you are on ECAhub. This is totally optional."]) {
        
        aboutMe.textColor =[UIColor lightGrayColor];
    }
    else{
        
        //aboutMe.textColor = UIColorFromRGB(text_color_hexcode);
        
        aboutMe.textColor = [UIColor blackColor];
    }
    
    NSString *phnStr =[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"phone"];
    if ([phnStr isEqualToString:@"0"]) {
        
        phnStr = @"";
        
    }
    
    phoneTxtField.text = phnStr;
    
    city_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"City"] valueForKey:@"id"];
    
    country.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Country"] valueForKey:@"country_name"];
    
    state.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"State"] valueForKey:@"state_name"];
    
    country_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Country"] valueForKey:@"id"];
    
    state_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"State"] valueForKey:@"id"];
    
    select_id = @"";
    
    [self getRequiredData];
    
}

-(void) getRequiredData {
    
    NSDictionary *urlParam = @{};
    
    [self.view addSubview:indicator];
    
    [countryConnection startConnectionWithString:[NSString stringWithFormat:@"country"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
        
        if ([countryConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            countryArray = [receivedData valueForKey:@"country"];
            
            countryDataLoad = YES;
            
            [indicator removeFromSuperview];
        }
    }];
    
    if ([country_id isEqualToString:@""] && [state_id isEqualToString:@""]) {
        
        
    } else {
        
        tapCountry = YES;
        
        tapState = YES;
        
        [self fetchLocationData];
    }
    
    //    [codeConnection startConnectionWithString:[NSString stringWithFormat:@"area_code"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
    //
    //        if ([codeConnection responseCode] == 1) {
    //
    //            NSLog(@"%@", receivedData);
    //
    //            codeArray = [receivedData copy];
    //
    //            codeDataLoad = YES;
    //
    //            [self prepareInterface];
    //
    //            [indicator removeFromSuperview];
    //        }
    //    }];
}

-(void) fetchLocationData {
    
    NSDictionary *urlParam;
    
    NSString *url;
    
    if (tapCountry) {
        
        url = @"state";
        
        //        country_id = select_id;
        
        urlParam = @{@"country_id" : country_id};
        
        [self.view addSubview:indicator];
        
        [stateConnection startConnectionWithString:url HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
            
            if ([stateConnection responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                //if (tapCountry) {
                
                stateArray = [receivedData valueForKey:@"state"];
                
                //} else if (tapState) {
                
                //     locationArray = [receivedData valueForKey:@"city"];
                // }
                
                dataLoad = YES;
                
                [indicator removeFromSuperview];
            }
        }];
        
        
    } else if (tapState) {
        
        url = @"city";
        
        //        state_id = select_id;
        
        urlParam = @{@"state_id" : state_id};
        
        [self.view addSubview:indicator];
        
        [cityConnection startConnectionWithString:url HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
            
            if ([cityConnection responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                locationArray = [receivedData valueForKey:@"city"];
                
                dataLoad = YES;
                
                [indicator removeFromSuperview];
            }
        }];
        
    }
}

-(void)cancelKeyboard:(UIBarButtonItem *)sender {
    
    if (tapDob) {
        
        dobTxtField.text = @"";
        
    } else if (tapCode) {
        
        codeTxtField.text = @"";
        
    } else if (tapCity) {
        
        cityTxtField.text = @"";
        
    } else if (tapGender) {
        
        genderTxtField.text = @"";
        
    } else if (tapCountry) {
        
        country.text = @"";
        
    } else if (tapState) {
        
        state.text = @"";
        
    }
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    [selectedTextfield resignFirstResponder];
}

-(void)doneKeyboard:(UIBarButtonItem *)sender {
    
    if (tapDob) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        [format setDateFormat:@"yyyy-MM-dd"];
        
        dateStr = [format stringFromDate:[datePicker date]];
        
        dobTxtField.text = [dateConversion convertDate:dateStr];
    }
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    if (tapState || tapCountry) {
        
        [self fetchLocationData];
    }
    
    [selectedTextfield resignFirstResponder];
}

#pragma mark - PickerView Delegates & Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (tapCode) {
        
        return codeArray.count +1;
        
    } else if (tapCity) {
        
        return locationArray.count +1;
        
    } else if (tapCountry) {
        
        return countryArray.count +1;
        
    } else if (tapState) {
        
        return stateArray.count +1;
        
    } else {
        
        return genderArray.count +1;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (row == 0) {
        
        return @"Select";
        
    } else {
        
        if (tapCity) {
            
            NSLog(@"%@", locationArray);
            
            NSLog(@"%@",[[[locationArray objectAtIndex:row-1] valueForKey:@"City"] valueForKey:@"city_name"]);
            
            return  [[[locationArray objectAtIndex:row-1] valueForKey:@"City"] valueForKey:@"city_name"];
            
        } else if (tapCode) {
            
            return  [[[codeArray objectAtIndex:row-1] valueForKey:@"Country"] valueForKey:@"phone_code"];
            
        } else if (tapCountry) {
            
            return  [[[countryArray objectAtIndex:row-1] valueForKey:@"Country"] valueForKey:@"country_name"];
            
        } else if (tapState) {
            
            return  [[[stateArray objectAtIndex:row-1] valueForKey:@"State"] valueForKey:@"state_name"];
            
        } else {
            
            return  [genderArray objectAtIndex:row-1];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (tapCode) {
        
        if (row == 0) {
            
            codeTxtField.text = @"Select";
            
            select = @"Select";
            
        } else {
            
            [codeTxtField setText:[[[codeArray objectAtIndex:row-1] valueForKey:@"Country"] valueForKey:@"phone_code"]];
            
            country_id = [[[codeArray objectAtIndex:row-1] valueForKey:@"Country"] valueForKey:@"id"];
            
            select = @"unselect";
        }
        
    } else if (tapCity) {
        
        if (row == 0) {
            
            cityTxtField.text = @"Select";
            
            select = @"Select";
            
        } else {
            
            [cityTxtField setText:[[[locationArray objectAtIndex:row-1] valueForKey:@"City"] valueForKey:@"city_name"]];
            
            city_id = [[[locationArray objectAtIndex:row-1] valueForKey:@"City"] valueForKey:@"id"];
            
            select = @"unselect";
        }
        
    } else if (tapCountry) {
        
        if (row == 0) {
            
            country.text = @"Select";
            
            select = @"Select";
            
        } else {
            
            [country setText:[[[countryArray objectAtIndex:row-1] valueForKey:@"Country"] valueForKey:@"country_name"]];
            
            codeTxtField.text = [[[countryArray objectAtIndex:row-1] valueForKey:@"Country"] valueForKey:@"phone_code"];
            
            country_id = [[[countryArray objectAtIndex:row-1] valueForKey:@"Country"] valueForKey:@"id"];
            
            select = @"Select";
        }
        
    } else if (tapState) {
        
        if (row == 0) {
            
            state.text = @"Select";
            
            select = @"Select";
            
        } else {
            
            [state setText:[[[stateArray objectAtIndex:row-1] valueForKey:@"State"] valueForKey:@"state_name"]];
            
            state_id = [[[stateArray objectAtIndex:row-1] valueForKey:@"State"] valueForKey:@"id"];
            
            select = @"unselect";
        }
        
    } else {
        
        if (row == 0) {
            
            genderTxtField.text = @"Select";
            
        } else {
            
            [genderTxtField setText:[genderArray objectAtIndex:row-1]];
            
        }
    }
}

#pragma mark - TextField Delegates & Datasource

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == phoneTxtField) {
        
        [phoneTxtField resignFirstResponder];
        
    } else if (textField == fnameTxtField) {
        
        [FamilyTxtField becomeFirstResponder];
        
    } else if (textField == FamilyTxtField) {
        
        [dobTxtField becomeFirstResponder];
        
    } else if (textField == dobTxtField) {
        
        [genderTxtField becomeFirstResponder];
        
    } else if (textField == country) {
        
        [state becomeFirstResponder];
        
    } else if (textField == state) {
        
        [cityTxtField becomeFirstResponder];
        
    } else if (textField == cityTxtField) {
        
        [codeTxtField becomeFirstResponder];
        
    } else if (textField == codeTxtField) {
        
        [phoneTxtField becomeFirstResponder];
    }
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, scrollHeight)];
    
    return TRUE;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    selectedTextfield = textField;
    
    if (textField == fnameTxtField) {
        
        scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [toolBar removeFromSuperview];
    
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
    
    if (textField == dobTxtField || textField == cityTxtField || textField == genderTxtField || textField == country || textField == state) {
        
        if (textField == dobTxtField) {
            
            tapDob = YES;
            tapCity = NO;
            tapCode = NO;
            tapGender = NO;
            tapState = NO;
            tapCountry = NO;
            
        } else if (textField == cityTxtField) {
            
            tapDob = NO;
            tapCity = YES;
            tapCode = NO;
            tapGender = NO;
            tapState = NO;
            tapCountry = NO;
            
        }
        //        else if (textField == codeTxtField) {
        //
        //            tapDob = NO;
        //            tapCity = NO;
        //            tapCode = YES;
        //            tapGender = NO;
        //            tapState = NO;
        //            tapCountry = NO;
        //
        //        }
        else if (textField == genderTxtField) {
            
            tapDob = NO;
            tapCity = NO;
            tapCode = NO;
            tapGender = YES;
            tapState = NO;
            tapCountry = NO;
            
        } else if (textField == country) {
            
            tapDob = NO;
            tapCity = NO;
            tapCode = NO;
            tapGender = NO;
            tapState = NO;
            tapCountry = YES;
            
        } else if (textField == state) {
            
            tapDob = NO;
            tapCity = NO;
            tapCode = NO;
            tapGender = NO;
            tapState = YES;
            tapCountry = NO;
        }
        
        
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
        
        if (textField == dobTxtField) {
            
            datePicker = [[UIDatePicker alloc] init];
            
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            [datePicker setMaximumDate:[NSDate date]];
            
            textField.inputView = datePicker;
            
        } else if(textField == country){
            
            textField.inputView = pickerView;
            
        }else if (textField == cityTxtField){
            
            textField.inputView = pickerView;
            
        }else if (textField == state){
            
            textField.inputView = pickerView;
            
        }else if (textField == genderTxtField){
            
            textField.inputView = pickerView;
            
        }
        
    }
    
    return TRUE;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    if (textField == phoneTxtField) {
    //
    //    NSString *newText = [ textField.text stringByReplacingCharactersInRange: range withString: string ];
    //
    //    long len = 10 - [newText length];
    //
    //    if(len < 0){
    //
    //        len = 0;
    //    }
    //
    //    if( [newText length]<= 10 ){
    //        return YES;
    //    }
    //
    //    // case where text length > MAX_LENGTH
    //
    //    textField.text = [ newText substringToIndex: 9 ];
    //
    //    }
    return true;
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            profileImage.image = image;
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    activeField = textField;
    if (textField == fnameTxtField) {
        
        scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }
    else {
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    activeField = nil;
}

#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    // activeField = textView;
    
    if ([textView.text isEqualToString:@"About me...anything to tell others why you are on ECAhub. This is totally optional."]) {
        
        textView.text = @"";
    }
    
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    
    if ([textView.text isEqualToString:@"About me...anything to tell others why you are on ECAhub. This is totally optional."]) {
        
        textView.text = @"";
    }
    
    textView.textColor = [UIColor blackColor];
    
    scrollView.frame = CGRectMake(0, -kHeight, self.view.frame.size.width, self.view.frame.size.height);
    
    return true;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""])
    {
         textView.textColor =[UIColor lightGrayColor];
    }
    return true;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0 ) {
        
        //        textView.text = @"Type your question here";
        
        //        textView.textColor = UIColorFromRGB(placeholder_text_color_hexcode);
        
    } else {
        
        textView.textColor = UIColorFromRGB(text_color_hexcode);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    scrollView.frame = CGRectMake(0, 67, self.view.frame.size.width, scrollHeight-67);
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollHeight);
    
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if ([text length]<1) {
        
        textView.text = @"About me...anything to tell others why you are on ECAhub. This is totally optional.";
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return FALSE;
    }
    
    return TRUE;
}

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.

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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0,0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
    scrollView.contentInset = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbHeight;
    
    UIView *activeView = activeField;
    
    if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
        
        [scrollView scrollRectToVisible: activeView.frame  animated:YES];
    }
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, scrollHeight)];
  
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    //    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    //
    //    scrollView.contentInset = contentInsets;
    //
    //    scrollView.scrollIndicatorInsets = contentInsets;
    //
    scrollView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, scrollHeight)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    [toolBar removeFromSuperview];
    
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Image Picker

#pragma mark - UIPickerView For Camera

-(void)openPictureViewWithCamera:(BOOL)camera {
    
    imagePicker =[[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if (camera) {
        
        imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        [self performSelector: @selector(showPhotoGallery) withObject: nil afterDelay: 0];
    }
    else {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.allowsEditing = YES;
        
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
            
            [profileImage setImage:imagePickedFromLib];
            
        } else {
            
            [profileImage setImage:imagePickedFromLib];
        }
        
        self.profile_Image = imagePickedFromLib;
        
        no_imageLbl.text = @"Image Attached";
    }
    
    images = [[NSMutableArray alloc] init];
    
    NSString *imagen = @"picture";
    
    [images addObject:@{@"fieldName" : imagen, @"fileName" : imagen, @"imageData" : UIImageJPEGRepresentation(imagePickedFromLib, 0.7) }];
    
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

- (IBAction)chooseImageBtn:(id)sender {
    
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

- (IBAction)saveBtn:(id)sender {
    
    validationObj = [[Validation alloc] init];
    
    NSString *message;
    
    if (![validationObj validateBlankField:fnameTxtField.text]) {
        
        message = @"Please enter your first name.";
        
    } else if (![validationObj validateBlankField:FamilyTxtField.text]) {
        
        message = @"Please enter your last name.";
        
    } else if (![validationObj validateBlankField:dobTxtField.text]) {
        
        message = @"Please enter your date of birth.";
        
    } else if (![validationObj validateBlankField:genderTxtField.text] || [genderTxtField.text isEqualToString:@"Select"]) {
        
        message = @"Please select your gender.";
        
    } else if (![validationObj validateBlankField:cityTxtField.text] || [cityTxtField.text isEqualToString:@"Select"]) {
        
        message = @"Please select your city.";
        
    } else if (![validationObj validateBlankField:codeTxtField.text]) {
        
        message = @"Please select your country code.";
        
    } else if (![validationObj validatePhoneNumber:phoneTxtField.text]) {
        
        message = @"Please enter your mobile number.";
        
    }  else if (![validationObj validateBlankField:country.text] || [country.text isEqualToString:@"Select"]) {
        
        message = @"Please select country.";
        
    }  else if (![validationObj validateBlankField:state.text] || [state.text isEqualToString:@"Select"]) {
        
        message = @"Please select state.";
        
    }
    //        else if (![validationObj validateBlankField:aboutMe.text] || [validationObj validateString:aboutMe.text equalTo:@"This is totally optional. Anything to tell others why you are on ECAhub."]) {
    //
    //         message = @"Please tell something About you";
    //    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        NSLog(@"%@",[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo" ] valueForKey:@"Member"] valueForKey:@"id"]);
        
        [self.view addSubview:indicator];
        
        NSString *about_me;
        
        if ([aboutMe.text isEqualToString:@"About me...anything to tell others why you are on ECAhub. This is totally optional."]) {
        
            about_me = @"";
        }
        else{
            
            about_me = aboutMe.text;
        }
        
        NSDictionary *paramURL =@{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo" ] valueForKey:@"Member"] valueForKey:@"id"], @"first_name" : fnameTxtField.text, @"last_name" : FamilyTxtField.text, @"gender" : genderTxtField.text, @"birth_date" : dateStr, @"city_id" : city_id, @"country_id" : country_id, @"phone" : phoneTxtField.text, @"about_me" :about_me, @"state_id" : state_id};
        
        NSLog(@"URL Params: %@", paramURL);
        
        [editProfileConnection startConnectionToUploadMultipleImagesWithString:[NSString stringWithFormat:@"edit_user_profile"] images:images HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([editProfileConnection responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
                    
                    [self performSegueWithIdentifier:@"addFamilySegue" sender:self];
                }
                
                else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Member details have been updated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}

- (IBAction)cancelBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end


