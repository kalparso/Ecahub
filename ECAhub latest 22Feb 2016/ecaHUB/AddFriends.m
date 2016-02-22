
//
//  AddFriends.m
//  ecaHUB
//
//  Created by promatics on 3/31/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AddFriends.h"
#import "PopUpView.h"
#import "searchprefrnce.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "myFriendTableViewCell.h"
#import "FriendlistingTableViewCell.h"
#import "SendMessageView.h"
#import "TabBarViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FindRegisteredFriendsViewController.h"

@interface AddFriends () {
    
    PopUpView *pop_view;
    
    UIStoryboard *storyboard;
    
    TabBarViewController *tabbar;
    
    WebServiceConnection *gmailConn;
    
    WebServiceConnection *inviteConn;
    
    WebServiceConnection *getGmailContactConn;
    
    WebServiceConnection *tellFrndConn,*fbconn;
    
    Indicator *indicator;
    
    Validation *validateObj;
    
    myFriendTableViewCell *friendCell;
    
    FriendlistingTableViewCell *listingCell;
    
    GPPSignIn *signIn;
    
    NSMutableArray *contactsArray, *friendArray, *friendListingArray, *inviteEmailArray, *tellFriendArray;
    
    NSString *member_first_name, *member_id, *gmailToken;
    
    BOOL isSelectAll, isSelectAllFrnd;
    
    SendMessageView *sendMsgView;
    
    NSArray *fb_id;
    
    NSMutableDictionary *fbDict;
    
    NSMutableArray *fbfriendsArray;
    
    bool isTapFb;
    
    
}
@end

@implementation AddFriends

@synthesize scroll_view, sendBtn, friendList_tbl, myFrnd_tbl, email, selectAllBtn, sendInvitationBtn, selectAllFriendBtn, tellYourFrndBtn,subView,skipBtn;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
  //  [[NSUserDefaults standardUserDefaults]delete:@"myPassFrndsArr"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    fbDict = [[NSMutableDictionary alloc]init];
    
    fbfriendsArray = [[NSMutableArray alloc]init];
    
//    if (![[[NSUserDefaults standardUserDefaults]valueForKey:@"inviteFriendNever"] isEqualToString:@"1"]) {
    
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"Sharing Is Caring! Share ECAhub discoveries with friends and even enroll yourselves or your kids in activities together.                                                                              See which friends of yours are on ECAhub." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:@"Later", nil];
        
        alertview.tag = 1;
        
        [alertview show];
        
        
   // }
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.rightBarButtonItem = skipBtn;
    
    subView.hidden = YES;
    
    sendBtn.hidden = YES;
    
    email.hidden= YES;
    
    self.title = @"My Friends";
    
    friendList_tbl.editing = YES;
    
    myFrnd_tbl.editing = YES;
    
    isSelectAll = NO;
    
    isSelectAllFrnd = NO;
    
    [selectAllBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    [selectAllFriendBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    [friendList_tbl setAllowsMultipleSelection:YES];
    
    [myFrnd_tbl setAllowsMultipleSelection:YES];
    
    inviteEmailArray = [[NSMutableArray alloc] init];
    
    tellFriendArray = [[NSMutableArray alloc] init];
    
    inviteConn = [WebServiceConnection connectionManager];
    
    tellFrndConn = [WebServiceConnection connectionManager];
    
    fbconn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    validateObj = [Validation validationManager];
    
    getGmailContactConn = [WebServiceConnection connectionManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapLater:) name:@"tapLaterAddFriends" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchHotMailContacts:) name:@"fetchHotMailContacts" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchGMailContacts:) name:@"fetchGMailContacts" object:nil];
    
    scroll_view.frame = self.view.frame;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGFloat hieght = 45.0f;
        
        CGRect frameRect = email.frame;
        frameRect.size.height = hieght;
        email.frame = frameRect;
        
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, 600);
    }
    
    sendInvitationBtn.layer.cornerRadius = 5.0f;
    
    tellYourFrndBtn.layer.cornerRadius = 5.0f;
    
    selectAllBtn.layer.borderWidth = 0.7f;
    
    selectAllBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    selectAllBtn.layer.cornerRadius = selectAllBtn.frame.size.width/2;
    
    selectAllFriendBtn.layer.borderWidth = 0.7f;
    
    selectAllFriendBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    selectAllFriendBtn.layer.cornerRadius = selectAllFriendBtn.frame.size.width/2;
    
    sendBtn.layer.cornerRadius = 5.0f;
    
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
//        
//        pop_view = [[[NSBundle mainBundle] loadNibNamed:@"popup" owner:self options:nil] objectAtIndex:0];
//        
//        pop_view.frame = self.view.frame;
//        pop_view.VC = @"2";
//        pop_view.remind_label.hidden = YES;
//        pop_view.checkbox_buttn.hidden = YES;
//        
//        pop_view.message.text = @"Sharing is caring. Share ECAhub discoveries privately with friends and even enroll yourselves or your kids in activities together. Start by telling your friends you are here.";
//        
//        [self.view addSubview:pop_view];
//    }
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    member_first_name = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"PayPal"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier]isEqualToString:@"FindRegisteredFriend"]) {
  
    FindRegisteredFriendsViewController *findVC = [segue destinationViewController];
    
    findVC.isfb = isTapFb;
        
    }
    
}


