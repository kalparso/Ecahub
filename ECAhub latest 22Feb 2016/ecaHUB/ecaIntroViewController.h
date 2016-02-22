//
//  ecaIntroViewController.h
//  ecaHUB
//
//  Created by promatics on 3/4/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ecaIntroViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)setupScrollView:(UIScrollView*)scrMain ;

@end
