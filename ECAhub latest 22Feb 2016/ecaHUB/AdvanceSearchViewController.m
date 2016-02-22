//
//  AdvanceSearchViewController.m
//  ecaHUB
//
//  Created by promatics on 5/4/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AdvanceSearchViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"

@interface AdvanceSearchViewController () {
    
    WebServiceConnection *webConnection;
    
    Indicator *indicator;
    
    UIDatePicker *datePicker;
    
    UIToolbar *toolBar;
    
    UIBarButtonItem *cancelBarButton;
    
    UIBarButtonItem *doneBarButton;
    
    BOOL tapMale, tapFemale, tapCourse, tapLesson, tapEvent, tapAge, tapLang, tapLocation;
    
    UIButton *selectedBtn;
    
    NSArray *ageArray, *langArray, *countryArray;
    
    NSString *country_id, *age_ids, *lang_ids;

    CGFloat y;
}
@end

@implementation AdvanceSearchViewController

@synthesize scrollView, from_dateBtn, to_dateBtn, type_courseBtn, type_lessonBtn, type_eventBtn, whereBtn, gender_MaleBtn, gender_femaleBtn, ageBtn, LanguageBtn, specific_textField, cancelBtn, SearchBtn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    scrollView.frame = self.view.frame;
    
    webConnection = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        
        y = 250.0f;
        
        CGRect frame = specific_textField.frame;
        
        frame.size.height = 45.0f;
        
        specific_textField.frame = frame;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1024);
        
        y = 230.0f;
    }
    
    specific_textField.layer.borderWidth = 1.0f;
    
    specific_textField.layer.borderColor = [UIColor blackColor].CGColor;
    
    specific_textField.layer.cornerRadius = 5.0f;
    
    whereBtn.layer.borderWidth = 1.0f;
    
    whereBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    whereBtn.layer.cornerRadius = 5.0f;
    
    from_dateBtn.layer.borderWidth = 1.0f;
    
    from_dateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    from_dateBtn.layer.cornerRadius = 5.0f;
    
    to_dateBtn.layer.borderWidth = 1.0f;
    
    to_dateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    to_dateBtn.layer.cornerRadius = 5.0f;
    
    type_courseBtn.layer.borderWidth = 1.0f;
    
    type_courseBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    type_courseBtn.layer.cornerRadius = 3.0f;
    
    type_eventBtn.layer.borderWidth = 1.0f;
    
    type_eventBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    type_eventBtn.layer.cornerRadius = 3.0f;
    
    type_lessonBtn.layer.borderWidth = 1.0f;
    
    type_lessonBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    type_lessonBtn.layer.cornerRadius = 3.0f;
    
    gender_MaleBtn.layer.borderWidth = 1.0f;
    
    gender_MaleBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    gender_MaleBtn.layer.cornerRadius = 3.0f;
    
    gender_femaleBtn.layer.borderWidth = 1.0f;
    
    gender_femaleBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    gender_femaleBtn.layer.cornerRadius = 3.0f;
    
    ageBtn.layer.borderWidth = 1.0f;
    
    ageBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    ageBtn.layer.cornerRadius = 3.0f;

    LanguageBtn.layer.borderWidth = 1.0f;
    
    LanguageBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    LanguageBtn.layer.cornerRadius = 3.0f;
    
    cancelBtn.layer.cornerRadius = 3.0f;
    
    SearchBtn.layer.cornerRadius = 3.0f;
    
    [gender_femaleBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    [gender_MaleBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    [type_lessonBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    [type_eventBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    [type_courseBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    tapMale = NO;
    tapFemale = NO;
    tapCourse = NO;
    tapLesson = NO;
    tapEvent = NO;
    tapLang = NO;
    tapAge = NO;
    tapLocation = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapFromBtn:(id)sender {
    
    selectedBtn = from_dateBtn;
    
    [self addPicker_toolBar];
}

- (IBAction)tapToBtn:(id)sender {
    
    selectedBtn = to_dateBtn;
    
    [self addPicker_toolBar];
}

- (IBAction)tapCourseTypeBtn:(id)sender {
    
    if (tapCourse) {
        
        [type_courseBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        tapCourse = NO;
        
    } else {
        
        [type_courseBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        tapCourse = YES;
    }
}

- (IBAction)tapLessonTypeBtn:(id)sender {
    
    if (tapLesson) {
        
        [type_lessonBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        tapLesson = NO;
        
    } else {
        
        [type_lessonBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        tapLesson = YES;
    }
}

- (IBAction)tapEventTypeBtn:(id)sender {
    
    if (tapEvent) {
        
        [type_eventBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        tapLesson = NO;
        
    } else {
        
        [type_eventBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        tapLesson = YES;
    }
}

- (IBAction)tapLocationBtn:(id)sender {
    
    [self.view addSubview:indicator];
    
    tapLocation = YES;
    
    tapAge = NO;
    
    [webConnection startConnectionWithString:@"country" HttpMethodType:Post_Type HttpBodyType:@{} Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([webConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            countryArray = [receivedData valueForKey:@"country"];
            
            [self showListData:[[countryArray valueForKey:@"Country"] valueForKey:@"country_name"] allowMultipleSelection:NO selectedData:[whereBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Country"];
        }
    }];
}

- (IBAction)tapMaleBtn:(id)sender {
    
    if (tapMale) {
        
        [gender_MaleBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        tapMale = NO;
        
    } else {
        
        [gender_MaleBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        tapMale = YES;
    }
}

- (IBAction)tapFemaleBtn:(id)sender {
    
    if (tapFemale) {
        
        [gender_femaleBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        tapFemale = NO;
        
    } else {
        
        [gender_femaleBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        tapFemale = YES;
    }
}

- (IBAction)tapAgeBtn:(id)sender {
    
    tapAge = YES;
    
    tapLocation = NO;
    
    ageArray = @[@{@"id":@"1",@"name":@"Babies (0 - 1 yrs.)"}, @{@"id":@"2",@"name":@"Toddlers (1 - 2 yrs.)"}, @{@"id":@"3",@"name":@"Pre-School Children (2 - 5 yrs.)"}, @{@"id":@"4",@"name":@"Early Primary Students (5 - 7 yrs.)"}, @{@"id":@"5",@"name":@"Primary Students (7 - 12 yrs.)"},@{@"id":@"6",@"name":@"Early Secondary Students (12 - 14 yrs.)"},@{@"id":@"7",@"name":@"Secondary Students (15 - 18 yrs.)"}, @{@"id":@"8",@"name":@"Tertiary Students (18 yrs. +)"}, @{@"id":@"9",@"name":@"Professional Students (18 yrs. +)"}, @{@"id":@"10",@"name":@"Adult Students (18 yrs. +)"}];
    
    [self showListData:[ageArray valueForKey:@"name"] allowMultipleSelection:YES selectedData:[ageBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Interests"];
}

- (IBAction)tapLangBtn:(id)sender {
    
    //mercury.promaticstechnologies.com/ecaHub/WebServices/find_list
    [self.view addSubview:indicator];
    
    tapLang = YES;
    
    tapAge = NO;
    
    [webConnection startConnectionWithString:@"find_list" HttpMethodType:Post_Type HttpBodyType:@{} Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([webConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            langArray = [receivedData valueForKey:@"language_info"];
            
            [self showListData:[[langArray valueForKey:@"Language"] valueForKey:@"name"] allowMultipleSelection:YES selectedData:[whereBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Language"];
        }
    }];
}

- (IBAction)tapCancelBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapSearchBtn:(id)sender {
    
    NSMutableDictionary *paramURL = [[NSMutableDictionary alloc] init];
    NSMutableArray *type_ValueArray = [[NSMutableArray alloc] init];
    NSMutableArray *gender_ValueArray = [[NSMutableArray alloc] init];
    NSMutableArray *lang_ValueArray = [[NSMutableArray alloc] init];
    NSMutableArray *age_ValueArray = [[NSMutableArray alloc] init];
    
    if([to_dateBtn.titleLabel.text isEqualToString:@"  To"]) {
        
        [to_dateBtn setTitle:@"" forState:UIControlStateNormal];
    
    }
    if([from_dateBtn.titleLabel.text isEqualToString:@"  From"]) {
        
        [from_dateBtn setTitle:@"" forState:UIControlStateNormal];
   
    }
    if([whereBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        [whereBtn setTitle:@"" forState:UIControlStateNormal];
    
    }
    if([ageBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        [ageBtn setTitle:@"" forState:UIControlStateNormal];
    
    }
    if([LanguageBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        [LanguageBtn setTitle:@"" forState:UIControlStateNormal];

    }
    if(tapCourse) {
        
        [type_ValueArray addObject:@"Course"];

    }
    if (tapLesson) {
        
        [type_ValueArray addObject:@"Lesson"];

    }
    if (tapEvent) {
        
        [type_ValueArray addObject:@"Event"];
   
    }
    if (tapMale) {
        
        [gender_ValueArray addObject:@"1"];

    }
    if (tapFemale) {
        
        [gender_ValueArray addObject:@"2"];
    
    }
    if (![LanguageBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        NSString *lang_name = LanguageBtn.titleLabel.text;
        
        lang_name = [lang_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSArray *lang_Array = [lang_name componentsSeparatedByString:@", "];
        
        for (int i=0; i < lang_Array.count; i++) {
            
            [lang_ValueArray addObject:[lang_Array objectAtIndex:i]];
        }
    }
    if (![ageBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        NSString *age = age_ids;
        
        age = [age stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSArray *age_Array = [age componentsSeparatedByString:@", "];
        
        for (int i=0; i < age_Array.count; i++) {
            
            [age_ValueArray addObject:[age_Array objectAtIndex:i]];
        }
    }
    
    for (int i=0; i < age_ValueArray.count; i++) {

        [paramURL setObject:[age_ValueArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"age_group[%d]",i]];
    }
    for (int i=0; i < lang_ValueArray.count; i++) {
        
        [paramURL setObject:[lang_ValueArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"language[%d]",i]];
    }
    for (int i=0; i < type_ValueArray.count; i++) {
        
        [paramURL setObject:[type_ValueArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"type[%d]",i]];
    }
    for (int i=0; i < gender_ValueArray.count; i++) {
        
        [paramURL setObject:[gender_ValueArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"gender[%d]",i]];
    }
    
    if (tapLocation) {
        
       [paramURL setObject:country_id forKey:@"venu_country_id"];
    }
    
    [paramURL setObject:from_dateBtn.titleLabel.text forKey:@"start_date"];
    [paramURL setObject:to_dateBtn.titleLabel.text forKey:@"finish_date"];
    [paramURL setObject:specific_textField.text forKey:@"any_keyword"];
   
    NSLog(@"%@",paramURL);
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AdvanceSearchFilter" object:paramURL];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addPicker_toolBar {
    
    datePicker = [[UIDatePicker alloc] init];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
        
    [datePicker setMinimumDate:[NSDate date]];
    
    if (selectedBtn == to_dateBtn) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        [format setDateFormat:@"dd MMM yyyy"];
        
        NSDate *date = [format dateFromString:from_dateBtn.titleLabel.text];
        
        [datePicker setMinimumDate:date];
    }
    
    cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPicker:)];
    
    [cancelBarButton setWidth:50];
    
    doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(donePicker:)];
    
    [doneBarButton setWidth:50];
    
    CGRect frame = datePicker.frame;
    
    frame.origin.y = self.view.frame.size.height - datePicker.frame.size.height;
    
    frame.size.width = self.view.frame.size.width;
    
    datePicker.frame = frame;
    
    datePicker.backgroundColor = [UIColor lightGrayColor];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- datePicker.frame.size.height)-44, self.view.frame.size.width, 44)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[cancelBarButton, flexibleItem, doneBarButton];
    
    [self.view addSubview:toolBar];
    
    [self.view addSubview:datePicker];
}

-(void)cancelPicker:(UIBarButtonItem *)sender {
    
    [toolBar removeFromSuperview];
    
    [datePicker removeFromSuperview];
}

-(void)donePicker:(UIBarButtonItem *)sender {
    
    NSString *date;
        
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"dd MMM yyyy"];
        
    date = [format stringFromDate:[datePicker date]];
        
    if (selectedBtn == to_dateBtn) {
            
        if (([[datePicker date] compare:[format dateFromString:from_dateBtn.titleLabel.text]] == NSOrderedSame) || ([[datePicker date] compare:[format dateFromString:from_dateBtn.titleLabel.text]] == NSOrderedDescending)) {
                
            date = [@"  " stringByAppendingString:date];
                
            [selectedBtn setTitle:date forState:UIControlStateNormal];
                
        } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Finish Date can't be less then start date" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
                [selectedBtn setTitle:@"  Finish Date" forState:UIControlStateNormal];
            }
            
        } else {
            
            date = [@"  " stringByAppendingString:date];
            
            [selectedBtn setTitle:date forState:UIControlStateNormal];
    }
    
    [toolBar removeFromSuperview];
    
    [datePicker removeFromSuperview];
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
    
    if (tapLocation) {
        
        NSString *name = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"country_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [whereBtn setTitle:name forState:UIControlStateNormal];
        
        country_id = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"id"];
        
    } else if (tapAge){
        
        NSString *name = [[[ageArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"state_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [ageBtn setTitle:name forState:UIControlStateNormal];
        
        age_ids = [[[ageArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"id"];
        
    } else if (tapLang) {
        
        NSString *name = [[[langArray objectAtIndex:index] valueForKey:@"Language"] valueForKey:@"name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [LanguageBtn setTitle:name forState:UIControlStateNormal];
        
        lang_ids = [[[langArray objectAtIndex:index] valueForKey:@"Language"] valueForKey:@"id"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSaveItems:(NSArray*)items indexs:(NSArray *)indexs{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *array_selectedInterest = [NSMutableArray array];
    
    NSMutableArray *array_Ids = [NSMutableArray array];
    
    NSArray *listDataArray;
    
    if (tapAge) {
        
        listDataArray = ageArray;
        
    } else {
        
        listDataArray = langArray;
    }
    
    for (NSIndexPath *indexPath in indexs) {
        
     //   NSLog(@"IndexPath:%ld",(long)indexPath.row);
        
        if (indexs.count > listDataArray.count) {
            
            if (indexPath.row < listDataArray.count) {
                
                if (tapAge) {
                    
                    [array_selectedInterest addObject:[listDataArray[indexPath.row] valueForKey :@"name"]];
                    
                    [array_Ids addObject:[listDataArray[indexPath.row] valueForKey :@"id" ]];
                    
                } else {
                    
                    [array_selectedInterest addObject:[[listDataArray[indexPath.row] valueForKey :@"Language"] valueForKey:@"name"]];
                    
                    [array_Ids addObject:[[listDataArray[indexPath.row] valueForKey:@"Language"] valueForKey:@"id"]];
                }
            }
            
        } else {
            
            if (tapAge) {
                
                [array_selectedInterest addObject:[listDataArray[indexPath.row-1] valueForKey :@"name"]];
                
                [array_Ids addObject:[listDataArray[indexPath.row-1] valueForKey :@"id" ]];
                
            } else {
                
                [array_selectedInterest addObject:[[listDataArray[indexPath.row-1] valueForKey :@"Language"] valueForKey:@"name"]];
                
                [array_Ids addObject:[[listDataArray[indexPath.row-1] valueForKey:@"Language"] valueForKey:@"id"]];
            }
        }
    }
    
    NSString *str = [array_selectedInterest  componentsJoinedByString:@", "];
    
    str = [@"  " stringByAppendingString:str];
    
    NSString *str_ids = [array_Ids  componentsJoinedByString:@","];
    
    if (tapAge) {
        
        [ageBtn setTitle:str forState:UIControlStateNormal];
        
        age_ids = str_ids;
        
    } else {
        
        [LanguageBtn setTitle:str forState:UIControlStateNormal];
        
        lang_ids = str_ids;
    }
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegae & UITextField DataSourse

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return true;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGRect frame = scrollView.frame;
    
    frame.origin.y  = -y;
    
    scrollView.frame = frame;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    CGRect frame = scrollView.frame;
    
    frame.origin.y  = 0.0f;
    
    scrollView.frame = frame;
}

@end
