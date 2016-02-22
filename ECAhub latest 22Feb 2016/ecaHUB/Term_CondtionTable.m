//
//  Term_CondtionTable.m
//  ecaHUB
//
//  Created by promatics on 4/10/15.
//  Copyright (c) 2015 promatics. All rights reserved.
//

#import "Term_CondtionTable.h"

@implementation Term_CondtionTable

@synthesize term_table, data_array;

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self intializer];
    }
    return self;
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self intializer];
    }
    return self;
}

-(void)awakeFromNib{
    
    [self intializer];
    
}

-(void)intializer
{
    CGRect frame = self.closeBtn.frame;
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Ipad" bundle:nil];
        
        frame.size.height = 45.0f;
        
      //  frame.size.width = 250.0f;
        
    } else {
        
        storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        
    }
    
    self.closeBtn.layer.cornerRadius = 5.0f;
    
    frame.origin.y = term_table.frame.origin.y + term_table.frame.size.height;
    
    self.closeBtn.frame = frame;
    
    [term_table reloadData];
}

#pragma mark - UITableView Delegates & Datasourse

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return data_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell_identifier";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.textLabel setNumberOfLines:4];
    
    cell.textLabel.text = [data_array objectAtIndex:indexPath.row];
    
    return cell;
}

- (IBAction)tapCloseBtn:(id)sender {
    
    [self removeFromSuperview];
}
@end
