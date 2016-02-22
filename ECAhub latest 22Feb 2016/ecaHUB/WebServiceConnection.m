//
//  WebServiceConnection.m
//  ecaHUB
//
//  Created by promatics on 2/26/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//
#import "WebServiceConnection.h"

/* completion block of any http request */

typedef void (^myBlock)(NSDictionary *receivedData);


@interface WebServiceConnection ()
{
    NSMutableData *recievedDataByConnection;
    myBlock outputBlock;
    NSInteger responseCode;
}

@end


@implementation WebServiceConnection

@synthesize showAlert;

+(id)connectionManager
{
    WebServiceConnection *newConnection=nil;
    //static dispatch_once_t onceToken;
    newConnection=[[self alloc]init];
    //    dispatch_once(&onceToken,^{
    //
    //    });
    NSLog(@"connection %@ self %@",newConnection, self);
    return newConnection;
}

-(id)init
{
    if (self=[super init]) {
        stringUrl=[[NSString alloc]init];
        queue=[[NSOperationQueue alloc]init];
        receivedData=[[NSDictionary alloc]init];
        recievedDataByConnection = [[NSMutableData alloc] init];
        request=[[NSMutableURLRequest alloc]init];
        showAlert = TRUE;
        responseCode = 0;
    }
    return self;
}

-(void)cancelRequest
{
    recievedDataByConnection = nil;
    [urlConnection cancel];
    recievedDataByConnection = [[NSMutableData alloc] init];
}

-(NSInteger)responseCode{
    return responseCode;
}

-(void)startConectionToUploadImageWithString:(NSString*)stringurl imageData:(NSData *)imageData HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction {
    
    [self cancelRequest];
    NSLog(@"%@",stringurl);
  //  NSLog(@"params %@",params);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]];
    
    
    
    [request setURL:[NSURL URLWithString:[baseURL stringByAppendingString:stringurl]]];
    [request setHTTPMethod:@"POST"];
    //[request setHTTPBody:[urlString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    for (NSString *param in params) {
        
        [postbody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    //    [postbody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //
    //    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"filename"] dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //    [postbody appendData:[[NSString stringWithFormat:@"%@\r\n", [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filename\"; filename=\"%@.jpg\"\r\n",@"text"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:imageData]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    outputBlock = outputFunction;
    
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [urlConnection start];
    });
    
}
-(void)startConnectionToUploadMultipleImagesWithString:(NSString*)stringurl images :(NSArray*)images HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction{
    
    [self cancelRequest];
    NSLog(@"%@",stringurl);
    NSLog(@"params %@",params);
    
    NSString *postLength = @"" ;
    
    NSInteger post = 0;
    
    //[NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]];
    
    [request setURL:[NSURL URLWithString:[baseURL stringByAppendingString: stringurl ]]];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postbody = [NSMutableData data];
    
    for (NSString *param in params) {
        
        [postbody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    for (NSDictionary *image in images) {
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpeg\"\r\n", [image valueForKey:@"fieldName"], [image valueForKey:@"fileName"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[@"Content-Type: application/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[NSData dataWithData:[image valueForKey:@"imageData"]]];
        
        post = post + [[image valueForKey:@"imageData"] length];
    }
    postLength = [NSString stringWithFormat:@"%lu", (long)post];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setHTTPBody:postbody];
    
    outputBlock = outputFunction;
    
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [urlConnection start];
    });
    
}


-(void)startConnectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction
{
    NSData *jsonData;
    
    [self cancelRequest];
    
    NSMutableString *stringParams = [[NSMutableString alloc] init];
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        
        for (NSString *key in [params allKeys]) {
            [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
        }
        
        stringUrl= [baseURL stringByAppendingString:stringurl];
        
      //  NSLog(@"%@",stringUrl);
        
    }else if([paramStringMethodType isEqualToString:Get_type]){
        
        if ([params count]>0) {
            
            for (NSString *key in [params allKeys]) {
                [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
            }
            stringUrl=[NSString stringWithFormat:@"%@?%@",stringurl,stringParams];
        }else{
            stringUrl=stringurl;
        }
        
    }
    
    NSLog(@"url %@",stringUrl);
    
    url=[NSURL URLWithString:stringUrl];
    [request setURL:url];
    [request setHTTPMethod:paramStringMethodType];
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        NSData *postData = [stringParams dataUsingEncoding:NSUTF8StringEncoding];
        
        // [request setHTTPMethod:@"POST"];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postData];
        
        //[request setHTTPBody:jsonData];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    }
    
    outputBlock = outputFunction;
    
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [urlConnection start];
    });
    
    
    
    
    //    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    //
    //
    //        NSLog(@"Response: %@",response);
    //        NSLog(@"Error : %@",connectionError);
    //        NSLog(@"data %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    //
    //
    //        NSLog(@"respnse desc %@",((NSHTTPURLResponse *)response).description);
    //
    //        if ([data length]>0 && connectionError==nil && ((NSHTTPURLResponse *)response).statusCode == 200) {
    //
    //            receivedData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
    //
    //
    //
    //
    //        }else if (((NSHTTPURLResponse *)response).statusCode != 200 && response != nil)
    //        {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //            [[alertView initWithTitle:@"Connection Error" message:@"There is some error in connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //            });
    //
    //            receivedData = @{@"Connection Error":@"There is some error in connection"};
    //        }else
    //        {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [[alertView initWithTitle:@"Connection Error" message:[connectionError localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    //            });
    //
    //            receivedData = @{@"Connection Error":[connectionError localizedDescription]};
    //        }
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            outputFunction((NSDictionary *)receivedData);
    //        });
    //
    //    }];
    
}

