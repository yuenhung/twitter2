//
//  ProfileViewController.h
//  Twitter
//
//  Created by Vincent Lai on 6/28/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileViewControllerDelegate <NSObject>

@optional
- (void)movePanelRight;

@required
- (void)movePanelToOriginalPosition;
- (void)movePanelToProfilePosition;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic, assign) id<ProfileViewControllerDelegate> delegate;

- (void)logout;
- (void)onCompose;
@property (nonatomic, assign) BOOL showingLeftPanel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end
