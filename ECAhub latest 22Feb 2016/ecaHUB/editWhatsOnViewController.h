//
//  editWhatsOnViewController.h
//  ecaHUB
//
//  Created by promatics on 4/21/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface editWhatsOnViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate,listingDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *selectListBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseImgBtn;
@property (weak, nonatomic) IBOutlet UILabel *imgLbl;
@property (weak, nonatomic) IBOutlet UIButton *auto_msgBtn;
@property (weak, nonatomic) IBOutlet UIButton *customBtn;
@property (weak, nonatomic) IBOutlet UILabel *orLbl;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) IBOutlet UIImageView *img_view;
@property (weak, nonatomic) IBOutlet UITextView *message_textView;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (strong, nonatomic) IBOutlet UILabel *listInfo_lbl;

- (IBAction)tapPostBtn:(id)sender;
- (IBAction)tapCancelBtn:(id)sender;
- (IBAction)tapAutoMsgBtn:(id)sender;
- (IBAction)tapCustomMsgBtn:(id)sender;
- (IBAction)tapChooseImg:(id)sender;
- (IBAction)tapSelectList:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *charLimit_lbl;

@end


