//
//  DontApproveView.h
//  ecaHUB
//
//  Created by promatics on 6/29/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DontApproveView : UIView <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *main_view;

@property (weak, nonatomic) IBOutlet UITextView *message_txtView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submit_btn;

- (IBAction)tapCloseBtn:(id)sender;

@end
