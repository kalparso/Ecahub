//
//  SendMessageView.h
//  ecaHUB
//
//  Created by promatics on 4/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface SendMessageView : UIView <UITextFieldDelegate, UITextViewDelegate, listingDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UITextField *to_textField;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UIButton *send_msgBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)tapCloseBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *subjct_lbl;
@property (strong, nonatomic) IBOutlet UILabel *message_lbl;
@property (strong, nonatomic) IBOutlet UITextField *toTextField;
@property (strong, nonatomic) IBOutlet UITextView *message_textview;
@property (strong, nonatomic) IBOutlet UIButton *send_btn;
- (IBAction)tapSend_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *closeMsg_btn;
- (IBAction)tapCloseMsg_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *toMsg_btn;
//- (IBAction)tapToMsg_btn:(id)sender;

@property (nonatomic, readwrite) CGRect view_frame;
@property (strong, nonatomic) IBOutlet UIButton *to_btn;
//- (IBAction)tapTo_btn:(id)sender;

- (IBAction)tapSendMsg:(id)sender;
- (IBAction)tapCancelBtn:(id)sender;

@property (nonatomic ,weak)NSString *toMailId;

@end
