//  AddLessionViewController.m
//  ecaHUB
//  Created by promatics on 4/1/15.
//  Copyright (c) 2015 promatics. All rights reserved.

#import "AddLessionViewController.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "Validation.h"
#import "AddEducatorViewController.h"
#import "AddTerms_ConditionViewController.h"
#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."

@interface AddLessionViewController () {
    
    WebServiceConnection *addLessionConnection;
    
    WebServiceConnection *getCategoryConn;
    
    WebServiceConnection *countryConn;
    
    AddEducatorViewController *educatorView;
    
    Indicator *indicator;
    
    Validation *validationobj;
    
    NSArray *typeArray;
    
    NSArray *array_interest;
    
    NSString *catIDs,*newcat_id, *city_id;
    
    NSString *sub_catIds;
    
    NSMutableArray *list_dataArray;
    
    NSMutableArray *cat_subCat_arr;
    
    id activeField;
    
    NSString *currentImg;
    
    UIImagePickerController *imagePicker;
    
    UIActionSheet *selectImageOptions;
    
    BOOL isCity,isState;
    NSString *state_id,*City_id;
    NSArray *locationArray,*stateArray;
    
    UIPickerView *pickerView;
    
    UIToolbar *toolBar;
    
    UIBarButtonItem *cancelButton;
    
    UIBarButtonItem *doneButton;
    BOOL checkbtn;
    BOOL img1;
    BOOL img2;
    BOOL img3;
    BOOL img4;
    BOOL img5;
    BOOL identityImg;
    BOOL tapCountry, tapType;
    
    NSString *country_id, *type_id;
    
    NSMutableArray *all_imageArray;
    NSMutableArray *logoImgArray, *img1_array,*img2_array,*img3_array,*img4_array,*img5_array, *countryArray;
    
    NSDictionary *addlessonDict;
}
@end

@implementation AddLessionViewController