-(void) tapLater:(NSNotification *)notification {
    
    //[self performSegueWithIdentifier:@"addSearchPref" sender:self];
    
        storyboard = self.storyboard;
    
        tabbar = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
    
        [self presentViewController:tabbar animated:YES completion:nil];
    
        NSString *message = @"Welcome to ECAhub! Before you get started, please check your email inbox and junk mail folder for the verification email sent to you.";
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark- UITextfielDelegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return true;
}

- (IBAction)tapSendInvitaion:(id)sender {
    
    if ([inviteEmailArray count] < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select atleast one contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self sendInvitaion];
    }
}

#pragma mark- Select All

- (IBAction)tapSelectAll:(id)sender {
    
    inviteEmailArray = [[NSMutableArray alloc] init];
    
    if (isSelectAll) {
        
        NSMutableArray *selectedData = [friendListingArray mutableCopy];
        
        for (NSString *data in selectedData) {
            
            [friendList_tbl deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[friendListingArray indexOfObject:data] inSection:0] animated:NO];
        }
        
        [inviteEmailArray removeAllObjects];
        
        isSelectAll = NO;
        
        [selectAllBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
    } else {
        
        NSMutableArray *selectedData = [friendListingArray mutableCopy];
        
        for (NSString *data in selectedData) {
            
            [friendList_tbl selectRowAtIndexPath:[NSIndexPath indexPathForRow:[friendListingArray indexOfObject:data] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        [selectAllBtn setBackgroundImage:[UIImage imageNamed:@"Check_Mark"] forState:UIControlStateNormal];
        
        [inviteEmailArray addObjectsFromArray:friendListingArray];
        
        isSelectAll = YES;
    }
}

#pragma mark - Tell Friends

-(void)tellYourFriends {
    
    [self.view addSubview:indicator];
    
    NSMutableDictionary *paramURL = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < tellFriendArray.count; i++) {
        
        [keys addObject:[NSString stringWithFormat:@"email[%d]",i]];
    }
    
    [keys addObject:@"member_id"];
    
    [keys addObject:@"member_first_name"];
    
    [tellFriendArray addObject:member_id];
    
    [tellFriendArray addObject:member_first_name];
    
    paramURL = [NSMutableDictionary dictionaryWithObjects:tellFriendArray forKeys:keys];
    
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
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Message sends successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }];
}

- (IBAction)tapTellYourFriendBtn:(id)sender {
    
    if ([tellFriendArray count] < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select atleast one contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self tellYourFriends];
    }
}

