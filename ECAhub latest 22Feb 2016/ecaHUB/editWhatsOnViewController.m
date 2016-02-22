//  editWhatsOnViewController.m
//  ecaHUB
//
//  Created by promatics on 4/21/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "editWhatsOnViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"

@interface editWhatsOnViewController () {
    
    WebServiceConnection *whatsOnPostConn;
    
    WebServiceConnection *getListConn;
    
    Indicator *indicator;
    
    BOOL isTapAuto;
    
    UIImagePickerController * imagePicker;
    
    NSMutableArray *images;
    
    float y;
    
    CGRect msgTextFrame;
    
    NSMutableArray *listingArray;
    
    NSString *member_id, *list_id, *type,*type_value;;
    
    NSDictionary *post_data;
    
    NSString *picture;
    
    NSString *name,*Id,*expiry_date,*list_type,*whatOnId,*city_name;
}
@end

@implementation editWhatsOnViewController

@synthesize scrollView, selectListBtn, chooseImgBtn, imgLbl, auto_msgBtn, customBtn, orLbl, postBtn, cancelBtn, img_view, message_textView, btnView,listInfo_lbl,charLimit_lbl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    self.navigationItem.title = @"Edit a \"What's On!\"";
    
    
    
    //You or your family may benefit from or enjoy this. If not, your friends might like it. Click Share!
    
    scrollView.frame = self.view.frame;
    
    getListConn = [WebServiceConnection connectionManager];
    
    whatsOnPostConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    listingArray = [[NSMutableArray alloc] init];
    
    selectListBtn.userInteractionEnabled = NO;
    
    [postBtn setTitle:@"Save Changes" forState:UIControlStateNormal];
    
    [postBtn setBackgroundColor:UIColorFromRGB(teal_text_color_hexcode)];
    
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    cancelBtn.layer.borderWidth = 1.0f;
    
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        chooseImgBtn.layer.cornerRadius = 22.5f;
        
        orLbl.layer.cornerRadius = 30.0f;
        
        y = 250;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height +50);
        
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        chooseImgBtn.layer.cornerRadius = 15.0f;
        
        orLbl.layer.cornerRadius = 20.0f;
        
        y = 180;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    }
    
    isTapAuto = YES;
    
    orLbl.layer.masksToBounds = YES;
    
    selectListBtn.layer.borderWidth = 1.0f;
    
    selectListBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    selectListBtn.layer.cornerRadius = 5.0f;
    
    chooseImgBtn.layer.borderWidth = 1.0f;
    
    chooseImgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    auto_msgBtn.layer.borderWidth = 1.0f;
    
    auto_msgBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    auto_msgBtn.layer.cornerRadius = 3.0f;
    
    customBtn.layer.borderWidth = 1.0f;
    
    customBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    customBtn.layer.cornerRadius = 3.0f;
    
    [customBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    cancelBtn.layer.cornerRadius = 5.0f;
    
    postBtn.layer.cornerRadius = 5.0f;
    
    msgTextFrame = message_textView.frame;
    
    CGRect frame = btnView.frame;
    
    frame.origin.y = msgTextFrame.origin.y + 20;
    
    btnView.frame = frame;
    
    message_textView.hidden = YES;
    
    member_id = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"];
    
    [self setDetails];
}

