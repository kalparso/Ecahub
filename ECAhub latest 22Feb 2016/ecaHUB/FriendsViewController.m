//
//  FriendsViewController.m
//  ecaHUB
//
//  Created by promatics on 9/17/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCollectionViewCell.h"
#import "WebServiceConnection.h"
#import "Indicator.h"
#import "SendMessageView.h"


@interface FriendsViewController (){
    
    WebServiceConnection *getConn;
    Indicator *indicator;
    NSArray *friendArray;
    FriendsCollectionViewCell *cell;
    
    NSString *emailId;
    
}

@end

@implementation FriendsViewController

@synthesize collection_View,find_inviteFriendsBtn,scroll_view,nodata_lbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    getConn = [WebServiceConnection connectionManager];
    
    indicator = [[Indicator alloc]initWithFrame:self.view.frame];
    
    [collection_View reloadData];
    
    self.nodata_lbl.hidden = YES;
    
    scroll_view.contentSize = CGSizeMake(self.view.frame.size.width,self.collection_View.frame.origin.y + collection_View.frame.size.height+50);
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.find_inviteFriendsBtn.layer.cornerRadius = 7;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        self.find_inviteFriendsBtn.layer.cornerRadius = 5;
        
        
    }
    
    [self fetchData];
   
    // Do any additional setup after loading the view.
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

-(void)fetchData{
    
//    NSDictionary *paramUrl = @{@"member_id":@"9"};
    
    NSDictionary *paramUrl = @{@"member_id":[[[[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"] valueForKey:@"Member"] valueForKey:@"id"]};
    
    
    
    [self.view addSubview:indicator];
    
    [getConn startConnectionWithString:@"friend_list" HttpMethodType:Post_Type HttpBodyType:paramUrl Output:^(NSDictionary *receivedData) {
        
        [indicator removeFromSuperview];
        
        if([getConn responseCode]==1){
            
            NSLog(@"%@",receivedData);
            
            friendArray =[receivedData valueForKey:@"info"];
            
            NSLog(@"%@",friendArray);
            
            [collection_View reloadData];
            
            if (friendArray.count ==0) {
               
                self.nodata_lbl.hidden = NO;
                
                scroll_view.contentSize = CGSizeMake(self.view.frame.size.width,self.nodata_lbl.frame.origin.y + self.nodata_lbl.frame.size.height +300);
                
            }
            
        }
        
        else{
            
            self.nodata_lbl.hidden = NO;
            
            scroll_view.contentSize = CGSizeMake(self.view.frame.size.width,self.nodata_lbl.frame.origin.y + self.nodata_lbl.frame.size.height +300);
            
        }
    }];
    
}

-(void)downloadImageWithString:(NSString *)urlString{
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *reponse,NSData *data, NSError *error) {
        
        if ([data length] > 0) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            cell.image_view.image = image;
        }
    }];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [friendArray count];
}
//FriendsCell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FriendsCell" forIndexPath:indexPath];
    
   // cell.backgroundColor = [UIColor clearColor];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        cell.image_view.layer.cornerRadius = 60;
        
        cell.image_view.layer.masksToBounds = YES;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        cell.image_view.layer.cornerRadius = 50;
        
        cell.image_view.layer.masksToBounds = YES;
        
    }
    
    NSString *imgurl = [[[friendArray objectAtIndex:indexPath.row]valueForKey:@"Member"]valueForKey:@"picture"];
    
    NSString *f_Name = [[[[friendArray objectAtIndex:indexPath.row]valueForKey:@"Member"]valueForKey:@"first_name"]stringByAppendingString:@" "];
    
    NSString *l_Name = [[[friendArray objectAtIndex:indexPath.row]valueForKey:@"Member"]valueForKey:@"last_name"];
    
    imgurl = [imgurl stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceCharacterSet]];
    
    if ([imgurl length] > 1) {
        
        imgurl = [profilePicURL stringByAppendingString:imgurl];
        
        [self downloadImageWithString:imgurl];
        
    } else {
        
        cell.image_view.image = [UIImage imageNamed:@"user_img"];
    }
    
    //emailId =[[[friendArray objectAtIndex:indexPath.row]valueForKey:@"Member"]valueForKey:@"email"];
    
    
    cell.name_Lbl.text = [f_Name stringByAppendingString:l_Name];
    
    [cell.msg_btn addTarget:self action:@selector(tapmsg:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.msg_btn.tag = indexPath.row;
    
    
    return cell;
}

-(void)tapmsg: (UIButton *)sender{
    
    SendMessageView *sendMsgView = [[SendMessageView alloc] init];
    
    emailId =[[[friendArray objectAtIndex:sender.tag]valueForKey:@"Member"]valueForKey:@"email"];
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPad" owner:self options:nil] objectAtIndex:0];
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
        sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SendMessageIPhone" owner:self options:nil] objectAtIndex:0];
    }
    
    sendMsgView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+60);
    
    NSString *f_Name = [[[[friendArray objectAtIndex:sender.tag]valueForKey:@"Member"]valueForKey:@"first_name"]stringByAppendingString:@" "];
    
    NSString *l_Name = [[[friendArray objectAtIndex:sender.tag]valueForKey:@"Member"]valueForKey:@"last_name"];
    
    sendMsgView.to_textField.text =emailId;
    
    sendMsgView.toTextField.hidden = YES;
    
    [sendMsgView.toMsg_btn setTitle:[f_Name stringByAppendingString:l_Name]
                           forState:UIControlStateNormal];
    
    sendMsgView.frame = self.view.frame;
    
    sendMsgView.view_frame = self.view.frame;
    
    sendMsgView.message.backgroundColor = [UIColor whiteColor]
    ;
    
    sendMsgView.message.layer.borderWidth = 1;
    
    sendMsgView.message.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.message.layer.cornerRadius = 5;
    
    sendMsgView.to_textField.layer.borderWidth = 1;
    
    sendMsgView.to_textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.to_textField.layer.cornerRadius = 5;
    
    sendMsgView.subject.layer.borderWidth = 1;
    
    sendMsgView.subject.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    sendMsgView.subject.layer.cornerRadius = 5;
    
    [self.view addSubview:sendMsgView];
    
    
}

- (IBAction)tap_find_inviteFriendsBtn:(id)sender {
    
    [self performSegueWithIdentifier:@"InviteFriend" sender:self];
}
@end
