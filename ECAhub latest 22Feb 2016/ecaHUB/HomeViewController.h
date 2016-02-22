//
//  HomeViewController.h
//  ecaHUB
//
//  Created by promatics on 2/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource ,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *msgtable_view;

-(void) dismissLoginVC;

@end

/// SuPriya 