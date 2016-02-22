//
//  ListViewController.h
//  ecaHUB
//
//  Created by promatics on 3/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol listDelegate <NSObject>

@optional

-(void)didSelectListItem:(id)item index:(NSInteger)index;
-(void)didSaveItems:(NSArray*)items indexs:(NSArray*)indexs;
-(void)didCancel;

@end

@interface ListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblView_list;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton_cancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton_save;

@property (strong, nonatomic) NSMutableArray *array_data;
@property (strong, nonatomic) NSArray *selectedData;
@property (strong, nonatomic) NSArray *data_typeArray;


@property (weak, nonatomic) id<listDelegate> delegate;
@property (assign, nonatomic) BOOL isMultipleSelected;

- (IBAction)tappedCancel:(id)sender;
- (IBAction)tappedSave:(id)sender;

@end



