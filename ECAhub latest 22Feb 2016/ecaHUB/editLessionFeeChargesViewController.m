//
//  editLessionFeeChargesViewController.m
//  ecaHUB
//
//  Created by promatics on 10/20/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "editLessionFeeChargesViewController.h"
#import "WebServiceConnection.h"
#import "Validation.h"
#import "Indicator.h"
#import "editSessionOptionsListingViewController.h"


@interface editLessionFeeChargesViewController ()
{
    
    Indicator *indicator;
    
    WebServiceConnection *getConn;
    
    WebServiceConnection *setConn;
    
    Validation *validation;
    
    UIPickerView *pickerView;
    
    UIToolbar *toolBar;
    
    UIBarButtonItem *cancelButton;
    
    UIBarButtonItem *doneButton;
    
    NSArray *pickerArray;
    
    NSString *list_index;
    
    NSString *deposit_ids;
    
    NSString *servere_ids;
    
    NSString *paymentDead_id;
    
    NSString *changes_enrol_id;
    
    NSString *cancellation_id;
    
    NSString *refund_id;
    
    NSString *make_up_id;
    
    NSString *books_material_id;
    
    NSString *security_deposite_id;
    
    NSString *course_id;
    
    NSString *othercharges_deposite_id,*currencyAccpt_id;
    
    id activeField;
    
    NSArray *currencyArray;
    
    NSMutableDictionary *finalDict;
    
    BOOL ispickerscroll;
    
}
@end

@implementation editLessionFeeChargesViewController

