//
//  ViewMemberDetailViewController.m
//  ecaHUB
//
//  Created by promatics on 6/24/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "ViewMemberDetailViewController.h"
#import "DateConversion.h"
#import "URL.h"

@interface ViewMemberDetailViewController () {
 
    DateConversion *dateConversion;
}
@end

@implementation ViewMemberDetailViewController
@synthesize main_view, sub_view, scrollView,member_image_view, member_lbl, star_rating_view, star1_img_view, star2_img_view, star3_img_view, star4_img_view, star5_img_view, session_lbl,student_name_lbl,session_value,student_name_value,member_name_lbl,member_name_value,enrollment_date_lbl,enrollment_date_value,lesson_fees_lbl,lesson_fees_value,date_time_lbl,date_time_value,memberDetail,phone_no_lbl,phone_no_value,dateofbirth_lbl,dateofBirth_value;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dateConversion = [DateConversion dateConversionManager];
    
    scrollView.frame = self.view.frame;
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    [self setMemberDetails];
    
    NSLog(@"%@", memberDetail);
}

-(void)downloadImageWithString:(NSString *)urlString {
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length]>0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            member_image_view.image = image;
            
            member_image_view.layer.masksToBounds = YES;
            
            member_image_view.layer.cornerRadius = 45;
        }
    }];
}

