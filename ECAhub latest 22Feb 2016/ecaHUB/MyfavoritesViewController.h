//
//  MyfavoritesViewController.h
//  ecaHUB
//
//  Created by promatics on 4/10/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyfavoritesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myFavTable;
@property (weak, nonatomic) IBOutlet UILabel *no_record;

@property (strong, nonatomic) IBOutlet UILabel *fav_lbl;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterBtn;
- (IBAction)tap_FilterBtn:(id)sender;
- (IBAction)tap_info_speech_batBtn:(id)sender;

@property BOOL isSuggestion;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *info_speech_batBtn;


@end
