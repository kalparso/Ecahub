//
//  SearchViewController.h
//  ecaHUB
//
//  Created by promatics on 4/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UITabBarControllerDelegate,UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *search_bar;
@property (weak, nonatomic) IBOutlet UIButton *select_typeBtn;
@property (weak, nonatomic) IBOutlet UITableView *searchTable;

@property (weak, nonatomic) IBOutlet UIView *advanceFilterView;
@property (weak, nonatomic) IBOutlet UIButton *mySeachPrefBtn;
@property (weak, nonatomic) IBOutlet UIButton *advanceFilterBtn;

- (IBAction)tapTypeBtn:(id)sender;
- (IBAction)tapAdvanceFilterBtn:(id)sender;
- (IBAction)tapUseMySearchPrefBtn:(id)sender;

@end
