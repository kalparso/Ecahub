//
//  OtherFeesLessionViewController.m
//  ecaHUB
//
//  Created by promatics on 4/4/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "OtherFeesLessionViewController.h"

@interface OtherFeesLessionViewController ()

@end

@implementation OtherFeesLessionViewController

@synthesize books_materials, security_deposit, other_charges;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"]);
    
    NSString *b_m_currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    NSString *book_price = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_books_materials"];
    
    if ([book_price isEqualToString:@""] || book_price==nil) {
        
        book_price = @"0";
    }
    
    books_materials.text = [b_m_currency stringByAppendingString:[NSString stringWithFormat:@" %0.2f",[book_price floatValue ]]];
    
    NSString *security_currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    NSString *security_price = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"quantity_security"];
    
    if ([security_price isEqualToString:@""] || security_price==nil) {
        
        security_price = @"0";
    }
    
    security_deposit.text = [security_currency stringByAppendingString:[NSString stringWithFormat:@" %0.2f",[security_price floatValue]]];
    
    NSString *other_currency = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"b_m_currency"] valueForKey:@"name"];
    
    NSString *other_price = [[[[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"] valueForKey:@"LessonListing"] valueForKey:@"other_charges"];
    
    if ([other_price isEqualToString:@""] || other_price==nil) {
        
        other_price = @"0";
    }
    
    other_charges.text = [other_currency stringByAppendingString:[NSString stringWithFormat:@" %0.2f",[other_price floatValue]]];

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
