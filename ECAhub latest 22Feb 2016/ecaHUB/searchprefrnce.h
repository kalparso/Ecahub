//
//  searchprefrnce.h
//  ecaHUB
//
//  Created by promatics on 3/30/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchprefrnce : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *city_label;

@property (weak, nonatomic) IBOutlet UILabel *catergory;


@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *interest;

@property (strong, nonatomic) IBOutlet UITextField *family_interest;

@property (strong, nonatomic) IBOutlet UIButton *save;
- (IBAction)SAVE:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *edit;

@end