-(void)setMemberDetails {
    
    int starRating = [[memberDetail valueForKey:@"count"] integerValue];
    
    [self starrating:starRating];
    
    NSString *typeStr = [[memberDetail valueForKey:@"CreateEnrollment"] valueForKey:@"type"];
    
    NSString *listing, *list_type, *listing_name, *list_name;
    
    NSString *birth_date = [[memberDetail valueForKey:@"Member"]valueForKey:@"birth_date"];
    
    if (![birth_date isEqualToString:@""]) {
        
        dateofBirth_value.text =[dateConversion convertDate:birth_date];
    }
    else{
        
       dateofBirth_value.text = NULL;
    }
    
    if ([typeStr isEqualToString:@"1"]) {
        
        listing = @"CourseSession";
        
        listing_name = @"CourseListing";
        
        list_name = @"course_name";
        
        list_type = @"Course";
        
    } else if ([typeStr isEqualToString:@"2"]) {
        
        listing = @"EventSession";
        
        listing_name = @"EventListing";
        
        list_name = @"event_name";
        
        list_type = @"Event";
        
    } else if ([typeStr isEqualToString:@"3"]) {
        
        listing = @"LessonSession";
        
        list_name = @"lesson_name";
        
        listing_name = @"LessonListing";
        
        list_type = @"Lesson";
    }
    
    NSString *profileImage = [[memberDetail valueForKey:@"Member"]valueForKey:@"picture"];
    
    profileImage = [profileImage stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
    
    if ([profileImage length] > 1) {
        
        profileImage = [profilePicURL stringByAppendingString:profileImage];
        
        [self downloadImageWithString:profileImage];
        
    } else {
    
       member_image_view.image = [UIImage imageNamed:@"user_img"];
        
    }

    member_lbl.text = [[[[memberDetail valueForKey:@"Member"] valueForKey:@"first_name"]stringByAppendingString:@" "]stringByAppendingString:[[memberDetail valueForKey:@"Member"] valueForKey:@"last_name"]];
    
    member_name_value.text = member_lbl.text;
    
    phone_no_value.text =[[memberDetail valueForKey:@"Member"]valueForKey:@"phone"];
    
    int starRt = [[memberDetail valueForKey:@"count"]integerValue];
    
    [self starrating:starRt];
    
    NSString *name = [[memberDetail valueForKey:@"Member"] valueForKey:@"first_name"];
    
    student_name_value.text = name;
    
    session_value.text = [[memberDetail valueForKey:listing] valueForKey:@"session_name"];
    
    if (![typeStr isEqualToString:@"3"]) {
    
    CGRect frame = member_name_lbl.frame;
    
    frame.origin.y = 0;
    
    member_name_lbl.frame = frame;
    
    [member_name_lbl sizeToFit];
    
    frame = member_name_value.frame;
    
    frame.origin.y = member_name_lbl.frame.origin.y;
    
    member_name_value.frame = frame;
    
    [member_name_value sizeToFit];
    
    frame = dateofbirth_lbl.frame;
    
    if (member_name_lbl.frame.size.height> member_name_value.frame.size.height) {
        
        frame.origin.y = member_name_lbl.frame.origin.y + member_name_lbl.frame.size.height+5;
    }
    else{
        
        frame.origin.y = member_name_value.frame.origin.y + member_name_value.frame.size.height+5;
        
    }
    
    dateofbirth_lbl.frame = frame;
    
    [dateofbirth_lbl sizeToFit];
    
    frame = dateofBirth_value.frame;
    
    frame.origin.y = dateofbirth_lbl.frame.origin.y;
    
    dateofBirth_value.frame = frame;
    
    [dateofBirth_value sizeToFit];
    
    frame = phone_no_lbl.frame;
    
    if (dateofbirth_lbl.frame.size.height> dateofBirth_value.frame.size.height) {
        
        frame.origin.y = dateofbirth_lbl.frame.origin.y + dateofbirth_lbl.frame.size.height+5;
    }
    else{
        
        frame.origin.y = dateofBirth_value.frame.origin.y + dateofBirth_value.frame.size.height+5;
        
    }
    
    phone_no_lbl.frame = frame;
    
    [phone_no_lbl sizeToFit];
    
    frame = phone_no_value.frame;
    
    frame.origin.y = phone_no_lbl.frame.origin.y;
    
    phone_no_value.frame = frame;
    
    [phone_no_value sizeToFit];
        
    frame = student_name_lbl.frame;
        
    if (phone_no_lbl.frame.size.height > phone_no_value.frame.size.height) {
        
        frame.origin.y = phone_no_lbl.frame.origin.y + phone_no_lbl.frame.size.height+5;
    }
    else{
        
        frame.origin.y = phone_no_value.frame.origin.y + phone_no_value.frame.size.height+5;
        
    }
    
    student_name_lbl.frame = frame;
    
    [student_name_lbl sizeToFit];
    
    frame = student_name_value.frame;
    
    frame.origin.y = student_name_lbl.frame.origin.y;

    student_name_value.frame = frame;
    
    [student_name_value sizeToFit];
        
        session_value.hidden = YES;
        
        session_lbl.hidden = YES;
        
        date_time_lbl.hidden = YES;
        
        date_time_value.hidden = YES;
        
        enrollment_date_lbl.hidden = YES;
        
        enrollment_date_value.hidden = YES;
        
        lesson_fees_lbl.hidden = YES;
        
        lesson_fees_value.hidden = YES;
        
        frame = sub_view.frame;
        
        frame.size.height = lesson_fees_value.frame.size.height + lesson_fees_value.frame.origin.y;
        
        sub_view.frame = frame;
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, sub_view.frame.size.height + sub_view.frame.origin.y+80)];
        
    } else{
        
        NSArray *dateArray = [memberDetail valueForKey:@"new_fil_dates"];
        
        NSString *dateString;
        
        if (dateArray.count>0) {
            
            for (int i = 0; i<dateArray.count; i++) {
                
                if (i ==0) {
                    
                    dateString = [[NSString stringWithFormat:@"Lesson No%d=> ",i+1]stringByAppendingString:[dateConversion convertDate:[dateArray objectAtIndex:i]]];
                }
                else{
                    
                    dateString =[dateString stringByAppendingString:[NSString stringWithFormat:@"\n%@",[[NSString stringWithFormat:@"Lesson No%d=> ",i+1]stringByAppendingString:[dateConversion convertDate:[dateArray objectAtIndex:i]]]]];
                }
                
                
                
            }
            
        }
        
        date_time_value.text =dateString;
                                 
        NSString *enrollmentDt = [[memberDetail valueForKey:@"CreateEnrollment"]valueForKey:@"booking_date"];
                    
        if(![enrollmentDt isEqualToString:@""]){
            
            enrollment_date_value.text = [dateConversion convertDate:enrollmentDt];
            
        }
        else{
                                     
            enrollment_date_value.text = @"";
        }
        
        lesson_fees_value.text = [[memberDetail valueForKey:@"LessonSession"]valueForKey:@"fee_quantity"];
        
        phone_no_lbl.hidden = YES;
        
        phone_no_value.hidden = YES;
        
        CGRect frame = member_name_lbl.frame;
        
        frame.origin.y = 0;
        
        member_name_lbl.frame = frame;
        
        [member_name_lbl sizeToFit];
        
        frame = member_name_value.frame;
        
        frame.origin.y = member_name_lbl.frame.origin.y;
        
        member_name_value.frame = frame;
        
        [member_name_value sizeToFit];
        
        frame = student_name_lbl.frame;
        
        if (member_name_lbl.frame.size.height> member_name_value.frame.size.height) {
            
            frame.origin.y = member_name_lbl.frame.origin.y + member_name_lbl.frame.size.height+5;
        }
        else{
            
            frame.origin.y = member_name_value.frame.origin.y + member_name_value.frame.size.height+5;
            
        }
        
        student_name_lbl.frame = frame;
        
        [student_name_lbl sizeToFit];
        
        frame = student_name_value.frame;
        
        frame.origin.y = student_name_lbl.frame.origin.y;
        
        student_name_value.frame = frame;
        
        [student_name_value sizeToFit];
        
        frame = dateofbirth_lbl.frame;
        
        if (student_name_lbl.frame.size.height > student_name_value.frame.size.height) {
            
            frame.origin.y = student_name_lbl.frame.origin.y + student_name_lbl.frame.size.height+5;
        }
        else{
            
            frame.origin.y = student_name_value.frame.origin.y + student_name_value.frame.size.height+5;
            
        }
        
        dateofbirth_lbl.frame = frame;
        
        [dateofbirth_lbl sizeToFit];
        
        frame = dateofBirth_value.frame;
        
        frame.origin.y = dateofbirth_lbl.frame.origin.y;
        
        dateofBirth_value.frame = frame;
        
        [dateofBirth_value sizeToFit];
        
        frame = session_lbl.frame;
        
        if (dateofbirth_lbl.frame.size.height > dateofBirth_value.frame.size.height){
            
            frame.origin.y = dateofbirth_lbl.frame.origin.y + dateofbirth_lbl.frame.size.height+5;
        }
        else{
            
            frame.origin.y = dateofBirth_value.frame.origin.y + dateofBirth_value.frame.size.height+5;
            
        }
        
        session_lbl.frame = frame;
        
        [session_lbl sizeToFit];
        
        frame = session_value.frame;
        
        frame.origin.y = session_lbl.frame.origin.y;
        
        session_value.frame = frame;
        
        [session_value sizeToFit];
        
        frame = date_time_lbl.frame;
        
        if (session_lbl.frame.size.height > session_value.frame.size.height){
            
            frame.origin.y = session_lbl.frame.origin.y + session_lbl.frame.size.height+5;
        }
        else{
            
            frame.origin.y = session_value.frame.origin.y + session_value.frame.size.height+5;
            
        }
        
        date_time_lbl.frame = frame;
        
        [date_time_lbl sizeToFit];
        
        frame = date_time_value.frame;
        
        frame.origin.y = date_time_lbl.frame.origin.y;
        
        date_time_value.frame = frame;
        
        [date_time_value sizeToFit];
        
        frame = enrollment_date_lbl.frame;
        
        if (date_time_lbl.frame.size.height > date_time_value.frame.size.height){
            
            frame.origin.y = date_time_lbl.frame.origin.y + date_time_lbl.frame.size.height+5;
        }
        else{
            
            frame.origin.y = date_time_value.frame.origin.y + date_time_value.frame.size.height+5;
            
        }
        
        enrollment_date_lbl.frame = frame;
        
        [enrollment_date_lbl sizeToFit];
        
        frame = enrollment_date_value.frame;
        
        frame.origin.y = enrollment_date_lbl.frame.origin.y;
        
        enrollment_date_value.frame = frame;
        
        [enrollment_date_value sizeToFit];
        
        frame = lesson_fees_lbl.frame;
        
        if (enrollment_date_lbl.frame.size.height > enrollment_date_value.frame.size.height){
            
            frame.origin.y = enrollment_date_lbl.frame.origin.y + enrollment_date_lbl.frame.size.height+5;
        }
        else{
            
            frame.origin.y = enrollment_date_value.frame.origin.y + enrollment_date_value.frame.size.height+5;
            
        }
        
        lesson_fees_lbl.frame = frame;
        
        [lesson_fees_lbl sizeToFit];
        
        frame = lesson_fees_value.frame;
        
        frame.origin.y = lesson_fees_lbl.frame.origin.y;
        
        lesson_fees_value.frame = frame;
        
        [lesson_fees_value sizeToFit];
        
        frame = sub_view.frame;
        
        frame.size.height = lesson_fees_value.frame.size.height + lesson_fees_value.frame.origin.y;
        
        sub_view.frame = frame;
        
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, sub_view.frame.size.height + sub_view.frame.origin.y+80)];
        
    }
    if ([typeStr isEqualToString:@"2"]) {
        
        student_name_lbl.text = @"Attendees";//9 Adults, 1 Children under 12
        
        NSString *adult= [[memberDetail valueForKey:@"CreateEnrollment"]valueForKey:@"adult"];
        
        NSString *child= [[memberDetail valueForKey:@"CreateEnrollment"]valueForKey:@"child"];
        
        if (![adult isEqualToString:NULL]) {
            
            adult = [adult stringByAppendingString:@" Adults"];
        }
        if (![child isEqualToString:NULL]) {
            
            child = [[@" ,"stringByAppendingString:child ] stringByAppendingString:@" Children under 12"];
        }
        
        student_name_value.text = [adult stringByAppendingString:child];
    }
    
}


