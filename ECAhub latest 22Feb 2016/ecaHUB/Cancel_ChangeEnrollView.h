//
//  Cancel_ChangeEnrollView.h
//  ecaHUB
//
//  Created by promatics on 6/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cancel_ChangeEnrollView : UIView <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (weak, nonatomic) IBOutlet UIView *main_view;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *member;
@property (weak, nonatomic) IBOutlet UILabel *student;
@property (weak, nonatomic) IBOutlet UILabel *list_name;
@property (weak, nonatomic) IBOutlet UILabel *session_name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIButton *session_btn;
@property (weak, nonatomic) IBOutlet UILabel *msg_lbl;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UILabel *select_session_lbl;
@property (weak, nonatomic) IBOutlet UILabel *amount_lbl;
@property (weak, nonatomic) IBOutlet UITextField *amount_txtField;
@property (weak, nonatomic) IBOutlet UIButton *confirm_Btn;
@property (weak, nonatomic) IBOutlet UIButton *close_btn;
@property (strong, nonatomic) IBOutlet UIView *MainView;
@property (strong, nonatomic) IBOutlet UIButton *selctDay_btn;
@property (strong, nonatomic) IBOutlet UILabel *selctDay_lbl;
@property (weak, nonatomic) IBOutlet UILabel *infomsg_lbl;

- (IBAction)tapCloseBtn:(id)sender;

@end


