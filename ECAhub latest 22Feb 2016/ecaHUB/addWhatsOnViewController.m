//  addWhatsOnViewController.m
//  ecaHUB
//
//  Created by promatics on 4/20/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "addWhatsOnViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "TabBarViewController.h"
#import "MyWhatsOnListing.h"

@interface addWhatsOnViewController () {
    
    WebServiceConnection *whatsOnPostConn;
    
    WebServiceConnection *getListConn;
    
    MyWhatsOnListing *myWhatson;
    
    Indicator *indicator;
    
    BOOL isTapAuto,tapDate;
    
    UIImagePickerController * imagePicker;
    
    NSArray *images;
    
    float y;
    
    CGRect msgTextFrame;
    
    NSMutableArray *listingArray;
    
    NSString *member_id, *list_id, *type,*expiryDate, *Date;
    
    NSData *picture;
    
    UIToolbar *toolbar;
    
    UIBarButtonItem *donebutton,*Cancelbutton,*flexiblebutton;
    
    UIDatePicker *DatePicker;
    
    NSMutableData *imageData;
    
    NSString *name,*Id,*NSString,*cityName;
}
@end

@implementation addWhatsOnViewController

@synthesize scrollView, selectListBtn, chooseImgBtn, imgLbl, auto_msgBtn, customBtn, orLbl, postBtn, cancelBtn, img_view, message_textView, btnView,expiry_btn,listinfo_lbl,tapWhatsOn_list,charLimit_lbl,post_Dict,listPost;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //   self.navigationController.navigationBar.topItem.title = @"";
    
    // self.navigationItem.title = @"Create \"What's On!\" Posts";
    
    self.navigationItem.title = @"Create a \"What's On!\"";
    
    NSLog(@"post_dict %@",post_Dict);
    
    scrollView.frame = self.view.frame;
    
    expiry_btn.hidden = YES;
    
    getListConn = [WebServiceConnection connectionManager];
    
    whatsOnPostConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    imageData  = [[NSMutableData alloc]init];
    
    listingArray = [[NSMutableArray alloc] init];
    
    message_textView.text = @"Write your message";
    
    message_textView.textColor = UIColorFromRGB(placeholder_text_color_hexcode);
    
    [postBtn setTitle:@"Create" forState:UIControlStateNormal];
    
    [postBtn setBackgroundColor:UIColorFromRGB(teal_text_color_hexcode)];
    
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    cancelBtn.layer.borderWidth = 1.0f;
    
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    charLimit_lbl.hidden = YES;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        chooseImgBtn.layer.cornerRadius = 22.5f;
        
        orLbl.layer.cornerRadius = 30.0f;
        
        y = 250;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+50);
        
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        chooseImgBtn.layer.cornerRadius = 15.0f;
        
        orLbl.layer.cornerRadius = 20.0f;
        
        y = 180;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    }
    
    isTapAuto = YES;
    
    tapDate = YES;
    
    orLbl.layer.masksToBounds = YES;
    
    selectListBtn.layer.borderWidth = 1.0f;
    
    selectListBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    selectListBtn.layer.cornerRadius = 5.0f;
    
    //[selectListBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    
    expiry_btn.layer.borderWidth = 1.0f;
    
    expiry_btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    expiry_btn.layer.cornerRadius = 5.0f;
    
    chooseImgBtn.layer.borderWidth = 1.0f;
    
    chooseImgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    auto_msgBtn.layer.borderWidth = 1.0f;
    
    auto_msgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    auto_msgBtn.layer.cornerRadius = 3.0f;
    
    customBtn.layer.borderWidth = 1.0f;
    
    customBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    customBtn.layer.cornerRadius = 3.0f;
    
    //  listinfo_lbl.hidden = YES;
    
    [customBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    //    [auto_msgBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    postBtn.layer.cornerRadius = 5.0f;
    
    msgTextFrame = message_textView.frame;
    
    CGRect frame = btnView.frame;
    
    frame.origin.y = msgTextFrame.origin.y + 20;
    
    btnView.frame = frame;
    
    message_textView.hidden = YES;
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    if(listPost){
        
        // paramURL = @{@"member_id": member_id, @"description":message_textView.text, @"listing_type":type, @"list_id":list_id, @"my_text":@"1",@"name":name,listType:Id,@"expiry_date":expiryDate,@"city_name":CityName};
        
        // postDict = @{@"expiry_date":expDate,@"listing_id":listing_id,@"type":type,@"name":listName,@"list_id":[receivedData valueForKey:@"listing_id"]};
        
        type = [post_Dict valueForKey:@"type"];
        
        
        if([type isEqualToString:@"1"]){
            
            type = @"course";
            
        } else if([ type isEqualToString:@"2"]){
            
            type = @"lesson";
            
        } else if([ type isEqualToString:@"3"]){
            
            type = @"event";
        }
        
        expiryDate = [post_Dict valueForKey:@"expiry_date"];
        
        name = [post_Dict valueForKey:@"name"];
        
        list_id = [post_Dict valueForKey:@"list_id"];
        
        Id = [post_Dict valueForKey:@"list_id"];
        
        [selectListBtn setTitle:[@"  " stringByAppendingString:name] forState:UIControlStateNormal];
        
        cityName = [post_Dict valueForKey:@"city_name"];
        
        
        
    } else {
        
        [selectListBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
    }
}

-(void)addPicker_toolBar {
    
    DatePicker = [[UIDatePicker alloc] init];
    
    if (tapDate) {
        
        [DatePicker setDatePickerMode:UIDatePickerModeDate];
        
        [DatePicker setMinimumDate:[NSDate date]];
        
        NSDate *nowDate = [NSDate date];
        
        int daysToAdd = 14;
        
        NSDate *newDate1 = [nowDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *expirydate = [dateFormat dateFromString:expiryDate];
        
        NSLog(@"%@",expirydate);
        
        if ([expirydate compare:newDate1] != NSOrderedAscending) {
            
            [DatePicker setMaximumDate:newDate1];
            
        } else{
            
            [DatePicker setMaximumDate:expirydate];
        }
        
        Cancelbutton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPicker:)];
        
        [Cancelbutton setWidth:50];
        
        donebutton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(donePicker:)];
        
        [donebutton setWidth:50];
        
        CGRect frame = DatePicker.frame;
        
        frame.origin.y = self.view.frame.size.height - DatePicker.frame.size.height;
        
        frame.size.width = self.view.frame.size.width;
        
        DatePicker.frame = frame;
        
        DatePicker.backgroundColor = [UIColor lightGrayColor];
        
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- DatePicker.frame.size.height)-44, self.view.frame.size.width, 44)];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        toolbar.items = @[Cancelbutton,flexibleItem,donebutton];
        
        [self.view addSubview:toolbar];
        
        [self.view addSubview:DatePicker];
    }
}

