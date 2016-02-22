//
//  PopUpView.h
//  ecaHUB
//
//  Created by promatics on 3/30/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpView : UIView

@property (strong, readwrite) NSString *VC;

@property (strong, nonatomic) IBOutlet UIButton *ok;

- (IBAction)OK:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *remind_label;
@property (strong, nonatomic) IBOutlet UIButton *checkbox_buttn;
- (IBAction)CHECKBOX:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *later;
- (IBAction)LATER:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *popview;

@property (strong, nonatomic) IBOutlet UILabel *message;


@end
