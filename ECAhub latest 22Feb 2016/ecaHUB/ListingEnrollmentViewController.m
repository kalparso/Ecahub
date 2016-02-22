//
//  ListingEnrollmentViewController.m
//  ecaHUB
//
//  Created by promatics on 5/21/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "ListingEnrollmentViewController.h"
#import "ListingEnrollmentTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "SendMessageView.h"
#import "ViewMemberDetailViewController.h"
#import "Cancel_ChangeEnrollView.h"
#import "Validation.h"
#import "DontApproveView.h"

@interface ListingEnrollmentViewController (){
    
    WebServiceConnection *enrollConn,*cancelConn, *approveEnrollConn, *changeEnrollConn, *getSessionConn,*selectDayConn, *dontApproveConn, *deleteConn;
    
    Indicator *indicator;
    
    SendMessageView * sendMsgView;
    
    Validation *validationObj;
    
    Cancel_ChangeEnrollView *cancel_ChangeEnrollView;
    
    DontApproveView *dontApproveView;
    
    ListingEnrollmentTableViewCell *cell;
    
    ViewMemberDetailViewController *viewMemberVC;
    
    DateConversion *dateconversion;
    
    NSArray  *sessionsArray;
    
    NSString *type, *dateStr, *list_session, *changeSession_id, *lesson_timeId;
    
    NSDictionary *memberDetail;
    
    NSMutableArray *listingEnrolArray, *lesson_timeArray;
    
    CGFloat x, y, view_x;
    
    BOOL isSession, tapSession;
    
    int blink;
    
    NSTimer *aTimer;
    
    UIView *actionView;
    
    CGFloat lblWidth, valueWidth;
    
    NSMutableArray *popupArary;
    
    NSMutableDictionary *popupDict;
    
    UIBarButtonItem *filterBarButton, *resetBarButton;
    
    UIView *mainfilterview;
    
    UIButton *subfilterButton;
    
    UITextField *filterTextField;
    
    BOOL isfilter;
    
    NSString *filter_type, *filter_val, *listing_type, *status_selected;
    
    NSInteger page_no, totalPage;
    
    CGFloat lastContentOffset;
    
    BOOL isScrollUp, isNextPage,isLodin;
}

@end

@implementation ListingEnrollmentViewController
@synthesize listEnroll_tableview,listingenroll_lbl;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isSession = NO;
    
    tapSession = NO;
    
    isfilter = NO;
    
    validationObj = [Validation validationManager];
    
    selectDayConn = [WebServiceConnection connectionManager];
    
    dontApproveConn = [WebServiceConnection connectionManager];
    
    deleteConn = [WebServiceConnection connectionManager];
    
    popupArary = [[NSMutableArray alloc]init];
    
    popupDict = [[NSMutableDictionary alloc]init];

    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        x = 141.0f;
        
        y = 55;
        
        view_x = 17.0f;
   
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        x = 15.0f;
        
        y = 20;
        
        view_x = 10.0f;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        lblWidth = 196;
        
        valueWidth = 450;
        
    } else {
        
        lblWidth =112;
        
        valueWidth = 160;
    }
    
    CGRect frame = listingenroll_lbl.frame;
    
    frame.origin.y = 100;
    
    listingenroll_lbl.frame = frame;
    
    dateconversion = [DateConversion dateConversionManager];
    
    enrollConn = [WebServiceConnection connectionManager];
    
    changeEnrollConn = [WebServiceConnection connectionManager];
    
    getSessionConn = [WebServiceConnection connectionManager];
    
    approveEnrollConn = [WebServiceConnection connectionManager];
    
    cancelConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    listingenroll_lbl.hidden = YES;
    
    frame = listEnroll_tableview.frame;
    
    frame.origin.y = 67;
    
    frame.size.height = self.view.frame.size.height - 105;
    
    listEnroll_tableview.frame = frame;
    
    status_selected = @"";
    
    page_no = 1;
    
    [self filterview];
    
    [self fetchWebData:page_no];
}

-(void)filterview{
    
    UIButton *barbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [barbtn addTarget:self action:@selector(tap_selectFiletrBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [barbtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    
    filterBarButton =[[UIBarButtonItem alloc]initWithCustomView:barbtn];
    
    //filterBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(tap_selectFiletrBtn:)];
    
    UIButton *barresetbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [barresetbtn addTarget:self action:@selector(tap_resetBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [barresetbtn setImage:[UIImage imageNamed:@"reset_icon"] forState:UIControlStateNormal];
    
    resetBarButton =[[UIBarButtonItem alloc]initWithCustomView:barresetbtn];
    
    
    //        resetBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reset_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(tap_resetBtn:)];
    
    self.navigationItem.rightBarButtonItem = filterBarButton;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        mainfilterview = [[UIView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width,45)];
        
    } else {
        
        mainfilterview = [[UIView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width,30)];
    }
    
    mainfilterview.backgroundColor = [UIColor clearColor];
    
    mainfilterview.hidden = YES;
    
    [self.view addSubview:mainfilterview];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        subfilterButton  = [[UIButton alloc]initWithFrame:CGRectMake(5, 0,self.view.frame.size.width-10,45)];
        
        [subfilterButton setFont:[UIFont systemFontOfSize:19.0f]];
        
    } else {
        
        subfilterButton  = [[UIButton alloc]initWithFrame:CGRectMake(5, 0,self.view.frame.size.width-10,30)];
        
        [subfilterButton setFont:[UIFont systemFontOfSize:17.0f]];
    }
    
    subfilterButton.backgroundColor = [UIColor whiteColor];
    
    [subfilterButton setTitle:@"Select" forState:UIControlStateNormal];
    
    [subfilterButton setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    subfilterButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    subfilterButton.layer.borderWidth = 1.0f;
    
    subfilterButton.layer.cornerRadius = 5.0f;
    
    [mainfilterview addSubview:subfilterButton];
    
    [subfilterButton addTarget:self action:@selector(tap_subfilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    subfilterButton.hidden = YES;
    
    UIView *paddingView;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        filterTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0,self.view.frame.size.width-10,45)];
        
        [filterTextField setFont:[UIFont systemFontOfSize:19.0f]];
        
        paddingView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 45)];
        
    } else {
        
        filterTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0,self.view.frame.size.width-10,30)];
        
        [filterTextField setFont:[UIFont systemFontOfSize:17.0f]];
        
        paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
    }
    
    self->filterTextField.delegate = self;
    
    filterTextField.backgroundColor = [UIColor whiteColor];
    
    filterTextField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    filterTextField.layer.borderWidth = 1.0f;
    
    filterTextField.layer.cornerRadius = 5.0f;
    
    [filterTextField setReturnKeyType:UIReturnKeySearch];
    
    [mainfilterview addSubview:filterTextField];
    
    filterTextField.leftView = paddingView;
    
    filterTextField.leftViewMode = UITextFieldViewModeAlways;
    
    filterTextField.hidden = YES;
    
}

-(void)tap_selectFiletrBtn:(UIButton *)sender{
    
    UIActionSheet *filetr_actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Type",@"Status Label",@"Enrolled By",@"Reference", nil];
    
    filetr_actionsheet.tag = 1;
    
    [filetr_actionsheet showFromBarButtonItem:filterBarButton animated:YES];
}

-(void)tap_subfilterBtn:(UIButton *)sender{
    
    UIActionSheet *subfiltersheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Please Accept",@"Waiting Payment",@"Confirmed / Payment Received",@"Declined",@"Requested for Cancel",@"Cancelled by student",@"Cancelled Enrollment", nil];
    
    subfiltersheet.tag = 2;
    
    [subfiltersheet showInView:self.view];
    
}

