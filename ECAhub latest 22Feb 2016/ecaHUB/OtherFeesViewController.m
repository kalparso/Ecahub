//
//  OtherFeesViewController.m
//  ecaHUB
//
//  Created by promatics on 3/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "OtherFeesViewController.h"

@interface OtherFeesViewController ()

@end

@implementation OtherFeesViewController

@synthesize books_materials, security_deposit, other_charges;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   //  self.navigationController.navigationBar.topItem.title = @"";
    
    NSString *b_m_currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    NSString *book_price = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"quantity_books_materials"];
    
    if ([book_price isEqual:@""]) {
        
        book_price = @"0.00";
    }
    
    book_price = [@" " stringByAppendingString:book_price];
    book_price = [b_m_currency stringByAppendingString:book_price];
    
    books_materials.text = book_price;
    
    
    NSString *security_currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"security_currency"] valueForKey:@"name"];
    
    NSString *security_price = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"quantity_security"];
    
    if ([security_price isEqual:@""]) {
        
        security_price = @"0.00";
    }
    
    security_price = [@" " stringByAppendingString:security_price];
    security_price = [security_currency stringByAppendingString:security_price];
    
    security_deposit.text = security_price;
    
    NSString *other_currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"other_charges_currency"] valueForKey:@"name"];
    
    NSString *other_price = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"] valueForKey:@"CourseListing"] valueForKey:@"other_charges"];
    
    if ([other_price isEqual:@""]) {
        
        other_price = @"0.00";
    }
    
    other_price = [@" " stringByAppendingString:other_price];
    other_price = [security_currency stringByAppendingString:other_price];
    
    other_charges.text = other_price;
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
