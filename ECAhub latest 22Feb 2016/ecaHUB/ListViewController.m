//
//  ListViewController.m
//  ecaHUB
//
//  Created by promatics on 3/11/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController (){
    
    BOOL isSelectCat;
    UITableViewCell *cell;
    NSMutableArray *selectRowArray;
}

@end

@implementation ListViewController

@synthesize array_data,delegate,isMultipleSelected,tblView_list,barButton_cancel,barButton_save,selectedData, data_typeArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSelectCat = NO;
    
    selectRowArray = [[NSMutableArray alloc] init];
    
    selectRowArray = [selectedData mutableCopy];
  
    self.navigationItem.leftBarButtonItem = barButton_cancel;
    
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Text_colore"] forBarMetrics:UIBarMetricsDefault];
   
    if (isMultipleSelected) {
        self.navigationItem.rightBarButtonItem = barButton_save;
        tblView_list.editing = YES;
        [tblView_list setAllowsMultipleSelection:YES];
    
    } else {
       
        [tblView_list setAllowsMultipleSelection:NO];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (isMultipleSelected) {
        
        for (NSString *data in selectedData) {
            
            [tblView_list selectRowAtIndexPath:[NSIndexPath indexPathForRow:[array_data indexOfObject:data] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)tappedCancel:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didCancel)]) {
       
        [delegate didCancel];
    }
    
}

- (IBAction)tappedSave:(id)sender {
    
    if ([delegate respondsToSelector:@selector(didSaveItems:indexs:)]) {
        
        [delegate didSaveItems:nil indexs:[tblView_list indexPathsForSelectedRows]];
    }
}

#pragma mark uitableview delegates and datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return data_typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    if ([[[data_typeArray objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Category"]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor lightGrayColor];
        
        NSNumber *cat_index = [[data_typeArray objectAtIndex:indexPath.row] valueForKey:@"categoryIndex"];
        
        cell.textLabel.text =[[[array_data objectAtIndex:[cat_index integerValue]] valueForKey:@"Category"] valueForKey:@"category_name"];

    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"sub_cat" forIndexPath:indexPath];
        
//        cell.textLabel.frame =
        
        NSNumber *cat_index = [[data_typeArray objectAtIndex:indexPath.row] valueForKey:@"categoryIndex"];
        
        NSNumber *sub_catIndex = [[data_typeArray objectAtIndex:indexPath.row] valueForKey:@"subCatIndex"];
        
        cell.textLabel.text =[[[[array_data objectAtIndex:[cat_index integerValue]] valueForKey:@"Subcategory"] objectAtIndex:[sub_catIndex integerValue]] valueForKey:@"subcategory_name"];
    }
    
    for (int i = 0; i < selectRowArray.count; i++) {
        
        if ([cell.textLabel.text isEqualToString:[selectRowArray objectAtIndex:i]]) {
            
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }        
    }
    
    NSNumber *cat_index = [[data_typeArray objectAtIndex:indexPath.row] valueForKey:@"categoryIndex"];
    
    if ([selectRowArray containsObject:[array_data objectAtIndex:[cat_index integerValue]]]) {
       
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        //cell.selected = YES;
        
    } else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        //cell.selected = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[[data_typeArray objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Category"]) {
        
            for (int i= (int)(indexPath.row+1); i<[data_typeArray count]; i++) {
            
                if ([[[data_typeArray objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"SubCategory"] && [[[data_typeArray objectAtIndex:i] valueForKey:@"categoryIndex"] integerValue]==[[[data_typeArray objectAtIndex:indexPath.row] valueForKey:@"categoryIndex"] integerValue]) {
                
                    [tblView_list selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
        }
    
    if (!isMultipleSelected && [delegate respondsToSelector:@selector(didSelectListItem:index:)]) {

        [delegate didSelectListItem:array_data[indexPath.row] index:indexPath.row];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = (UITableViewCell *)[tblView_list cellForRowAtIndexPath:indexPath];
    
    if ([[[data_typeArray objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Category"]) {
        
        for (int i= (int)(indexPath.row+1); i<[data_typeArray count]; i++) {
            
            if ([[[data_typeArray objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"SubCategory"] && [[[data_typeArray objectAtIndex:i] valueForKey:@"categoryIndex"] integerValue]==[[[data_typeArray objectAtIndex:indexPath.row] valueForKey:@"categoryIndex"] integerValue]) {
                
                [tblView_list deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO];
                
                cell = (UITableViewCell *)[tblView_list cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                for (int i = 0; i < selectRowArray.count; i++) {
                    
                    if ([cell.textLabel.text isEqualToString:[selectRowArray objectAtIndex:i]]) {
                        
                        [selectRowArray removeObject:cell.textLabel.text];
                    }
                }
            }
        }
    }else{
                
        [selectRowArray removeObject:cell.textLabel.text];
    }
}

@end