@synthesize saveAndAddSessionBtn,bookMaterialText,currencyBtn,bookMaterialBtn,otherChargesBtn,otherChargesText,securityBtn,securityDepositText,lessonDict,scroll_view;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Edit Fees & Charges";
    
    ispickerscroll = NO;
    
    // [[NSUserDefaults standardUserDefaults] setValue:term_conData forKey:@"Term_CondData"];
    
    NSLog(@"%@", lessonDict);
    
    NSLog(@"  %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"]);
    
    currencyBtn.layer.borderWidth = 1.0f;
    
    currencyBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    currencyBtn.layer.cornerRadius = 5;
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    getConn = [WebServiceConnection connectionManager];
    
    setConn = [WebServiceConnection connectionManager];
    
    bookMaterialBtn.userInteractionEnabled = NO;
    
    securityBtn.userInteractionEnabled = NO;
    
    otherChargesBtn.userInteractionEnabled = NO;
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    validation = [Validation validationManager];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        //[scroll_view setContentSize:CGSizeMake(self.view.frame.size.width, 1050)];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        //[scroll_view setContentSize:CGSizeMake(self.view.frame.size.width, 580)];
    }
    
    [self registerForKeyboardNotifications];
    
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    saveAndAddSessionBtn.layer.cornerRadius =5;
    
    tapgest.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapgest];
    
    [self setData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setData {
    
    course_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"id"];
    
    [currencyBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    [bookMaterialBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    [securityBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    [otherChargesBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    NSString *str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    
    
    //[securityBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"security_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    //[otherChargesBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"other_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    bookMaterialText.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_books_materials"];
    
    str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    securityDepositText.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_security"];
    
    str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    otherChargesText.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges"];
    
    str = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    currencyAccpt_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"currency"];
    
    books_material_id = currencyAccpt_id;
    
    security_deposite_id = currencyAccpt_id;
    
    othercharges_deposite_id = currencyAccpt_id;
    
    
    // books_material_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"currency"];
    
    // security_deposite_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"currency_security"];
    
    // othercharges_deposite_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges_currency"];
}

#pragma mark - Hide Picker View

-(void)hidePickerView {
    
    [toolBar removeFromSuperview];
    [pickerView removeFromSuperview];
}

-(void)cancelKeyboard:(UIBarButtonItem *)sender {
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
}

-(void)doneKeyboard:(UIBarButtonItem *)sender {
    
    if (ispickerscroll == NO) {
        
        NSString *data_id, *pickerValue;
        
        data_id = [[[pickerArray objectAtIndex:0] valueForKey:@"Currency"]  valueForKey:@"id"];
        
        pickerValue = [[[pickerArray objectAtIndex:0] valueForKey:@"Currency"] valueForKey:@"name"];
        
        pickerValue = [@"  " stringByAppendingString:pickerValue];
        
        currencyAccpt_id = [[[pickerArray objectAtIndex:0] valueForKey:@"Currency"]  valueForKey:@"id"];
        
        [currencyBtn setTitle:pickerValue forState:UIControlStateNormal];
        
        //  pickerValue = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"] valueForKey:@"name"];
        
        [bookMaterialBtn setTitle:pickerValue forState:UIControlStateNormal];
        
        books_material_id = data_id;
        
        [securityBtn setTitle:pickerValue forState:UIControlStateNormal];
        
        security_deposite_id = data_id;
        
        [otherChargesBtn setTitle:pickerValue forState:UIControlStateNormal];
        
        othercharges_deposite_id = data_id;
        
    }
    
    else{
        
        ispickerscroll = NO;
    }
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
}

#pragma mark - PickerView Delegates & Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([list_index isEqualToString:@"10"]) {
        
        return [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"] valueForKey:@"name"];
    } else {
        
        return [[pickerArray objectAtIndex:row] valueForKey:@"name"];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *pickerlbl = (UILabel*)view;
    
    if (!pickerlbl){
        pickerlbl = [[UILabel alloc] init];
    }
    
    pickerlbl.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 30);
    
    [pickerlbl setLineBreakMode:NSLineBreakByClipping];
    
    [pickerlbl  setNumberOfLines:0];
    
    [pickerlbl  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [pickerlbl setFont:[UIFont systemFontOfSize:17]];
    
    pickerlbl.textAlignment = NSTextAlignmentCenter;
    
    //   NSLog(@"%@",[[pickerArray objectAtIndex:row] valueForKey:@"name"]);
    
    NSString *text;
    
    if ([list_index isEqualToString:@"10"]) {
        
        text = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"]  valueForKey:@"name"];
    } else {
        
        text = [[pickerArray objectAtIndex:row] valueForKey:@"name"];
    }
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width - (1.0 * 2), FLT_MAX);
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect lable_frame = pickerlbl.frame;
    
    lable_frame.size.height = size.height + 10;
    
    [pickerlbl  setFrame:lable_frame];
    
    [pickerlbl sizeToFit];
    
    //Set text value
    //   pickerlbl.text = [[pickerArray objectAtIndex:row] valueForKey:@"name"];
    
    if ([list_index isEqualToString:@"10"]) {
        
        pickerlbl.text = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"]  valueForKey:@"name"];
        
    } else {
        
        pickerlbl.text = [[pickerArray objectAtIndex:row] valueForKey:@"name"];
    }
    
    
    return pickerlbl;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    UILabel *pickerlbl = [[UILabel alloc] init];
    
    pickerlbl.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 30);
    
    [pickerlbl setLineBreakMode:NSLineBreakByClipping];
    
    [pickerlbl  setNumberOfLines:0];
    
    [pickerlbl  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [pickerlbl setFont:[UIFont systemFontOfSize:17]];
    
    NSString *text;
    
    if ([list_index isEqualToString:@"10"]) {
        
        text = [[[pickerArray objectAtIndex:2] valueForKey:@"Currency"]  valueForKey:@"name"];
        
    } else {
        
        text = [[pickerArray objectAtIndex:2] valueForKey:@"name"];
    }
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width - (1.0 * 2), FLT_MAX);
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect lable_frame = pickerlbl.frame;
    
    lable_frame.size.height = size.height + 10;
    
    [pickerlbl sizeToFit];
    
    CGFloat height = size.height + 10;
    
    if (height < 50.0) {
        
        height = 50.0f;
    }
    return height;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *pickerValue;
    
    NSString *data_id;
    
    if ([list_index isEqualToString:@"10"]) {
        
        //text = [[[pickerArray objectAtIndex:2] valueForKey:@"Currency"]  valueForKey:@"name"];
        
    } else {
        
        pickerValue = [[pickerArray objectAtIndex:row] valueForKey:@"name"];
        
        data_id = [[pickerArray objectAtIndex:row] valueForKey:@"id"];
        
        pickerValue = [@"  " stringByAppendingString:pickerValue];
        
    }
    
    switch ([list_index intValue]) {
        case 0:{
            
            //   [paymentDeadLineBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            paymentDead_id = data_id;
            break;
            
        }  case 1:{
            
            [securityBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            break;
            
        }  case 2:{
            
            //   [changeEnrollmentBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            changes_enrol_id = data_id;
            break;
            
        }  case 3:{
            
            //  [cancellationBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            cancellation_id = data_id;
            
            if ([cancellation_id isEqualToString:@"3"]) {
                
                //      cancellation_textfield.hidden = NO;
                
                //[self sizeScrollView];
                
            }
            else{
                
                //       cancellation_textfield.hidden = YES;
            }
            break;
            
        }  case 4:{
            
            //     [refundBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            refund_id = data_id;
            break;
            
        }  case 5:{
            
            //       [make_upLessionBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            make_up_id = data_id;
            break;
            
        }  case 6:{
            
            //       [servere_weatherBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            //servere_ids = data_id;
            break;
            
        }  case 7:{
            
            [bookMaterialBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            books_material_id = data_id;
            
            [securityBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            security_deposite_id = data_id;
            
            [otherChargesBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            othercharges_deposite_id = data_id;
            
            break;
            
        }  case 8:{
            
            [securityBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            security_deposite_id = data_id;
            
            break;
            
        }  case 9:{
            
            [otherChargesBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            othercharges_deposite_id = data_id;
            
            break;
        } case 10:{
            
            ispickerscroll = YES;
            
            data_id = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"]  valueForKey:@"id"];
            
            pickerValue = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"] valueForKey:@"name"];
            
            pickerValue = [@"  " stringByAppendingString:pickerValue];
            
            currencyAccpt_id = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"]  valueForKey:@"id"];
            
            [currencyBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            //  pickerValue = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"] valueForKey:@"name"];
            
            [bookMaterialBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            books_material_id = data_id;
            
            [securityBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            security_deposite_id = data_id;
            
            [otherChargesBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            othercharges_deposite_id = data_id;
            
            break;
        }
            
        default:
            break;
    }
}

-(void) showPicker {
    
    [toolBar removeFromSuperview];
    
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
    
    [cancelButton setWidth:100];
    
    doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
    
    [doneButton setWidth:100];
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    CGRect frame = pickerView.frame;
    
    frame.origin.y = self.view.frame.size.height - frame.size.height - 40;
    
    frame.size.width = self.view.frame.size.width;
    
    pickerView.frame = frame;
    
    pickerView.backgroundColor = [UIColor lightGrayColor];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- pickerView.frame.size.height) - 84, self.view.frame.size.width, 44)];
    
    toolBar.backgroundColor = [UIColor darkGrayColor];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[cancelButton,flexibleItem, doneButton];
    
    [self.view addSubview:toolBar];
    
    [self.view addSubview:pickerView];
}


#pragma mark - list delegate

-(void)didSelectListItem:(id)item index:(NSInteger)index{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSaveItems:(NSArray*)items indexs:(NSArray *)indexs{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *array_selectedInterest = [NSMutableArray array];
    
    NSMutableArray *array_Ids = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in indexs) {
        
        NSLog(@"IndexPath:%ld",(long)indexPath.row);
        
        if (indexs.count > pickerArray.count) {
            
            if (indexPath.row < pickerArray.count) {
                
                [array_selectedInterest addObject:[pickerArray[indexPath.row] valueForKey :@"name" ]];
                
                [array_Ids addObject:[pickerArray[indexPath.row] valueForKey :@"id" ]];
            }
            
        } else {
            
            [array_selectedInterest addObject:[pickerArray[indexPath.row-1] valueForKey:@"name"]];
            
            [array_Ids addObject:[pickerArray[indexPath.row-1] valueForKey :@"id" ]];
        }
    }
    
    NSString *str = [array_selectedInterest  componentsJoinedByString:@", "];
    
    str = [@"  " stringByAppendingString:str];
    
    NSString *str_ids = [array_Ids  componentsJoinedByString:@","];
    
    if ([list_index isEqualToString:@"1"]) {
        
        [securityBtn setTitle:str forState:UIControlStateNormal];
        
        deposit_ids = str_ids;
        
    } else if ([list_index isEqualToString:@"6"]){
        
        // [servere_weatherBtn setTitle:str forState:UIControlStateNormal];
        
        servere_ids = str_ids;
    }
}
#pragma mark - TextField Delegates & Datasource

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (textField == bookMaterialText|| textField == securityDepositText|| textField == otherChargesText) {
        
        if (![validation validateNumber:textField.text]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please enter an amount with two decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
    
    return TRUE;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    
    scroll_view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    // [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    //  [self animateTextField: textField up: NO];
}

- (void)animateTextField:(UITextField*)textField up:(BOOL) up {
    
    const int movementDistance = -(self.view.frame.size.height - textField.frame.origin.y - 50);
    
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
    
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(67, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        //    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1600)];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        //     [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1200)];
    }
    
    scroll_view.contentInset = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbHeight;
    
    UIView *activeView = activeField;
    
    if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
        
        [scroll_view scrollRectToVisible: activeView.frame  animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scroll_view.contentInset = contentInsets;
    
    scroll_view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    
    scroll_view.scrollIndicatorInsets = contentInsets;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    [self.view endEditing:YES];
}

- (IBAction)tap_Currency:(id)sender {
    
    ispickerscroll = NO;
    
    NSDictionary *paramURL =@{};
    
    [self.view addSubview:indicator];
    
    [getConn startConnectionWithString:@"get_currency" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if([getConn responseCode]==1)
        {
            
            NSLog(@"%@",receivedData);
            
            pickerArray =[receivedData valueForKey:@"info"];
            
            list_index = @"10";
            
            [self showPicker];
        }
    }];
}
- (IBAction)tap_BookMaterialBtn:(id)sender {
    
    list_index = @"7";
    
    pickerArray = @[@{@"id":@"0", @"name":@"Select"},@{@"id":@"0", @"name":@"HKD"},@{@"id":@"1", @"name":@"SGD"},@{@"id":@"2", @"name":@"THB"},@{@"id":@"3", @"name":@"MYR"},@{@"id":@"4", @"name":@"PHP"},@{@"id":@"5", @"name":@"IRD"},@{@"id":@"6", @"name":@"RMB"},@{@"id":@"7", @"name":@"USD"}];
    
    // [self showPicker];
}
- (IBAction)tap_SecurityBtn:(id)sender {
}
- (IBAction)tap_OtherChargesBtn:(id)sender {
    
    list_index = @"9";
    
    pickerArray = @[@{@"id":@"0", @"name":@"Select"},@{@"id":@"0", @"name":@"HKD"},@{@"id":@"1", @"name":@"SGD"},@{@"id":@"2", @"name":@"THB"},@{@"id":@"3", @"name":@"MYR"},@{@"id":@"4", @"name":@"PHP"},@{@"id":@"5", @"name":@"IRD"},@{@"id":@"6", @"name":@"RMB"},@{@"id":@"7", @"name":@"USD"}];
    
    //[self showPicker];
}
- (IBAction)tap_SaveAndAddSessionBtn:(id)sender {
    
    NSString *message;
    
    NSString *currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    if ([currency isEqualToString:@""] || [currencyBtn.titleLabel.text isEqualToString:@""]) {
        
        message = @"Please select currency";
        
    } else if (![bookMaterialText.text isEqualToString:@""]) {
        
        if (![validation validateNumber:bookMaterialText.text]) {
            
            message = @"Please enter valid price for books and material with two decimal places.";
        }
    } else if (![securityDepositText.text isEqualToString:@""]) {
        
        if (![validation validateNumber:securityDepositText.text]) {
            
            message = @"Please enter valid price for security deposit with two decimal places.";
        }
    } else if(![otherChargesText.text isEqualToString:@""]) {
        
        if (![validation validateNumber:otherChargesText.text]) {
            
            message = @"Please enter valid price for other charge security deposit with two decimal places.";
        }
    }
    
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        
        NSString *currecy_name = currencyBtn.titleLabel.text;
        
        currecy_name = [currecy_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSDictionary *dict = @{@"currency_id":currencyAccpt_id,@"currency_name":currecy_name};
        
        [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"Currency"];
        
        
        //  NSLog(@"%@", term_conData);
        
        // [[NSUserDefaults standardUserDefaults] setValue:term_conData forKey:@"Term_CondData"];
        
        
        NSDictionary *paramURL;
        
        NSLog(@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"description_educator"]);
        
        [self.view addSubview:indicator];
        
        NSLog(@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"enrollment"]);
        
        if (![[lessonDict valueForKey:@"newcat_id"]isEqualToString:@""]) {
            
            
            paramURL = @{@"lesson_id":course_id,@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
                         @"lesson_name":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"lesson_name"],
                         @"no_img":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"no_img"],
                         @"lesson_description":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"lesson_description"],
                         
                         @"lesson_type":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"lesson_type"],
                         @"type":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"type"],
                         @"lesson_duration_hours":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"lesson_duration_hours"],
                         @"lesson_duration_minutes":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"lesson_duration_minutes"],
                         @"enrollment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"enrollment"],
                         @"payment_deadline":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"payment_deadline"],
                         @"deposit":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"deposit"],
                         @"cancellation":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"cancellation"],
                         @"refund":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"refund"],
                         @"make_up_lessons":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"make_up_lessons"],
                         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],@"minimum_payment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"minimum_payment"],
                         @"currency":books_material_id,
                         @"quantity_books_materials":bookMaterialText.text,
                         @"currency_security":security_deposite_id,
                         @"quantity_security":securityDepositText.text,
                         @"other_charges_currency":othercharges_deposite_id,
                         @"other_charges":otherChargesText.text,
                         @"country_id" :[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"country_id"],
                         
                         @"new_category":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"new_category"],@"new_category_name":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"new_category_name"],@"state_id":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"state_id"],@"city_id":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"city_id"]
                         };
            
            
        } else{
            paramURL = @{@"lesson_id":course_id,@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
                         @"lesson_name":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_name"],
                         @"no_img":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"no_img"],
                         @"lesson_description":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_description"],
                         @"category_id": [[lessonDict valueForKey:@"paramURL2"]valueForKey:@"category_id"],
                         @"subcategory_id":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"subcategory_id"],
                         @"lesson_type":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_type"],
                         @"type":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"type"],
                         @"lesson_duration_hours":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_duration_hours"],
                         @"lesson_duration_minutes":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_duration_minutes"],
                         @"enrollment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"enrollment"],
                         @"payment_deadline":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"payment_deadline"],
                         @"deposit":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"deposit"],
                         @"cancellation":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"cancellation"],
                         @"refund":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"refund"],
                         @"make_up_lessons":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"make_up_lessons"],
                         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],@"minimum_payment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"minimum_payment"],
                         @"currency":books_material_id,
                         @"quantity_books_materials":bookMaterialText.text,
                         @"currency_security":security_deposite_id,
                         @"quantity_security":securityDepositText.text,
                         @"other_charges_currency":othercharges_deposite_id,
                         @"other_charges":otherChargesText.text,
                         @"country_id" :[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"country_id"],
                         
                         @"state_id":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"state_id"],@"city_id":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"city_id"]
                         };
            
        }
        
        NSLog(@"%@",paramURL);
        
        
        NSArray *all_imageArray = [lessonDict valueForKey:@"imageArray"];
        
        [setConn startConnectionToUploadMultipleImagesWithString:[NSString stringWithFormat:@"add_lesson"] images:all_imageArray HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([setConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                                      
                    
                    [[NSUserDefaults standardUserDefaults] setValue:course_id forKey:@"course_id"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"session_type"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"type"] forKey:@"Lesson_Type"];
                    
                    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"educator_data"];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Term_CondData"];
                    
                    NSString *lesson_nm = [[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_name"];
                    
                    NSString *message = [[@"The first part of the listing " stringByAppendingString:lesson_nm]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    message = [message stringByAppendingString:@" has been updated. You may now check and edit the Sessions Options."];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    
                    editSessionOptionsListingViewController *editSessVc = [self.storyboard instantiateViewControllerWithIdentifier:@"sessionVC"];
                    
                    editSessVc.listing_type = @"3";
                    
                    [self.navigationController pushViewController:editSessVc animated:YES];
                    
                    
                    
                    
                    //[self performSegueWithIdentifier:@"LessonSessionSegue" sender:self];
                    
                    //  [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please Fill all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
            }
        }];
        
        
    }
    
}


@end