-(void)tap_resetBtn:(UIButton *)sender{
    
    listingenroll_lbl.hidden = YES;
    
    [filterTextField resignFirstResponder];
    
    CGRect frame = listEnroll_tableview.frame;
    
    frame.origin.y = 67;
    
    frame.size.height = self.view.frame.size.height - 115;
    
    listEnroll_tableview.frame = frame;
    
    isfilter = NO;
    
    listEnroll_tableview.hidden = NO;
    
    [subfilterButton setTitle:@"Select" forState:UIControlStateNormal];
    
    [subfilterButton setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    mainfilterview.hidden = YES;
    
    subfilterButton.hidden = YES;
    
    filterTextField.hidden = YES;
    
    filterTextField.text = @"";
    
    filter_type = @"";
    
    filter_val = @"";
    
    listing_type = @"";
    
    [self fetchWebData:1];
    
}

#pragma mark - UIActionsheet Delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag ==1) {
        
        if (buttonIndex == 0) {
            
            UIActionSheet *typesheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Course",@"Event",@"Lesson", nil];
            
            typesheet.tag = 3;
            
            [typesheet showFromBarButtonItem:filterBarButton animated:YES];
            
            filter_type = @"1";
        }
        
        else if (buttonIndex == 1){
            
            filter_type = @"4";
            
            listing_type = @"";
            
            subfilterButton.hidden = NO;
            
            filterTextField.hidden = YES;
            
            mainfilterview.hidden = NO;
            
            [subfilterButton setTitle:@"Select Status" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
            
            CGRect frame = listEnroll_tableview.frame;
            
            frame.origin.y = mainfilterview.frame.origin.y + mainfilterview.frame.size.height +10;
            
            frame.size.height = self.view.frame.size.height -  (mainfilterview.frame.origin.y + mainfilterview.frame.size.height +50);;
            
            listEnroll_tableview.frame = frame;
            
            
        }
        else if (buttonIndex ==2){
            
            filter_type = @"2";
            
            subfilterButton.hidden = YES;
            
            filterTextField.hidden = NO;
            
            mainfilterview.hidden = NO;
            
            filterTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Student Name" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
            
            CGRect frame = listEnroll_tableview.frame;
            
            frame.origin.y = mainfilterview.frame.origin.y + mainfilterview.frame.size.height +10;
            
            frame.size.height = self.view.frame.size.height -  (mainfilterview.frame.origin.y + mainfilterview.frame.size.height +50);
            
            listEnroll_tableview.frame = frame;
            
            
        }
        else if (buttonIndex ==3){
            
            filter_type = @"3";
            
            subfilterButton.hidden = YES;
            
            filterTextField.hidden = NO;
            
            mainfilterview.hidden = NO;
            
            filterTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Enrollment Reference" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(placeholder_text_color_hexcode)}];
            
            CGRect frame = listEnroll_tableview.frame;
            
            frame.origin.y = mainfilterview.frame.origin.y + mainfilterview.frame.size.height +10;
            
            frame.size.height = self.view.frame.size.height -  (mainfilterview.frame.origin.y + mainfilterview.frame.size.height +50);;
            
            listEnroll_tableview.frame = frame;
            
            
        }
    }
    
    //"Waiting",@"Accepted / Please Pay",@"Confirmed",@"Requested to Cancel",@"Cancelled by educator", nil];
    else if (actionSheet.tag ==2){
        
        filter_val = @"";
        
        if (buttonIndex ==0) {
            
            status_selected =@"1";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Please Accept" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchWebData:1];
            
            
        }
        else if (buttonIndex ==1){
            
            status_selected =@"2";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Waiting Payment" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchWebData:1];
            
        }
        else if (buttonIndex ==2){
            
            status_selected =@"3";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Confirmed / Payment Received" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchWebData:1];
            
            
            
        }
        else if (buttonIndex ==3){
            
            status_selected =@"6";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Declined" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchWebData:1];
            
            
            
            
        }
        else if (buttonIndex==4){
            
            status_selected =@"7";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Requested for Cancel" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchWebData:1];
            
            
        }
        else if (buttonIndex==4){
            
            status_selected =@"8";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Cancelled by student" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchWebData:1];
            
            
        }
        else if (buttonIndex==4){
            
            status_selected =@"9";
            
            isfilter = YES;
            
            [subfilterButton setTitle:@"Cancelled Enrollment" forState:UIControlStateNormal];
            
            [subfilterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            [self fetchWebData:1];
            
            
        }
    }
    else if (actionSheet.tag == 3){
        
        if (buttonIndex == 0) {
            
            listing_type =@"1";
            
            filterTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Course Name" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
            
        }
        else if (buttonIndex ==1){
            
            listing_type =@"2";
            
            filterTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Event Name" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
        }
        else{
            
            listing_type =@"3";
            
            filterTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Enter Lesson Name" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
            
        }
        
        subfilterButton.hidden = YES;
        
        filterTextField.hidden = NO;
        
        mainfilterview.hidden = NO;
        
        CGRect frame = listEnroll_tableview.frame;
        
        frame.origin.y = mainfilterview.frame.origin.y + mainfilterview.frame.size.height +10;
        
        frame.size.height = self.view.frame.size.height -  (mainfilterview.frame.origin.y + mainfilterview.frame.size.height +50);
        
        listEnroll_tableview.frame = frame;
    }

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if (![filter_type isEqualToString:@""]) {
        
        filter_val = filterTextField.text;
    }
    
    isfilter = YES;
    
    [self fetchWebData:1];
    
    return true;
    
}

-(void)fetchWebData:(int)current_page {
    
    [self.view addSubview:indicator];
    
    NSDictionary *Dict;
    
    if (isfilter) {
       
    Dict = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],@"status_selected":status_selected,@"filter_type":filter_type,@"filter_val":filter_val,@"listing_type":listing_type};
       
    }
    else{
    
    Dict = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
        
    }
    
    NSString *service = [@"enrollment_booking/page:"stringByAppendingString:[NSString stringWithFormat:@"%d",current_page]];
    
    [enrollConn startConnectionWithString:service HttpMethodType:Post_Type HttpBodyType:Dict Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([enrollConn responseCode]== 1) {
            
            NSLog(@"%@",receivedData);
            
            if ([[receivedData valueForKey:@"code"]integerValue] == 1) {
                
                isLodin = YES;
                
                totalPage = [[receivedData valueForKey:@"total_page"] integerValue];
                
                if (current_page == 1) {
                    
                    listingEnrolArray = [[NSMutableArray alloc]init];
                }
                popupArary = [[NSMutableArray alloc]init];
                
                [listingEnrolArray addObjectsFromArray:[receivedData valueForKey:@"enroll_data"]];
                
                for (int i =0; i<listingEnrolArray.count; i++) {
                    
                    [popupArary addObject:[[[listingEnrolArray objectAtIndex:i] valueForKey:@"CreateEnrollment"] valueForKey:@"status"]];
                }
                
                
                [listEnroll_tableview reloadData];
                
                listEnroll_tableview.hidden = NO;
                
                listingenroll_lbl.hidden = YES;
                
                if (isfilter) {
                    
                    self.navigationItem.rightBarButtonItems = @[resetBarButton,filterBarButton];
                }
                else{
                    
                    self.navigationItem.rightBarButtonItems = nil;
                    
                    self.navigationItem.rightBarButtonItem = filterBarButton;
                }
                
                
            }else{
                
                isLodin = YES;
                
                listEnroll_tableview.hidden = YES;
                
                listingenroll_lbl.hidden = NO;
                
                if (isfilter) {
                    
                    self.navigationItem.rightBarButtonItems = @[resetBarButton,filterBarButton];
                }
                                //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"You don't have any enrollment as yet." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                //
                //                [alert show];
            }
        }
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat Height = cell.main_view.frame.origin.y + cell.main_view.frame.size.height+20;
    
    NSLog(@"%f",Height);
    
    return cell.main_view.frame.origin.y + cell.main_view.frame.size.height+10;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [listingEnrolArray count];
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // if(isServiceCall){
    
    if( (indexPath.row >= (int)(listingEnrolArray.count - 5)) && (isScrollUp)){
        
        isNextPage = YES;
        
    }else{
        
        isNextPage = NO;
    }
    
    if(isNextPage && isLodin){
        
        if (page_no < totalPage) {
            
            [self loadNextPage];
        }
        
    }
    
    //}
}