@synthesize scrollView, lession_name, lession_img1, lession_img2, lession_img3, lession_img4, lession_img5, identity_img, description_textView, hours, mints, categoriesBtn, addSession, T_CBtn, aboutEducator, noOfSession, limit_chars, save_btn, cancel_btn, countryBtn, type_bttn,newcategory_textfield,check_btn,state_btn,city_btn,limit36char_lbl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.save_btn.hidden = YES;
    
    self.cancel_btn.hidden = YES;
    
    self.title =@"Create a Lesson";
    
    //self.navigationController.navigationBar.topItem.title = @"";
    
    addLessionConnection = [WebServiceConnection connectionManager];
    
    getCategoryConn = [WebServiceConnection connectionManager];
    
    countryConn = [WebServiceConnection connectionManager];
    
    logoImgArray = [[NSMutableArray alloc] init];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
    validationobj = [Validation validationManager];
    
    cat_subCat_arr = [[NSMutableArray alloc] init];
    
    list_dataArray = [[NSMutableArray alloc] init];
    
    imagePicker = [[UIImagePickerController alloc] init];
    
    newcategory_textfield.hidden = YES;
    
    selectImageOptions = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Gallery", @"Take Photo", nil];
    
    [aboutEducator addTarget:self action:@selector(tapEducatorBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    imagePicker.delegate = self;
    
    [type_bttn setTitle:@"  Select" forState:UIControlStateNormal];
    
    newcat_id = @"";
    
    checkbtn = NO;
    
    img1 = NO;
    img2 = NO;
    img3 = NO;
    img4 = NO;
    img5 = NO;
    
    isState = NO;
    isCity = NO;
    identityImg = NO;
    tapCountry = NO;
    tapType = NO;
    
    all_imageArray = [[NSMutableArray alloc] init];
    
    img1_array = [[NSMutableArray alloc] init];
    
    img2_array = [[NSMutableArray alloc] init];
    
    img3_array = [[NSMutableArray alloc] init];
    
    img4_array = [[NSMutableArray alloc] init];
    
    img5_array = [[NSMutableArray alloc] init];
    
    [self prepareInterface];
    
    [self fetchRequiredData];
}

-(void)prepareInterface {
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.T_CBtn.frame.origin.y +self.T_CBtn.frame.size.height + 30);//1500
        
        CGRect frame = lession_name.frame;
        
        frame.size.height = 45.0f;
        
        lession_name.frame = frame;
        
        frame = hours.frame;
        
        frame.size.height = 45.0f;
        
        hours.frame = frame;
        
        frame = mints.frame;
        
        frame.size.height = 45.0f;
        
        mints.frame = frame;
        
        frame = newcategory_textfield.frame;
        
        frame.size.height = 45.0f;
        
        newcategory_textfield.frame = frame;
        
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.frame = self.view.frame;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.T_CBtn.frame.origin.y +self.T_CBtn.frame.size.height + 30);//1050
        
        CGRect frame = lession_name.frame;
        
        frame.size.height = 30.0f;
        
        lession_name.frame = frame;
        
        frame = hours.frame;
        
        frame.size.height = 30.0f;
        
        hours.frame = frame;
        
        frame = mints.frame;
        
        frame.size.height = 30.0f;
        
        mints.frame = frame;
        
        frame = newcategory_textfield.frame;
        
        frame.size.height = 30.0f;
        
        newcategory_textfield.frame = frame;
    }
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    tapScroll.cancelsTouchesInView = NO;
    
    lession_name.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Lesson name e.g.. Academic Writing, Piano for Beginners, Math Tutorial" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    hours.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Hours" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    mints.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"Minutes" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(placeholder_text_color_hexcode)}];
    
    check_btn.layer.cornerRadius = 3.0f;
    
    check_btn.layer.borderWidth = 1.0f;
    
    check_btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [check_btn setBackgroundImage:[UIImage imageNamed:@"un-check"] forState:UIControlStateNormal];
    
    self.typeLable.layer.borderWidth = 1.0f;
    
    self.typeLable.layer.borderWidth = 1.0f;
    
    self.typeLable.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.typeLable.layer.cornerRadius = 5.0f;
    
    [scrollView addGestureRecognizer:tapScroll];
    
    type_bttn.layer.cornerRadius = 5.0f;
    
    type_bttn.layer.borderWidth = 1.0f;
    
    type_bttn.layer.borderColor = [UIColor blackColor].CGColor;
    
    if ([type_bttn.titleLabel.text isEqualToString:@"  Select"]) {
        
        [type_bttn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
    }
    
    else{
        
        [type_bttn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }
    
    categoriesBtn.layer.cornerRadius = 5.0f;
    
    categoriesBtn.layer.borderWidth = 1.0f;
    
    categoriesBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    if ([categoriesBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        [categoriesBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
    }
    
    else{
        
        [categoriesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }
    
    newcategory_textfield.layer.cornerRadius = 5.0f;
    
    newcategory_textfield.layer.borderWidth = 1.0f;
    
    newcategory_textfield.layer.borderColor = [UIColor blackColor].CGColor;
    
    countryBtn.layer.cornerRadius = 5.0f;
    
    countryBtn.layer.borderWidth = 1.0f;
    
    countryBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    if ([countryBtn.titleLabel.text isEqualToString:@"  Country"]) {
        
        [countryBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
       
    }
    
    else{
        
        [countryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    state_btn.layer.cornerRadius = 5.0f;
    
    state_btn.layer.borderWidth = 1.0f;
    
    state_btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    if ([state_btn.titleLabel.text isEqualToString:@"  State"]) {
        
        [state_btn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
    }
    
    else{
        
        [state_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      
    }
    
    city_btn.layer.cornerRadius = 5.0f;
    
    city_btn.layer.borderWidth = 1.0f;
    
    city_btn.layer.borderColor = [UIColor blackColor].CGColor;
    
    if ([city_btn.titleLabel.text isEqualToString:@"  City"]) {
        
        [city_btn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
    } else {
        
        [city_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    save_btn.layer.cornerRadius = 5.0f;
    
    cancel_btn.layer.cornerRadius = 5.0f;
    
    addSession.layer.cornerRadius = 5.0f;
    
    T_CBtn.layer.cornerRadius = 5.0f;
    
    aboutEducator.layer.cornerRadius = 5.0f;
    
    description_textView.layer.borderWidth = 1.0f;
    
    description_textView.layer.borderColor = [UIColor blackColor].CGColor;
    
    description_textView.layer.cornerRadius = 5.0f;
    
    description_textView.textColor = UIColorFromRGB(placeholder_text_color_hexcode);
    
    lession_name.layer.cornerRadius = 5.0f;
    
    lession_name.layer.borderWidth = 1.0f;
    
    lession_name.layer.borderColor = [UIColor blackColor].CGColor;
    
    hours.layer.cornerRadius = 5.0f;
    
    hours.layer.borderWidth = 1.0f;
    
    hours.layer.borderColor = [UIColor blackColor].CGColor;
    
    mints.layer.cornerRadius = 5.0f;
    
    mints.layer.borderWidth = 1.0f;
    
    mints.layer.borderColor = [UIColor blackColor].CGColor;
    
    lession_img1.layer.cornerRadius = 5.0f;
    
    lession_img2.layer.cornerRadius = 5.0f;
    
    lession_img3.layer.cornerRadius = 5.0f;
    
    lession_img4.layer.cornerRadius = 5.0f;
    
    lession_img5.layer.cornerRadius = 5.0f;
    
    identity_img.layer.cornerRadius = 5.0f;
    
    ////   Image
    
    lession_img1.userInteractionEnabled = YES;
    
    lession_img2.userInteractionEnabled = YES;
    
    lession_img3.userInteractionEnabled = YES;
    
    lession_img4.userInteractionEnabled = YES;
    
    lession_img5.userInteractionEnabled = YES;
    
    identity_img.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gest1 = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(selectImage1:)];
    
    gest1.numberOfTapsRequired = 1;
    
    gest1.delegate = self;
    
    [lession_img1 addGestureRecognizer:gest1];
    
    UITapGestureRecognizer *gest2 = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(selectImage2:)];
    gest2.delegate = self;
    
    [lession_img2 addGestureRecognizer:gest2];
    
    UITapGestureRecognizer *gest3 = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(selectImage3:)];
    gest3.delegate = self;
    
    [lession_img3 addGestureRecognizer:gest3];
    
    UITapGestureRecognizer *gest4 = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(selectImage4:)];
    gest4.delegate = self;
    
    [lession_img4 addGestureRecognizer:gest4];
    
    UITapGestureRecognizer *gest5 = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(selectIdentityImage:)];
    gest5.delegate = self;
    
    [identity_img addGestureRecognizer:gest5];
    
    UITapGestureRecognizer *gest6 = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self action:@selector(selectImage5:)];
    gest6.delegate = self;
    
    [lession_img5 addGestureRecognizer:gest6];
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePickerView)];
    
    tapgest.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapgest];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier]isEqualToString:@"LessonTermSegue"]) {
        
        AddTerms_ConditionViewController *termVC =[segue destinationViewController];
        
        termVC.lessonData = addlessonDict;
    }
}
-(void)tapEducatorBtn:(UIButton *)sender{
    
    if (!country_id && !state_id && !city_id) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please fill the Country, state, city fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
              
    }else{
        
        NSDictionary *dict =@{@"country_id":country_id, @"city_id":city_id,@"state_id":state_id, @"country_name":countryBtn.titleLabel.text, @"state_name":state_btn.titleLabel.text, @"city_name":city_btn.titleLabel.text};
        
        [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"location_data"];
        
        UIStoryboard *storyboard = self.storyboard;
        
        educatorView = [storyboard instantiateViewControllerWithIdentifier:@"addEducator"];
        
        [self.navigationController pushViewController:educatorView animated:YES];
    }
}

#pragma mark - Hide Picker View

-(void)hidePickerView {
    
    [toolBar removeFromSuperview];
    [pickerView removeFromSuperview];
}


