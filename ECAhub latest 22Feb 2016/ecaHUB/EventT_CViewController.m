//
//  EventT_CViewController.m
//  ecaHUB
//
//  Created by promatics on 4/7/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "EventT_CViewController.h"

@interface EventT_CViewController ()

@end

@implementation EventT_CViewController

@synthesize scrollView, event_name, payment, deposit, changes, cancellation, makeupLessions, severe_weather, changes_booking,paymentLbl,refundLbl,changesLbl,cancellationlbl,makeupLbl,severeWeatherLbl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Terms & Conditions";
    
    // self.navigationController.navigationBar.topItem.title = @"";
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1024);
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 850);
    }
    
    [self setTermsDetails];
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

-(void) setTermsDetails {
    
    NSDictionary *dict =[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"];
    
    NSDictionary *term_dict = [[[NSUserDefaults standardUserDefaults] valueForKey:@"eventDetail"] valueForKey:@"event_info"];
    
    payment.text = [[term_dict valueForKey:@"TermsPayment"] valueForKey:@"title"];
    
    cancellation.text = [[term_dict valueForKey:@"TermsCancellation"] valueForKey:@"title"];
    
//    changes.text = [[term_dict valueForKey:@"TermsChange"] valueForKey:@"title"];
    
    deposit.text = [[term_dict valueForKey:@"TermsRefund"] valueForKey:@"title"];
    
    makeupLessions.text = [[term_dict valueForKey:@"TermsMakeUpLesson"] valueForKey:@"title"];
        
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
    
    event_name.text = [[term_dict valueForKey:@"EventListing"] valueForKey:@"event_name"];
    
    changes_booking.text = [[term_dict valueForKey:@"TermsChangesBooking"] valueForKey:@"title"];
    
    CGRect Frame = payment.frame;
    
    Frame.origin.y =paymentLbl.frame.origin.y + paymentLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:payment.text];
    
    payment.frame = Frame;
    
    Frame = changesLbl.frame;
    
    Frame.origin.y =payment.frame.origin.y + payment.frame.size.height + 5;
    
    changesLbl.frame = Frame;
    
    Frame = changes_booking.frame;
    
    Frame.origin.y =changesLbl.frame.origin.y + changesLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:changes_booking.text];
    
    changes_booking.frame = Frame;
    
    Frame = cancellationlbl.frame;
    
    Frame.origin.y =changes_booking.frame.origin.y + changes_booking.frame.size.height + 5;
    
    cancellationlbl.frame = Frame;
    
    Frame = cancellation.frame;
    
    Frame.origin.y =cancellationlbl.frame.origin.y + cancellationlbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:cancellation.text];
    
    cancellation.frame = Frame;
    
    Frame = refundLbl.frame;
    
    Frame.origin.y =cancellation.frame.origin.y + cancellation.frame.size.height + 5;
    
    refundLbl.frame = Frame;
    
    Frame = deposit.frame;
    
    Frame.origin.y =refundLbl.frame.origin.y + refundLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:deposit.text];
    
    deposit.frame = Frame;
    
    Frame = makeupLbl.frame;
    
    Frame.origin.y =deposit.frame.origin.y + deposit.frame.size.height + 5;
    
    makeupLbl.frame = Frame;
    
    Frame = makeupLessions.frame;
    
    Frame.origin.y =makeupLbl.frame.origin.y + makeupLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:makeupLessions.text];
    
    makeupLessions.frame = Frame;
    
    Frame = severeWeatherLbl.frame;
    
    Frame.origin.y =makeupLessions.frame.origin.y + makeupLessions.frame.size.height + 5;
    
    severeWeatherLbl.frame = Frame;
    
    Frame = severe_weather.frame;
    
    Frame.origin.y =severeWeatherLbl.frame.origin.y + severeWeatherLbl.frame.size.height + 5;
    
    Frame.size.height = [self heightCalculate:severe_weather.text];
    
    severe_weather.frame = Frame;
    
    severe_weather.numberOfLines = 0;
    
    severe_weather.lineBreakMode = NSLineBreakByWordWrapping;
    
    // [paymentLbl sizeToFit];
    
    [payment sizeToFit];
    
    //  [depositeLbl sizeToFit];
    
    [deposit sizeToFit];
    
    [cancellation sizeToFit];
    
    //  [cancelLbl sizeToFit];
    
    [severe_weather sizeToFit];
    
    //  [refundLbl sizeToFit];
    
    // [makeLbl sizeToFit];
    
    [makeupLessions sizeToFit];
    
    [changes_booking sizeToFit];
    
    // [SevereLbl sizeToFit];
    
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
