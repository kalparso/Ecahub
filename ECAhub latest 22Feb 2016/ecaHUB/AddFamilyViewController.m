//
//  AddFamilyViewController.m
//  ecaHUB
//
//  Created by promatics on 3/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AddFamilyViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "PopUpView.h"
#import "AddFriends.h"
#import "AddMySearchPrefViewController.h"

@interface AddFamilyViewController () {
    
    UIImagePickerController * imagePicker;
   
    NSMutableArray *images;
    
    NSArray *genderArray;
    
    AddMySearchPrefViewController *mySearchprefVC;
    
    UIPickerView *pickerView;
    
    UIDatePicker *datePicker;
    
    UIToolbar *toolBar;
    
    UIBarButtonItem *cancelButton;
    
    UIBarButtonItem *doneButton;
    
    id activeField;
    
    BOOL tapDob;
    
    BOOL tapGender;
    
    WebServiceConnection *editMemberConn;
    
    WebServiceConnection *interestListConn;
    
    Indicator *indicator;
    
    Validation *validationObj;
    
    NSArray *array_interest;
    
    NSString *catIDs;
    
    NSString *sub_catIds;
    
    NSMutableArray *list_dataArray;
    
    NSMutableArray *cat_subCat_arr;
    
    PopUpView *pop_view;
    
    UITextField *selectedTextfield;
    
}
@end

@implementation AddFamilyViewController

@synthesize f_name, family_name, dob, gender, interestedInBtn, scrollView, no_imgLbl, member_img, chooseImg, saveBtn, cancelBtn, savecancel,interest_text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    cat_subCat_arr = [[NSMutableArray alloc] init];
    
    genderArray = @[@"Select",@"Female", @"Male"];
    
    list_dataArray = [[NSMutableArray alloc] init];
    
    editMemberConn = [WebServiceConnection connectionManager];
    
    interestListConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    validationObj = [Validation validationManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapLater:) name:@"tapLaterAddFamily" object:nil];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
        
        pop_view = [[[NSBundle mainBundle] loadNibNamed:@"popup" owner:self options:nil] objectAtIndex:0];
        
        pop_view.frame = self.view.frame;
        
        pop_view.VC = @"1";
        
        pop_view.remind_label.hidden = YES;
        pop_view.checkbox_buttn.hidden = YES;
        
        [saveBtn setTitle:@"Save & Continue" forState:UIControlStateNormal];
        
        cancelBtn.hidden = YES;
        
        CGRect frame = self.savecancel.frame;
        
        frame.origin.x = (self.view.frame.size.width - 200)/2;
        
        frame.size.width = 200.0f;
        
        self.savecancel.frame = frame;
        
        frame.origin.x = 0.0f;
        
        frame.origin.y = 0.0f;
        
        saveBtn.frame = frame;
        
        pop_view.message.text = @"Create Family Member Profiles to make enrollment and booking as simple as a click. Save their interests so you can easily find what you want on ECAhub. Don’t worry, this is all private information.";
        
        [self.view addSubview:pop_view];
    }

    [self getInterestListService];
    
    [self prepareInterface];
}

-(void)viewWillAppear:(BOOL)animated{
//    if([interestedInBtn.titleLabel.text isEqualToString:nil])
//    {
//        interest_text.hidden = NO;
//    }
//    else{
//        
//        interest_text.hidden = YES;
//    }
//    
}

-(void) tapLater :(NSNotification *) notification {
    
    [pop_view removeFromSuperview];
    
    //[self performSegueWithIdentifier:@"friendsSague" sender:self];
    
    UIStoryboard * storyboard = self.storyboard;
    
    mySearchprefVC = [storyboard instantiateViewControllerWithIdentifier:@"addMySearchPref"];
    
    [self.navigationController pushViewController:mySearchprefVC animated:YES];
       
     //[self performSegueWithIdentifier:@"addSearchPref" sender:self];
}

