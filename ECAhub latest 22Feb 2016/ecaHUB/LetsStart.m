//
//  LetsStart.m
//  ecaHUB
//
//  Created by promatics on 3/31/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "LetsStart.h"
#import "EditProfileViewController.h"

@interface LetsStart (){
    
    EditProfileViewController *editProfileVC;
}

@end

@implementation LetsStart

@synthesize wlcm,personlize,start;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
     //self.navigationController.navigationBar.topItem.title = @"";
    
    start.layer.cornerRadius = 5.0f;
   
   NSString *nameStr = [@"Welcome" stringByAppendingString:[NSString stringWithFormat:@" %@",[[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"first_name"] capitalizedString]]];
    
    wlcm.text = [nameStr stringByAppendingString:@" !"];
    
    //nameStr = [nameStr uppercaseString];
    
// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)START:(id)sender {
    
    UIStoryboard *storyboard = self.storyboard;
    
    editProfileVC = [storyboard instantiateViewControllerWithIdentifier:@"EditProfile"];
    
    [self.navigationController pushViewController:editProfileVC animated:YES];
    
}
@end
