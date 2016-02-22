//
//  DashboardViewController.m
//  ecaHUB
//
//  Created by promatics on 3/2/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardTableViewCell.h"
#import <FacebookSDK/FacebookSDK.h>
#import "StarRatingTableViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface DashboardViewController () {
    
    DashboardTableViewCell *cell;
    
    RatingView *back_StarView;
    
    WebServiceConnection *total_noConn, *deactivateConn,*starRatingConn;
    
    Indicator *indicator;
    
    CGFloat height, buttonWidth,labelWidth;
    
    CGFloat font;
    
    NSString *enroll_count, *listed_enroll_book, *posted_whatson_no, *total_lists,*myReview;
    
    NSString *friendInvite,*recommdation,*review,*listing,*myWhatsOn,*stars;
}
@end

@implementation DashboardViewController

@synthesize table_view,menuData,star_ratingView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        font = 23;
        
        height = 50;
        
        buttonWidth = 46;
        labelWidth = 46;
    
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        font = 19;
        
        height = 40;
        
        buttonWidth = 30;
        labelWidth = 30;
    }
    
    [self getMenuBar];
    
    total_noConn = [WebServiceConnection connectionManager];
    
    starRatingConn = [WebServiceConnection connectionManager];
    
    deactivateConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc] initWithFrame:self.view.frame];
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    
   [self getTotalCounts];
    
    [self starRating];
}

