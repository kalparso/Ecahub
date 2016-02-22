//
//  WebServiceConnection.h
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "URL.h"
#import "Constant.h"


@interface WebServiceConnection : NSObject<NSURLConnectionDataDelegate>
{
    NSString *stringUrl;
    NSURL *url;
    NSMutableURLRequest *request;
    NSOperationQueue *queue;
    NSURLConnection *urlConnection;
    UIAlertView *aKlertView;
    id receivedData;
}

@property (assign, nonatomic) BOOL showAlert;

/* its factory method to get instance of webservice connection class */

+(id)connectionManager;

/* to send request */

-(void)startConnectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;

/* to login linked in*/

-(void)startConnectionWithStringLi:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;

-(void)startLinkedInConnectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;

-(void)startLinkedInShareConnectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;

/* GMAIL */

-(void)startConnectionWithGMail:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;

-(void)startGmailConnectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;

/* HotMail */

-(void)startHotMailInConnectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;

/* to upload image to server with parameters */

-(void)startConectionToUploadImageWithString:(NSString*)stringurl imageData:(NSData *)imageData HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;

-(void)startConnectionToUploadMultipleImagesWithString:(NSString*)stringurl images :(NSArray*)images HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction;

/* to cancel request */

-(void)cancelRequest;

/* to get responss code of request
 1 => success
 2 => failure
 */

-(NSInteger)responseCode;

@end