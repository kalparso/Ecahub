//
//  EditEventOtherFeesAndChargesViewController.m
//  ecaHUB
//
//  Created by promatics on 10/19/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EditEventOtherFeesAndChargesViewController.h"
#import "WebServiceConnection.h"
#import "Validation.h"
#import "Indicator.h"
#import "editSessionOptionsListingViewController.h"

@interface EditEventOtherFeesAndChargesViewController (){
    
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
    
    NSString *othercharges_deposite_id,*currencyAccpt_id;
    
    id activeField;
    
    NSArray *currencyArray;
    
    NSMutableDictionary *finalDict;
    
    
    NSString *pickerValue;
    
    NSString *data_id;
    
    NSInteger pickerIndex;
    
}

@end

@implementation EditEventOtherFeesAndChargesViewController

@synthesize saveAndAddSessionBtn,bookMaterialText,currencyBtn,bookMaterialBtn,otherChargesBtn,otherChargesText,securityBtn,securityDepositText,scroll_view,EventDataDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Edit Fees & Charges";
    
    NSLog(@"%@", EventDataDict);
    
    currencyBtn.layer.borderWidth = 1.0f;
    
    currencyBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    currencyBtn.layer.cornerRadius = 5;
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    getConn = [WebServiceConnection connectionManager];
    
    setConn = [WebServiceConnection connectionManager];
    
    bookMaterialBtn.userInteractionEnabled = NO;
    
    securityBtn.userInteractionEnabled = NO;
    
    otherChargesBtn.userInteractionEnabled = NO;
    
    otherChargesText.textColor = [UIColor darkGrayColor];
    
    NSLog(@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"]);
    
    [currencyBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    [bookMaterialBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    [securityBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    [otherChargesBtn setTitle: [@"  " stringByAppendingString:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"]valueForKey:@"b_m_currency"] valueForKey:@"name"]] forState:UIControlStateNormal];
    
    
    bookMaterialText.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"quantity_books_materials"];
    
    securityDepositText.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"quantity_security"];
    
    otherChargesText.text = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"other_charges"];
    
    currencyAccpt_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"currency"];
    
    books_material_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"currency"];
    
    security_deposite_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"currency_security"];
    
    othercharges_deposite_id = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"other_charges_currency"];
    
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    validation = [Validation validationManager];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        [scroll_view setContentSize:CGSizeMake(self.view.frame.size.width, 1050)];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        [scroll_view setContentSize:CGSizeMake(self.view.frame.size.width, 500)];
    }
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    [scroll_view addGestureRecognizer:tapScroll];
    
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePickerView)];
    
    saveAndAddSessionBtn.layer.cornerRadius =5;
    
    // tapgest.cancelsTouchesInView = NO;
    
    // [self.view addGestureRecognizer:tapgest];
    
    //  finalDict = [[NSMutableDictionary alloc]init];
    // Dispose of any re
    // Do
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

