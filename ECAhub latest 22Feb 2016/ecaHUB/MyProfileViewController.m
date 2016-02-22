//
//  MyProfileViewController.m
//  ecaHUB
//
//  Created by promatics on 3/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "MyProfileViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"

@interface MyProfileViewController () {
    
    WebServiceConnection *myProfileConnection;
    
    Indicator *indicator;
    
    DateConversion *dateConversion;
}
@end

@implementation MyProfileViewController

@synthesize profile_img, profile_imgView, user_name, family_name, fname, dob, gender, about_me, phone_no, city, mainView, state, country, scroll_view,acoountID,email;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     //self.navigationController.navigationBar.topItem.title = @"";
    
    dateConversion = [DateConversion dateConversionManager];
    
    UIStoryboard *storyboard;
    
    CGFloat y;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        profile_imgView.layer.cornerRadius = 75.0f;
        
        profile_imgView.layer.borderWidth = 12.0f;
        
        scroll_view.frame = self.view.frame;
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        
        y = 0;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        profile_imgView.layer.cornerRadius = 40.0f;
        
        profile_imgView.layer.borderWidth = 6.0f;
        
        scroll_view.frame = self.view.frame;
    
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, 625);
        
        y = -64;
    }
    
    CGRect frame = mainView.frame ;
    
    frame.origin.y = y;
    
    mainView.frame = frame;
    
//    frame = profile_imgView.frame ;
//    
//    frame.origin.x = (scroll_view.frame.size.width-frame.size.width/2);
//    
//    user_name.frame = frame;

    profile_imgView.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Text_colore"]].CGColor;
    
    myProfileConnection = [WebServiceConnection connectionManager];
    
    mainView.hidden = YES;
    
//    [self fetchUpdateUserData];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self fetchUpdateUserData];
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
            
            mainView.hidden = NO;
            
            NSString *lastName = [[receivedData valueForKey:@"Member"] valueForKey:@"last_name"];
            
            NSString *Fullname = [lastName substringToIndex:1];
            
            Fullname = [Fullname stringByAppendingString:@"."];
            
            Fullname = [@" " stringByAppendingString:Fullname];
            
            Fullname = [[[receivedData valueForKey:@"Member"] valueForKey:@"first_name"] stringByAppendingString:Fullname];
            
            user_name.text = Fullname;
            
            fname.text = [[receivedData valueForKey:@"Member"] valueForKey:@"first_name"];
            
            family_name.text = [[receivedData valueForKey:@"Member"] valueForKey:@"last_name"];
            
            acoountID.text = [[receivedData valueForKey:@"Member"] valueForKey:@"account_number"];
            
            email.text = [[receivedData valueForKey:@"Member"] valueForKey:@"email"];
            
            NSString *date = [[receivedData valueForKey:@"Member"] valueForKey:@"birth_date"];
            
            if ([date isEqualToString:@"0000-00-00"]) {
                
                dob.text = @"";
            }
            
            else if ([date length] > 1) {
                
               dob.text = [dateConversion convertDate:date];
                
            }
            phone_no.text = [[[[receivedData valueForKey:@"Country"] valueForKey:@"phone_code"]stringByAppendingString:@" "]stringByAppendingString:[[receivedData valueForKey:@"Member"] valueForKey:@"phone"]];
            
            gender.text = [[receivedData valueForKey:@"Member"] valueForKey:@"gender"];
            
            CGFloat height = [self heightCalculate:[[receivedData valueForKey:@"Member"] valueForKey:@"about_me"]];
            
            CGRect frame = about_me.frame;
            
            frame.size.height = height;
            
            frame.size.width = mainView.frame.size.width - frame.origin.x - 10;
            
            about_me.frame = frame;
            
            scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, frame.origin.y + height + 30);
            
            [about_me setLineBreakMode:NSLineBreakByClipping];
            
            [about_me  setNumberOfLines:0];
            
            [about_me  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
            
            [about_me setFont:[UIFont systemFontOfSize:17]];
            
            if ([[[receivedData valueForKey:@"Member"] valueForKey:@"about_me"] isEqualToString:@""]) {
                
                about_me.text = @"About me...anything to tell others why you are on ECAhub. This is totally optional.";
            }
            
            about_me.text = [[receivedData valueForKey:@"Member"] valueForKey:@"about_me"];
            
            state.text = [[receivedData valueForKey:@"State"] valueForKey:@"state_name"];
            
            country.text = [[receivedData valueForKey:@"Country"] valueForKey:@"country_name"];
            
            NSString *profileImage = [[receivedData valueForKey:@"Member"] valueForKey:@"picture"];
            
            profileImage = [profileImage stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceCharacterSet]];
            
            if ([profileImage length] > 1) {
                
                profileImage = [profilePicURL stringByAppendingString:profileImage];
                
                [self downloadImageWithString:profileImage];
            
            } else {
                
                profile_img.image = [UIImage imageNamed:@"user_img"];
            }
            
            id cityName = [[receivedData valueForKey:@"City"] valueForKey:@"city_name"];
            
            if ([cityName isKindOfClass:[NSNull class]]) {
                
                city.text = @"";
                
            } else {
            
                city.text = [[receivedData valueForKey:@"City"] valueForKey:@"city_name"];
            }
        }
    }];
}

-(CGFloat)heightCalculate:(NSString *)calculateText{
    
    UILabel *lable = [[UILabel alloc] initWithFrame: about_me.frame];
    
    [lable setLineBreakMode:NSLineBreakByClipping];
    
    [lable  setNumberOfLines:0];
    
    [lable  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [lable setFont:[UIFont systemFontOfSize:17]];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width - (1.0 * 2), FLT_MAX);
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect lable_frame = lable.frame;
    
    lable_frame.size.height = size.height + 10;
    
    [lable  setFrame:lable_frame];
    
   // [lable sizeToFit];
    
    NSLog(@"%f",lable_frame.origin.y);
    
    CGFloat height_lbl = size.height;
    
    NSLog(@"%f",height_lbl);
    
    return height_lbl;
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
                        
            profile_img.image = image;
            
            profile_img.layer.cornerRadius = 40;
        }
    }];
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
