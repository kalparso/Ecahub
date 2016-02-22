//
//  Term_CondtionTable.h
//  ecaHUB
//
//  Created by promatics on 4/10/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Term_CondtionTable : UIView <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *term_table;
@property (retain, nonatomic) NSArray *data_array;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

- (IBAction)tapCloseBtn:(id)sender;

@end