-(void)setDetails {
    
    post_data = [[NSUserDefaults standardUserDefaults] valueForKey:@"whatsOnPost"];
    
    name = [post_data valueForKey:@"name"];
    
    city_name =  [post_data valueForKey:@"city_name"];
    
    
    whatOnId = [post_data valueForKey:@"id"];
    
    [selectListBtn setTitle: [NSString stringWithFormat:@"  %@",[post_data valueForKey:@"name"]] forState:UIControlStateNormal];
    
    imgLbl.text = @"Image Attached";
    
    // NSString *descStr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"whatsOnPost"] valueForKey:@"description"];
    
    charLimit_lbl.hidden = YES;
    
    charLimit_lbl.text = @"Maximum 100 characters";
    
    //listInfo_lbl.text = descStr;
    
    listInfo_lbl.text = @"You or your family may benefit from or enjoy this. If not, your friends might like it. Click Share!";
    
    message_textView.text = @"You or your family may benefit from or enjoy this. If not, your friends might like it. Click Share!";
    
    NSString *radio_value = [post_data valueForKey:@"radio_value"];
    
    if ([radio_value isEqualToString:@"0"]) {
        
        [customBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        [auto_msgBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        isTapAuto = YES;
        
    } else {
        
        [customBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        [auto_msgBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        //NSString *desc = [post_data valueForKey:@"description"];
        
        message_textView.text = [post_data valueForKey:@"description"];
        
        message_textView.hidden = NO;
        
        charLimit_lbl.hidden = NO;
        
        CGRect frame = btnView.frame;
        
        //frame.origin.y = msgTextFrame.origin.y + msgTextFrame.size.height + 20;
        
        frame.origin.y = charLimit_lbl.frame.origin.y + charLimit_lbl.frame.size.height + 20;
        
        btnView.frame = frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, frame.origin.y + 100);
        
        isTapAuto = NO;
    }
    
    list_id = [post_data valueForKey:@"id"];
    
    type = [post_data valueForKey:@"listing_type"];
    
    type_value = type;
    
    if ([type isEqualToString:@"1"]) {
        
        type = @"course";
        
        Id = [post_data valueForKey:@"course_id"];
        
    } else if ([type isEqualToString:@"2"]) {
        
        type = @"event";
        
        Id = [post_data valueForKey:@"event_id"];
        
    } else if ([type isEqualToString:@"3"]) {
        
        type = @"lesson";
        
        Id = [post_data valueForKey:@"lesson_id"];
        
    }
    
    expiry_date =  [post_data valueForKey:@"expiry_date"];
    
    
    NSString *img = [post_data valueForKey:@"picture"];
    
    img = [@"http://mercury.promaticstechnologies.com/ecaHub//img/whatson_images/" stringByAppendingString:img];
    
    picture = img;
    
    [self downloadImageWithString:img];
}

#pragma  mark- Load Image To Cell

-(void)downloadImageWithString:(NSString *)urlString{
    
    [self.view addSubview:indicator];
    
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        [indicator removeFromSuperview];
        
        if ([data length] > 0) {
            
            images = [[NSMutableArray alloc] init];
            
            NSString *imagen = @"picture";
            
            [images addObject:@{@"fieldName" : imagen, @"fileName" : imagen, @"imageData" : data}];
            
            UIImage *image = [UIImage imageWithData:data];
            
            img_view.image = image;
        }
    }];
}

- (IBAction)tapSelectList:(id)sender {
    
    [self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id":member_id, @"id":[post_data valueForKey:@"id"]};
    
    [getListConn startConnectionWithString:@"select_whatson" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([getListConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if ([[receivedData valueForKey:@"code"] integerValue] == 0) {
                
                NSArray *listArray = [receivedData valueForKey:@"merged_array"];
                
                NSString *listing, *listId;
                
                NSDictionary *dict;
                
                if (listArray.count < 1) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"No member exits. Please add family member" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                } else {
                    
                    for (int i = 0; i < listArray.count; i++) {
                        
                        if ([[listArray objectAtIndex:i] valueForKey:@"CourseListing"]) {
                            
                            name = [[[listArray objectAtIndex:i] valueForKey:@"CourseListing"] valueForKey:@"course_name"];
                            
                            listId = [[[listArray objectAtIndex:i] valueForKey:@"CourseListing"] valueForKey:@"id"];
                            
                            listing = @"course";
                            
                            dict = @{@"name":name, @"list_id":listId, @"listing_type": listing};
                            
                            [listingArray addObject:dict];
                            
                        } else if ([[listArray objectAtIndex:i] valueForKey:@"LessonListing"]) {
                            
                            name = [[[listArray objectAtIndex:i] valueForKey:@"LessonListing"] valueForKey:@"lesson_name"];
                            
                            listId = [[[listArray objectAtIndex:i] valueForKey:@"LessonListing"] valueForKey:@"id"];
                            
                            listing = @"lesson";
                            
                            dict = @{@"name":name, @"list_id":listId, @"listing_type": listing};
                            
                            [listingArray addObject:dict];
                            
                        } else if ([[listArray objectAtIndex:i] valueForKey:@"EventListing"]) {
                            
                            name = [[[listArray objectAtIndex:i] valueForKey:@"EventListing"] valueForKey:@"event_name"];
                            
                            listId = [[[listArray objectAtIndex:i] valueForKey:@"EventListing"] valueForKey:@"id"];
                            
                            listing = @"event";
                            
                            dict = @{@"name":name, @"list_id":listId, @"listing_type": listing};
                            
                            [listingArray addObject:dict];
                        }
                    }
                    //                NSLog(@"%@", listingArray);
                    
                    [self showListData:[listingArray valueForKey:@"name"] allowMultipleSelection:NO selectedData:[selectListBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Select List"];
                }
            }
        }
    }];
}

-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title {
    
    ListingViewController *listViewController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"listingVC"];
        
    } else {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil] instantiateViewControllerWithIdentifier:@"listingVC"];
    }
    
    listViewController.isMultipleSelected = allowMultipleSelection;
    
    listViewController.array_data = [items mutableCopy];
    
    listViewController.selectedData = [selectedData mutableCopy];
    
    listViewController.delegate = self;
    
    listViewController.title = title;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - list delegate

