//
//  LinkedInShareViewController.m
//  ecaHUB
//
//  Created by promatics on 4/23/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "LinkedInShareViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"

@interface LinkedInShareViewController ()<UIWebViewDelegate>{

    WebServiceConnection *conn;
    
    Indicator *indicator;
    
    BOOL step1;
    
    NSString *title;
    
    NSString *caption;
    
    NSIndexPath *selected_row;
}

@end

@implementation LinkedInShareViewController

@synthesize linkedInWebView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"LinkedIn Share";
    
    indicator = [[Indicator alloc] initWithFrame:self.view.bounds];
    
    conn = [WebServiceConnection connectionManager];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"linkinShare"];
    
    step1 = false;
    
    [self getAuthorizationCode];
}
-(void)getAuthorizationCode{

    NSString *authorizeURL = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=78imindwbpf3mg&redirect_uri=http%3A%2F%2Fmercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect&state=ecaHub987654321&scope=r_fullprofile%20r_emailaddress%20w_share";
    
    [self.linkedInWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authorizeURL]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    /*if (webView.request.URL.absoluteString isEqualToString:@"http://europa.promaticstecnologies.com/socialfit360")*/
    
    if ([webView.request.URL.absoluteString rangeOfString:@"ecaHub"].location != NSNotFound && step1) {
        
        [self exchangeAuthCode:webView.request.URL.absoluteString];
 
    }
    step1 = true;
}
-(void)exchangeAuthCode:(NSString*)url {
    
    step1 = true;
    
    NSString *fullUrlString = url;
    
    NSArray *arr = [fullUrlString componentsSeparatedByString:@"?"];

    NSString *resultString = arr[1];
    
    NSArray *arr2 = [resultString componentsSeparatedByString:@"&"];
    
    NSString *userCred = arr2[0];
    
    NSArray *arr3 = [userCred componentsSeparatedByString:@"="];
    
    NSString *code= @"";
    
    if ([arr3[0] isEqualToString:@"code"])
    {
        code = arr3[1];

        NSString *redirect_uri = @"http://mercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect";

        NSString *client_id = @"78imindwbpf3mg";

        NSString *client_secret = @"G5Wl3zAe4ZcoHqGW";

        NSDictionary *urlParam = @{
                                   @"grant_type":@"authorization_code",
                                   @"code":code,
                                   @"redirect_uri":redirect_uri,
                                   @"client_id" :client_id,
                                   @"client_secret" :client_secret
                                   };
        
        NSLog(@"%@",urlParam);
        
        [conn startConnectionWithStringLi:[NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData)
         {
   
             [indicator removeFromSuperview];
             
             if([conn responseCode]==1)
             {
                 [self shareData:[receivedData valueForKey:@"access_token"]];
             }
         }];
    }
}

- (void)shareData:(NSString*)token{

    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"linkedInToken"];
    
 //   NSDictionary *dict = @{@"title":listing_name.text, @"description": course_dscriptionTxtView.text, @"img_url":img_url};
    
   // [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"linkedInShareData"];
    
    NSString *img_url = [[[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInShareData"] valueForKey:@"img_url"];
    
    title = [[[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInShareData"] valueForKey:@"title"];
    
    caption = [[[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInShareData"] valueForKey:@"description"];
    
    NSDictionary *urlParam = @{@"comment": @"www.ecaHUB.com",
                               @"content": @{
                                   @"title": title,
                                   @"description": caption,
                                   @"submitted-url": @"http://mercury.promaticstechnologies.com/ecaHub/",
                                  @"submitted-image-url":img_url
                               },
                               @"visibility": @{
                                   @"code": @"anyone"
                               }
                               };
    NSLog(@"%@",urlParam);
    
    [conn startLinkedInConnectionWithString:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/shares?format=json"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData) {
        
         [indicator removeFromSuperview];

         if([conn responseCode]==1) {
             
             [self.navigationController popViewControllerAnimated:YES];
             
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Successfully share" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             
             [alert show];
             
             NSLog(@"%@", receivedData);
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
