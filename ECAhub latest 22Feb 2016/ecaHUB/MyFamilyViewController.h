//
//  MyFamilyViewController.h
//  ecaHUB
//
//  Created by promatics on 3/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFamilyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *family_tbl;

@end