-(void)starrating: (int)count{
    
    switch (count) {
        case 1:{
            
            //[star1_img_view setImage:[UIImage imageNamed:@"star"]];
           
            star1_img_view.image = [UIImage imageNamed:@"star"];
            star2_img_view.image = [UIImage imageNamed:@"star_white"];
            star3_img_view.image = [UIImage imageNamed:@"star_white"];
            star4_img_view.image = [UIImage imageNamed:@"star_white"];
            star5_img_view.image = [UIImage imageNamed:@"star_white"];
        }
        break;
            
        case 2:{
            
            star1_img_view.image = [UIImage imageNamed:@"star"];
            star2_img_view.image = [UIImage imageNamed:@"star"];
            star3_img_view.image = [UIImage imageNamed:@"star_white"];
            star4_img_view.image = [UIImage imageNamed:@"star_white"];
            star5_img_view.image = [UIImage imageNamed:@"star_white"];
        }
        break;
            
        case 3:{
            
            star1_img_view.image = [UIImage imageNamed:@"star"];
            star2_img_view.image = [UIImage imageNamed:@"star"];
            star3_img_view.image = [UIImage imageNamed:@"star"];
            star4_img_view.image = [UIImage imageNamed:@"star_white"];
            star5_img_view.image = [UIImage imageNamed:@"star_white"];
        }
        break;
            
        case 4:{
            
            star1_img_view.image = [UIImage imageNamed:@"star"];
            star2_img_view.image = [UIImage imageNamed:@"star"];
            star3_img_view.image = [UIImage imageNamed:@"star"];
            star4_img_view.image = [UIImage imageNamed:@"star"];
            star5_img_view.image = [UIImage imageNamed:@"star_white"];
        }
        break;
            
        case 5:{
            
            star1_img_view.image = [UIImage imageNamed:@"star"];
            star2_img_view.image = [UIImage imageNamed:@"star"];
            star3_img_view.image = [UIImage imageNamed:@"star"];
            star4_img_view.image = [UIImage imageNamed:@"star"];
            star5_img_view.image = [UIImage imageNamed:@"star"];
        }
        break;
        
    }
}

@end