-(void)loadNextPage{
    
    page_no = page_no + 1;
    
    [self fetchWebData:page_no];
    
    isLodin = NO;
    
    isNextPage = NO;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(lastContentOffset > scrollView.contentOffset.y){
        
        isScrollUp = NO;
        
    }else{
        
        isScrollUp = YES;
    }
    
    lastContentOffset = scrollView.contentOffset.y;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // aTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(aTime) userInfo:nil repeats:YES];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"ListingEnroll" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil){
        
        cell = [[ListingEnrollmentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListingEnroll"];
    }
    
    int count = 6;

    NSString *typeStr = [[[listingEnrolArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }
    
    dateStr = [[[listingEnrolArray objectAtIndex:indexPath.row]valueForKey:listing] valueForKey:@"start_date"];
    
    if ([dateStr isEqual:@""]) {
        
    }
    else{
    
        dateStr = [dateconversion convertDate:dateStr];
        
    }
    
    cell.from_value.text = dateStr;
    
    CGRect frame = cell.main_view.frame;
    frame.origin.x = view_x;
    frame.size.width = cell.frame.size.width - (view_x *2);
    //frame.origin.x = 20;
    cell.main_view.frame = frame;
    
    dateStr = [[[listingEnrolArray objectAtIndex:indexPath.row]valueForKey:listing]valueForKey:@"finish_date"];
    
    if ([dateStr isEqual:@""]) {
        
    }
    else{
        
        dateStr = [dateconversion convertDate:dateStr];
        
    }
    
    cell.to_value.text = dateStr;
    
    //cell.details_lbl.text = list_type;
    //Cartoon Creation Workshop
   // [Session Name] - Intermediate Group
    
    cell.listingName_lbl.text = [[NSString stringWithFormat:@"[%@] ",list_type]stringByAppendingString:[[[listingEnrolArray objectAtIndex:indexPath.row] valueForKey:listing_name] valueForKey:list_name]];
    
    cell.sessionName_lbl.text = [@"[Session] "stringByAppendingString:[[[listingEnrolArray objectAtIndex:indexPath.row] valueForKey:listing] valueForKey:@"session_name"]];
    
   // cell.sess = [[[listingEnrolArray objectAtIndex:indexPath.row]valueForKey:listing]valueForKey:@"session_name"];
    
    cell.main_view.layer.cornerRadius = 5.0f;
    cell.main_view.layer.masksToBounds = YES;
    
//    NSString *venu_unit = [[[listingEnrolArray objectAtIndex:indexPath.row]valueForKey:listing]  valueForKey:@"venu_unit"];
//    
//    if ([venu_unit isEqualToString:@""]) {
//        
//        venu_unit = @"";
//    }
//    else{
//        
//        venu_unit = [venu_unit stringByAppendingString:@", "];
//    }
//    
//    NSString *venu_building_name = [[[listingEnrolArray objectAtIndex: indexPath.row] valueForKey:listing] valueForKey:@"venu_building_name"];
//    
//    if ([venu_building_name isEqualToString:@""]) {
//        
//        venu_building_name = @"";
//    }
//    else{
//        
//        venu_building_name = [venu_building_name stringByAppendingString:@", "];
//    }
    
    [cell.infoAcnBtn addTarget:nil action:@selector(tap_infotoolBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *venu_street = [[[listingEnrolArray objectAtIndex: indexPath.row] valueForKey:listing] valueForKey:@"venu_street"];
    
    if ([venu_street isEqualToString:@""]) {
        
        venu_street = @"";
    }
    else{
        
        venu_street = [venu_street stringByAppendingString:@", "];
    }
    
    NSString *venu_district = [[[listingEnrolArray objectAtIndex: indexPath.row] valueForKey:listing] valueForKey:@"venu_district"];
    
    if ([venu_district isEqualToString:@""]) {
        
        venu_district = @"";
    }
    else{
        
        venu_district = [venu_district stringByAppendingString:@", "];
    }
    
   // NSString *state_name = [[[[listingEnrolArray objectAtIndex: indexPath.row] valueForKey:listing]valueForKey:@"State"] valueForKey:@"state_name"];
    
    //if ([state_name isEqualToString:@""]) {
        
    //    state_name = @"";
   // }
    //else{
        
   //     state_name = [state_name stringByAppendingString:@", "];
  //  }
    
    NSString *city_name = [[[listingEnrolArray objectAtIndex: indexPath.row] valueForKey:@"data"] valueForKey:@"city_name"];
    
    if ([city_name isEqualToString:@""]) {
        
        city_name = @"";
    }
    else{
        
        city_name = [city_name stringByAppendingString:@", "];
    }
    
    NSString *state_name = [[[listingEnrolArray objectAtIndex: indexPath.row] valueForKey:@"data"] valueForKey:@"state_name"];
    
    if ([state_name isEqualToString:@""]) {
        
        state_name = @"";
    }
    else{
        
        state_name = [state_name stringByAppendingString:@", "];
    }
    
    NSString *country_name = [[[listingEnrolArray objectAtIndex: indexPath.row] valueForKey:@"data"] valueForKey:@"country_name"];
    
    if ([country_name isEqualToString:@""]) {
        
        country_name = @"";
    }
    else{
        
        country_name = [country_name stringByAppendingString:@""];
    }
    
    cell.venue_value.text =[[[[venu_street stringByAppendingString:venu_district]stringByAppendingString:city_name]stringByAppendingString:state_name]stringByAppendingString:country_name];
    
    NSString *name = [[[listingEnrolArray objectAtIndex:indexPath.row] valueForKey:@"Member"]valueForKey:@"first_name"];
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@" %@",[[[listingEnrolArray objectAtIndex:indexPath.row] valueForKey:@"Member"] valueForKey:@"last_name"]]];
    
    cell.enrollby_value.text = name;
    
    name = [[[listingEnrolArray objectAtIndex:indexPath.row] valueForKey:@"Family"]valueForKey:@"first_name"];
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@" %@",[[[listingEnrolArray objectAtIndex:indexPath.row] valueForKey:@"Family"] valueForKey:@"family_name"]]];

    cell.student_value.text = name;
    
    dateStr = [[[listingEnrolArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"booking_date"];
    
    dateStr = [dateconversion convertDate:dateStr];
    
    cell.enrollment_value.text = dateStr;
    
    NSString *status = [[[listingEnrolArray objectAtIndex:indexPath.row] valueForKey:@"CreateEnrollment"] valueForKey:@"status"];
    
    /*    payment_status '1'=>'Approve', '2'=>'Approval
     Pending','3'=>'Cancel Enrollment and booking','4'=>'Recurring
     payment cancel by user,'5'=>'Recuring payment cancel by paypal
     business account holder'
     */
    /*
     //calender
     1'=>'Waiting for acceptance',  '2'=>'Accept Enrollment/Booking  Request','3'=>'Confirmed(Automatically after  payment)', '4'=>'Recurring payment cancel by user, '5'=>'Recuring  payment cancel by paypal business account holder','6'=>'Do not accept  Enrollment/Booking Request','7'=>Cancel By educator,'8'=>cancel  by student
     *///Smily
    
    if ([status isEqualToString:@"0"]) {
        
        
    } else if ([status isEqualToString:@"1"]) {
        
        cell.status_value.text = @"Please Accept";
        
    } else if ([status isEqualToString:@"2"]) {
        
        cell.status_value.text = @"Waiting Payment";
        
    } else if ([status isEqualToString:@"3"]) {
        
       cell.status_value.text = @"Confirmed / Payment Received";
        
    } else if ([status isEqualToString:@"4"]) {
        
        cell.status_value.text = @"";
        
    } else if ([status isEqualToString:@"5"]) {
        
        cell.status_value.text = @"";
        
    } else if ([status isEqualToString:@"6"]) {
        
        cell.status_value.text = @"Declined";
        
        count = count - 1;
        
    } else if ([status isEqualToString:@"8"]) {
        
        cell.status_value.text = @"Cancelled by student";
        
        cell.changeEnrol_bttn.hidden = YES;
        
        count = count -1;
        
    } else {
        
        cell.status_value.text = @"";
    }
    
    if ([status isEqualToString:@"7"]) {
        
        cell.cancelEnroll_bttn.hidden = YES;
        cell.changeEnrol_bttn.hidden = NO;
        cell.pending_bttn.hidden = YES;
        cell.approved_bttn.hidden = YES;
        
        count = count -3;
        
        cell.status_value.text = @"Requested for Cancel";
        
    }if ([status isEqualToString:@"9"]) {
        
        cell.status_value.text = @"Cancelled Enrollment";
        
    }
    else {
        
        cell.cancelEnroll_bttn.hidden = NO;
        cell.changeEnrol_bttn.hidden = NO;
    }
    
    cell.actionImgView.image = [UIImage imageNamed:@"red_circle"];
    
//    cell.cancelEnroll_bttn.hidden = YES;
    
    cell.reference_value.text = [[[listingEnrolArray objectAtIndex:indexPath.row]valueForKey:@"CreateEnrollment"]valueForKey:@"reference_code"];
    
//    [cell.message_bttn addTarget:self action:@selector(tapMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [cell.approved_bttn addTarget:self action:@selector(tapApprovedBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [cell.pending_bttn addTarget:self action:@selector(tapPendingBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [cell.changeEnrol_bttn addTarget:self action:@selector(tapChangeEnrollBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [cell.cancelEnroll_bttn addTarget:self action:@selector(tapCancelEnrollBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.actionBtn addTarget:self action:@selector(tap_actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.actionBtn.tag = indexPath.row;
    
    int total_width = cell.main_view.frame.size.width;
    
    int btn_width = cell.viewBtn.frame.size.width;
    
    int x_btn = (total_width - (count * btn_width))/(count+1);
    
    CGRect frame_btn = cell.viewBtn.frame;
    frame_btn.origin.x = x_btn;
    [cell.viewBtn setFrame:frame_btn];
    
    frame_btn = cell.message_bttn.frame;
    frame_btn.origin.x = cell.viewBtn.frame.origin.x + btn_width + x_btn;
    [cell.message_bttn setFrame:frame_btn];
    
    if ([status isEqualToString:@"2"]) {
        
        CGRect frame_btn = cell.pending_bttn.frame;
        frame_btn.origin.x = cell.message_bttn.frame.origin.x + btn_width + x_btn;
        [cell.pending_bttn setFrame:frame_btn];
        
        frame_btn = cell.cancelEnroll_bttn.frame;
        frame_btn.origin.x = cell.pending_bttn.frame.origin.x + btn_width + x_btn;
        [cell.cancelEnroll_bttn setFrame:frame_btn];
        
        frame_btn = cell.changeEnrol_bttn.frame;
        frame_btn.origin.x = cell.cancelEnroll_bttn.frame.origin.x + btn_width + x_btn;
        [cell.changeEnrol_bttn setFrame:frame_btn];
    }
    
    if ([status isEqualToString:@"1"] || [status isEqualToString:@"3"]) {
        
        CGRect frame_btn = cell.approved_bttn.frame;
        frame_btn.origin.x = cell.message_bttn.frame.origin.x + btn_width + x_btn;
        [cell.approved_bttn setFrame:frame_btn];
        
        frame_btn = cell.pending_bttn.frame;
        frame_btn.origin.x = cell.approved_bttn.frame.origin.x + btn_width + x_btn;
        [cell.pending_bttn setFrame:frame_btn];
        
        frame_btn = cell.cancelEnroll_bttn.frame;
        frame_btn.origin.x = cell.pending_bttn.frame.origin.x + btn_width + x_btn;
        [cell.cancelEnroll_bttn setFrame:frame_btn];
        
        frame_btn = cell.changeEnrol_bttn.frame;
        frame_btn.origin.x = cell.cancelEnroll_bttn.frame.origin.x + btn_width + x_btn;
        [cell.changeEnrol_bttn setFrame:frame_btn];
    }
    
    if ([status isEqualToString:@"6"]) {
        
        CGRect frame_btn = cell.approved_bttn.frame;
        frame_btn.origin.x = cell.message_bttn.frame.origin.x + btn_width + x_btn;
        [cell.approved_bttn setFrame:frame_btn];
        
//        frame_btn = cell.pending_bttn.frame;
//        frame_btn.origin.x = cell.approved_bttn.frame.origin.x + btn_width + x_btn;
//        [cell.pending_bttn setFrame:frame_btn];
        
        frame_btn = cell.cancelEnroll_bttn.frame;
        frame_btn.origin.x = cell.approved_bttn.frame.origin.x + btn_width + x_btn;
        [cell.cancelEnroll_bttn setFrame:frame_btn];
        
        frame_btn = cell.changeEnrol_bttn.frame;
        frame_btn.origin.x = cell.cancelEnroll_bttn.frame.origin.x + btn_width + x_btn;
        [cell.changeEnrol_bttn setFrame:frame_btn];
    }
    
    if ([status isEqualToString:@"7"]) {
        
        CGRect frame_btn = cell.changeEnrol_bttn.frame;
        frame_btn.origin.x = cell.message_bttn.frame.origin.x + btn_width + x_btn;
        [cell.changeEnrol_bttn setFrame:frame_btn];
    }
    
    
    
    
    
    cell.message_bttn.tag = indexPath.row;
    
    cell.approved_bttn.tag = indexPath.row;
    
    cell.pending_bttn.tag = indexPath.row;
    
    cell.changeEnrol_bttn.tag = indexPath.row;
    
    cell.cancelEnroll_bttn.tag = indexPath.row;
    
    cell.viewBtn.tag = indexPath.row;
    
   // [cell.viewBtn addTarget:self action:@selector(tapViewMember:) forControlEvents:UIControlEventTouchUpInside];
    
    frame = cell.listingName_lbl.frame;
    
    frame.origin.y = 5;
    
    frame.size.width = self.view.frame.size.width - 60;
    
    cell.listingName_lbl.frame = frame;
    
    frame = cell.sessionName_lbl.frame;
    
    frame.origin.y = cell.listingName_lbl.frame.origin.y + cell.listingName_lbl.frame.size.height+5;
    
    frame.size.width = self.view.frame.size.width-60;
    
    cell.sessionName_lbl.frame = frame;
    
    [cell.sessionName_lbl sizeToFit];
    
    frame = cell.From_lbl.frame;
    
    frame.origin.y =cell.sessionName_lbl.frame.origin.y + cell.sessionName_lbl.frame.size.height +5;
    
    frame.size.width = lblWidth;
    
    cell.From_lbl.frame =frame;
    
    [cell.From_lbl sizeToFit];
    
    frame = cell.from_value.frame;
    
    frame.origin.y = cell.sessionName_lbl.frame.origin.y + cell.sessionName_lbl.frame.size.height +5;
    
    frame.size.width = valueWidth;
    
    cell.from_value.frame = frame;
    
    [cell.from_value sizeToFit];
    
    frame= cell.to_lbl.frame;
    
    if (cell.From_lbl.frame.size.height > cell.from_value.frame.size.height) {
        
    frame.origin.y = cell.From_lbl.frame.origin.y +cell.From_lbl.frame.size.height+5;
        
    }
    else{
        
    frame.origin.y = cell.from_value.frame.origin.y +cell.from_value.frame.size.height+5;
        
    }
    
    frame.size.width = lblWidth;
    
    cell.to_lbl.frame = frame;
    
    [cell.to_lbl sizeToFit];
    
    frame = cell.to_value.frame;
    
    frame.origin.y = cell.to_lbl.frame.origin.y;
    
    frame.size.width = valueWidth;
    
    cell.to_value.frame = frame;
    
    [cell.to_value sizeToFit];
    
    frame = cell.venue_lbl.frame;
    
    if (cell.to_lbl.frame.size.height > cell.to_value.frame.size.height) {
        
        frame.origin.y = cell.to_lbl.frame.origin.y +cell.to_lbl.frame.size.height+5;
        
    }
    else{
        
        frame.origin.y = cell.to_value.frame.origin.y +cell.to_value.frame.size.height+5;
    }
    
    frame.size.width = lblWidth;
    
    cell.venue_lbl.frame = frame;
    
    [cell.venue_lbl sizeToFit];
    
    frame = cell.venue_value.frame;
    
    frame.origin.y = cell.venue_lbl.frame.origin.y;
    
    frame.size.width = valueWidth;
    
    cell.venue_value.frame = frame;
    
    [cell.venue_value sizeToFit];
    
    frame = cell.enrolBy_lbl.frame;
    
    if (cell.venue_lbl.frame.size.height > cell.venue_value.frame.size.height) {
        
        frame.origin.y = cell.venue_lbl.frame.origin.y +cell.venue_lbl.frame.size.height+5;
    }
    else{
        
        frame.origin.y = cell.venue_value.frame.origin.y +cell.venue_value.frame.size.height+5;
    }
    
    frame.size.width = lblWidth;
    
    cell.enrolBy_lbl.frame = frame;
    
    [cell.enrolBy_lbl sizeToFit];
    
    frame = cell.enrollby_value.frame;
    
    frame.origin.y = cell.enrolBy_lbl.frame.origin.y;
    
    frame.size.width = valueWidth;
    
    cell.enrollby_value.frame = frame;
    
    [cell.enrollby_value sizeToFit];
    
    frame = cell.student_lbl.frame;
    
    if (cell.enrolBy_lbl.frame.size.height > cell.enrollby_value.frame.size.height) {
        
        frame.origin.y = cell.enrolBy_lbl.frame.origin.y +cell.enrolBy_lbl.frame.size.height+5;
    }
    else{
        
        frame.origin.y = cell.enrollby_value.frame.origin.y +cell.enrollby_value.frame.size.height+5;
    }
    
    frame.size.width = lblWidth;
    
    cell.student_lbl.frame = frame;
    
    [cell.student_lbl sizeToFit];
    
    frame = cell.student_value.frame;
    
    frame.origin.y = cell.student_lbl.frame.origin.y;
    
    frame.size.width = valueWidth;
    
    cell.student_value.frame = frame;
    
    [cell.student_value sizeToFit];
    
    frame = cell.enrolBookingDate_lbl.frame;
    
    if (cell.student_lbl.frame.size.height > cell.student_value.frame.size.height) {
        
        frame.origin.y = cell.student_lbl.frame.origin.y +cell.student_lbl.frame.size.height+5;
    }
    else{
        
        frame.origin.y = cell.student_value.frame.origin.y +cell.student_value.frame.size.height+5;
    }
    
    frame.size.width = lblWidth;
    
    cell.enrolBookingDate_lbl.frame = frame;
    
    [cell.enrolBookingDate_lbl sizeToFit];
    
    frame = cell.enrollment_value.frame;
    
    frame.origin.y = cell.enrolBookingDate_lbl.frame.origin.y;
    
    frame.size.width = valueWidth;
    
    cell.enrollment_value.frame = frame;
    
    [cell.enrollment_value sizeToFit];
    
    frame = cell.reference_lbl.frame;
    
    if (cell.enrolBookingDate_lbl.frame.size.height > cell.enrollment_value.frame.size.height) {
        
        frame.origin.y = cell.enrolBookingDate_lbl.frame.origin.y +cell.enrolBookingDate_lbl.frame.size.height+5;
    }
    else{
    
        frame.origin.y = cell.enrollment_value.frame.origin.y +cell.enrollment_value.frame.size.height+5;
    }
    
    frame.size.width =lblWidth;
    
    cell.reference_lbl.frame = frame;
    
    [cell.reference_lbl sizeToFit];
    
    frame = cell.reference_value.frame;
    
    frame.origin.y = cell.reference_lbl.frame.origin.y;
    
    frame.size.width = valueWidth;
    
    cell.reference_value.frame = frame;
    
    [cell.reference_value sizeToFit];
    
    frame = cell.status_lbl.frame;
    
    if (cell.reference_lbl.frame.size.height > cell.reference_value.frame.size.height) {
        
        frame.origin.y = cell.reference_lbl.frame.origin.y +cell.reference_lbl.frame.size.height+5;
        
    }
    else{
        
        frame.origin.y = cell.reference_value.frame.origin.y +cell.reference_value.frame.size.height+5;
    }
    
    frame.size.width = lblWidth;
    
    cell.status_lbl.frame = frame;
    
    [cell.status_lbl sizeToFit];
    
    frame = cell.status_value.frame;
    
    frame.origin.y = cell.status_lbl.frame.origin.y;
    
    frame.size.width = valueWidth;
    
    cell.status_value.frame = frame;
    
    [cell.status_value sizeToFit];
    
    frame = cell.infoimgBtn.frame;
    
    frame.origin.y = cell.status_lbl.frame.origin.y + 1.5;
    
    cell.infoimgBtn.frame = frame;
    
    frame = cell.infoAcnBtn.frame;
    
    frame.origin.y = cell.status_lbl.frame.origin.y ;
    
    cell.infoAcnBtn.frame = frame;
    
    frame = cell.main_view.frame;
    
    frame.origin.y = 0;
    
    if (cell.status_lbl.frame.size.height > cell.status_value.frame.size.height) {
        
        frame.size.height = cell.status_lbl.frame.origin.y + cell.status_lbl.frame.size.height+10;
    }
    else{
        
       frame.size.height = cell.status_value.frame.origin.y + cell.status_value.frame.size.height+10;
    }
    
    cell.main_view.frame = frame;
    
    frame = cell.actionBtn.frame;
    
    frame.origin.y = 10;
    
    cell.actionBtn.frame = frame;
    
    return cell;
    
}

-(void)aTime
{
    
    NSLog(@"....Update Function Called....");
    
    if (blink ==0) {
        
        blink = 1;
        
        cell.actionImgView.image = [UIImage imageNamed:@"red_circle"];
    }
    else{
        
        blink = 0;
        
        cell.actionImgView.image = [UIImage imageNamed:@""];
        
        
    }
  
    
}


-(CGFloat)heightCalculate:(NSString *)calculateText:(UILabel *)lbl{
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(lbl.frame.size.width - (1.0f * 2), FLT_MAX);
    
    UIFont *font;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        font = [UIFont systemFontOfSize:19];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        font = [UIFont systemFontOfSize:17];
        
    }
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font} context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    [calculateText_lbl setFrame:CGRectMake(10, 74, 300 ,size.height+5)];
    
    [calculateText_lbl sizeToFit];
    
    CGFloat height_lbl = size.height;
    
    if (height_lbl> lbl.frame.size.height) {
       
        return (height_lbl);
        
    }
    
    else{
        
        return lbl.frame.size.height;
    }
    
    
}


-(void)tapViewMember:(UIButton *)sender{
    
    memberDetail = [listingEnrolArray objectAtIndex:sender.tag];
    
    [self performSegueWithIdentifier:@"viewMemberSegue" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"viewMemberSegue"]) {
        
        viewMemberVC = (ViewMemberDetailViewController *)[segue destinationViewController];
        
        viewMemberVC.memberDetail = memberDetail;
    }
}

