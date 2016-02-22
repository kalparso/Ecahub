//  editSessionOptionsListingViewController.m
//  ecaHUB
//  Created by promatics on 11/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.

#import "editSessionOptionsListingViewController.h"
#import "DateConversion.h"
#import "editSessionOptionsListingTableViewCell.h"
#import "SessionDetailViewController.h"
#import "AddSessionViewController.h"
#import "WebServiceConnection.h"
#import "MyListingViewController.h"
#import "EventSessionViewController.h"
#import "AddEventSessionViewController.h"
#import "LessionSessionViewController.h"
#import "AddLessonSessionsViewController.h"

@interface editSessionOptionsListingViewController (){
    
    NSArray *sessionArray;
    DateConversion *dateconversion;
    editSessionOptionsListingTableViewCell *cell;
    WebServiceConnection *getCourseConn;
    
}

@end

@implementation editSessionOptionsListingViewController

@synthesize add_barbutton,donebutton,listing_tableView,type,info_lbl,listing_type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Edit Session Options";
    
    self.navigationItem.hidesBackButton = YES;
    
    info_lbl.text = @"No session options have been saved for this Listing, and you need at least one session option on your Listing. Create a session option by clicking the '+' above.";
    
    info_lbl.numberOfLines = 0;
    
    info_lbl.lineBreakMode = NSLineBreakByWordWrapping;
    
    [info_lbl sizeToFit];
    
    dateconversion = [DateConversion dateConversionManager];
    
    self.navigationItem.rightBarButtonItems = @[donebutton,add_barbutton];
    
    //  sessionArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"]valueForKey:@"course_sessions"];
    
    if (sessionArray.count>0) {
        
        info_lbl.hidden = YES;
        
        listing_tableView.hidden = NO;
    }
    
    else{
        
        info_lbl.hidden = NO;
        
        listing_tableView.hidden = YES;
        
    }
    
    // [listing_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if([listing_type isEqualToString:@"1"]){
        
        sessionArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"]valueForKey:@"course_sessions"];
        
    } else if([listing_type isEqualToString:@"2"]){
        
        sessionArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]valueForKey:@"event_sessions"];
        
        
    } else if([ listing_type isEqualToString:@"3"]){
        
        sessionArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]valueForKey:@"lesson_sessions"];
        
    }
    if (sessionArray.count>0) {
        
        info_lbl.hidden = YES;
        
        listing_tableView.hidden = NO;
        
    } else {
        
        info_lbl.hidden = NO;
        
        listing_tableView.hidden = YES;
        
    }
    
    [listing_tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"addCourseSession"]) {
        
        AddSessionViewController *addSessionVC = [segue destinationViewController];
        
        addSessionVC.isEdit = YES;
        
        if (sessionArray.count >0) {
            
            addSessionVC.isPrevAddress = YES;
        }
        else{
            
            addSessionVC.isPrevAddress = NO;
        }
        
    }
    
    else if ([[segue identifier] isEqualToString:@"addEventSession"]) {
        
        AddEventSessionViewController *addEventSessionVC = [segue  destinationViewController];
        
        addEventSessionVC.isEdit = YES;
        
        if (sessionArray.count >0) {
            
            addEventSessionVC.isPrevAddress = YES;
        }
        else{
            
            addEventSessionVC.isPrevAddress = NO;
        }
        
    }
    
    //    else if ([[segue identifier] isEqualToString:@"addEventSession"]) {
    //
    //        AddEventSessionViewController *addEventSessionVC = [segue destinationViewController];
    //
    //        addEventSessionVC.isEdit = YES;
    //
    //        if (sessionArray.count >0) {
    //
    //            addEventSessionVC.isPrevAddress = YES;
    //        }
    //        else{
    //
    //            addEventSessionVC.isPrevAddress = NO;
    //        }
    //
    //    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sessionArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"sessionCell" forIndexPath:indexPath];
    
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"]);
    
    if([listing_type isEqualToString:@"1"]){
        
        
        NSString *start_date = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"]valueForKey:@"course_sessions"]objectAtIndex:indexPath.row]valueForKey:@"CourseSession" ]valueForKey:@"start_date"];
        
        if (![start_date isEqualToString:@""]) {
            
            start_date = [dateconversion convertDate:start_date];
        }
        else{
            
            start_date = @"";
        }
        
        NSString *finish_date = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"]valueForKey:@"course_sessions"]objectAtIndex:indexPath.row]valueForKey:@"CourseSession" ]valueForKey:@"finish_date"];
        
        if (![finish_date isEqualToString:@""]) {
            
            finish_date = [dateconversion convertDate:finish_date];
        }
        else{
            
            finish_date = @"";
        }
        
        NSString *session_name = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"]valueForKey:@"course_sessions"]objectAtIndex:indexPath.row]valueForKey:@"CourseSession" ]valueForKey:@"session_name"];
        
        cell.session_name.text = session_name;
        
        NSString *sessions = [[[[@"("stringByAppendingString:start_date]stringByAppendingString:@" - "]stringByAppendingString:finish_date]stringByAppendingString:@")"];
        
        cell.date_time.text = sessions;
        
        
    } else if([listing_type isEqualToString:@"3"]){
        
        NSString *start_date = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]valueForKey:@"lesson_sessions"]objectAtIndex:indexPath.row]valueForKey:@"LessonSession" ]valueForKey:@"start_date"];
        
        if (![start_date isEqualToString:@""]) {
            
            start_date = [dateconversion convertDate:start_date];
        }
        else{
            
            start_date = @"";
        }
        
        NSString *finish_date = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]valueForKey:@"lesson_sessions"]objectAtIndex:indexPath.row]valueForKey:@"LessonSession" ]valueForKey:@"finish_date"];
        
        if (![finish_date isEqualToString:@""]) {
            
            finish_date = [dateconversion convertDate:finish_date];
        }
        else{
            
            finish_date = @"Indefinite";
        }
        
        NSString *session_name = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]valueForKey:@"lesson_sessions"]objectAtIndex:indexPath.row]valueForKey:@"LessonSession" ]valueForKey:@"session_name"];
        
        cell.session_name.text = session_name;
        
        NSString *sessions = [[[[@"("stringByAppendingString:start_date]stringByAppendingString:@" - "]stringByAppendingString:finish_date]stringByAppendingString:@")"];
        
        cell.date_time.text = sessions;
        
    } else if ([listing_type isEqualToString:@"2"]){
        
        
        NSString *start_date = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]valueForKey:@"event_sessions"]objectAtIndex:indexPath.row]valueForKey:@"EventSession" ]valueForKey:@"start_date"];
        
        if (![start_date isEqualToString:@""]) {
            
            start_date = [dateconversion convertDate:start_date];
        }
        else{
            
            start_date = @"";
        }
        
        NSString *finish_date = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]valueForKey:@"event_sessions"]objectAtIndex:indexPath.row]valueForKey:@"EventSession" ]valueForKey:@"finish_date"];
        
        if (![finish_date isEqualToString:@""]) {
            
            finish_date = [dateconversion convertDate:finish_date];
        }
        else{
            
            finish_date = @"";
        }
        
        NSString *session_name = [[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]valueForKey:@"event_sessions"]objectAtIndex:indexPath.row]valueForKey:@"EventSession" ]valueForKey:@"session_name"];
        
        cell.session_name.text = session_name;
        
        // NSString *sessions = [[[[@"("stringByAppendingString:start_date]stringByAppendingString:@" - "]stringByAppendingString:finish_date]stringByAppendingString:@")"];
        
        // cell.date_time.text = sessions;
        
        cell.date_time.text = start_date;
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([listing_type isEqualToString:@"1"]) {
        
        NSDictionary *sesionDict = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"] valueForKey:@"course_sessions"] objectAtIndex:indexPath.row];
        
        NSDictionary *age_groupDict = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"] valueForKey:@"age_title"] objectAtIndex:indexPath.row];
        
        NSDictionary *course_sessionDict = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"] valueForKey:@"course_sessions"] objectAtIndex:indexPath.row];
        
        NSDictionary *suitableDict = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"CourseDetail"] valueForKey:@"suitable_for"] objectAtIndex:indexPath.row];
        
        NSMutableDictionary *sessionData_dict = [[NSMutableDictionary alloc] init];
        
        [sessionData_dict setObject:sesionDict forKey:@"sesion"];
        
        [sessionData_dict setObject:age_groupDict forKey:@"age_group"];
        
        [sessionData_dict setObject:course_sessionDict forKey:@"course_session"];
        
        [sessionData_dict setObject:suitableDict forKey:@"suitable"];
        
        NSLog(@"%@", sessionData_dict);
        
        [[NSUserDefaults standardUserDefaults] setValue:sessionData_dict forKey:@"sessionDetail"];
        
        EventSessionViewController *sessionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SessionDetail"];
        
        sessionVC.isEdit = YES;
        
        if (sessionArray.count >0) {
            
            sessionVC.isPrevAddAvail = YES;
        }
        else{
            
            sessionVC.isPrevAddAvail = NO;
        }
        
        [self.navigationController pushViewController:sessionVC animated:YES];
        
    } else if ([listing_type isEqualToString:@"3"]){
        
        NSDictionary *sesionDict = [[[[[NSUserDefaults standardUserDefaults]valueForKey:@"lessonDetail"]valueForKey:@"lesson_info"] valueForKey:@"Sessions"]objectAtIndex:indexPath.row];
        
        NSDictionary *age_groupDict = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"age_title"] objectAtIndex:indexPath.row];
        
        NSDictionary *course_sessionDict = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_sessions"] objectAtIndex:indexPath.row];
        
        NSDictionary *suitableDict = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"suitable_for"] objectAtIndex:indexPath.row];
        
        NSMutableDictionary *sessionData_dict = [[NSMutableDictionary alloc] init];
        
        [sessionData_dict setObject:sesionDict forKey:@"sesion"];
        
        [sessionData_dict setObject:age_groupDict forKey:@"age_group"];
        
        [sessionData_dict setObject:course_sessionDict forKey:@"course_session"];
        
        [sessionData_dict setObject:suitableDict forKey:@"suitable"];
        
        NSLog(@"%@", sessionData_dict);
        
        [[NSUserDefaults standardUserDefaults] setValue:sessionData_dict forKey:@"sessionDetail"];
        
        LessionSessionViewController *sessionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"lessionSessionDetail"];
        
        sessionVC.isEdit = YES;
        
        if (sessionArray.count >0) {
            
            sessionVC.isPrevAddAvail = YES;
        }
        else{
            
            sessionVC.isPrevAddAvail = NO;
        }
        
        [self.navigationController pushViewController:sessionVC animated:YES];
        
        
    } else if ([listing_type isEqualToString:@"2"]) {
        
        NSDictionary *sesionDict = [[[[NSUserDefaults standardUserDefaults]valueForKey:@"eventDetail"]valueForKey:@"event_info"] valueForKey:@"EventListing"];
        
        NSDictionary *age_groupDict = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"age_title"] objectAtIndex:indexPath.row];
        
        NSDictionary *course_sessionDict = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_sessions"] objectAtIndex:indexPath.row];
        
        NSDictionary *suitableDict = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"suitable_for"] objectAtIndex:indexPath.row];
        
        NSMutableDictionary *sessionData_dict = [[NSMutableDictionary alloc] init];
        
        [sessionData_dict setObject:sesionDict forKey:@"sesion"];
        
        [sessionData_dict setObject:age_groupDict forKey:@"age_group"];
        
        [sessionData_dict setObject:course_sessionDict forKey:@"course_session"];
        
        [sessionData_dict setObject:suitableDict forKey:@"suitable"];
        
        NSLog(@"%@", sessionData_dict);
        
        [[NSUserDefaults standardUserDefaults] setValue:sessionData_dict forKey:@"sessionDetail"];
        
        LessionSessionViewController *sessionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"eventSessionDetail"];
        
        sessionVC.isEdit = YES;
        
        if (sessionArray.count >0) {
            
            sessionVC.isPrevAddAvail = YES;
        }
        else{
            
            sessionVC.isPrevAddAvail = NO;
        }
        
        [self.navigationController pushViewController:sessionVC animated:YES];
        
        //        NSDictionary *sesionDict = [sessionArray objectAtIndex:indexPath.row];
        //
        //        NSDictionary *age_groupDict = [[eventDetailArray valueForKey:@"age_title"] objectAtIndex:indexPath.row];
        //
        //        NSDictionary *course_sessionDict = [[eventDetailArray valueForKey:@"event_sessions"] objectAtIndex:indexPath.row];
        //
        //        NSDictionary *suitableDict = [[eventDetailArray valueForKey:@"suitable_for"] objectAtIndex:indexPath.row];
        //
        //        NSMutableDictionary *sessionData_dict = [[NSMutableDictionary alloc] init];
        //
        //        [sessionData_dict setObject:sesionDict forKey:@"sesion"];
        //
        //        [sessionData_dict setObject:age_groupDict forKey:@"age_group"];
        //
        //        [sessionData_dict setObject:course_sessionDict forKey:@"course_session"];
        //
        //        [sessionData_dict setObject:suitableDict forKey:@"suitable"];
        //
        //        NSLog(@"%@", sessionData_dict);
        //
        //        [[NSUserDefaults standardUserDefaults] setValue:sessionData_dict forKey:@"sessionDetail"];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)tap_add_barbutton:(id)sender {
    
    if([listing_type isEqualToString:@"1"]){
        
        [self performSegueWithIdentifier:@"addCourseSession" sender:self];
        
    }
    else if([ listing_type isEqualToString:@"2"]){
        
        [self performSegueWithIdentifier:@"addEventSession" sender:self];
        
    } else if ([listing_type isEqualToString:@"3"]) {
        
        AddLessonSessionsViewController *addSessionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addLessonSession"];
        
        if (sessionArray.count >0) {
            
            addSessionVC.isPrevAddress = YES;
        }
        else{
            
            addSessionVC.isPrevAddress = NO;
        }
        
        [self.navigationController pushViewController:addSessionVC animated:YES];
        
    }
}
- (IBAction)tap_donebutton:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You have successfully updated the Listing. For other members to see it, please ensure to click the 'post' icon once again on this Listing in your My Listings." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    MyListingViewController *myListingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myListing"];
    
    [self.navigationController pushViewController:myListingVC animated:YES];
    
    [alertView show];
}
@end