-(void)didSelectListItem:(id)item index:(NSInteger)index {
    
    name = [[listingArray objectAtIndex:index] valueForKey:@"name"];
    
    name = [@"  " stringByAppendingString:name];
    
    [selectListBtn setTitle:name forState:UIControlStateNormal];
    
    list_id = [[listingArray objectAtIndex:index] valueForKey:@"list_id"];
    
    type = [[listingArray objectAtIndex:index] valueForKey:@"listing_type"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)tapPostBtn:(id)sender {
    
    NSString *my_text = @"0";
    
    NSString *message;
    
    if (!isTapAuto) {
        
        my_text = @"1";
        
        if ([message_textView.text isEqualToString:@"Enter Message"] || [message_textView.text isEqualToString:@" "]) {
            
            message = @"Please enter the message";
        }
    }
    
    if ([selectListBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        message = @"Please select the list";
        
    } else if ([imgLbl.text isEqualToString:@"No Image Selected"]) {
        
        message = @"Please select the image";
    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.view addSubview:indicator];
        
        if(expiry_date == nil){
            
            expiry_date = @"";
        }
        
        list_type = [type stringByAppendingString:@"_id"];
        
        NSDictionary *paramURL;
        
        //        paramURL= @{@"member_id": member_id,
        //                    @"listing_type":type_value,
        //                    @"list_id":list_id, @"my_text":my_text,
        //                    @"name":name,
        //                    list_type:Id,
        //                    @"expiry_date":expiry_date,
        //                    @"id":whatOnId};
        
        //NSString * CityName = @"[ ";
        
        //CityName = [CityName stringByAppendingString:type];
        
        //CityName = [CityName stringByAppendingString:@" | "];
        
        //CityName = [CityName stringByAppendingString:city_name];
        
        
        if([my_text isEqualToString:@"1"]){
            
            paramURL= @{@"description":message_textView.text,
                        @"type":type_value,
                        @"list_id":list_id, @"my_text":my_text,
                        @"id":whatOnId,@"city_name":city_name};
        }  else {
            
            paramURL= @{@"type":type_value,
                        @"list_id":list_id,
                        @"my_text":my_text,
                        @"id":whatOnId,@"city_name":city_name};
            
        }
        
        
        
        NSLog(@"%@ %@", paramURL,images);
        
        // [self downloadImageWithString:picture];
        {
            
            [whatsOnPostConn startConnectionToUploadMultipleImagesWithString:@"whatson_edit" images:images HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
                
                [indicator removeFromSuperview];
                
                if ([whatsOnPostConn responseCode] == 1) {
                    
                    NSLog(@"%@", receivedData);
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Your list has been successfully Posted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    // [alert show];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
        }
    }
    //member_id, picture, description, listing_type='course', list_id, (my_text=0 / my_test=1) {'0'=>'automatically generated description','1'=>'typed description'}
}

- (IBAction)tapCancelBtn:(id)sender {
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapAutoMsgBtn:(id)sender {
    
    isTapAuto = YES;
    
    CGRect frame = btnView.frame;
    
    frame.origin.y = msgTextFrame.origin.y + 20;
    
    btnView.frame = frame;
    
    message_textView.hidden = YES;
    
    charLimit_lbl.hidden = YES;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, frame.origin.y + 50);
    
    [customBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    
    [auto_msgBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
}

- (IBAction)tapCustomMsgBtn:(id)sender {
    
    if (isTapAuto) {
        
        message_textView.hidden = NO;
        
        charLimit_lbl.hidden = NO;
        
        CGRect frame = btnView.frame;
        
        //  frame.origin.y = msgTextFrame.origin.y + msgTextFrame.size.height + 20;
        
        frame.origin.y = charLimit_lbl.frame.origin.y + charLimit_lbl.frame.size.height + 20;
        
        btnView.frame = frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, frame.origin.y + 100);
        
        isTapAuto = NO;
        
        [customBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        [auto_msgBtn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
    }
}

#pragma mark - UIPickerView For Camera

-(void)openPictureViewWithCamera:(BOOL)camera {
    
    imagePicker =[[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    if (camera) {
        
        imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self performSelector: @selector(showPhotoGallery) withObject: nil afterDelay: 0];
    }
    else {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        // imagePicker.allowsEditing = YES;
        
        [self performSelector: @selector(showPhotoGallery) withObject: nil afterDelay: 0];
    }
}

- (void) showPhotoGallery {
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"%@", info);
    
    if (![[UIApplication sharedApplication] isStatusBarHidden])
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    UIImage *imagePickedFromLib,*image;
    
    NSData *pict;
    
    long size = [pict length];
    
    NSURL *mediaUrl = (NSURL *)[info valueForKey:UIImagePickerControllerMediaURL];
    
    if (mediaUrl == nil) {
        
        image = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
        
        pict = UIImageJPEGRepresentation(image, 0.7);
        
        size = [pict length];
        
        if(size > 80680){
            
            imagePickedFromLib = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerEditedImage]];
            
        } else {
            
            imagePickedFromLib = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
            
        }
        
        if (imagePickedFromLib == nil) {
            
            image = (UIImage *)[info valueForKey:
                                UIImagePickerControllerOriginalImage];
            
            pict = UIImageJPEGRepresentation(image, 0.7);
            
            size = [pict length];
            
            if(size > 80680){
                
                imagePickedFromLib = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerOriginalImage]];
                
            } else {
                
                imagePickedFromLib = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
                
            }
            
            [img_view setImage:imagePickedFromLib];
            
        } else {
            
            [img_view setImage:imagePickedFromLib];
        }
        
        imgLbl.text = @"Image Attached";
    }
    
    images = [[NSMutableArray alloc] init];
    
    pict = UIImageJPEGRepresentation(imagePickedFromLib, 0.7);
    
    
    NSString *imagen = @"picture";
    
    [images addObject:@{@"fieldName" : imagen, @"fileName" : imagen, @"imageData" : pict }];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}



- (UIImage *)scaleAndRotateImage:(UIImage *) image {
    int kMaxResolution = 512;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


#pragma mark - UITextView Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    NSString *newText = [ textView.text stringByReplacingCharactersInRange: range withString: text ];
    
    long len = 116 - [newText length];
    
    if(len < 0){
        
        len = 0;
    }
    
    charLimit_lbl.text = [NSString stringWithFormat:@"%ld characters left",len];
    
    NSString *leftChar = [NSString stringWithFormat:@"%lu", len];
    
    leftChar = [leftChar stringByAppendingString:@" characters left"];
    
    if( [newText length]<= 115 ){
        
        return TRUE;
        
    } else {
        
        return false;
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"Enter Message";
    }
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = 0;
    
    self.view.frame = frame;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Enter Message"]) {
        
        textView.text = @"";
    }
    
    CGRect frame = self.view.frame;
    
    frame.origin.y = -y;
    
    self.view.frame = frame;
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)           //Camera
    {
        if (buttonIndex == 0)
        {
            [self openPictureViewWithCamera:YES];
        }
        else if(buttonIndex == 1)
        {
            [self openPictureViewWithCamera:NO];
        }
    }
    else if (actionSheet.tag == 2)      //without camera
    {
        if (buttonIndex == 0) {
            
            [self openPictureViewWithCamera:NO];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)tapChooseImg:(id)sender {
    
    UIActionSheet * actionSheetForImage = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        actionSheetForImage = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Use Gallery", nil];
        [actionSheetForImage setTag:1];
    }
    else {
        
        actionSheetForImage = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery", nil];
        
        [actionSheetForImage setTag:2];
    }
    
    [actionSheetForImage showInView:self.view];
}

@end