-(void)tapMessageBtn:(UIButton *)sender {
    
    [actionView removeFromSuperview];
    
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
    
    sendMsgView.toMsg_btn.layer.borderWidth = 1.0f;
    
    sendMsgView.toMsg_btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.toMsg_btn.layer.cornerRadius = 5.0f;
    
    sendMsgView.toMsg_btn.userInteractionEnabled = NO;
    
    [sendMsgView.toMsg_btn setTitle:[[[[[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"first_name"]stringByAppendingString:@" "]stringByAppendingString:[[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"last_name"]]stringByAppendingString:@", "]forState:UIControlStateNormal];
    
    sendMsgView.to_textField.text = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"email"];
    
    sendMsgView.to_textField.hidden = YES;
    
    sendMsgView.subject.layer.borderWidth = 1.0f;
    
    sendMsgView.subject.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.subject.layer.cornerRadius = 5.0f;
    
    sendMsgView.message.layer.borderWidth = 1.0f;
    
    sendMsgView.message.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.message.layer.cornerRadius = 5.0f;
    
    sendMsgView.message.backgroundColor = [UIColor whiteColor];
    
    sendMsgView.frame = self.view.frame;
    
    sendMsgView.view_frame = self.view.frame;
    
    [self.view addSubview:sendMsgView];

}

-(void)tapApprovedBtn:(UIButton *)sender {
    
     [actionView removeFromSuperview];
    
    //enrollment_id,seller_name,seller_email  (seller name=> name of the member who confirm enrollment, seller_email=> email of the member who is confirming enrollment)
    
    NSString *enroll_id = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:@"CreateEnrollment"]valueForKey:@"id"];
    
    NSString *seller_email = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"EnrollmentOwner"] valueForKey:@"email"];
    
    NSString *seller_name = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"EnrollmentOwner"] valueForKey:@"first_name"];
    
    seller_name = [seller_name stringByAppendingString:@" "];
    
    seller_name = [seller_name stringByAppendingString:[[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"EnrollmentOwner"] valueForKey:@"last_name"]];

    NSDictionary *paramURL = @{@"enrollment_id":enroll_id, @"seller_name":seller_name, @"seller_email":seller_email};
    
    NSLog(@"%@", paramURL);
    
    [self.view addSubview:indicator];
    
    [approveEnrollConn startConnectionWithString:@"confirm_enroll" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        if ([approveEnrollConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            [self fetchWebData:1];
        }
    }];
}

