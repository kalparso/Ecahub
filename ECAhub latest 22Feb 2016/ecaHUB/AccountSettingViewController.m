//
//  AccountSettingViewController.m
//  ecaHUB
//
//  Created by promatics on 8/20/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

//
//  AccountSettingViewController.m
//  ecaHUB
//
//  Created by promatics on 8/20/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "AccountViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "AddPersonalAccountViewController.h"

@interface AccountSettingViewController (){
    
    WebServiceConnection *getConn;
    Validation *validation;
    Indicator *indicator;
    BOOL isPersonalAcnt;
    NSString *accountActivity;
    NSArray  *PersonalAccountArray;
    NSArray *BusinessAccountArray;
    AddPersonalAccountViewController *addEditacnt;
    
}

@end

@implementation AccountSettingViewController

@synthesize personalAcntBtn,businessAcntBtn,main_view,scroll_view,info_btn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"Account Settings";
    
    scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, businessAcntBtn.frame.origin.y+100);
    
    scroll_view.backgroundColor = [UIColor whiteColor];
    
    //scroll_view.hidden = YES;
    
    getConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    personalAcntBtn.layer.cornerRadius =5;
    businessAcntBtn.layer.cornerRadius =5;
    
    
    
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self fetchData];
}

-(void)viewWillAppear:(BOOL)animated{
    
    scroll_view.hidden = YES;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier]isEqualToString:@"AccountVC"]){
        
        AccountViewController *acntVC = [segue destinationViewController];
        
        acntVC.IsPersonalAcntView = isPersonalAcnt;
        
    }
    else if([[segue identifier]isEqualToString:@"PersonalAccountVC"]){
        
        addEditacnt = [segue destinationViewController];
        
        addEditacnt.IsPersonalAcntView = isPersonalAcnt;
        
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)fetchData{
    
    NSDictionary *paramURL = @{@"member_id": [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [self.view addSubview:indicator];
    
    [getConn startConnectionWithString:@"account_view" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        
        if([getConn responseCode]==1){
            
            NSLog(@"%@",receivedData);
            
            PersonalAccountArray = [[NSArray alloc]init];
            
            BusinessAccountArray = [[NSArray alloc]init];
            
            PersonalAccountArray = [[receivedData valueForKey:@"personal"]valueForKey:@"PersonalAccount"];
            
            BusinessAccountArray = [[receivedData valueForKey:@"business"]valueForKey:@"BusinessAccount"];
            
            if([PersonalAccountArray count]> 0){
                
                [personalAcntBtn setTitle:@"Personal Account Details" forState:UIControlStateNormal];
            }
            if ([BusinessAccountArray count]>0){
                
                [businessAcntBtn setTitle:@"Business Account Details" forState:UIControlStateNormal];
                
            }
            
            scroll_view.hidden = NO;
            
        }}];
    
}
- (IBAction)tap_personalAcntBtn:(id)sender {
    
    isPersonalAcnt = YES;
    
    if([PersonalAccountArray count]> 0){
        
        
        [self performSegueWithIdentifier:@"AccountVC" sender:self];
        
    }
    else
    {
        
        [self performSegueWithIdentifier:@"PersonalAccountVC" sender:self];
        
    }
    
    
}
- (IBAction)tap_BusinessAcntBtn:(id)sender {
    
    isPersonalAcnt = NO;
    
    if ([BusinessAccountArray count]>0){
        
        [self performSegueWithIdentifier:@"AccountVC" sender:self];
        
    }
    else{
        
        [self performSegueWithIdentifier:@"PersonalAccountVC" sender:self];
        
    }
    
}
- (IBAction)tapInfo_btn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"ECAhub operates out of Hong Kong. If your Bank Account is outside of Hong Kong, we recommend you use PayPal instead to receive Refunds from ECAhub. It saves you international transfer fees.\nTo use PayPal as your Refund account, you simply add the email address you have used to register an account with PayPal. Any refunds that is due to you will be credited to your PayPal account, which you can then withdraw and deposit to your local bank account anytime." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (IBAction)tapBusinessInfo:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"ECAhub operates out of Hong Kong. If your Bank Account is outside of Hong Kong, we recommend you use PayPal instead to receive funds from ECAhub. It saves you international transfer fees.\nTo use PayPal as your Pay-In account, you simply add the email address you have used to register an account with PayPal. Any sales income that is due to you will be credited to your PayPal account, which you can then withdraw and deposit to your local bank account anytime." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
    
}
@end
