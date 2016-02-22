//
//  EventBookViewController.h
//  ecaHUB
//
//  Created by promatics on 10/10/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventBookViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *attendingBtn;
- (IBAction)tap_attendingBtn:(id)sender;
- (IBAction)selectAdult:(id)sender;
- (IBAction)selectChildrenBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectChildrenBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectAdultBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)tap_nextBtn:(id)sender;

@end