-(void)prepareInterface {
    
    scrollView.frame = self.view.frame;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    [scrollView addGestureRecognizer:tapScroll];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGRect frame = interest_text.frame;
        frame.size.height = 45;
        interest_text.frame =frame;
        
        CGFloat hieght = 45.0f;
        
        CGRect frameRect = f_name.frame;
        frameRect.size.height = hieght;
        f_name.frame = frameRect;
        
        CGRect frameRect1 = family_name.frame;
        frameRect1.size.height = hieght;
        family_name.frame = frameRect1;
        
        CGRect frameRect2 = dob.frame;
        frameRect2.size.height = hieght;
        dob.frame = frameRect2;
        
        CGRect frameRect3 = gender.frame;
        frameRect3.size.height = hieght;
        gender.frame = frameRect3;
        
        CGRect frameRect4 = interestedInBtn.frame;
        frameRect4.size.height = hieght;
        interestedInBtn.frame = frameRect4;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
    }
    
    chooseImg.layer.cornerRadius = 15.0f;
    saveBtn.layer.cornerRadius = 5.0f;
    cancelBtn.layer.cornerRadius = 5.0f;
    
    f_name.layer.borderWidth = 0.5f;
    f_name.layer.cornerRadius = 5.0f;
    f_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    family_name.layer.borderWidth = 0.5f;
    family_name.layer.cornerRadius = 5.0f;
    family_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    dob.layer.borderWidth = 0.5f;
    dob.layer.cornerRadius = 5.0f;
    dob.layer.borderColor = [UIColor blackColor].CGColor;
    
    gender.layer.borderWidth = 0.5f;
    gender.layer.cornerRadius = 5.0f;
    gender.layer.borderColor = [UIColor blackColor].CGColor;
    
    interestedInBtn.layer.borderWidth = 0.5f;
    interestedInBtn.layer.cornerRadius = 5.0f;
    interestedInBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    gender.inputView = pickerView;
    datePicker = [[UIDatePicker alloc] init];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [datePicker setMaximumDate:[NSDate date]];
    dob.inputView = datePicker;

}

-(void)cancelKeyboard:(UIBarButtonItem *)sender {
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    [selectedTextfield resignFirstResponder];
}

-(void)doneKeyboard:(UIBarButtonItem *)sender {    
        
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
    [format setDateFormat:@"dd MMM yyyy"];
        
    dob.text = [format stringFromDate:[datePicker date]];
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    [selectedTextfield resignFirstResponder];
}

#pragma mark - TextField Delegates & Datasource

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        
    [textField resignFirstResponder];
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 150)];
    
    return TRUE;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = textField.text;
    
    if ([textField.text length] == 1) {
        
        textField.text = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
    }
    
    return true;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [toolBar removeFromSuperview];
    
    if (textField == dob || textField == gender) {
        
        selectedTextfield = textField;
        
        if (textField == dob) {
            
            tapDob = YES;
            tapGender = NO;
            
        } else if (textField == gender) {
            
            tapDob = NO;
            tapGender = YES;
        }
        
        UIStoryboard *storyboard;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
            
            [cancelButton setWidth:70];
            
            doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
            
            [doneButton setWidth:70];
            
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- pickerView.frame.size.height) - 60, self.view.frame.size.width, 60)];
            
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
            
            [cancelButton setWidth:50];
            
            doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
            
            [doneButton setWidth:50];
            
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- pickerView.frame.size.height) - 44, self.view.frame.size.width, 44)];
        }
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        toolBar.items = @[cancelButton,flexibleItem, doneButton];
        
        [self.view addSubview:toolBar];
        
        pickerView = [[UIPickerView alloc] init];
        
        pickerView.delegate = self;
        
        pickerView.dataSource = self;
        
        if (textField == dob) {
            
            datePicker = [[UIDatePicker alloc] init];
            
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            [datePicker setMaximumDate:[NSDate date]];

            textField.inputView = datePicker;
            
        } else {
            
            textField.inputView = pickerView;
        }
        
    }
    return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self setListData];
    
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    activeField = nil;
}


