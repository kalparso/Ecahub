//
//  recievedReviewViewController.m
//  ecaHUB
//
//  Created by promatics on 12/4/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "recievedReviewViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DateConversion.h"
#import "recievedReviewTableViewCell.h"

@interface recievedReviewViewController ()
{
  
    WebServiceConnection *reviewConn;
    
    Indicator *indicator;
    
    recievedReviewTableViewCell *cell;
    
    NSArray *reviewArr;
    
    
}

@end

@implementation recievedReviewViewController

@synthesize  reviewTable,main_view,scroll_view,chech_btn,name_lbl,desc_lbl,no_review_lbl,list_id,list_type,listName,status,desc,url,list_img_view;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    reviewConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    CGRect frame = main_view.frame;
    
    frame.origin.y = 10;
    
    main_view.frame = frame;
    
    main_view.backgroundColor = [UIColor clearColor];
    
       
    if([status isEqualToString:@"0"]){
        
    [chech_btn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        
    } else if ([status isEqualToString:@"1"]){
        
    [chech_btn setBackgroundImage:[UIImage imageNamed:@"Check_Mark"] forState:UIControlStateNormal];
    
        
    } else if ([status isEqualToString:@"2"]){
        
    [chech_btn setBackgroundImage:[UIImage imageNamed:@"expiry_icon"] forState:UIControlStateNormal];
    }
    
    [list_img_view sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Listing_Image"]];
    
    name_lbl.text = listName;
    
    chech_btn.layer.cornerRadius = chech_btn.frame.size.width/2;
    
    desc_lbl.hidden = YES;
    
    reviewTable.hidden = YES;
    
    // [self getReview];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getReview{
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"listing_id":list_id,@"listing_type":list_type};
    
    [reviewConn startConnectionWithString:@"reviews_received" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        
        if ([reviewConn responseCode] == 1) {
            
            NSLog(@"recived data: %@",receivedData);
            
            reviewArr = [reviewArr valueForKey:@"reviews"];
            
            reviewTable.hidden = YES;
        
        }
    }];
    
}


#pragma tableview dategates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return reviewArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    
    return cell;
}


- (IBAction)tap_check_btn:(id)sender {
}
@end
