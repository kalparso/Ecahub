//
//  UpdateMemberViewController.m
//  ecaHUB
//
//  Created by promatics on 3/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "UpdateMemberViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "URL.h"
#import "MyFamilyViewController.h"

@interface UpdateMemberViewController () {
    
    UIImagePickerController * imagePicker;
    
    MyFamilyViewController *myfamily;
    
    NSMutableArray *images;
    
    NSArray *genderArray;
    
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
    
    UITextField *selectedTextfield;
}
@end

@implementation UpdateMemberViewController

@synthesize f_name, family_name, dob, member_img, img_view, interestedInBtn, saveBtn, cancelBtn, changeImgBtn, gender, scrollView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    cat_subCat_arr = [[NSMutableArray alloc] init];
    
    genderArray = @[@"Select",@"Female", @"Male"];
    
    list_dataArray = [[NSMutableArray alloc] init];
    
    editMemberConn = [WebServiceConnection connectionManager];
    
    interestListConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    validationObj = [Validation validationManager];
    
//    [self getInterestListService];
    
    [self prepareInterface];
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
        
        img_view.layer.cornerRadius = 75.0f;
        
        img_view.layer.borderWidth = 12.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        img_view.layer.cornerRadius = 40.0f;
        
        img_view.layer.borderWidth = 6.0f;
    }
    
    img_view.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Text_colore"]].CGColor;
    
    changeImgBtn.layer.cornerRadius = 15.0f;
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
    
     NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"]);
     
     f_name.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"first_name"];
     
     family_name.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"family_name"];
     
     NSString *date_str = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"birth_date"];
     
     NSArray *arr = [date_str componentsSeparatedByString:@"00"];
     
     date_str = [arr objectAtIndex:0];
     
     dob.text = date_str;
     
     gender.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"gender"];
     
     NSArray *cat_array = [[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"subcats"];
     
     NSMutableArray *categories = [[NSMutableArray alloc] init];
     
     for (int i = 0; i < cat_array.count; i++) {
     
     [categories addObject:[[[cat_array objectAtIndex:i] valueForKey:@"Subcategory"] valueForKey:@"subcategory_name"]];
     }
    
    catIDs =  [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"category_id"];
    
    sub_catIds = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"subcategory_id"];
     
     NSString *cat_interest = [categories componentsJoinedByString:@", "];
    
    cat_interest = [@"  " stringByAppendingString:cat_interest];
    
     NSLog(@"%@", cat_interest);
     
  //   interestedInBtn.titleLabel.text = cat_interest;
    
    [interestedInBtn setTitle:cat_interest forState:UIControlStateNormal];
    
     NSString *imageURL = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"picture"];
     
     imageURL = [imageURL stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
     
     if ([imageURL length] > 1) {
     
         imageURL = [FamilyImage stringByAppendingString:imageURL];
     
         [self downloadImageWithString:imageURL];
     
     } else {
     
         member_img.image = [UIImage imageNamed:@"user_img"];
     }
}

-(void) downloadImageWithString:(NSString *)urlString {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            member_img.image = image;
        }
    }];
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
        
        if (textField == dob) {
            
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
}

#pragma  mark - get Interest List

-(void)getInterestListService {
    
    NSDictionary *paramUrl = @{};
    
    [self.view addSubview:indicator];
    
    [interestListConn startConnectionWithString:[NSString stringWithFormat:@"interested_list"] HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary *recievdData) {
        
        [indicator removeFromSuperview];
        
        NSLog(@"%@",recievdData);
        
        if ([interestListConn responseCode] == 1) {
            
            array_interest = (NSArray *)recievdData;
            
            [self setListData];
            
            NSString *cat = interestedInBtn.titleLabel.text;
            
            cat = [cat stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [self showListData:list_dataArray allowMultipleSelection:YES selectedData:[cat componentsSeparatedByString:@", "] title:@"Interests"];

        }
    }];
}

-(void) setListData {
    
    list_dataArray = [[NSMutableArray alloc]init];
    
    cat_subCat_arr = [[NSMutableArray alloc]init];
    
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
    
    [self getInterestListService];
}

-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title {
    
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
    
    [interestedInBtn setTitle:[array_selectedInterest componentsJoinedByString:@", "] forState:UIControlStateNormal];
    
    [interestedInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    catIDs = [array_catIds componentsJoinedByString:@","];
    
    sub_catIds = [array_subCatIds componentsJoinedByString:@","];
    
    NSLog(@"%@\n%@", catIDs,sub_catIds);
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedSaveBtn:(id)sender {
    
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
        
        message = @"Please select interest";
    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.view addSubview:indicator];
        
        //NSMutableDictionary *member_data =[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"];
        
        NSDictionary *paramURL = @{@"family_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"id"],@"first_name" : f_name.text, @"family_name" : family_name.text, @"birth_date" : dob.text, @"gender" : gender.text, @"category_id" : catIDs, @"subcategory_id" : sub_catIds,@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
        
        [editMemberConn startConnectionToUploadMultipleImagesWithString:[NSString stringWithFormat:@"edit_family"] images:images HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
            
             [indicator removeFromSuperview];
            
            if ([editMemberConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                //  [self.navigationController popViewControllerAnimated:YES];
                
                if ([[receivedData valueForKey:@"code"]integerValue ]== 1) {
                    
                  // [self.navigationController popToRootViewControllerAnimated:YES];
                    //[self.navigationController popViewControllerAnimated:YES];
                    UIStoryboard  *storyboard = self.storyboard;
                    
                    myfamily = [storyboard instantiateViewControllerWithIdentifier:@"MyFamilyVC"];
                    
                    [self.navigationController pushViewController:myfamily animated:YES];
                    //[self popToViewController:myfamily animated:YES];
                    
                 
                }
                
                else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title  message:@"There is some problem.please try again later" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
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
        
       // imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        [self performSelector: @selector(showPhotoGallery) withObject: nil afterDelay: 0];
    }
    else {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
      //  imagePicker.allowsEditing = YES;
        
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
  
        } else if(buttonIndex == 1) {
            
            [self openPictureViewWithCamera:NO];
        }
    } else if (actionSheet.tag == 2) {     //without camera

        if (buttonIndex == 0) {
            
            [self openPictureViewWithCamera:NO];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)tappedChangeImg:(id)sender {
    
    scrollView.frame = self.view.frame;
    
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
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
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
    
    scrollView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
    
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


