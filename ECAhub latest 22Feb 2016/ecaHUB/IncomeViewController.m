//
//  IncomeViewController.m
//  ecaHUB
//
//  Created by promatics on 5/13/15.
//  Copyright (c) 2015 promatics. All rights reserved.

#import "IncomeViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "IncomeTableViewCell.h"
#import "DateConversion.h"

@interface IncomeViewController () {
    
    IncomeTableViewCell *cell;
    
    WebServiceConnection *incomeConn;
    
    Indicator *indicator;
    
    NSArray *incomeArray;
    
    DateConversion *dateConversion;
    
    NSString *option_selected;
    
    UIDatePicker *datePicker;
    
    UIToolbar *toolBar;
    
    UIBarButtonItem *cancelButton;
    
    UIBarButtonItem *doneButton;
    
    UIButton *selectedButton;
    
}
@end

@implementation IncomeViewController

@synthesize incomeTabel_view,income_lbl, startDate, endDateBtn, filterBtn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //  self.navigationController.navigationBar.topItem.title = @"";
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    incomeConn = [WebServiceConnection connectionManager];
    
    dateConversion = [DateConversion dateConversionManager];
    
    income_lbl.hidden = YES;
    
    startDate.hidden = YES;
    endDateBtn.hidden = YES;
    filterBtn.hidden = YES;
    
    CGRect frame = incomeTabel_view.frame;
    frame.origin.y = 65;
    frame.size.height = frame.size.height+60;
    incomeTabel_view.frame = frame;
    
    startDate.layer.borderWidth = 1.0f;
    startDate.layer.borderColor = [UIColor darkGrayColor].CGColor;
    startDate.layer.cornerRadius = 5.0f;
    
    endDateBtn.layer.borderWidth = 1.0f;
    endDateBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    endDateBtn.layer.cornerRadius = 5.0f;
    
    filterBtn.layer.cornerRadius = 5.0f;
    
    datePicker = [[UIDatePicker alloc] init];
    
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    // incomeTabel_view.backgroundColor = [UIColor lightGrayColor];
    
    //cell.main_view.backgroundColor = [UIColor whiteColor];
    
    //  [datePicker setMaximumDate:[NSDate date]];
    
    [self fetchIncomes];
}

-(void)fetchIncomes {
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id": [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [incomeConn startConnectionWithString:@"incomes" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([incomeConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            incomeArray = [receivedData valueForKey:@"income_info"];
            
            if ([incomeArray count] > 0) {
                
                [incomeTabel_view reloadData];
                
                incomeTabel_view.hidden = NO;
                
            } else {
                
                income_lbl.hidden = NO;
                //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No Record Exits" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //
                //                [alert show];
                incomeTabel_view.hidden = YES;
                
            }
        }
    }];
}

