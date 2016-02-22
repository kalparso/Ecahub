//
//  ListingViewController.h
//  ecaHUB
//
//  Created by promatics on 3/19/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol listingDelegate <NSObject>

@optional

-(void)didSelectListItem:(id)item index:(NSInteger)index;
-(void)didSaveItems:(NSArray*)items indexs:(NSArray*)indexs;
-(void)didCancel;

@end

@interface ListingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblView_list;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton_cancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton_save;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton_SelectAll;

@property (strong, nonatomic) NSMutableArray *array_data;
@property (strong, nonatomic) NSMutableArray *selectedData;

@property (weak, nonatomic) id<listingDelegate> delegate;
@property (assign, nonatomic) BOOL isMultipleSelected;



- (IBAction)tappedCancel:(id)sender;
- (IBAction)tappedSave:(id)sender;
//- (IBAction)tappedSelectAll:(id)sender;

@end