- (IBAction)tapSelectAllFrndBtn:(id)sender {
    
    tellFriendArray = [[NSMutableArray alloc] init];
    
    if (isSelectAllFrnd) {
        
        NSMutableArray *selectedData = [friendArray mutableCopy];
        
        for (NSString *data in selectedData) {
            
            [myFrnd_tbl deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[friendArray indexOfObject:data] inSection:0] animated:NO];
        }
        
        [tellFriendArray removeAllObjects];
        
        isSelectAllFrnd = NO;
        
        [selectAllFriendBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
    } else {
        
        NSMutableArray *selectedData = [friendArray mutableCopy];
        
        for (NSString *data in selectedData) {
            
            [myFrnd_tbl selectRowAtIndexPath:[NSIndexPath indexPathForRow:[friendArray indexOfObject:data] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
        [selectAllFriendBtn setBackgroundImage:[UIImage imageNamed:@"Check_Mark"] forState:UIControlStateNormal];
        
        [tellFriendArray addObjectsFromArray:friendArray];
        
        isSelectAllFrnd = YES;
    }
}

#pragma mark - Gmail Contact

-(void)fetchGMailContacts :(NSNotification *) notification {
    
    gmailConn = [WebServiceConnection connectionManager];
    
    signIn = [GPPSignIn sharedInstance];
    
    signIn.delegate = self;
    
    NSDictionary *data = [notification object];
    
    NSLog(@"%@",data);
    
    NSString *kClientID = @"826883180395-5as7fj9lg65ekt1s0jtu8l2i5jrs363t.apps.googleusercontent.com";
    
    NSString *redirect_uri = @"http://mercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect";
    
    NSString *client_secret = @"9qAnx8ppdN4rkP4GMI_CVMxk";
    
    NSString *code = [data valueForKey:@"code"];
    
    NSDictionary *urlParam = @{@"client_id":kClientID, @"redirect_uri":redirect_uri, @"grant_type":@"authorization_code", @"client_secret":client_secret, @"code":code};
    
    NSLog(@"%@",urlParam);
    
    [self.view addSubview:indicator];
    
    //https://www.googleapis.com/oauth2/v3/token
    
    [gmailConn startConnectionWithGMail:[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v3/token"] HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([gmailConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            NSString *token = [receivedData valueForKey:@"access_token"];
            
            gmailToken = token;
            
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"GmailToken"];
            
            [self getGmailContacts];
            
            [[GPPSignIn sharedInstance] signOut];
            
            [[GPPSignIn sharedInstance] disconnect];
        }
    }];
}

-(void)logOutGmail {
    
    NSString *url = @"https://accounts.google.com/o/oauth2/revoke?token=";
    
    url = [url stringByAppendingString:gmailToken];
    
    [gmailConn startGmailConnectionWithString:[NSString stringWithFormat:@"%@",url] HttpMethodType:Get_type HttpBodyType:@{} Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([gmailConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
        }
    }];
}

-(void)getGmailContacts {
    
    [self.view addSubview:indicator];
    
    [getGmailContactConn startGmailConnectionWithString:[NSString stringWithFormat:@"https://www.google.com/m8/feeds/contacts/default/full?v=3&alt=json"] HttpMethodType:Get_type HttpBodyType:@{} Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([getGmailContactConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            contactsArray = [[NSMutableArray alloc] init];
            
            NSArray *arr = [[[[receivedData valueForKey:@"feed"] valueForKey:@"entry"] valueForKey:@"gd$email"] valueForKey:@"address"];
            
            for (int i = 0; i < arr.count; i++) {
                
                [contactsArray addObject:[[arr objectAtIndex:i] objectAtIndex:0]];
            }
            NSLog(@"%@", contactsArray);
            
            [self getRegisterMember:contactsArray];
        }
    }];
}

- (IBAction)tapGmailBtn:(id)sender {
    
    //NSString *kClientID = @"826883180395-bcuk9vv9h8p1sl09gm6mnoujh5r5lqc5.apps.googleusercontent.com";
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"Gmail"];
    
    NSString* launchUrl = @"https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=826883180395-5as7fj9lg65ekt1s0jtu8l2i5jrs363t.apps.googleusercontent.com&scope=https://www.googleapis.com/auth/contacts.readonly&state=1&redirect_uri=http%3A%2F%2Fmercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation {
    
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (IBAction)tapYmailBtn:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Gmail"];
    
    [self createYahooSession];
}