-(void)getTotalCounts {
    
    //[self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [total_noConn startConnectionWithString:@"badge_count" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
     //   [indicator removeFromSuperview];
        
        if ([total_noConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            
            myReview = [NSString stringWithFormat:@"%@",[receivedData valueForKey:@"review"]];
            enroll_count =[NSString stringWithFormat:@"%@",[receivedData valueForKey:@"enroll_count"]];
            listed_enroll_book = [NSString stringWithFormat:@"%@",[receivedData valueForKey:@"listed_enroll_book"]];
            posted_whatson_no = [NSString stringWithFormat:@"%@",[receivedData valueForKey:@"posted_whatson_no"]];
            total_lists = [NSString stringWithFormat:@"%@",[receivedData valueForKey:@"total_lists"]];
            
            
            [table_view reloadData];
        }
    }];
}
-(void)starRating {
    
    //[self.view addSubview:indicator];
    
    NSDictionary *paramURL = @{@"member_id" : [[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    [starRatingConn startConnectionWithString:@"rewards" HttpMethodType:Post_Type HttpBodyType:paramURL Output:^(NSDictionary *receivedData) {
        
        //   [indicator removeFromSuperview];
        
        if ([total_noConn responseCode] == 1) {
            
            NSLog(@"%@", receivedData);
            
            
            friendInvite = [NSString stringWithFormat:@"%@",[receivedData valueForKey:@"invite_friend"]];
            
            recommdation =[NSString stringWithFormat:@"%@",[receivedData valueForKey:@"recommendation"]];
            
            review = [NSString stringWithFormat:@"%@",[receivedData valueForKey:@"reviews"]];
            
            listing = [NSString stringWithFormat:@"%@",[receivedData valueForKey:@"listing_post"]];
            
            myWhatsOn = [NSString stringWithFormat:@"%@",[receivedData valueForKey:@"whats_on"]];
            
            stars = [NSString stringWithFormat:@"%@",[receivedData valueForKey:@"stars"]];
            
            
            [table_view reloadData];
            
        }
    }];
}

-(void) getMenuBar {
    
    if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"login"] valueForKey:@"ecaHubLogin"] integerValue] == 0) {
        
        menuData =  @[
                      @{
                          @"title" : @"Personal",
                          
                          @"items" : @[
                                  @{
                                      @"image" : @"Profile",
                                      @"title" : @"Profile",
                                      @"action" : ^{
                                          
                                          [self tappedMyProfile];
                                      }
                                      },
                                  @{
                                      @"image" : @"family_icon",
                                      @"title" : @"My Family",
                                      @"action" : ^{
                                          
                                          [self tappedMyFamily];
                                      }
                                      },
                                  @{
                                      @"image" : @"friends",
                                      @"title" : @"My Friends",
                                      @"action" : ^{
                                          
                                      }
                                      },
                                  @{
                                      @"image" : @"search",
                                      @"title" : @"My Search Preferences",
                                      @"action" : ^{
                                          
                                          [self mySearchPreferences];
                                      }
                                      },
                                  
                                  @{
                                      @"image" : @"fav",
                                      @"title" : @"My Favorites",
                                      @"action" : ^{
                                          
                                      }
                                      },
                                  
                                  @{
                                      @"image" : @"recomdation",
                                      @"title" : @" My Recommendations",
                                      @"action" : ^{
                                          
                                      }
                                      },
                                  
                                  @{
                                      @"image" : @"edit",
                                      @"title" : @"My Reviews",
                                      @"action" : ^{
                                          
                                      }
                                      },
                                  
                                  @{
                                      @"image" : @"target",
                                      @"title" : @"My Enrollments & Bookings",
                                      @"action" : ^{
                                          
                                      }
                                      }
                                  
                                  
                                  ]
                          },
                      @{
                          @"title" : @"Business",
                          
                          @"items" : @[
                                  @{
                                      @"image" : @"educator",
                                      @"title" : @"Business Profile",
                                      @"action" : ^{
                                          
                                          [self tappedBusinessProfile];
                                      }
                                      },
                                @{
                                      @"image" : @"list",
                                      @"title" : @"My Listings",
                                      @"action" : ^{
                                          
                                          [self tappedMyListing];
                                      }
                                      },
                                  @{
                                      @"image" : @"whatson",
                                      @"title" : @"My \"What's On!\" Posts",
                                      @"action" : ^{
                                          
                                          [self MyWhatsOnListing];
                                          
                                      }
                                      },
                                
                                  @{
                                      @"image" : @"multi_user",
                                      @"title" : @"Listing Enrollments & Bookings",
                                      @"action" : ^{
                                          
                                      }
                                      }
                                  ]
                          },
                    
                      @{
                          @"title" :@"Account",
                          
                          @"items" : @[
                                  @{
                                      @"image" : @"paypal",
                                      @"title" : @"Account Settings",
                                      @"action" : ^{
                                          
                                          [self tappedAccountSetting];
                                      }
                                      },
                                  @{
                                      @"image" : @"income",
                                      @"title" : @"Income",
                                      @"action" : ^{
                                          
                                           [self tappedIncome];
                                      }
                                      },
                                  @{
                                      @"image" : @"Paymentss",
                                      @"title" : @"Payments",
                                      @"action" : ^{
                                          
                                          [self tappedPayments];
                                      }
                                      },
                               
                                  @{
                                      @"image" : @"activate_deactivate",
                                      @"title" : @"Activate/Deactivate",
                                      @"action" : ^{
                                          
                                            [self DeactivateAccount];
                                      }
                                      }
                                  
                                  ]
                          },
                      @{
                          @"title" :@"",
                          
                          @"items" : @[
                                  @{
                                      @"image" : @"",
                                      @"title" : @"My Star Rating",
                                      @"action" : ^{
                                          
                                      }
                                      }
                                  ]
                          },
                      
                      
                      
                      @{
                          @"title" :@"Friends Joined"
                          },
                      @{
                          @"title" :@"Recommendations Joined"
                          },
                      @{
                          @"title" :@"Reviews Posted"
                          },
                      @{
                          @"title" :@"Listings Posted"
                          },
                      @{
                          @"title" :@"\"What's On!\" Posted"
                          },
                      @{
                          @"title" :@"Achieve More"
                          },
                      
                      @{
                          @"title" :@"",
                          @"items" :@[
                                  @{
                                      
                                      @"image" : @"help",
                                      @"title" : @"Help",
                                      @"action" : ^{
                                          
                                      }
                                      },
                                  @{
                                      @"image" : @"logout",
                                      @"title" : @"Log Out",
                                      @"action" : ^{
                                          
                                          [self logout];
                                      }
                                      }
                                  ]
                          }
                      ];
    } else {
        
        menuData = @[
                     @{
                         @"title" : @"Personal",
                         
                         @"items" : @[
                                 @{
                                     @"image" : @"Profile",
                                     @"title" : @"Profile",
                                     @"action" : ^{
                                         
                                         [self tappedMyProfile];
                                     }
                                     },
                                 //                                   @{
                                 //                                       @"image" : @"account",
                                 //                                       @"title" : @"Change Password",
                                 //                                       @"action" : ^{
                                 //
                                 //                                           [self tappedChangePassword];
                                 //                                       }
                                 //                                       },
                                 @{
                                     @"image" : @"family_icon",
                                     @"title" : @"My Family",
                                     @"action" : ^{
                                         
                                         [self tappedMyFamily];
                                     }
                                     },
                                 @{
                                     @"image" : @"friends",
                                     @"title" : @"My Friends",
                                     @"action" : ^{
                                         
                                         [self tappedMyFriends];
                                     }
                                     },
                                 @{
                                     @"image" : @"search",
                                     @"title" : @"My Search Preferences",
                                     @"action" : ^{
                                         
                                         [self mySearchPreferences];
                                     }
                                     },
                                 
                                 @{
                                     @"image" : @"fav",
                                     @"title" : @"My Favorites",
                                     @"action" : ^{
                                         
                                         [self tapMyFavorites];
                                     }
                                     },
                                 
                                 @{
                                     @"image" : @"recomdation",
                                     @"title" : @"My Recommendations",
                                     @"action" : ^{
                                         
                                         [self tapMyRecommendations];
                                     }
                                     },
                                 
                                 @{
                                     @"image" : @"edit",
                                     @"title" : @"My Reviews",
                                     @"action" : ^{
                                         
                                         [self tapMyReviews];
                                     }
                                     },
                                 
                                 @{
                                     @"image" : @"target",
                                     @"title" : @"My Enrollments & Bookings",
                                     @"action" : ^{
                                         
                                         [self tapMyEnrollments];
                                     }
                                     }
                                 
                                 
                                 ]
                         },
                     @{
                         @"title" : @"Business",
                         
                         @"items" : @[
                                 @{
                                     @"image" : @"educator",
                                     @"title" : @"Business Profile",
                                     @"action" : ^{
                                         
                                         [self tappedBusinessProfile];
                                     }
                                     },
                                 @{
                                     @"image" : @"list",
                                     @"title" : @"My Listings",
                                     @"action" : ^{
                                         
                                         [self tappedMyListing];
                                     }
                                     },
                                 @{
                                     @"image" : @"whatson",
                                     @"title" : @"My \"What's On!\" Posts",
                                     @"action" : ^{
                                         
                                         [self MyWhatsOnListing];
                                     }
                                     },
                                
                                 @{
                                     @"image" : @"multi_user",
                                     @"title" : @"Listing Enrollments & Bookings",
                                     @"action" : ^{
                                         
                                         [self ListingEnrollment];
                                     }
                                     }
                                 ]
                         },
                     
                     @{
                         @"title" :@"Account",
                         
                         @"items" : @[
                                 @{
                                     @"image" : @"paypal",
                                     @"title" : @"Account Settings",
                                     @"action" : ^{
                                         
                                         [self tappedAccountSetting];
                                     }
                                     },
                                @{
                                     @"image" : @"income",
                                     @"title" : @"Income",
                                     @"action" : ^{
                                         
                                         [self tappedIncome];
                                     }
                                     },
                                 @{
                                     @"image" : @"Paymentss",
                                     @"title" : @"Payments",
                                     @"action" : ^{
                                         
                                         [self tappedPayments];
                                     }
                                     },
                                 @{
                                     @"image" : @"changepswrd",
                                     @"title" : @"Change Password",
                                     @"action" : ^{
                                         
                                         [self tappedChangePassword];
                                     }
                                     },
                                 @{
                                     @"image" : @"activate_deactivate",
                                     @"title" : @"Activate/Deactivate",
                                     @"action" : ^{
                                         
                                         [self DeactivateAccount];
                                     }
                                     }
                                 
                                 ]
                         },
                     
                     //                                   @{
                     //                                       @"image" : @"account",
                     //                                       @"title" : @"Account",
                     //                                       @"action" : ^{
                     //
                     //                                       }
                     //                                       },
                     @{
                         @"title" :@"",
                         
                         @"items" : @[
                                 @{
                                     @"image" : @"",
                                     @"title" : @"My Star Rating",
                                     @"action" : ^{
                                         
                                     }
                                     }
                                 ]
                         },
                     @{
                         @"title" :@"Friends Joined"
                         },
                     @{
                         @"title" :@"Recommendations Joined"
                         },
                     @{
                         @"title" :@"Reviews Posted"
                         },
                     @{
                         @"title" :@"Listings Posted"
                         },
                     @{
                         @"title" :@"\"What's On!\" Posted",
                         },
                     @{
                         @"title" :@"Achieve More"
                         },
                     
                     @{
                         @"title" :@"",
                         @"items" :@[
                                 @{
                                     
                                     @"image" : @"help",
                                     @"title" : @"Help",
                                     @"action" : ^{
                                         
                                     }
                                     },
                                 @{
                                     @"image" : @"logout",
                                     @"title" : @"Log Out",
                                     @"action" : ^{
                                         
                                         [self logout];
                                     }
                                }
                                 ]
                         }
                     ];
    }
}

