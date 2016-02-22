//  OtherFeesAndChargesViewController.m
//  ecaHUB
//  Created by promatics on 9/8/15.
//  Copyright (c) 2015 promatics. All rights reserved.

#import "OtherFeesAndChargesViewController.h"
#import "WebServiceConnection.h"
#import "Validation.h"
#import "Indicator.h"

@interface OtherFeesAndChargesViewController (){
    
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
    
    BOOL ispickerscroll;
    
    int checkCurrency;
    
}

@end

@implementation OtherFeesAndChargesViewController

@synthesize saveAndAddSessionBtn,bookMaterialText,currencyBtn,bookMaterialBtn,otherChargesBtn,otherChargesText,securityBtn,securityDepositText,lessonDict,scroll_view;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Fees & Charges";
    
    ispickerscroll = NO;
    
    // NSLog(@"%@", lessonDict);
    
    checkCurrency =0;
    
    currencyBtn.layer.borderWidth = 1.0f;
    
    currencyBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    currencyBtn.layer.cornerRadius = 5;
    
    [currencyBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    [otherChargesBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    [bookMaterialBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    [securityBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    otherChargesText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"90.00" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    securityDepositText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"90.00" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    bookMaterialText.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"90.00" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
    
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
        
//        [scroll_view setContentSize:CGSizeMake(self.view.frame.size.width, 800)];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
//        [scroll_view setContentSize:CGSizeMake(self.view.frame.size.width, 580)];
    }
    
    [self registerForKeyboardNotifications];
    
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    saveAndAddSessionBtn.layer.cornerRadius =5;
    
    tapgest.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapgest];
    
    //  finalDict = [[NSMutableDictionary alloc]init];
    // Dispose of any re
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
    
    checkCurrency = 1;
    
    if (ispickerscroll == NO) {
        
        
        NSString *pickerValue;
        
        NSString *data_id;
        
        data_id = [[[pickerArray objectAtIndex:0] valueForKey:@"Currency"]  valueForKey:@"id"];
        
        pickerValue = [[[pickerArray objectAtIndex:0] valueForKey:@"Currency"] valueForKey:@"name"];
        
        pickerValue = [@"  " stringByAppendingString:pickerValue];
        
        currencyAccpt_id = [[[pickerArray objectAtIndex:0] valueForKey:@"Currency"]  valueForKey:@"id"];
        
        [currencyBtn setTitle:pickerValue forState:UIControlStateNormal];
        
        [currencyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [bookMaterialBtn setTitle:pickerValue forState:UIControlStateNormal];
        
        [bookMaterialBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        books_material_id = data_id;
        
        [securityBtn setTitle:pickerValue forState:UIControlStateNormal];
        
        [securityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        security_deposite_id = data_id;
        
        [otherChargesBtn setTitle:pickerValue forState:UIControlStateNormal];
        
        [otherChargesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
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
            
            [currencyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            //  pickerValue = [[[pickerArray objectAtIndex:row] valueForKey:@"Currency"] valueForKey:@"name"];
            
            [bookMaterialBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            [bookMaterialBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            books_material_id = data_id;
            
            [securityBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            [securityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            security_deposite_id = data_id;
            
            [otherChargesBtn setTitle:pickerValue forState:UIControlStateNormal];
            
            [otherChargesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            othercharges_deposite_id = data_id;
            
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

//- (IBAction)tappaymentDeadLine:(id)sender {
//
//    pickerArray = @[@{@"id":@"0", @"name":@"Select"},@{@"id":@"0", @"name":@"Payment is required 48 hours prior to commencement of the course"},@{@"id":@"1", @"name":@"Payment is required within 7 days after enrollment confirmation or 7 days before the start of the course, which ever comes first"},@{@"id":@"2", @"name":@"Payment is required immediately upon enrollment confirmation"}];
//
//    list_index = @"0";
//
//    [self showPicker];
//}
//
//- (IBAction)tapChangeEnrollment:(id)sender {
//
//    list_index = @"2";
//
//    pickerArray = @[@{@"id":@"0", @"name":@"Select"}, @{@"id":@"0", @"name":@"Changes to enrollment can be made upon request under certain circumstances"},@{@"id":@"1", @"name":@"Changes to enrollment are not permitted"}];
//
//    [self showPicker];
//}
//
//- (IBAction)tapCancellationBtn:(id)sender {
//
//    list_index = @"3";
//
//    pickerArray = @[@{@"id":@"0", @"name":@"Select"}, @{@"id":@"0", @"name":@"Cancellations are permitted under special circumstances"},@{@"id":@"1", @"name":@"Cancellations can only be made prior to 7 days before course commencement"},@{@"id":@"2", @"name":@"Cancellations are not permitted"},@{@"id":@"3", @"name":@"Other"}];
//
//    [self showPicker];
//}
//
//- (IBAction)tapRefundBtn:(id)sender {
//
//    list_index = @"4";
//
//    pickerArray = @[@{@"id":@"0", @"name":@"Select"}, @{@"id":@"0", @"name":@"Refunds are available"},@{@"id":@"1", @"name":@"Refund upon request only under special circumstances"},@{@"id":@"2", @"name":@"No refund policy"}];
//
//    [self showPicker];
//}
//
//- (IBAction)tapmake_upLession:(id)sender {
//
//    list_index = @"5";
//
//    pickerArray = @[@{@"id":@"0", @"name":@"Select"}, @{@"id":@"0", @"name":@"Make-up lessons are available upon request"},@{@"id":@"1", @"name":@"Make-up lessons can only be arrange due to sickness or travel"},@{@"id":@"2", @"name":@"Make-up lessons are not available"}];
//
//    [self showPicker];
//}

//- (IBAction)tapservere_weather:(id)sender {
//
//    list_index = @"6";
//
//    pickerArray = @[@{@"id":@"0", @"name":@"Lessons are not held during severe weather warnings such as Typhoon 8 & Black Rain Storm Warnings"},@{@"id":@"1", @"name":@"Make-up lessons can be arranged due to forced closures under certain circumstances"},@{@"id":@"2", @"name":@"Make-up classes cannot be arranged due to forced closures"}];
//
//    [self showListData:[pickerArray valueForKey:@"name"] allowMultipleSelection:YES selectedData:[depositeBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Interests"];
//
//}

//-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title {
//
//    ListingViewController *listViewController = [[ListingViewController alloc] init];
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
    
    //    NSLog(@"%@",paymentDeadLineBtn.titleLabel.text);
    
    //    if ([paymentDeadLineBtn.titleLabel.text isEqualToString:@"  Select"]) {
    //
    //        message = @"Please select the payment deadline option";
    //
    //   }
    //    if ([depositeBtn.titleLabel.text isEqualToString:@"  Select"] || [depositeBtn.titleLabel.text isEqualToString:@""] ) {
    //
    //        message = @"Please select the deposit option";
    //    }
    
    //    } else if ([changeEnrollmentBtn.titleLabel.text isEqualToString:@"  Select"]) {
    //
    //        message = @"Please select the change to enrollment option";
    
    //    }   else if ([refundBtn.titleLabel.text isEqualToString:@"  Select"]) {
    //
    //        message = @"Please select the refund option";
    
    //  }
    
    //    else if ([make_upLessionBtn.titleLabel.text isEqualToString:@"  Select"]) {
    //
    //        message = @"Please select the make-up lesson option";
    //
    //    } else if ([servere_weatherBtn.titleLabel.text isEqualToString:@"  Select"] || [depositeBtn.titleLabel.text isEqualToString:@""] ) {
    //
    //        message = @"Please select the severe weather option";
    
    //  }\
    
    NSLog (@"%@", currencyBtn.titleLabel.text);
    
    // if ([currencyBtn.titleLabel.text isEqualToString:@" Select"]) {
    
    if (checkCurrency ==0) {
        
        message = @"Please select currency.";
        
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
        
        
        // [termDataDict valueForKey:@"cancellation"];
        
        //  NSDictionary *term_conData = @{@"payment_deadline":[termDataDict valueForKey:@"payment_deadline"], @"deposit":[termDataDict valueForKey:@"deposit"], @"change_enrollment":[termDataDict valueForKey:@"change_enrollment"],@"cancellation":[termDataDict valueForKey:@"cancellation"], @"refund":[termDataDict valueForKey:@"refund"], @"make_up_lessons":[termDataDict valueForKey:@"make_up_lessons"], @"severe_weather":[termDataDict valueForKey:@"severe_weather"], @"currency":books_material_id, @"quantity_books_materials":bookandMaterialTxt.text, @"currency_security":security_deposite_id,@"quantity_security":depositTxt.text,@"other_charges_currency":othercharges_deposite_id,@"other_charges":otherChargesTxt.text,@"other_cancellation":[termDataDict valueForKey:@"other_cancellation"]};
        
        // NSLog(@"%@",term_conData);
        
        
        //        NSDictionary *term_conData = @{@"payment_deadline":paymentDead_id, @"deposit":deposit_ids, @"change_enrollment":changes_enrol_id,@"cancellation":cancellation_id, @"refund":refund_id, @"make_up_lessons":make_up_id, @"severe_weather":servere_ids, @"currency":books_material_id, @"quantity_books_materials":books_materialPrice.text, @"currency_security":security_deposite_id,@"quantity_security":securityPriceTxtField.text,@"other_charges_currency":othercharges_deposite_id,@"other_charges":othrCharge_textfield.text,@"other_cancellation":cancellation_textfield.text};
        
        NSString *currecy_name = currencyBtn.titleLabel.text;
        
        currecy_name = [currecy_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSDictionary *dict = @{@"currency_id":currencyAccpt_id,@"currency_name":currecy_name};
        
        [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"Currency"];
        
        
        //  NSLog(@"%@", term_conData);
        
        // [[NSUserDefaults standardUserDefaults] setValue:term_conData forKey:@"Term_CondData"];
        
        NSDictionary *paramURL;
        
        NSLog(@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"description_educator"]);
        
        [self.view addSubview:indicator];
        
        if (![[lessonDict valueForKey:@"newcat_id"]isEqualToString:@""]) {
            
            //            paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
            //                         @"lesson_name":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"lesson_name"],
            //                         @"no_img":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"no_img"],
            //                         @"lesson_description":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"lesson_description"],
            //
            //                         @"lesson_type":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"lesson_type"],
            //                         @"type":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"type"],
            //                         @"lesson_duration_hours":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"lesson_duration_hours"],
            //                         @"lesson_duration_minutes":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"lesson_duration_minutes"],
            //                         @"payment_deadline":[[[NSUserDefaults standardUserDefaults]valueForKey:@"Term_CondData"] valueForKey:@"payment_deadline"],
            //                         @"deposit":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"deposit"],
            //                         @"change_enrollment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"change_enrollment"],
            //                         @"cancellation":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"cancellation"],
            //                         @"refund":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"refund"],
            //                         @"make_up_lessons":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"make_up_lessons"],
            //                         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],
            //                         @"currency":books_material_id,
            //                         @"quantity_books_materials":bookMaterialText.text,
            //                         @"currency_security":security_deposite_id,
            //                         @"quantity_security":securityDepositText,
            //                         @"country_id" : [[lessonDict valueForKey:@"paramURL1"]valueForKey:@"country_id"],
            //                         //                         @"description_educator":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"description_educator"],
            //                         //                         @"name_educator":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"name_educator"],
            //                         //                         @"business_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"business_type"],
            //                         //                         @"author_venu_unit" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_unit"],
            //                         //                         @"author_venu_building_name" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_building_name"],
            //                         //                         @"author_venu_street":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_street"],
            //                         //                         @"author_venu_district":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_district"],
            //                         //                         @"author_country_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_country_id"],
            //                         //                         @"author_state_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_state_id"],
            //                         //                         @"author_city_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_city_id"],
            //                         //                         @"year":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"year"],
            //                         //                         @"offer":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"offer"],
            //                         @"new_category":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"new_category"],@"new_category_name":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"new_category_name"],@"state_id":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"state_id"],@"city_id":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"city_id"]};
            //        }else{
            //
            //            paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
            //                         @"lesson_name":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_name"],
            //                         @"no_img":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"no_img"],
            //                         @"lesson_description":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_description"],
            //                         @"category_id": [[lessonDict valueForKey:@"paramURL2"]valueForKey:@"category_id"],
            //                         @"subcategory_id":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"subcategory_id"],
            //                         @"lesson_type":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_type"],
            //                         @"type":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"type"],
            //                         @"lesson_duration_hours":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_duration_hours"],
            //                         @"lesson_duration_minutes":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"lesson_duration_minutes"],
            //                         @"payment_deadline":[[[NSUserDefaults standardUserDefaults]valueForKey:@"Term_CondData"] valueForKey:@"payment_deadline"],
            //                         @"deposit":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"deposit"],
            //                         @"change_enrollment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"change_enrollment"],
            //                         @"cancellation":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"cancellation"],
            //                         @"refund":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"refund"],
            //                         @"make_up_lessons":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"make_up_lessons"],
            //                         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],@"currency":books_material_id,
            //                         @"quantity_books_materials":bookMaterialText.text,
            //                         @"currency_security":security_deposite_id,
            //                         @"quantity_security":securityDepositText,
            //                         @"country_id" :[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"country_id"],
            //                         //                         @"description_educator":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"description_educator"],
            //                         //                         @"name_educator":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"name_educator"],
            //                         //                         @"business_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"business_type"],
            //                         //                         @"author_venu_unit" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_unit"],
            //                         //                         @"author_venu_building_name" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_building_name"],
            //                         //                         @"author_venu_street":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_street"],
            //                         //                         @"author_venu_district":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_district"],
            //                         //                         @"author_country_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_country_id"],
            //                         //                         @"author_state_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_state_id"],
            //                         //                         @"author_city_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_city_id"],
            //                         //                         @"year":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"year"],
            //                         //                         @"offer":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"offer"],
            //                         @"state_id":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"state_id"],@"city_id":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"city_id"]
            //                         };
            
            paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
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
                         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],
                         @"currency":books_material_id,
                         @"quantity_books_materials":bookMaterialText.text,
                         @"currency_security":security_deposite_id,
                         @"quantity_security":securityDepositText.text,
                         @"other_charges":otherChargesText.text,
                         @"country_id" :[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"country_id"],
                         @"minimum_payment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"minimum_payment"],
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
                         @"new_category":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"new_category"],@"new_category_name":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"new_category_name"],@"state_id":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"state_id"],@"city_id":[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"city_id"]
                         };
            
            
        } else{
            paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
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
                         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],
                         @"currency":books_material_id,
                         @"quantity_books_materials":bookMaterialText.text,
                         @"currency_security":security_deposite_id,
                         @"quantity_security":securityDepositText.text,
                         @"other_charges":otherChargesText.text,
                         @"country_id" :[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"country_id"],@"minimum_payment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"minimum_payment"],
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
                         @"state_id":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"state_id"],@"city_id":[[lessonDict valueForKey:@"paramURL2"]valueForKey:@"city_id"]
                         };
            
        }
        
        NSLog(@"%@",paramURL);
        
        //  NSArray *educator_img = [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"identity"];
        
        // [all_imageArray addObjectsFromArray:logoImgArray];
        
        // [all_imageArray addObjectsFromArray:educator_img];
        
        NSArray *all_imageArray = [lessonDict valueForKey:@"imageArray"];
        
        [setConn startConnectionToUploadMultipleImagesWithString:[NSString stringWithFormat:@"add_lesson"] images:all_imageArray HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([setConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[receivedData valueForKey:@"generated_id"] forKey:@"course_id"];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"session_type"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[lessonDict valueForKey:@"paramURL1"]valueForKey:@"type"] forKey:@"Lesson_Type"];
                    
                    [self performSegueWithIdentifier:@"LessonSessionSegue" sender:self];
                    
                    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"educator_data"];
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Term_CondData"];
                    
                                       
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"You have just completed Step 1 by saving the Lesson Description and Terms & Conditions. You are nearly finished. Now complete Step 2 by scheduling Session Options. You need at least one Session Option for members to enroll in your Lesson." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    //  [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please Fill all the fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
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
@end