- (void)createYahooSession
{
    // Create session with consumer key, secret, application ID and callback URL
    
    NSString *Client_ID = @"dj0yJmk9dU5SQ1lJNno5YnJiJmQ9WVdrOWFrTk5kMFpvTkRRbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD0xMA--";
    
    NSString *Client_Secret = @"3fff7514e5a4d6a29da9797cf13d80fd42c45756";
    
    NSString*app_id = @"jCMwFh44";
    
    self.session = [YahooSession sessionWithConsumerKey:Client_ID
                                      andConsumerSecret:Client_Secret
                                       andApplicationId:app_id
                                         andCallbackUrl:@"https://mercury.promaticstechnologies.com/ecaHub/"
                                            andDelegate:self];
    // Try to resume a user session if one exists
    BOOL hasSession = [self.session resumeSession];
    
    // No session detected, send user to sign-in and authorization page
    if(!hasSession) {
        
        [self.session sendUserToAuthorization];
        // Session detected, user is already signed-in begin requests
    } else {
        NSLog(@"Session detected!");
        // Send authenticated requests to Yahoo APIs here...
        
        [self sendRequests];
    }
}

- (void)didReceiveAuthorization
{
    [self createYahooSession];
}

- (void)sendRequests
{
    // Initialize contact list request
    YOSUserRequest *request = [YOSUserRequest requestWithSession:self.session];
    
    // Fetch the user's contact list
    [request fetchContactsWithStart:0 andCount:300 withDelegate:self];
}

- (void)requestDidFinishLoading:(YOSResponseData *)data
{
    // Get the JSON response, will exist ONLY if requested response is JSON
    // If JSON does not exist, use data.responseText for NSString response
    NSDictionary *json = data.responseJSONDict;
    
    NSDictionary *contactDict = json[@"contacts"];
    if (contactDict) {
        NSLog(@"Contact list fetched");
        NSLog(@"%@",contactDict);
    }
    NSMutableArray *email_array = [[NSMutableArray alloc] init];
    NSArray *contactArray = [contactDict valueForKey:@"contact"];
    
    for (int i=0; i< contactArray.count; i++) {
        
        NSString *emailStr ;
        
        if ([[[contactArray objectAtIndex:i] valueForKey:@"fields"] count] > 1 ) {
            
            emailStr = [[[[contactArray objectAtIndex:i] valueForKey:@"fields"] objectAtIndex:1] valueForKey:@"value"];
        } else {
            
            emailStr = [[[[contactArray objectAtIndex:i] valueForKey:@"fields"] objectAtIndex:0] valueForKey:@"value"];
        }
        
        [email_array addObject:emailStr];
    }
    
    NSLog(@"%@",email_array);
    
    if ([email_array count] < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No contact found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        [self.session clearSession];
    }
    
    [self.session clearSession];
    
    contactsArray = [email_array mutableCopy];
    
    NSLog(@"%@",contactsArray);
    
    [self getRegisterMember:contactsArray];
}

- (IBAction)tapOutlokkBtn:(id)sender {
    
    //[self tapHotmailBtn:self];
    
    if ([FBSDKAccessToken currentAccessToken]){
        
        [FBSDKAccessToken setCurrentAccessToken:nil];
      
    }
    else{
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile",@"user_friends"]
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 
                 NSLog(@"%@",result);
                 
                 NSLog(@"%@",FBSDKAccessToken.currentAccessToken);
                 
                 FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me?fields=id,name,email,birthday,first_name,last_name,gender,picture,friends" parameters:nil  HTTPMethod:@"GET"];
               
                 [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     NSLog(@"Data%@",result);
                     
                     if ([result isKindOfClass:[NSDictionary class]]) {
                         
                         NSDictionary *data = result;
                         
                         
                         fb_id = [[data objectForKey:@"friends"]valueForKey:@"data"];
                         
                         [self fetchfbfriends];
                        
                         
                     }
                     
                        [login logOut];
                     // Insert your code heref
                 }];
                 
                 
             }
             [FBSDKAccessToken setCurrentAccessToken:nil];
         }];
    }
    
    
}

