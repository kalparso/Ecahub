//
//  EditFeesAndChargesViewController.h
//  ecaHUB
//
//  Created by promatics on 10/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "ListingViewController.h"

@interface EditFeesAndChargesViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate,listDelegate,listingDelegate>

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
@property (weak, nonatomic) IBOutlet UIButton *EditSessionOptnBtn;
- (IBAction)tap_EditSessionOptnBtn:(id)sender;

@end