- (void)selectImage1:(UIGestureRecognizer *)gestureRecognizer
{
    currentImg = @"1";
    
    //[selectImageOptions showInView:self.view];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)selectImage2:(UIGestureRecognizer *)gestureRecognizer
{
    currentImg = @"2";
    
    //[selectImageOptions showInView:self.view];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectImage3:(UIGestureRecognizer *)gestureRecognizer
{
    currentImg = @"3";
    
    //[selectImageOptions showInView:self.view];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectImage4:(UIGestureRecognizer *)gestureRecognizer
{
    currentImg = @"4";
    
    //[selectImageOptions showInView:self.view];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectImage5:(UIGestureRecognizer *)gestureRecognizer
{
    currentImg = @"6";
    
    //[selectImageOptions showInView:self.view];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectIdentityImage:(UIGestureRecognizer *)gestureRecognizer
{
    currentImg = @"5";
    
    //[selectImageOptions showInView:self.view];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    switch (buttonIndex) {
        case 0:
            
            [self showGallery];
            
            break;
        case 1:
            
            [self showCamera];
            
            break;
            
        default:
            break;
    }
}

- (void) showGallery {
    
    //imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void) showCamera {
    
    //imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    NSLog(@"%@", info);
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.7f);
    
    CGFloat compressionFactor = 0.7f;
    
    NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imageData length]);
    
    long size = [imageData length];
    
    if(size > 80680){
        
        chosenImage = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerOriginalImage]];
    }
    
    //    if(size > 512000 || size < 71680) {
    
    if(size > 512000) {
        
        //        if(size < 71680) {
        //
        //            while([imageData length] < 71680) {
        //
        //                compressionFactor += 0.1;
        //
        //                imageData = UIImageJPEGRepresentation(chosenImage, compressionFactor);
        //
        //                NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imageData length]);
        //
        //            }
        //
        //        } else {
        
        while([imageData length] > 512000) {
            
            compressionFactor -= 0.1f;
            
            imageData = UIImageJPEGRepresentation(chosenImage, compressionFactor);
            NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imageData length]);
            
            if (compressionFactor <= 0.0  ) {
                
                
                break;
            }
            
        }
        
        // }
    }
    
    NSData *imgData = UIImageJPEGRepresentation(chosenImage, compressionFactor);
    NSLog(@"Size of Image(bytes):%lu",(unsigned long)[imgData length]);
    
    size = [imgData length];
    
    //    if (size < 71680 || size > 512000) {  //70 kb - 500 kb
    //
    //
    //
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please ensure your images are between 70kb to 500kb" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        
    //        [alert show];
    //        
    //    } else {
    
        if ([currentImg isEqualToString:@"1"]) {
            
            lession_img1.image = chosenImage;
            img1 = YES;
            
            [img1_array addObjectsFromArray:@[@{@"fieldName" : @"picture0", @"fileName" : @"picture0", @"imageData" : UIImageJPEGRepresentation(lession_img1.image, compressionFactor)}]];
        }
        if ([currentImg isEqualToString:@"2"]) {
            
            lession_img2.image = chosenImage;
            img2 = YES;
            
            [img2_array addObjectsFromArray:@[@{@"fieldName" : @"picture1", @"fileName" : @"picture1", @"imageData" : UIImageJPEGRepresentation(lession_img2.image, compressionFactor)}]];
            
        }
        if ([currentImg isEqualToString:@"3"]) {
            
            lession_img3.image = chosenImage;
            img3 = YES;
            
            [img3_array addObjectsFromArray:@[@{@"fieldName" : @"picture2", @"fileName" : @"picture2", @"imageData" : UIImageJPEGRepresentation(lession_img3.image, compressionFactor)}]];
        }
        if ([currentImg isEqualToString:@"4"]) {
            
            lession_img4.image = chosenImage;
            
            img4 = YES;
            
            [img4_array addObjectsFromArray:@[@{@"fieldName" : @"picture3", @"fileName" : @"picture3", @"imageData" : UIImageJPEGRepresentation(lession_img4.image, compressionFactor)}]];
        }
        if ([currentImg isEqualToString:@"6"]) {
            
            lession_img5.image = chosenImage;
            
            img5 = YES;
            
            [img5_array addObjectsFromArray:@[@{@"fieldName" : @"picture4", @"fileName" : @"picture4", @"imageData" : UIImageJPEGRepresentation(lession_img5.image, compressionFactor)}]];
        }
        if ([currentImg isEqualToString:@"5"]) {
            
            identity_img.image = chosenImage;
            identityImg = YES;
            
            [logoImgArray addObjectsFromArray:@[@{@"fieldName" : @"logo", @"fileName" : @"logo", @"imageData" : UIImageJPEGRepresentation(identity_img.image, compressionFactor)}]];
        }
    //}
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//chosenImage = [self scaleAndRotateImage: [info objectForKey:UIImagePickerControllerOriginalImage]];
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



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma  mark - get Interest List

-(void)fetchRequiredData {
    
    NSDictionary *paramUrl = @{ };
    
    [getCategoryConn startConnectionWithString:[NSString stringWithFormat:@"interested_list"] HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary *recievdData) {
        
        NSLog(@"%@",recievdData);
        
        if ([getCategoryConn responseCode] == 1) {
            
            array_interest = (NSArray *)recievdData;
            
            [self setListData];
        }
    }];
}