-(void)fetchfbfriends{
    
    NSMutableDictionary *paramURL;
    
    paramURL = [[NSMutableDictionary alloc]init];
    
    for (int i=0; i<[fb_id count]; i++) {
        
        [paramURL setValue:[[fb_id objectAtIndex:i]valueForKey:@"id"]forKey:[NSString stringWithFormat:@"facebook_id[%d]",i]];
        
    }
    
    NSLog(@"%@", paramURL);
    
    [self.view addSubview:indicator];
    
    [fbconn startConnectionWithString:@"member_data_facebook" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([fbconn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            NSArray *fbArray = [receivedData valueForKey:@"info"];
            
            if ([[receivedData valueForKey:@"code"]isEqual:@"1"]) {
                
                if ([fbArray count]>0) {
                    
                    for (int i =0; i< [fbArray count]; i++) {
                        
                        [fbfriendsArray addObject:[[[fbArray objectAtIndex:i]valueForKey:@"Member"]valueForKey:@"email"]];
                        
                    }
                
            }
           
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:fbfriendsArray forKey:@"fbArray"];
            
            isTapFb = YES;
            
            [self performSegueWithIdentifier:@"FindRegisteredFriend" sender:self];
           
        }
        
        }];
}

- (IBAction)tapHotmailBtn:(id)sender {
    
    //https://login.live.com/oauth20_authorize.srf?client_id=CLIENT_ID&scope=wl.signin+wl.basic+wl.contacts_emails&response_type=code&redirect_uri=REDIRECT_URL
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"Hotmail"];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Gmail"];
    
    NSString*url = @"https://login.live.com/oauth20_authorize.srf?client_id=0000000048154773&scope=wl.contacts_emails&response_type=code&redirect_uri=http://mercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

- (IBAction)tapSendBtn:(id)sender {
    //invite_friends
    
    NSString *message;
    
    if (![validateObj validateEmail:email.text]) {
        
        message = @"Please enter valid email";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
    } else {
        
        [inviteEmailArray addObject:email.text];
        
        [self sendInvitaion];
    }
    
}

-(void)sendInvitaion {
    
    [self.view addSubview:indicator];
    
    NSMutableDictionary *paramURL = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < inviteEmailArray.count; i++) {
        
        [keys addObject:[NSString stringWithFormat:@"email[%d]",i]];
    }
    
    [keys addObject:@"member_id"];
    
    [keys addObject:@"member_first_name"];
    
    [keys addObject:@"total"];
    
    NSString *str = [NSString stringWithFormat:@"%lu", (unsigned long)inviteEmailArray.count];
    
    [inviteEmailArray addObject:member_id];
    
    [inviteEmailArray addObject:member_first_name];
    
    [inviteEmailArray addObject:str];
    
    paramURL = [NSMutableDictionary dictionaryWithObjects:inviteEmailArray forKeys:keys];
    
    NSLog(@"%@", paramURL);
    
    // NSDictionary *urlParam = @{@"email":inviteEmailArray, @"member_id":member_id, @"member_first_name":member_first_name};
    
    [inviteConn startConnectionWithString:@"invite_friends" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([inviteConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
                
                storyboard = self.storyboard;
                
                tabbar = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
                
                [self presentViewController:tabbar animated:YES completion:nil];
                
                NSString *message = @"Welcome to ECAhub! Before you get started, please check your email inbox and junk mail folder for the verification email sent to you.";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
            }
              if (isSelectAll) {
                
                friendArray = [@[] mutableCopy];
                
                friendListingArray = [@[] mutableCopy];
                
                [myFrnd_tbl reloadData];
                
                [friendList_tbl reloadData];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Invitation sends successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }];
}