/* Gmail  */

-(void)startConnectionWithGMail:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction
{
    NSData *jsonData;
    
    [self cancelRequest];
    
    NSMutableString *stringParams = [[NSMutableString alloc] init];
   
    if ([paramStringMethodType isEqualToString:Post_Type]) {
     
        jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        
        for (NSString *key in [params allKeys]) {
            [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
        }
        
        stringUrl= stringurl;
        
          NSLog(@"%@",stringUrl);
        
    }else if([paramStringMethodType isEqualToString:Get_type]){
        
        if ([params count]>0) {
            
            for (NSString *key in [params allKeys]) {
                [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
            }
            stringUrl=[NSString stringWithFormat:@"%@?%@",stringurl,stringParams];
        }else{
            stringUrl=stringurl;
        }
        
    }
    
    NSLog(@"url %@",stringUrl);
    
    url=[NSURL URLWithString:stringUrl];
    [request setURL:url];
    [request setHTTPMethod:paramStringMethodType];
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        NSData *postData = [stringParams dataUsingEncoding:NSUTF8StringEncoding];
        
        // [request setHTTPMethod:@"POST"];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postData];
        
        //[request setHTTPBody:jsonData];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    }
    
    outputBlock = outputFunction;
    
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [urlConnection start];
    });
    

}

-(void)startGmailConnectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction {
    
    NSData *jsonData;
    
    [self cancelRequest];
    
    NSMutableString *stringParams = [[NSMutableString alloc] init];
    
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        
        for (NSString *key in [params allKeys]) {
            
            [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
        }
        
        //        stringUrl= [baseURL stringByAppendingString:stringurl];
        
        stringUrl= stringurl;
        
        NSLog(@"%@",stringUrl);
        
    } else if ([paramStringMethodType isEqualToString:Get_type]) {
        
        if ([params count]>0) {
            
            for (NSString *key in [params allKeys]) {
                [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
            }
            stringUrl=[NSString stringWithFormat:@"%@?%@",stringurl,stringParams];
        }else{
            stringUrl=stringurl;
        }
        
    }
    
    NSLog(@"url %@",stringUrl);
    
    url=[NSURL URLWithString:stringUrl];
    [request setURL:url];
    [request setHTTPMethod:paramStringMethodType];
    
    NSString *token= [[NSUserDefaults standardUserDefaults] valueForKey:@"GmailToken"];
    
    NSLog(@"LinkedIn Token:-> %@", token);
    
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    
    [request addValue:[NSString stringWithFormat:@"3.0"] forHTTPHeaderField:@"GData-Version"];
    
    //GData-Version
    
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        NSData *postData = [stringParams dataUsingEncoding:NSUTF8StringEncoding];
        
        // [request setHTTPMethod:@"POST"];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postData];
        
        //[request setHTTPBody:jsonData];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GmailToken"];
    
    outputBlock = outputFunction;
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [urlConnection start];
    });
}