-(void) setListData {
    
    for (int i = 0; i < array_interest.count; i++) {
        
        [list_dataArray addObject:@{@"type" : @"Category", @"categoryIndex" : [NSNumber numberWithInt:i], @"subCatIndex" : @"0"}];
        
        for (int j=0; j < [[[array_interest objectAtIndex:i] valueForKey:@"Subcategory"] count]; j++) {
            
            [list_dataArray addObject:@{@"type" : @"SubCategory", @"categoryIndex" : [NSNumber numberWithInt:i], @"subCatIndex" : [NSNumber numberWithInt:j]}];
        }
    }
    
    for (int i = 0; i<list_dataArray.count; i++) {
        
        if ([[[list_dataArray objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"Category"]) {
            
            NSNumber *cat_index = [[list_dataArray objectAtIndex:i] valueForKey:@"categoryIndex"];
            
            [cat_subCat_arr addObject:[[array_interest objectAtIndex:[cat_index integerValue]] valueForKey:@"Category"]];
            
        } else {
            
            NSNumber *cat_index = [[list_dataArray objectAtIndex:i] valueForKey:@"categoryIndex"];
            
            NSNumber *sub_catIndex = [[list_dataArray objectAtIndex:i] valueForKey:@"subCatIndex"];
            
            [cat_subCat_arr addObject:[[[array_interest objectAtIndex:[cat_index integerValue]] valueForKey:@"Subcategory"] objectAtIndex:[sub_catIndex integerValue]]];
        }
    }
    
    NSLog(@"%@", cat_subCat_arr);
}

- (IBAction)tappedCatBtn:(id)sender {
    
    if (array_interest == nil || array_interest.count < 1 ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Categories" message:@"Please wait while categories is loading." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        
        return;
    }
    
    [self showListData:list_dataArray allowMultipleSelection:YES selectedData:[categoriesBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Categories"];
    
    if ([categoriesBtn.titleLabel.text isEqualToString:@"  Select"]) {
        
        [categoriesBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
    }
    
    else{
       
        [categoriesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }
}

- (IBAction)tap_AddTermAndCondBtn:(id)sender {
    
    NSString *message;
    
    if (img1) {
        
        [all_imageArray addObjectsFromArray:img1_array];
    }
    if (img2) {
        
        [all_imageArray addObjectsFromArray:img2_array];
    }
    if (img3) {
        
        [all_imageArray addObjectsFromArray:img3_array];
        
    }if (img4) {
        
        [all_imageArray addObjectsFromArray:img4_array];
        
    }if (img5) {
        
        [all_imageArray addObjectsFromArray:img5_array];
    }
    
    if ([all_imageArray count] < 2) {
        
        message = @"Please select minimum two images.";
        
    } else if (!identityImg) {
        
        message = @"Please upload an Identity image, such as a profile picture or logo.";
        
    } else if ([lession_name.text isEqualToString:@""]) {
        
        message = @"Please enter the Lesson name.";
        
    } else if ([description_textView.text isEqualToString:@"Description"] || [description_textView.text isEqualToString:@""]) {
        
        message = @"Please enter the Lesson description.";
        
    } else if ([description_textView.text length] < 100) {
        
        message = @"Please enter minimum 100 characters about Lesson description.";
        
    } else if (!type_id) {
        
        message = @"Please select teaching method.";
        
    } else if ([countryBtn.titleLabel.text isEqualToString:@"  Country"]) {
        
        message = @"Please select country.";
        
    }else if ([state_btn.titleLabel.text isEqualToString:@"  State"]) {
        
        message = @"Please select state.";
        
    }else if ([city_btn.titleLabel.text isEqualToString:@"  City"]) {
        
        message = @"Please select city.";
        
    } else if ([hours.text isEqualToString:@""] || (![validationobj validateNumberDigits:hours.text])) {
        
        message = @"Please enter valid hours.";
        
//    } else if ([mints.text isEqualToString:@""] || (![validationobj validateNumberDigits:mints.text])) {
//        
//        message = @"Please enter valid hours";
        
//    } else if (![[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"]) {
//        
//        message = @"Please add terms & conditions";
//        
//    } else if (![[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"]) {
//        
//        message = @"Please add the educator details";
//        
//    } else if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"enrollment"]) {
//        
//        message = @"Please select the enrollment";
        
    }
    else{
        if (checkbtn){
            
            if ([newcategory_textfield.text isEqualToString:@""]) {
                
                message = @"Please enter the new category.";
            }
        }else {
            
            if ([categoriesBtn.titleLabel.text isEqualToString:@"  Select"]) {
                
                message = @"Please select atleast one category.";
            }
        }
    }
    id educator_img = [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"identity"];
    
    if ([educator_img isKindOfClass:[NSNull class]] || [educator_img isKindOfClass:[NSString class]]) {
        
        message = @"Please select the educator Identity Image.";
    }
    
    if ([message length] > 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    } else {
        
        [self.view addSubview:indicator];
        
        long img_count = all_imageArray.count;
        
        NSString *no_img = [NSString stringWithFormat:@"%lu",img_count];
        
        NSDictionary *paramURL1;
        
        NSDictionary *paramURL2;
        
        paramURL1 = @{@"lesson_name":lession_name.text,
                         @"no_img":no_img,
                         @"lesson_description":description_textView.text,
                         @"lesson_type":@"1",
                         @"type": type_id,
                         @"lesson_duration_hours":hours.text,
                         @"lesson_duration_minutes":mints.text,
                         @"country_id" : country_id,
                         @"new_category":newcat_id,@"new_category_name":newcategory_textfield.text,@"state_id":state_id,@"city_id":city_id
                         };
            
       
            paramURL2 = @{@"lesson_name":lession_name.text,
                         @"no_img":no_img,
                         @"lesson_description":description_textView.text,
                         @"category_id": catIDs,
                         @"subcategory_id":sub_catIds,
                         @"lesson_type":@"1",
                         @"type": type_id,
                         @"lesson_duration_hours":hours.text,
                         @"lesson_duration_minutes":mints.text,
                         @"country_id" : country_id,
                         @"state_id":state_id,@"city_id":city_id};
       
        //new_category=>1, and new_category_name
        
        NSLog(@"%@ %@",paramURL1,paramURL2);
        
        NSArray *educator_img = [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"identity"];
        
        [all_imageArray addObjectsFromArray:logoImgArray];
        
        [all_imageArray addObjectsFromArray:educator_img];
        
        addlessonDict = @{@"imageArray":all_imageArray,@"paramURL1":paramURL1,@"paramURL2":paramURL2,@"newcat_id":newcat_id};
        
        [indicator removeFromSuperview];
        
        [self performSegueWithIdentifier:@"LessonTermSegue" sender:self];
        
//        [addLessionConnection startConnectionToUploadMultipleImagesWithString:[NSString stringWithFormat:@"add_lesson"] images:all_imageArray HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
//            
//            [indicator removeFromSuperview];
//            
//            if ([addLessionConnection responseCode] == 1) {
//                
//                NSLog(@"%@", receivedData);
//                
//                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
//                    
//                    [[NSUserDefaults standardUserDefaults] setValue:[receivedData valueForKey:@"generated_id"] forKey:@"course_id"];
//                    
//                    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"session_type"];
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject:type_id forKey:@"Lesson_Type"];
//                    
//                    [self performSegueWithIdentifier:@"addLessionSessionSegue" sender:self];
//                    
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"educator_data"];
//                    
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Term_CondData"];
//                    
//                    //  [self.navigationController popViewControllerAnimated:YES];
//                    
//                } else {
//                    
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please Fill all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    
//                    [alert show];
//                }
//            }
//        }];
    }

}

- (IBAction)tap_info_name_lbl:(id)sender {
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:Alert_title message:@"Once the Lesson Listing has been posted 'live' for other members to view, the Lesson Name cannot be edited." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (IBAction)tap_info_category_btn:(id)sender {
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:Alert_title message:@"Once you click 'post' on this Listing, your suggested new category or categories will be reviewed and your Listing will be posted either under your suggested new category or something very similar." delegate:nil cancelButtonTitle:@"Ok Thanks" otherButtonTitles:nil, nil];
    
    [alert show];
}

-(void)showListData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title {
    
    ListViewController *listViewController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil] instantiateViewControllerWithIdentifier:@"ListView"];
        
    } else {
        
        listViewController = [[UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil] instantiateViewControllerWithIdentifier:@"ListView"];
    }
    
    listViewController.isMultipleSelected = allowMultipleSelection;
    
    listViewController.array_data = [array_interest mutableCopy];
    
    listViewController.data_typeArray = items;
    
    listViewController.selectedData = selectedData;
    
    listViewController.delegate = self;
    
    listViewController.title = title;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - list delegate

-(void)didSaveItems:(NSArray*)items indexs:(NSArray*)indexs {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableArray *array_selectedInterest = [NSMutableArray array];
    
    NSMutableArray *array_catIds = [NSMutableArray array];
    
    NSMutableArray *array_subCatIds = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in indexs) {
        
        id name = [cat_subCat_arr[indexPath.row] valueForKey:@"subcategory_name"];
        
        if (name) {
            
            [array_selectedInterest addObject:[cat_subCat_arr[indexPath.row] valueForKey:@"subcategory_name"]];
            
            [array_subCatIds addObject:[cat_subCat_arr[indexPath.row] valueForKey:@"id"]];
            
            [array_catIds addObject:[cat_subCat_arr[indexPath.row] valueForKey:@"category_id"]];
            
        } else {
            
            [array_catIds addObject:[cat_subCat_arr[indexPath.row] valueForKey:@"id"]];
        }
    }
    
    [array_catIds setArray:[[NSSet setWithArray:array_catIds] allObjects]];
    
    NSString *cat_interest = [array_selectedInterest componentsJoinedByString:@", "];
    
    cat_interest = [@"  " stringByAppendingString:cat_interest];
    
    [categoriesBtn setTitle:cat_interest forState:UIControlStateNormal];
    
    [categoriesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    catIDs = [array_catIds componentsJoinedByString:@","];
    
    sub_catIds = [array_subCatIds componentsJoinedByString:@","];
    
    newcat_id = @"";
    
    NSLog(@"%@\n%@", catIDs,sub_catIds);
}

-(void)didCancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextfield Delegates & Datasource

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newText = [ lession_name.text stringByReplacingCharactersInRange: range withString: string ];
    
    long len = 36 - [newText length];
    
    if(len < 0){
        
        len = 0;
    }
    
    NSString *leftChar = [NSString stringWithFormat:@"%lu", len];
    
    leftChar = [leftChar stringByAppendingString:@" characters left"];
    
    limit36char_lbl.text = leftChar;
    
    if( [newText length]<= 36 ){
        // return [text isEqualToString:filtered];
        
        return TRUE;
    }
    
    lession_name.text = [newText substringToIndex: 35 ];
    
    return TRUE;
    

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    //scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.T_CBtn.frame.origin.y +self.T_CBtn.frame.size.height + 30);//1500
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.T_CBtn.frame.origin.y +self.T_CBtn.frame.size.height + 30);//1050
    }
    
    if (textField == hours) {
        
        if (![validationobj validateNumberDigits:hours.text]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please enter valid hours." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
            textField.text = @"";
        }
    }
    
    if (textField == mints) {
        
        int mint = [mints.text intValue];
        
        if (mint > 59 || mint < 0 || (![validationobj validateNumberDigits:textField.text])) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please enter mints between 00-59." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
            textField.text = @"";
        }
    }
    
    return TRUE;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return TRUE;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    activeField = nil;
}

