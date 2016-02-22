//
//  URL.h
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#ifndef ecaHUB_URL_h
#define ecaHUB_URL_h

/*  response code
 1 => success
 0 => failure
 */


/* domain */

#define baseURL @"http://mercury.promaticstechnologies.com/ecaHub/WebServices/"

//#define baseURL @"http:localhost/ecaHub/WebServices/"

#define profilePicURL @"http://mercury.promaticstechnologies.com/ecaHub/img/profile/"
/* method type */

//http://mercury.promaticstechnologies.com/ecaHub/Homes/terms_and_condition

#define term_Condition_Url @"http://mercury.promaticstechnologies.com/ecaHub/Homes/terms_and_condition"

#pragma mark - method type

#define Post_Type @"POST"
#define Get_type @"GET"

/* Images URL */

#define CourseImageURL @"http://mercury.promaticstechnologies.com/ecaHub/img/courses_images/"
#define LessonImageURL @"http://mercury.promaticstechnologies.com/ecaHub/img/lessons_images/"
#define EventImageURL @"http://mercury.promaticstechnologies.com/ecaHub/img/events_images/"

#define FlagImageURL @"http://mercury.promaticstechnologies.com/ecaHub/img/flag_images/"


// LOGO URL

#define CourseLogoURL @"http://mercury.promaticstechnologies.com/ecaHub/img/courses_logo_images/"
#define LessonLogoURL @"http://mercury.promaticstechnologies.com/ecaHub/img/lessons_logo_images/"
#define EventLogoURL @"http://mercury.promaticstechnologies.com/ecaHub/img/events_logo_images/"

// Identity IMg URL
#define CourseIdentityURL @"http://mercury.promaticstechnologies.com/ecaHub/img/courses_identity_images/"
#define LessonIdentityURL @"http://mercury.promaticstechnologies.com/ecaHub/img/lessons_identity_images/"
#define EventIdentityURL @"http://mercury.promaticstechnologies.com/ecaHub/img/events_identity_images/"

#define BusinessProfileImgURL @"http://mercury.promaticstechnologies.com/ecaHub/img/business_profile_images/"

//http://mercury.promaticstechnologies.com/ecaHub/img/business_profile_images/
// WhatsOn Images URL

#define WhatsOnImgURL @"http://mercury.promaticstechnologies.com/ecaHub/img/whatson_images/"

// WhatsOn Images URL

#define FamilyImage @"http://mercury.promaticstechnologies.com/ecaHub/img/family/"

// PayPal Recurring Payment

#define PayPalRecurringPayment @"http://mercury.promaticstechnologies.com/ecaHub/Homes/payment_vendors?"

#endif
