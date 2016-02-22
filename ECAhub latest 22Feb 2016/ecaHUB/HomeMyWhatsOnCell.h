//
//  HomeMyWhatsOnCell.h
//  ecaHUB
//
//  Created by promatics on 4/23/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeMyWhatsOnCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *whtson_imgview;


@property (strong, nonatomic) IBOutlet UIButton *whatson_chckbttn;
@property (strong, nonatomic) IBOutlet UILabel *whtslist_namelbl;
@property (strong, nonatomic) IBOutlet UILabel *whtscreate_namelbl;
@property (strong, nonatomic) IBOutlet UILabel *whtsDiscription;
@property (strong, nonatomic) IBOutlet UIView *whatstab_view;
@property (strong, nonatomic) IBOutlet UIButton *whtsedit_tabbttn;
@property (strong, nonatomic) IBOutlet UIButton *whtsupload_tabbttn;

@property (strong, nonatomic) IBOutlet UIButton *whtsdelet_tabbttn;

@property (strong, nonatomic) IBOutlet UIButton *whtsback_tabbttn;
@property (strong, nonatomic) IBOutlet UIView *whts_view;

@end