-(void)tapPendingBtn:(UIButton *)sender{
    
     [actionView removeFromSuperview];
    
    dontApproveView = [[DontApproveView alloc] init];
    
    dontApproveView = [[[NSBundle mainBundle] loadNibNamed:@"DontApproveView" owner:self options:nil] objectAtIndex:0];
    
    dontApproveView.frame = self.view.frame;
    
    [dontApproveView.submit_btn addTarget:self action:@selector(tapSubmitPending:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dontApproveView];
}

-(void)tapSubmitPending:(UIButton *)sender {
    
     [actionView removeFromSuperview];

     //rejection_confirm   rejection_reason, enrollment_id
    
    [self.view addSubview:indicator];
    
    if ([dontApproveView.message_txtView.text isEqualToString:@"Please provide a rejection reason"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please enter message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        NSString *enroll_id = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:@"CreateEnrollment"]valueForKey:@"id"];
        
        NSDictionary *paramURL = @{@"rejection_reason":dontApproveView.message_txtView.text, @"enrollment_id":enroll_id};
        
        [dontApproveConn startConnectionWithString:@"rejection_confirm" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([dontApproveConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                [dontApproveView removeFromSuperview];
                
                [self fetchWebData:1];
            }
        }];
    }
}

-(void)tapChangeEnrollBtn:(UIButton *)sender{
    
    [actionView removeFromSuperview];
    
    NSString *typeStr = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }
    
    NSString *dateStart = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing] valueForKey:@"start_date"];
    
    dateStart = [dateconversion convertDate:dateStart];
    
    NSString *finish_date = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"finish_date"];
    
    finish_date = [dateconversion convertDate:finish_date];
    
    dateStart = [@"[Date] - " stringByAppendingString:dateStart];
    
    dateStart = [dateStart stringByAppendingString:@" to "];
    dateStart = [dateStart stringByAppendingString:finish_date];
    
    NSString *listName = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing_name]valueForKey:list_name];
    
    list_type = [@"[" stringByAppendingString:[NSString stringWithFormat:@"%@] - ",list_type]];
    
    listName = [list_type stringByAppendingString:listName];
    
    NSString *session_name = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"session_name"];
    
    // NSString *session_id = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"id"];
    
    session_name = [@"[Session Name] - " stringByAppendingString:session_name];
    
    NSString *name = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Member"]valueForKey:@"first_name"];
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@" %@",[[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"last_name"]]];
    
    NSString *s_name = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Family"]valueForKey:@"first_name"];
    
    s_name = [s_name stringByAppendingString:[NSString stringWithFormat:@" %@",[[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Family"] valueForKey:@"family_name"]]];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        cancel_ChangeEnrollView = [[Cancel_ChangeEnrollView alloc] init];
        
        cancel_ChangeEnrollView = [[[NSBundle mainBundle] loadNibNamed:@"Cancel_changeEnrollIPad" owner:self options:nil] objectAtIndex:0];
        
        cancel_ChangeEnrollView.frame = self.view.frame;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        cancel_ChangeEnrollView = [[Cancel_ChangeEnrollView alloc] init];
        
        cancel_ChangeEnrollView = [[[NSBundle mainBundle] loadNibNamed:@"Cancel_ChangeEnrollView" owner:self options:nil] objectAtIndex:0];
        
        cancel_ChangeEnrollView.frame = self.view.frame;
    }
    
    cancel_ChangeEnrollView.title.text = @"Enrollment/ Booking Cancellation";
    cancel_ChangeEnrollView.member.text = name;
    cancel_ChangeEnrollView.student.text = s_name;
    cancel_ChangeEnrollView.list_name.text = listName;
    cancel_ChangeEnrollView.session_name.text = session_name;
    cancel_ChangeEnrollView.date.text = dateStart;
    cancel_ChangeEnrollView.amount_lbl.hidden = YES;
    cancel_ChangeEnrollView.amount_txtField.hidden = YES;
    [cancel_ChangeEnrollView.confirm_Btn addTarget:self action:@selector(tapCangeEnrollmentBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancel_ChangeEnrollView.confirm_Btn.tag = sender.tag;
    [cancel_ChangeEnrollView.session_btn addTarget:self action:@selector(tapSessionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancel_ChangeEnrollView.confirm_Btn setTitle:@"Send Request" forState:UIControlStateNormal];
    cancel_ChangeEnrollView.session_btn.tag = sender.tag;
    
     //[cancel_ChangeEnrollView.confirm_Btn sizeToFit];
    
    NSString *status = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"payment_status"];
    
    if ([typeStr isEqualToString:@"3"]) {
        
        cancel_ChangeEnrollView.selctDay_btn.hidden = NO;
        cancel_ChangeEnrollView.selctDay_lbl.hidden = NO;
        
        [cancel_ChangeEnrollView.selctDay_btn addTarget:self action:@selector(tapSelectDayBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        cancel_ChangeEnrollView.selctDay_btn.tag = sender.tag;
        
    } else {
        
        cancel_ChangeEnrollView.selctDay_btn.hidden = YES;
        cancel_ChangeEnrollView.selctDay_lbl.hidden = YES;
        
        CGRect frame = cancel_ChangeEnrollView.MainView.frame;
        
        frame.origin.y = cancel_ChangeEnrollView.selctDay_lbl.frame.origin.y;
        
        cancel_ChangeEnrollView.MainView.frame = frame;
        
        frame = cancel_ChangeEnrollView.main_view.frame;
        
        frame.size.height = cancel_ChangeEnrollView.MainView.frame.size.height+cancel_ChangeEnrollView.MainView.frame.origin.y+20;
        
        cancel_ChangeEnrollView.main_view.frame = frame;
        
    }
    
         
    if ([status isEqualToString:@"0"]) {
        
        cancel_ChangeEnrollView.message.hidden = YES;
        cancel_ChangeEnrollView.msg_lbl.hidden = YES;
        CGRect frame = cancel_ChangeEnrollView.confirm_Btn.frame;
        frame.origin.y = cancel_ChangeEnrollView.message.frame.origin.y;
        cancel_ChangeEnrollView.confirm_Btn.frame = frame;
        
        frame = cancel_ChangeEnrollView.close_btn.frame;
        frame.origin.y = cancel_ChangeEnrollView.confirm_Btn.frame.origin.y + cancel_ChangeEnrollView.confirm_Btn.frame.size.height + 15;
        cancel_ChangeEnrollView.close_btn.frame = frame;
        
        frame = cancel_ChangeEnrollView.MainView.frame;
        frame.size.height = cancel_ChangeEnrollView.close_btn.frame.origin.y + cancel_ChangeEnrollView.close_btn.frame.size.height + 20;
        cancel_ChangeEnrollView.MainView.frame = frame;
        
        frame = cancel_ChangeEnrollView.main_view.frame;
        frame.size.height = cancel_ChangeEnrollView.MainView.frame.origin.y + cancel_ChangeEnrollView.MainView.frame.size.height + 10;
        cancel_ChangeEnrollView.main_view.frame = frame;

    }
    
    cancel_ChangeEnrollView.scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, cancel_ChangeEnrollView.main_view.frame.origin.y+cancel_ChangeEnrollView.main_view.frame.size.height +50);
    
    [self.view addSubview:cancel_ChangeEnrollView];
}

-(void)tapSelectDayBtn:(UIButton *)sender{
    
    if (!changeSession_id) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please select session first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        NSString *typeStr = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
        
        NSString *listing, *list_type, *listing_name, *list_name;
        
        if ([typeStr isEqualToString:@"1"]) {
            
            listing = @"CourseSession";
            
            listing_name = @"CourseListing";
            
            list_name = @"course_name";
            
            list_type = @"Course";
            
        } else if ([typeStr isEqualToString:@"2"]) {
            
            listing = @"EventSession";
            
            listing_name = @"EventListing";
            
            list_name = @"event_name";
            
            list_type = @"Event";
            
        } else if ([typeStr isEqualToString:@"3"]) {
            
            listing = @"LessonSession";
            
            list_name = @"lesson_name";
            
            listing_name = @"LessonListing";
            
            list_type = @"Lesson";
        }
        
        NSString *session_id = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"id"];
        
        NSDictionary *paramUrl = @{@"selected_session_id":session_id};
        
        [self.view addSubview:indicator];
        
        [selectDayConn startConnectionWithString:@"select_lesson_timing" HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary *ReceivedData){
            
            [indicator removeFromSuperview];
            
            if ([selectDayConn responseCode]==1) {
                
                NSLog(@"%@",ReceivedData);
                
                NSArray *lesson_array = [ReceivedData valueForKey:@"Timings"];
                
                lesson_timeArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < lesson_array.count; i++) {
                    
                    NSString *day = [[[lesson_array objectAtIndex:i] valueForKey:@"LessonTiming"] valueForKey:@"day_select"];
                    
                    day = [day stringByAppendingString:[NSString stringWithFormat:@" ( %@ - %@ )",[[[lesson_array objectAtIndex:i] valueForKey:@"LessonTiming"] valueForKey:@"start_time"], [[[lesson_array objectAtIndex:i] valueForKey:@"LessonTiming"] valueForKey:@"finish_time"]]];
                    
                    NSString *lesson_id = [[[lesson_array objectAtIndex:i] valueForKey:@"LessonTiming"] valueForKey:@"id"];
                    
                    NSDictionary *dict = @{@"id": lesson_id, @"name":day};
                    
                    [lesson_timeArray addObject:dict];
                }
                
                [self showListData:[lesson_timeArray valueForKey:@"name"] allowMultipleSelection:NO selectedData:[cancel_ChangeEnrollView.selctDay_btn.titleLabel.text componentsSeparatedByString:@", "] title:@"Select Lesson Day"];
            }
        }];
    }
}

-(void)tapSessionBtn:(UIButton *)sender {
    
    [self.view addSubview:indicator];
    
    tapSession = YES;
    
    // enrollment_id, payment_status (1 if payment done, 0 is payment not done), current_session_id
    
    NSString *typeStr = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }
    
    NSDictionary *paramURL;
    
    NSString *enroll_id1 = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
    
    // session_id (For which enrollment will be changed), enrollment_id, role (1 for student, 2 for educator), lesson_timing_id(if lesson)
    
    paramURL = @{ @"enrollment_id":enroll_id1, @"role":@"1", @"session_id":[[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"id"], @"lesson_timing_id":[[[[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"session_timings"]objectAtIndex:0]valueForKey:listing]valueForKey:@"id"]};
    
    [getSessionConn startConnectionWithString:@"get_all_sessions" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([getSessionConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            sessionsArray = [receivedData valueForKey:@"Sessions"];
            
            list_session = listing;
            
            [self showListData:[[sessionsArray valueForKey:listing] valueForKey:@"session_name"] allowMultipleSelection:NO selectedData:[cancel_ChangeEnrollView.session_btn.titleLabel.text componentsSeparatedByString:@","] title:@"Select Session"];
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

-(void)didSelectListItem:(id)item index:(NSInteger)index {
    
    if (!tapSession) {
        
        [cancel_ChangeEnrollView.selctDay_btn setTitle:[@"  " stringByAppendingString:[[lesson_timeArray objectAtIndex:index] valueForKey:@"name"]] forState:UIControlStateNormal];
        
        lesson_timeId = [[lesson_timeArray objectAtIndex:index] valueForKey:@"id"];
        
    } else {
        
        [cancel_ChangeEnrollView.session_btn setTitle:[@"  " stringByAppendingString:[[[sessionsArray objectAtIndex:index] valueForKey:list_session] valueForKey:@"session_name"]] forState:UIControlStateNormal];
        
        changeSession_id = [[[sessionsArray objectAtIndex:index] valueForKey:list_session] valueForKey:@"id"];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didSaveItems:(NSArray*)items indexs:(NSArray *)indexs{
    
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)tapCangeEnrollmentBtn:(UIButton *)sender {
    
    [actionView removeFromSuperview];
    
    NSString *typeStr = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *enroll_id1 = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }
    
    NSString *message;
    
    NSString *status = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"payment_status"];
    
    if ([status isEqualToString:@"1"]) {
        
        if ([cancel_ChangeEnrollView.message.text isEqualToString:@"Enter Message"]) {
            
            message = @"Please enter message";
            
        } else if (![validationObj validateNumberDigits:cancel_ChangeEnrollView.amount_txtField.text]) {
            
            message = @"Please enter valid refund amount";
        }
    } else {
        
        if ([cancel_ChangeEnrollView.session_btn.titleLabel.text isEqualToString:@"  Select"]) {
            
            message = @"Please Select Session";
        }
        
        if ([typeStr isEqualToString:@"Lesson"]) {
            
            if (!lesson_timeId) {
                
                message = @"Please Select Day";
            }
        }
    }
    if (message.length > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        NSString *status = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"payment_status"];
        
        if ([status isEqualToString:@"0"]) {
            
            // session_id (For which enrollment will be changed), enrollment_id, role (1 for student, 2 for educator), lesson_timing_id(if lesson)
            
            NSDictionary *paramURL;
            
//            if ([list_type isEqualToString:@"Lesson"]) {
//                
//                paramURL = @{@"enrollment_id":enroll_id1, @"role":@"1", @"session_id":changeSession_id, @"lesson_timing_id":lesson_timeId};
//                
//            } else {
            
                paramURL = @{@"enrollment_id":enroll_id1, @"role":@"1", @"session_id":changeSession_id};
//            }
            
            
            [self.view addSubview:indicator];
            
            [changeEnrollConn startConnectionWithString:@"change_enrollment_before_paid_student" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
                
                [indicator removeFromSuperview];
                
                if ([changeEnrollConn responseCode] == 1) {
                    
                    NSLog(@"%@", receivedData);
                    
                    [cancel_ChangeEnrollView removeFromSuperview];
                    
                    [self fetchWebData:1];
                }
            }];
            
        } else {
            
            // NSString *educator_id = [[[myEnrollArray objectAtIndex:sender.tag] valueForKey:@"EnrollmentOwner"] valueForKey:@"id"];
            
            // enrollment_id, message_content, payment_status = 1
            
            [self.view addSubview:indicator];
            
            NSDictionary *paramURL;
            
            //session_id (For which enrollment will be changed), enrollment_id, message_content,  lesson_timing_id(if lesson)
            if ([list_type isEqualToString:@"Lesson"]) {
                
                paramURL = @{@"enrollment_id":enroll_id1, @"role":@"1", @"session_id":changeSession_id, @"lesson_timing_id":lesson_timeId, @"message_content":cancel_ChangeEnrollView.message.text};
                
            } else {
                
                paramURL = @{@"enrollment_id":enroll_id1, @"role":@"1", @"session_id":changeSession_id, @"message_content":cancel_ChangeEnrollView.message.text};
            }
            
            [changeEnrollConn startConnectionWithString:@"change_enrollment_by_edu_after_payment" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
                
                [indicator removeFromSuperview];
                
                if ([changeEnrollConn responseCode] == 1) {
                    
                    NSLog(@"%@", receivedData);
                    
                    [cancel_ChangeEnrollView removeFromSuperview];
                    
                    [self fetchWebData:1];
                }
            }];
        }
    }
}

-(void)tapCancelEnrollBtn:(UIButton *)sender {
    
    [actionView removeFromSuperview];
    
    NSString *typeStr = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }
    
    NSString *dateStart = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing] valueForKey:@"start_date"];
    
    dateStart = [dateconversion convertDate:dateStart];
    
     NSString *finish_date = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"finish_date"];
    
    finish_date = [dateconversion convertDate:finish_date];
    
    dateStart = [@"[Date] - " stringByAppendingString:dateStart];
    
    dateStart = [dateStart stringByAppendingString:@" to "];
    dateStart = [dateStart stringByAppendingString:finish_date];
    
    NSString *listName = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing_name]valueForKey:list_name];
    
    list_type = [@"[" stringByAppendingString:[NSString stringWithFormat:@"%@] - ",list_type]];
    
    listName = [list_type stringByAppendingString:listName];
    
    NSString *session_name = [[[listingEnrolArray objectAtIndex:sender.tag]valueForKey:listing]valueForKey:@"session_name"];
   
    session_name = [@"[Session Name] - " stringByAppendingString:session_name];
    
    NSString *name = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Member"]valueForKey:@"first_name"];
    
    name = [name stringByAppendingString:[NSString stringWithFormat:@" %@",[[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Member"] valueForKey:@"last_name"]]];
    
    NSString *s_name = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Family"]valueForKey:@"first_name"];
    
    s_name = [s_name stringByAppendingString:[NSString stringWithFormat:@" %@",[[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"Family"] valueForKey:@"family_name"]]];
    
    NSDictionary *paramURL;
    
    NSString *webservice_url;
    
    NSString *enroll_id = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
    
    NSString *status = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"payment_status"];
    
    if ([status isEqualToString:@"0"]
        ) {
        
        webservice_url = @"cancel_enrollment";
        
        //enrollment_id, status (7 if educator cancel, 8 if student cancel), payment_status = 0
        
        paramURL = @{@"enrollment_id":enroll_id,@"status":@"7",@"payment_status":@"0"};
    
        [self.view addSubview:indicator];
        
        [cancelConn startConnectionWithString:webservice_url HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
            
            [indicator removeFromSuperview];
            
            if ([cancelConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                [self fetchWebData:1];
            }
        }];

    } else {
        
        UIStoryboard *storyboard;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
       
            cancel_ChangeEnrollView = [[Cancel_ChangeEnrollView alloc] init];
            
            cancel_ChangeEnrollView = [[[NSBundle mainBundle] loadNibNamed:@"Cancel_changeEnrollIPad" owner:self options:nil] objectAtIndex:0];
            
            cancel_ChangeEnrollView.frame = self.view.frame;
            
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            cancel_ChangeEnrollView = [[Cancel_ChangeEnrollView alloc] init];
            
            cancel_ChangeEnrollView = [[[NSBundle mainBundle] loadNibNamed:@"Cancel_ChangeEnrollView" owner:self options:nil] objectAtIndex:0];
            
            cancel_ChangeEnrollView.frame = self.view.frame;
        }
        
        cancel_ChangeEnrollView.title.text = @"Enrollment/ Booking Cancellation";
        cancel_ChangeEnrollView.member.text = name;
        cancel_ChangeEnrollView.student.text = s_name;
        cancel_ChangeEnrollView.list_name.text = listName;
        cancel_ChangeEnrollView.session_name.text = session_name;
        cancel_ChangeEnrollView.date.text = dateStart;
        cancel_ChangeEnrollView.session_btn.hidden = YES;
        cancel_ChangeEnrollView.select_session_lbl.hidden = YES;
        cancel_ChangeEnrollView.selctDay_lbl.hidden = YES;
        cancel_ChangeEnrollView.selctDay_btn.hidden = YES;
        
        CGRect frame = cancel_ChangeEnrollView.MainView.frame;
        
        frame.origin.y = cancel_ChangeEnrollView.select_session_lbl.frame.origin.y;
        
        cancel_ChangeEnrollView.MainView.frame = frame;
        
        frame = cancel_ChangeEnrollView.main_view.frame;
        
        frame.size.height = cancel_ChangeEnrollView.MainView.frame.size.height +cancel_ChangeEnrollView.MainView.frame.origin.y+30;
        
        cancel_ChangeEnrollView.main_view.frame = frame;
        
        cancel_ChangeEnrollView.scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, cancel_ChangeEnrollView.main_view.frame.origin.y+cancel_ChangeEnrollView.main_view.frame.size.height +60);
        
        [cancel_ChangeEnrollView.confirm_Btn addTarget:self action:@selector(tapCanclEnroll:) forControlEvents:UIControlEventTouchUpInside];
        cancel_ChangeEnrollView.confirm_Btn.tag = sender.tag;
        [self.view addSubview:cancel_ChangeEnrollView];
    }
}