-(void)fetchHotMailContacts :(NSNotification *) notification {
    
    NSString *link_url = [notification object];
    
    NSLog(@"%@",link_url);
    
    NSArray *stringArray = [link_url componentsSeparatedByString:@"code="];
    
    NSString *state= [stringArray objectAtIndex:1];
    
    NSLog(@"%@", state);
    
    NSArray *codeArray = [state componentsSeparatedByString:@"mercury"];
    
    NSString *code = [codeArray objectAtIndex:0];
    
    NSLog(@"%@", code);
    
    NSString *client_secret = @"7zgc14Sj-hdo7Fw8Nv3vM0DWOKNDZsR3";
    
    NSString *client_id = @"0000000048154773";
    
    NSString *redirect_uri = [@"http://mercury.promaticstechnologies.com/ecaHub/WebServices/linkedin_redirect" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    //client_id=CLIENT_ID&redirect_uri=REDIRECT_URL&client_secret=CLIENT_SECRET&code=AUTHORIZATION_CODE&grant_type=authorization_code
    
    NSDictionary *urlParam = @{@"grant_type": @"authorization_code", @"code": code, @"redirect_uri": redirect_uri, @"client_id": client_id, @"client_secret": client_secret};
    
    NSLog(@"Access Token Param- %@", urlParam);
    
    gmailConn = [WebServiceConnection connectionManager];
    
    [gmailConn startHotMailInConnectionWithString:@"https://login.live.com/oauth20_token.srf" HttpMethodType:Post_Type HttpBodyType:urlParam Output:^(NSDictionary *receivedData){
        
        NSLog(@"%@", receivedData);
        
        NSString *token = [receivedData valueForKey:@"access_token"];
        
        [self getHotmailContact:token];
    }];
}

-(void)getHotmailContact:(NSString *)token {
    
    NSString *url = @"https://apis.live.net/v5.0/me/contacts?access_token=";
    
    url = [url stringByAppendingString:token];
    
    NSLog(@"%@", url);
    
    WebServiceConnection *getContacts;
    
    contactsArray = [[NSMutableArray alloc] init];
    
    getContacts = [WebServiceConnection connectionManager];
    
    [getContacts startHotMailInConnectionWithString:url HttpMethodType:Get_type HttpBodyType:@{} Output:^(NSDictionary *receiveddata){
        
        NSLog(@"%@", receiveddata);
        
        for (int i= 0; i < [[receiveddata valueForKey:@"data"] count]; i++) {
            
            [contactsArray addObject:[[[[receiveddata valueForKey:@"data"] objectAtIndex:i] valueForKey:@"emails"] valueForKey:@"preferred"]];
        }
        
        NSString *emails = [[[receiveddata valueForKey:@"data"] objectAtIndex:0] valueForKey:@"email_hashes"];
        
        NSLog(@"%@\n%@", emails, contactsArray);
        
        [self getRegisterMember:contactsArray];
    }];
}

#pragma mark- RegisterMembers

-(void)getRegisterMember:(NSArray *)emailsArray {
    
    NSLog(@"%@", emailsArray);
    
    if ([emailsArray count] < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No Contact Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.view addSubview:indicator];
        
        NSDictionary *paramUrl = @{@"member_id":member_id};
        
        friendListingArray = [[NSMutableArray alloc] init];
        
        friendArray = [[NSMutableArray alloc] init];
        
        [inviteConn startConnectionWithString:@"invited_friends" HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary *receivedData){
            
            [indicator removeFromSuperview];
            
            if ([inviteConn responseCode] == 1) {
                
                NSLog(@"%@", receivedData);
                
                NSArray *listArray = [receivedData valueForKey:@"members_email"];
                
                for (int i=0; i< emailsArray.count; i++) {
                    
                    if ([listArray containsObject:[emailsArray objectAtIndex:i]]) {
                        
                        [friendArray addObject:[emailsArray objectAtIndex:i]];
                        
                    } else {
                        
                        [friendListingArray addObject:[emailsArray objectAtIndex:i]];
                    }
                }
                
                NSDictionary *myDic = @{@"friendArr":friendArray,@"friendlistArr":friendListingArray};
                
                [[NSUserDefaults standardUserDefaults]setObject:myDic forKey:@"myPassFrndsArr"];
                
                [friendList_tbl reloadData];
                
                [myFrnd_tbl reloadData];
                
                isTapFb = NO;
                
                [self performSegueWithIdentifier:@"FindRegisteredFriend" sender:self];
                
                
            }
        }];
    }
}

