//
//  PaypalAccountViewController.m
//  ecaHUB
//
//  Created by promatics on 5/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "PaypalAccountViewController.h"
#import "PaypalAccTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"

@interface PaypalAccountViewController () {
    
    WebServiceConnection *paypalAccConn;
    
    Indicator *indicator;
    
    PaypalAccTableViewCell *cell;
    
    NSArray *accountArray;
    
    Validation *validationObj;
}
@end

@implementation PaypalAccountViewController

@synthesize tbl_view;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    paypalAccConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    validationObj = [Validation validationManager];
    
  //  [self fetchPaypalAccounts];
}

-(void)fetchPaypalAccounts {
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id": [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};

    [paypalAccConn startConnectionWithString:@"" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([paypalAccConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([accountArray count] > 0) {
                
                [tbl_view reloadData];
                
                tbl_view.hidden = NO;
                
            } else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No Record Exits" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
                tbl_view.hidden = YES;
            }
        }
    }];
}

#pragma mark- UITableView Delegates & DataSourses

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tbl_view dequeueReusableCellWithIdentifier:@"paypalAccCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect frame = cell.delete_btn.frame;
    
    frame.origin.x = tbl_view.frame.size.width - frame.size.width - 10;
    
    cell.delete_btn.frame = frame;
    
    frame = cell.editBtn.frame;
    
    frame.origin.x = cell.delete_btn.frame.origin.x - frame.size.width - 20;
    
    cell.editBtn.frame = frame;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)tapAddAccountBtn:(id)sender {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Account" message:@"Enter Your Paypal Id"  delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Submit", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
}

#pragma mark UIAlertView Delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSString *email = [alertView textFieldAtIndex:0].text;
        
        if (![validationObj validateEmail:email]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please enter valid email"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        } else {
            
            NSLog(@"%@", email);
        }
    }
}

@end

