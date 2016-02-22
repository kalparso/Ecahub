//
//  InviteFriendsViewController.m
//  ecaHUB
//
//  Created by promatics on 8/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "InviteFriendsTableViewCell.h"
#import "Indicator.h"
#import "WebServiceConnection.h"
#import "TabBarViewController.h"

@interface InviteFriendsViewController (){
    
    NSArray *nonRegisteredListArray;
    NSDictionary *ContactlistDict;
    InviteFriendsTableViewCell *cell;
    NSArray *registeredListArray;
    NSMutableArray *friendArray;
    WebServiceConnection *inviteConn;
    Indicator *indicator;
    NSString *member_first_name, *member_id;
    UIStoryboard *storyboard;
    TabBarViewController *tabbar;
}

@end

@implementation InviteFriendsViewController

@synthesize skipBtn,tableView = _tableView,inviteThemBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    friendArray = [[NSMutableArray alloc]init];
    
    inviteConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    ContactlistDict = @{@"Contactslist":[[NSUserDefaults standardUserDefaults]valueForKey:@"myPassFrndsArr"]};
    
    nonRegisteredListArray = [[ContactlistDict valueForKey:@"Contactslist"]valueForKey:@"friendlistArr"];
    
    self.navigationItem.rightBarButtonItem = skipBtn;
    
    _tableView.allowsMultipleSelection = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
       
        inviteThemBtn.layer.cornerRadius = 7;
       
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        inviteThemBtn.layer.cornerRadius = 5;
        
     
    }
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


-(void)tellYourFriends {
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    member_first_name = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"];
    
    [self.view addSubview:indicator];
    
    NSMutableDictionary *paramURL = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < friendArray.count; i++) {
        
        [keys addObject:[NSString stringWithFormat:@"email[%d]",i]];
    }
    
    [keys addObject:@"member_id"];
    
    [keys addObject:@"member_first_name"];
    
    [keys addObject:@"total"];
    
    NSString *str = [NSString stringWithFormat:@"%lu", (unsigned long)friendArray.count];
    [friendArray addObject:member_id];
    
    [friendArray addObject:member_first_name];
    
    [friendArray addObject:str];
    
    paramURL = [NSMutableDictionary dictionaryWithObjects:friendArray forKeys:keys];
    
    NSLog(@"%@", paramURL);
  
    
    [inviteConn startConnectionWithString:@"invite_friends" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([inviteConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
                
                storyboard = self.storyboard;
                
                tabbar = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
                
                [self presentViewController:tabbar animated:YES completion:nil];
                
                NSString *message = @"Welcome to ECAhub! Before you get started, please check your email inbox and junk mail folder for the verification email sent to you.";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Alert_title message:@"As soon as your friends accept your invitation, you will see them in the My Friends page of your Dashboard, which is totally private. Only you can see who your friends are." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
            
            alertView.tag = 1;
            
            [alertView show];
            
            
        }
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [nonRegisteredListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"InviteFriendsCell" forIndexPath:indexPath];
    
    cell.emailLbl.text = [nonRegisteredListArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell =(InviteFriendsTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [friendArray addObject:[nonRegisteredListArray objectAtIndex:indexPath.row]];
    
    [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"Check_Mark"] forState:UIControlStateNormal];
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell =(InviteFriendsTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [friendArray removeObject:[nonRegisteredListArray objectAtIndex:indexPath.row]];
    
    [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
}

- (IBAction)tap_InviteThemBtn:(id)sender {
    
    if ([friendArray count] < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select atleast one contact" delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self tellYourFriends];
    }
    
    
}


- (IBAction)tap_LearnMoreBtn:(id)sender {
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"An email invitation will be sent to the contacts you select." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertview show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag ==1) {
        
        
        if (buttonIndex ==0) {
            
             [self performSegueWithIdentifier:@"ManualInviteSegue" sender:self];
        }
    }
}

- (IBAction)tap_skipBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"ManualInviteSegue" sender:self];
}


@end
