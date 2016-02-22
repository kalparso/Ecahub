
//  AddPersonalAccountViewController.m
//  ecaHUB
//
//  Created by promatics on 8/20/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AddPersonalAccountViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"



@interface AddPersonalAccountViewController (){
    
    WebServiceConnection *getConn;
    Indicator *indicator;
    NSString *accountType;
    NSString *editID;
    Validation *validation;
    id activeField;
    
}

@end

@implementation AddPersonalAccountViewController

@synthesize scroll_view,bankCodeText,bankNameTxt,branchCodeText,branchLocationText,paypal_emailTxt,accountNameText,accountNumberText,swiftCodeText,saveBtn,cancelBtn,countryTxt,mainView,selectAccountBtn,IsPersonalAcntView,isEdit,editAccountDict,infoLbl;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    getConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    validation = [Validation validationManager];
    
    scroll_view.frame = self.view.frame;
    
    if (IsPersonalAcntView == YES) {
        
        
        
        infoLbl.text = @"Sometimes a lesson, course or event you enroll in may get cancelled. Any refund amounts due to you will be credited to this account.";
    }
    else{
        
        infoLbl.text = @"Any ECAhub sales income due to you from Listing enrollments and bookings will be credited to this account.";
    }
    
    if (IsPersonalAcntView == YES) {
        
        if (isEdit == YES) {
            
            infoLbl.text = @"Sometimes a lesson, course or event you enroll in may get cancelled. Any refund amounts due to you will be credited to this account.";
            
            self.title =@"Edit Personal Account";
            
            [self fetchEditData];
        }
        else{
            
            infoLbl.text = @"Any refund amounts due to you from cancelled private lesson, courses or events will be credited to this account.";
            
            self.title = @"Add Personal Account";
        }
    }
    
    else{
        
        if (isEdit == YES) {
            
            infoLbl.text = @"Any ECAhub sales income due to you from Listing enrollments and bookings will be credited to this account.";
            
            self.title =@"Edit Business Account";
            
            [self fetchEditData];
        }
        else{
            
            infoLbl.text = @"Any ECAhub sales income due to you from Listing enrollments and bookings will be credited to this account.";
            
            self.title = @"Add Business Account";
        }
        
    }
    
    
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = YES;
    
    [scroll_view addGestureRecognizer:tapScroll];
    
    [self registerForKeyboardNotifications];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGRect frame = mainView.frame;
        frame.size.height = saveBtn.frame.origin.y + 150;
        mainView.frame = frame;
        
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, saveBtn.frame.origin.y+200);
        
        saveBtn.layer.cornerRadius = 7;
        cancelBtn.layer.cornerRadius = 7;
        
        CGRect frame1;
        frame1 = countryTxt.frame;
        frame1.size.height =35;
        countryTxt.frame =frame1;
        
        frame1 = branchCodeText.frame;
        frame1.size.height =35;
        branchCodeText.frame =frame1;
        
        frame1 = bankCodeText.frame;
        frame1.size.height =35;
        bankCodeText.frame =frame1;
        
        frame1 = bankNameTxt.frame;
        frame1.size.height =35;
        bankNameTxt.frame =frame1;
        
        frame1 = accountNumberText.frame;
        frame1.size.height =35;
        accountNumberText.frame =frame1;
        
        frame1 = accountNameText.frame;
        frame1.size.height =35;
        accountNameText.frame =frame1;
        
        frame1 = swiftCodeText.frame;
        frame1.size.height =35;
        swiftCodeText.frame =frame1;
        
        frame1 = paypal_emailTxt.frame;
        frame1.size.height =35;
        paypal_emailTxt.frame =frame1;
        
        frame1 = branchLocationText.frame;
        frame1.size.height =35;
        branchLocationText.frame =frame1;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        CGRect frame = mainView.frame;
        frame.size.height = saveBtn.frame.origin.y + 60;
        mainView.frame = frame;
        
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, saveBtn.frame.origin.y+150);
        
        saveBtn.layer.cornerRadius = 5;
        cancelBtn.layer.cornerRadius = 5;
        
    }
    
    if (![selectAccountBtn.titleLabel.text isEqualToString:@"Select"]){
        
        [selectAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    
    [self setPlaceholderText];
    // Do any additional setup after loading the view.
}

-(void)setPlaceholderText {
    
    //scroll_view,bankCodeText,bankNameTxt,branchCodeText,branchLocationText,paypal_emailTxt,accountNameText,accountNumberText,swiftCodeText,saveBtn,cancelBtn,countryTxt,mainView,selectAccountBtn,IsPersonalAcntView,isEdit,editAccountDict,infoLbl;
    
    [paypal_emailTxt setPlaceholder:@"Your email registered with PayPal"];
    
    [countryTxt setPlaceholder:@"Country"];
    
    [bankNameTxt setPlaceholder:@"Bank Name"];
    
    [swiftCodeText setPlaceholder:@"Swift Code"];
    
    [branchLocationText setPlaceholder:@"Branch Location"];
    
    [bankCodeText setPlaceholder:@"Bank Code"];
    
    [branchCodeText setPlaceholder:@"Branch Code"];
    
    [accountNameText setPlaceholder:@"Account Name"];
    
    [accountNumberText setPlaceholder:@"Account Number"];
    
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

-(void)fetchEditData{
    
    branchCodeText.text = [editAccountDict valueForKey:@"branch_code"];
    
    branchLocationText.text = [editAccountDict valueForKey:@"branch_location"];
    
    countryTxt.text = [editAccountDict valueForKey:@"country"];
    
    bankNameTxt.text = [editAccountDict valueForKey:@"bank_name"];
    
    swiftCodeText.text = [editAccountDict valueForKey:@"swift_code"];
    
    bankCodeText.text = [editAccountDict valueForKey:@"bank_code"];
    
    accountNameText.text = [editAccountDict valueForKey:@"account_name"];
    
    accountNumberText.text = [editAccountDict valueForKey:@"account_number"];
    
    
    
    if ([[editAccountDict valueForKey:@"account_type"]isEqualToString:@"0"]) {
        
        // [selectAccountBtn setTitle:@"PayPal Account" forState:UIControlStateNormal];
        
    }
    
    else{
        
        //  [selectAccountBtn setTitle:@"Bank Account" forState:UIControlStateNormal];
        
    }
    
    paypal_emailTxt.text = [editAccountDict valueForKey:@"paypal_email"];
    
}


- (IBAction)tap_saveBtn:(id)sender {
    
    NSLog(@"%@",selectAccountBtn.titleLabel.text);
    
    
    NSString *weblink;
    
    NSString *msg;
    
    int a = 3;
    
    
    if (IsPersonalAcntView == YES) {
        
        weblink = @"add_personal_account";
    }
    else{
        
        weblink =@"add_business_account";
    }
    
    if([msg length]==0) {
        
        NSInteger counter = 0;
        
        if ([selectAccountBtn.titleLabel.text isEqualToString:@"PayPal Account"]) {
            
            counter = 0;
            
            if([paypal_emailTxt.text isEqualToString:@""]){
                
                msg =@"Please enter your paypal email.";
                
            }
            else if(![paypal_emailTxt.text isEqualToString:@""]){
                
                if(![validation validateEmail:paypal_emailTxt.text]){
                    
                    msg =@"Please enter a valid email.";
                }
                
            }
            
            if([msg length]<1){
                
                a=4;
            }
        }
        else if(![paypal_emailTxt.text isEqualToString:@""]){
            
            if(![validation validateEmail:paypal_emailTxt.text]){
                
                msg =@"Please enter a valid email.";
            }
            a = 0;
        }
        
        
        if([msg length]<1){
            
            if ([selectAccountBtn.titleLabel.text isEqualToString:@"Bank Account"]){
                
                if ([countryTxt.text isEqualToString:@""]) {
                    
                    msg =@"Please enter country name.";
                }
                else if ([bankNameTxt.text isEqualToString:@""]) {
                    
                    msg =@"Please enter your bank name.";
                }
                else if ([swiftCodeText.text isEqualToString:@""]) {
                    
                    msg =@"Please enter your swift code.";
                }
                else if ([branchLocationText.text isEqualToString:@""]) {
                    
                    msg =@"Please enter your branch location.";
                }
                else if ([bankCodeText.text isEqualToString:@""]) {
                    
                    msg =@"Please enter your bank code.";
                }else if ([branchCodeText.text isEqualToString:@""]) {
                    
                    msg =@"Please enter your branch code.";
                }else if ([accountNameText.text isEqualToString:@""]) {
                    
                    msg =@"Please enter your account name.";
                }else if ([accountNumberText.text isEqualToString:@""]) {
                    
                    msg =@"Please enter your account number.";
                }
                else if ([selectAccountBtn.titleLabel.text isEqualToString:@"Select"]){
                    
                    msg =@"Please select your default account.";
                    
                }
                
                if([msg length] < 1){
                    
                    a=4;
                }
                
            } else {
                
                if ([countryTxt.text isEqualToString:@""]) {
                    
                    msg =@"Please enter country name.";
                    
                    counter = 1;
                }
                if ([bankNameTxt.text isEqualToString:@""] && (counter == 1 ||counter == 0)) {
                    
                    msg =@"Please enter your bank name.";
                    
                    counter = counter + 1;
                }
                if ([swiftCodeText.text isEqualToString:@""] && (counter == 2 || counter == 0)) {
                    
                    msg =@"Please enter your swift code.";
                    
                    counter = counter+1;
                }
                if ([branchLocationText.text isEqualToString:@""] && (counter == 3 || counter == 0)) {
                    
                    msg =@"Please enter your branch location.";
                    
                    counter = counter +1;
                }
                if ([bankCodeText.text isEqualToString:@""] && (counter == 4 || counter == 0)) {
                    
                    msg =@"Please enter your bank code.";
                    
                    counter = counter +1;
                    
                }
                if ([branchCodeText.text isEqualToString:@""] && (counter == 5 || counter == 0)) {
                    
                    msg =@"Please enter your branch code.";
                    
                    counter = counter +1;
                    
                }
                if ([accountNameText.text isEqualToString:@""] && (counter == 6 || counter == 0)) {
                    
                    msg =@"Please enter your account name.";
                    
                    counter = counter +1;
                }
                if ([accountNumberText.text isEqualToString:@""] && (counter == 7 || counter == 0)) {
                    
                    msg =@"Please enter your account number.";
                    
                    counter = counter +1;
                }
                
                if(counter == 8) {
                    
                    msg = @"";
                    
                } else if(counter == 0){
                    
                    if(a==0)
                    {
                        a = 2;
                        
                    } else {
                        
                        a = 1;
                    }
                    
                }
                
            }
            
        }
        counter = 0;
    }
    
    if(a==3 && [msg length]<1)
    {
        
        msg = @"Fill atleast one account details.";
    }
    
    if(a==2 &&[msg length]<1){
        
        msg = @"Please select default account.";
    }
    
    if([msg length]>0){
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        
        [alertView show];
    }
    else{
        
        NSDictionary *paramURL ;
        
        
        
        if (isEdit == YES) {
            
            
            if ([selectAccountBtn.titleLabel.text isEqualToString:@"PayPal Account"]) {
                
                accountType = @"0";
                
            } else  if ([selectAccountBtn.titleLabel.text isEqualToString:@"Bank Account"]) {
                
                accountType = @"1";
            } else if ([selectAccountBtn.titleLabel.text isEqualToString:@"Select"]){
                
                accountType = [NSString stringWithFormat:@"%d",a];
                
            }
            
            editID = [editAccountDict valueForKey:@"id"];
            
            paramURL = @{@"id":editID,@"paypal_email":paypal_emailTxt.text,@"country":countryTxt.text,@"bank_name":bankNameTxt.text,@"swift_code":swiftCodeText.text,@"branch_location":branchLocationText.text,@"bank_code":bankCodeText.text,@"branch_code":branchCodeText.text,@"account_name":accountNameText.text,@"account_number":accountNumberText.text,@"account_type":accountType};
            
            [self.view addSubview:indicator];
            
            [getConn startConnectionWithString:weblink HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
                
                [indicator removeFromSuperview];
                
                
                if([getConn responseCode]==1){
                    
                    NSLog(@"%@",receivedData);
                    
                    
                    NSString *msg = @"Your Account information has been updated successfully.";
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alertView.tag = 1;
                    
                    [alertView show];
                    
                    
                    
                }
                
            }];
            
        } else {
            
            NSLog(@"%@",selectAccountBtn.titleLabel.text);
            
            if ([selectAccountBtn.titleLabel.text isEqualToString:@"PayPal Account"]) {
                
                accountType = @"0";
                
            } else  if ([selectAccountBtn.titleLabel.text isEqualToString:@"Bank Account"]) {
                
                accountType = @"1";
            } else if ([selectAccountBtn.titleLabel.text isEqualToString:@"Select"]){
                
                accountType = [NSString stringWithFormat:@"%d",a];
                
            }
            
            
            paramURL = @{@"member_id": [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"paypal_email":paypal_emailTxt.text,@"country":countryTxt.text,@"bank_name":bankNameTxt.text,@"swift_code":swiftCodeText.text,@"branch_location":branchLocationText.text,@"bank_code":bankCodeText.text,@"branch_code":branchCodeText.text,@"account_name":accountNameText.text,@"account_number":accountNumberText.text,@"account_type":accountType};
            
            [self.view addSubview:indicator];
            
            [getConn startConnectionWithString:weblink HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
                
                [indicator removeFromSuperview];
                
                
                if([getConn responseCode]==1){
                    
                    NSLog(@"%@",receivedData);
                    
                    NSString *msg = @"Your Account has been added successfully.";
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    alertView.tag =1;
                    
                    [alertView show];
                    
                }
                
            }];}
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        
        if (buttonIndex ==0) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
    
}

- (IBAction)tap_cancelBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)tap_selectBtn:(id)sender {
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"PayPal Account",@"Bank Account", nil];
    
    actionsheet.backgroundColor = [UIColor grayColor];
    
    [actionsheet showInView:self.mainView];
    
    if (![selectAccountBtn.titleLabel.text isEqualToString:@"Select"]){
        
        [selectAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    
}

-(void)
actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        [selectAccountBtn setTitle:@"PayPal Account" forState:UIControlStateNormal];
        
        accountType = @"0";
        
        [selectAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    else if (buttonIndex ==1){
        
        [selectAccountBtn setTitle:@"Bank Account" forState:UIControlStateNormal];
        
        accountType = @"1";
        
        [selectAccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
}

#pragma mark- Textfield Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    //    if (theTextField == paypal_emailTxt) {
    //
    //        [theTextField resignFirstResponder];
    //
    //     //   [self tappedCreateAccBtn:theTextField];
    //
    //    } else if (theTextField == countryTxt) {
    //
    //        [bankNameTxt becomeFirstResponder];
    //
    //    }  else if (theTextField == bankNameTxt) {
    //
    //        [swiftCodeText becomeFirstResponder];
    //
    //    }  else if (theTextField == swiftCodeText) {
    //
    //        [branchLocationText becomeFirstResponder];
    //
    //    }  else if (theTextField == branchLocationText) {
    //
    //        [bankCodeText becomeFirstResponder];
    //
    //    }  else if (theTextField == bankCodeText) {
    //
    //        [branchCodeText becomeFirstResponder];
    //
    //    }  else if (theTextField == branchCodeText) {
    //
    //        [accountNameText becomeFirstResponder];
    //
    //    }  else if (theTextField == accountNameText) {
    //
    //        [accountNumberText becomeFirstResponder];
    //    }
    
    [theTextField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    activeField = nil;
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
    
    // [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    scroll_view.contentInset = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbHeight;
    
    
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    //scrollView.contentOffset = contentInsets;
    
    scroll_view.scrollIndicatorInsets = contentInsets;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, saveBtn.frame.origin.y+50);
        
    }
    else{
        
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, saveBtn.frame.origin.y+50);
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, saveBtn.frame.origin.y+50);
        
    }
    else{
        
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, saveBtn.frame.origin.y+50);
    }
    [self.view endEditing:YES];
}


-(IBAction)tapInfoPayPal_btn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"If your bank account is outside of Hong Kong, we recommend you use PayPal to receive your funds to save on any international bank transfer fees. Funds will be deposited in your local currency into your PayPal account, and once received, you can transfer the funds into your local bank account in the same local currency fee free." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}
- (IBAction)tapInfoBankAcc_btn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"If your Bank account is outside of Hong Kong, there will be extra charges to receive your money. Every bank incurs different charges. This method of receiving your funds is not recommended unless your Bank is in Hong Kong." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}
@end