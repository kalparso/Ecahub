//
//  DateConversion.h
//  ecaHUB
//
//  Created by promatics on 3/18/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateConversion : NSObject

+(id)dateConversionManager;

-(NSString *)convertDate:(NSString*)date;

-(NSString *)getDateFromString:(NSString *)string;

-(NSString *)convertTime:(NSString *)time ;

-(NSString *)convertDate_Time:(NSString *)string;

@end
