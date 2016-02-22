//
//  ViewBusinessProfileViewController.m
//  ecaHUB
//
//  Created by promatics on 7/14/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "ViewBusinessProfileViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "AddBusinessProfileViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ViewBusinessProfileViewController () {
    
    WebServiceConnection *getBusinessConn;
    Indicator *indicator;
    NSDictionary *businessDict;
    NSString *offerStr;
    BOOL isEdit;
    float addressWidth,offersWidth;
}
@end

@implementation ViewBusinessProfileViewController

@synthesize scrollView, educator_imgView, educator_image, educator_name, educator_description, established_year, address, offers, city, state, country, offr_lbl, sub_view, businesType, editBtn,yearStatic_lbl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isEdit = NO;
    
    self.navigationItem.rightBarButtonItem = editBtn;
    
    getBusinessConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    scrollView.frame = self.view.frame;
    
    scrollView.hidden = YES;
    
    educator_imgView.layer.cornerRadius = educator_imgView.frame.size.width/2;
    
    educator_imgView.layer.borderWidth = 5.0f;
    
    addressWidth = address.frame.size.width;
    
    offersWidth = offers.frame.size.width;
    
    educator_imgView.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Text_colore"]].CGColor;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self getBusinessData];
}

-(void)getBusinessData {
    
    [self.view addSubview:indicator];
    
    editBtn.enabled = NO;
    
    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [getBusinessConn startConnectionWithString:@"view_business_profile" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        editBtn.enabled = YES;
        
        [indicator removeFromSuperview];
        
        if ([getBusinessConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 0) {
                
                isEdit = NO;
                
                [self performSegueWithIdentifier:@"addBusinessSegue" sender:self];
                
            } else {
                
                businessDict = [receivedData valueForKey:@"info"];
                
                offerStr = [receivedData valueForKey:@"offer"];
                
                scrollView.hidden = NO;
                
                [self setBusinessData];
            }
        }
    }];
}

