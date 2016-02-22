//
//  MyFriendsViewController.m
//  ecaHUB
//
//  Created by promatics on 4/24/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "myFriendTableViewCell.h"
#import "FriendlistingTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"

@interface MyFriendsViewController () {
    
    myFriendTableViewCell *friendCell;
    
    FriendlistingTableViewCell *listingCell;
    
    WebServiceConnection *connection;
    
    Indicator *indicator;
    
    NSArray *friendsArray, *listingArray;
}
@end

@implementation MyFriendsViewController

@synthesize myFriendListTable, myFriendTable;

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

#pragma mark- UItableview Delegates & Datasourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == myFriendTable) {
        
        return friendCell;
    
    } else {
        
        return listingCell;
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