#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //scrollView.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);

    activeField = textView;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"Description"]) {
        
        textView.text = @"";
    }
    
    textView.textColor = [UIColor darkGrayColor];
    
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
//    
//    NSString *filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
//    if ([text isEqualToString:@"\n"]) {
//        
//        [textView resignFirstResponder];
//        
//        return FALSE;
//    }
    
    NSString *newText = [ textView.text stringByReplacingCharactersInRange: range withString: text ];
    
    long len = 2000 - [newText length];
    
    if(len < 0) {
        
        len = 0;
    }
    
    NSString *leftChar = [NSString stringWithFormat:@"%lu", len];
    
    leftChar = [leftChar stringByAppendingString:@" characters left"];
    
    limit_chars.text = leftChar;
    
    if( [newText length]<= 2000 ) {
        
        return true;
    }
    
    // case where text length > MAX_LENGTH
    
    textView.text = [ newText substringToIndex: 1999 ];
    
    return true;}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length == 0 ) {
        
        textView.text = @"Description";
        
        textView.textColor = UIColorFromRGB(placeholder_text_color_hexcode);
    }
    
    if (textView.text.length < 100) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Minimum 100 characters required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
     //scrollView.frame = CGRectMake(0, 67, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark Lesson Type

- (IBAction)tapcheck_btn:(id)sender {
    
    if (checkbtn) {
        
        checkbtn = NO;
        
        [check_btn setBackgroundImage:[UIImage imageNamed:@"un_check"] forState:UIControlStateNormal];
        
        catIDs = @"";
        sub_catIds = @"";
        newcat_id = @"";
        newcategory_textfield.hidden = YES;
        
        categoriesBtn.hidden = NO;
        
    }
    else{
        
        checkbtn = YES;
        
        [check_btn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        
        newcategory_textfield.hidden = NO;
        
        categoriesBtn.hidden = YES;
        
        [categoriesBtn setTitle:@"  Select" forState:UIControlStateNormal];
        
        [categoriesBtn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
        
        catIDs = @"";
        sub_catIds = @"";
        newcat_id = @"1";
    }
    
    
}




- (IBAction)tapType_btn:(id)sender {
    
    tapType = YES;
    
    tapCountry = NO;
    
    typeArray = @[@{@"id":@"", @"name":@"Select"},@{@"id":@"1", @"name":@"Private Tutorial Lesson"}, @{@"id":@"2", @"name":@"Group Lesson"}, @{@"id":@"3", @"name":@"Online Private Tutorial Lesson"}, @{@"id":@"4", @"name":@"Online Group Lesson"}];
    
    [self showPicker];
    
}

//#pragma mark Country
//
//- (IBAction)tapCountry:(id)sender {
//
//    tapCountry = YES;
//
//    tapType = NO;
//
//    [self.view addSubview:indicator];
//
//    NSDictionary *paramURL = @{};
//
//    [countryConn startConnectionWithString:[NSString stringWithFormat:@"country"] HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
//
//        [indicator removeFromSuperview];
//
//        if ([countryConn responseCode] == 1) {
//
//            NSLog(@"%@", receivedData);
//
//            countryArray = [receivedData valueForKey:@"country"];
//
//            NSDictionary *dict = @{@"Country":@{@"country_name":@"Country", @"id":@""}};
//
//            NSDictionary *d = [[receivedData valueForKey:@"country"] copy];
//
//            countryArray =[d mutableCopy];
//
//            [countryArray insertObject:dict atIndex:0];
//
//
//            [self showPicker];
//        }
//    }];
//}
#pragma mark County

- (IBAction)tapCountry:(id)sender {
    
    isCity = NO;
    isState = NO;
    tapCountry = YES;
    tapType = NO;
    [self fetchLocation:@"country"];
  
}


- (IBAction)tapstate_btn:(id)sender {
    if ([country_id length] > 0) {
        
        isCity = NO;
        isState = YES;
        tapCountry = NO;
        
        [self fetchLocation:@"state"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please select country first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
  
}

- (IBAction)tapcity_btn:(id)sender {
    
    if ([state_id length] > 0) {
        
        isCity = YES;
        isState = NO;
        tapCountry = NO;
        
        [self fetchLocation:@"city"];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title  message:@"Please select state first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
  
}

-(void)fetchLocation:(NSString *)url {
    
    NSDictionary *paramURL;
    
    if (tapCountry) {
        
        paramURL = @{};
        
    } else if (isState){
        
        paramURL = @{@"country_id" : country_id};
        
    } else if (isCity) {
        
        paramURL = @{@"state_id" : state_id};
    }
    
    [self.view addSubview:indicator];
    
    [countryConn startConnectionWithString:url HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
        
        [indicator removeFromSuperview];
        
        if ([countryConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            if (tapCountry) {
                
                countryArray = [receivedData valueForKey:@"country"];
                
                [self showListingData:[[countryArray valueForKey:@"Country"] valueForKey:@"country_name"] allowMultipleSelection:NO selectedData:[countryBtn.titleLabel.text componentsSeparatedByString:@", "] title:@"Country"];
                
            } else if (isState){
                
                stateArray = [receivedData valueForKey:@"state"];
                
                [self showListingData:[[stateArray valueForKey:@"State"] valueForKey:@"state_name"] allowMultipleSelection:NO selectedData:[state_btn.titleLabel.text componentsSeparatedByString:@", "] title:@"State"];
                
            } else if (isCity) {
                
                locationArray = [receivedData valueForKey:@"city"];
                
                [self showListingData:[[locationArray valueForKey:@"City"] valueForKey:@"city_name"] allowMultipleSelection:NO selectedData:[city_btn.titleLabel.text componentsSeparatedByString:@", "] title:@"City"];
            }
        }
    }];
}

-(void)showListingData:(NSArray *)items allowMultipleSelection:(BOOL)allowMultipleSelection selectedData:(NSArray *)selectedData title:(NSString *)title {
    
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

-(void)didSelectListItem:(id)item index:(NSInteger)index{
    
    if (tapCountry) {
        
        NSString *name = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"country_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [countryBtn setTitle:name forState:UIControlStateNormal];
        
        country_id = [[[countryArray objectAtIndex:index] valueForKey:@"Country"] valueForKey:@"id"];
        
        [countryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    } else if (isState){
        
        NSString *name = [[[stateArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"state_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [state_btn setTitle:name forState:UIControlStateNormal];
        
        state_id = [[[stateArray objectAtIndex:index] valueForKey:@"State"] valueForKey:@"id"];
        
         [state_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    } else if (isCity) {
        
        NSString *name = [[[locationArray objectAtIndex:index] valueForKey:@"City"] valueForKey:@"city_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [city_btn setTitle:name forState:UIControlStateNormal];
        
        city_id = [[[locationArray objectAtIndex:index] valueForKey:@"City"] valueForKey:@"id"];
        
         [city_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) showPicker {
    
    [toolBar removeFromSuperview];
    
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboard:)];
    
    [cancelButton setWidth:20];
    
    doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneKeyboard:)];
    
    [cancelButton setWidth:50];
    
    pickerView = [[UIPickerView alloc] init];
    
    pickerView.delegate = self;
    
    pickerView.dataSource = self;
    
    CGRect frame = pickerView.frame;
    
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    
    frame.size.width = self.view.frame.size.width;
    
    pickerView.frame = frame;
    
    pickerView.backgroundColor = [UIColor lightGrayColor];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height- pickerView.frame.size.height) - 44, self.view.frame.size.width, 44)];
    
    toolBar.backgroundColor = [UIColor darkGrayColor];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar.items = @[cancelButton,flexibleItem, doneButton];
    
    [self.view addSubview:toolBar];
    
    [self.view addSubview:pickerView];
}

-(void)cancelKeyboard:(UIBarButtonItem *)sender {
    
    [countryBtn setTitle:@"  Country" forState:UIControlStateNormal];
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
}

-(void)doneKeyboard:(UIBarButtonItem *)sender {
    
    [toolBar removeFromSuperview];
    
    [pickerView removeFromSuperview];
    
}

#pragma mark - PickerView Delegates & Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *pickerlbl = (UILabel*)view;
    
    if (!pickerlbl){
        pickerlbl = [[UILabel alloc] init];
    }
    
    pickerlbl.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 30);
    
    [pickerlbl setLineBreakMode:NSLineBreakByClipping];
    
    [pickerlbl  setNumberOfLines:0];
    
    [pickerlbl  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [pickerlbl setFont:[UIFont systemFontOfSize:17]];
    
    pickerlbl.textAlignment = NSTextAlignmentCenter;
    
    // NSLog(@"%@",[[pickerArray objectAtIndex:row] valueForKey:@"name"]);
    
    NSString *text = [[typeArray objectAtIndex:row] valueForKey:@"name"];
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width - (1.0 * 2), FLT_MAX);
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect lable_frame = pickerlbl.frame;
    
    lable_frame.size.height = size.height + 10;
    
    [pickerlbl  setFrame:lable_frame];
    
    [pickerlbl sizeToFit];
    
    //Set text value
    pickerlbl.text = [[typeArray objectAtIndex:row] valueForKey:@"name"];
    
    return pickerlbl;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    
    UILabel *pickerlbl = [[UILabel alloc] init];
    
    pickerlbl.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 30);
    
    [pickerlbl setLineBreakMode:NSLineBreakByClipping];
    
    [pickerlbl  setNumberOfLines:0];
    
    [pickerlbl  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    [pickerlbl setFont:[UIFont systemFontOfSize:17]];
    
    NSString *text = [[typeArray objectAtIndex:2] valueForKey:@"name"];
    
    //NSLog(@"%@",[[pickerArray objectAtIndex:2] valueForKey:@"name"]);
    
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width - (1.0 * 2), FLT_MAX);
    
    CGRect frame = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    CGSize size = CGSizeMake(frame.size.width, frame.size.height + 1);
    
    CGRect lable_frame = pickerlbl.frame;
    
    lable_frame.size.height = size.height + 10;
    
    [pickerlbl sizeToFit];
    
    CGFloat height = size.height + 10;
    
    if (height < 50.0) {
        
        height = 50.0f;
    }
    return height;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (tapCountry) {
        
        return countryArray.count;
        
    } else {
        
        return typeArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (tapCountry) {
        
        return [[[countryArray objectAtIndex:row] valueForKey:@"Country"] valueForKey:@"country_name"];
        
    } else {
        
        return [[typeArray objectAtIndex:row] valueForKey:@"name"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *name;
    
    if (tapCountry) {
        
        name = [[[countryArray objectAtIndex:row] valueForKey:@"Country"] valueForKey:@"country_name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [countryBtn setTitle:name forState:UIControlStateNormal];
        
        country_id = [[[countryArray objectAtIndex:row] valueForKey:@"Country"] valueForKey:@"id"];
        
    } else {
        
        name = [[typeArray objectAtIndex:row] valueForKey:@"name"];
        
        name = [@"  " stringByAppendingString:name];
        
        [type_bttn setTitle:name forState:UIControlStateNormal];
        
        
        if ([name isEqualToString:@"  Select"]) {
            
            [type_bttn setTitleColor:UIColorFromRGB(placeholder_text_color_hexcode) forState:UIControlStateNormal];
            
        }
        
        else{
            
            [type_bttn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
        }
        
        type_id = [[typeArray objectAtIndex:row] valueForKey:@"id"];
    }
}

- (IBAction)tappedCancelBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - Add course
//
//- (IBAction)tappedSaveBtn:(id)sender {
//    
//    NSString *message;
//    
//    if (img1) {
//        
//        [all_imageArray addObjectsFromArray:img1_array];
//    }
//    if (img2) {
//        
//        [all_imageArray addObjectsFromArray:img2_array];
//    }
//    if (img3) {
//        
//        [all_imageArray addObjectsFromArray:img3_array];
//        
//    }if (img4) {
//        
//        [all_imageArray addObjectsFromArray:img4_array];
//        
//    }if (img5) {
//        
//        [all_imageArray addObjectsFromArray:img5_array];
//    }
//    
//    if ([all_imageArray count] < 2) {
//        
//        message = @"Please select atleast 2 images!";
//        
//    } else if (!identityImg) {
//        
//        message = @"Please select course identity image!";
//        
//    } else if ([lession_name.text isEqualToString:@""]) {
//        
//        message = @"Please enter the course name.";
//        
//    } else if ([description_textView.text isEqualToString:@"Description"] || [description_textView.text isEqualToString:@""]) {
//        
//        message = @"Please enter the course description.";
//        
//    } else if ([description_textView.text length] < 100) {
//        
//        message = @"Please enter minimum 100 characters about Lesson description.";
//        
//    } else if (!type_id) {
//        
//        message = @"Please select teaching method.";
//        
//    } else if ([countryBtn.titleLabel.text isEqualToString:@"  Country"]) {
//        
//        message = @"Please select country.";
//        
//    }else if ([state_btn.titleLabel.text isEqualToString:@"  State"]) {
//        
//        message = @"Please select state.";
//        
//    }else if ([city_btn.titleLabel.text isEqualToString:@"  City"]) {
//        
//        message = @"Please select city.";
//        
//    } else if ([hours.text isEqualToString:@""] || (![validationobj validateNumberDigits:hours.text])) {
//        
//        message = @"Please enter valid hours.";
//        
//        //    } else if ([mints.text isEqualToString:@""] || (![validationobj validateNumberDigits:mints.text])) {
//        //
//        //        message = @"Please enter valid Hours";
//        //        
//    } else if (![[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"]) {
//        
//        message = @"Please add terms & conditions.";
//        
//    } else if (![[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"]) {
//        
//        message = @"Please add the educator details.";
//        
//    } else if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"enrollment"]) {
//        
//        message = @"Please select the enrollment.";
//        
//    }
//    else{
//        if (checkbtn){
//            
//            if ([newcategory_textfield.text isEqualToString:@""]) {
//                
//                message = @"Please enter the new category.";
//            }
//        }else {
//            
//            if ([categoriesBtn.titleLabel.text isEqualToString:@"Categories"]) {
//                
//                message = @"Please select atleast one category.";
//            }
//        }
//    }
//    id educator_img = [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"identity"];
//    
//    if ([educator_img isKindOfClass:[NSNull class]] || [educator_img isKindOfClass:[NSString class]]) {
//        
//        message = @"Please select the educator Identity Image.";
//    }
//    
//    if ([message length] > 1) {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        
//        [alert show];
//        
//    } else {
//        
//        [self.view addSubview:indicator];
//        
//        long img_count = all_imageArray.count;
//        
//        NSString *no_img = [NSString stringWithFormat:@"%lu",img_count];
//        
//        NSDictionary *paramURL;
//        
//        if (![newcat_id isEqualToString:@""]) {
//            
//            paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
//                         @"lesson_name":lession_name.text,
//                         @"no_img":no_img,
//                         @"lesson_description":description_textView.text,
//                         @"lesson_type":@"1",
//                         @"type": type_id,
//                         @"lesson_duration_hours":hours.text,
//                         @"lesson_duration_minutes":mints.text,
//                         @"enrollment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"enrollment"],
//                         @"minimum_payment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"minimum_payment"],
//                         @"payment_deadline":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"payment_deadline"],
//                         @"deposit":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"deposit"],
//                         @"change_enrollment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"change_enrollment"],
//                         @"cancellation":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"cancellation"],
//                         @"refund":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"refund"],
//                         @"make_up_lessons":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"make_up_lessons"],
//                         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],
//                         @"currency":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"currency"],
//                         @"quantity_books_materials":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"quantity_books_materials"],
//                         @"currency_security":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"currency_security"],
//                         @"quantity_security":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"quantity_security"],
//                         @"country_id" : country_id,
//                         @"description_educator":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"description_educator"],
//                         @"name_educator":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"name_educator"],
//                         @"business_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"business_type"],
//                         @"author_venu_unit" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_unit"],
//                         @"author_venu_building_name" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_building_name"],
//                         @"author_venu_street":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_street"],
//                         @"author_venu_district":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_district"],
//                         @"author_country_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_country_id"],
//                         @"author_state_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_state_id"],
//                         @"author_city_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_city_id"],
//                         @"year":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"year"],
//                         @"offer":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"offer"],
//                         @"new_category":newcat_id,@"new_category_name":newcategory_textfield.text,@"state_id":state_id,@"city_id":city_id
//                         };
//            
//            
//        } else{
//            paramURL = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"],
//                         @"lesson_name":lession_name.text,
//                         @"no_img":no_img,
//                         @"lesson_description":description_textView.text,
//                         @"category_id": catIDs,
//                         @"subcategory_id":sub_catIds,
//                         @"lesson_type":@"1",
//                         @"type": type_id,
//                         @"lesson_duration_hours":hours.text,
//                         @"lesson_duration_minutes":mints.text,
//                         @"enrollment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"enrollment"],
//                         @"minimum_payment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"minimum_payment"],
//                         @"payment_deadline":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"payment_deadline"],
//                         @"deposit":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"deposit"],
//                         @"change_enrollment":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"change_enrollment"],
//                         @"cancellation":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"cancellation"],
//                         @"refund":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"refund"],
//                         @"make_up_lessons":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"make_up_lessons"],
//                         @"severe_weather":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"severe_weather"],
//                         @"currency":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"currency"],
//                         @"quantity_books_materials":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"quantity_books_materials"],
//                         @"currency_security":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"currency_security"],
//                         @"quantity_security":[[[NSUserDefaults standardUserDefaults] valueForKey:@"Term_CondData"] valueForKey:@"quantity_security"],
//                         @"country_id" : country_id,
//                         @"description_educator":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"description_educator"],
//                         @"name_educator":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"name_educator"],
//                         @"business_type":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"business_type"],
//                         @"author_venu_unit" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_unit"],
//                         @"author_venu_building_name" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_building_name"],
//                         @"author_venu_street":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_street"],
//                         @"author_venu_district":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_venu_district"],
//                         @"author_country_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_country_id"],
//                         @"author_state_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_state_id"],
//                         @"author_city_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"author_city_id"],
//                         @"year":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"year"],
//                         @"offer":[[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"offer"],@"state_id":state_id,@"city_id":city_id
//                         };
//        }
//        
//        //new_category=>1, and new_category_name
//        
//        NSLog(@"%@",paramURL);
//        
//        NSArray *educator_img = [[[NSUserDefaults standardUserDefaults] valueForKey:@"educator_data"] valueForKey:@"identity"];
//        
//        [all_imageArray addObjectsFromArray:logoImgArray];
//        
//        [all_imageArray addObjectsFromArray:educator_img];
//        
//        [addLessionConnection startConnectionToUploadMultipleImagesWithString:[NSString stringWithFormat:@"add_lesson"] images:all_imageArray HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData){
//            
//            [indicator removeFromSuperview];
//            
//            if ([addLessionConnection responseCode] == 1) {
//                
//                NSLog(@"%@", receivedData);
//                
//                if ([[receivedData valueForKey:@"code"] integerValue] == 1) {
//                    
//                    [[NSUserDefaults standardUserDefaults] setValue:[receivedData valueForKey:@"generated_id"] forKey:@"course_id"];
//                    
//                    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKey:@"session_type"];
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject:type_id forKey:@"Lesson_Type"];
//                    
//                    [self performSegueWithIdentifier:@"addLessionSessionSegue" sender:self];
//                    
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"educator_data"];
//                    
//                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Term_CondData"];
//                    
//                    //  [self.navigationController popViewControllerAnimated:YES];
//                    
//                } else {
//                    
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Alert_title message:@"Please Fill all the fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                    
//                    [alert show];
//                }
//            }
//        }];
//    }
//}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)registerForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    float kbHeight = 0.0;
    
    if (kbSize.width > kbSize.height) {
        
        kbHeight = kbSize.height;
        
    } else {
        
        kbHeight = kbSize.width;
    }
    
    NSLog(@"%f", self.view.frame.origin.x);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(67, 0.0, kbHeight-self.view.frame.origin.x, 0.0);
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        // [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1700)];//1500
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        // [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1300)];//1100
    }
    
    scrollView.contentInset = contentInsets;
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbHeight;
    
    UIView *activeView = activeField;
    
    if (!CGRectContainsPoint(aRect, activeView.frame.origin) ) {
        
        [scrollView scrollRectToVisible: activeView.frame  animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    scrollView.contentInset = contentInsets;
    
    //scrollView.scrollIndicatorInsets = contentInsets;
    
    scrollView.frame = CGRectMake(0, 67, self.view.frame.size.width, self.view.frame.size.height-120);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)hideKeyboard {
    
    [self.view endEditing:YES];
}

@end
