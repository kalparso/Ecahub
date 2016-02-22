//
//  Constant.h
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#ifndef ecaHUB_Constant_h
#define ecaHUB_Constant_h

#define KeyboardSize 216

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/* color codes */
#define placeholder_text_color_gray [UIColor grayColor]
#define theme_color_hexcode 0x4699E7
#define placeholder_text_color_hexcode 0xC7C7CD
#define text_color_hexcode 0x000000
#define background_color_hexcode 0x2A3B41
#define title_color_hexcode 0x4699E7
#define button_background_color_hexcode 0x4699E7

#define teal_text_color_hexcode 0x128D8F

#define dlight_gray_color_hexcode 0xE0E0E0

#define text_color_hexcode 0x000000

#define LinkedInApiKey 78imindwbpf3mg
#define LinkedInSecretKey G5Wl3zAe4ZcoHqGW

#define Alert_title @""

#define FBApiKey 766725830047199

#endif
