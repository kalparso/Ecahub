//
//  EventBookViewController.m
//  ecaHUB
//
//  Created by promatics on 10/10/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EventBookViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "ListingViewController.h"
#import "EventEnrollmentViewController.h"

@interface EventBookViewController (){
    
    
    WebServiceConnection *getMemberConnection;
    
    Indicator *indicator;
    
    NSArray *memberArray;
    
    NSString *member_id;
    
    NSDictionary *select_memberData;
    
    NSMutableDictionary *noOfattendiesDict;
    
    EventEnrollmentViewController *eventenrolVC;
    
    NSMutableArray *memberDataArray;
    
    int btntype;
    
    BOOL isslctAtndingBtn, isslctAdultBtn, isslctChildBtn;
}
//enrollmentData
@end

@implementation EventBookViewController

@synthesize attendingBtn,selectAdultBtn,selectChildrenBtn,nextBtn;

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Booking Request";
    
    noOfattendiesDict = [[NSMutableDictionary alloc]init];
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    attendingBtn.layer.cornerRadius = 5.0f;
    
    attendingBtn.layer.borderWidth = 1.0f;
    
    attendingBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [attendingBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    selectAdultBtn.layer.cornerRadius = 5.0f;
    
    selectAdultBtn.layer.borderWidth = 1.0f;
    
    selectAdultBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [selectAdultBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    selectChildrenBtn.layer.cornerRadius = 5.0f;
    
    selectChildrenBtn.layer.borderWidth = 1.0f;
    
    selectChildrenBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [selectChildrenBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    isslctAdultBtn = NO;
    
    isslctChildBtn = NO;
    
    isslctAtndingBtn = NO;
    
//    enter_member_detailBtn.layer.cornerRadius = 5.0f;
//    
//    nextBtn.layer.cornerRadius = 5.0f;
//    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
       nextBtn.layer.cornerRadius = 7.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        nextBtn.layer.cornerRadius = 5.0f;
    }
    
//    or_lable.layer.masksToBounds = YES;
    
    getMemberConnection = [WebServiceConnection connectionManager];
    
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
                
                if (memberArray.count < 1) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No member Exits" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                }else{
                    
                    memberDataArray = [[NSMutableArray alloc]init];
                    
                    [memberDataArray addObject:@"Myself"];
                    
                    [memberDataArray addObjectsFromArray:[[memberArray valueForKey:@"Family"] valueForKey:@"first_name"]];
                    
                    [self showListData:memberDataArray allowMultipleSelection:NO selectedData:[attendingBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Select Member"];
                                        
                }
            }
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
    
    if (btntype ==1) {
        
        NSString *name;
        
        if (index ==0) {
            
            name = [[[memberArray objectAtIndex:index] valueForKey:@"Member"] valueForKey:@"first_name"];
            
            member_id = [[[memberArray objectAtIndex:index] valueForKey:@"Member"] valueForKey:@"id"];
            
            [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isMyself"];
            
            select_memberData = [memberArray objectAtIndex:index];
            
            
        }
        else{
            
            name = [[[memberArray objectAtIndex:index-1] valueForKey:@"Family"] valueForKey:@"first_name"];
            
            member_id = [[[memberArray objectAtIndex:index-1] valueForKey:@"Family"] valueForKey:@"id"];
            
            [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"isMyself"];
            
            select_memberData = [memberArray objectAtIndex:index-1];
            
        }
        
   [attendingBtn setTitle:name forState:UIControlStateNormal];
        
   [attendingBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    isslctAtndingBtn = YES;
        
    }
    
    else if (btntype ==2){
        
       NSArray *adultArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        
        NSString *name = [adultArray objectAtIndex:index];
        
        [noOfattendiesDict setObject:name forKey:@"adult"];
        
        [selectAdultBtn setTitle:name forState:UIControlStateNormal];
        
        [selectAdultBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        isslctAdultBtn = YES;
        
    }
    
    else if (btntype ==3){
      
        NSArray *adultArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
        
        NSString *name = [adultArray objectAtIndex:index];
        
        [noOfattendiesDict setObject:name forKey:@"child"];
                           
        [selectChildrenBtn setTitle:name forState:UIControlStateNormal];
        
        [selectChildrenBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        isslctChildBtn = YES;
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)memberBtn:(id)sender {
    
    [self fetchMembers];
}

- (IBAction)nextBtn:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:select_memberData forKey:@"enroll_details"];
    
    [[NSUserDefaults standardUserDefaults] setObject:member_id forKey:@"enrollMember_id"];
    
//    NSString *type = [[[NSUserDefaults standardUserDefaults] valueForKey:@"enrollmentData"] valueForKey:@"type"];
    
    [self performSegueWithIdentifier:@"EventEnrollmentSegue" sender:self];
    
//    if ([type isEqualToString:@"Course"]) {
//        
//        [self performSegueWithIdentifier:@"enroll_course" sender:self];
//        
//    } else if ([type isEqualToString:@"Lesson"]) {
//        
//        [self performSegueWithIdentifier:@"enroll_lesson" sender:self];
//        
//    }  else if ([type isEqualToString:@"Event"]) {
//        
//        [self performSegueWithIdentifier:@"EventEnrollmentSegue" sender:self];
//    }
}

- (IBAction)tap_attendingBtn:(id)sender {
    
    btntype = 1;
    
    [self fetchMembers];
}

- (IBAction)selectAdult:(id)sender {
    
    btntype = 2;
    
    NSArray *adultArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    [self showListData:adultArray allowMultipleSelection:NO selectedData:[selectAdultBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Select Adults/Teens"];
  
}

- (IBAction)selectChildrenBtn:(id)sender {
    
    btntype = 3;
    
    NSArray *adultArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    
    [self showListData:adultArray allowMultipleSelection:NO selectedData:[selectChildrenBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Select Children (under 12)"];
   
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier]isEqualToString:@"EventEnrollmentSegue"]) {
        
        eventenrolVC = [segue destinationViewController];
        
        eventenrolVC.attendiesDict = [noOfattendiesDict mutableCopy];
    }
}

- (IBAction)tap_nextBtn:(id)sender {
    
    NSString *msg;
    
    if (!isslctAtndingBtn) {
        
       msg = @"Please select who is attending/booking.";
        
    }
    
    else if (!isslctAdultBtn && !isslctChildBtn){
        
       msg = @"Please select atleast one member either child or adult.";
    }
    
    else{
            
    [[NSUserDefaults standardUserDefaults] setObject:select_memberData forKey:@"enroll_details"];
    
    [[NSUserDefaults standardUserDefaults] setObject:member_id forKey:@"enrollMember_id"];
    
    [self performSegueWithIdentifier:@"EventEnrollmentSegue" sender:self];
        
    }
    
    if ([msg length]>0) {
        
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:Alert_title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
}
@end
