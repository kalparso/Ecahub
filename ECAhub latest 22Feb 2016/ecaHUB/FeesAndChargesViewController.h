//
//  FeesAndChargesViewController.h
//  ecaHUB
//
//  Created by promatics on 9/1/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeesAndChargesViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addSessionBtn;
- (IBAction)tap_addSessionBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *otherChargesTxt;
@property (weak, nonatomic) IBOutlet UITextField *depositTxt;
@property (weak, nonatomic) IBOutlet UITextField *bookandMaterialTxt;
- (IBAction)tap_bookMaterialBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bookMaterialBtn;
@property (weak, nonatomic) IBOutlet UIButton *depositeBtn;
- (IBAction)tap_otherChargesBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *otherChargesBtn;
@property (weak, nonatomic) IBOutlet UIButton *currencyBtn;
- (IBAction)tap_currencyBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
- (IBAction)tap_depositeBtn:(id)sender;

@property NSDictionary *termDataDict;
@property NSDictionary *courseDataDict;

@end
