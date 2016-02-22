//
//  AddBusinessAccountViewController.m
//  ecaHUB
//
//  Created by promatics on 8/20/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "AddBusinessAccountViewController.h"
#import "WebServiceConnection.h"
#import "Validation.h"
#import "Indicator.h"

@interface AddBusinessAccountViewController (){
    
    
}

@end

@implementation AddBusinessAccountViewController

@synthesize scroll_View,bankCodeText,bankNameTxt,branchCodeText,branchLocationText,paypal_emailTxt,accountNameText,accountNumberText,swiftCodeText,saveBtn,cancelBtn,countryTxt;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scroll_View.contentSize = CGSizeMake(self.view.frame.size.width,1050);
    // Do any additional setup after loading the view.
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

- (IBAction)tap_selectAccount:(id)sender {
}
- (IBAction)tap_Save:(id)sender {
}
- (IBAction)tapCancelBtn:(id)sender {
}
@end
