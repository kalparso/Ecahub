//
//  PaymentsTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 5/13/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *main_view;

@property (strong, nonatomic) IBOutlet UILabel *confirmDate_lbl;
@property (strong, nonatomic) IBOutlet UILabel *transDate_lbl;
@property (strong, nonatomic) IBOutlet UILabel *transactionId_lbl;
@property (strong, nonatomic) IBOutlet UILabel *toWho_lbl;

@property (strong, nonatomic) IBOutlet UILabel *details_lbl;
@property (strong, nonatomic) IBOutlet UILabel *forWho_lbl;
@property (strong, nonatomic) IBOutlet UILabel *amount_lbl;
@property (weak, nonatomic) IBOutlet UIButton *confirmDate_info_btn;
@property (weak, nonatomic) IBOutlet UIButton *transDate_info_btn;

@property (weak, nonatomic) IBOutlet UILabel *toWhoStatic_lbl;
@property (weak, nonatomic) IBOutlet UILabel *detailStatic_lbl;
@property (weak, nonatomic) IBOutlet UILabel *forWhoStatic_lbl;
@property (weak, nonatomic) IBOutlet UILabel *amountStatic_lbl;

@end
