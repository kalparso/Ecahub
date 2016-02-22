//
//  myReviewsViewController.h
//  ecaHUB
//
//  Created by promatics on 4/15/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myReviewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tble_view;

@property (strong, nonatomic) IBOutlet UILabel *emptyreview_lbl;

@end