-(void)DeactivateAccount{
    
   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Do you want to deactivate your account" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"]);
     
        [self.view addSubview:indicator];
        
    NSDictionary *dict = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"]valueForKey:@"id"],@"first_name":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"]valueForKey:@"Member"]valueForKey:@"first_name"],@"email":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"]valueForKey:@"email"]};
        
        [deactivateConn startConnectionWithString:@"deactivateAccount" HttpMethodType:Post_Type HttpBodyType:dict Output:^(NSDictionary *receivedData) {
            
            [indicator removeFromSuperview];
            
            if ([deactivateConn responseCode] == 1) {
                
                NSLog(@"%@",receivedData);
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Alert_title message:@"Your account has been deactivate successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [self logout];
                
                [alert show];
            }
        }];
    }
}

-(void)mySearchPreferences {
    
    [self performSegueWithIdentifier:@"MySearchPreferences" sender:self];
}

-(void) logout {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    
    NSDictionary *login = @{@"login" : @"0", @"ecaHubLogin" : @"1"};
    
    [[NSUserDefaults standardUserDefaults] setValue:login forKey:@"login"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    
    [self performSegueWithIdentifier:@"login" sender:self];
}

-(void)tappedBusinessProfile {
    
    [self performSegueWithIdentifier:@"businessProfileSegue" sender:self];
}

-(void) tappedMyListing {
    
    [self performSegueWithIdentifier:@"MyListingSegue" sender:self];
}

-(void)tapMyRecommendations {

    [self performSegueWithIdentifier:@"myRecommendationSegue" sender:self];
}

-(void)tapMyEnrollments {
    
    [self performSegueWithIdentifier:@"myEnrollmentSegue" sender:self];
}

-(void)ListingEnrollment{
    
    [self performSegueWithIdentifier:@"ListingenrollSague" sender:self];
}

-(void) tappedMyProfile {
    
    [self performSegueWithIdentifier:@"myProfile" sender:self];
}

-(void) tappedChangePassword {
    
    [self performSegueWithIdentifier:@"changePassword" sender:self];
}

-(void)tapMyReviews {

    [self performSegueWithIdentifier:@"myReviewsSegue" sender:self];
}

-(void) tappedMyFamily {
    
    [self performSegueWithIdentifier:@"MyFamilySegue" sender:self];
}

-(void)tappedMyFriends {
    
    [self performSegueWithIdentifier:@"myFriendsSegue" sender:self];
}

-(void)tapMyFavorites {
    
    [self performSegueWithIdentifier:@"myFavSegue" sender:self];
}

-(void)MyWhatsOnListing{
    
    [self performSegueWithIdentifier:@"mywhtsOnSague" sender:self];
}

-(void)tappedPayments{
    
    [self performSegueWithIdentifier:@"paymentSague" sender:self];
}

-(void)tappedIncome{
    
    [self performSegueWithIdentifier:@"incomeSague" sender:self];
}

-(void)tappedAccountSetting{
    
    [self performSegueWithIdentifier:@"AccountSettingVC" sender:self];
}

#pragma mark - UITableView Delegates & Datasources

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    
    UILabel *label;
    
    if (section == 9) {
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
        
        /* Create custom view to display section header... */
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake((table_view.frame.size.width-150)/2, 0, 150, height)];
        
        label.layer.cornerRadius = 5.0f;
        
        label.layer.masksToBounds = YES;
        
        view.backgroundColor = [UIColor clearColor];
        
        label.textColor = [UIColor whiteColor];
        
        label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow_button"]];//blackColor
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [label setText:[[menuData objectAtIndex:section] valueForKey:@"title"]];
        
    } else {
    
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
        
        /* Create custom view to display section header... */
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-20, height)];
        
        view.backgroundColor = [UIColor lightGrayColor];
        
        label.textColor = [UIColor blackColor];
        
        [label setText:[[menuData objectAtIndex:section] valueForKey:@"title"]];
        
    }
    
    if (section == 2) {
     
        view.backgroundColor = [UIColor lightGrayColor];
    
    }
 
    [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:font]];
    
    [view addSubview:label];
    
    CALayer *layer = view.layer;
    
    //changed to zero for the new fancy shadow
    
    layer.shadowOffset = CGSizeZero;
    
    layer.shadowColor = [[UIColor whiteColor] CGColor];
    
    //changed for the fancy shadow
    
    layer.shadowRadius = 1.0f;
    
    layer.shadowOpacity = 0.30f;
    
    UILabel *starRating_lbl;
    
    if (section == 4||section == 5||section == 6||section == 7||section == 8) {
        
        UIButton *addSign = [[UIButton alloc]initWithFrame:CGRectMake(self.table_view.frame.size.width-buttonWidth-10, (height-buttonWidth)/2,buttonWidth, buttonWidth)];
        [addSign setBackgroundImage:[UIImage imageNamed:@"addSign"] forState:UIControlStateNormal];
        
        [addSign addTarget:self action:@selector(tapAddSign:) forControlEvents:UIControlEventTouchUpInside];
        
         addSign.tag =section;
        
        starRating_lbl = [[UILabel alloc]initWithFrame:CGRectMake(addSign.frame.origin.x-labelWidth-5,(height-buttonWidth)/2, labelWidth, labelWidth)];
        
        [starRating_lbl setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow_button"]]];
        
       [starRating_lbl setFont:[UIFont fontWithName:@"Helvetica Neue" size:19]];
      
       // starRating_lbl.text = [NSString stringWithFormat:@"%lu",(long)section];
        
        [view addSubview:addSign];
        
        [view addSubview:starRating_lbl];
        
        if (section == 4) {
            
            starRating_lbl.text = [NSString stringWithFormat:@"%@",friendInvite];
            
        } else if (section == 5){
            
           starRating_lbl.text = [NSString stringWithFormat:@"%@",recommdation];
        }else if (section == 6){
            
            starRating_lbl.text = [NSString stringWithFormat:@"%@",review];
        }
        else if (section == 7){
            
            starRating_lbl.text = [NSString stringWithFormat:@"%@",listing];
            
        }else if (section == 8){
            
            starRating_lbl.text = [NSString stringWithFormat:@"%@",myWhatsOn];
        }
        
        
    }
    
   if (section == 4||section == 5||section == 6||section == 7||section == 8) {
       
       view.backgroundColor = [UIColor whiteColor];
    }
    
    
    return view;
}
    
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [menuData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 10 || section == 3) {
       
        return 0;
    }

    else {
        
        return height;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 ||section == 10|| section == 3 || section == 2|| section ==1) {
        
        return 0;
   
    }
    
    else {
      
        return 5;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view;
    
     view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    
    if (section == 4) {
        
        view.backgroundColor = [UIColor clearColor];
   
    } else {
        
        view.backgroundColor = [UIColor clearColor];
    }
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[menuData objectAtIndex:section] valueForKey:@"items"]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 3) {
        
        //starRatingCell
        
        StarRatingTableViewCell *starCell;
        
        starCell = [tableView dequeueReusableCellWithIdentifier:@"starRatingCell" forIndexPath:indexPath];
        
        starCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        starCell.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame = starCell.title_lable.frame;
        
        UIStoryboard *storyboard;
        
        UIView *ratingView;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            frame.origin.x = 21;
            
            frame.size.width = 500;
            
             ratingView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width +25, 15, 25*5, 35)];
            
        } else {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            frame.origin.x = 20;
            
            frame.size.width = 200;
            
             ratingView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width-20,frame.origin.y, 25*5, 30)];
        }
        
        starCell.title_lable.frame = frame;
        
        back_StarView = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, ratingView.frame.size.width, ratingView.frame.size.height) numberOfStar:0 starWidth:25];
        
        back_StarView.userInteractionEnabled = NO;
        
        back_StarView.delegate =self;
        
        [ratingView addSubview:back_StarView];
        
        [starCell addSubview:ratingView];
        
        CGFloat rate = [stars floatValue];
        
        star_ratingView = [[RatingView alloc] initWithFrame:CGRectMake(0, 0, (26 * rate) - rate, ratingView.frame.size.height) numberOfStar:rate starWidth:25];
        
        star_ratingView.userInteractionEnabled = NO;
        
        star_ratingView.delegate =self;
        
      //  ratingView.backgroundColor = [UIColor whiteColor];
        
        [ratingView addSubview:star_ratingView];
        
        return starCell;
    
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"DashboardCell" forIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[DashboardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DashboardCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.title_lable.text = [[[[menuData objectAtIndex:indexPath.section] valueForKey:@"items"] objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        cell.image_view.image = [UIImage imageNamed:[[[[menuData objectAtIndex:indexPath.section] valueForKey:@"items"]objectAtIndex:indexPath.row] valueForKey:@"image"]];
        
        CGRect frame = cell.total_numbers.frame;
        
        CGFloat width = frame.size.width;
        
        frame.origin.x = (table_view.frame.size.width - width - 40);
        
        cell.total_numbers.frame = frame;
        
        frame = cell.title_lable.frame;
        
        frame.size.width = (table_view.frame.size.width - width - 70);
        
        cell.title_lable.frame = frame;
        
        cell.total_numbers.layer.cornerRadius = width/2;
        
        cell.total_numbers.layer.masksToBounds = YES;
        
        cell.total_numbers.hidden = YES;
        
    if (indexPath.section == 0) {
        
        if ([[[[NSUserDefaults standardUserDefaults] valueForKey:@"login"] valueForKey:@"ecaHubLogin"] integerValue] == 0) {
    
            if (indexPath.row == 6 || indexPath.row == 7) {
        
                cell.total_numbers.hidden = NO;
                
                if (indexPath.row == 6) {
                    
                    cell.total_numbers.text = myReview;
                    
                }else if (indexPath.row == 7) {
                    
                    cell.total_numbers.text = enroll_count;
                }
            }
        } else {
            
            if (indexPath.row == 6 || indexPath.row == 7 ) {
                
                cell.total_numbers.hidden = NO;
                
                if (indexPath.row == 7) {
                    
                    cell.total_numbers.text = enroll_count;
                    
                }else if(indexPath.row == 6){
                    
                    cell.total_numbers.text = myReview;
                }
            }
        }
    } else if (indexPath.section == 1) {
        
        cell.total_numbers.hidden = NO;
        
        if (indexPath.row == 0) {
            
            cell.total_numbers.hidden = YES;
        }
        
        if (indexPath.row == 1) {
            
            cell.total_numbers.text = total_lists;
            
        } else if (indexPath.row == 2) {
            
            cell.total_numbers.text = posted_whatson_no;
        
        } else if (indexPath.row == 3) {
            
            cell.total_numbers.text = listed_enroll_book;
        }
//         else if (indexPath.row == 1) {
//            
//            cell.total_numbers.text = listed_enroll_book;
//        }
        }
        
      }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    void (^simpleBlock)(void);
    
    simpleBlock = [[[[menuData objectAtIndex:indexPath.section] valueForKey:@"items"]objectAtIndex:indexPath.row] valueForKey:@"action"];
    
    simpleBlock();
}

-(void)tapAddSign:(UIButton *)sender {
    
    if (sender.tag == 4) {
        
    [self performSegueWithIdentifier:@"myFriendsSegue" sender:self];
        
    } else if (sender.tag == 5){
        
      [self performSegueWithIdentifier:@"myRecommendationSegue" sender:self];
        
    } else if(sender.tag ==6){
        
     [self performSegueWithIdentifier:@"myReviewsSegue" sender:self];
        
    } else if (sender.tag == 7){
        
   [self performSegueWithIdentifier:@"MyListingSegue" sender:self];
        
    } else if (sender.tag == 8){
     
    [self performSegueWithIdentifier:@"mywhtsOnSague" sender:self];

    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end