-(void)setBusinessData {
    
    NSString *img_url = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"identity"];
    
    img_url = [BusinessProfileImgURL stringByAppendingString:img_url];
    
    [educator_image sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:@"user_img"]];
    
    educator_name.text = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"];
    
    businesType.text = [[businessDict valueForKey:@"BusinessType"] valueForKey:@"title"];
    
    NSString *locationStr = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"author_venu_unit"];
    
    locationStr = [locationStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([locationStr length]>0){
        
        locationStr = [locationStr stringByAppendingString:@", "];
        
    } else {
        
        locationStr = @"";
    }
    
    locationStr = [locationStr stringByAppendingString:[[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"author_venu_building_name"]];
    
    locationStr = [locationStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([locationStr length]>0){
        
        locationStr = [locationStr stringByAppendingString:@", "];
        
    } else {
        
        locationStr = @"";
    }
    
    locationStr = [locationStr stringByAppendingString:[[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"author_venu_street"]];
    
    locationStr = [locationStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([locationStr length]>0){
        
        locationStr = [locationStr stringByAppendingString:@", "];
        
    } else {
        
        locationStr = @"";
    }
    
    locationStr = [locationStr stringByAppendingString:[[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"author_venu_district"]];
    
    //    locationStr = [locationStr stringByAppendingString:@", "];
    //
    //    locationStr = [locationStr stringByAppendingString:[[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"name_educator"]];
    
    address.text = locationStr;
    
    country.text = [[businessDict valueForKey:@"author_country"] valueForKey:@"country_name"];
    
    
    state.text = [[businessDict valueForKey:@"author_state"] valueForKey:@"state_name"];
    
    city.text = [[businessDict valueForKey:@"author_city"] valueForKey:@"city_name"];
    
    city.hidden =YES;
    
    state.hidden =YES;
    
    country.hidden =YES;
    
    
    if([city.text length]>0){
        
        address.text = [address.text stringByAppendingString:@"\n"];
        
        address.text = [address.text stringByAppendingString:city.text];
        
    }
    
    
    if([state.text length]>0){
        
        address.text = [address.text stringByAppendingString:@", "];
        
        address.text = [address.text stringByAppendingString:state.text];
        
        
    }
    
    
    if([country.text length]>0){
        
        address.text = [address.text stringByAppendingString:@", "];
        
        address.text = [address.text stringByAppendingString:country.text];
        
        
    }
    
    NSLog(@"%@",address.text);
    
    CGRect frame = address.frame;
    
    frame.size.width = addressWidth;
    
    address.frame = frame;
    
    [address sizeToFit];
    
    yearStatic_lbl.text = @"Established Year";
    
    frame = yearStatic_lbl.frame;
    
    frame.origin.y = address.frame.origin.y+address.frame.size.height+10;
    
    frame.size.width = yearStatic_lbl.frame.size.width+30;
    
    yearStatic_lbl.frame = frame;
    
    frame = established_year.frame;
    
    frame.origin.y = address.frame.origin.y+address.frame.size.height+10;
    
    established_year.frame = frame;
    
    
    established_year.text = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"year"];
    
    CGFloat height = [self heightCalculate:[[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"description_educator"]];
    
    frame = educator_description.frame;
    
    frame.size.height = height;
    
    frame.size.width = self.view.frame.size.width - educator_description.frame.origin.x*2;
    
    educator_description.frame = frame;
    
    [educator_description setLineBreakMode:NSLineBreakByClipping];
    
    [educator_description  setNumberOfLines:0];
    
    [educator_description  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    educator_description.text = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"description_educator"];
    
    [educator_description sizeToFit];
    
    
    frame = sub_view.frame;
    
    frame.origin.y = educator_description.frame.size.height + educator_description.frame.origin.y + 10;
    
    frame.size.height = established_year.frame.origin.y+established_year.frame.size.height;
    
    sub_view.frame = frame;
    
    offr_lbl.text = @"Offer";
    
    frame = offr_lbl.frame;
    
    frame.origin.y = sub_view.frame.origin.y + sub_view.frame.size.height + 10;
    
    offr_lbl.frame = frame;
    
    height = [self heightCalculate:offerStr];
    
    frame = offers.frame;
    
    frame.origin.y = sub_view.frame.origin.y + sub_view.frame.size.height + 10;
    
    frame.size.height = height;
    
    frame.size.width = offersWidth;
    
    offers.frame = frame;
    
    [offers setLineBreakMode:NSLineBreakByClipping];
    [offers  setNumberOfLines:0];
    [offers  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    offerStr = [offerStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    offers.text = offerStr;
    
    [offers sizeToFit];
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, (offers.frame.size.height + offers.frame.origin.y + 30));
}

-(CGFloat)heightCalculate:(NSString *)calculateText{
    
    UILabel *lable = [[UILabel alloc] initWithFrame:educator_description.frame];
    
    [lable setLineBreakMode:NSLineBreakByClipping];
    
    [lable  setNumberOfLines:0];
    
    [lable  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [lable setFont:[UIFont systemFontOfSize:17]];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width - (1.0 * 2), FLT_MAX);
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect lable_frame = lable.frame;
    
    lable_frame.size.height = size.height + 10;
    
    [lable  setFrame:lable_frame];
    
    CGFloat height_lbl = size.height;
    
    return height_lbl;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier]isEqualToString:@"addBusinessSegue"]) {
        
        AddBusinessProfileViewController *addVC = (AddBusinessProfileViewController *)[segue destinationViewController];
        
        if (isEdit) {
            
            addVC.business_id = [[businessDict valueForKey:@"BusinessProfile"] valueForKey:@"id"];
            
            addVC.businessDict = [businessDict copy];
            
            addVC.offers = offerStr;
            
            addVC.isEdit = YES;
            
        } else {
            
            addVC.isEdit = NO;
        }
    }
}

- (IBAction)tapEditBtn:(id)sender {
    
    isEdit = YES;
    
    [self performSegueWithIdentifier:@"addBusinessSegue" sender:self];
}
@end