#pragma mark- UITableViewDelegates & UITableViewDataSourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == myFrnd_tbl) {
        
        return friendArray.count;
        
    } else {
        
        return friendListingArray.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == myFrnd_tbl) {
        
        friendCell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
        
        friendCell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        friendCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        friendCell.email.text = [friendArray objectAtIndex:indexPath.row];
        
        CGRect frame = friendCell.email.frame;
        
        frame.size.width = myFrnd_tbl.frame.size.width - friendCell.msgBtn.frame.size.width - 5;
        frame.origin.x = 5.0f;
        
        friendCell.email.frame = frame;
        
        //        frame = friendCell.msgBtn.frame;
        //
        //        frame.origin.x = myFrnd_tbl.frame.size.width - frame.size.width -5;
        //
        //        friendCell.msgBtn.frame = frame;
        
        [friendCell.msgBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        friendCell.msgBtn.tag = indexPath.row;
        
        return friendCell;
        
    } else {
        
        listingCell = [tableView dequeueReusableCellWithIdentifier:@"listingCell" forIndexPath:indexPath];
        
        listingCell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        listingCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        listingCell.email.text = [friendListingArray objectAtIndex:indexPath.row];
        
        CGRect frame = listingCell.email.frame;
        
        frame.size.width = myFrnd_tbl.frame.size.width - listingCell.inviteBtn.frame.size.width - 5;
        frame.origin.x = 15.0f;
        
        listingCell.email.frame = frame;
        
        [listingCell.inviteBtn addTarget:self action:@selector(sendInvite:) forControlEvents:UIControlEventTouchUpInside];
        
        listingCell.inviteBtn.tag = indexPath.row;
        
        return listingCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == myFrnd_tbl) {
        
        [tellFriendArray addObject:[friendArray objectAtIndex:indexPath.row]];
        
    } else {
        
        [inviteEmailArray addObject:[friendListingArray objectAtIndex:indexPath.row]];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == myFrnd_tbl) {
        
        [tellFriendArray removeObject:[friendArray objectAtIndex:indexPath.row]];
        
    } else {
        
        [inviteEmailArray removeObject:[friendListingArray objectAtIndex:indexPath.row]];
    }
}

-(void)sendInvite:(UIButton *)sender {
    
    [inviteEmailArray addObject:[friendListingArray objectAtIndex:sender.tag]];
    
    [self sendInvitaion];
}

-(void)sendMessage:(UIButton *)sender {
    
    NSString *emailstr = [friendArray objectAtIndex:sender.tag];
    
    sendMsgView = [[SendMessageView alloc] init];
    
    sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageView" owner:self options:nil] objectAtIndex:0];
    
    sendMsgView.frame = self.view.frame;
    
    sendMsgView.view_frame = self.view.frame;
    
    sendMsgView.to_textField.text = emailstr;
    
    [self.view addSubview:sendMsgView];
}


- (IBAction)tap_skipBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"ManualInviteSegue" sender:self];
}
- (IBAction)tap_learnMoreBtn:(id)sender {
    
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"ECAhubwill access your email address book in order to check which email address contacts are already registered on ECAhub. Any password that you may need to enter are verification requirements of your email account, and are not retained by the ECAhubsystem." delegate:self cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alertview show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
       
        if (buttonIndex == 1) {
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Signup"] isEqualToString:@"1"]) {
            
            storyboard = self.storyboard;
            
            tabbar = [storyboard instantiateViewControllerWithIdentifier:@"Tabbar"];
            
            [self presentViewController:tabbar animated:YES completion:nil];
            
            NSString *message = @"Welcome to ECAhub! Before you get started, please check your email inbox and junk mail folder for the verification email sent to you.";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
                
            }
            
            else{
            
           // [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"inviteFriendNever"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            
        }
        
        else if (buttonIndex == 2){
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
    }
}
@end



