//
//  LeftMenuViewController.h
//  Twitter
//
//  Created by Vincent Lai on 7/4/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeftMenuViewController;

@protocol LeftMenuViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;
- (void)movePanelToProfilePosition;

@end

@interface LeftMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) NSMutableArray *tableData;

@property (nonatomic, assign) id<LeftMenuViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end
