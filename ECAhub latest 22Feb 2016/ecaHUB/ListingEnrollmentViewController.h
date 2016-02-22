//
//  ListingEnrollmentViewController.h
//  ecaHUB
//
//  Created by promatics on 5/21/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface ListingEnrollmentViewController : UIViewController<UIActionSheetDelegate ,UITableViewDelegate,UITableViewDataSource, listingDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listEnroll_tableview;
@property (strong, nonatomic) IBOutlet UILabel *listingenroll_lbl;



@end
