//  AccountViewController.m
//  ecaHUB
//
//  Created by promatics on 8/21/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AccountViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "AddPersonalAccountViewController.h"

@interface AccountViewController (){
    
    WebServiceConnection *getConn;
    NSArray *PersonalAccountArray;
    NSArray *BusinessAccountArray;
    Indicator *indicator;
    NSArray *accountArray;
    NSDictionary *PersonalAccountDict;
    NSDictionary *BusinessAccountDict;
    NSDictionary *accountDict;
    NSString *memberInfo;
    AddPersonalAccountViewController *editAcnt;
    
    UILabel *bankAcc_lbl;
    
    UILabel *bankAccDetail_lbl ;
    
    CGFloat width;
}


@end

@implementation AccountViewController

@synthesize accountNamelbl,accountNumberLbl,bankCodeLbl,banknameLbl,branchCodelbl,branchLocationLbl,businessLbl,personalLbl,swiftCodelbl,countrylbl,memberIDlbl,memberIDValuelbl,editBtn,scroll_view,IsPersonalAcntView,AccountTypeLbl,bankAcntdetailView,paypal_emailTxt,defaultAccountlbl,bankAccount_lbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IsPersonalAcntView == YES) {
        
        self.title =@"Personal (Refund Account)";
        
    }
    
    else{
        
        self.title =@"Business (Pay-In Account)";
    }
    
    scroll_view.hidden = YES;
    
    getConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, editBtn.frame.origin.y+100);
    
    editBtn.layer.cornerRadius =5;
    
    width = paypal_emailTxt.frame.size.width;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self fetchData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[ segue identifier]isEqualToString:@"AccountEdit"]) {
        
        editAcnt = [segue destinationViewController];
        
        editAcnt.isEdit = YES;
        
        editAcnt.editAccountDict = accountDict;
        
        editAcnt.IsPersonalAcntView = IsPersonalAcntView;
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(void)fetchData{
    
    NSDictionary *paramURL = @{@"member_id": [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [self.view addSubview:indicator];
    
    [getConn startConnectionWithString:@"account_view" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        
        if([getConn responseCode]==1){
            
            NSLog(@"%@",receivedData);
            
            PersonalAccountDict = [[receivedData valueForKey:@"personal"]valueForKey:@"PersonalAccount"];
            
            BusinessAccountDict = [[receivedData valueForKey:@"business"]valueForKey:@"BusinessAccount"];
            
            memberInfo = [[[receivedData valueForKey:@"member_info"]valueForKey:@"Member"]valueForKey:@"account_number"];
            
            
            if (IsPersonalAcntView == YES) {
                
                AccountTypeLbl.text =@"Personal (Refund Account)";
                
                accountDict = [PersonalAccountDict copy];
                
                businessLbl.hidden = YES;
                
                memberIDValuelbl.hidden = YES;
                
                memberIDlbl.hidden = YES;
                
            }
            else{
                
                AccountTypeLbl.text =@"Business (Pay-In Account)";
                
                accountDict = [BusinessAccountDict copy];
                
                personalLbl.hidden = YES;
                
                memberIDValuelbl.text = memberInfo;
            }
            
            branchCodelbl.text = [accountDict valueForKey:@"branch_code"];
            
            branchLocationLbl.text = [accountDict valueForKey:@"branch_location"];
            
            countrylbl.text = [accountDict valueForKey:@"country"];
            
            banknameLbl.text = [accountDict valueForKey:@"bank_name"];
            
            swiftCodelbl.text = [accountDict valueForKey:@"swift_code"];
            
            bankCodeLbl.text = [accountDict valueForKey:@"bank_code"];
            
            accountNamelbl.text = [accountDict valueForKey:@"account_name"];
            
            accountNumberLbl.text = [accountDict valueForKey:@"account_number"];
            
            CGRect frame;
            
            frame = paypal_emailTxt.frame;
            
            frame.size.width = width;
            
            paypal_emailTxt.frame = frame;
            
            
            paypal_emailTxt.text =[accountDict valueForKey:@"paypal_email"];
            
            if([paypal_emailTxt.text length]<1){
                
                paypal_emailTxt.text = @"nil";
                
            }
            
            NSString *defaultAcntType = [accountDict valueForKey:@"account_type"];
            
            [paypal_emailTxt sizeToFit];
            
            scroll_view.scrollEnabled = YES;
            
            [bankAcc_lbl removeFromSuperview];
            
            [bankAccDetail_lbl removeFromSuperview];
            
            if ([defaultAcntType isEqualToString:@"0"]) {
                
                paypal_emailTxt.hidden = NO;
                
                defaultAccountlbl.text =@"PayPal Account (Default)";
                
                defaultAccountlbl.hidden = NO;
                
                bankAccount_lbl.text = @"Bank Account";
                
                
                if([countrylbl.text isEqualToString:@""]) {
                    
                    bankAcc_lbl = [[UILabel alloc] init];
                    
                    bankAccDetail_lbl = [[UILabel alloc] init];
                    
                    //scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, 500);
                    
                    frame = bankAcc_lbl.frame;
                    
                    frame.origin.y = paypal_emailTxt.frame.origin.y+paypal_emailTxt.frame.size.height+10;
                    
                    frame.origin.x = defaultAccountlbl.frame.origin.x;
                    
                    frame.size.width = 250.0f;
                    
                    frame.size.height = 21.f;
                    
                    bankAcc_lbl.frame = frame;
                    
                    [scroll_view addSubview:bankAcc_lbl];
                    
                    bankAcc_lbl.text = @"Bank Account";
                    
                    bankAcc_lbl.textColor = [UIColor darkGrayColor];
                    
                    frame = bankAccDetail_lbl.frame;
                    
                    frame.origin.y = bankAcc_lbl.frame.origin.y+bankAcc_lbl.frame.size.height+10;
                    
                    frame.origin.x = paypal_emailTxt.frame.origin.x;
                    
                    frame.size.width = 250.0f;
                    
                    frame.size.height = 21.f;
                    
                    bankAccDetail_lbl.frame = frame;
                    
                    [scroll_view addSubview:bankAccDetail_lbl];
                    
                    bankAccDetail_lbl.font = paypal_emailTxt.font;
                    
                    bankAccDetail_lbl.text = @"nil";
                    
                    UIFont *currentFont = defaultAccountlbl.font;
                    
                    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        
                        [bankAcc_lbl setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@",currentFont.fontName] size:19]];
                        
                        currentFont = paypal_emailTxt.font;
                        
                        
                        [bankAccDetail_lbl setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@",currentFont.fontName] size:19]];
                        
                    } else {
                        
                        [bankAcc_lbl setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@",currentFont.fontName] size:17]];
                        
                        currentFont = paypal_emailTxt.font;
                        
                        
                        [bankAccDetail_lbl setFont:[UIFont fontWithName:[NSString stringWithFormat:@"%@",currentFont.fontName] size:17]];
                        
                        //scroll_view.scrollEnabled = NO;
                        
                    }
                    
                    bankAccDetail_lbl.textColor = UIColorFromRGB(teal_text_color_hexcode);
                    
                    
                    frame = editBtn.frame;
                    
                    frame.origin.y= bankAccDetail_lbl.frame.origin.y +bankAccDetail_lbl.frame.size.height+30;
                    
                    //frame.origin.y= paypal_emailTxt.frame.origin.y +paypal_emailTxt.frame.size.height+30;
                    
                    editBtn.frame = frame;
                    
                    bankAcntdetailView.hidden = YES;
                    
                } else {
                    
                    bankAcntdetailView.hidden = NO;
                    
                    frame = bankAcntdetailView.frame;
                    
                    frame.origin.y = paypal_emailTxt.frame.origin.y +paypal_emailTxt.frame.size.height+10;
                    
                    bankAcntdetailView.frame = frame;
                    
                    frame = editBtn.frame;
                    
                    frame.origin.y= bankAcntdetailView.frame.origin.y+bankAcntdetailView.frame.size.height+20;
                    
                    editBtn.frame = frame;
                    
                    
                }
                
                
            }else{
                
                bankAccount_lbl.text = @"Bank Account (Default)";
                
                bankAcntdetailView.hidden=NO;
                
                CGRect frame;
                
                if([paypal_emailTxt.text length]>0){
                    
                    paypal_emailTxt.hidden = NO;
                    
                    defaultAccountlbl.hidden = NO;
                    
                    defaultAccountlbl.text = @"PayPal Account";
                    
                    frame = bankAcntdetailView.frame;
                    
                    frame.origin.y = paypal_emailTxt.frame.origin.y +paypal_emailTxt.frame.size.height+10;
                    
                    bankAcntdetailView.frame = frame;
                    
                    frame = editBtn.frame;
                    
                    frame.origin.y= bankAcntdetailView.frame.origin.y+bankAcntdetailView.frame.size.height+20;
                    
                    editBtn.frame = frame;
                    
                } else {
                    
                    
                    frame = bankAcntdetailView.frame;
                    
                    frame.origin.y = defaultAccountlbl.frame.origin.y;
                    
                    bankAcntdetailView.frame = frame;
                    
                    frame = editBtn.frame;
                    
                    frame.origin.y= bankAcntdetailView.frame.origin.y+bankAcntdetailView.frame.size.height+20;
                    
                    editBtn.frame = frame;
                    
                    defaultAccountlbl.text = @"PayPal Account";
                    
                    // paypal_emailTxt.text = @"nil";
                    
                    //paypal_emailTxt.hidden = YES;
                    
                    //defaultAccountlbl.hidden = YES;
                    
                    //defaultAccountlbl.text =@"Bank Account (Default)";
                    
                    //bankAcntdetailView.hidden=NO;
                }
                
            }
            
            scroll_view.hidden = NO;
            
        }
    }];
    
}

- (IBAction)tapEditBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"AccountEdit" sender:self];
    
    
}
@end