#pragma mark - UITableView Delegates & DataSouses

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return cell.main_view.frame.origin.y + cell.main_view.frame.size.height + 20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [incomeArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"myIncomeCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat hieght = 21.0f;
    
    CGRect frame = cell.main_view.frame;
    
    frame.origin.x = 15;
    
    frame.size.width = incomeTabel_view.frame.size.width -20;
    
    cell.main_view.frame = frame;
    
    NSString *date = [[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"confirm_date"];
    
    
    if([date length]>0) {
        
        cell.confirmDate_lbl.text = [dateConversion convertDate:date];
        
    }
    else{
        
        cell.confirmDate_lbl.text = @"";
    }
    
    date = [[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"Payment"] valueForKey:@"payment_date"];
    
    if([date length]>0) {
        
        cell.transDate_lbl.text = [dateConversion convertDate:date];
        
    } else {
        
        cell.transDate_lbl.text = date;
    }
    
    cell.transactionId_lbl.text = [[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"Payment"] valueForKey:@"trans_id"];
    
    cell.fromWho_lbl.text = [[[[[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Member"] valueForKey:@"first_name"] stringByAppendingString:[[[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Member"] valueForKey:@"last_name"]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    
    NSString *name, *lname;
    NSArray *arr;
    
    if ([[[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Family"] count] < 1) {
        
        name = [[[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Member"] valueForKey:@"first_name"];
        
        lname = [[[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Member"] valueForKey:@"family_name"];
        
    } else {
        
        name = [[[[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Family"] valueForKey:@"first_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        lname = [[[[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Family"] valueForKey:@"family_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        arr = [name componentsSeparatedByString:@" "];
        
        name = [arr objectAtIndex:0];
    }
    cell.forWho_lbl.text = [[[name stringByAppendingString:@" "]stringByAppendingString:lname]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *coursedetail =[[[incomeArray objectAtIndex:indexPath.row]valueForKey:@"CourseListing"]valueForKey:@"course_name"];
    
    
    date = [[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"CourseListing"] valueForKey:@"expiry_date"];
    
    if ([date length]>0) {
        
        date = [dateConversion convertDate:date];
    }
    else{
        
        date = @"";
    }
    
    if ([coursedetail length]>0 && [date length]>0) {
        
        cell.detail_lbl.text = [[[coursedetail stringByAppendingString:@"/"]stringByAppendingString:date]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else{
        
        cell.detail_lbl.text = [[[coursedetail stringByAppendingString:@" "]stringByAppendingString:date]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    }
    
    //NSString *amount = [[[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"Currency"] valueForKey:@"name"];
    
    NSString *amount = [[[[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"Payment"] valueForKey:@"amount"]stringByAppendingString:@" "]stringByAppendingString:[[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"Payment"] valueForKey:@"currency"]];
    
    cell.amount_lbl.text = [amount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    date = [[[incomeArray objectAtIndex:indexPath.row] valueForKey:@"Payment"] valueForKey:@"payment_date"];
    
    [cell.confirmDate_info_btn addTarget:self action:@selector(tapConfirDateInfo_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.transDate_info_btn addTarget:self action:@selector(tapTransDateInfo_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.fromWho_info_btn addTarget:self action:@selector(tapFromWhoInfo_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.forWho_info_btn addTarget:self action:@selector(tapForWhoInfo_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.amount_info_btn addTarget:self action:@selector(tapAmountInfo_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.payInDate_info_btn addTarget:self action:@selector(tapPayInDateInfo_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if([date length]>0){
        
        cell.payInDate_lbl.text = [dateConversion convertDate:date];
        
    } else {
        
        cell.payInDate_lbl.text = date;
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        frame = cell.transactionId_lbl.frame;
        
        frame.size.height = [self heightCalculate:cell.transactionId_lbl.text :cell.transactionId_lbl];
        
        cell.transactionId_lbl.frame = frame;
        
        frame = cell.fromWho_lbl.frame;
        
        frame.origin.y = cell.transactionId_lbl.frame.origin.y +cell.transactionId_lbl.frame.size.height+10;
        
        frame.size.height = [self heightCalculate:cell.fromWho_lbl.text :cell.fromWho_lbl];
        
        cell.fromWho_lbl.frame = frame;
        
        frame = cell.fromWhoStatic_lbl.frame;
        
        frame.origin.y = cell.transactionId_lbl.frame.origin.y +cell.transactionId_lbl.frame.size.height+10;
        
        cell.fromWhoStatic_lbl.frame = frame;
        
        frame = cell.fromWho_info_btn.frame;
        
        frame.origin.y = cell.transactionId_lbl.frame.origin.y +cell.transactionId_lbl.frame.size.height+10;
        
        cell.fromWho_info_btn.frame = frame;
        
        frame = cell.forWho_lbl.frame;
        
        frame.size.height = [self heightCalculate:cell.forWho_lbl.text :cell.forWho_lbl];
        
        frame.origin.y = cell.fromWho_lbl.frame.origin.y +cell.fromWho_lbl.frame.size.height+10;
        
        cell.forWho_lbl.frame = frame;
        
        frame = cell.forWhoStatic_lbl.frame;
        
        frame.origin.y = cell.fromWho_lbl.frame.origin.y +cell.fromWho_lbl.frame.size.height+10;
        
        cell.forWhoStatic_lbl.frame = frame;
        
        frame = cell.fromWho_info_btn.frame;
        
        frame.origin.y = cell.fromWho_lbl.frame.origin.y +cell.fromWho_lbl.frame.size.height+10;
        
        cell.forWho_info_btn.frame = frame;
        
        
        frame = cell.detail_lbl.frame;
        
        frame.origin.y = cell.forWho_lbl.frame.origin.y +cell.forWho_lbl.frame.size.height+10;
        
        frame.size.height = [self heightCalculate:cell.detail_lbl.text :cell.detail_lbl];
        
        cell.detail_lbl.frame = frame;
        
        frame = cell.detailStatic_lbl.frame;
        
        frame.origin.y = cell.forWho_lbl.frame.origin.y +cell.forWho_lbl.frame.size.height+10;
        
        cell.detailStatic_lbl.frame = frame;
        
        
        frame = cell.amount_lbl.frame;
        
        frame.origin.y = cell.detail_lbl.frame.origin.y + cell.detail_lbl.frame.size.height+10;
        
        frame.size.height = [self heightCalculate:cell.amount_lbl.text :cell.amount_lbl];
        
        cell.amount_lbl.frame = frame;
        
        frame = cell.amountStatic_lbl.frame;
        
        frame.origin.y = cell.detail_lbl.frame.origin.y + cell.detail_lbl.frame.size.height+10;
        
        cell.amountStatic_lbl.frame = frame;
        
        frame = cell.amount_info_btn.frame;
        
        frame.origin.y = cell.detail_lbl.frame.origin.y + cell.detail_lbl.frame.size.height+10;
        
        cell.amount_info_btn.frame = frame;
        
        
        frame = cell.payInDate_lbl.frame;
        
        frame.origin.y = cell.amount_lbl.frame.origin.y + cell.amount_lbl.frame.size.height+10;
        
        cell.payInDate_lbl.frame = frame;
        
        frame = cell.payInDateStatic_lbl.frame;
        
        frame.origin.y = cell.amount_lbl.frame.origin.y + cell.amount_lbl.frame.size.height+10;
        
        cell.payInDateStatic_lbl.frame = frame;
        
        frame = cell.payInDate_info_btn.frame;
        
        frame.origin.y = cell.amount_lbl.frame.origin.y + cell.amount_lbl.frame.size.height+10;
        
        cell.payInDate_info_btn.frame = frame;
        
        frame = cell.main_view.frame;
        
        frame.size.height = cell.payInDate_lbl.frame.origin.y + cell.payInDate_lbl.frame.size.height+10;
        
        cell.main_view.frame = frame;
        
    } else {
        
        frame = cell.transactionId_lbl.frame;
        
        frame.size.height = [self heightCalculate:cell.transactionId_lbl.text :cell.transactionId_lbl];
        
        cell.transactionId_lbl.frame = frame;
        
        
        frame = cell.fromWho_lbl.frame;
        
        frame.origin.y = cell.transactionId_lbl.frame.origin.y +cell.transactionId_lbl.frame.size.height+10;
        
        frame.size.height = [self heightCalculate:cell.fromWho_lbl.text :cell.fromWho_lbl];
        
        cell.fromWho_lbl.frame = frame;
        
        frame = cell.fromWhoStatic_lbl.frame;
        
        frame.origin.y = cell.transactionId_lbl.frame.origin.y +cell.transactionId_lbl.frame.size.height+10;
        
        cell.fromWhoStatic_lbl.frame = frame;
        
        frame = cell.fromWho_info_btn.frame;
        
        frame.origin.y = cell.transactionId_lbl.frame.origin.y +cell.transactionId_lbl.frame.size.height+6;
        
        cell.fromWho_info_btn.frame = frame;
        
        frame = cell.fromHwo_img_btn.frame;
        
        frame.origin.y = cell.transactionId_lbl.frame.origin.y +cell.transactionId_lbl.frame.size.height+10;
        
        cell.fromHwo_img_btn.frame = frame;
        
        
        frame = cell.forWho_lbl.frame;
        
        frame.size.height = [self heightCalculate:cell.forWho_lbl.text :cell.forWho_lbl];
        
        frame.origin.y = cell.fromWho_lbl.frame.origin.y +cell.fromWho_lbl.frame.size.height+10;
        
        cell.forWho_lbl.frame = frame;
        
        frame = cell.forWhoStatic_lbl.frame;
        
        frame.origin.y = cell.fromWho_lbl.frame.origin.y +cell.fromWho_lbl.frame.size.height+10;
        
        cell.forWhoStatic_lbl.frame = frame;
        
        frame = cell.fromWho_info_btn.frame;
        
        frame.origin.y = cell.fromWho_lbl.frame.origin.y +cell.fromWho_lbl.frame.size.height+6;
        
        cell.forWho_info_btn.frame = frame;
        
        frame = cell.forWho_img_btn.frame;
        
        frame.origin.y = cell.fromWho_lbl.frame.origin.y +cell.fromWho_lbl.frame.size.height+10;
        
        cell.forWho_img_btn.frame = frame;
        
        
        frame = cell.detail_lbl.frame;
        
        frame.origin.y = cell.forWho_lbl.frame.origin.y +cell.forWho_lbl.frame.size.height+10;
        
        frame.size.height = [self heightCalculate:cell.detail_lbl.text :cell.detail_lbl];
        
        cell.detail_lbl.frame = frame;
        
        frame = cell.detailStatic_lbl.frame;
        
        frame.origin.y = cell.forWho_lbl.frame.origin.y +cell.forWho_lbl.frame.size.height+10;
        
        cell.detailStatic_lbl.frame = frame;
        
        
        frame = cell.amount_lbl.frame;
        
        frame.origin.y = cell.detail_lbl.frame.origin.y + cell.detail_lbl.frame.size.height+10;
        
        frame.size.height = [self heightCalculate:cell.amount_lbl.text :cell.amount_lbl];
        
        cell.amount_lbl.frame = frame;
        
        frame = cell.amountStatic_lbl.frame;
        
        frame.origin.y = cell.detail_lbl.frame.origin.y + cell.detail_lbl.frame.size.height+10;
        
        cell.amountStatic_lbl.frame = frame;
        
        frame = cell.amount_info_btn.frame;
        
        frame.origin.y = cell.detail_lbl.frame.origin.y + cell.detail_lbl.frame.size.height+6;
        
        cell.amount_info_btn.frame = frame;
        
        frame = cell.amount_img_btn.frame;
        
        frame.origin.y = cell.detail_lbl.frame.origin.y + cell.detail_lbl.frame.size.height+10;
        
        cell.amount_img_btn.frame = frame;
        
        
        frame = cell.payInDate_lbl.frame;
        
        frame.origin.y = cell.amount_lbl.frame.origin.y + cell.amount_lbl.frame.size.height+10;
        
        cell.payInDate_lbl.frame = frame;
        
        frame = cell.payInDateStatic_lbl.frame;
        
        frame.origin.y = cell.amount_lbl.frame.origin.y + cell.amount_lbl.frame.size.height+10;
        
        cell.payInDateStatic_lbl.frame = frame;
        
        frame = cell.payInDate_info_btn.frame;
        
        frame.origin.y = cell.amount_lbl.frame.origin.y + cell.amount_lbl.frame.size.height+6;
        
        cell.payInDate_info_btn.frame = frame;
        
        frame = cell.payIn_img_btn.frame;
        
        frame.origin.y = cell.amount_lbl.frame.origin.y + cell.amount_lbl.frame.size.height+10;
        
        cell.payIn_img_btn.frame = frame;
        
        
        
        frame = cell.main_view.frame;
        
        frame.size.height = cell.payInDate_lbl.frame.origin.y + cell.payInDate_lbl.frame.size.height+10;
        
        cell.main_view.frame = frame;
        
    }
    
    
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
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The date the buying member paid the system for your service." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}
-(void)tapFromWhoInfo_btn:(UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The member who purchased your service." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}
-(void)tapForWhoInfo_btn:(UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The person actually using your service.Tommy Smith." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}
-(void)tapAmountInfo_btn:(UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The total amount for all services as noted in Details." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}
-(void)tapPayInDateInfo_btn:(UIButton *)sender{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"The date the amount was deposited into your Pay- In Account. If it says ‘Pending’, it will be paid by the end of the next business day." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

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
    
    [self filterIncomes];
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
    
    CGRect frame = incomeTabel_view.frame;
    frame.origin.y = 65;
    frame.size.height = self.view.frame.size.height - 110;
    incomeTabel_view.frame = frame;
    
    if (buttonIndex == 0) {
        
        option_selected = @"0";
        
        [self filterIncomes];
        
    } else if (buttonIndex == 1) {
        
        option_selected = @"1";
        
        [self filterIncomes];
        
    } else if (buttonIndex == 2) {
        
        option_selected = @"2";
        
        [self filterIncomes];
        
    } else if (buttonIndex == 3) {
        
        option_selected = @"3";
        
        CGRect frame = incomeTabel_view.frame;
        frame.origin.y = filterBtn.frame.origin.y + filterBtn.frame.size.height + 10;
        frame.size.height = self.view.frame.size.height - frame.origin.y - 40;
        incomeTabel_view.frame = frame;
        
        startDate.hidden = NO;
        endDateBtn.hidden = NO;
        filterBtn.hidden = NO;
        
        [self filterIncomes];
        
    } else if (buttonIndex == 4) {
        
        startDate.hidden = YES;
        endDateBtn.hidden = YES;
        filterBtn.hidden = YES;
        
        CGRect frame = incomeTabel_view.frame;
        frame.origin.y = 65;
        frame.size.height = self.view.frame.size.height - 110;
        incomeTabel_view.frame = frame;
        
        [self fetchIncomes];
        
    }
    
}

-(void)filterIncomes {
    
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
        
        paramURL = @{@"member_id": [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"], @"option_selected":option_selected};
    }
    
    if ([msg length] > 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        NSLog(@"paramUre = %@",paramURL);
        
        [self.view addSubview:indicator];
        
        [incomeConn startConnectionWithString:@"incomes" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([incomeConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                incomeArray = [receivedData valueForKey:@"income_info"];
                
                if ([incomeArray count] > 0) {
                    
                    [incomeTabel_view reloadData];
                    
                    incomeTabel_view.hidden = NO;
                    
                } else {
                    
                    income_lbl.hidden = NO;
                    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No Record Exits" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    //
                    //                [alert show];
                    
                    incomeTabel_view.hidden = YES;
                }
            }
        }];
    }
}

@end

