//
//  FamilyMemberDetailViewController.m
//  ecaHUB
//
//  Created by promatics on 3/13/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "FamilyMemberDetailViewController.h"
#import "DateConversion.h"
#import "URL.h"

@interface FamilyMemberDetailViewController () {
    
    DateConversion *dateConversion;
}
@end

@implementation FamilyMemberDetailViewController

@synthesize f_name, family_name, dob, gender, category, img_view, member_img, line_view, editBn,scroll_view;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    dateConversion = [DateConversion dateConversionManager];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        scroll_view.frame = self.view.frame;
        
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        img_view.layer.cornerRadius = 75.0f;
        
        img_view.layer.borderWidth = 12.0f;
        
        CGRect frame = editBn.frame;
        
        frame.size.height = 45.0f;
        
        editBn.frame = frame;
        
    } else {
        
        scroll_view.frame = self.view.frame;
        
        scroll_view.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        img_view.layer.cornerRadius = 40.0f;
        
        img_view.layer.borderWidth = 6.0f;
    }
    
    img_view.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Text_colore"]].CGColor;

    editBn.layer.cornerRadius = 5.0f;
    
//    [self setMemberDetails];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setMemberDetails];
}

-(void) setMemberDetails {
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"]);
    
    f_name.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"first_name"];
    
    family_name.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"family_name"];
    
    NSString *date_str = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"birth_date"];
    
    date_str = [dateConversion convertDate:date_str];    
    
    dob.text = date_str;
    
    gender.text = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"gender"];
    
    NSArray *cat_array = [[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"subcats"];
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < cat_array.count; i++) {
        
        [categories addObject:[[[cat_array objectAtIndex:i] valueForKey:@"Subcategory"] valueForKey:@"subcategory_name"]];
    }
    
    NSString *cat_interest;
    
    if ([categories count] > 0) {
        
        cat_interest = [categories componentsJoinedByString:@", "];
        
        category.text = cat_interest;
        
    } else {
        
        category.text = @"";
        
        cat_interest = @"";
    }
    
    [self heightCalculate:cat_interest];
    
    NSString *imageURL = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"member_detail"] valueForKey:@"Family"] valueForKey:@"picture"];
    
    imageURL = [imageURL stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if ([imageURL length] > 1) {
        
        imageURL = [FamilyImage stringByAppendingString:imageURL];
        
        [self downloadImageWithString:imageURL];
        
    } else {
        
        member_img.image = [UIImage imageNamed:@"user_img"];
    }
}

-(void)heightCalculate:(NSString *)calculateText{
    
    [category setLineBreakMode:NSLineBreakByWordWrapping];
    
    [category  setNumberOfLines:0];
    
    [category  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [category setFont:[UIFont systemFontOfSize:17]];
    category.frame = CGRectMake(category.frame.origin.x, category.frame.origin.y, category.frame.size.width, 3000);
    
    
    [category sizeToFit];
    
    line_view.frame = CGRectMake(0, category.frame.origin.y + category.frame.size.height + 20, self.view.frame.size.width, 2);
    
    /*NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width - (1.0 * 2), FLT_MAX);
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect lable_frame = category.frame;
    
    lable_frame.size.height = size.height + 10;
    
    [category  setFrame:lable_frame];
    
    //[category sizeToFit];
    
    NSLog(@"%f",lable_frame.origin.y);
    
    line_view.frame = CGRectMake(0, lable_frame.origin.y + category.frame.size.height + 20, self.view.frame.size.width, 2);
    */
   // editBn.frame = CGRectMake((self.view.frame.size.width-120)/2, lable_frame.origin.y + category.frame.size.height + 30, 120, 35);
    
    //CGFloat height_lbl = size.height;
    
   // NSLog(@"%f",height_lbl);
}

-(void) downloadImageWithString:(NSString *)urlString {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            member_img.image = image;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

@end
