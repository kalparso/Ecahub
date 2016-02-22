//
//  ManualInviteFriendsViewController.m
//  ecaHUB
//
//  Created by promatics on 8/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "ManualInviteFriendsViewController.h"
#import "Validation.h"
#import "Indicator.h"
#import "WebServiceConnection.h"
#import "TabBarViewController.h"
@interface ManualInviteFriendsViewController (){
    
    Validation *validateObj;
    Indicator *indicator;
    WebServiceConnection *inviteConn;
    NSMutableArray *inviteEmailArray;
    NSString *member_id,*member_first_name;
    UIStoryboard *storyboard;
    TabBarViewController *tabbar;
    id activeField;
}

@end

@implementation ManualInviteFriendsViewController

@synthesize skipBtn,emailTxt,sendInviteBtn,scrollView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    inviteEmailArray = [[NSMutableArray alloc]init];
    
    validateObj = [Validation validationManager];
    
    indicator =  [[Indicator alloc]initWithFrame:self.view.frame];
    
    inviteConn = [WebServiceConnection connectionManager];
    
    self.navigationItem.rightBarButtonItem = skipBtn;
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    [scrollView addGestureRecognizer:tapScroll];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGRect frame = emailTxt.frame;
        
        frame.size.height = 30;
        
        emailTxt.frame = frame;
        
        sendInviteBtn.layer.cornerRadius = 7;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        
        
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        sendInviteBtn.layer.cornerRadius = 5;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.navigationItem.rightBarButtonItem = skipBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)sendInvitaion {
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    member_first_name = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"];
    
    [self.view addSubview:indicator];
    
    NSMutableDictionary *paramURL = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < inviteEmailArray.count; i++) {
        
        [keys addObject:[NSString stringWithFormat:@"email[%d]",i]];
    }
    
    [keys addObject:@"member_id"];
    
    [keys addObject:@"member_first_name"];
    
    [keys addObject:@"total"];
    
    NSString *str = [NSString stringWithFormat:@"%lu", (unsigned long)inviteEmailArray.count];
    
    [inviteEmailArray addObject:member_id];
    
    [inviteEmailArray addObject:member_first_name];
    
    [inviteEmailArray addObject:str];
    
    paramURL = [NSMutableDictionary dictionaryWithObjects:inviteEmailArray forKeys:keys];
    
    NSLog(@"%@", paramURL);
    
    // NSDictionary *urlParam = @{@"email":inviteEmailArray, @"member_id":member_id, @"member_first_name":member_first_name};
    
    [inviteConn startConnectionWithString:@"invite_friends" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([inviteConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
                
                storyboard = self.storyboard;
                
                tabbar = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
                
                [self presentViewController:tabbar animated:YES completion:nil];
                
                NSString *message = @"Welcome to ECAhub! Before you get started, please check your email inbox and junk mail folder for the verification email sent to you.";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                
                [alert show];
            }

            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:Alert_title message:@"As soon as your friends accept your invitation, you will see them in the My Friends page of your Dashboard, which is totally private. Only you can see who your friends are." delegate:self cancelButtonTitle:@"Invite More" otherButtonTitles:@"Ok Thanks", nil];
            
            alertview.tag =1;
            
            [alertview show];
        }
    }];
}

- (IBAction)tap_sendInviteBTn:(id)sender {
    
    NSString *message;
    
    if (![validateObj validateEmail:emailTxt.text]) {
        
        message = @"Please enter valid email";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
    } else {
        
        [inviteEmailArray addObject:emailTxt.text];
        
        [self sendInvitaion];
    }
}

- (IBAction)tap_skipBtn:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- Textfield Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0,0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    
    scrollView.contentInset = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbHeight;
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1) {
        
        if (buttonIndex ==1) {
           
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
      
    }
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    //scrollView.contentOffset = contentInsets;
    
    scrollView.scrollIndicatorInsets = contentInsets;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
       scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        
    }
    else{
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
       scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        
    }
    else{
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    }
    [self.view endEditing:YES];
}
@end