-(void)startConnectionWithStringLi:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction
{
    NSData *jsonData;
    
    [self cancelRequest];
    
    NSMutableString *stringParams = [[NSMutableString alloc] init];
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        
        for (NSString *key in [params allKeys]) {
            [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
        }
        
        stringUrl= stringurl;
        
        NSLog(@"%@",stringUrl);
        
    }else if([paramStringMethodType isEqualToString:Get_type]){
        
        if ([params count]>0) {
            
            for (NSString *key in [params allKeys]) {
                [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
            }
            stringUrl=[NSString stringWithFormat:@"%@?%@",stringurl,stringParams];
        }else{
            stringUrl=stringurl;
        }
        
    }
    
    NSLog(@"url %@",stringUrl);
    
    url=[NSURL URLWithString:stringUrl];
    [request setURL:url];
    [request setHTTPMethod:paramStringMethodType];
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        NSData *postData = [stringParams dataUsingEncoding:NSUTF8StringEncoding];
        
        // [request setHTTPMethod:@"POST"];
        
        [request setValue:[NSString stringWithFormat:@"%lu", [postData length]] forHTTPHeaderField:@"Content-Length"];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
       
        [request setHTTPBody:postData];
    }
    
    outputBlock = outputFunction;
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [urlConnection start];
    });
}

