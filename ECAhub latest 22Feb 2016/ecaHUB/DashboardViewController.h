//
//  DashboardViewController.h
//  ecaHUB
//
//  Created by promatics on 3/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface DashboardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RatingViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table_view;

@property(nonatomic,retain) NSArray *menuData;
@property (strong, nonatomic) RatingView *star_ratingView;

@end
