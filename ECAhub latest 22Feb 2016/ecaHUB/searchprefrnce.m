//
//  searchprefrnce.m
//  ecaHUB
//
//  Created by promatics on 3/30/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "searchprefrnce.h"
#import "WebServiceConnection.h"
#import "Indicator.h"

@interface searchprefrnce () {
 
    WebServiceConnection *mySearchPrefConn;
    
    Indicator *indicator;
}
@end

@implementation searchprefrnce

@synthesize city,interest,family_interest,save,edit, city_label, catergory;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     //self.navigationController.navigationBar.topItem.title = @"";
    
    mySearchPrefConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    [self getSearchPrefData];
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [self getSearchPrefData];
}

-(void)getSearchPrefData {
    
    NSDictionary *paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [self.view addSubview:indicator];
    
    [mySearchPrefConn startConnectionWithString:@"my_search_preference" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([mySearchPrefConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
                
                [[NSUserDefaults standardUserDefaults] setObject:receivedData forKey:@"MySearchPrefData"];
                
                NSString *location = [[[receivedData valueForKey:@"search_info"] valueForKey:@"City"] valueForKey:@"city_name"];
                
                location = [location stringByAppendingString:[NSString stringWithFormat:@", %@",[[[receivedData valueForKey:@"search_info"] valueForKey:@"State"] valueForKey:@"state_name"]]];
                
                 location = [location stringByAppendingString:[NSString stringWithFormat:@", %@",[[[receivedData valueForKey:@"search_info"] valueForKey:@"Country"] valueForKey:@"country_name"]]];
                
                city_label.text = location;
                
                NSArray *sub_array = [[receivedData valueForKey:@"subcat_names"] objectAtIndex:0];
                
                NSMutableArray *subCatAyyay = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < sub_array.count; i++) {
                    
                    [subCatAyyay addObject:[[[sub_array objectAtIndex:i] valueForKey:@"Subcategory"] valueForKey:@"subcategory_name"]];
                }
                catergory.text = [subCatAyyay componentsJoinedByString:@", "];
                
                [self heightCalculate:[subCatAyyay componentsJoinedByString:@", "]];
                
               
                
            } else {
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"No Search Preferences Exits. Please Add your search preferences." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                
//                [alert show];
                [self performSegueWithIdentifier:@"editSearchPref" sender:self];
                
                
            }
        }
    }];
}

-(void)heightCalculate:(NSString *)calculateText{
    
    //    newsCell = [self.tblView dequeueReusableCellWithIdentifier:@"NewsFeedsCustomCell"];
    UIStoryboard *storyboard;
    CGFloat width;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        width = 30.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        width = 20.0f;
    }
    [catergory setLineBreakMode:NSLineBreakByClipping];
    
    [catergory setNumberOfLines:0];
    
    [catergory setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [catergory setFont:[UIFont systemFontOfSize:17]];
    
    NSString *text = calculateText;
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(catergory.frame.size.width - (1.0f * 2), FLT_MAX);
    
    //    CGSize size1 = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect frame1 = catergory.frame;
    
    frame1.size.height = size.height;
    
    //frame1.size.width = self.view.frame.size.width - frame1.origin.x-width;
    
    [catergory setFrame:frame1];
    
   // [catergory sizeToFit];
    
    CGFloat height_lbl = size.height;
    
    NSLog(@"%f",height_lbl);
    
}

- (IBAction)SAVE:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
