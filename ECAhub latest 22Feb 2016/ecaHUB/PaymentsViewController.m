//
//  PaymentsViewController.m
//  ecaHUB
//
//  Created by promatics on 5/13/15.
//  Copyright (c) 2015 promatics. All rights reserved.

#import "PaymentsViewController.h"
#import "PaymentsTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"

@interface PaymentsViewController () {
    
    PaymentsTableViewCell *cell;
    
    WebServiceConnection *paymentConn;
    
    Indicator *indicator;
    
    NSArray *paymentArray;
    
    DateConversion *dateConversion;
    
    NSString *option_selected;
    
    UIDatePicker *datePicker;
    
    UIToolbar *toolBar;
    
    UIBarButtonItem *cancelButton;
    
    UIBarButtonItem *doneButton;
    
    UIButton *selectedButton;
}
@end

@implementation PaymentsViewController

@synthesize paymentTabel_view,payment_lbl,startDate,endDateBtn,filterBtn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    paymentConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
    
    payment_lbl.hidden = YES;
    
    startDate.hidden = YES;
    endDateBtn.hidden = YES;
    filterBtn.hidden = YES;
    
    CGRect frame = paymentTabel_view.frame;
    frame.origin.y = 65;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        frame.size.height = frame.size.height+60;
    }
    
    paymentTabel_view.frame = frame;
    
    startDate.layer.borderWidth = 1.0f;
    startDate.layer.borderColor = [UIColor darkGrayColor].CGColor;
    startDate.layer.cornerRadius = 5.0f;
    
    endDateBtn.layer.borderWidth = 1.0f;
    endDateBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    endDateBtn.layer.cornerRadius = 5.0f;
    
    filterBtn.layer.cornerRadius = 5.0f;
    
    datePicker = [[UIDatePicker alloc] init];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    
    [self fetchPayments];
}

-(void)fetchPayments {
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id": [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [paymentConn startConnectionWithString:@"payments" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([paymentConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            paymentArray = [receivedData valueForKey:@"payment_info"];
            
            NSLog(@"paymentArray  %@",paymentArray);
            
            if ([paymentArray count] > 0) {
                
                [paymentTabel_view reloadData];
                
                paymentTabel_view.hidden = NO;
                
            } else {
                
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No Record Exits" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //
                //                [alert show];
                
                payment_lbl.hidden = NO;
                
                paymentTabel_view.hidden = YES;
            }
        }
    }];
}

