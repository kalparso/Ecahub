//
//  AddMySearchPrefViewController.h
//  ecaHUB
//
//  Created by promatics on 5/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"
#import "ListViewController.h"

@interface AddMySearchPrefViewController : UIViewController <listingDelegate, listDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)tapCountryBtn:(id)sender;
- (IBAction)tapStateBtn:(id)sender;
- (IBAction)tapCityBtn:(id)sender;
- (IBAction)tapIntrestBtn:(id)sender;
- (IBAction)tapSaveBtn:(id)sender;

- (IBAction)tap_infocircle:(id)sender;

@end
