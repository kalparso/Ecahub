 //
//  FindRegisteredFriendsViewController.m
//  ecaHUB
//
//  Created by promatics on 8/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "FindRegisteredFriendsViewController.h"
#import "FindRegisteredFriendsTableViewCell.h"
#import "Indicator.h"
#import "WebServiceConnection.h"
#import "TabBarViewController.h"

@interface FindRegisteredFriendsViewController (){
    
    NSDictionary *ContactlistDict;
 
    NSArray *registeredListArray;
    FindRegisteredFriendsTableViewCell *cell;
    NSMutableArray *friendArray;
    WebServiceConnection *inviteConn;
    Indicator *indicator;
    NSString *member_first_name, *member_id;
    UIStoryboard *storyboard;
    TabBarViewController *tabbar;
    NSArray *fbArray;
}

@end

@implementation FindRegisteredFriendsViewController

@synthesize skipBtn,tableView = _tableView,tellThemBtn,isfb;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    inviteConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    if (isfb == YES) {
        
         fbArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"fbArray"];
    }
    else{
    
    ContactlistDict = @{@"Contactslist":[[NSUserDefaults standardUserDefaults]valueForKey:@"myPassFrndsArr"]};
   
    registeredListArray = [[ContactlistDict valueForKey:@"Contactslist"]valueForKey:@"friendArr"];
    }
    
    if ([registeredListArray count] == 0 && isfb == NO) {
        
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"You don’t seem to have any of your contacts on ECAhubyet. But you can certainly invite them to join you." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
        
        alertview.tag = 2;
        
        [alertview show];
    }
    
    else if ([fbArray count]==0 && isfb == YES){
        
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"You don’t seem to have any of your contacts on ECAhubyet. But you can certainly invite them to join you." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
        
        alertview.tag = 2;
        
        [alertview show];
        
        
    }
    
    self.navigationItem.rightBarButtonItem = skipBtn;
    
    friendArray =[[NSMutableArray alloc]
                  init];
    
    [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    _tableView.allowsMultipleSelection = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        tellThemBtn.layer.cornerRadius = 7;
        
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        tellThemBtn.layer.cornerRadius = 5;
        
        
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

#pragma mark - Tell Friends

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
    
    // NSDictionary *urlParam = @{@"email":inviteEmailArray, @"member_id":member_id, @"member_first_name":member_first_name};
    //email, member_first_name, total    {email should be in array format like email[0],email[1]...}
    
    [inviteConn startConnectionWithString:@"invite_registered_friends" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
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
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Message sent successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            alert.tag = 4;
            
            [alert show];
        }
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [registeredListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"RegisteredListingCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
   // cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (isfb == YES) {
        
        cell.emailLbl.text = [fbArray objectAtIndex:indexPath.row];
    }
    else{
        
    cell.emailLbl.text = [registeredListArray objectAtIndex:indexPath.row];
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    NSLog(@"%ld",(long)indexPath.row);
    
    cell =(FindRegisteredFriendsTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
    
    if (isfb == YES) {
        
        [friendArray addObject:[fbArray objectAtIndex:indexPath.row]];
    }
    else{
    
    [friendArray addObject:[registeredListArray objectAtIndex:indexPath.row]];
        
    }
    
    [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"Check_Mark"] forState:UIControlStateNormal];
    
    //cell.imgview.image = [UIImage imageNamed:@"Check_Mark"];
 
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell =(FindRegisteredFriendsTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
    
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    NSLog(@"%ld",(long)indexPath.row);
    
    if (isfb == YES) {
        
         [friendArray removeObject:[fbArray objectAtIndex:indexPath.row]];
        
    }
    else{
    
     [friendArray removeObject:[registeredListArray objectAtIndex:indexPath.row]];
        
    }
    
     [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    cell.imgview.image = [UIImage imageNamed:@"un_check"];
   
}


- (IBAction)tap_checkBtn:(id)sender {
}
- (IBAction)tap_tellThemBtn:(id)sender {
    
    if ([friendArray count] < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select atleast one contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self tellYourFriends];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==2) {
        
        if (buttonIndex==0) {
            
            if (isfb == YES) {
                
                [self performSegueWithIdentifier:@"ManualInviteSegue" sender:self];
                
            }
            else{
                
                [self performSegueWithIdentifier:@"InviteSegue" sender:self];
                
            }
        }
        
    }
    
    else if (alertView.tag==4) {
        
        if (buttonIndex==0) {
            
            if (isfb == YES) {
                
                [self performSegueWithIdentifier:@"ManualInviteSegue" sender:self];
                
            }
            else{
                
                [self performSegueWithIdentifier:@"InviteSegue" sender:self];
                
            }
        }
        
    }
}


- (IBAction)tap_learnMoreBtn:(id)sender {
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"An email will be sent to these contacts to tell them that you are now on ECAhub. Once they confirm to know you, they will be on your My Friends page on your Dashboard, which is totally private. Only you can see who your friends are. By having them as friends on ECAhub, it makes sharing discoveries easier." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertview show];
    
    
}
- (IBAction)tap_skipBtn:(id)sender {
    
    if (isfb ==YES) {
        
        [self performSegueWithIdentifier:@"ManualInviteSegue" sender:self];
        
    }
    else{
    
    [self performSegueWithIdentifier:@"InviteSegue" sender:self];
        
    }
}
@end
