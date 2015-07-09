//
//  LeftMenuViewController.m
//  Twitter
//
//  Created by Vincent Lai on 7/4/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "User.h"
#import "TweetsViewController.h"
#import "UIImageView+NSAdditions.h"

@interface LeftMenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    User *currentUser = [User currentUser];
    
    [self.profileImage fadeInImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentUser.profileImageUrl]] placeholderImage:nil];
    
    self.userName.text = currentUser.name;
    self.address.text = [NSString stringWithFormat:@"@%@", currentUser.screenname];
    
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:107./255. green:179./255. blue:255./255. alpha:1];
    
    UIColor *backgroundColor = [UIColor colorWithRed:107./255. green:179./255. blue:255./255. alpha:1];
    self.tableview.backgroundView = [[UIView alloc]initWithFrame:self.tableview.bounds];
    self.tableview.backgroundView.backgroundColor = backgroundColor;
    //[[UITableView appearance] setBackgroundColor:[UIColor redColor]];
    
    //self.tableview.rowHeight = UITableViewAutomaticDimension;
    //self.tableview.estimatedRowHeight = 86;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    /*
    self.navigationItem.title = @"Menu";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:107./255. green:179./255. blue:255./255. alpha:1];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
     */
    
    self.tableData = [@[@"Home Timeline", @"Profile Page", @"Sign Out"] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [[UIColor alloc] initWithRed:107./255. green:179./255. blue:255./255. alpha:1];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = self.tableData[indexPath.row];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            [_delegate movePanelToOriginalPosition];
            break;
        }
        case 1:
        {
            [_delegate movePanelToProfilePosition];
            break;
        }
            
        case 2:
        {
            [User logout];
            break;
        }
    }
    
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
