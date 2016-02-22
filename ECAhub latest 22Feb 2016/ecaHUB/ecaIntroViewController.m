//
//  ecaIntroViewController.m
//  ecaHUB
//
//  Created by promatics on 3/4/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "ecaIntroViewController.h"

@interface ecaIntroViewController ()

@end

@implementation ecaIntroViewController

@synthesize main_view, loginBtn, signUpBtn, scrollView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     //self.navigationController.navigationBar.topItem.title = @"";
    
    loginBtn.layer.cornerRadius = 5.0f;
    
    signUpBtn.layer.cornerRadius = 5.0f;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        CGRect frameRect = main_view.frame;
        
        frameRect.origin.y = self.view.frame.size.height - 100;
        
        main_view.frame = frameRect;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        CGRect frameRect = main_view.frame;
        
        frameRect.origin.y = self.view.frame.size.height - 80;
        
        main_view.frame = frameRect;
    }
        
    scrollView.tag = 1;
    
    scrollView.userInteractionEnabled = NO;
    
    scrollView.autoresizingMask=UIViewAutoresizingNone;
    
    [self setupScrollView:scrollView];
   
    UIPageControl *pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-30, self.view.frame.size.width, 30)];
    
    [pgCtr setTag:12];
    
    pgCtr.numberOfPages=5;
    
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    
    [self.view addSubview:pgCtr];
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
    
}
- (void)setupScrollView:(UIScrollView*)scrMain {
    
    // we have 10 images here.
    // we will add all images into a scrollView & set the appropriate size.
    
    for (int i=1; i<=5; i++) {
        
        // create image
        
        UIStoryboard *storyboard;
        
        UIImage *image;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
            
            image = [UIImage imageNamed:[NSString stringWithFormat:@"img%02i",i]];
            
        } else {
        
            storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
            
            image = [UIImage imageNamed:[NSString stringWithFormat:@"sti%02i",i]];
        }
       
        // create imageView
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*scrMain.frame.size.width, 0, scrMain.frame.size.width + 0.5, scrMain.frame.size.height)];
       
        // set scale to fill
        
        imgV.contentMode=UIViewContentModeScaleAspectFill;
      
        // set image
        
        [imgV setImage:image];
      
        // apply tag to access in future
        
        imgV.tag=i+1;
      
        // add to scrollView
        
        [scrMain addSubview:imgV];
    }
    // set the content size to 10 image width
    [scrMain setContentSize:CGSizeMake(scrMain.frame.size.width*5, scrMain.frame.size.height)];
    // enable timer after each 2 seconds for scrolling.
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

- (void)scrollingTimer {
   
    // access the scroll view with the tag
    UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
   
    // same way, access pagecontroll access
    
    UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:12];
   
    // get the current offset ( which page is being displayed )
   
    CGFloat contentOffset = scrMain.contentOffset.x;
   
    // calculate next page to display
  
    int nextPage = (int)(contentOffset/scrMain.frame.size.width) + 1 ;
   
    // if page is not 10, display it
    
    if( nextPage!=5 )  {
        
        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
      
        pgCtr.currentPage=nextPage;
       
        // else start sliding form 1 :)
    
    }
//    else {
//     
//        [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
//       
//        pgCtr.currentPage=0;
//    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;

    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
