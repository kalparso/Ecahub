//
//  AccountSettingViewController.h
//  ecaHUB
//
//  Created by promatics on 8/20/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface AccountSettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *personalAcntBtn;
- (IBAction)tap_personalAcntBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *businessAcntBtn;
- (IBAction)tap_BusinessAcntBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (weak, nonatomic) IBOutlet UIButton *info_btn;
- (IBAction)tapInfo_btn:(id)sender;
- (IBAction)tapBusinessInfo:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *businessInfo_btn;

@end
