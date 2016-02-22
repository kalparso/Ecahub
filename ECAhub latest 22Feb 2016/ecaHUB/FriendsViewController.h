//
//  FriendsViewController.h
//  ecaHUB
//
//  Created by promatics on 9/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *find_inviteFriendsBtn;
- (IBAction)tap_find_inviteFriendsBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collection_View;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (weak, nonatomic) IBOutlet UILabel *nodata_lbl;

@end
