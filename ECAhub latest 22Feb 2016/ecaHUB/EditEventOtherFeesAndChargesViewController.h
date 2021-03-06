//
//  EditEventOtherFeesAndChargesViewController.h
//  ecaHUB
//
//  Created by promatics on 10/19/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditEventOtherFeesAndChargesViewController : UIViewController

- (IBAction)tap_Currency:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *currencyBtn;
- (IBAction)tap_BookMaterialBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bookMaterialBtn;
@property (weak, nonatomic) IBOutlet UIButton *securityBtn;
- (IBAction)tap_SecurityBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *otherChargesBtn;
- (IBAction)tap_OtherChargesBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *bookMaterialText;
@property (weak, nonatomic) IBOutlet UITextField *securityDepositText;
@property (weak, nonatomic) IBOutlet UITextField *otherChargesText;
@property (weak, nonatomic) IBOutlet UIButton *saveAndAddSessionBtn;
- (IBAction)tap_SaveAndAddSessionBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property NSDictionary *EventDataDict;

- (IBAction)tap_infofees:(id)sender;

@end
