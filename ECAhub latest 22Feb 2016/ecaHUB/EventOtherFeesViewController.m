//
//  EventOtherFeesViewController.m
//  ecaHUB
//
//  Created by promatics on 4/7/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EventOtherFeesViewController.h"

@interface EventOtherFeesViewController ()

@end

@implementation EventOtherFeesViewController

@synthesize books_materials, security_deposit, other_charges;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     //self.navigationController.navigationBar.topItem.title = @"";
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"]);
    
    NSString *b_m_currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    NSString *book_price = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"quantity_books_materials"];
    
    book_price = [@" " stringByAppendingString:book_price];
    book_price = [b_m_currency stringByAppendingString:book_price];
    
    books_materials.text = book_price;
    
    
    NSString *security_currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"security_currency"] valueForKey:@"name"];
    
    NSString *security_price = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"quantity_security"];
    
    security_price = [@" " stringByAppendingString:security_price];
    security_price = [security_currency stringByAppendingString:security_price];
    
    security_deposit.text = security_price;
    
    NSString *other_currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"other_charges_currency"] valueForKey:@"name"];
    
    NSString *other_price = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"] valueForKey:@"EventListing"] valueForKey:@"other_charges"];
    
    other_price = [@" " stringByAppendingString:other_price];
    other_price = [other_currency stringByAppendingString:other_price];
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

@end
