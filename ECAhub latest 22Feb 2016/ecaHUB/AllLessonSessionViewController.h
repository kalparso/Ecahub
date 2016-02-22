//
//  AllLessonSessionViewController.h
//  ecaHUB
//
//  Created by promatics on 6/22/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllLessonSessionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbl_view;
@property (retain, nonatomic) NSArray *sessionArray;


@end
