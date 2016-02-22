//
//  MyFriendsViewController.h
//  ecaHUB
//
//  Created by promatics on 4/24/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myFriendListTable;
@property (weak, nonatomic) IBOutlet UITableView *myFriendTable;

@end
