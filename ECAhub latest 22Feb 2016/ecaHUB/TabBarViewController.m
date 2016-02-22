//
//  TabBarViewController.m
//  ecaHUB
//
//  Created by promatics on 3/3/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     //self.navigationController.navigationBar.topItem.title = @"";
    
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
