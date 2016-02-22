//
//  TermsViewController.m
//  ecaHUB
//
//  Created by promatics on 3/27/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

@synthesize scrollView, course_name, payment, deposit, changes, cancellation, makeupLessions, severe_weather,refund_Value,refundLbl,paymentLbl,depositeLbl,changeLbl,cancelLbl,makeLbl,SevereLbl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // self.navigationController.navigationBar.topItem.title = @"";
    
    [self setTermsDetails];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, severe_weather.frame.origin.y + severe_weather.frame.size.height +80);
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, severe_weather.frame.origin.y + severe_weather.frame.size.height +50);
    }

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    [super viewWillDisappear:animated];
    
}

-(CGFloat)heightCalculate:(NSString *)calculateText{
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(refund_Value.frame.size.width - (1.0f * 2), FLT_MAX);
    
    UIFont *font;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        font = [UIFont systemFontOfSize:19];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        font = [UIFont systemFontOfSize:17];
        
    }
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font} context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    [calculateText_lbl setFrame:CGRectMake(10, 74, 300 ,size.height+5)];
    
    [calculateText_lbl sizeToFit];
    
    CGFloat height_lbl = size.height;
    
    return (height_lbl + 10);
}


-(void) setTermsDetails {
    
    NSDictionary *sdict =[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"];
    
    NSLog(@"%@",sdict);
    
    NSDictionary *term_dict = [[[NSUserDefaults standardUserDefaults] valueForKey:@"courseDetails"] valueForKey:@"course_info"];
    
    
    NSLog(@"%@",term_dict);
    
    payment.text = [[term_dict valueForKey:@"TermsPayment"] valueForKey:@"title"];
    
    cancellation.text = [[term_dict valueForKey:@"TermsCancellation"] valueForKey:@"title"];
    
    changes.text = [[term_dict valueForKey:@"TermsChange"] valueForKey:@"title"];
    
    deposit.text = [sdict valueForKey:@"deposit_name"];
    
    makeupLessions.text = [[term_dict valueForKey:@"TermsMakeUpLesson"] valueForKey:@"title"];
    
    NSArray *severArray =[[sdict valueForKey:@"severe_names"]objectAtIndex:0];
    
    NSString *severe;
    
    for (int i = 0; i<severArray.count; i++) {
        
        if (i==0){
            
            severe = [[[[severArray objectAtIndex:i]valueForKey:@"TermsSevereWeather"]valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        else{
            
            severe = [[severe stringByAppendingString:@"\n"]stringByAppendingString:[[[[severArray objectAtIndex:i]valueForKey:@"TermsSevereWeather"]valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
    }
    
    severe_weather.text = [severe stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    course_name.text = [[term_dict valueForKey:@"CourseListing"] valueForKey:@"course_name"];
    
    refund_Value.text = [[term_dict valueForKey:@"TermsRefund"] valueForKey:@"title"];
    
    CGRect Frame = payment.frame;
    
    Frame.origin.y =paymentLbl.frame.origin.y + paymentLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:payment.text];
    
    payment.frame = Frame;
    
    Frame = depositeLbl.frame;
    
    Frame.origin.y =payment.frame.origin.y + payment.frame.size.height + 5;
    
    depositeLbl.frame = Frame;
    
    Frame = deposit.frame;
    
    Frame.origin.y =depositeLbl.frame.origin.y + depositeLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:deposit.text];
    
    deposit.frame = Frame;
    
    Frame = changeLbl.frame;
    
    Frame.origin.y =deposit.frame.origin.y + deposit.frame.size.height + 5;
    
    changeLbl.frame = Frame;
    
    Frame = changes.frame;
    
    Frame.origin.y =changeLbl.frame.origin.y + changeLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:changes.text];
    
    changes.frame = Frame;
    
    Frame = cancelLbl.frame;
    
    Frame.origin.y =changes.frame.origin.y + changes.frame.size.height + 5;
    
    cancelLbl.frame = Frame;
    
    Frame = cancellation.frame;
    
    Frame.origin.y =cancelLbl.frame.origin.y + cancelLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:cancellation.text];
    
    cancellation.frame = Frame;
    
    Frame = refundLbl.frame;
    
    Frame.origin.y =cancellation.frame.origin.y + cancellation.frame.size.height + 5;
    
    refundLbl.frame = Frame;
    
    Frame = refund_Value.frame;
    
    Frame.origin.y =refundLbl.frame.origin.y + refundLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:refund_Value.text];
    
    refund_Value.frame = Frame;
    
    Frame = makeLbl.frame;
    
    Frame.origin.y =refund_Value.frame.origin.y + refund_Value.frame.size.height + 5;
    
    makeLbl.frame = Frame;
    
    Frame = makeupLessions.frame;
    
    Frame.origin.y =makeLbl.frame.origin.y + makeLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:makeupLessions.text];
    
    makeupLessions.frame = Frame;
    
    Frame = SevereLbl.frame;
    
    Frame.origin.y =makeupLessions.frame.origin.y + makeupLessions.frame.size.height + 5;
    
    SevereLbl.frame = Frame;
    
    Frame = severe_weather.frame;
    
    Frame.origin.y =SevereLbl.frame.origin.y + SevereLbl.frame.size.height + 5;
    
    severe_weather.numberOfLines = 0;
    
    severe_weather.lineBreakMode = NSLineBreakByWordWrapping;
    
    severe_weather.frame = Frame;
    
    [severe_weather sizeToFit];
    
   // [paymentLbl sizeToFit];
    
     [payment sizeToFit];
    
   //  [depositeLbl sizeToFit];
    
     [deposit sizeToFit];
    
     [cancellation sizeToFit];
    
   //  [cancelLbl sizeToFit];
    
     [refund_Value sizeToFit];
    
   //  [refundLbl sizeToFit];
    
    // [makeLbl sizeToFit];
    
     [makeupLessions sizeToFit];
    
    
    // [SevereLbl sizeToFit];
    
   
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
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
