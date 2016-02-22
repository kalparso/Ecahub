//
//  Lession_Term_ConViewController.m
//  ecaHUB
//
//  Created by promatics on 4/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "Lession_Term_ConViewController.h"

@interface Lession_Term_ConViewController ()

@end

@implementation Lession_Term_ConViewController

@synthesize scrollView, lession_name, payment, deposit, changes, cancellation, makeupLessions, severe_weather, enrollment, minimum_payment,refund,refund_lbl,paymentDeadline_Lbl,deposit_Lbl,changes_Lbl,cancellation_Lbl,makeup_lbl,serverWeather_Lbl,enrollment_Lbl,minimumPayment_lbl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   //  self.navigationController.navigationBar.topItem.title = @"";
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1024);
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1050);
    }
    
    changes.hidden = YES;
    
    changes_Lbl.hidden = YES;
    
    [self setTermsDetails];
}

-(void) setTermsDetails {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"];
    
    NSLog(@"%@",dict);
    
    NSDictionary *term_dict = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lessonDetail"] valueForKey:@"lesson_info"];
                 
   NSLog(@"%@",term_dict);
    
    payment.text = [[[term_dict valueForKey:@"TermsPayment"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    cancellation.text = [[[term_dict valueForKey:@"TermsCancellation"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    minimum_payment.text = [[[term_dict valueForKey:@"MinimumPayment"]valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    changes.text = [[term_dict valueForKey:@"TermsChange"] valueForKey:@"title"];
    
    deposit.text = [[dict valueForKey:@"deposit_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    makeupLessions.text = [[[term_dict valueForKey:@"TermsMakeUpLesson"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *severArray =[[dict valueForKey:@"severe_names"]objectAtIndex:0];
    
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
    
    refund.text =[[[term_dict valueForKey:@"TermsRefund"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    lession_name.text = [[[term_dict valueForKey:@"LessonListing"] valueForKey:@"lesson_name"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    enrollment.text = [[[term_dict valueForKey:@"Enrollment"] valueForKey:@"title"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    CGRect Frame = enrollment.frame;
    
    Frame.origin.y =enrollment_Lbl.frame.origin.y + enrollment_Lbl.frame.size.height + 5;
    
    Frame.size.width = enrollment.frame.size.width;
    
    enrollment.frame = Frame;
    
    [enrollment sizeToFit];
    
    if (enrollment.frame.size.height <enrollment_Lbl.frame.size.height) {
        
        Frame.size.height = enrollment_Lbl.frame.size.height;
        
        enrollment.frame = Frame;
    }
        
    Frame = minimumPayment_lbl.frame;
    
    Frame.origin.y =enrollment.frame.origin.y + enrollment.frame.size.height + 5;
    
    minimumPayment_lbl.frame = Frame;
    
    Frame = minimum_payment.frame;
    
    Frame.origin.y =minimumPayment_lbl.frame.origin.y + minimumPayment_lbl.frame.size.height + 5;
    
    Frame.size.width = minimum_payment.frame.size.width;
    
    minimum_payment.frame = Frame;
    
    [minimum_payment sizeToFit];
    
    if (minimum_payment.frame.size.height <enrollment_Lbl.frame.size.height) {
        
        Frame.size.height = enrollment_Lbl.frame.size.height;
        
        minimum_payment.frame = Frame;
    }
    
    Frame = paymentDeadline_Lbl.frame;
    
    Frame.origin.y =minimum_payment.frame.origin.y + minimum_payment.frame.size.height + 5;
    
    paymentDeadline_Lbl.frame = Frame;
    
    Frame = payment.frame;
    
    Frame.origin.y =paymentDeadline_Lbl.frame.origin.y + paymentDeadline_Lbl.frame.size.height + 5;
    
    Frame.size.width = payment.frame.size.width;
    
    payment.frame = Frame;
    
    [payment sizeToFit];
    
    if (payment.frame.size.height <enrollment_Lbl.frame.size.height) {
        
        Frame.size.height = enrollment_Lbl.frame.size.height;
        
        payment.frame = Frame;
    }
    
    Frame = deposit_Lbl.frame;
    
    Frame.origin.y =payment.frame.origin.y + payment.frame.size.height + 5;
    
    deposit_Lbl.frame = Frame;
    
    Frame = deposit.frame;
    
    Frame.origin.y =deposit_Lbl.frame.origin.y + deposit_Lbl.frame.size.height + 5;
    
    Frame.size.width = deposit.frame.size.width;
    
    deposit.frame = Frame;
    
    [deposit sizeToFit];
    
    if (deposit.frame.size.height <enrollment_Lbl.frame.size.height) {
        
        Frame.size.height = enrollment_Lbl.frame.size.height;
        
        deposit.frame = Frame;
    }
    
    Frame = cancellation_Lbl.frame;
    
    Frame.origin.y =deposit.frame.origin.y + deposit.frame.size.height + 5;
    
    cancellation_Lbl.frame = Frame;
    
    Frame = cancellation.frame;
    
    Frame.origin.y =cancellation_Lbl.frame.origin.y + cancellation_Lbl.frame.size.height + 5;
    
    Frame.size.width = cancellation.frame.size.width;
    
    cancellation.frame = Frame;
    
    [cancellation sizeToFit];
    
    if (cancellation.frame.size.height <enrollment_Lbl.frame.size.height) {
        
        Frame.size.height = enrollment_Lbl.frame.size.height;
        
        cancellation.frame = Frame;
    }
    
    Frame = refund_lbl.frame;
    
    Frame.origin.y =cancellation.frame.origin.y + cancellation.frame.size.height + 5;
    
    refund_lbl.frame = Frame;
    
    Frame = refund.frame;
    
    Frame.origin.y =refund_lbl.frame.origin.y + refund_lbl.frame.size.height + 5;
    
    Frame.size.width = refund.frame.size.width;
    
    refund.frame = Frame;
    
    [refund sizeToFit];
    
    if (refund.frame.size.height <enrollment_Lbl.frame.size.height) {
        
        Frame.size.height = enrollment_Lbl.frame.size.height;
        
        refund.frame = Frame;
    }
    
    Frame = makeup_lbl.frame;
    
    Frame.origin.y =refund.frame.origin.y + refund.frame.size.height + 5;
    
    makeup_lbl.frame = Frame;
    
    Frame = makeupLessions.frame;
    
    Frame.origin.y =makeup_lbl.frame.origin.y + makeup_lbl.frame.size.height + 5;
    
    Frame.size.width = makeupLessions.frame.size.width;
    
    makeupLessions.frame = Frame;
    
    [makeupLessions sizeToFit];
    
    if (makeupLessions.frame.size.height <enrollment_Lbl.frame.size.height) {
        
        Frame.size.height = enrollment_Lbl.frame.size.height;
        
        makeupLessions.frame = Frame;
    }
    
    Frame = serverWeather_Lbl.frame;
    
    Frame.origin.y =makeupLessions.frame.origin.y + makeupLessions.frame.size.height + 5;
    
    serverWeather_Lbl.frame = Frame;
    
    Frame = severe_weather.frame;
    
    Frame.origin.y =serverWeather_Lbl.frame.origin.y + serverWeather_Lbl.frame.size.height + 5;
    
    Frame.size.width = severe_weather.frame.size.width;
    
    severe_weather.frame = Frame;
    
    [severe_weather sizeToFit];
    
    if (severe_weather.frame.size.height <enrollment_Lbl.frame.size.height) {
        
        Frame.size.height = enrollment_Lbl.frame.size.height;
        
        severe_weather.frame = Frame;
    }
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, severe_weather.frame.origin.y + severe_weather.frame.size.height +50);
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, severe_weather.frame.origin.y + severe_weather.frame.size.height +50);
    }

    
}

-(CGFloat)heightCalculate:(NSString *)calculateText{
    
    UILabel *calculateText_lbl = [[UILabel alloc] init];
    
    [calculateText_lbl setLineBreakMode:NSLineBreakByClipping];
    
    [calculateText_lbl setNumberOfLines:0];
    
    [calculateText_lbl setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    NSString *text = calculateText;
    
    NSLog(@"%@",calculateText);
    
    CGSize constraint = CGSizeMake(deposit.frame.size.width - (1.0f * 2), FLT_MAX);
    
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

-(void)viewWillAppear:(BOOL)animated{
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    [super viewWillDisappear:animated];
    
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
