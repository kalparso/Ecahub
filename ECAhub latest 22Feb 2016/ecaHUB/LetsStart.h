//
//  LetsStart.h
//  ecaHUB
//
//  Created by promatics on 3/31/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LetsStart : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *wlcm;

@property (strong, nonatomic) IBOutlet UILabel *personlize;
@property (strong, nonatomic) IBOutlet UIButton *start;
- (IBAction)START:(id)sender;

@end
