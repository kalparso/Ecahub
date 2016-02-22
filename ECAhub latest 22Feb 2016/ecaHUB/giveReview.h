//
//  giveReview.h
//  ecaHUB
//
//  Created by promatics on 4/15/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface giveReview : UIView <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *reviewView;
@property (weak, nonatomic) IBOutlet UITextView *review_txtView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *submit_btn;

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *list_id;

- (IBAction)tapCancelBtn:(id)sender;
- (IBAction)tapSubmitBtn:(id)sender;


@end
