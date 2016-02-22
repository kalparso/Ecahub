//
//  DateConversion.m
//  ecaHUB
//
//  Created by promatics on 3/18/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "DateConversion.h"

@implementation DateConversion

+(id)dateConversionManager
{
    static DateConversion *newDateConversion = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        
        newDateConversion=[[self alloc]init];
    });
    
    NSLog(@"connection %@ self %@",newDateConversion, self);
    
    return newDateConversion;
}

-(NSString *)convertDate:(NSString *)date {
    
    NSArray *dateArray = [date componentsSeparatedByString:@" "];
    
    NSString *dateStr = [dateArray objectAtIndex:0];
    
    NSArray *dateComponentArray = [dateStr componentsSeparatedByString:@"-"];
    
    NSString *months;
    
    int month = [[dateComponentArray objectAtIndex:1] intValue];
    
    switch (month) {
            
        case 01: {
            
            months = @"Jan";
            break;
        }
        case 02:{
            
            months = @"Feb";
            break;
        }
        case 03:{
            
            months = @"Mar";
            break;
        }
        case 04:{
            
            months = @"Apr";
            break;
        }
        case 05:{
            
            months = @"May";
            break;
        }
        case 06:{
            
            months = @"Jun";
            break;
        }
        case 07:{
            
            months = @"Jul";
            break;
        }
        case 8:{
            
            months = @"Aug";
            break;
        }
        case 9:{
            
            months = @"Sept";
            break;
        }
        case 10:{
            
            months = @"Oct";
            break;
        }
        case 11:{
            
            months = @"Nov";
            break;
        }
        case 12:{
            
            months = @"Dec";
            break;
        }
            
        default:
            
            months = @"00";
            break;
    }
    
    NSString *day = [dateComponentArray objectAtIndex:2];
    
    NSString *year = [dateComponentArray objectAtIndex:0];
    
    day = [day stringByAppendingString:@" "];
    
    day = [day stringByAppendingString:months];
    
    day = [day stringByAppendingString:@" "];
    
    day = [day stringByAppendingString:year];

    return day;
}

-(NSString *)getDateFromString:(NSString *)string {
    
    NSString * dateString = [NSString stringWithFormat: @"%@",string];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_CA_POSIX"];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* myDate = [dateFormatter dateFromString:dateString];
    
    NSTimeInterval timeInterval = (-1)*[myDate timeIntervalSinceNow];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    
    [dateFormatter1 setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter1 setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *formattedDateString = [dateFormatter1 stringFromDate:myDate];
    
   // NSLog(@"formattedDateString: %@", formattedDateString);
    
    NSString * strTime;
    
    if (timeInterval <=86400) {
        
    //    NSLog(@"Print Time:%f",timeInterval);
        
        int hours, minutes;
        
        hours = timeInterval / 3600;
        
        minutes = (timeInterval - (hours*3600)) / 60;
        
        if (hours ==0) {
            
            strTime = [NSString stringWithFormat:@"%02d min ago", minutes];
            
        }else if(hours == 1){
            
            strTime = [NSString stringWithFormat:@"%2d hour ago", hours];
            
        } else {
            
            strTime = [NSString stringWithFormat:@"%02d hours ago", hours];
            
        }
        
    //    NSLog(@"time = %02d:%02d", hours, minutes);
        
    } else if (timeInterval >= 86400 && timeInterval <= 172800) {
        
    //    NSLog(@"Yesterday:%@",dateString);
        
        strTime =@"Yesterday";
        
    } else {
        
   //     NSLog(@"Date print:%@",dateString);
        
        strTime = [NSString stringWithFormat:@"%@",formattedDateString];
    }
    
//    NSLog(@"%f", strTime);
    
    return strTime;
}

-(NSString *)convertTime:(NSString *)time {
    
    NSArray *timeArry = [time componentsSeparatedByString:@":"];
    NSString *hourStr = [timeArry objectAtIndex:0];
    NSString *mintStr = [timeArry objectAtIndex:1];
    NSString *timestr;
    
    int hour = hourStr.intValue;
    
    if(hour < 12){
        
        hourStr = [hourStr stringByAppendingString:@":"];
        mintStr = [mintStr stringByAppendingString:@" AM"];
        timestr = [hourStr stringByAppendingString:mintStr];
        
    } else {
        
        if(hour == 12){
            
            hour = 12;
            
        } else {
            
            hour = hour - 12;
            
        }
        
        if(hour < 10){
            hourStr = [@(hour) stringValue];
            hourStr = [@"0" stringByAppendingString:hourStr];
            hourStr = [hourStr stringByAppendingString:@":"];
            mintStr = [mintStr stringByAppendingString:@" PM"];
            
        } else{
            
            hourStr = [@(hour) stringValue];
            hourStr = [hourStr stringByAppendingString:@":"];
            mintStr = [mintStr stringByAppendingString:@" PM"];
        }
        
        timestr = [hourStr stringByAppendingString:mintStr];
    }
    
    return timestr;
    
}

-(NSString *)convertDate_Time:(NSString *)string {
    
    NSArray *array_str = [string componentsSeparatedByString:@" "];
    
    NSString *dateStr = [array_str objectAtIndex:0];
    
    NSString *timeStr = [array_str objectAtIndex:1];
    
    dateStr = [self convertDate:dateStr];
    
    timeStr = [self convertTime:timeStr];
    
    NSString *date_time_str = [dateStr stringByAppendingString:[NSString stringWithFormat:@" %@", timeStr]];
    
    return date_time_str;
}

@end
