//
//  IncomeTableViewCell.h
//  ecaHUB
//
//  Created by promatics on 5/13/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *main_view;

@property (strong, nonatomic) IBOutlet UILabel *confirmDate_lbl;
@property (strong, nonatomic) IBOutlet UILabel *transDate_lbl;

@property (strong, nonatomic) IBOutlet UILabel *transactionId_lbl;
@property (strong, nonatomic) IBOutlet UILabel *fromWho_lbl;

@property (strong, nonatomic) IBOutlet UILabel *forWho_lbl;

@property (strong, nonatomic) IBOutlet UILabel *detail_lbl;
@property (strong, nonatomic) IBOutlet UILabel *amount_lbl;
@property (strong, nonatomic) IBOutlet UILabel *payInDate_lbl;

@property (weak, nonatomic) IBOutlet UIButton *confirmDate_info_btn;
@property (weak, nonatomic) IBOutlet UIButton *transDate_info_btn;
@property (weak, nonatomic) IBOutlet UIButton *fromWho_info_btn;
@property (weak, nonatomic) IBOutlet UIButton *forWho_info_btn;
@property (weak, nonatomic) IBOutlet UIButton *amount_info_btn;
@property (weak, nonatomic) IBOutlet UIButton *payInDate_info_btn;


@property (weak, nonatomic) IBOutlet UILabel *fromWhoStatic_lbl;
@property (weak, nonatomic) IBOutlet UILabel *forWhoStatic_lbl;
@property (weak, nonatomic) IBOutlet UILabel *detailStatic_lbl;

@property (weak, nonatomic) IBOutlet UILabel *amountStatic_lbl;

@property (weak, nonatomic) IBOutlet UILabel *payInDateStatic_lbl;

@property (weak, nonatomic) IBOutlet UIButton *fromHwo_img_btn;

@property (weak, nonatomic) IBOutlet UIButton *forWho_img_btn;
@property (weak, nonatomic) IBOutlet UIButton *amount_img_btn;

@property (weak, nonatomic) IBOutlet UIButton *payIn_img_btn;

@end