-(void)tapCanclEnroll:(UIButton *)sender {
    //cancel_enrollment_refund
    //enrollment_id, educator_id, amount, message_content
    
    [actionView removeFromSuperview];
    
    NSString *message;
    
    if ([cancel_ChangeEnrollView.message.text isEqualToString:@"Enter Message"]) {
        
        message = @"Please enter message";
        
    } else if (![validationObj validateNumberDigits:cancel_ChangeEnrollView.amount_txtField.text]) {
        
        message = @"Please enter valid refund amount";
    }
    
    if (message.length > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
    
    NSString *enroll_id = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
    
    NSString *educator_id = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"EnrollmentOwner"] valueForKey:@"id"];
    
    NSDictionary *paramURL = @{@"enrollment_id":enroll_id,@"educator_id":educator_id,@"amount":cancel_ChangeEnrollView.amount_txtField.text, @"message_content":cancel_ChangeEnrollView.message.text};
    
    [self.view addSubview:indicator];
    
    [cancelConn startConnectionWithString:@"cancel_enrollment_refund" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([cancelConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            [cancel_ChangeEnrollView removeFromSuperview];
            
            [self fetchWebData:1];
        }
    }];
    }
}


-(void)popup:(BOOL)isbtn1:(BOOL)isbtn2:(BOOL)isbtn3:(BOOL)isbtn4:(BOOL)isbtn5:(BOOL)isbtn6:(BOOL)isbtn7:(NSInteger)indexrow{
    
    [actionView removeFromSuperview];
    
    actionView = [[UIView alloc]initWithFrame:CGRectMake(20, 200, 250, 400)];
    
    actionView.backgroundColor = [UIColor darkGrayColor];
    
    actionView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    actionView.layer.borderWidth = 1.0f;
    
    actionView.layer.cornerRadius = 5;
    
    //[actionView bounds];
    
    CGRect frame = actionView.frame;
    
    frame.origin.x = (self.view.frame.size.width-actionView.frame.size.width)/2;
    
    actionView.frame = frame;
    
    [actionView sizeToFit];
    
    [self.view addSubview:actionView];
    
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 50)];
    
    subView.backgroundColor = [UIColor lightGrayColor];
    
    //subView.layer.cornerRadius = 5;
    
    [actionView addSubview:subView];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 200, 30)];
    
    lbl.backgroundColor = [UIColor clearColor];
    
    [lbl.font fontWithSize:17];
    
    lbl.textColor = [UIColor whiteColor];
    
    lbl.text = @"Action";
    
    lbl.textAlignment = NSTextAlignmentCenter;
    
    [subView addSubview:lbl];
    
    UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 51, 250, 30)];
    
    subView1.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView1];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn1.backgroundColor = [UIColor clearColor];
    
    [btn1 setTitle:@"View" forState:UIControlStateNormal];
    
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    //btn1.layer.cornerRadius = 5;
    
    [btn1 addTarget:self action:@selector(tapViewMember:) forControlEvents:UIControlEventTouchUpInside];
    
    btn1.tag = indexrow;
    
    [subView1 addSubview:btn1];
    
    UIImageView *imgview1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview1.image = [UIImage imageNamed:@"eye_blue"];
    
    //imgview1.layer.cornerRadius = 5;
    
    //imgview1.layer.masksToBounds = YES;
    
    [subView1 addSubview:imgview1];
    
    
    UIView *subView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 82, 250, 30)];
    
    subView2.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView2];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn2.backgroundColor = [UIColor clearColor];
    
    [btn2 setTitle:@"Message" forState:UIControlStateNormal];
    
    btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn2 addTarget:self action:@selector(tapMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn2.tag = indexrow;
    
    [subView2 addSubview:btn2];
    
    UIImageView *imgview2 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview2.image = [UIImage imageNamed:@"message"];
    
    [subView2 addSubview:imgview2];
    
    UIView *subView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 113, 250, 30)];
    
    subView3.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView3];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn3.backgroundColor = [UIColor clearColor];
    
    [btn3 setTitle:@"Accept" forState:UIControlStateNormal];
    
    btn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn3 addTarget:self action:@selector(tapApprovedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn3.tag = indexrow;
    
    [subView3 addSubview:btn3];
    
    UIImageView *imgview3 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview3.image = [UIImage imageNamed:@"Smily"];
    
    [subView3 addSubview:imgview3];
    
    UIView *subView4 = [[UIView alloc]initWithFrame:CGRectMake(0, 144, 250, 30)];
    
    subView4.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView4];
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn4.backgroundColor = [UIColor clearColor];
    
    [btn4 setTitle:@"Decline" forState:UIControlStateNormal];
    
     btn4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn4 addTarget:self action:@selector(tapPendingBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn4.tag = indexrow;
    
    [subView4 addSubview:btn4];
    
    UIImageView *imgview4 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview4.image = [UIImage imageNamed:@"mah_face"];
    
    [subView4 addSubview:imgview4];
    
    UIView *subView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 175, 250, 30)];
    
    subView5.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView5];
    
    UIButton *btn5 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn5.backgroundColor = [UIColor clearColor];
    
    [btn5 setTitle:@"Change Enrollment" forState:UIControlStateNormal];
    
     btn5.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn5 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn5 addTarget:self action:@selector(tapChangeEnrollBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn5.tag = indexrow;
    
    [subView5 addSubview:btn5];
    
    UIImageView *imgview5 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview5.image = [UIImage imageNamed:@"adjust"];
    
    [subView5 addSubview:imgview5];
    
    UIView *subView6 = [[UIView alloc]initWithFrame:CGRectMake(0, 261, 250, 30)];
    
    subView6.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView6];
    
    UIButton *btn6 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn6.backgroundColor = [UIColor clearColor];
    
    [btn6 setTitle:@"Cancel Enrollment" forState:UIControlStateNormal];
    
     btn6.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn6 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn6 addTarget:self action:@selector(tapChangeEnrollBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn6.tag = indexrow;
    
    [subView6 addSubview:btn6];
    
    UIImageView *imgview6 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview6.image = [UIImage imageNamed:@"minus"];
    
    [subView6 addSubview:imgview6];
    
    UIView *subView7 = [[UIView alloc]initWithFrame:CGRectMake(0, 292, 250, 30)];
    
    subView7.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:subView7];
    
    UIButton *btn7 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 220, 30)];
    
    btn7.backgroundColor = [UIColor clearColor];
    
    [btn7 setTitle:@"Delete" forState:UIControlStateNormal];
    
    //[btn6.titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    btn7.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn7 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn7 addTarget:self action:@selector(tapDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    btn7.tag = indexrow;
    
    [subView7 addSubview:btn7];
    
    UIImageView *imgview7 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    
    imgview7.image = [UIImage imageNamed:@"delete_teal"];
    
    [subView7 addSubview:imgview7];
    
    UIView *cancelView = [[UIView alloc]initWithFrame:CGRectMake(0, 261, 250, 30)];
    
    cancelView.backgroundColor = [UIColor whiteColor];
    
    [actionView addSubview:cancelView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
    
    btn.backgroundColor = [UIColor clearColor];
    
    [btn setTitle:@"Close" forState:UIControlStateNormal];
    
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(tap_cancelpopup:) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelView addSubview:btn];
    
    CGRect frame1;
    
    if (isbtn1) {
        
        frame1 = subView1.frame;
        
        frame1.origin.y = subView.frame.origin.y + subView.frame.size.height+1;
        
        subView1.frame = frame1;
        
    }
    else{
        
        frame1 = subView1.frame;
        
        frame1.origin.y = 20;
        
        subView1.frame = frame1;
        
        subView1.hidden = YES;
        
    }
    
    if (isbtn2) {
        
        frame1 = subView2.frame;
        
        frame1.origin.y = subView1.frame.origin.y + subView1.frame.size.height+1;
        
        subView2.frame = frame1;
    }
    else{
        
        subView2.frame = subView1.frame;
        
        subView2.hidden = YES;
        
    }
    
    if (isbtn3) {
        
        frame1 = subView3.frame;
        
        frame1.origin.y = subView2.frame.origin.y + subView2.frame.size.height+1;
        
        subView3.frame = frame1;
    }
    else{
        
        subView3.frame = subView2.frame;
        
        subView3.hidden = YES;
        
    }
    
    if (isbtn4) {
        
        frame1 = subView4.frame;
        
        frame1.origin.y = subView3.frame.origin.y + subView3.frame.size.height+1;
        
        subView4.frame = frame1;
    }
    else{
        
        subView4.frame = subView3.frame;
        
        subView4.hidden = YES;
        
    }
    
    if (isbtn5) {
        
        frame1 = subView5.frame;
        
        frame1.origin.y = subView4.frame.origin.y + subView4.frame.size.height+1;
        
        subView5.frame = frame1;
    }
    else{
        
        subView5.frame = subView4.frame;
        
        subView5.hidden = YES;
        
    }
    
    if (isbtn6) {
        
        frame1 = subView6.frame;
        
        frame1.origin.y = subView5.frame.origin.y + subView5.frame.size.height+1;
        
        subView6.frame = frame1;
    }
    else{
        
        subView6.frame = subView5.frame;
        
        subView6.hidden = YES;
        
    }
    if (isbtn7) {
        
        frame1 = subView7.frame;
        
        frame1.origin.y = subView6.frame.origin.y + subView6.frame.size.height+1;
        
        subView7.frame = frame1;
    }
    else{
        
        subView7.frame = subView6.frame;
        
        subView7.hidden = YES;
        
    }
    
    frame1 = cancelView.frame;
    
    frame1.origin.y = subView7.frame.origin.y + subView7.frame.size.height+1;
    
    cancelView.frame = frame1;
    
    
    
    frame1 = actionView.frame;
    
    frame1.size.height = cancelView.frame.origin.y + cancelView.frame.size.height+1;
    
    frame1.origin.y = (self.view.frame.size.height-frame1.size.height)/2;
    
    actionView.frame = frame1;
    
        
    }