-(void)startLinkedInConnectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction {
    
    NSData *jsonData;
    
    [self cancelRequest];
    
    NSMutableString *stringParams = [[NSMutableString alloc] init];
    
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        
        for (NSString *key in [params allKeys]) {
            
            [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
        }
        
//        stringUrl= [baseURL stringByAppendingString:stringurl];
        
        stringUrl= stringurl;
        
        NSLog(@"%@",stringUrl);
        
    } else if ([paramStringMethodType isEqualToString:Get_type]) {
        
        if ([params count]>0) {
            
            for (NSString *key in [params allKeys]) {
                [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
            }
            stringUrl=[NSString stringWithFormat:@"%@?%@",stringurl,stringParams];
        }else{
            stringUrl=stringurl;
        }
        
    }
    
    NSLog(@"url %@",stringUrl);
    
    url=[NSURL URLWithString:stringUrl];
    [request setURL:url];
    [request setHTTPMethod:paramStringMethodType];
    
    NSString *token= [[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInToken"];
    
    NSLog(@"LinkedIn Token:-> %@", token);
    
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        NSData *postData = [stringParams dataUsingEncoding:NSUTF8StringEncoding];
        
        // [request setHTTPMethod:@"POST"];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
            
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
        [request setHTTPBody:postData];
        
        //[request setHTTPBody:jsonData];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"linkedInToken"];
    
    outputBlock = outputFunction;
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [urlConnection start];
    });
}

-(void)startLinkedInShareConnectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction {
    
    NSData *jsonData;
    
    [self cancelRequest];
    
    NSMutableString *stringParams = [[NSMutableString alloc] init];
    
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        
        /*for (NSString *key in [params allKeys]) {
         
         [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
         }*/
        
        stringUrl= stringurl;
        
        NSLog(@"%@",stringUrl);
        
    } else if ([paramStringMethodType isEqualToString:Get_type]) {
        
        if ([params count]>0) {
            
            for (NSString *key in [params allKeys]) {
                [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
            }
            stringUrl=[NSString stringWithFormat:@"%@?%@",stringurl,stringParams];
        }else{
            stringUrl=stringurl;
        }
        
    }
    
    NSLog(@"url %@",stringUrl);
    
    url=[NSURL URLWithString:stringUrl];
    [request setURL:url];
    [request setHTTPMethod:paramStringMethodType];
    
    NSString *token= [[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInToken"];
    
    NSLog(@"LinkedIn Token:-> %@", token);
    
    [request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        NSData *postData = jsonData;
        
        // [request setHTTPMethod:@"POST"];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
        
        [request setHTTPBody:postData];
        
        //[request setHTTPBody:jsonData];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"linkedInToken"];
    
    outputBlock = outputFunction;
    
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [urlConnection start];
    });
}

#pragma mark HotMail

-(void)startHotMailInConnectionWithString:(NSString*)stringurl HttpMethodType:(NSString*)paramStringMethodType HttpBodyType:(NSDictionary*)params Output:(void(^)(NSDictionary *receivedData)) outputFunction {
    
    NSData *jsonData;
    
    [self cancelRequest];
    
    NSMutableString *stringParams = [[NSMutableString alloc] init];
    
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        
        for (NSString *key in [params allKeys]) {
            
            [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
        }
        
        //        stringUrl= [baseURL stringByAppendingString:stringurl];
        
        stringUrl= stringurl;
        
        NSLog(@"%@",stringUrl);
        
    } else if ([paramStringMethodType isEqualToString:Get_type]) {
        
        if ([params count]>0) {
            
            for (NSString *key in [params allKeys]) {
                [stringParams appendFormat:@"%@=%@&",key,[params valueForKey:key]];
            }
            stringUrl=[NSString stringWithFormat:@"%@?%@",stringurl,stringParams];
        }else{
            stringUrl=stringurl;
        }
        
    }
    
    NSLog(@"url %@",stringUrl);
    
    url=[NSURL URLWithString:stringUrl];
    [request setURL:url];
    [request setHTTPMethod:paramStringMethodType];
    
   // NSString *token= [[NSUserDefaults standardUserDefaults] valueForKey:@"linkedInToken"];
    
   // NSLog(@"LinkedIn Token:-> %@", token);
    
    //[request addValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    
    if ([paramStringMethodType isEqualToString:Post_Type]) {
        
        NSData *postData = [stringParams dataUsingEncoding:NSUTF8StringEncoding];
        
        // [request setHTTPMethod:@"POST"];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postData];
        
        //[request setHTTPBody:jsonData];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"linkedInToken"];
    
    outputBlock = outputFunction;
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [urlConnection start];
    });
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    responseCode = 2;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (showAlert) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    });
    
    receivedData = @{@"Connection Error":[error localizedDescription]};
    
    dispatch_async(dispatch_get_main_queue(), ^{
        outputBlock((NSDictionary *)receivedData);
    });
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (((NSHTTPURLResponse *)response).statusCode != 200 && response != nil)
              {
        responseCode = 2;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"There is some error in connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[alert show];
            
            
            
        });
        
        receivedData = @{@"Connection Error":@"There was a slight error. Please try again later."};
        dispatch_async(dispatch_get_main_queue(), ^{
            outputBlock((NSDictionary *)receivedData);
        });
              }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [recievedDataByConnection appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* newStr = [[NSString alloc] initWithData:recievedDataByConnection encoding:NSUTF8StringEncoding];
 //   NSLog(@"%@", newStr);
    
    newStr = [newStr stringByReplacingOccurrencesOfString:@":\"null\"" withString:@":\"\""];
    
    newStr = [newStr stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    
    newStr = [newStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    recievedDataByConnection =  [[newStr dataUsingEncoding:NSUTF8StringEncoding] mutableCopy] ;
    
 //   NSLog(@"%@", newStr);
    
    receivedData=[NSJSONSerialization JSONObjectWithData:recievedDataByConnection options:kNilOptions error:nil];
    
    if (receivedData == nil)
              {
        responseCode = 2;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"There was a slight error. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        });
        
        receivedData = @{@"Connection Error":@"There is some error please try again later."};
        dispatch_async(dispatch_get_main_queue(), ^{
            outputBlock((NSDictionary *)receivedData);
        });
              }else{
                  responseCode = 1;
                  dispatch_async(dispatch_get_main_queue(), ^{
                      outputBlock((NSDictionary *)receivedData);
                  });
              }    
}


@end