//
//  EventOtherFeesAndChargesViewController.m
//  ecaHUB
//
//  Created by promatics on 9/8/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

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
    
    data_id = [[[pickerArray objectAtIndex:pickerIndex] valueForKey:@"Currency"]  valueForKey:@"id"];
    
    pickerValue = [[[pickerArray objectAtIndex:pickerIndex] valueForKey:@"Currency"] valueForKey:@"name"];
    
    pickerValue = [@"  " stringByAppendingString:pickerValue];
    
    currencyAccpt_id = [[[pickerArray objectAtIndex:pickerIndex] valueForKey:@"Currency"]  valueForKey:@"id"];
    
    [currencyBtn setTitle:pickerValue forState:UIControlStateNormal];
    
    //  pickerValue = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"] valueForKey:@"name"];
    
    [bookMaterialBtn setTitle:pickerValue forState:UIControlStateNormal];
    
    books_material_id = data_id;
    
    [securityBtn setTitle:pickerValue forState:UIControlStateNormal];
    
    security_deposite_id = data_id;
    
    [otherChargesBtn setTitle:pickerValue forState:UIControlStateNormal];
    
    othercharges_deposite_id = data_id;
    
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
            
            pickerIndex = row;
            
            //            data_id = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"]  valueForKey:@"id"];
            //
            //            pickerValue = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"] valueForKey:@"name"];
            //
            //            pickerValue = [@"  " stringByAppendingString:pickerValue];
            //
            //            currencyAccpt_id = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"]  valueForKey:@"id"];
            //
            //            [currencyBtn setTitle:pickerValue forState:UIControlStateNormal];
            //
            //            //  pickerValue = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"] valueForKey:@"name"];
            //
            //            [bookMaterialBtn setTitle:pickerValue forState:UIControlStateNormal];
            //
            //            books_material_id = data_id;
            //
            //            [securityBtn setTitle:pickerValue forState:UIControlStateNormal];
            //
            //            security_deposite_id = data_id;
            //
            //            [otherChargesBtn setTitle:pickerValue forState:UIControlStateNormal];
            //
            //            othercharges_deposite_id = data_id;
            
            break;
        }
            
        default:
            break;
    }
}
//-(void)sizeScrollView{
//
//    CGRect frame = size_view.frame;
//
//    frame.origin.y = cancellation_textfield.frame.size.height + cancellation_textfield.frame.origin.y + 20;
//
//    // frame.origin.x = cancellation_textfield.frame.origin.x;
//
//    size_view.frame = frame;
//
//
//}
-(void) showPicker {
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
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
    
    NSDictionary *paramURL =@{};
    
    [self.view addSubview:indicator];
    
    [getConn startConnectionWithString:@"get_currency" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if([getConn responseCode]==1)
        {
            
            NSLog(@"%@",receivedData);
            
            pickerArray =[receivedData valueForKey:@"info"];
            
            list_index = @"10";
            
            pickerIndex = 0;
            
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
    
    if([otherChargesText.text length]==0){
        
        otherChargesText.text = @"";
    }
    
    
    if ([currencyBtn.titleLabel.text isEqualToString:@"  Select Currency"]) {
        
        message = @"Please select your normal currency even if you do not charge the optional other fees in this section";
        
    } else if(![validation validateNumber:otherChargesText.text] && (![otherChargesText.text isEqualToString:@""])) {
        
        message = @"Please enter an amount for Other Charges with two decimal places.";
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
        
        NSLog (@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"]);
        
        if (![[EventDataDict valueForKey:@"newcat_id"]isEqualToString:@""]) {
            
            
            paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"event_id" :[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"event_id"],
                         @"event_name":[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"event_name"],
                         @"no_img":[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"no_img"],
                         @"event_description":[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"event_description"],
                         
                         @"type":[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"event_type"],
                         @"event_duration_hours":[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"event_duration_hours"],
                         @"event_duration_minutes":[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"event_duration_minutes"],
                         @"payment_deadline":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"payment_deadline"],
                         @"deposit":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"deposit"],
                         @"change_booking":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"change_booking"],
                         @"cancellation":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"cancellation"],
                         @"refund":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"refund"],
                         @"make_up_lessons":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"make_up_events"],
                         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],
                         @"currency":currencyAccpt_id,
                         @"other_charges_currency":currencyAccpt_id,
                         @"other_charges":otherChargesText.text,
                         
                         @"country_id" :[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"country_id"],
                         @"new_category":[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"new_category"],@"new_category_name":[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"new_category_name"],@"state_id":[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"state_id"],@"city_id":[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"city_id"]
                         };
            
            
        } else{
            paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"event_id" :[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"event_id"],
                         @"event_name":[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"event_name"],
                         @"no_img":[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"no_img"],
                         @"event_description":[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"event_description"],
                         @"category_id": [[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"category_id"],
                         @"subcategory_id":[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"subcategory_id"],
                         @"type":[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"event_type"],
                         @"event_duration_hours":[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"event_duration_hours"],
                         @"event_duration_minutes":[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"event_duration_minutes"],
                         @"payment_deadline":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"payment_deadline"],
                         @"deposit":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"deposit"],
                         @"change_booking":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"change_booking"],
                         @"cancellation":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"cancellation"],
                         @"refund":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"refund"],
                         @"make_up_lessons":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"make_up_events"],
                         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],
                         @"currency":currencyAccpt_id,
                         
                         @"other_charges_currency":currencyAccpt_id,
                         @"other_charges":otherChargesText.text,
                         
                         @"country_id" :[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"country_id"],
                         @"state_id":[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"state_id"],@"city_id":[[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"city_id"]
                         };
            
        }
        
        NSLog(@"%@",paramURL);
        
        NSString *event_id = [paramURL valueForKey:@"event_id"];
        
        [[NSUserDefaults standardUserDefaults]setValue:event_id forKey:@"course_id"];
        
        //  NSArray *educator_img = [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"identity"];
        
        // [all_imageArray addObjectsFromArray:logoImgArray];
        
        // [all_imageArray addObjectsFromArray:educator_img];
        // @"event_id" : course_id,add_events;
        
        NSArray *all_imageArray = [EventDataDict valueForKey:@"imageArray"];
        
        all_imageArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"all_imageArray"];
        
        [setConn startConnectionToUploadMultipleImagesWithString:[NSString stringWithFormat:@"add_events"] images:all_imageArray HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([setConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                    
                    NSString *c_id = [[EventDataDict valueForKey:@"paramURL2"]valueForKey:@"event_id"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:c_id forKey:@"course_id"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"session_type"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"type"] forKey:@"event_type"];
                    
                    //editsessionVc.type = 1;

                    editSessionOptionsListingViewController *editSessVc = [self.storyboard instantiateViewControllerWithIdentifier:@"sessionVC"];
                    
                    editSessVc.listing_type = @"2";
                    
                    [self.navigationController pushViewController:editSessVc animated:YES];
                    
                    
                    //[self performSegueWithIdentifier:@"EventSessionSegue" sender:self];
                    
                    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"educator_data"];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Term_CondData"];
                    
                    NSString *message = [[@"The first part of the listing " stringByAppendingString:[[EventDataDict valueForKey:@"paramURL1"]valueForKey:@"event_name"]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    message = [message stringByAppendingString:@" has been saved. You may now check and edit the Sessions Options."];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    
                    
                    [alert show];
                    
                    //  [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please Fill all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
            }
        }];
        
        /*
         
         paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
         @"course_name":cource_name.text,
         @"no_courseimg":no_courseimg,
         @"course_description":description_textView.text,
         @"category_id": catIDs,
         @"subcategory_id":sub_catIds,
         @"course_type":@"1",
         @"type":type_id,
         @"course_duration_hours":hours.text,
         @"course_duration_minutes":mints.text,
         @"payment_deadline":[[[NSUserDefaults standardUserDefaults]valueForKey:@"Term_CondData"] valueForKey:@"payment_deadline"],
         @"deposit":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"deposit"],
         @"change_enrollment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"change_enrollment"],
         @"cancellation":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"cancellation"],
         @"refund":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"refund"],
         @"make_up_lessons":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"make_up_lessons"],
         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],
         @"currency":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"currency"],
         @"quantity_books_materials":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"quantity_books_materials"],
         @"currency_security":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"currency_security"],
         @"quantity_security":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"quantity_security"],
         @"country_id" : country_id,
         //                         @"description_educator":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"description_educator"],
         //                         @"name_educator":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"name_educator"],
         //                         @"business_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"business_type"],
         //                         @"author_venu_unit" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_unit"],
         //                         @"author_venu_building_name" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_building_name"],
         //                         @"author_venu_street":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_street"],
         //                         @"author_venu_district":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_district"],
         //                         @"author_country_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_country_id"],
         //                         @"author_state_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_state_id"],
         //                         @"author_city_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_city_id"],
         //                         @"year":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"year"],
         //                         @"offer":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"offer"],
         @"state_id":state_id,@"city_id":city_id
         };
         
         */
        
        
    }
    
}



- (IBAction)tap_infofees:(id)sender {
    
    UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:nil message:@"The 'Other Charges' in this section is optional for anything other than the entry fee to your event. If your event is free, you can specify this on the next page. Even if your event is free, please still select the currency of your country in the 'Currency Accepted' question. Thanks." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alrt show];
}
@end