-(void)tapDeleteBtn:(UIButton *)sender{
    
    [actionView removeFromSuperview];
    
    NSString *enroll_id1 = [[[listingEnrolArray objectAtIndex:sender.tag] valueForKey:@"CreateEnrollment"] valueForKey:@"id"];
    
    NSDictionary *paramURL = @{@"enrollment_id":enroll_id1};
    
    [self.view addSubview:indicator];
    
    [deleteConn startConnectionWithString:@"delete_this_enrollment_list" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if ([deleteConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            [cancel_ChangeEnrollView removeFromSuperview];
            
            [self fetchWebData:1];
        }
    }];
    
}

-(void)tap_actionBtn:(UIButton *)sender{
    
        [actionView removeFromSuperview];
        
        if ([[popupArary objectAtIndex:sender.tag] isEqual:@"1"]) {
            
            [popupDict setObject:@"YES" forKey:@"btn1"]; //view
            
            [popupDict setObject:@"YES" forKey:@"btn2"];//msg
            
            [popupDict setObject:@"YES" forKey:@"btn3"];//accept
            
            [popupDict setObject:@"YES" forKey:@"btn4"];//decline
            
            [popupDict setObject:@"YES" forKey:@"btn5"]; //change E
            
            [popupDict setObject:@"YES" forKey:@"btn6"]; // camcel E
            
            [popupDict setObject:@"NO" forKey:@"btn7"];
            
            
        }
        else if([[popupArary objectAtIndex:sender.tag] isEqual:@"2"]){
            
            [popupDict setObject:@"YES" forKey:@"btn1"];
            
            [popupDict setObject:@"YES" forKey:@"btn2"];
            
            [popupDict setObject:@"NO" forKey:@"btn3"];
            
            [popupDict setObject:@"YES" forKey:@"btn4"];
            
            [popupDict setObject:@"YES" forKey:@"btn5"];
            
            [popupDict setObject:@"YES" forKey:@"btn6"];
            
            [popupDict setObject:@"NO" forKey:@"btn7"];
            
            
            
        }
        
        else if([[popupArary objectAtIndex:sender.tag] isEqual:@"3"]){
            
            [popupDict setObject:@"YES" forKey:@"btn1"];
            
            [popupDict setObject:@"YES" forKey:@"btn2"];
            
            [popupDict setObject:@"NO" forKey:@"btn3"];
            
            [popupDict setObject:@"NO" forKey:@"btn4"];
            
            [popupDict setObject:@"YES" forKey:@"btn5"];
            
            [popupDict setObject:@"YES" forKey:@"btn6"];
            
            [popupDict setObject:@"YES" forKey:@"btn7"];
            
            
            
        }
        
        else if([[popupArary objectAtIndex:sender.tag] isEqual:@"9"]){
            
            [popupDict setObject:@"YES" forKey:@"btn1"];
            
            [popupDict setObject:@"YES" forKey:@"btn2"];
            
            [popupDict setObject:@"NO" forKey:@"btn3"];
            
            [popupDict setObject:@"NO" forKey:@"btn4"];
            
            [popupDict setObject:@"NO" forKey:@"btn5"];
            
            [popupDict setObject:@"NO" forKey:@"btn6"];
            
            [popupDict setObject:@"NO" forKey:@"btn7"];
            
            
            
        }
        
        else if([[popupArary objectAtIndex:sender.tag] isEqual:@"5"]){
            
            [popupDict setObject:@"YES" forKey:@"btn1"];
            
            [popupDict setObject:@"YES" forKey:@"btn2"];
            
            [popupDict setObject:@"YES" forKey:@"btn3"];
            
            [popupDict setObject:@"YES" forKey:@"btn4"];
            
            [popupDict setObject:@"YES" forKey:@"btn5"];
            
            [popupDict setObject:@"YES" forKey:@"btn6"];
            
            [popupDict setObject:@"NO" forKey:@"btn7"];
            
            
            
        }
        
        else if([[popupArary objectAtIndex:sender.tag] isEqual:@"6"]){
            
            [popupDict setObject:@"YES" forKey:@"btn1"];
            
            [popupDict setObject:@"YES" forKey:@"btn2"];
            
            [popupDict setObject:@"YES" forKey:@"btn3"];
            
            [popupDict setObject:@"NO" forKey:@"btn4"];
            
            [popupDict setObject:@"YES" forKey:@"btn5"];
            
            [popupDict setObject:@"YES" forKey:@"btn6"];
            
            [popupDict setObject:@"NO" forKey:@"btn7"];
            
            
            
        }
        
        else if([[popupArary objectAtIndex:sender.tag] isEqual:@"7"]){
            
            [popupDict setObject:@"YES" forKey:@"btn1"];
            
            [popupDict setObject:@"YES" forKey:@"btn2"];
            
            [popupDict setObject:@"NO" forKey:@"btn3"];
            
            [popupDict setObject:@"NO" forKey:@"btn4"];
            
            [popupDict setObject:@"YES" forKey:@"btn5"];
            
            [popupDict setObject:@"YES" forKey:@"btn6"];
            
            [popupDict setObject:@"YES" forKey:@"btn7"];
            
            
            
        }
        
        else if([[popupArary objectAtIndex:sender.tag] isEqual:@"8"]){
            
            [popupDict setObject:@"YES" forKey:@"btn1"];
            
            [popupDict setObject:@"YES" forKey:@"btn2"];
            
            [popupDict setObject:@"NO" forKey:@"btn3"];
            
            [popupDict setObject:@"NO" forKey:@"btn4"];
            
            [popupDict setObject:@"NO" forKey:@"btn5"];
            
            [popupDict setObject:@"NO" forKey:@"btn6"];
            
            [popupDict setObject:@"YES" forKey:@"btn7"];
            
        }
    
    BOOL btn1,btn2,btn3,btn4,btn5,btn6,btn7;
    
    if ([[popupDict valueForKey:@"btn1"]isEqual:@"YES"]) {
        
        btn1 = YES;
    }
    
    else{
        
        btn1 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn2"]isEqual:@"YES"]) {
        
        btn2 = YES;
    }
    
    else{
        
        btn2 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn3"]isEqual:@"YES"]) {
        
        btn3 = YES;
    }
    
    else{
        
        btn3 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn4"]isEqual:@"YES"]) {
        
        btn4 = YES;
    }
    
    else{
        
        btn4 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn5"]isEqual:@"YES"]) {
        
        btn5 = YES;
    }
    
    else{
        
        btn5 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn6"]isEqual:@"YES"]) {
        
        btn6 = YES;
    }
    
    else{
        
        btn6 = NO;
    }
    
    if ([[popupDict valueForKey:@"btn7"]isEqual:@"YES"]) {
        
        btn7 = YES;
    }
    
    else{
        
        btn7 = NO;
    }
    
    
    [self popup:btn1 :btn2 :btn3 :btn4 :btn5 :btn6 :btn7 :sender.tag];
    
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

-(void)tap_infotoolBtn:(UIButton *)sender {
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Status' shows the stage of the enrollment or booking process. There are 4 statuses that may be shown. 'Please Accept' means the student or attendee is waiting for you (the educator) to Accept the enrollment or booking request. 'Waiting Payment' is when you are waiting for the student or attendee to pay your ECAhub account. 'Confirmed / Payment Received' means the student or attendee has paid your ECAhub account and therefore the enrollment or booking is confirmed. 'Cancelled' is when you as Educator has cancelled the enrollment or booking." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
   
    
    [alertview show];
}

-(void)tap_cancelpopup:(UIButton *)sender{
    
    [actionView removeFromSuperview];
    
}

@end
