//
//  AllEventSessionViewController.m
//  ecaHUB
//
//  Created by promatics on 6/22/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AllEventSessionViewController.h"
#import "AllEventSessionTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "SendMessageView.h"
#import "EnrollmentViewController.h"

@interface AllEventSessionViewController () {
    
    AllEventSessionTableViewCell *cell;
    WebServiceConnection *enrollConn;
    Indicator *indicator;
    DateConversion *dateConversion;
    EnrollmentViewController *enrolVC;
    SendMessageView *sendMsgView;
}

@end

@implementation AllEventSessionViewController

@synthesize sessionArray, tbl_view;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Session Options";
    
    enrollConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    NSLog(@"%@", sessionArray);
    
    dateConversion = [DateConversion dateConversionManager];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    [super viewWillDisappear:animated];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return cell.main_view.frame.size.height + cell.main_view.frame.origin.y +5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[sessionArray valueForKey:@"event_info"] valueForKey:@"Sessions"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"eventSessionCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    NSString *fdate = [[[[sessionArray valueForKey:@"event_info"] valueForKey:@"Sessions"] objectAtIndex:indexPath.row] valueForKey:@"finish_date"];
//    
//    NSString *sdate = [[[[sessionArray valueForKey:@"event_info"] valueForKey:@"Sessions"] objectAtIndex:indexPath.row] valueForKey:@"start_date"];
//    
//    if ([sdate isEqualToString:@""]||sdate == nil) {
//        
//        sdate = @"";
//    }
//    else
//    {
//        
//        sdate = [dateConversion convertDate:sdate];
//        
//    }
//    
//    if ([fdate isEqualToString:@""]||fdate == nil) {
//        
//        fdate =@"";
//    }
//    else
//    {
//        
//        fdate = [@" - "stringByAppendingString:[dateConversion convertDate:fdate]];
//        
//    }
    
    NSString *date = [[[[sessionArray valueForKey:@"event_sessions"]objectAtIndex:indexPath.row ]valueForKey:@"EventSession"] valueForKey:@"start_date"];
    
    if ([date isEqualToString:@""]) {
        
        date = @"";
    }
    else{
        
        date = [dateConversion convertDate:date];
        
    }
    date = [date stringByAppendingString:@" ( "];
    
    date = [date stringByAppendingString:[[[[sessionArray valueForKey:@"event_sessions"]objectAtIndex:indexPath.row ]valueForKey:@"EventSession"] valueForKey:@"start_time"]];
    
    date = [date stringByAppendingString:@" - "];
    
    date = [date stringByAppendingString:[[[[sessionArray valueForKey:@"event_sessions"]objectAtIndex:indexPath.row ]valueForKey:@"EventSession"] valueForKey:@"finish_time"]];
    
    date = [date stringByAppendingString: @" )"];
    
    cell.day_timeValue.text = date;
       
    NSArray *age_array =[[sessionArray valueForKey:@"age_title"]objectAtIndex:0];
    
    NSString *age = @" ";
    
    for (int i= 0; i < age_array.count; i++) {
        
        age = [age stringByAppendingString:[[[age_array objectAtIndex:i] valueForKey:@"AgeGroup"]valueForKey:@"title"]];
        
        if (i+1< age_array.count){
            
            age = [age stringByAppendingString:@", "];
            
        }
        
        //age = [age stringByAppendingString:age];
        
    }
    
    cell.age_groupValue.text = [age stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length = [age length];
    
    NSString *agetag = @"Age Group";
    
    for (int i =0;i< length; i++) {
        
        agetag = [agetag stringByAppendingString:@" "];
    }
    
    cell.age_group.text = agetag;
    
    NSArray *genderArray = [[[[sessionArray valueForKey:@"suitable_for"] objectAtIndex:indexPath.row] valueForKey:@"Suitable"] valueForKey:@"title"];
    
    cell.genderValue.text = [genderArray componentsJoinedByString:@", "];
    
    cell.max_classValue.text = [[[[[sessionArray valueForKey:@"event_sessions"]objectAtIndex:indexPath.row ]valueForKey:@"EventSession"] valueForKey:@"total_students"]stringByAppendingString:@" Attendees"];
    
    cell.placesValue.text = [[[[sessionArray valueForKey:@"event_sessions"]objectAtIndex:indexPath.row ]valueForKey:@"EventSession"] valueForKey:@"places"];
    
    NSString *currency = [[[[sessionArray valueForKey:@"event_sessions"] objectAtIndex:indexPath.row] valueForKey:@"Currency"] valueForKey:@"name"];
    
    NSString *name = [[[[sessionArray valueForKey:@"event_sessions"]objectAtIndex:indexPath.row ]valueForKey:@"EventSession"] valueForKey:@"fee_quantity"];
    
    currency = [currency stringByAppendingString:[NSString stringWithFormat:@" %0.2f",[name   floatValue]]];
    
    cell.feeValue.text = currency;
    
    cell.session_name.text = [[[[sessionArray valueForKey:@"event_sessions"]objectAtIndex:indexPath.row ]valueForKey:@"EventSession"] valueForKey:@"session_name"];
    
    tbl_view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    cell.day_time.text = @"Date & Time";
    
    cell.places.text = @"Seats Remaining";
    
    cell.fee.text = @"Event Entry Fee";
    
    CGRect Frame = cell.day_time.frame;
    
    Frame.size.width = cell.day_time.frame.size.width;
    
    cell.day_time.frame = Frame;
    
    [cell.day_time sizeToFit];
    
    Frame = cell.day_timeValue.frame;
    
    Frame.size.width = cell.day_timeValue.frame.size.width;
    
    cell.day_timeValue.frame = Frame;
    
    [cell.day_timeValue sizeToFit];
    
    Frame = cell.age_group.frame;
    
    Frame.size.width = cell.age_group.frame.size.width;
    
    Frame.origin.y = cell.day_timeValue.frame.origin.y +cell.day_timeValue.frame.size.height +8;
    
    cell.age_group.frame = Frame;
    
    [cell.age_group sizeToFit];
    
    Frame = cell.age_groupValue.frame;
    
    Frame.size.width = cell.age_groupValue.frame.size.width;
    
    Frame.origin.y = cell.day_timeValue.frame.origin.y +cell.day_timeValue.frame.size.height +8;
    
    cell.age_groupValue.frame = Frame;
    
    [cell.age_groupValue sizeToFit];
    
    Frame = cell.gender.frame;
    
    Frame.size.width = cell.gender.frame.size.width;
    
    Frame.origin.y = cell.age_groupValue.frame.origin.y +cell.age_groupValue.frame.size.height +8;
    
    cell.gender.frame = Frame;
    
    [cell.gender sizeToFit];
    
    Frame = cell.genderValue.frame;
    
    Frame.size.width = cell.genderValue.frame.size.width;
    
    Frame.origin.y = cell.age_groupValue.frame.origin.y +cell.age_groupValue.frame.size.height +8;
    
    cell.genderValue.frame = Frame;
    
    [cell.genderValue sizeToFit];
    
    Frame = cell.max_class.frame;
    
    Frame.size.width = cell.max_class.frame.size.width;
    
    Frame.origin.y = cell.genderValue.frame.origin.y +cell.genderValue.frame.size.height +8;
    
    cell.max_class.frame = Frame;
    
    [cell.max_class sizeToFit];
    
    Frame = cell.max_classValue.frame;
    
    Frame.size.width = cell.max_classValue.frame.size.width;
    
    Frame.origin.y = cell.genderValue.frame.origin.y +cell.genderValue.frame.size.height +8;
    
    cell.max_classValue.frame = Frame;
    
    [cell.max_classValue sizeToFit];
    
    Frame = cell.places.frame;
    
    Frame.size.width = cell.places.frame.size.width;
    
    Frame.origin.y = cell.max_classValue.frame.origin.y +cell.max_classValue.frame.size.height +8;
    
    cell.places.frame = Frame;
    
    [cell.places sizeToFit];
    
    Frame = cell.placesValue.frame;
    
    Frame.size.width = cell.placesValue.frame.size.width;
    
    Frame.origin.y = cell.max_classValue.frame.origin.y +cell.max_classValue.frame.size.height +8;
    
    cell.placesValue.frame = Frame;
    
    [cell.placesValue sizeToFit];
    
    Frame = cell.fee.frame;
    
    Frame.size.width = cell.fee.frame.size.width;
    
    Frame.origin.y = cell.placesValue.frame.origin.y +cell.placesValue.frame.size.height +8;
    
    cell.fee.frame = Frame;
    
    [cell.fee sizeToFit];
    
    Frame = cell.feeValue.frame;
    
    Frame.size.width = cell.feeValue.frame.size.width;
    
    Frame.origin.y = cell.placesValue.frame.origin.y +cell.placesValue.frame.size.height +8;
    
    cell.feeValue.frame = Frame;
    
    [cell.feeValue sizeToFit];
    
    Frame = cell.requestToEnrollBtn.frame;
    
    Frame.origin.y = cell.feeValue.frame.origin.y +cell.feeValue.frame.size.height +15;
    
    cell.requestToEnrollBtn.frame = Frame;
    
    Frame = cell.main_view.frame;
    
    Frame.size.height = cell.requestToEnrollBtn.frame.origin.y +cell.requestToEnrollBtn.frame.size.height +30;
    
    cell.main_view.frame = Frame;
    
    cell.scroll_view.frame = cell.main_view.frame;
    
    [cell.requestToEnrollBtn addTarget:self action:@selector(tapEnrolBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.requestToEnrollBtn.tag = indexPath.row;
    
    [cell.enquireBtn addTarget:self action:@selector(tapEnqueryBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.enquireBtn.tag = indexPath.row;
    
    cell.requestToEnrollBtn.layer.cornerRadius = 5.0f;
    cell.main_view.layer.cornerRadius = 5.0f;
    cell.main_view.layer.masksToBounds = YES;
    cell.enquireBtn.layer.cornerRadius = 5.0f;
    
    return cell;
}

//-(CGFloat)heightCalculate:(NSString *)calculateText{
//    
//    UILabel *calculateText_lbl = [[UILabel alloc] init];
//    
//    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
//    
//    [calculateText_lbl setNumberOfLines:0];
//    
//    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
//    
//    NSString *text = calculateText;
//    
//    NSLog(@"%@",calculateText);
//    
//    CGSize constraint = CGSizeMake(cell.age_groupValue.frame.size.width - (1.0f * 2), FLT_MAX);
//    
//    UIFont *font;
//    
//    UIStoryboard *storyboard;
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        
//        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
//        
//        font = [UIFont systemFontOfSize:19];
//        
//    } else {
//        
//        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
//        
//        font = [UIFont systemFontOfSize:17];
//        
//    }
//    
//    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
//                                   attributes:@{NSFontAttributeName:font} context:nil];
//    
//    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
//    
//    [calculateText_lbl setFrame:CGRectMake(10, 74, 300 ,size.height+5)];
//    
//    [calculateText_lbl sizeToFit];
//    
//    CGFloat height_lbl = size.height;
//    
//    return (height_lbl + 10);
//}

-(void)tapEnrolBtn:(UIButton *)sender{
    
    NSDictionary *sesionDict = [[sessionArray valueForKey:@"event_info"] valueForKey:@"EventListing"];
    
    NSDictionary *age_groupDict = [[sessionArray valueForKey:@"age_title"] objectAtIndex:sender.tag];
    
    NSDictionary *course_sessionDict = [[sessionArray valueForKey:@"event_sessions"] objectAtIndex:sender.tag];
    
    NSDictionary *suitableDict = [[sessionArray valueForKey:@"suitable_for"] objectAtIndex:sender.tag];
    
    NSMutableDictionary *sessionData_dict = [[NSMutableDictionary alloc] init];
    
    [sessionData_dict setObject:sesionDict forKey:@"sesion"];
    
    [sessionData_dict setObject:age_groupDict forKey:@"age_group"];
    
    [sessionData_dict setObject:course_sessionDict forKey:@"course_session"];
    
    [sessionData_dict setObject:suitableDict forKey:@"suitable"];
    
    NSLog(@"%@", sessionData_dict);
    
    [[NSUserDefaults standardUserDefaults] setValue:sessionData_dict forKey:@"sessionDetail"];
    
//    NSDictionary *dict= @{@"type" : @"Event", @"id":[[[sessionArray valueForKey:@"course_sessions"] valueForKey:@"EventSession"] valueForKey:@"event_id"], @"session_id" : [[[sessionArray valueForKey:@"course_sessions"] valueForKey:@"EventSession"] valueForKey:@"id"]};
    
//    NSDictionary *dict= @{@"type" : @"Event", @"id":[[[[sessionArray valueForKey:@"event_info"] valueForKey:@"Sessions"] objectAtIndex:sender.tag] valueForKey:@"event_id"], @"session_id" : [[[[sessionArray valueForKey:@"event_info"] valueForKey:@"Sessions"] objectAtIndex:sender.tag] valueForKey:@"id"]};
//
//    
//    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"enrollmentData"];
//    
//    UIStoryboard *storyboard = self.storyboard;
//    
//    enrolVC = [storyboard instantiateViewControllerWithIdentifier:@"enrollmentVC"];
//    
//    [self.navigationController pushViewController:enrolVC animated:YES];
    
    [self performSegueWithIdentifier:@"ViewMoreSession" sender:self];
    


}
-(void)tapEnqueryBtn:(UIButton *)sender{
    
    sendMsgView = [[SendMessageView alloc] init];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPad" owner:self options:nil] objectAtIndex:0];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPhone" owner:self options:nil] objectAtIndex:0];
    }
    
    sendMsgView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+80);
    // [[NSUserDefaults standardUserDefaults] setObject:cousreDetailArray forKey:@"CourseDetail"];
    //NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"CourseDetail"]);
    
    NSString *listing_name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"event_name"];
    
    listing_name = [@"[Enquiry] " stringByAppendingString:listing_name];
    
    NSString *educator_name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"name_educator"];
    
    NSString *name = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]valueForKey:@"event_info"]  valueForKey:@"Member"]valueForKey:@"first_name"];
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@", %@", educator_name]];
    
    sendMsgView.to_textField.text = name;
    
    [[NSUserDefaults standardUserDefaults] setValue:[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]valueForKey:@"event_info"]  valueForKey:@"Member"]valueForKey:@"email"] forKey:@"enquir_to"];
    
    sendMsgView.subject.text = listing_name;
    
    sendMsgView.frame = self.view.frame;
    
    sendMsgView.view_frame = self.view.frame;
    
    [self.view addSubview:sendMsgView];

    
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

@end

