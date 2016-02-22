//
//  AdvanceSearchViewController.h
//  ecaHUB
//
//  Created by promatics on 5/4/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingViewController.h"

@interface AdvanceSearchViewController : UIViewController <UITextFieldDelegate, listingDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *from_dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *to_dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *type_courseBtn;
@property (weak, nonatomic) IBOutlet UIButton *type_lessonBtn;
@property (weak, nonatomic) IBOutlet UIButton *type_eventBtn;
@property (weak, nonatomic) IBOutlet UIButton *whereBtn;
@property (weak, nonatomic) IBOutlet UIButton *gender_MaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *gender_femaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *ageBtn;
@property (weak, nonatomic) IBOutlet UIButton *LanguageBtn;
@property (weak, nonatomic) IBOutlet UITextField *specific_textField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;

- (IBAction)tapFromBtn:(id)sender;
- (IBAction)tapToBtn:(id)sender;
- (IBAction)tapCourseTypeBtn:(id)sender;
- (IBAction)tapLessonTypeBtn:(id)sender;
- (IBAction)tapEventTypeBtn:(id)sender;
- (IBAction)tapLocationBtn:(id)sender;
- (IBAction)tapMaleBtn:(id)sender;
- (IBAction)tapFemaleBtn:(id)sender;
- (IBAction)tapAgeBtn:(id)sender;
- (IBAction)tapLangBtn:(id)sender;
- (IBAction)tapCancelBtn:(id)sender;
- (IBAction)tapSearchBtn:(id)sender;


@end