#pragma mark - UITableView Delegates & DataSouses


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [paymentArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return cell.main_view.frame.origin.y + cell.main_view.frame.size.height + 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"myPaymentCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat hieght;
    
    CGRect frame = cell.main_view.frame;
    
    frame.origin.x = 15;
    
    frame.size.width = paymentTabel_view.frame.size.width - 20;
    
    cell.main_view.frame = frame;
    
    NSString *date = [[[paymentArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"confirm_date"];
    
    if ([date isEqualToString:@""]) {
        
        cell.confirmDate_lbl.text = date;
        
    } else {
        
        cell.confirmDate_lbl.text = [dateConversion convertDate:date];
        
    }
    
    date = [[[paymentArray objectAtIndex:indexPath.row] valueForKey:@"Payment"] valueForKey:@"payment_date"];
    
    if ([date isEqualToString:@""]) {
        
        cell.transDate_lbl.text = date;
        
    } else {
        
        cell.transDate_lbl.text = [dateConversion convertDate:date];
        
    }
    
    cell.transactionId_lbl.text = [[[paymentArray objectAtIndex:indexPath.row] valueForKey:@"Payment"] valueForKey:@"trans_id"];
    
    
    cell.toWho_lbl.text = [[[[[paymentArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Member"] valueForKey:@"first_name"] stringByAppendingString:[NSString stringWithFormat:@" %@",[[[[paymentArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Member"] valueForKey:@"last_name"]]];
    
    
    cell.details_lbl.text = @"";
    
    hieght = [self heightCalculate: cell.details_lbl.text:cell.details_lbl];
    
    NSString *name;
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"]);
    
    if ([[[[paymentArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Family"] count]<1 ) {
        
        name = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"];
        
    }else{
        
        name = [[[[paymentArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Family"] valueForKey:@"first_name"];
    }
    
    
    cell.forWho_lbl.text = name;
    
    
    NSString *amount = [[[[[paymentArray objectAtIndex:indexPath.row] valueForKey:@"Payment"] valueForKey:@"amount"]stringByAppendingString:@" "]stringByAppendingString:[[[paymentArray objectAtIndex:indexPath.row] valueForKey:@"Payment"] valueForKey:@"currency"]];
    
    cell.amount_lbl.text = [amount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    cell.amount_lbl.text = amount;
    
    NSString *coursedetail =[[[paymentArray objectAtIndex:indexPath.row]valueForKey:@"CourseListing"]valueForKey:@"course_name"];
    
    date = [[[paymentArray objectAtIndex:indexPath.row] valueForKey:@"CourseListing"] valueForKey:@"expiry_date"];
    
    if ([date length]>0) {
        
        date = [dateConversion convertDate:date];
    }
    else{
        
        date = @"";
    }
    
    if ([coursedetail length]>0 && [date length]>0) {
        
        cell.details_lbl.text = [[[coursedetail stringByAppendingString:@"/"]stringByAppendingString:date]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    } else {
        
        cell.details_lbl.text = [[[coursedetail stringByAppendingString:@" "]stringByAppendingString:date]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    }
    
    
    
    frame = cell.transactionId_lbl.frame;
    
    frame.size.height = [self heightCalculate:cell.transactionId_lbl.text :cell.transactionId_lbl];
    
    cell.transactionId_lbl.frame = frame;
    
    
    frame = cell.toWho_lbl.frame;
    
    frame.origin.y = cell.transactionId_lbl.frame.origin.y +cell.transactionId_lbl.frame.size.height+10;
    
    frame.size.height = [self heightCalculate:cell.toWho_lbl.text :cell.toWho_lbl];
    
    cell.toWho_lbl.frame = frame;
    
    frame = cell.toWhoStatic_lbl.frame;
    
    frame.origin.y = cell.transactionId_lbl.frame.origin.y +cell.transactionId_lbl.frame.size.height+10;
    
    cell.toWhoStatic_lbl.frame = frame;
    
    frame = cell.details_lbl.frame;
    
    frame.origin.y = cell.toWho_lbl.frame.origin.y +cell.toWho_lbl.frame.size.height+10;
    
    frame.size.height = [self heightCalculate:cell.details_lbl.text :cell.details_lbl];
    
    cell.details_lbl.frame = frame;
    
    frame = cell.detailStatic_lbl.frame;
    
    frame.origin.y = cell.toWho_lbl.frame.origin.y +cell.toWho_lbl.frame.size.height+10;
    
    cell.detailStatic_lbl.frame = frame;
    
    
    frame = cell.forWho_lbl.frame;
    
    frame.origin.y = cell.details_lbl.frame.origin.y +cell.details_lbl.frame.size.height+10;
    
    frame.size.height = [self heightCalculate:cell.forWho_lbl.text :cell.forWho_lbl];
    
    cell.forWho_lbl.frame = frame;
    
    frame   = cell.forWhoStatic_lbl.frame;
    
    frame.origin.y = cell.details_lbl.frame.origin.y +cell.details_lbl.frame.size.height+10;
    
    cell.forWhoStatic_lbl.frame = frame;
    
    frame = cell.amount_lbl.frame;
    
    frame.origin.y = cell.forWho_lbl.frame.origin.y +cell.forWho_lbl.frame.size.height+10;
    
    frame.size.height = [self heightCalculate:cell.toWho_lbl.text :cell.toWho_lbl];
    
    cell.amount_lbl.frame = frame;
    
    frame = cell.amountStatic_lbl.frame;
    
    frame.origin.y = cell.forWho_lbl.frame.origin.y +cell.forWho_lbl.frame.size.height+10;
    
    cell.amountStatic_lbl.frame = frame;
    
    frame = cell.main_view.frame;
    
    frame.size.height = cell.amount_lbl.frame.origin.y + cell.amount_lbl.frame.size.height+10;
    
    cell.main_view.frame = frame;
    
    [cell.confirmDate_info_btn addTarget:self action:@selector(tapConfirDateInfo_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.transDate_info_btn addTarget:self action:@selector(tapTransDateInfo_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)heightCalculate:(NSString *)calculateText :(UILabel *)lbl{
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(lbl.frame.size.width - (1.0f * 2), FLT_MAX);
    
    UIFont *font;
    
    CGFloat staticHieght;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        font = [UIFont systemFontOfSize:20];
        
        staticHieght = 30.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        font = [UIFont systemFontOfSize:17];
        
        staticHieght = 21.0f;
        
    }
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font} context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    [calculateText_lbl setFrame:CGRectMake(10, 74, 300 ,size.height+5)];
    
    [calculateText_lbl sizeToFit];
    
    CGFloat height_lbl = size.height;
    
    
    if (height_lbl > lbl.frame.size.height) {
        
        return (height_lbl);
    }
    
    else{
        
        return staticHieght;
        
    }
    
}


-(void)tapConfirDateInfo_btn:(UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Enrollment or booking confirmation date." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}
-(void)tapTransDateInfo_btn:(UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The date the payment was processed." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
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

- (IBAction)tapStartBtn:(id)sender {
    
    selectedButton = startDate;
    
    [toolBar removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
        
        [cancelButton setWidth:70];
        
        doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
        
        [doneButton setWidth:70];
        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- datePicker.frame.size.height) - 60, self.view.frame.size.width, 60)];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
        
        [cancelButton setWidth:50];
        
        doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
        
        [doneButton setWidth:50];
        
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- datePicker.frame.size.height) - 44, self.view.frame.size.width, 44)];
    }
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[cancelButton,flexibleItem, doneButton];
    
    [self.view addSubview:toolBar];
    
    //toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- datePicker.frame.size.height) - 60, self.view.frame.size.width, 60)];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- datePicker.frame.size.height), self.view.frame.size.width,200)];
    
    [datePicker setBackgroundColor:[UIColor lightGrayColor]];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [self.view addSubview:datePicker];
}

- (IBAction)tapEndDate:(id)sender {
    
    selectedButton = endDateBtn;
    
    [toolBar removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    if ([startDate.titleLabel.text isEqualToString:@"Start Date"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please select start date first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        UIStoryboard *storyboard;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
            
            [cancelButton setWidth:70];
            
            doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
            
            [doneButton setWidth:70];
            
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- datePicker.frame.size.height) - 60, self.view.frame.size.width, 60)];
            
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
            
            [cancelButton setWidth:50];
            
            doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
            
            [doneButton setWidth:50];
            
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- datePicker.frame.size.height) - 44, self.view.frame.size.width, 44)];
        }
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        toolBar.items = @[cancelButton,flexibleItem, doneButton];
        
        [self.view addSubview:toolBar];
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- datePicker.frame.size.height), self.view.frame.size.width,200)];
        
        [datePicker setBackgroundColor:[UIColor lightGrayColor]];
        
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        [format setDateFormat:@"yyyy-MM-dd"];
        
        [datePicker setMinimumDate:[format dateFromString:startDate.titleLabel.text]];
        
        [self.view addSubview:datePicker];
    }
}


- (IBAction)tapFilterDateBtn:(id)sender {
    
    [self filterPayments];
}

- (IBAction)tapFilterBtn:(id)sender {
    
    [startDate setTitle:@"Start Date" forState:UIControlStateNormal];
    
    [endDateBtn setTitle:@"Start Date" forState:UIControlStateNormal];
    
    [toolBar removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Last Month", @"Last Two Month", @"Last Three Month", @"Custom", @"Reset", nil];
    
    [actionsheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    startDate.hidden = YES;
    endDateBtn.hidden = YES;
    filterBtn.hidden = YES;
    
    CGRect frame = paymentTabel_view.frame;
    frame.origin.y = 65;
    frame.size.height = self.view.frame.size.height - 110;
    paymentTabel_view.frame = frame;
    
    if (buttonIndex == 0) {
        
        option_selected = @"0";
        
        [self filterPayments];
        
    } else if (buttonIndex == 1) {
        
        option_selected = @"1";
        
        [self filterPayments];
        
    } else if (buttonIndex == 2) {
        
        option_selected = @"2";
        
        [self filterPayments];
        
    } else if (buttonIndex == 3) {
        
        option_selected = @"3";
        
        CGRect frame = paymentTabel_view.frame;
        frame.origin.y = filterBtn.frame.origin.y + filterBtn.frame.size.height + 10;
        frame.size.height = self.view.frame.size.height - frame.origin.y - 40;
        paymentTabel_view.frame = frame;
        
        startDate.hidden = NO;
        endDateBtn.hidden = NO;
        filterBtn.hidden = NO;
        
        [self filterPayments];
        
    } else if (buttonIndex == 4) {
        
        startDate.hidden = YES;
        endDateBtn.hidden = YES;
        filterBtn.hidden = YES;
        
        CGRect frame = paymentTabel_view.frame;
        frame.origin.y = 65;
        frame.size.height = self.view.frame.size.height - 110;
        paymentTabel_view.frame = frame;
        
        [self fetchPayments ];
    }
}

-(void)filterPayments{
    
    //member_id, For Filters {option_selected =>'0'=>'Last Month','1'=>'Last Two Month','2'=>'Last Three Month','3'=>'Custom'(In case of custon send  start_date,last_date) date format=> 1991-08-25 }
    
    NSDictionary *paramURL;
    
    NSString *msg;
    
    if ([option_selected isEqualToString:@"3"]) {
        
        if ([startDate.titleLabel.text isEqualToString:@"Start Date"] || [endDateBtn.titleLabel.text isEqualToString:@"End Date"]) {
            
            msg = @"Please select start date and end date.";
            
        } else {
            
            paramURL = @{@"member_id": [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"option_selected": option_selected, @"start_date":startDate.titleLabel.text, @"last_date":endDateBtn.titleLabel.text};
        }
        
    } else {
        
        paramURL = @{@"member_id": [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"option_selected": option_selected};
    }
    
    if ([msg length] > 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.view addSubview:indicator];
        
        [paymentConn startConnectionWithString:@"payments" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([paymentConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                paymentArray = [receivedData valueForKey:@"income_info"];
                
                if ([paymentArray count] > 0) {
                    
                    [paymentTabel_view reloadData];
                    
                    paymentTabel_view.hidden = NO;
                    
                } else {
                    
                    payment_lbl.hidden = NO;
                    
                    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No Record Exits" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    //
                    //                [alert show];
                    
                    paymentTabel_view.hidden = YES;
                }
            }
        }];
    }
}

-(void)cancelKeyboard:(UIBarButtonItem *)sender {
    
    [toolBar removeFromSuperview];
    
    [datePicker removeFromSuperview];
    
}

-(void)doneKeyboard:(UIBarButtonItem *)sender {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"yyyy-MM-dd"];
    
    [selectedButton setTitle:[format stringFromDate:datePicker.date] forState:UIControlStateNormal];
    
    [toolBar removeFromSuperview];
    
    [datePicker removeFromSuperview];
}
@end