-(void)cancelPicker:(UIBarButtonItem *)sender {
    
    [toolbar removeFromSuperview];
    
    [DatePicker removeFromSuperview];
}

-(void)donePicker:(UIBarButtonItem *)sender{
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    Date = [dateFormater stringFromDate:[DatePicker date]];
    
    Date = [@"  " stringByAppendingString:Date];
    
    [expiry_btn setTitle:Date forState:UIControlStateNormal];
    
    [toolbar removeFromSuperview];
    
    [DatePicker removeFromSuperview];
}

- (IBAction)tapSelectList:(id)sender {
    
    [toolbar removeFromSuperview];
    
    [DatePicker removeFromSuperview];
    
    [self.view addSubview:indicator];
    
    [listingArray removeAllObjects];
    
    NSDictionary *paramURL = @{@"member_id":member_id};
    
    [getListConn startConnectionWithString:@"select_whatson" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([getListConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 0) {
                
                NSArray *listArray = [receivedData valueForKey:@"merged_array"];
                
                NSString *listing, *listId;
                
                NSDictionary *dict;
                
                if (listArray.count < 1) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No member exits. Please add family member" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                } else {
                    
                    for (int i = 0; i < listArray.count; i++) {
                        
                        if ([[listArray objectAtIndex:i] valueForKey:@"CourseListing"]) {
                            
                            name = [[[listArray objectAtIndex:i] valueForKey:@"CourseListing"] valueForKey:@"course_name"];
                            
                            listId = [[[listArray objectAtIndex:i] valueForKey:@"CourseListing"] valueForKey:@"id"];
                            
                            expiryDate = [[[listArray objectAtIndex:i] valueForKey:@"CourseListing"] valueForKey:@"expiry_date"];
                            
                            Id = [[[listArray objectAtIndex:i] valueForKey:@"CourseListing"] valueForKey:@"id"];
                            
                            cityName = [[[listArray objectAtIndex:i] valueForKey:@"course_city"] valueForKey:@"city_name"];
                            
                            
                            listing = @"course";
                            
                            dict = @{@"name":name, @"list_id":listId, @"listing_type": listing,@"expiry_date":expiryDate,@"id":Id,@"city_name":cityName};
                            
                            
                            [listingArray addObject:dict];
                            
                        } else if ([[listArray objectAtIndex:i] valueForKey:@"LessonListing"]) {
                            
                            name = [[[listArray objectAtIndex:i] valueForKey:@"LessonListing"] valueForKey:@"lesson_name"];
                            
                            listId = [[[listArray objectAtIndex:i] valueForKey:@"LessonListing"] valueForKey:@"id"];
                            
                            expiryDate = [[[listArray objectAtIndex:i] valueForKey:@"LessonListing"] valueForKey:@"expiry_date"];
                            
                            Id =[[[listArray objectAtIndex:i] valueForKey:@"LessonListing"] valueForKey:@"id"];
                            
                            cityName = [[[listArray objectAtIndex:i] valueForKey:@"lesson_city"] valueForKey:@"city_name"];
                            
                            listing = @"lesson";
                            
                            dict = @{@"name":name, @"list_id":listId, @"listing_type": listing,@"expiry_date":expiryDate,@"id":Id,@"city_name":cityName};
                            
                            [listingArray addObject:dict];
                            
                        } else if ([[listArray objectAtIndex:i] valueForKey:@"EventListing"]) {
                            
                            name = [[[listArray objectAtIndex:i] valueForKey:@"EventListing"] valueForKey:@"event_name"];
                            
                            listId = [[[listArray objectAtIndex:i] valueForKey:@"EventListing"] valueForKey:@"id"];
                            
                            expiryDate = [[[listArray objectAtIndex:i] valueForKey:@"EventListing"] valueForKey:@"expiry_date"];
                            
                            Id = [[[listArray objectAtIndex:i] valueForKey:@"EventListing"] valueForKey:@"id"];
                            
                            cityName = [[[listArray objectAtIndex:i] valueForKey:@"event_city"] valueForKey:@"city_name"];
                            
                            listing = @"event";
                            
                            dict = @{@"name":name, @"list_id":listId, @"listing_type": listing,@"expiry_date":expiryDate,@"id":Id,@"city_name":cityName};
                            
                            [listingArray addObject:dict];
                        }
                    }
                    //“A new <category> <listing type> has just been posted in <City> for <Age Group>. Check it out. “
                    
                    [self showListData:[listingArray valueForKey:@"name"] allowMultipleSelection:NO selectedData:[selectListBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Select List"];
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

-(void)didSelectListItem:(id)item index:(NSInteger)index {
    
    name = [[listingArray objectAtIndex:index] valueForKey:@"name"];
    
    name = [@"  " stringByAppendingString:name];
    
    [selectListBtn setTitle:name forState:UIControlStateNormal];
    
    list_id = [[listingArray objectAtIndex:index] valueForKey:@"list_id"];
    
    type = [[listingArray objectAtIndex:index] valueForKey:@"listing_type"];
    
    expiryDate = [[listingArray objectAtIndex:index] valueForKey:@"expiry_date"];
    
    Id = [[listingArray objectAtIndex:index] valueForKey:@"id"];
    
    cityName = [[listingArray objectAtIndex:index] valueForKey:@"city_name"];
    
    [selectListBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    // NSString * listStr = [NSString stringWithFormat:@"A new %@ has just been posted in %@",[[listingArray objectAtIndex:index] valueForKey:@"listing"], [[listingArray objectAtIndex:index] valueForKey:@"city"]];
    
    //  listinfo_lbl.text = listStr;
    
    // NSString *typeSTR = [listStr stringByAppendingString:@"has just been posted in"];
    
    // NSString *cityStr = [typeSTR stringByAppendingString:[NSString stringWithFormat:@"%@",city]];
    //expiryDate = @"2015-06-20 00:00:00";
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)tap_expiry_btn:(id)sender {
    
    if (listingArray.count < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please select list first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self addPicker_toolBar];
        
        //        [toolbar removeFromSuperview];
        //
        //        [DatePicker removeFromSuperview];
    }
}

- (IBAction)tapPostBtn:(id)sender {
    
    NSString *my_text = @"0";
    
    NSString *message;
    
    if (!isTapAuto) {
        
        my_text = @"1";
        
        if ([message_textView.text isEqualToString:@"Write your message"] || [message_textView.text isEqualToString:@" "]) {
            
            message = @"Please enter the message";
        }
    }
    
    if ([selectListBtn.titleLabel.text isEqualToString:@"  Select a Listing to boost"]) {
        
        message = @"Please select the list";
        
    } else if (images.count<  1 ){
        
        message = @"Please select an image.";
    }
    
    
    
    // else if ([expiry_btn.titleLabel.text isEqualToString:@"  Select"]) {
    ////        message = @"Please select the expiry date";
    ////
    ////    }
    //    else if ([imgLbl.text isEqualToString:@"No Image Selected"]) {
    //
    //        message = @"Please select the image";
    //    }
    //
    Date = expiry_btn.titleLabel.text;
    
    Date = [Date stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.view addSubview:indicator];
        
        // @"expiry_date":Date
        
        /*
         course_name" = "Jim Institute Part 3"
         member_id, picture,  listing_type='course', list_id, (my_text=0 / my_text=1) {'0'=>'automatically generated description','1'=>'typed description'} description(in case of my_text=>1), expiry_date
         */
        
        // NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[images objectAtIndex:0]];
        
        //        if([type isEqualToString:@"course"]){
        //
        //
        //        } else if([ type isEqualToString:@"lesson"]){
        //
        //
        //        } else if([ type isEqualToString:@"event"]){
        //
        //        }
        
        if(expiryDate==nil){
            
            expiryDate = @"";
        }
        
        NSString *listType;
        
        listType = [type stringByAppendingString:@"_id"];
        
        NSDictionary *paramURL;
        
        
        NSString * CityName = @" [";
        
        CityName = [CityName stringByAppendingString:[type capitalizedString]];
        
        CityName = [CityName stringByAppendingString:@" | "];
        
        CityName = [CityName stringByAppendingString:cityName];
        
        CityName = [CityName stringByAppendingString:@"]"];
        
        
        if ([my_text isEqualToString:@"1"]) {
            
            paramURL = @{@"member_id": member_id, @"description":message_textView.text, @"listing_type":type, @"list_id":list_id, @"my_text":@"1",@"name":name,listType:Id,@"expiry_date":expiryDate,@"city_name":CityName};
            
        } else {
            
            paramURL = @{@"member_id": member_id, @"listing_type":type, @"list_id":list_id, @"my_text":@"0",@"name":name,listType:Id,@"expiry_date":expiryDate,@"city_name":CityName};
        }
        
        NSLog(@"%@",paramURL);
        
        
        //[whatsOnPostConn startConnectionWithString:@"whatson_post"  HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        //[whatsOnPostConn startConnectionToUploadMultipleImagesWithString:@"whatson_post" images:images HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData)
        
        
        [whatsOnPostConn startConnectionToUploadMultipleImagesWithString:@"whatson_post" images:images HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            NSLog(@"%@", receivedData);
            
            if ([whatsOnPostConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                //                TabBarViewController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"whatsonVC"]
                //                tbc.selectedIndex=1;
                //               [self presentViewController:tbc animated:YES completion:nil];
                //                self.tabBarController.selectedViewController =   [self.tabBarController.viewControllers objectAtIndex:1];
                
                if(tapWhatsOn_list){
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    tapWhatsOn_list = NO;
                    
                } else {
                    
                    UIStoryboard * storyboard = self.storyboard;
                    
                    myWhatson = [storyboard instantiateViewControllerWithIdentifier:@"MyWhatsOnVC"];
                    
                    [self.navigationController pushViewController:myWhatson animated:YES];
                }
                
                //[self.navigationController popViewControllerAnimated:YES];
                
                //You have successfully created your "What's On!". But for other members to see it, you should now click the 'post' icon on this "What's On!" item
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"You have successfully created your \"What's On!\". But for other members to see it, you should now click the 'post' icon on this \"What's On!\" item" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }];
    }
    //member_id, picture, description, listing_type='course', list_id, (my_text=0 / my_test=1) {'0'=>'automatically generated description','1'=>'typed description'}
}

- (IBAction)tapCancelBtn:(id)sender {
    
    // [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapAutoMsgBtn:(id)sender {
    
    isTapAuto = YES;
    
    CGRect frame = btnView.frame;
    
    frame.origin.y = msgTextFrame.origin.y + 20;
    
    btnView.frame = frame;
    
    message_textView.hidden = YES;
    
    charLimit_lbl.hidden = YES;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, frame.origin.y + 50);
    
    [customBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    [auto_msgBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    //     frame = orLbl.frame;
    //    frame.origin.y = listinfo_lbl.frame.origin.y+orLbl.frame.size.height+30;
    //    orLbl.frame = frame;
    
    // listinfo_lbl.hidden = NO;
    
}

- (IBAction)tapCustomMsgBtn:(id)sender {
    
    // if (isTapAuto) {
    
    message_textView.hidden = NO;
    
    //charLimit_lbl.hidden = NO;
    
    CGRect frame = btnView.frame;
    
    //frame.origin.y = msgTextFrame.origin.y + msgTextFrame.size.height + 20;
    
    frame.origin.y = charLimit_lbl.frame.origin.y + charLimit_lbl.frame.size.height +20;
    
    
    btnView.frame = frame;
    
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, frame.origin.y + 100);
    
    isTapAuto = NO;
    
    [customBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    
    [auto_msgBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    //  listinfo_lbl.hidden = YES;
    
    //        frame = orLbl.frame;
    //
    //        frame.origin.y = (listinfo_lbl.frame.origin.y+listinfo_lbl.frame.size.height/2);
    //
    //        orLbl.frame = frame;
    
    
    //}
}

#pragma mark - UIPickerView For Camera

-(void)openPictureViewWithCamera:(BOOL)camera {
    
    imagePicker =[[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if (camera) {
        
        imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        
        [self performSelector: @selector(showPhotoGallery) withObject: nil afterDelay: 0];
    }
    else {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        // imagePicker.allowsEditing = YES;
        
        [self performSelector: @selector(showPhotoGallery) withObject: nil afterDelay: 0];
    }
}

- (void) showPhotoGallery {
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"%@", info);
    
    if (![[UIApplication sharedApplication] isStatusBarHidden])
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    UIImage *imagePickedFromLib,*image;
    
    NSURL *mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    long size;
    
    if (mediaUrl == nil) {
        
        
        // imagePickedFromLib = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        
        image = [info valueForKey:UIImagePickerControllerEditedImage];
        
        picture = UIImageJPEGRepresentation(image, 0.7);
        
        size = [picture length];
        
        if(size > 80680){
            
            imagePickedFromLib = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerEditedImage]];
            
        } else {
            
            imagePickedFromLib = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
            
        }
        
        if (imagePickedFromLib == nil) {
            
            
            // imagePickedFromLib = (UIImage *)[info valueForKey:                                             UIImagePickerControllerOriginalImage];
            
            image = (UIImage *)[info valueForKey:                                             UIImagePickerControllerOriginalImage];
            
            picture = UIImageJPEGRepresentation(image, 0.7);
            
            size = [picture length];
            
            if(size > 80680){
                
                imagePickedFromLib = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerOriginalImage]];
                
            } else {
                
                imagePickedFromLib = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
                
            }
            
            
            [img_view setImage:imagePickedFromLib];
            
        } else {
            
            [img_view setImage:imagePickedFromLib];
        }
        
        imgLbl.text = @"Image Attached";
    }
    
    
    
    img_view.backgroundColor = [UIColor clearColor];
    
    //images = [[NSMutableArray alloc] init];
    
    NSString *imagen = @"picture";
    
    picture = UIImageJPEGRepresentation(imagePickedFromLib, 0.7);
    
    size = [picture length];
    
    
    images =@[@{@"fieldName" : imagen, @"fileName" : imagen, @"imageData" : picture }];
    
    
    // images = @[@{@"fieldName" : imagen, @"fileName" :@"assest.jpeg", @"imageData" : UIImageJPEGRepresentation(imagePickedFromLib, 0.7),@"fileType":@"image/jpeg"}];
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


// imagePickedFromLib = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerEditedImage]];
- (UIImage *)scaleAndRotateImage:(UIImage *) image {
    int kMaxResolution = 512;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

#pragma mark - UITextView Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    //return [text isEqualToString:filtered];
    
    //  return TRUE;
    
    charLimit_lbl.hidden = NO;
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    
    NSString *newText = [ textView.text stringByReplacingCharactersInRange: range withString: text ];
    
    long len = 116 - [newText length];
    
    if(len < 0){
        
        len = 0;
    }
    
    charLimit_lbl.text = [NSString stringWithFormat:@"%ld characters left",len];
    
    NSString *leftChar = [NSString stringWithFormat:@"%lu", len];
    
    leftChar = [leftChar stringByAppendingString:@" characters left"];
    
    if( [newText length]<= 115 ){
        
        return TRUE;
        
    } else {
        
        return false;
    }
    
    
    // return true;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"Write your message";
        
        textView.textColor = UIColorFromRGB(placeholder_text_color_hexcode);
    }
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = 0;
    
    self.view.frame = frame;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Write your message"]) {
        
        textView.text = @"";
    }
    
    textView.textColor = [UIColor darkGrayColor];
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = -y;
    
    self.view.frame = frame;
}


#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 1)           //Camera
    {
        if (buttonIndex == 0)
        {
            [self openPictureViewWithCamera:YES];
        }
        else if(buttonIndex == 1)
        {
            [self openPictureViewWithCamera:NO];
        }
    }
    else if (actionSheet.tag == 2)      //without camera
    {
        if (buttonIndex == 0) {
            
            [self openPictureViewWithCamera:NO];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)tapChooseImg:(id)sender {
    
    UIActionSheet * actionSheetForImage = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        actionSheetForImage = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Use Gallery", nil];
        [actionSheetForImage setTag:1];
    }
    else {
        
        actionSheetForImage = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery", nil];
        
        [actionSheetForImage setTag:2];
    }
    
    [actionSheetForImage showInView:self.view];
    
}

@end