#pragma mark - PickerView Delegates & Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
        return genderArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
        return  [genderArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
        [gender setText:[genderArray objectAtIndex:row]];
}

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

#pragma  mark - get Interest List

-(void)getInterestListService {
    
    NSDictionary *paramUrl = @{};
    
    [interestListConn startConnectionWithString:[NSString stringWithFormat:@"interested_list"] HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary *recievdData) {
       
        NSLog(@"%@",recievdData);
        
        if ([interestListConn responseCode] == 1) {
           
            array_interest = (NSArray *)recievdData;
            
            [self setListData];
            
        }
    }];
}

-(void) setListData {
    
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

- (IBAction)tappedInterestBtn:(id)sender {
    
    if (array_interest == nil || array_interest.count < 1 ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Interest List" message:@"Please wait while interest list is loading" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        
        return;
    }
    
    NSString *selectedData = interestedInBtn.titleLabel.text;
    
    selectedData = [selectedData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    [self showListData:list_dataArray allowMultipleSelection:YES selectedData:[selectedData componentsSeparatedByString:@", "] title:@"Interests"];
    
   
}

-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title{
    ListViewController *listViewController = [[UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil] instantiateViewControllerWithIdentifier:@"ListView"];
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
    
    [interestedInBtn setTitle:cat_interest forState:UIControlStateNormal];
   
    [interestedInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
    catIDs = [array_catIds componentsJoinedByString:@","];
    
    sub_catIds = [array_subCatIds componentsJoinedByString:@","];
    
    NSLog(@"%@\n%@", catIDs,sub_catIds);
    
    if ([array_selectedInterest count] > 0) {
        
        interest_text.hidden =YES;
    }
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedSaveBtn:(id)sender {
    
    NSLog(@"Button Pressed");
    
    NSString *message;
    
    if (![validationObj validateBlankField:f_name.text]) {
        
        message = @"Please enter first name";
  
    } else if (![validationObj validateBlankField:family_name.text]){
        
        message = @"Please enter Last name";
        
    } else if (![validationObj validateBlankField:dob.text]){
        
        message = @"Please enter birth date";
        
    } else if (![validationObj validateBlankField:gender.text] || [gender.text isEqualToString:@"Select"]){
        
        message = @"Please enter gender";
        
    } else if (![validationObj validateBlankField:interestedInBtn.titleLabel.text]){
        
        message = @"Please select your family member's interests.";
   
    } else if ([sub_catIds length] <1) {
        
        message = @"Please select your family member's interests.";
    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        
        [self.view addSubview:indicator];
        
        NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"first_name" : f_name.text, @"family_name" : family_name.text, @"birth_date" : dob.text, @"gender" : gender.text, @"category_id" : catIDs, @"subcategory_id" : sub_catIds};
        
        [editMemberConn startConnectionToUploadMultipleImagesWithString:[NSString stringWithFormat:@"add_family"] images:images HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
            
            if ([editMemberConn responseCode] == 1) {
                
                [indicator removeFromSuperview];
                
                NSLog(@"%@", receivedData);
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
                    
                    [self performSegueWithIdentifier:@"friendssegue" sender:self];
              
                } else {
                    
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Member details have been updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    
//                    [alert show];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                
                [self.navigationController.navigationBar setUserInteractionEnabled:YES];
            }
        }];
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
            
            [member_img setImage:imagePickedFromLib];
            
        } else {
            
            [member_img setImage:imagePickedFromLib];
        }
        
        self.profile_Image = imagePickedFromLib;
        
        no_imgLbl.text = @"Image Attached";
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

- (IBAction)tappedChooseImg:(id)sender {
    
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
 //   [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
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
    
    scrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    
    //[scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    [selectedTextfield resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    [toolBar removeFromSuperview];
    
    [self.view endEditing:YES];
    
    [selectedTextfield resignFirstResponder];
}

@end


