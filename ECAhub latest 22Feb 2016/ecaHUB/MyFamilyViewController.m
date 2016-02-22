//
//  MyFamilyViewController.m
//  ecaHUB
//
//  Created by promatics on 3/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.

#import "MyFamilyViewController.h"
#import "MyFamilyTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "DateConversion.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MyFamilyViewController (){
    
    WebServiceConnection *myFamilyConnection;
    
    WebServiceConnection *delete_mamberConnection;
    
    Indicator *indicator;
    
    MyFamilyTableViewCell *cell;
    
    NSArray *myFamilyArray;
    
    NSIndexPath *selectedIndexPath;
    
    DateConversion *dateConversion;
}
@end

@implementation MyFamilyViewController

@synthesize family_tbl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    myFamilyConnection = [WebServiceConnection connectionManager];
    
    delete_mamberConnection = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    dateConversion = [DateConversion dateConversionManager];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self fetchFamilyMembers];
}

-(void)fetchFamilyMembers {

    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [self.view addSubview:indicator];
    
    [myFamilyConnection startConnectionWithString:[NSString stringWithFormat:@"family_member_list"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([myFamilyConnection responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            myFamilyArray = [receivedData valueForKey:@"family_details"];
            
            NSMutableArray *categories = [[NSMutableArray alloc] init];

            
            if (myFamilyArray.count < 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Adding family members saves having to complete tedious details, each time you enroll or book activities for your specific family members. Don’t worry, family member information is private. Only Educators you enroll or book with will see family member details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                self.title = @"My Family";
                
                [alert show];
           
            } else {
                
                self.title = @"Family Member";
                
                NSString *cat_interest;
                
                if ([categories count] > 0) {
                    
                    cat_interest = [categories componentsJoinedByString:@", "];
                    
                    cell.interestIn.text = cat_interest;
                    
                } else {
                    
                    cell.interestIn.text = @"";
                    
                    cat_interest = @"";
                }
                
                [self heightCalculate:cat_interest];

            
                [family_tbl reloadData];
            }
        }
    }];
}

-(void)heightCalculate:(NSString *)calculateText{
    
//    UIStoryboard *storyboard;
//    CGFloat width;
//    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        
//        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
//        
//        width = 25.0f;
//        
//    } else {
//        
//        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
//        
//        width = 15.0f;
//    }

    
    [cell.interestIn setLineBreakMode:NSLineBreakByClipping];
       
    [cell.interestIn  setNumberOfLines:0];
    
    [cell.interestIn   setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [cell.interestIn  setFont:[UIFont systemFontOfSize:17]];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width - (1.0 * 2), FLT_MAX);
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect lable_frame = cell.interestIn.frame;
    
    lable_frame.size.height = size.height + 10;
    
    [cell.interestIn  setFrame:lable_frame];
    
    //[category sizeToFit];
    
    NSLog(@"%f",lable_frame.origin.y);
    
//    line_view.frame = CGRectMake(0, lable_frame.origin.y + category.frame.size.height + 20, self.view.frame.size.width, 2);
//    
//    editBn.frame = CGRectMake((self.view.frame.size.width-120)/2, lable_frame.origin.y + category.frame.size.height + 30, 120, 35);
    
    CGFloat height_lbl = size.height;
    
    NSLog(@"%f",height_lbl);
}


#pragma mark - UITableView Delegates & Datasources

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [myFamilyArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"MyFamilyCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        cell.member_img.layer.cornerRadius = cell.member_img.frame.size.width/2;
        
        cell.img_view.layer.cornerRadius = 75.0f;
        
        cell.img_view.layer.borderWidth = 12.0f;

        
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        cell.member_img.layer.cornerRadius = cell.member_img.frame.size.width/2;
        
        cell.img_view.layer.cornerRadius = 40.0f;
        
        cell.img_view.layer.borderWidth = 6.0f;
        
        CGRect frame = cell.f_name.frame;
        
        frame.size.width = (self.view.frame.size.width - (cell.firstName.frame.size.width )-30);
        
        cell.f_name.frame = frame;
        
        
        frame.origin.y = cell.interestIn.frame.origin.y;
        
        cell.interestIn.frame = frame;
    }
    
     cell.img_view.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Text_colore"]].CGColor;
    
    NSString *imageURL = [[[myFamilyArray objectAtIndex:indexPath.row] valueForKey:@"Family"] valueForKey:@"picture"];
    
    imageURL = [imageURL stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
    
    if ([imageURL length] > 1) {
        
        imageURL = [@"http://mercury.promaticstechnologies.com/ecaHub/img/family/" stringByAppendingString:imageURL];
 
        [cell.member_img sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"user_img"]];
        
    } else {
        
        cell.member_img.image = [UIImage imageNamed:@"user_img"];
    }
    
    NSString *firstName = [[[myFamilyArray objectAtIndex:indexPath.row] valueForKey:@"Family"] valueForKey:@"first_name"];
    
    cell.f_name.text = [[[firstName substringToIndex:1] uppercaseString] stringByAppendingString:[firstName substringFromIndex:1]];
    
   // cell.f_name.text = [[[myFamilyArray objectAtIndex:indexPath.row] valueForKey:@"Family"] valueForKey:@"first_name"];
    
     NSString *lastName =[[[myFamilyArray objectAtIndex:indexPath.row] valueForKey:@"Family"] valueForKey:@"family_name"];
    
    cell.l_name.text = [[[lastName substringToIndex:1] uppercaseString] stringByAppendingString:[lastName substringFromIndex:1]];
    
    cell.gender.text = [[[myFamilyArray objectAtIndex:indexPath.row] valueForKey:@"Family"] valueForKey:@"gender"];
    
    NSString *date_str = [[[myFamilyArray objectAtIndex:indexPath.row] valueForKey:@"Family"] valueForKey:@"birth_date"];
    
    date_str = [dateConversion convertDate:date_str];
    
    cell.dob.text = date_str;
    
    NSArray *cat_array = [[myFamilyArray objectAtIndex:indexPath.row] valueForKey:@"subcats"];
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < cat_array.count; i++) {
        
        [categories addObject:[[[cat_array objectAtIndex:i] valueForKey:@"Subcategory"] valueForKey:@"subcategory_name"]];
    }
    
    if ([categories count] > 0) {
        
        NSString *cat_interest = [categories componentsJoinedByString:@", "];
        
        cell.interestIn.text = cat_interest;

    } else {
        
        cell.interestIn.text = @"";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete) {
        
        selectedIndexPath=indexPath;

        NSString *member_id = cell.f_name.text = [[[myFamilyArray objectAtIndex:indexPath.row] valueForKey:@"Family"] valueForKey:@"id"];

        [self delete_familyMember:member_id];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *member_data = [myFamilyArray objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setValue:member_data forKey:@"member_detail"];
    
    [self performSegueWithIdentifier:@"memberDetail" sender:self];
    
}

-(void) delete_familyMember:(NSString *)member_id {
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"id" : member_id};
    
    [delete_mamberConnection startConnectionWithString:[NSString stringWithFormat:@"delete_family"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([delete_mamberConnection responseCode] ==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Family Member" message:@"Member deleted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
            [self fetchFamilyMembers];
        }
    }];
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString indexPath:(NSIndexPath *)indexPath {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            cell = (MyFamilyTableViewCell *)[self.family_tbl cellForRowAtIndexPath:indexPath];
            
            cell.member_img.image = image;
        }
    }];
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

@end
