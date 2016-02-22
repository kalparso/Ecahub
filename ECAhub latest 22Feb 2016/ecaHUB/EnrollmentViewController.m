
//
//  EnrollmentViewController.m
//  ecaHUB
//
//  Created by promatics on 4/9/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EnrollmentViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"

@interface EnrollmentViewController () {
    
    WebServiceConnection *getMemberConnection ,*myProfileConnection;
    
    Indicator *indicator;
    
    NSArray *memberArray;
    
    NSString *member_id;
    
    NSDictionary *select_memberData;
    
    NSMutableArray *memberDataArray;
    
    NSInteger isselect;
    
}
@end

@implementation EnrollmentViewController

@synthesize select_memberBtn, nextBtn, enter_member_detailBtn, or_lable;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    select_memberBtn.layer.cornerRadius = 5.0f;
    
    select_memberBtn.layer.borderWidth = 1.0f;
    
    select_memberBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [select_memberBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    enter_member_detailBtn.layer.cornerRadius = 5.0f;
    
    memberDataArray = [[NSMutableArray alloc]init];
    
    nextBtn.layer.cornerRadius = 5.0f;
    
    isselect = 0;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        or_lable.layer.cornerRadius = 30.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
       
        or_lable.layer.cornerRadius = 20.0f;
    }
    
    or_lable.layer.masksToBounds = YES;

    getMemberConnection = [WebServiceConnection connectionManager];
    
    myProfileConnection = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
}

-(void)fetchMembers {
    
    [self.view addSubview:indicator];
    
    NSDictionary *urlParm = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [getMemberConnection startConnectionWithString:[NSString stringWithFormat:@"family_member_list"] HttpMethodType:Post_Type HttpBodyType:urlParm Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([getMemberConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                memberArray = [receivedData valueForKey:@"family_details"];
                
//                if (memberArray.count < 1) {
//                    
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No member Exits" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                    
//                    [alert show];
//                    
//                }else{
                
                    memberDataArray = [[NSMutableArray alloc]init];
                    
                    [memberDataArray addObject:@"Myself"];
                
                if (memberArray.count > 0) {
                    
                    [memberDataArray addObjectsFromArray:[[memberArray valueForKey:@"Family"] valueForKey:@"first_name"]];
                    
                }
                
                 [self showListData:memberDataArray allowMultipleSelection:NO selectedData:[select_memberBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Select Member"];
            
//                }
            }
        }
    }];
}

-(void) fetchUpdateUserData {
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"]);
    
    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [self.view addSubview:indicator];
    
    [myProfileConnection startConnectionWithString:[NSString stringWithFormat:@"user_view_profile"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([myProfileConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            [[NSUserDefaults standardUserDefaults] setValue:receivedData forKey:@"userInfo"];
            
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"]);
            
            NSString *lastName = [[receivedData valueForKey:@"Member"] valueForKey:@"first_name"];
            
                    }
    }];
}

-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title {
    
    ListingViewController *listViewController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"listingVC"];
        
    } else {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil] instantiateViewControllerWithIdentifier:@"listingVC"];
    }
    
    listViewController.isMultipleSelected = allowMultipleSelection;
    
    listViewController.array_data = [items mutableCopy];
    
    listViewController.selectedData = [selectedData mutableCopy];
    
    listViewController.delegate = self;
    
    listViewController.title = title;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - list delegate

-(void)didSelectListItem:(id)item index:(NSInteger)index{
    
    isselect = 1;
    
    NSString *name;
    
    if (index ==0) {
        
        name = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"];
        
        member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
        
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isMyself"];
        
         //select_memberData = [memberArray objectAtIndex:index];
       
        
    }
    else{
        
        NSLog(@"%@",memberDataArray);
        
        
        name = [[[memberArray objectAtIndex:index-1] valueForKey:@"Family"] valueForKey:@"first_name"];
        
        member_id = [[[memberArray objectAtIndex:index-1] valueForKey:@"Family"] valueForKey:@"id"];
        
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"isMyself"];
        
        select_memberData = [memberArray objectAtIndex:index-1];
        
    }
  
    //name = [@"  " stringByAppendingString:name];
        
    [select_memberBtn setTitle:name forState:UIControlStateNormal];
    
    [select_memberBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)memberBtn:(id)sender {
    
    [self fetchUpdateUserData];
    
    [self fetchMembers];
}

- (IBAction)nextBtn:(id)sender {
    
    if (isselect ==1) {
        
        NSLog(@"%@",select_memberData);
                
        [[NSUserDefaults standardUserDefaults] setObject:select_memberData forKey:@"enroll_details"];
        
        [[NSUserDefaults standardUserDefaults] setObject:member_id forKey:@"enrollMember_id"];
        
        NSString *type = [[[NSUserDefaults standardUserDefaults] valueForKey:@"enrollmentData"] valueForKey:@"type"];
        
        if ([type isEqualToString:@"Course"]) {
            
            [self performSegueWithIdentifier:@"enroll_course" sender:self];
            
        } else if ([type isEqualToString:@"Lesson"]) {
            
            [self performSegueWithIdentifier:@"enroll_lesson" sender:self];
            
        }  else if ([type isEqualToString:@"Event"]) {
            
            [self performSegueWithIdentifier:@"enroll_event" sender:self];
        }
    }
    
    else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please select 'who is enrolling' " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
                [alert show];
    }
    
   
}

- (IBAction)enterMemberBtn:(id)sender {
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
