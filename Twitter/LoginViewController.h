//
//  LoginViewController.h
//  Twitter
//
//  Created by Vincent Lai on 6/27/15.
//  Copyright (c) 2015 Vincent Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (void)loadTweetsViewController;

@property (nonatomic, assign) BOOL profilePage;
-(void)movePanelToOriginalPosition;

@end
